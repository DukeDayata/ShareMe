import 'profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'auth.dart';
import 'themehelper.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAge = TextEditingController();
  final TextEditingController _controllerHobby = TextEditingController();
  final TextEditingController _controllerSkills = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerBirthdate = TextEditingController();
  var gender;
  bool checkedValue = false;
  bool checkboxValue = false;
  String? errorMessage = '';

  Widget _errorMessage(){
    return Text (errorMessage == '' ? '' : "Hmmmmm? $errorMessage");
  }

  Future<void> createUserWithEmailAndPassword() async{
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          age: int.parse(_controllerAge.text),
          fullName: _controllerName.text,
          gender: gender,
          address: _controllerAddress.text,
          hobby: _controllerHobby.text,
          skill: _controllerSkills.text,
          birthdate: _controllerBirthdate.text,

      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30,),
                        const SizedBox(height: 30,),
                        const SizedBox(height: 30,),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: InkWell(
                            child: Container(
                              child: const Image(
                                image: AssetImage("assets/1212-removebg-preview.png"),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            controller: _controllerName,
                            decoration: ThemeHelper().textInputDecoration('Full name', 'Enter your full name'),
                            validator: (value) {
                              return (value == '') ? 'Please enter your full name' : null;
                            },
                          ),

                        ),
                        const SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            controller: _controllerEmail,
                            decoration: ThemeHelper().textInputDecoration('Email', 'Enter your email'),
                            validator: (val) {
                              if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                return "Enter a valid email address";
                              }
                            },
                          ),

                        ),
                        const SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            controller: _controllerPassword,
                            decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                            validator: (value) {
                              return (value == '') ? 'Please enter your password' : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            controller: _controllerAge,
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
                            ), color: Colors.white, borderRadius: BorderRadius.circular(25.0)),
                            height: 45,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0, bottom: 6.0, left: 10.0),
                              child: DropdownButtonFormField(
                                hint: const Text('Gender'),
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
                          child: TextFormField(
                            controller: _controllerAddress,
                            decoration: ThemeHelper().textInputDecoration('Address', 'Enter your address'),
                            validator: (value) {
                              return (value == '') ? 'Please enter a address' : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            readOnly: true,
                            controller: _controllerBirthdate,
                            decoration: ThemeHelper().textInputDecoration('Birthdate', 'Enter your birthdate'),
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                _controllerBirthdate.text = DateFormat('MM/dd/yyyy').format(date);
                              }
                            },
                          )),

                        const SizedBox(height: 30,),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    const Text("I accept all terms and conditions.", style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Theme.of(context).colorScheme.error,fontSize: 12,),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                createUserWithEmailAndPassword();
                                print(_controllerBirthdate.text);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()
                                    ),
                                        (Route<dynamic> route) => false
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
