import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kosen_test_trades/hotel_booking/hotel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'model/hotel_list_data.dart';

class HotelListView extends StatelessWidget {
  HotelListView({
    Key? key,
    this.hotelData,
    this.Email,
    this.animationController,
    this.animation,
    this.callback,
    this.reload,
  }) : super(key: key);

  final VoidCallback? callback;

  final VoidCallback? reload;
  final String? Email;
  final HotelListData? hotelData;
  final AnimationController? animationController;
  final Animation<double>? animation;

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> deleteDocument(String docId) async {
    await _firestore
        .collection('fileList')
        .doc(docId)
        .delete()
        .catchError((error) => print("Failed to delete document: $error"));
  }

// Storageからフォルダを削除する関数
  Future<void> deleteFolder(String folderName) async {
    try {
      final ListResult result = await _storage.ref().child('filedata').child(folderName).listAll();
      final List<Reference> allFiles = result.items;

      await Future.wait(allFiles.map((file) => file.delete()));
      await _storage.ref().child(folderName).delete();
    } catch (error) {
      print('Failed to delete folder: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: callback,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: CachedNetworkImage(
                                imageUrl: hotelData!.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: HotelAppTheme.buildLightTheme()
                                  .colorScheme
                                  .background,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    hotelData!.titleTxt,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {

                                                    if(hotelData!.email == auth.currentUser!.email){

                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return SafeArea(
                                                            child: Container(
                                                              height: 100.0,
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(10.0),
                                                                  topRight: Radius.circular(10.0),
                                                                ),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 5.0),
                                                                  Container(
                                                                    height: 5.0,
                                                                    width: 80.0,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.grey[300],
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10.0),
                                                                  Expanded(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Expanded(
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        title: Text('ファイルを削除しますか？'),
                                                                                        actions: [
                                                                                          TextButton(
                                                                                            child: Text('キャンセル'),
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                          ),
                                                                                          TextButton(
                                                                                            child: Text('削除'),
                                                                                            onPressed: () {
                                                                                              // ファイルを削除する処理
                                                                                              print(hotelData!.foldaname);
                                                                                              deleteDocument(hotelData!.foldaname);
                                                                                              deleteFolder(hotelData!.foldaname);
                                                                                              Navigator.pop(context);
                                                                                              reload;
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(width: 16.0),
                                                                                    Icon(Icons.delete_forever_outlined,size: 26, color: Colors.grey
                                                                                    ),
                                                                                    SizedBox(width: 8.0),
                                                                                    Text('ファイルを削除',style: TextStyle(fontSize: 22),),
                                                                                    SizedBox(width: 8.0),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }else{
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext
                                                        context) {
                                                          return Container(
                                                            height: 200.0,
                                                            child: Center(
                                                              child: Text(
                                                                  'このファイルの操作はできません'),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }

                                                  },
                                                  icon: Icon(Icons.more_vert),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  hotelData!.subTxt,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey
                                                          .withOpacity(0.8)),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Icon(
                                                  Icons.label,
                                                  size: 12,
                                                  color: HotelAppTheme
                                                          .buildLightTheme()
                                                      .primaryColor,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${hotelData!.grade.toString()}年 ${hotelData!.term.toString()}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey
                                                            .withOpacity(0.8)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Row(
                                                children: <Widget>[
                                                  FavoriteButton(
                                                    iconSize: 30,
                                                    isFavorite: (UserDate.Likes
                                                        .contains(hotelData!
                                                            .foldaname)),
                                                    valueChanged:
                                                        (_isFavorite) async {
                                                      UserDate
                                                          .addOrRemoveFromArrayfileLise(
                                                              hotelData!
                                                                  .foldaname,
                                                              Email!);
                                                      UserDate
                                                          .addOrRemoveFromArrayUser(
                                                              Email!,
                                                              hotelData!
                                                                  .foldaname);

                                                      print(
                                                          'Is Favorite : $_isFavorite');
                                                    },
                                                  ),
                                                  Text(
                                                    ' ${hotelData!.LikesUsers.length} Favorite',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey
                                                            .withOpacity(0.8)),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Align(
                                                    child: Text(
                                                      'Upload ${hotelData!.datetime} ',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.8)),
                                                    ),
                                                    alignment:
                                                        Alignment.centerRight,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
