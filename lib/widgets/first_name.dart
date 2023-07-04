import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirstName extends StatefulWidget {
  final String documentId;

  FirstName(this.documentId);

  @override
  State<FirstName> createState() => _FirstNameState();
}

class _FirstNameState extends State<FirstName> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['first name']} ${data['last name']}',
              style: TextStyle(fontSize: 20));
        }

        return CircularProgressIndicator();
      },
    );
  }
}
