import 'package:chatapp/components/usertile.dart';
import 'package:chatapp/services/auth/authservice.dart';
import 'package:chatapp/services/chat/chatservices.dart';
import 'package:flutter/material.dart';

class Blockeduserspage extends StatelessWidget {
  Blockeduserspage({super.key});

  final Chatservices chatservices = Chatservices();
  final Authservice authservice = Authservice();
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Unblock User'),
            content: const Text("Are you sure you want to unblock"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),

              TextButton(
                onPressed: () {
                  chatservices.unblockUser(userId);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Unblocked")));
                },
                child: const Text("Unblock"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = authservice.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(title: const Text("Blocked Users"), actions: []),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatservices.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error Loading..'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final blockedUsers = snapshot.data ?? [];

          if (blockedUsers.isEmpty) {
            return const Center(child: Text("No Blocked Users"));
          }
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return Usertile(
                text: user['email'],
                onTap: () => _showUnblockBox(context, user["uid"]),
              );
            },
          );
        },
      ),
    );
  }
}
