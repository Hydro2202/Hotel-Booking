import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../models/message.dart';
import '../services/auth_service.dart';
import 'messages_screen.dart';

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;

  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int guests = 1;

  double get totalPrice {
    if (checkInDate == null || checkOutDate == null) return 0.0;
    final nights = checkOutDate!.difference(checkInDate!).inDays;
    if (nights <= 0) return 0.0;
    final extraGuestCharge = guests > widget.booking.maxGuests
        ? (guests - widget.booking.maxGuests) * 500
        : 0;
    return (widget.booking.pricePerNight * nights) + extraGuestCharge;
  }

  Future<void> _selectDate({required bool isCheckIn}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate != null && checkOutDate!.isBefore(picked)) {
            checkOutDate = null;
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  void _confirmBooking() async {
    if (!AuthService.isLoggedIn) {
      final result = await Navigator.pushNamed(context, '/auth');

      // Optional: Check if login was successful
      if (result != true && !AuthService.isLoggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login required to book a room.')),
        );
        return;
      }
    }

    // Proceed with booking
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking confirmed!')),
    );

    final confirmationMessage = Message(
      sender: "System",
      text: "Your booking at ${widget.booking.hotel} is confirmed!\n"
          "Check-in: ${DateFormat('MMM dd, yyyy').format(checkInDate!)}\n"
          "Check-out: ${DateFormat('MMM dd, yyyy').format(checkOutDate!)}\n"
          "Guests: $guests\n"
          "Total: ₱${totalPrice.toStringAsFixed(2)}",
      timestamp: DateTime.now(),
      isSystemMessage: true,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessagesScreen(
          hotelName: widget.booking.hotel,
          initialMessages: [confirmationMessage],
          initialMessage: confirmationMessage,
        ),
      ),
    ).then((_) {
      Navigator.of(context).pop(true);
    });
  }


  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM dd, yyyy');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.booking.hotel),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.asset(
              widget.booking.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            Text(
              widget.booking.description,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),

            const Text(
              'Room Details',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• 2 Queen-size beds\n'
                  '• Private bathroom with hot & cold shower\n'
                  '• Flat-screen TV with cable channels\n'
                  '• Free high-speed Wi-Fi\n'
                  '• Air conditioning\n'
                  '• Mini fridge\n'
                  '• Complimentary bottled water\n'
                  '• Room service available\n',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),

            Text(
              '₱${widget.booking.pricePerNight.toStringAsFixed(2)} per night',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDate(isCheckIn: true),
                    child: Text(
                      checkInDate == null
                          ? 'Select Check-in'
                          : 'Check-in: ${formatter.format(checkInDate!)}',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: checkInDate == null
                        ? null
                        : () => _selectDate(isCheckIn: false),
                    child: Text(
                      checkOutDate == null
                          ? 'Select Check-out'
                          : 'Check-out: ${formatter.format(checkOutDate!)}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Guests:',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: guests > 1
                          ? () => setState(() => guests--)
                          : null,
                      icon: const Icon(Icons.remove, color: Colors.white),
                    ),
                    Text(
                      '$guests',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () => setState(() => guests++),
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (checkInDate != null && checkOutDate != null)
              Text(
                'Total: ₱${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: (checkInDate != null && checkOutDate != null)
                  ? _confirmBooking
                  : null,
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}