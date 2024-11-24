import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalBrandScroller extends StatelessWidget {
  const HorizontalBrandScroller({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('settings')
          .doc('brand') // Replace with your document ID if different
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading brands."));
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text("No brands available."));
        }

        // Extract the array of brand maps
        final brands = snapshot.data!.data()!['brands'] as List<dynamic>;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: brands.map((brandData) {
              final brand = brandData as Map<String, dynamic>;
              final brandName =
                  brand['brandName'] as String? ?? "Unknown Brand";
              final imageUrl = brand['brandImage'] as String? ?? "";

              return _buildBrandItem(context, brandName, imageUrl);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildBrandItem(
      BuildContext context, String brandName, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/products', arguments: {'brandName': brandName});
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 50,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  )
                : const Icon(Icons.image_not_supported),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
