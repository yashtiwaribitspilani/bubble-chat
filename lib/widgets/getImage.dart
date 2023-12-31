import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class getImage extends StatefulWidget {
  final String documentId;

  getImage(this.documentId);

  @override
  State<getImage> createState() => _getImageState();
}

class _getImageState extends State<getImage> {
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

          return Image.network(data['image']);
        }

        return CircularProgressIndicator();
      },
    );
  }
}
