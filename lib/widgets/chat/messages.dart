import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  Future<User?> data() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),
          builder: (context, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              reverse: true,
              itemCount: chatSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  key: ValueKey(chatSnapshot.data!.docs[index].id),
                  userName: chatSnapshot.data!.docs[index]['username'],
                  message: chatSnapshot.data!.docs[index]['text'],
                  isMe: chatSnapshot.data!.docs[index]['userId'] ==
                      futureSnapshot.data!.uid,
                );
              },
            );
          },
        );
      },
    );
  }
}
