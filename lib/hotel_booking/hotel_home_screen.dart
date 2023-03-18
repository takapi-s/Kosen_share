import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kosen_test_trades/hotel_booking/ImageTapSlide.dart';
import 'package:kosen_test_trades/hotel_booking/MylistScreen.dart';
import 'package:kosen_test_trades/hotel_booking/add_paper_screen.dart';
import 'package:kosen_test_trades/hotel_booking/calendar_popup_view.dart';
import 'package:kosen_test_trades/hotel_booking/favoritesScreen.dart';
import 'package:kosen_test_trades/hotel_booking/hotel_list_view.dart';
import 'package:kosen_test_trades/hotel_booking/model/hotel_list_data.dart';
import 'package:flutter/material.dart';
import 'package:kosen_test_trades/hotel_booking/settingScreen.dart';
import '../main.dart';
import 'filters_screen.dart';
import 'hotel_app_theme.dart';
import 'model/popular_filter_list.dart';

class HotelHomeScreen extends StatefulWidget {
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<HotelListData> hotelList = HotelListData.hotelList;
  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  String searchText = ''; // 新しい変数を追加
  List<HotelListData> filteredList = []; //
  List<HotelListData> filteredList_se = []; // 新しいリストを追加

  List<PopularFilterListData> selectedList = []; // 新しいリストを追加
  String Txt = '';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String Email = '';
  String? displayname = '';

  Future<void>? _loadDataStream;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    selectedList = PopularFilterListData.selectedList;
    filteredList_se = [];
    getUserEmail();

    super.initState();
    _loadDataStream = loadData();
  }

  Future<void> loadData() async {
    HotelListData.streamdata();
    User? user = auth.currentUser;
    Email = user!.email!;
    print(Email);
    await HotelListData.gethotelList();
    await UserDate.getLikes(Email);

    await HotelListData.FilterList();
    filteredList = HotelListData.filterList;
    filteredList_se =
        filteredList.where((hotel) => hotel.titleTxt.contains(Txt)).toList();
    print('load');
    print(filteredList_se);
    print('Likes');
    print(UserDate.Likes);
  }

  Future<void> refresh() async {
    _loadDataStream = loadData();
    setState(() {});
  }

  Future<void> getUserEmail() async {
    User? user = auth.currentUser;
    displayname = user?.displayName!;
  }

  Future<void> _handleSignOut() async {
    await auth.signOut();
    setState(() {
      App.login = false;
      App.user = null;
    });
    await Future.delayed(Duration(seconds: 1));
  }


  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          key: scaffoldKey,
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    getAppBarUI(),
                                  ],
                                );
                              }, childCount: 1),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    getSearchBarUI(),
                                  ],
                                );
                              }, childCount: 1),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: ContestTabHeader(
                                getFilterBarUI(),
                              ),
                            ),
                          ];
                        },
                        body: FutureBuilder<void>(
                          future: _loadDataStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              return Container(
                                color: HotelAppTheme.buildLightTheme()
                                    .colorScheme
                                    .background,
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    // リフレッシュ時に実行する処理
                                    // 例えば、データを再取得するなど
                                    await refresh();
                                  },
                                  child: ListView.builder(
                                    itemCount: filteredList_se.length,
                                    padding: const EdgeInsets.only(top: 8),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final int count =
                                          filteredList_se.length > 10
                                              ? 10
                                              : filteredList_se.length;
                                      final Animation<double> animation =
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                                  parent: animationController!,
                                                  curve: Interval(
                                                      (1 / count) * index, 1.0,
                                                      curve: Curves
                                                          .fastOutSlowIn)));
                                      animationController?.forward();
                                      return HotelListView(
                                        callback: () {
                                          print('select:' +
                                              filteredList_se[index].foldaname);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ImageSlider(
                                                imgURLs: filteredList_se[index]
                                                    .imgURLs,
                                              ),
                                            ),
                                          );
                                        },
                                        hotelData: filteredList_se[index],
                                        Email: Email,
                                        animation: animation,
                                        animationController:
                                            animationController!,
                                        reload: () async {
                                          await refresh();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color:
                          HotelAppTheme.buildLightTheme().colorScheme.background,
                        ),
                        child: Text(
                          displayname!,
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.list_alt),
                        title: Text('MyList'),
                        onTap: () {

                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => MyListScreen()));
                          // Drawer内のメニュー項目がタップされたときの処理を実装する
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.favorite_border),
                        title: Text('Favorites'),
                        onTap: () {

                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => FavoriteScreen()));
                          // Drawer内のメニュー項目がタップされたときの処理を実装する
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text('Share'),
                        onTap: () {
                          // Drawer内のメニュー項目がタップされたときの処理を実装する
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: Text("privacy policy"),
                  onTap: () {

                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SettingScreenPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout_outlined),
                  title: Text("Logout"),
                  onTap: () {

                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("ログアウトしますか？"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("キャンセル",style: TextStyle(color: HotelAppTheme.buildLightTheme()
                                  .primaryColor),),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("ログアウト",style: TextStyle(color: HotelAppTheme.buildLightTheme()
                                  .primaryColor)),
                              onPressed: () {
                                _handleSignOut();

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => App()),
                                );
                                },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),

          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddScreen(),
                          fullscreenDialog: true))
                  .then((value) {
                refresh();
              });
            },
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().colorScheme.background,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (txt) {
                      setState(() {
                        Txt = txt;
                        filteredList_se = filteredList
                            .where((hotel) => hotel.titleTxt.contains(Txt))
                            .toList();
                        print('filting');
                        print(filteredList_se);
                      });
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '検索',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().colorScheme.background,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HotelAppTheme.buildLightTheme().colorScheme.background,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      filteredList_se.length.toString() + ' found',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        selectedList[0].titleTxt + '年',
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        selectedList[1].titleTxt,
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        selectedList[2].titleTxt,
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => FiltersScreen(),
                            fullscreenDialog: true),
                      ).then((value) {
                        // 画面遷移先から戻ってきたときに実行される処理
                        setState(() {
                          filteredList = HotelListData.filterList;
                          print('Txt:' + Txt);
                          filteredList_se = filteredList
                              .where((hotel) => hotel.titleTxt.contains(Txt))
                              .toList();
                          selectedList = PopularFilterListData.selectedList;
                        });
                      }); // ここで閉じカッコを追加
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort,
                                color: HotelAppTheme.buildLightTheme()
                                    .primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().colorScheme.background,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ), // 左側に寄せたいウィジェットを追加
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'HOME',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
            ],
          )),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );

  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
