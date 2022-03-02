import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        onPressed: () {},
        child: const Icon(Icons.share),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
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
            List<VisitationAndModels> visitationList = state.visitationList;
            return ListView.builder(
              itemCount: visitationList.length,
              itemBuilder: (context, index) {
                VisitationAndModels visitation = visitationList[index];
                return VisitationCard(visitation: visitation);
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
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

