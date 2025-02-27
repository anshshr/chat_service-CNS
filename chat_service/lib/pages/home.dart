import 'package:chat_service/Auth/auth.dart';
import 'package:chat_service/components/circular_indicator.dart';
import 'package:chat_service/components/dialog.dart';
import 'package:chat_service/pages/chat_screen.dart';
import 'package:chat_service/pages/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final auth = Auth();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth authenticate = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Start Chatting..'),
          centerTitle: true,
          backgroundColor: Colors.amber,
          actions: [
            IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularIndicator()),
                  );
                  final String message = await auth.logoutUser();
                  Navigator.pop(context);

                  if (message == "Success") {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      ),
                      (route) => false,
                    );
                  } else {
                    dailog(message, context, () => Navigator.pop(context));
                  }
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                  size: 25,
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: db.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox(
                height: 100,
                width: 100,
                child: Text(
                  "Somehting error occured ...",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
                children: snapshot.data!.docs
                    .where((doc) =>
                        doc["email"] != authenticate.currentUser!.email)
                    .map<Widget>((doc) => ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    receiverEmail: doc["email"],
                                    recierverId: doc["userId"],
                                  ),
                                ));
                          },
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.black87,
                            child: Text(
                              doc['email'][0].toString().toUpperCase() +
                                  doc['email']
                                      .toString()
                                      .split('@')[1][0]
                                      .toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            doc['email']
                                    .toString()
                                    .split('@')[0][0]
                                    .toUpperCase() +
                                doc['email']
                                    .toString()
                                    .split('@')[0]
                                    .substring(1)
                                    .toLowerCase(),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            doc['email'],
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ))
                    .toList());
          },
        ));
  }
}
