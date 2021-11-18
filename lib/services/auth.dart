import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sona_magazine/screens/userpanel/userpanel.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  signIn(String email,String password)async{
    try{
       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password
      );
       return userCredential.user!.uid;
    }on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  signOut()async{
    try{
      return _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}
//Google signIn....
//
// class AuthClass {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'email',
//       'https://www.googleapis.com/auth/contacts.readonly',
//     ],
//   );
//
//   Future<void> googleSignIn(BuildContext context) async {
//     try {
//       GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
//       if(googleSignInAccount != null){
//         GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;
//
//         AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );
//
//         try{
//           UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const HomePage()), (route) => false);
//         }catch(e){
//           final snackBar = SnackBar(content: Text(e.toString()));
//           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//
//         }
//       }
//       else{
//         const snackBar = SnackBar(content: Text("Not able to signin"));
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       }
//     }catch(e){
//       final snackBar = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }
// }
class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }
}