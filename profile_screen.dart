import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService.logout();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,  // Center the contents horizontally
          children: [
            // Center the profile picture at the top
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                user.profilePicUrl.isNotEmpty
                    ? user.profilePicUrl  // If the user has a profile pic URL, load it
                    : 'assets/profile.jpg', // Fallback to the default local image
              ),
            ),
            SizedBox(height: 20), // Add space between the picture and the user info
            _buildInfo("Name", user.name),
            _buildInfo("Email", user.email),
            _buildEditableInfo("Phone", user.phone, _editPhone),
            _buildEditableInfo("Address", user.address, _editAddress),
            _buildEditableInfo("Payment", user.paymentInfo, _editPayment),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return ListTile(
      title: Text(label, style: TextStyle(color: Colors.white)),
      subtitle: Text(value.isEmpty ? "Not provided" : value,
          style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildEditableInfo(String label, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(label, style: TextStyle(color: Colors.white)),
      subtitle: Text(value.isEmpty ? "Not provided" : value,
          style: TextStyle(color: Colors.white)),
      trailing: Icon(Icons.edit, color: Colors.white54),
      onTap: onTap,
    );
  }

  void _editPhone() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter Phone Number"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(hintText: "e.g. 09123456789"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: Text("Save")),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => AuthService.currentUser!.phone = result);
    }
  }

  void _editAddress() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter Address"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Your address"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: Text("Save")),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => AuthService.currentUser!.address = result);
    }
  }

  void _editPayment() async {
    String selectedMethod = "E-Wallet";
    String? platform;
    String? number;
    String? name;
    String? cardNumber;
    String? cvv;
    String? cardHolder;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text("Select Payment Method"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: selectedMethod,
                  items: ["E-Wallet", "Bank"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setStateDialog(() => selectedMethod = val!),
                ),
                if (selectedMethod == "E-Wallet") ...[
                  DropdownButton<String>(
                    value: platform,
                    hint: Text("Select Platform"),
                    items: ["GCash", "PayMaya"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setStateDialog(() => platform = val),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Wallet Number"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val) => number = val,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Account Name"),
                    onChanged: (val) => name = val,
                  ),
                ] else if (selectedMethod == "Bank") ...[
                  TextField(
                    decoration: InputDecoration(hintText: "Card Number"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val) => cardNumber = val,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "CVV"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val) => cvv = val,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Cardholder Name"),
                    onChanged: (val) => cardHolder = val,
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
              TextButton(
                onPressed: () {
                  String paymentInfo;
                  if (selectedMethod == "E-Wallet") {
                    if (platform != null && number != null && name != null) {
                      paymentInfo = "$platform: $number ($name)";
                    } else {
                      paymentInfo = "Incomplete e-wallet info";
                    }
                  } else {
                    if (cardNumber != null && cvv != null && cardHolder != null) {
                      paymentInfo =
                      "Card ****${cardNumber!.substring(cardNumber!.length - 4)} ($cardHolder)";
                    } else {
                      paymentInfo = "Incomplete card info";
                    }
                  }

                  setState(() {
                    AuthService.currentUser!.paymentInfo = paymentInfo;
                  });

                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }
}
