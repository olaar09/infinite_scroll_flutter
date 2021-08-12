part of 'bloc.dart';

class FetchDataState extends Union4Impl<_Initial, _Loaded, _Error, _Loading> {
  // PRIVATE low-level factory
  // Used for instantiating individual "subclasses"
  static final Quartet<_Initial, _Loaded, _Error, _Loading> _factory =
      const Quartet<_Initial, _Loaded, _Error, _Loading>();

  // PRIVATE constructor which takes in the individual weather states
  FetchDataState._(Union4<_Initial, _Loaded, _Error, _Loading> union)
      : super(union);

  factory FetchDataState.initial() =>
      FetchDataState._(_factory.first(_Initial()));

  factory FetchDataState.loaded(List data) =>
      FetchDataState._(_factory.second(_Loaded(data: data)));

  factory FetchDataState.error({generic = ''}) =>
      FetchDataState._(_factory.third(_Error(generic: generic)));

  factory FetchDataState.loading() =>
      FetchDataState._(_factory.fourth(_Loading()));
}

class _Initial extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class _Loading extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class _Loaded extends Equatable {
  final List data;

  _Loaded({required this.data});

  @override
  // TODO: implement props
  List<Object> get props => [data];
}

class _Error extends Equatable {
  final String generic;

  _Error({required this.generic});

  @override
  // TODO: implement props
  List<Object> get props => [generic];
}
