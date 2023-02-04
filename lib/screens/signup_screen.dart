import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/color_utils.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "signUpScreen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  void _signUp() async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text)
          .then((value) {
        print("New account created.");
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } on FirebaseAuthException catch (e){
      print("ERROR");
      print(e.message);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: Container(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height*0.1, 20, 0),
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      TextField(
                        controller: _emailTextController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: "Enter Email"),
                      ),
                      SizedBox(height: 40),
                      TextField(
                        controller: _passwordTextController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: "Enter Password"),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                        icon: Icon(Icons.lock_open, size: 32,),
                        label: Text("Sign Up", style: TextStyle(fontSize: 24),),
                        onPressed: _signUp,
                      ),
                    ]
                )
            )
        )
    );
  }

}
