import 'dart:io';


class imageListData {

  static List<File> imageList = <File>[];

  static addImage(File image){
    imageList.add(image);
  }
  static void removeImage(File image) {
    imageList.remove(image);
  }

}