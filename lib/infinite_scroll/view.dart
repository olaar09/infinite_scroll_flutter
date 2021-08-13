import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_scroll/infinite_scroll/cubit.dart';
import 'package:flutter_infinite_scroll/podo/data_podo.dart';
import 'package:flutter_infinite_scroll/repositories/data_repo.dart';
import 'package:flutter_infinite_scroll/repositories/i_data_repo.dart';
import 'package:flutter_infinite_scroll/util/rest_client.dart';

class InfiniteScrollPage extends StatefulWidget {
  final String dataUrl;
  final int perPage;
  final int debounceMaxPeriod;
  late final Function(DataPODO data)? child;

  InfiniteScrollPage({
    required this.dataUrl,
    this.child,
    this.perPage = 10,
    this.debounceMaxPeriod = 5000,
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
  late InfiniteScrollCubit _bloc;
  ScrollController _scrollController = ScrollController();
  bool showBottomLoading = false;
  bool listenerAdded = false;
  int debounceEnd = 0;
  int debounceStart = 0;
  List<DataPODO> oldData = [];

  @override
  void initState() {
    _dataRepository = DataRepository(restClient: RestClientRepository().init());
    _bloc = InfiniteScrollCubit(_dataRepository);
    _bloc.dispatchFetchEvent(widget.dataUrl);
    super.initState();
  }

  setBottomLoading([loading = false]) {
    this.setState(() {
      showBottomLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildShowBottomLoading(),
      body: BlocConsumer<InfiniteScrollCubit, FetchDataState>(
        bloc: _bloc,
        listener: (context, state) {
          state.join(
            (_) => setBottomLoading(),
            (loaded) {
              oldData = loaded.data;
              onScrollToBottom();
              setBottomLoading();
            },
            (error) => setBottomLoading(),
            (loading) {
              if (loading.isLoadMore) setBottomLoading(true);
            },
          );
        },
        builder: (context, state) {
          return state.join(
            (_) => buildCupertinoActivityIndicator(),
            (loaded) {
              return buildList(loaded.data);
            },
            (error) => Center(child: Text('${error.generic}')),
            (loading) {
              if (loading.oldData == null) {
                return buildCupertinoActivityIndicator();
              } else {
                return buildList(loading.oldData!);
              }
            },
          );
        },
      ),
    );
  }

  Widget buildShowBottomLoading() {
    return showBottomLoading
        ? Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: buildCupertinoActivityIndicator(),
            height: 60,
          )
        : SizedBox(height: 0);
  }

  onScrollToBottom() {
    if (listenerAdded) {
      _scrollController.removeListener(scrollListener);
      _scrollController.addListener(scrollListener);
    } else {
      _scrollController.addListener(scrollListener);
      listenerAdded = true;
    }
  }

  scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        debounceStart = DateTime.now().millisecondsSinceEpoch;
        print('since epoch ${debounceStart - debounceEnd}');
      });

      if ((debounceStart == 0 ||
          debounceStart - debounceEnd > widget.debounceMaxPeriod)) {
        _bloc.dispatchLoadMoreEvent(widget.dataUrl, oldData);

        setState(() {
          debounceEnd = DateTime.now().millisecondsSinceEpoch;
        });
      }
    }
  }

  Widget buildList(List<DataPODO> data) {
    print('display data length ${data.length}');
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
            child: CustomScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    await _bloc.dispatchRefreshEvent(widget.dataUrl, data);
                  },
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (widget.child == null) {
                      return widget.buildWidgetItem(data[index]);
                    } else {
                      return widget.child!(data[index]);
                    }
                  }, childCount: data.length),
                ),
              ],
            ), //ListView.builder(
          ),
        ],
      ),
    );
  }

  Widget buildCupertinoActivityIndicator() =>
      Center(child: CupertinoActivityIndicator(radius: 15));

  @override
  void dispose() {
    _bloc.close();
    _scrollController.dispose();
    super.dispose();
  }
}
