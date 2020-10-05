import 'package:flutter/material.dart';
import 'package:yuyan_app/models/widgets_small/toast.dart';
import 'package:yuyan_app/views/explore_page/search/search_result/result_page.dart';
import 'package:yuyan_app/views/explore_page/search/view/suggest_list.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  int pageIndex = 0;

  // 重写叉叉
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          print(query);
          if (query.length > 0 && query != null) {
            query = "";
          } else {
            close(context, "");
          }
        },
      )
    ];
  }

  //重写返回图标
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      //关闭上下文，当前页面
      onPressed: () => close(context, null),
    );
  }

  // 重写搜索结果
  @override
  Widget buildResults(BuildContext context, {bool aboutMe: false}) {
    if (query == "") {
      return suggestList(context, query: query, onTap: goSearch);
    } else {
      return SearchResultPage(
        text: query,
        aboutMe: aboutMe,
        pageIndex: pageIndex,
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return suggestList(context, query: query, onTap: goSearch);
  }

  goSearch(BuildContext context, {String text, int index: 0}) {
    if (text == "") {
      myToast(context, "🔍找点什么呢❓");
      return null;
    } else {
      pageIndex = index;
      showResults(context);
    }
  }
}
