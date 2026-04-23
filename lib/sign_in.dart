import 'package:flutter/material.dart';
import 'package:rhombix_task_3/data/trip_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sign_in extends StatelessWidget {
  const sign_in(
      {super.key,
      this.current_location,
      required this.long,
      required this.lat});
  final double long;
  final double lat;
  final current_location;

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(current_location);
                check_credentials(
                    emailController.text, passwordController.text, context);
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  void check_credentials(
      String email, String password, BuildContext context) async {
    SharedPreferences sh = await SharedPreferences.getInstance();

    String? storedEmail = sh.getString('email');
    String? storedPassword = sh.getString('password');

    if (storedEmail != null && storedPassword != null) {
      if (storedEmail == email && storedPassword == password) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => trip_screen(
            current_location: current_location,
            long: long,
            lat: lat,
          ),
        ));
      } else {
        print("Invalid email or password");
      }
    } else {
      print("No account found. Please sign up.");
    }
  }
}
