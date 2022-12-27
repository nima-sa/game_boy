import 'package:flutter/material.dart';
import 'package:game_boy/NS_Lib/NSCaptiveText.dart';
import 'package:game_boy/NS_Lib/NSColor.dart';
import 'package:game_boy/NS_Lib/NSLocalizer.dart';
import 'package:game_boy/NS_Lib/NSAppBar.dart';
import 'package:game_boy/NS_Lib/NSMaterializedColors.dart';
import 'package:game_boy/NS_Lib/NSScaffold.dart';

import 'SpyRoleDistributor.dart';

class SpyCategoryScreen extends StatefulWidget {
  @override
  _SpyCategoryScreenState createState() => _SpyCategoryScreenState();
}

class _SpyCategoryScreenState extends State<SpyCategoryScreen> {
  // int selectedCategoryIdx = 0;
  List<int> selectedCategoriesIdxs = [0]; // add the value above.
  int selectedPlayersCount = 3; // players minimum number
  int playersOfset = 2; // minus one. because indexes start from 0 :)
  final Color selectionColor = Colors.amber;
  List<String> subCategories;
  List<String> categories = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NSLocalizer.load('lang/spy'),
      builder: (BuildContext context, AsyncSnapshot<Map<String, String>> ss) {
        final dict = ss.data ?? {};
        if (categories.length == 0 && dict.isNotEmpty) {
          categories = dict.keys
              // .where((e) => !e.contains('del_') && e.contains('cat_'))
              .where((e) => e.substring(0, 4) == 'cat_')
              .toList();
          selectedCategoriesIdxs =
              List.generate(categories.length - 1, (i) => i);
        }

        return NSScaffold(
          darkBackgroundColor:
              NSColor.platform(iOS: Colors.black, android: Colors.grey[850]),
          navBar: NSAppBar(
            title: SizedBox(
              width: 120,
              child: NScaptiveTextNavBar(
                dict['categorySelection'] ?? '',
                lightColor: Colors.black,
              ),
            ),
            iOSDarkItemsColor: Colors.white,
            iOSLightItemsColor: Colors.black,
            backgroundColor: NSColor.dynamic(
              light: Colors.white,
              dark: NSMaterializedColors.black,
            ),
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: _makeSliverLists(dict, categories),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        textColor: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? Colors.grey[300]
                            : Colors.grey[700],
                        padding: EdgeInsets.fromLTRB(
                            8, 8, 8, MediaQuery.of(context).padding.bottom + 8),
                        child: Directionality(
                            textDirection: NSLocalizer.textDirection,
                            child: NSText(NSLocalizer.translate('continue'))),
                        onPressed: () {
                          if (subCategories.length == 0) return;
                          NSScaffold.pushScreen(
                              context,
                              SpyRoleDistributer(
                                  selectedPlayersCount + playersOfset,
                                  subCategories));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget renderTitle(String title, Color color,
      {Color textColor, FontWeight weight}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: color,
            // color: MediaQuery.of(context).platformBrightness == Brightness.light
            // ? Colors.black
            // : Colors.grey[600],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: NSText.inverted(
              title,
              color: textColor ?? Colors.black,
              // lightColor: Colors.white,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17, fontWeight: weight ?? FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _makeTopContainer() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Directionality(
            textDirection: NSLocalizer.textDirection,
            child: NSText(NSLocalizer.translate('players') +
                ': ' +
                NSLocalizer.numsToLng(
                    '${selectedPlayersCount + playersOfset}')),
          ),
          SizedBox(
            height: 47,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 50,
              itemBuilder: (context, idx) => Padding(
                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Container(
                  // height: 45,
                  // width: 45,
                  child: RaisedButton(
                    padding: EdgeInsets.zero,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? (selectedPlayersCount - 1 == idx
                            ? selectionColor
                            : Colors.blueGrey[500])
                        : (selectedPlayersCount - 1 == idx
                            ? selectionColor
                            : Colors.blueGrey[500]),
                    child: SizedBox(
                      width: 120,
                      child: NSText(
                        NSLocalizer.numsToLng('${idx + playersOfset + 1}'),
                        color: selectedPlayersCount - 1 == idx
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    onPressed: () {
                      selectedPlayersCount = idx + 1;
                      setState(() {});
                    },
                  ),
                ),
              ),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _makeSubCategorySlivers(Map<String, String> langDict, String cat) {
  Widget _makeSubCategorySlivers(Map<String, String> langDict) {
    if (langDict == null) return Container();

    List<Widget> holder = [];
    final subCategoryNames = List.generate(selectedCategoriesIdxs.length,
        (i) => this.categories[selectedCategoriesIdxs[i]].split('_').last);
    // final subCategoryName = cat.split('_').last;

    subCategories = langDict.keys
        .where((e) => e.substring(0, 4) == 'sub_')
        // .where((element) => element.contains(subCategoryName == 'all' ? 'sub_' : 'sub_$subCategoryName'))
        .where((e) {
          final catOfSub = e.split('_')[1];
          return subCategoryNames.contains(catOfSub);
        })
        // .where((e) =>
        //     subCategoryName == 'all' ? true : e.contains(subCategoryName))
        .where((e) => categories.contains('cat_${e.split('_')[1]}'))
        .toList();

    // final sth = subCategories.where((e) {
    //   final s = e.split('_')[1];
    //   final a = categories.contains('cat_$s');
    //   return a;
    // }).toList();
    final double width = MediaQuery.of(context).size.width / 2 - 12;

    for (int idx = 0; idx < subCategories.length; idx++) {
      final subCat = subCategories[idx];
      final subCatTitle = langDict[subCat];
      holder.add(
        Padding(
          padding: EdgeInsets.fromLTRB(
              idx % 2 == 0 ? 4 : 2, 0, idx % 2 == 0 ? 2 : 4, 0),
          child: Container(
              child: Center(
                  child: SizedBox(
                width: width,
                child: Directionality(
                  textDirection: NSLocalizer.textDirection,
                  child: NSText(
                    subCatTitle,
                    textDirection: NSLocalizer.textDirection,
                  ),
                ),
              )),
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Colors.grey[500]
                      : Colors.grey[800]),
        ),
      );
    }
    return SliverGrid.count(
      crossAxisSpacing: 0,
      mainAxisSpacing: 4,
      childAspectRatio: (6 / 1),
      crossAxisCount: 2,
      children: holder,
    );
  }

  Widget _makeSliverLists(Map<String, String> dict, List<String> categories) {
    if (dict == null || categories == null || categories.isEmpty)
      return Container();

    List<Widget> holder = [];

    for (int idx = 0; idx < categories.length; idx++) {
      holder.add(
        Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Container(
            child: RaisedButton(
              padding: EdgeInsets.zero,
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? (selectedCategoriesIdxs.contains(idx)
                          // selectedCategoryIdx == idx
                          ? selectionColor
                          : Colors.blueGrey[500])
                      : (selectedCategoriesIdxs.contains(idx)
                          // selectedCategoryIdx == idx
                          ? selectionColor
                          : Colors.blueGrey[500]),
              child: SizedBox(
                width: 120,
                child: NSText.inverted(dict[categories[idx]],
                    color: selectedCategoriesIdxs.contains(idx)
                        // selectedCategoryIdx == idx
                        ? Colors.black
                        : Colors.white),
              ),
              onLongPress: () {
                if (categories[idx] == 'cat_all') return;
                selectedCategoriesIdxs.clear();
                selectedCategoriesIdxs.add(idx);
                setState(() {});
              },
              onPressed: () {
                if (categories[idx] == 'cat_all') {
                  if (selectedCategoriesIdxs.length > 2) {
                    selectedCategoriesIdxs.clear();
                  } else {
                    selectedCategoriesIdxs.clear();
                    selectedCategoriesIdxs = List.generate(
                        categories.length - 1 /* minus 'all' */, (i) => i);
                  }
                } else {
                  if (selectedCategoriesIdxs.contains(idx))
                    selectedCategoriesIdxs.removeWhere((e) => e == idx);
                  else
                    selectedCategoriesIdxs.add(idx);
                }
                setState(() {});
                // selectedCategoryIdx = idx;
              },
            ),
          ),
        ),
      );
    }
    return CustomScrollView(
      slivers: [
        _makeTopContainer(),
        SliverGrid.count(
          childAspectRatio: (2 / 1),
          crossAxisCount: 4,
          children: holder,
        ),
        renderTitle(NSLocalizer.translate('titles'), selectionColor),
        // _makeSubCategorySlivers(dict, categories[selectedCategoryIdx]),
        _makeSubCategorySlivers(dict),
      ],
    );
  }

  // void repKey(String key) {}
}
