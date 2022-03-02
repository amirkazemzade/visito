import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visito_new/bloc/home/home_bloc.dart';
import 'package:visito_new/data/models/store.dart';
import 'package:visito_new/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final HomeBloc _bloc = HomeBloc();

  Future<void> _refresh() async {
    _bloc.add(HomeLoadStores());
    return;
  }

  void onStoreTap(Store store) {
    _bloc.add(HomeOnNavigateToStore(store));
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _bloc.add(HomeLoadStores());
  }

  @override
  Widget build(BuildContext context) {
    _bloc.add(HomeLoadStores());
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is HomeNavigateToStore) {
          Navigator.pushNamed(
            context,
            '/store',
            arguments: state.store,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Visito'),
            actions: [
              IconButton(
                onPressed: () {
                  if (state is HomeSucceed) {
                    showSearch(
                      context: context,
                      delegate: StoresSearchDelegate(
                        stores: state.stores,
                        onStoreTap: (store) => onStoreTap(store),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HomeFailed) {
                return const Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red),
                );
              } else if (state is HomeSucceed) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: StoresListView(
                    stores: state.stores,
                    onStoreTap: onStoreTap,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }
}

class StoresListView extends StatelessWidget {
  final List<Store> stores;
  final Function(Store store) onStoreTap;

  const StoresListView(
      {Key? key, required this.stores, required this.onStoreTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index) {
        var store = stores[index];
        return StoreItemWidget(
          storeName: store.name!,
          storeAddress: store.address!,
          onTap: () => onStoreTap(store),
        );
      },
    );
  }
}

class StoresSearchDelegate extends SearchDelegate {
  final List<Store> stores;
  final void Function(Store store) onStoreTap;

  StoresSearchDelegate({required this.stores, required this.onStoreTap});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Store> matchQuery = [];
    for (var store in stores) {
      if (store.name?.toLowerCase().contains(query.toLowerCase()) ?? false) {
        matchQuery.add(store);
      }
    }
    return StoresListView(stores: matchQuery, onStoreTap: onStoreTap);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Store> matchQuery = [];
    for (var store in stores) {
      if (store.name?.toLowerCase().contains(query.toLowerCase()) ?? false) {
        matchQuery.add(store);
      }
    }
    return StoresListView(stores: matchQuery, onStoreTap: onStoreTap);
  }
}

class StoreItemWidget extends StatefulWidget {
  const StoreItemWidget(
      {Key? key,
      required this.storeName,
      required this.storeAddress,
      required this.onTap})
      : super(key: key);
  final String storeName;
  final String storeAddress;
  final Function onTap;

  @override
  State<StoreItemWidget> createState() => _StoreItemWidgetState();
}

class _StoreItemWidgetState extends State<StoreItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () => widget.onTap.call(),
        child: Card(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.storeName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.storeAddress,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }
}
