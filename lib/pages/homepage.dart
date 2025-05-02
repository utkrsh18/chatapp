import 'package:chatapp/components/mdrawer.dart';
import 'package:chatapp/components/usertile.dart';
import 'package:chatapp/pages/chatpage.dart';
import 'package:chatapp/services/auth/authservice.dart';
import 'package:chatapp/services/chat/chatservices.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final Chatservices _chatservices = Chatservices();
  final Authservice _authservice = Authservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const Mdrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatservices.getUsersStreamExcludingBlocked(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        return ListView(
          children:
              snapshot.data!
                  .map<Widget>(
                    (userData) => _buildUserListItem(userData, context),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    if (userData["email"] != _authservice.getCurrentUser()!.email) {
      return Usertile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Chatpage(
                    receiverEmail: userData['email'],
                    receiverID: userData['uid'],
                  ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
