import 'package:chatapp/pages/loginpage.dart';
import 'package:chatapp/pages/registerpage.dart';
import 'package:flutter/material.dart';

class Lor extends StatefulWidget {
  const Lor({super.key});

  @override
  State<Lor> createState() => _LorState();
}

class _LorState extends State<Lor> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Loginpage(onTap: togglePages);
    } else {
      return Registerpage(onTap: togglePages);
    }
  }
}
