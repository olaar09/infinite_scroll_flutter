import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_scroll/infinite_scroll/bloc.dart';
import 'package:flutter_infinite_scroll/podo/data_podo.dart';
import 'package:flutter_infinite_scroll/repositories/data_repo.dart';
import 'package:flutter_infinite_scroll/repositories/i_data_repo.dart';
import 'package:flutter_infinite_scroll/util/rest_client.dart';

class InfiniteScrollPage extends StatefulWidget {
  final String dataUrl;
  final int perPage;
  late final Function(DataPODO data)? child;

  InfiniteScrollPage({
    required this.dataUrl,
    this.child,
    this.perPage = 10,
  });

  Container buildWidgetItem(DataPODO data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          ListTile(
            title: Text('${data.title}'),
            leading: CircleAvatar(
              child: Icon(
                Icons.file_copy,
                color: Colors.blue,
              ),
              backgroundColor: Colors.white,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  _InfiniteScrollPageState createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  late IDataRepository _dataRepository;
  late InfiniteScrollBloc _bloc;

  @override
  void initState() {
    _dataRepository = DataRepository(restClient: RestClientRepository().init());
    _bloc = InfiniteScrollBloc(_dataRepository);
    _bloc.dispatchFetchEvent(widget.dataUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<InfiniteScrollBloc, FetchDataState>(
        bloc: _bloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return state.join(
            (_) => buildCupertinoActivityIndicator(),
            (loaded) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: loaded.data.length,
                        itemBuilder: (context, index) {
                          if (widget.child == null) {
                            return widget.buildWidgetItem(loaded.data[index]);
                          } else {
                            return widget.child!(loaded.data[index]);
                          }
                          // return buildWidgetItem(data[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            (error) => Center(child: Text('${error.generic}')),
            (loading) => buildCupertinoActivityIndicator(),
          );
        },
      ),
    );
  }

  Widget buildCupertinoActivityIndicator() =>
      Center(child: CupertinoActivityIndicator(radius: 15));

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
