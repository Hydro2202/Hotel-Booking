import 'package:flutter/material.dart';

class PlaceRoomsScreen extends StatelessWidget {
  final String placeName;
  final String imageUrl;

  PlaceRoomsScreen({required this.placeName, required this.imageUrl});

  final List<Map<String, String>> availableRooms = [
    {
      "name": "Standard Room",
      "description": "1 Queen bed • Free Wi-Fi • Air Conditioning",
      "image": "assets/roomSamp.jpg",
    },
    {
      "name": "Deluxe Room",
      "description": "2 Double beds • Sea View • Breakfast included",
      "image": "assets/roomSamp.jpg",
    },
    {
      "name": "Suite",
      "description": "1 King bed • Living Area • Bathtub • Premium View",
      "image": "assets/roomSamp.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeName),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: availableRooms.length,
        itemBuilder: (context, index) {
          final room = availableRooms[index];
          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(room["image"]!, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(room["name"]!, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text(room["description"]!, style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
