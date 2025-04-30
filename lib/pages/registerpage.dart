import 'package:chatapp/services/auth/authservice.dart';
import 'package:chatapp/components/mbutton.dart';
import 'package:chatapp/components/mtextfield.dart';
import 'package:flutter/material.dart';

class Registerpage extends StatelessWidget {
  final TextEditingController _emController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _cpwController = TextEditingController();
  final void Function()? onTap;

  Registerpage({super.key, required this.onTap});

  void register(BuildContext context) {
    final auth = Authservice();

    if (_pwController.text == _cpwController.text) {
      try {
        auth.signUpWithEmailPassword(_emController.text, _pwController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    } else {
      showDialog(
        context: context,
        builder:
            (context) => const AlertDialog(
              title: Text("Password dont match, try again"),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 55,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 30),
            Text(
              'Lets create an account for you',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 30),
            Mtextfield(
              hintText: "Email",
              obscureText: false,
              controller: _emController,
            ),
            const SizedBox(height: 25),
            Mtextfield(
              hintText: "password",
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(height: 25),
            Mtextfield(
              hintText: "confirm password",
              obscureText: true,
              controller: _cpwController,
            ),
            const SizedBox(height: 25),
            Mbutton(text: "Register", onTap: () => register(context)),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account"),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
