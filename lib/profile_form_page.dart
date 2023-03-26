// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, unnecessary_null_comparison

//NOTE: USE THIS PAGE CODE FOR THE 2ND OPTION ONLY
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shareme/storage_service.dart';

import 'themehelper.dart';

class ProForm extends StatefulWidget {
  DocumentSnapshot docU;

  ProForm({Key? key, required this.docU}) : super(key: key);

  @override
  State<ProForm> createState() => _ProFormState();
}

class _ProFormState extends State<ProForm> {
  final CollectionReference profile =
      FirebaseFirestore.instance.collection('users1');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Storage storage = Storage();
  final formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final age = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final hobby = TextEditingController();
  final skill = TextEditingController();
  final birthdate = TextEditingController();
  var gender, sender;
  bool update = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot newDoc = widget.docU;
    if (newDoc != null) {
      fullName.text = newDoc['fullName'];
      age.text = newDoc['age'].toString();
      email.text = newDoc['email'];
      gender = newDoc['gender'];
      address.text = newDoc['address'];
      birthdate.text = newDoc['birthdate'];
      hobby.text = newDoc['hobby'];
      skill.text = newDoc['skill'];
    }
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Profile Information'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 20),
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
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['png', 'jpg', 'jpeg']);

                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No Image Selected")));
                              return;
                            }
                            final filePath = result.files.single.path!;
                            const fileName = "pfp";
                            storage.uploadFile(filePath, fileName);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(
                              253, 2, 2, 2),),
                          child: const Text("Change Profile Picture",
                              style: TextStyle(color: Colors.white))),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                {
                  return Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          height: 120,
                          child: const CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                "https://i0.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg?ssl=1"),
                          )),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['png', 'jpg', 'jpeg']);

                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No Image Selected")));
                              return;
                            }
                            final filePath = result.files.single.path!;
                            const fileName = "pfp";
                            storage.uploadFile(filePath, fileName);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                          child: const Text("Change Profile Picture",
                              style: TextStyle(color: Colors.white))),
                    ],
                  );
                }
              }),
          Container(
            alignment: Alignment.center,
            height: 450,
            //color: Colors.green,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: [
                  const SizedBox(height: 7),
                  Container(
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: TextFormField(
                      controller: fullName,
                      decoration: ThemeHelper().textInputDecoration('Full name', 'Enter your full name'),
                      validator: (value) {
                        return (value == '') ? 'Please enter your full name' : null;
                      },
                    ),

                  ),
                  const SizedBox(height: 30,),
                  Container(
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: TextFormField(
                      controller: age,
                      decoration: ThemeHelper().textInputDecoration('Age', 'Enter your age'),
                      validator: (value) {
                        return (value == '') ? 'Please enter your Age' : null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    decoration: BoxDecoration(border: Border.all(
                        width: 0.3,
                        color: Colors.orange
                    ), color: Colors.white, borderRadius: BorderRadius.circular(25.0), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 8.0)],),
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 6.0, left: 10.0),
                      child: DropdownButtonFormField(
                          hint: const Text('Gender'),
                          value: gender,
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            )
                          ],
                          onChanged: (g1){
                            gender = g1.toString();

                          }
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        controller: birthdate,
                        decoration: ThemeHelper().textInputDecoration('Birthdate', 'Enter your birthdate'),
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            birthdate.text = DateFormat('MM/dd/yyyy').format(date);
                          }
                        },
                      )),
                  const SizedBox(height: 30,),
                  Container(
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: TextFormField(
                      controller: address,
                      decoration: ThemeHelper().textInputDecoration('Address', 'Enter your address'),
                      validator: (value) {
                        return (value == '') ? 'Please enter a address' : null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            //color: Colors.blue,
            child: ElevatedButton(
              onPressed: () async {
                print(newDoc.id);
                print(_firebaseAuth.currentUser!.uid);
                if (formKey.currentState!.validate()) {
                  await profile.doc(newDoc.id).update({
                    "fullName": fullName.text,
                    "age": int.parse(age.text),
                    "gender": gender.toString(),
                    "email": email.text,
                    "birthdate": birthdate.text,
                    "skill": skill.text,
                    "hobby": hobby.text,
                    "address": address.text,

                  });
                  Navigator.pop(context);
                } else {
                  return;
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black,),
              child: const Text("Save Changes",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
