import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      if (isLogin) {
        await AuthService.login(email, password);
      } else {
        await AuthService.signUp(name, email, password);
      }

      Navigator.pop(context, true); // <--- Return `true` on success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(isLogin ? "Login" : "Sign Up"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen/ back
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isLogin)
                  TextFormField(
                    decoration: InputDecoration(labelText: "Name"),
                    onSaved: (val) => name = val!,
                    style: TextStyle(color: Colors.white),
                  ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  onSaved: (val) => email = val!,
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  onSaved: (val) => password = val!,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(isLogin ? "Login" : "Sign Up"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(isLogin
                      ? "Don't have an account? Sign Up"
                      : "Have an account? Login"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
