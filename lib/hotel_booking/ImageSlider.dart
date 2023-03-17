import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosen_test_trades/hotel_booking/model/Image_list.dart';

import 'hotel_app_theme.dart';



class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<String> _imagePaths = [];

  // 画像を追加するための関数
  Future<void> _addImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePaths.add(pickedFile.path);
        imageListData.addImage(File(pickedFile.path));
      });
    }

    print(imageListData.imageList);
  }


  // 画像を削除するための関数
  void _removeImage(int index) {
    setState(() {
      if (index != null && index >= 0 && index < _imagePaths.length) {

        imageListData.removeImage(File(_imagePaths[index]));
        _imagePaths.removeAt(index);
      }
    });
    print(imageListData.imageList);
  }
  @override
  void initState() {
    imageListData.imageList = [];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0, // ウィジェットの高さを指定
      child: _imagePaths.isNotEmpty
          ? ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imagePaths.length + 2, // カメラアイコンとファイルアイコンも含めるため +2
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: ElevatedButton(
                  onPressed: () => _addImage(ImageSource.camera),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: HotelAppTheme
                          .buildLightTheme()
                          .primaryColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                        color:
                        HotelAppTheme
                            .buildLightTheme()
                            .primaryColor,
                        Icons.camera_alt_outlined),
                  ),
                ),
              ),
            );
          } else if (index == 1) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: ElevatedButton(
                  onPressed: () => _addImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: HotelAppTheme
                          .buildLightTheme()
                          .primaryColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                        color:
                        HotelAppTheme
                            .buildLightTheme()
                            .primaryColor,
                        Icons.folder_outlined),
                  ),
                ),
              ),
            );
          } else {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.file(
                    File(_imagePaths[index - 2]), // カメラアイコンとファイルアイコンの分を引く
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5.0,
                  right: 5.0,
                  child: GestureDetector(
                    onTap: () => _removeImage(index - 2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      )
          : Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: SizedBox(
              width: 100.0,
              height: 100.0,
              child: ElevatedButton(
                onPressed: () => _addImage(ImageSource.camera),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: HotelAppTheme
                        .buildLightTheme()
                        .primaryColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Center(
                  child: Icon(
                      color: HotelAppTheme
                          .buildLightTheme()
                          .primaryColor,
                      Icons.camera_alt_outlined),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: SizedBox(
              width: 100.0,
              height: 100.0,
              child: ElevatedButton(
                onPressed: () => _addImage(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: HotelAppTheme
                        .buildLightTheme()
                        .primaryColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Center(
                  child: Icon(
                      color: HotelAppTheme
                          .buildLightTheme()
                          .primaryColor,
                      Icons.folder_outlined),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
