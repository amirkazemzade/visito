import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visito_new/bloc/store/store_bloc.dart';
import 'package:visito_new/data/models/store_model.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final StoreBloc _bloc = StoreBloc();
  late final StoreModel _store;
  int _selected = 0;
  final FocusNode _sendVisitationFocus = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store = ModalRoute.of(context)!.settings.arguments as StoreModel;
    _bloc.add(StoreLoadEvent(_store.id!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreBloc, StoreState>(
      bloc: _bloc,
      listener: (context, state) {
        if(state is StoreSucceed){

        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_store.name!),
          ),
          floatingActionButton: FloatingActionButton(
            focusNode: _sendVisitationFocus,
            onPressed: () {
              if (state is StoreSucceed) {
                FocusScope.of(context).unfocus();
                _bloc.add(
                  StoreSendVisitationEvent(
                    state.brands,
                    state.products,
                    _store.id!,
                  ),
                );
              }
            },
            child: const Icon(Icons.send),
          ),
          body: Builder(
            builder: (context) {
              if (state is StoreLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is StoreSucceed) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.products.length,
                              itemBuilder: (context, index) {
                                return ProductItem(
                                  name: state.products[index].name!,
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Future.delayed(Duration.zero, () {
                                      setState(() {
                                        _selected = index;
                                      });
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const Divider(height: 20.0),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListView.builder(
                              itemCount: state.brands[_selected].length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return const BrandItemHeader();
                                } else {
                                  var brandWithState =
                                      state.brands[_selected][index - 1];
                                  var brand = brandWithState.brand;
                                  var sendState = brandWithState.state;
                                  return BrandItem(
                                    name: brand.name!,
                                    face: brand.face != null
                                        ? brand.face.toString()
                                        : '',
                                    sku: brand.sku != null
                                        ? brand.sku.toString()
                                        : '',
                                    state: sendState,
                                    onFaceChanged: (face) {
                                      var faceDouble = double.tryParse(face);
                                      if (faceDouble != null &&
                                          brand.face != faceDouble) {
                                        var newBrands = state.brands;
                                        newBrands[_selected][index - 1]
                                            .brand
                                            .face = double.tryParse(face);
                                        // FocusNode focusNode = FocusScope.of(context).focusedChild ?? FocusNode();
                                        _bloc.add(
                                          StoreUpdateEvent(
                                            state.products,
                                            newBrands,
                                          ),
                                        );
                                        // log('its running');
                                        // Future.delayed(Duration.zero, (){
                                        //     FocusScope.of(context).;
                                        // });
                                      }
                                    },
                                    onSkuChanged: (sku) {
                                      var skuDouble = double.tryParse(sku);
                                      if (skuDouble != null &&
                                          brand.sku != skuDouble) {
                                        var newBrands = state.brands;
                                        newBrands[_selected][index - 1]
                                            .brand
                                            .sku = double.tryParse(sku);
                                        _bloc.add(
                                          StoreUpdateEvent(
                                            state.products,
                                            newBrands,
                                          ),
                                        );
                                      }
                                    },
                                    faceError: brandWithState.faceError,
                                    skuError: brandWithState.skuError,
                                  );
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else if (state is StoreFailed) {
                return const Center(child: Text('Something went wrong!'));
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

class ProductItem extends StatefulWidget {
  const ProductItem({Key? key, required this.name, required this.onTap})
      : super(key: key);
  final String name;
  final Function onTap;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onTap();
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(widget.name),
            ],
          ),
        ),
      ),
    );
  }
}

class BrandItemHeader extends StatelessWidget {
  const BrandItemHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Brand',
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'face',
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: Text(
                'sku',
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
            const Icon(
              Icons.error,
              color: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}

class BrandItem extends StatefulWidget {
  const BrandItem({
    Key? key,
    required this.name,
    this.sku = '',
    this.face = '',
    required this.onFaceChanged,
    required this.onSkuChanged,
    this.state = 'normal',
    required this.faceError,
    required this.skuError,
  }) : super(key: key);
  final String name;
  final String sku;
  final String face;
  final Function(String face) onFaceChanged;
  final Function(String sku) onSkuChanged;
  final String state;
  final bool faceError;
  final bool skuError;

  @override
  State<BrandItem> createState() => _BrandItemState();
}

class _BrandItemState extends State<BrandItem> {
  final _faceController = TextEditingController();
  final _skuController = TextEditingController();
  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _faceController.text = widget.face;
    _skuController.text = widget.sku;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(widget.name),
            ),
            Expanded(
                flex: 1,
                child: FocusScope(
                  onFocusChange: (focus) {
                    if (!focus) {
                      widget.onFaceChanged.call(_faceController.text);
                    } else {
                      log('face has focused');
                    }
                  },
                  child: TextFormField(
                    controller: _faceController,
                    onFieldSubmitted: (face) => widget.onFaceChanged.call(face),
                    decoration: InputDecoration(
                      errorText: widget.faceError
                          ? 'required'
                          : widget.skuError
                              ? ''
                              : null,
                      filled: true,
                      fillColor: Colors.blue.shade100,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  ),
                )),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: FocusScope(
                onFocusChange: (focus) {
                  if (!focus) {
                    widget.onSkuChanged.call(_skuController.text);
                  } else {
                    log('sku has focused');
                  }
                },
                child: TextFormField(
                  controller: _skuController,
                  onFieldSubmitted: (sku) => widget.onSkuChanged.call(sku),
                  decoration: InputDecoration(
                    errorText: widget.skuError
                        ? 'required'
                        : widget.faceError
                            ? ''
                            : null,
                    filled: true,
                    fillColor: Colors.blue.shade100,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(4)],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Builder(
              builder: (context) {
                switch (widget.state) {
                  case 'succeed':
                    return const Icon(
                      Icons.done,
                      color: Colors.green,
                    );
                  case 'warning':
                    return const Icon(
                      Icons.warning,
                      color: Colors.orangeAccent,
                    );
                  case 'error':
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                    );
                  default:
                    return const Icon(Icons.error, color: Colors.transparent);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
