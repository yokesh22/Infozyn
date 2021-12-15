import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sona_magazine/screens/admin/listview.dart';
import 'package:sona_magazine/screens/admin/upload.dart';
import 'package:sona_magazine/screens/userpanel/homepage.dart';
import 'package:sona_magazine/services/auth.dart';
import 'package:sona_magazine/services/preferences.dart';
class SignUp extends StatefulWidget {
  const SignUp({ Key? key }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey=GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool flag = false;
  bool loginFail = false;
  bool emailfield = false;
  bool passwordfield = true;
  AuthMethods authMethods = AuthMethods();
  FirebaseServices firebaseServices = FirebaseServices();
   final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferenceFunctions sharedPreferenceFunctions = SharedPreferenceFunctions();
  // AuthClass authClass = AuthClass();


    validate()async{
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();

      //sharedPreferenceFunctions.saveUserEmail(_emailController.text);
      await authMethods.signIn(_emailController.text, _passwordController.text).then(
          (value){
            //sharedPreferenceFunctions.isUserLoggedIn(true);
            if (value != null) {
          setState(() {
            flag = true;
          });
          Future.delayed(
            const Duration(seconds: 2),
            (){
              Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => FirebaseItems()),
              (route) => false);
            }
          );
        }
            else{
              setState(() {
                loginFail = true;
              });
            }
          }
      );
    }
  }

  googleSignUp()async{
    setState(() {
      flag = true;
    });
    try{
      await firebaseServices.signInwithGoogle();
      sharedPreferenceFunctions.isUserLoggedIn(true);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
    }catch(e){
      if(e is FirebaseAuthException){
        showMessage(e.message!);
      }
    }
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(

        body:flag? const Center(
          child: CircularProgressIndicator(),
        ): SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:MediaQuery.of(context).size.height,
                    decoration:  BoxDecoration(
                      color: Color(0xff007bff)
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: size.height*0.15,
                            padding: EdgeInsets.only(top: 40.0),
                            child: const Text(
                                  "INFOZYN",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal
                                  ),
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: size.width*0.9,
                              height: size.height*0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white.withOpacity(0.5),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 4,
                                      blurRadius: 7,
                                      offset: const Offset(10,10)
                                  ),
                                ],
                                border: Border.all(color: Colors.white54)
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8.0,),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15.0,top: 10.0),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const Divider(color: Colors.white54,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            emailfield=true;
                                          });
                                        },
                                        child: TextFormField(
                                          controller: _emailController,
                                          validator: (val){
                                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)?
                                            null:"enter a valid Email";
                                          },
                                          keyboardType: TextInputType.emailAddress,
                                          style: const TextStyle(color: Colors.white),
                                          autofocus: false,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.blue
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: _emailController.clear,
                                              icon: Icon(
                                                Icons.clear,
                                                color: Colors.black54,
                                                ),
                                            ),
                                            errorText: loginFail ? "check email" : null,
                                            focusColor: Colors.white,
                                            labelText: "Email",
                                            labelStyle: const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black54
                                            ),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.black54,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        validator: (val){
                                          return RegExp( r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(val!)?
                                          null:"enter a valid password";
                                        },
                                        style: const TextStyle(color: Colors.white),
                                        autofocus: false,
                                        obscureText: passwordfield? true : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.blue
                                          ),
                                          suffixIcon: IconButton(
                                             icon: Icon(
                                              passwordfield ? Icons.visibility_off : Icons.visibility,color: Colors.black54
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                passwordfield = !passwordfield;
                                              });
                                            },
                                           
                                          ),
                                          errorText: loginFail ? "check password" : null,
                                          focusColor: Colors.white,
                                          labelText: "Password",
                                          labelStyle: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black54
                                          ),
                                          fillColor: Colors.white,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.black54,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                      
                                      ),
                                    ),
                                    const SizedBox(height: 13.0,),
                                    GestureDetector(
                                      onTap: (){
                                        validate();
                                      },
                                      child: Center(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: size.width/2,
                                          height: size.height/14,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Colors.white54,
                                                Colors.white30
                                              ]
                                            ),
                                              border: Border.all(color: Colors.white38),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black.withOpacity(0.2),
                                                    spreadRadius: 4,
                                                    blurRadius: 7,
                                                    offset: const Offset(5,5)
                                                ),
                                              ],
                                            borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                                color: Colors.black54,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                FittedBox(
                                  fit:BoxFit.fitWidth,
                                  child: Text(
                                    "Click below to",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                                Text(
                                  " Sign Up",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          GestureDetector(
                            onTap: (){
                              googleSignUp();
                            },
                            child: Container(
                              width: size.width*0.8,
                              height: size.height*0.08,
                              decoration: BoxDecoration(
                                color: Color(0xffffc107),
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.white54),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white54.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(5,5),
                                  ),
                                ],
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage("assets/images/googlelogo.png"),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  ),
                                  const SizedBox(width: 5.0,),
                                  const FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0,
                                        fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ),
            
                                ],
                              ),
                            ),
                          ),
                              ],
                            )
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        
      ),
    );
  }
}