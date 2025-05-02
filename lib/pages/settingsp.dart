import 'package:chatapp/main.dart';
import 'package:chatapp/pages/blockeduserspage.dart';
import 'package:chatapp/themes/themeprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settingsp extends StatelessWidget {
  const Settingsp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("Settings"), actions: []),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.all(25),
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dark Mode",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    CupertinoSwitch(
                      value:
                          Provider.of<Themeprovider>(
                            context,
                            listen: false,
                          ).isDarkMode,
                      onChanged:
                          (value) =>
                              Provider.of<Themeprovider>(
                                context,
                                listen: false,
                              ).toggleTheme(),
                    ),
                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.all(25),
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Blocked Users",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    IconButton(
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Blockeduserspage(),
                            ),
                          ),
                      icon: Icon(Icons.arrow_forward_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
