// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shareme/family_background.dart';
import 'auth.dart';
import 'login_register_page.dart';
import 'profile_form_page.dart';
import 'profile_model.dart';
import 'storage_service.dart';

class ProfilePage extends StatefulWidget {
  final int? selectedIndex;

  final dynamic data;

  const ProfilePage({
    Key? key,
    this.selectedIndex,
    this.data,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference profile =
      FirebaseFirestore.instance.collection('users1');

  late DocumentSnapshot docToEdit;
  late Future<List<Profile>> dataList;
  List<Profile> datas = [];
  var receiver;
  var isLoading = false;
  final Storage storage = Storage();

  setDoc(DocumentSnapshot documentSnapshot) {
    docToEdit = documentSnapshot;
  }

  final User? user = Auth().currentUser!;

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
    await Auth().signOut();
    setState(() {
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }


  buildProfileStreamBuilder() {
    return StreamBuilder(
      stream: profile.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot =
              streamSnapshot.data!.docs[index];
              if (documentSnapshot.id != _firebaseAuth.currentUser!.uid) {
                return Container();
              } else {
                setDoc(documentSnapshot);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    const Divider(thickness: 2),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.person_outline_rounded, size: 30, color: Colors.white),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Full Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                documentSnapshot['fullName'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.wc_outlined, size: 30, color: Colors.white),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gender',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                documentSnapshot['gender'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.cake_outlined, size: 30, color: Colors.white),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Birthdate',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                documentSnapshot['birthdate'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 30, color: Colors.white),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                documentSnapshot['address'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );

              }
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Text("ShareMe", style: TextStyle(color: Colors.white),),
        leading: Image.asset("assets/1212-removebg-preview.png"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
                receiver = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProForm(
                          docU: docToEdit,
                        )));
                if (receiver != null) {
                  setState(() {
                    datas.add(receiver);
                  });
                } else {
                  return;
                }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              signOut();
            },
          ),
        ],
        backgroundColor: Colors.black
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Define a function to refresh the data in the stream
          await profile.get();
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          children: [
            const SizedBox(height: 36),
            StreamBuilder(
                stream: storage.getPicStream('pfp'),
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            height: 120,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(snapshot.data ??
                                  "https://i0.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg?ssl=1"),
                            )),
                      ],
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Container(
                      alignment: Alignment.center,
                      height: 120,
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage("https://i0.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg?ssl=1"),
                      ));
                }),

            const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              elevation: 5.0,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.topLeft,
                height: 500,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : buildProfileStreamBuilder(),
              ),
            ),
          ),

            const SizedBox(height: 5),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FamilyBackground()));
        },
        child: const Icon(Icons.arrow_circle_right_outlined),
      ),
    );
  }
}
