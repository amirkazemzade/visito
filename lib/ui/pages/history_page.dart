import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Column, Alignment, Row, Stack;
import 'package:visito_new/bloc/history/history_bloc.dart';
import 'package:visito_new/data/models/visitation_and_models.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryBloc _bloc = HistoryBloc();

  @override
  void initState() {
    _bloc.add(HistoryLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('History'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_list_alt),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (state is HistorySucceed) {
                exportAsExcel(state.visitationList);
              }
            },
            child: const Icon(Icons.share),
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: Stack(
              children: [
                ListView(),
                Builder(
                  builder: (context) {
                    if (state is HistoryLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is HistoryFailed) {
                      return const Center(
                        child: Text(
                          'Something went wrong!',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      );
                    } else if (state is HistorySucceed) {
                      List<VisitationAndModels> visitationList =
                          state.visitationList;
                      return ListView.builder(
                        itemCount: visitationList.length,
                        itemBuilder: (context, index) {
                          VisitationAndModels visitation =
                              visitationList[index];
                          return VisitationCard(visitation: visitation);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _refresh() async {
    _bloc.add(HistoryLoadEvent());
    return;
  }

  void exportAsExcel(List<VisitationAndModels> visitations) async {
    File file = await createExcel(visitations);
    Share.shareFiles([file.path]);
  }

  Future<File> createExcel(List<VisitationAndModels> visitations) async {
    Workbook workbook = Workbook();
    Worksheet worksheet = workbook.worksheets[0];
    for (int i = 1; i < 6; i++) {
      worksheet.insertColumn(i);
    }
    for (int i = 0; i < visitations.length; i++) {
      worksheet.insertRow(i+1);
      var visitation = visitations[i];
      worksheet.getRangeByIndex(i+1, 1).setText('${visitation.brand.name}');
      worksheet.getRangeByIndex(i+1, 2).setText('${visitation.visitation.face}');
      worksheet.getRangeByIndex(i+1, 3).setText('${visitation.visitation.sku}');
      worksheet.getRangeByIndex(i+1, 4).setText('${visitation.store.name}');
      worksheet.getRangeByIndex(i+1, 5).setText('${visitation.store.address}');
      worksheet.getRangeByIndex(i+1, 6).setText('${visitation.visitation.date}');
    }
    for (int i = 1; i < 6; i++) {
      worksheet.autoFitColumn(i);
    }
    List<int> bytes = workbook.saveAsStream();
    var dir = Directory.systemTemp.createTempSync();
    File excelFile = File('${dir.path}/visitation.xlsx');
    excelFile.createSync();
    excelFile.writeAsBytes(bytes);
    workbook.dispose();
    return excelFile;
  }
}

class VisitationCard extends StatefulWidget {
  final VisitationAndModels visitation;

  const VisitationCard({Key? key, required this.visitation}) : super(key: key);

  @override
  State<VisitationCard> createState() => _VisitationCardState();
}

class _VisitationCardState extends State<VisitationCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('store: ${widget.visitation.store.name}'),
                  const SizedBox(width: 4),
                  Text('date: ${widget.visitation.visitation.date}')
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('brand: ${widget.visitation.brand.name}'),
                  const SizedBox(width: 4),
                  Text('face: ${widget.visitation.visitation.face}'),
                  const SizedBox(width: 4),
                  Text('sku: ${widget.visitation.visitation.sku}'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
