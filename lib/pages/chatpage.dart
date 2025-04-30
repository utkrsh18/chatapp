import 'package:chatapp/components/mtextfield.dart';
import 'package:chatapp/services/auth/authservice.dart';
import 'package:chatapp/services/chat/chatservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  Chatpage({super.key, required this.receiverEmail, required this.receiverID});

  final TextEditingController _messageController = TextEditingController();

  final Chatservices _chatservices = Chatservices();
  final Authservice _authservice = Authservice();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatservices.sendMessage(receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail)),
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildUserInput()],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authservice.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: _chatservices.getMessages(senderID, receiverID),
      builder: (context, snapshot) {
        print('Snapshot state: ${snapshot.connectionState}'); // Add this
        print('Snapshot has data: ${snapshot.hasData}'); // Add this
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No messages yet.');
        }
        print('Messages found: ${snapshot.data!.docs.length}');
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data['message']);
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: Mtextfield(
            controller: _messageController,
            hintText: 'Type a message',
            obscureText: false,
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.arrow_upward),
        ),
      ],
    );
  }
}
