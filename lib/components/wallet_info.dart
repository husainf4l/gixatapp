import 'package:flutter/material.dart';

class WalletInfoWidget extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final double availablePoints;

  const WalletInfoWidget(
      {super.key, this.userData, required this.availablePoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "النقاط المتوفرة:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                "$availablePoints نقطة",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              Text(
                "= ${availablePoints / 10} دينار",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "معلومات المحفظة",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "اسم المحفظة: ${userData?['wallet']?['name'] ?? 'غير متوفر'}",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "رقم المحفظة: ${userData?['wallet']?['number'] ?? 'غير متوفر'}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
