import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'place_rooms_screen.dart';
import '../models/booking.dart';
import 'booking_detail_screen.dart';
import '../models/message.dart';
import 'messages_screen.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required String userName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHotelSelected = true;
  int _selectedIndex = 0;

  final List<Booking> bookings = [
    Booking("Ascott", "Bonifacio Global City",'📍', "assets/ascott.jpg", "A beautiful hotel with city lights view in bgc. Enjoy the city lights!"),
    Booking("Red Planet Hotel", "Makati",'📍', "assets/redplanet.jpg", "Feel the bustling sights and sounds of Makati's famed Poblacion nightlife district with this centrally located budget hotel."),
    Booking("Citilink Hotel", "lucena City",'📍', "assets/citilink.jpg", "The hotel is in front of SM Lucena which makes it very ideal and easy to find."),
    Booking("Quest Hotel", "Tagaytay","📍", "assets/quest.jpg", "Your choice destination for relaxation, family bonding and staycations."),
  ];

  final List<String> places = ["Lucena City", "Tayabas", "Sariaya"];
  final List<String> placesImages = [
    "assets/lucena.jpg",
    "assets/tayabas.jpg",
    "assets/sariaya.jpg",
  ];

  final List<Booking> favoriteBookings = [];
  final List<Booking> historyBookings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/intro.jpg",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 60,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Where you ", style: TextStyle(color: Colors.white, fontSize: 40, shadows: [Shadow(blurRadius: 6.0, color: Colors.black87, offset: Offset(2.0, 2.0))])),
                    Text("wanna go?", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 6.0, color: Colors.black87, offset: Offset(2.0, 2.0))])),
                  ],
                ),
              ),
              const Positioned(
                top: 60,
                right: 20,
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ),
            ],
          ),
          if (_selectedIndex == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  _buildChip("Hotel", isHotelSelected),
                  const SizedBox(width: 10),
                  _buildChip("Place", !isHotelSelected),
                ],
              ),
            ),
          Expanded(
            child: _selectedIndex == 0
                ? (isHotelSelected ? _buildHotelList() : _buildPlaceList())
                : _selectedIndex == 1
                ? _buildFavoriteList()
                : _selectedIndex == 4
                ? _buildHistoryList()
                : const SizedBox(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushNamed(
              context,
              AuthService.isLoggedIn ? '/profile' : '/auth',
            );
          } else if (index == 3) {
            if (AuthService.isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MessagesScreen(
                    hotelName: "Suite Dream Support",
                    initialMessage: Message(
                      sender: "Support",
                      text: "Welcome to Suite Dream support! "
                          "Here you can view your reservation chats and contact us.",
                      timestamp: DateTime.now(),
                    ),
                    initialMessages: [],
                  ),
                ),
              );
            } else {
              Navigator.pushNamed(context, '/auth');
            }
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
    );
  }

  Widget _buildHotelList() {
    if (bookings.isEmpty) {
      return const Center(
        child: Text('No bookings available.', style: TextStyle(color: Colors.white70, fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: bookings.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final isFavorite = favoriteBookings.any((b) => b.hotel == booking.hotel);
        final isBooked = historyBookings.any((b) => b.hotel == booking.hotel);

        return GestureDetector(
          onTap: () {
            if (isBooked) {
              _showCancelBookingDialog(booking);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: booking)),
              ).then((isConfirmed) {
                if (isConfirmed == true) {
                  setState(() {
                    if (!historyBookings.any((b) => b.hotel == booking.hotel)) {
                      historyBookings.add(booking);
                    }
                  });
                }
              });
            }
          },
          child: Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(booking.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isFavorite) {
                              favoriteBookings.removeWhere((b) => b.hotel == booking.hotel);
                            } else {
                              favoriteBookings.add(booking);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.hotel, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("${booking.location} • ${booking.date}", style: const TextStyle(fontSize: 14, color: Colors.white70)),
                      if (isBooked)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 16),
                              const SizedBox(width: 4),
                              const Text("Booked", style: TextStyle(color: Colors.green, fontSize: 12)),
                            ],
                          ),
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
  }

  void _showCancelBookingDialog(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Cancel Booking', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to cancel your booking at ${booking.hotel}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                historyBookings.removeWhere((b) => b.hotel == booking.hotel);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking at ${booking.hotel} cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteList() {
    if (favoriteBookings.isEmpty) {
      return const Center(
        child: Text('No favorites yet', style: TextStyle(color: Colors.white70, fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: favoriteBookings.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final booking = favoriteBookings[index];
        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(booking.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.hotel, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("${booking.location} • ${booking.date}", style: const TextStyle(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryList() {
    if (historyBookings.isEmpty) {
      return const Center(
        child: Text('No booking history yet.', style: TextStyle(color: Colors.white70, fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: historyBookings.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final booking = historyBookings[index];
        return GestureDetector(
          onTap: () => _showCancelBookingDialog(booking),
          child: Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(booking.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.hotel, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("${booking.location} • ${booking.date}", style: const TextStyle(fontSize: 14, color: Colors.white70)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 16),
                            const SizedBox(width: 4),
                            const Text("Booked", style: TextStyle(color: Colors.green, fontSize: 12)),
                          ],
                        ),
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
  }

  Widget _buildPlaceList() {
    return ListView.builder(
      itemCount: places.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlaceRoomsScreen(
                  placeName: places[index],
                  imageUrl: placesImages[index],
                ),
              ),
            );
          },
          child: Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(placesImages[index], height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(places[index], style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => isHotelSelected = label == "Hotel"),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}