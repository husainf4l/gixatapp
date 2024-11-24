import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

class DestinationPage extends StatelessWidget {
  const DestinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Extracting arguments passed through navigation
    final Map<String, dynamic> arguments = Get.arguments;
    final String pageTitle = arguments['pageTitle'];
    final String boldHeader = arguments['boldHeader'];
    final String bodyText = arguments['bodyText'];
    final List imageList = arguments['imageList'];

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle), // Displaying the pageTitle in the AppBar
      ),
      body: SingleChildScrollView(
        // Using SingleChildScrollView for content that might exceed screen height
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (boldHeader
                    .isNotEmpty) // Checking if boldHeader is not empty
                  Text(
                    boldHeader,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 8),
                Text(
                  bodyText,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                // Displaying the images
                if (imageList.isNotEmpty)
                  Column(
                    children: imageList.map((image) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
