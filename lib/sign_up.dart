import 'package:rhombix_task_3/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sign_up extends StatelessWidget {
  sign_up(
      {super.key,
      required this.current_location,
      required this.long,
      required this.lat});

  final current_location;
  final double long;
  final double lat;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
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
                save_data_locally(nameController.text, emailController.text,
                    passwordController.text);
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => sign_in(
                        current_location: current_location,
                        long: long,
                        lat: lat)));
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  void save_data_locally(String name, String email, String password) async {
    SharedPreferences sh = await SharedPreferences.getInstance();

    sh.setString('name', name);
    sh.setString('email', email);
    sh.setString('password', password);
  }
}
