import 'package:flutter/material.dart';
import 'home_page.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  final atmController = TextEditingController();
  final finalController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(userName: nameController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Info")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                value!.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                controller: numberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? 'Enter your number' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                value!.length < 6 ? 'Password too short' : null,
              ),
              TextFormField(
                controller: atmController,
                decoration: InputDecoration(labelText: 'ATM Info (Optional)'),

              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
