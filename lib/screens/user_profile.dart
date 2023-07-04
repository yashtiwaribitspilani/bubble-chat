import 'package:chat_app/widgets/first_name.dart';
import 'package:chat_app/widgets/getImage.dart';
import 'package:chat_app/widgets/username.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String imageUrl = '';

  @override
  final currentUserEmail =
      FirebaseAuth.instance.currentUser!.email.toString().trim();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Future imageurl() async {
        FutureBuilder<DocumentSnapshot>(
          future: users.doc(currentUserEmail).get(),
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

              return Text('${data['image']}');
            }

            return CircularProgressIndicator();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 300,
              child: Image.network(imageUrl),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  print('${file?.path}');
                  if (file == null) return;
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child('images');
                  Reference referenceImageToUpload =
                      referenceDirImages.child(currentUserEmail);
                  try {
                    await referenceImageToUpload.putFile(File(file!.path));
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUserEmail)
                        .update({'image': imageUrl});
                  } catch (error) {}
                });
              },
              child: const Text(
                'Pick from gallery',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Take your picture',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    ' Name:',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF00cfdf),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FirstName(currentUserEmail),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Username:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF00cfdf)),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  UserName(currentUserEmail),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Email:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  currentUserEmail,
                  style: const TextStyle(fontSize: 20),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
