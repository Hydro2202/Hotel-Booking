class Booking {
  final String hotel;
  final String location;
  final String date;
  final String imageUrl;
  final String description;
  final double pricePerNight;
  final int maxGuests;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int guests;
  bool isConfirmed;

  Booking(
      this.hotel,
      this.location,
      this.date,
      this.imageUrl,
      this.description, {
        this.checkInDate,
        this.checkOutDate,
        this.guests = 1,
        this.isConfirmed = false,
        this.pricePerNight = 2500.0,
        this.maxGuests = 2,
      });
}