import 'package:flutter/material.dart';

class SuggestedPlace {
  final String name;
  final String imageUrl;

  SuggestedPlace(this.name, this.imageUrl);
}

class SuggestedPlacesSection extends StatelessWidget {
  final List<SuggestedPlace> places = [
    SuggestedPlace("Lucena City", "https://picsum.photos/seed/lucena/400/200"),
    SuggestedPlace("Tayabas", "https://picsum.photos/seed/tayabas/400/200"),
    SuggestedPlace("Pagbilao", "https://picsum.photos/seed/pagbilao/400/200"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            "Suggested Places",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.network(
                        place.imageUrl,
                        width: 250,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: Colors.black54,
                          child: Text(
                            place.name,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
