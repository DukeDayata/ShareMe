import 'family_model.dart';
import 'storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class FamilyBackground extends StatefulWidget {
  bool? isUpdated;
  FamilyBackground({Key? key, this.isUpdated}) : super(key: key);

  @override
  State<FamilyBackground> createState() => _FamilyBackgroundState();
}

class _FamilyBackgroundState extends State<FamilyBackground> {
  final _formKey = GlobalKey<FormState>();
  Storage? storage;
  var isloading = false;
  final _notes = <Family>[];
  final _fullName = TextEditingController();
  final _age = TextEditingController();
  final _birthdate = TextEditingController();
  final _address = TextEditingController();
  final _type = TextEditingController();
  final _occupation = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  bool? created;

  @override
  void initState() {
    storage = Storage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isUpdated != null){
      isLoading = widget.isUpdated!;
    }else{
      isLoading = created ?? true;
    }
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Family Information",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          leading: Image.asset('assets/1212-removebg-preview.png')
      ),
      body: isLoading
          ? _showDietaryPlan()
          : const Center(child: Text("No Background Information")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddNoteDialog();
          _address.clear();
          _age.clear();
          _birthdate.clear;
          _occupation.clear;
          _type.clear;
        },
        backgroundColor: Colors.black,
      ),
    );
  }

  _showDietaryPlan() {
    final CollectionReference planner =
    FirebaseFirestore.instance.collection('users1').doc(_firebaseAuth.currentUser!.uid).collection('familyHistory');
    return RefreshIndicator(
      onRefresh: () async {
        // Define a function to refresh the data in the stream
        await planner.get();
        setState(() {});
      },
      child: StreamBuilder(
          stream: planner.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
            if(streamSnapshot.hasData){
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                  return InkWell(
                      onTap: () => _showEditNoteDialog(documentSnapshot, documentSnapshot.id),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                      const SizedBox(
                        height: 8,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                            children: [
                            Icon(Icons.person),
                        SizedBox(width: 8),
                        Text(
                          '${documentSnapshot['fullName']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ])
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.people),
                            SizedBox(width: 8),
                            Text(
                              'Relationship: ${documentSnapshot['type']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.cake),
                            SizedBox(width: 8),
                            Text(
                              'Age: ${documentSnapshot['age'].toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8),
                            Text(
                              'Birthdate: ${documentSnapshot['birthdate']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.work),
                            SizedBox(width: 8),
                            Text(
                              'Occupation: ${documentSnapshot['occupation']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      ],
                  ));
                },
              );
            }{
              return const CircularProgressIndicator();
            }

          }),
    );
  }


  _showAddNoteDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add a Background Information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _fullName,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter a name'
                          : null;
                    },
                  ),
                  TextFormField(
                    controller: _age,
                    decoration: const InputDecoration(labelText: 'Age'),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter an age'
                          : null;
                    },
                  ),
                  TextFormField(
                    controller: _type,
                    decoration: const InputDecoration(labelText: 'Relationship'),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter a relationship'
                          : null;
                    },
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _birthdate,
                    decoration: const InputDecoration(labelText: 'Birthdate'),
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        _birthdate.text = DateFormat('MM/dd/yyyy').format(date);
                      }
                    },
                  ),
                  TextFormField(
                    controller: _occupation,
                    decoration: const InputDecoration(labelText: 'Occupation'),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter an Occupation'
                          : null;
                    },
                  ),
                ]),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(
                    255, 255, 165, 0)),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(
                    255, 255, 165, 0)),
                child: const Text("Add"),
                onPressed: () {
                  {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      storage!.addUserPlannerToDB(Family(
                          type: _type.text,
                          fullName: _fullName.text,
                          age: int.parse(_age.text),
                          birthdate: _birthdate.text,
                          occupation: _occupation.text,

                      ));

                      var note = Family(type: _type.text,
                        fullName: _fullName.text,
                        age: int.parse(_age.text),
                        birthdate: _birthdate.text,
                        occupation: _occupation.text);
                      setState(() {
                        _notes.add(note);
                      });
                      Navigator.pop(context);
                    }
                  }
                }),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(DocumentSnapshot documentSnapshot, String docID) {
    final CollectionReference planner =
    FirebaseFirestore.instance.collection('users1').doc(_firebaseAuth.currentUser!.uid).collection('familyHistory');
    _fullName.text = documentSnapshot['fullName']!;
    _type.text = documentSnapshot['type'];
    _occupation.text = documentSnapshot['occupation'];
    _birthdate.text = documentSnapshot['birthdate'];
    _age.text = documentSnapshot['age'].toString();

    Future<void> deleteData(String plannerId) async {
      await planner.doc(plannerId).delete();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit your Information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _fullName,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter a name'
                          : null;
                    },
                  ),
                  TextFormField(
                    controller: _age,
                    decoration: const InputDecoration(labelText: 'Age'),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter an age'
                          : null;
                    },
                  ),
                  TextFormField(
                    controller: _type,
                    decoration: const InputDecoration(labelText: 'Relationship'),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter a relationship'
                          : null;
                    },
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _birthdate,
                    decoration: const InputDecoration(labelText: 'Birthdate'),
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        _birthdate.text = DateFormat('MM/dd/yyyy').format(date);
                      }
                    },
                  ),
                  TextFormField(
                    controller: _occupation,
                    decoration: const InputDecoration(labelText: 'Occupation'),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter an Occupation'
                          : null;
                    },
                  ),
                ]),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),),
            ElevatedButton(
                child: const Text("Save"),
                onPressed: () {
                  {
                    if (_formKey.currentState!.validate()) {
                      planner.doc(docID).update({
                        'type': _type.text,
                        'fullName': _fullName.text,
                        'age': int.parse(_age.text),
                        'birthdate': _birthdate.text,                        'occupation': _occupation.text,
                      });

                      // setState(() {
                      //   note.description = _descController.text;
                      // });
                      Navigator.pop(context);
                    }
                  }
                },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,)
            ),
            ElevatedButton(
                onPressed: (){
                  deleteData(documentSnapshot.id);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
            ),
            )
          ],
        );
      },
    );
  }
}
