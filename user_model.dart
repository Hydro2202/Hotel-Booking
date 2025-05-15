class UserModel {
  final String name;
  final String email;
  final String profilePicUrl;

  String phone;
  String address;
  String paymentInfo;

  UserModel({
    required this.name,
    required this.email,
    required this.profilePicUrl,
    this.phone = '',
    this.address = '',
    this.paymentInfo = '',
  });
}
