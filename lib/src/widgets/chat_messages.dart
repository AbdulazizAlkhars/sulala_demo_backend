import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sulala_demo_backend/src/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Text('Error retrieving messages');
        } else {
          final messages = snapshot.data!.docs;
          if (messages.isEmpty) {
            return const ListTile(
              title: Center(child: Text("There are no messages")),
            );
          }
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index].data();
              final messageText = message['text'] ?? '';
              final username = message['username'] ?? '';
              final userImage = message['userImage'] ?? '';
              final isMe =
                  message['userId'] == FirebaseAuth.instance.currentUser?.uid;

              if (index == 0) {
                return MessageBubble.first(
                  userImage: isMe ? null : userImage,
                  username: isMe ? null : username,
                  message: messageText,
                  isMe: isMe,
                );
              } else {
                return MessageBubble.next(
                  message: messageText,
                  isMe: isMe,
                );
              }
            },
          );
        }
      },
    );
  }
}
