import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'hotel_app_theme.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


class ImageSlider extends StatefulWidget {
  final List<dynamic> imgURLs;

  ImageSlider({required this.imgURLs});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: widget.imgURLs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Center(
                        child: InteractiveViewer(
                          boundaryMargin: EdgeInsets.all(20),
                          minScale: 0.1,
                          maxScale: 4.0,
                          child: CachedNetworkImage(
                            imageUrl: widget.imgURLs[index],
                            fit: BoxFit.fitWidth,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                              color:
                                  HotelAppTheme.buildLightTheme().primaryColor,
                              value: downloadProgress.progress,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    setState(
                      () {
                        _currentIndex = index;
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
          Positioned(
            top: 30,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child:IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Colors.white,
                ),
                onPressed: () {
                  // 保存する処理を実装
                  saveImageToDevice(widget.imgURLs[_currentIndex]);
                  // ダイアログを表示
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('保存しました'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

            ),
          ),
        ],
      ),
    );
  }


  Future<void> saveImageToDevice(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;

    final appDirectory = await getTemporaryDirectory();
    final folderName = 'Kosen_trades'; // 独自のフォルダ名を指定します。
    final folderPath = '${appDirectory.path}/$folderName';

    // フォルダが存在しない場合は作成します。
    final folder = Directory(folderPath);
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'image_$timestamp.jpg';
    final filePath = '$folderPath/$fileName'; // 独自のフォルダに保存します。
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    final result = await ImageGallerySaver.saveFile(filePath);
    print(result);
  }


}
