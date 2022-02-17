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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store = ModalRoute
        .of(context)!
        .settings
        .arguments as StoreModel;
    _bloc.add(StoreLoadEvent(_store.id!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_store.name!),
      ),
      body: BlocBuilder<StoreBloc, StoreState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is StoreLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StoreSucceed) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery
                      .of(context)
                      .size
                      .height,
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
                                setState(() {
                                  _selected = index;
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          itemCount: state.brands[_selected].length,
                          itemBuilder: (context, index) {
                            return BrandItem(
                              name: state.brands[_selected][index].name!,
                              onFaceChanged: () {
                                log('on face changed has called');
                              },
                              onSkuChanged: () {
                                log('on sku changed has called');
                              },
                            );
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

class BrandItem extends StatefulWidget {
  const BrandItem({
    Key? key,
    required this.name,
    this.sku = '',
    this.face = '',
    required this.onFaceChanged,
    required this.onSkuChanged,
  }) : super(key: key);
  final String name;
  final String sku;
  final String face;
  final Function onFaceChanged;
  final Function onSkuChanged;

  @override
  State<BrandItem> createState() => _BrandItemState();
}

class _BrandItemState extends State<BrandItem> {
  final _faceController = TextEditingController();
  final _skuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _faceController.text = widget.face;
    // _skuController.text = widget.sku;
  }

  @override
  Widget build(BuildContext context) {
    _faceController.text = widget.face;
    _skuController.text = widget.sku;

    _faceController.addListener(() {
      log('add face listener has called');
      widget.onFaceChanged.call();
    });

    _skuController.addListener(() {
      log('add sku listener has called');
      widget.onSkuChanged.call();
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(widget.name)),
            Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _faceController,
                  decoration: InputDecoration(
                      prefixText: 'face ',
                      prefixStyle: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade700,
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade100,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8)),
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(4)],
                )),
            const SizedBox(width: 4),
            Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _skuController,
                  decoration: InputDecoration(
                      prefixText: 'sku ',
                      prefixStyle: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade700,
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade100,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8)),
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(4)],
                )),
          ],
        ),
      ),
    );
  }
}
