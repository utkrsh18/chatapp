import 'package:chatapp/services/auth/authservice.dart';
import 'package:chatapp/components/mbutton.dart';
import 'package:chatapp/components/mtextfield.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget {
  final TextEditingController _emController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final void Function()? onTap;

  Loginpage({super.key, required this.onTap});
  void login(BuildContext context) async {
    final authService = Authservice();
    try {
      await authService.signInWithEmailPassword(
        _emController.text,
        _pwController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
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
              size: 60,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 40),
            Text(
              'Welcom back you been missed',
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
            Mbutton(text: "Login", onTap: () => login(context)),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member? "),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register Now",
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
