import 'package:flutter/material.dart';
import 'package:readwenderlich/data/repository.dart';
import 'package:readwenderlich/entities/article.dart';
import 'package:readwenderlich/ui/exception_indicators/empty_list_indicator.dart';
import 'package:readwenderlich/ui/exception_indicators/error_indicator.dart';
import 'package:readwenderlich/ui/list/article_list_item.dart';
import 'package:readwenderlich/ui/list/article_list_screen.dart';
import 'package:readwenderlich/ui/preferences/list_preferences.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

// 1
class PagedArticleListView extends StatefulWidget {
  final Repository repository;
  final ListPreferences listPreferences;

  const PagedArticleListView({
    // 2
    @required this.repository,
    // 3
    this.listPreferences,
    Key key,
  })  : assert(repository != null),
        super(key: key);

  @override
  _PagedArticleListViewState createState() => _PagedArticleListViewState();
}

class _PagedArticleListViewState extends State<PagedArticleListView> {
  // 4
  ListPreferences get _listPreferences => widget.listPreferences;

  // 1
  final _pagingController = PagingController<int, Article>(
    // 2
    firstPageKey: 1,
  );

  @override
  void initState() {
    // 3
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await widget.repository.getArticleListPage(
        number: pageKey,
        size: 8,
        // 1
        filteredPlatformIds: _listPreferences?.filteredPlatformIds,
        filteredDifficulties: _listPreferences?.filteredDifficulties,
        filteredCategoryIds: _listPreferences?.filteredCategoryIds,
        sortMethod: _listPreferences?.sortMethod,
      );

      final previouslyFetchedItemsCount =
          // 2
          _pagingController.itemList?.length ?? 0;

      final isLastPage = newPage.isLastPage(previouslyFetchedItemsCount);
      final newItems = newPage.itemList;

      if (isLastPage) {
        // 3
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      // 4
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    // 4
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PagedArticleListView oldWidget) {
    if (oldWidget.listPreferences != widget.listPreferences) {
      _pagingController.refresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  // 5
  @override
  Widget build(BuildContext context) =>
      // 1
      RefreshIndicator(
        onRefresh: () => Future.sync(
          // 2
          () => _pagingController.refresh(),
        ),
        // 3
        child: PagedListView.separated(
          // 4
          pagingController: _pagingController,
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
          builderDelegate: PagedChildBuilderDelegate<Article>(
            itemBuilder: (context, article, index) => ArticleListItem(
              article: article,
            ),
            firstPageProgressIndicatorBuilder: (ctx) => PaginatedListShimmer(),
            firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              error: _pagingController.error,
              onTryAgain: () => _pagingController.refresh(),
            ),
            noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),
          ),
        ),
      );
}

class PaginatedListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        child: Container(
          width: double.infinity,
          child: ListView.builder(
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ShimmerContainer.text(
                              height: 40,
                            ),
                            const Padding(padding: EdgeInsets.all(5.0)),
                            ShimmerContainer.text(),
                            const Padding(padding: EdgeInsets.all(2.0)),
                            ShimmerContainer.text(),
                            const Padding(padding: EdgeInsets.all(2.0)),
                            ShimmerContainer.text(),
                            const Padding(padding: EdgeInsets.all(2.0)),
                            ShimmerContainer.text(
                              width: 120.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    ShimmerContainer.image(),
                  ],
                ),
              ),
            ),
            itemCount: 3,
          ),
        ),
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;

  factory ShimmerContainer.text({
    double height = 20,
    double width = double.infinity,
  }) =>
      ShimmerContainer(
        height: height,
        width: width,
      );

  factory ShimmerContainer.image({
    double length = 70,
  }) =>
      ShimmerContainer(
        height: length,
        width: length,
      );

  ShimmerContainer({
    this.height = double.infinity,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.black,
      ),
    );
  }
}
