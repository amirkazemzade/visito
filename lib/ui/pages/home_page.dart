import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visito_new/bloc/home/home_bloc.dart';
import 'package:visito_new/data/models/store_model.dart';
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

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
    log('didChangeDependencies');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visito'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: StoresSearchDelegate([
                  StoreModel(id: 1, name: 'first', address: 'first address'),
                  StoreModel(id: 2, name: 'second', address: 'second address'),
                  StoreModel(id: 3, name: 'third', address: 'third address'),
                  StoreModel(id: 4, name: 'fourth', address: 'fourth address'),
                ]),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
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
              child: ListView.builder(
                itemCount: state.stores.length,
                itemBuilder: (context, index) {
                  var store = state.stores[index];
                  return StoreItemWidget(
                    storeName: store.name!,
                    storeAddress: store.address!,
                    onTap: () {
                      _bloc.add(HomeOnNavigateToStore(store));
                    },
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: const SizedBox(height: 40.0),
        color: Theme.of(context).colorScheme.background,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class StoresSearchDelegate extends SearchDelegate {
  final List<StoreModel> stores;

  StoresSearchDelegate(this.stores);

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
    List<String> matchQuery = [];
    for (var store in stores) {
      if (store.name?.toLowerCase().contains(query.toLowerCase()) ?? false) {
        matchQuery.add(store.name!);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(matchQuery[index]),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var store in stores) {
      if (store.name?.toLowerCase().contains(query.toLowerCase()) ?? false) {
        matchQuery.add(store.name!);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(matchQuery[index]),
      ),
    );
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
