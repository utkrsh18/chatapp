import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatservices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //GU
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
          final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
          final usersSnapshot = await _firestore.collection('Users').get();
          return usersSnapshot.docs
              .where(
                (doc) =>
                    doc.data()['email'] != currentUser.email &&
                    !blockedUserIds.contains(doc.id),
              )
              .map((doc) => doc.data())
              .toList();
        });
  }

  //SM
  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomId = ids.join('_');
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //GU
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  //R
  Future<void> reportUser(String messageId, String userId) async {
    final CurrentUser = _auth.currentUser;
    final report = {
      'reportedBy': CurrentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('Reports').add(report);
  }

  //B
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
  }

  //UB
  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
  }

  //GB
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String UserId) {
    return _firestore
        .collection('Users')
        .doc(UserId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
          final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
          final userDocs = await Future.wait(
            blockedUserIds.map(
              (id) => _firestore.collection('Users').doc(id).get(),
            ),
          );
          return userDocs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
  }
}
