import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readwenderlich/data/data_dependencies_provider.dart';
import 'package:readwenderlich/ui/app_colors.dart';
import 'package:readwenderlich/ui/list/article_list_screen.dart';
import 'package:readwenderlich/ui/list/paged_article_list_view.dart';

void main() {
  runApp(ReadWenderlich());
}

class ReadWenderlich extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w700BitterFont = GoogleFonts.bitter(
      fontWeight: FontWeight.w700,
    );
    return DataDependenciesProvider(
      child: MaterialApp(
        title: 'readwenderlich',
        theme: ThemeData(
          primarySwatch: AppColors.black,
          accentColor: AppColors.green,
          buttonColor: AppColors.green,
          scaffoldBackgroundColor: AppColors.grey,
          backgroundColor: AppColors.grey,
          primaryTextTheme: TextTheme(
            headline6: w700BitterFont,
          ),
          textTheme: TextTheme(
            subtitle1: w700BitterFont.apply(color: AppColors.black),
            headline6: w700BitterFont.apply(color: AppColors.black),
            bodyText2: TextStyle(color: AppColors.black),
          ),
        ),
        home: ArticleListScreen(), //ShimmerScreen(),
      ),
    );
  }
}

class ShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PaginatedListShimmer(),
    );
  }
}
