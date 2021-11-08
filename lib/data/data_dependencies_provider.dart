
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:readwenderlich/data/repository.dart';
import 'package:readwenderlich/data/stores/in_memory_store.dart';
import 'package:readwenderlich/data/stores/remote/remote_store.dart';

/// Provider for all data layer dependencies.
class DataDependenciesProvider extends SingleChildStatelessWidget {
  const DataDependenciesProvider({
    Widget child,
    Key key,
  }) : super(
          child: child,
          key: key,
        );

  @override
  Widget buildWithChild(
    BuildContext context,
    Widget child,
  ) =>
      MultiProvider(
        providers: [
          _DioProvider(),
          _RemoteStoreProvider(),
          _InMemoryStoreProvider(),
          _RepositoryProvider(),
        ],
        child: child,
      );
}

class _DioProvider extends SingleChildStatelessWidget {
  @override
  Widget buildWithChild(
    BuildContext context,
    Widget child,
  ) {
    final configuration = BaseOptions(
      baseUrl: 'https://www.raywenderlich.com/api/',
    );

    return Provider<Dio>(
      create: (_) => Dio(
        configuration,
      ),
      child: child,
    );
  }
}

class _RemoteStoreProvider extends SingleChildStatelessWidget {
  @override
  Widget buildWithChild(
    BuildContext context,
    Widget child,
  ) =>
      ProxyProvider<Dio, RemoteStore>(
        update: (_, dio, __) => RemoteStore(
          dio: dio,
        ),
        child: child,
      );
}

class _InMemoryStoreProvider extends SingleChildStatelessWidget {
  @override
  Widget buildWithChild(
    BuildContext context,
    Widget child,
  ) =>
      Provider<InMemoryStore>(
        create: (_) => InMemoryStore(),
        child: child,
      );
}

class _RepositoryProvider extends SingleChildStatelessWidget {
  @override
  Widget buildWithChild(
    BuildContext context,
    Widget child,
  ) =>
      ProxyProvider2<RemoteStore, InMemoryStore, Repository>(
        update: (_, remoteApi, inMemoryStorage, __) => Repository(
          remoteStore: remoteApi,
          inMemoryStore: inMemoryStorage,
        ),
        child: child,
      );
}
