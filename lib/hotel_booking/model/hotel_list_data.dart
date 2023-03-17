import 'dart:async';

import 'package:kosen_test_trades/hotel_booking/model/popular_filter_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelListData {
  HotelListData({
    this.imagePath = '',
    this.titleTxt = '', //教科名
    this.subTxt = "", //系　コース

    this.term = "", //前期後期
    this.email = '',
    this.datetime = "", //upload 日時
    this.foldaname = '',
    this.grade = '', //年
    this.reviews = 80, //評価数

    required this.imgURLs,

    required this.LikesUsers,
  });

  String imagePath;
  String titleTxt;
  String subTxt;
  String term;
  String email;
  String foldaname;
  String datetime;

  List<dynamic> imgURLs;

  List<dynamic> LikesUsers;
  int reviews;
  String grade;

  static FirebaseFirestore _firestore = FirebaseFirestore.instance;


  static Future<void> FilterList() async{
    filterList = <HotelListData>[];
    for (var data in hotelList) {
      if (data.grade.toString() ==
          PopularFilterListData.selectedList[0].titleTxt &&
          data.subTxt == PopularFilterListData.selectedList[1].titleTxt &&
          data.term == PopularFilterListData.selectedList[2].titleTxt) {
        filterList.add(data);
        print('filter' + data.titleTxt);
      }
    }
  }

  static Future<void> gethotelList() async {
    hotelList = [];
    CollectionReference fileListRef = _firestore.collection('fileList');
    await fileListRef.orderBy("uploadtime", descending: true).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.data());
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        HotelListData hotdata = HotelListData(
            titleTxt: data['titleTxt'],
            imagePath: data['imagePath'],
            subTxt: data['subTxt'],
            //系　コース
            term: data['term'],
            //前期後期
            email: data['email'],
            datetime: data['datatime'],
            //upload 日時
            foldaname: data['foldaneme'],
            grade: data['grade'],
            //年
            reviews: data['review'],
            //評価数
            imgURLs: data['imgURLs'],
            LikesUsers: data['LikesUsers']
        );
        hotelList.add(hotdata);
      });
    });
    print('get');
    print(hotelList);
  }

  static Stream<void> streamdata() async*{
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      querySnapshot.docChanges.forEach((docChange) {
        if (docChange.type == DocumentChangeType.added) {
          // 新しいドキュメントが追加された場合
          print('New document added: ${docChange.doc.data()}');
        } else if (docChange.type == DocumentChangeType.modified) {
          // 既存のドキュメントが更新された場合
          print('Document modified: ${docChange.doc.data()}');
        } else if (docChange.type == DocumentChangeType.removed) {
          // 既存のドキュメントが削除された場合
          print('Document removed: ${docChange.doc.data()}');
        }
      });
    });
  }

  static Stream<void> getHotelListStream() {
    return _firestore.collection('fileList').snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((doc) => HotelListData(
            titleTxt: doc['titleTxt'],
            imagePath: doc['imagePath'],
            subTxt: doc['subTxt'],
            term: doc['term'],
            email: doc['email'],
            datetime: doc['datatime'],
            foldaname: doc['foldaneme'],
            grade: doc['grade'],
            reviews: doc['review'],
            imgURLs: doc['imgURLs'],
            LikesUsers: doc['LikesUsers']
        ))
    );
  }




  static List<HotelListData> hotelList = <HotelListData>[];

  static List<HotelListData> filterList = <HotelListData>[];

  static List<HotelListData> allList = <HotelListData>[];
}


class UserDate {
  static List<dynamic> Likes = [];
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> getLikes(String documentName) async {
    Likes = [];
    final CollectionReference users = _firestore.collection('User');
    await users.doc(documentName).get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        Likes = data['Likes'];
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }



  static void addOrRemoveFromArrayUser(String uid, String item) async {

    print('addOrRemoveFromArrayUser');
    final DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(uid);

    final DocumentSnapshot snapshot = await userDocRef.get();
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    final List<dynamic> dataLikes = data['Likes'] as List<dynamic>;

    if (dataLikes.contains(item)) {
      print('true');
      await userDocRef.update({
        'Likes': FieldValue.arrayRemove([item])
      });
    } else {
      print('false');
      await userDocRef.update({
        'Likes': FieldValue.arrayUnion([item])
      });
    }
  }

  static void addOrRemoveFromArrayfileLise(String uid, String item) async {
    print('addOrRemoveFromArrayfileLise');
    final DocumentReference userDocRef = FirebaseFirestore.instance.collection('fileList').doc(uid);

    final DocumentSnapshot snapshot = await userDocRef.get();
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    final List<dynamic> dataLikes = data['LikesUsers'] as List<dynamic>;

    if (dataLikes.contains(item)) {

      print('true');
      await userDocRef.update({
        'LikesUsers': FieldValue.arrayRemove([item])
      });
    } else {
      print('false');
      await userDocRef.update({
        'LikesUsers': FieldValue.arrayUnion([item])
      });
    }
  }


}