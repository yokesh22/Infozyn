import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceFunctions{

  final String emailSharedPreference = "userEmail";
  final String userLoggedInSharedPreference = "ISLOGGEDIN";

  isUserLoggedIn(bool isLoggedIn)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res = sharedPreferences.setBool(userLoggedInSharedPreference, isLoggedIn);
    return res;
  }

    saveUserEmail(String userEmailId)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res = sharedPreferences.setString(emailSharedPreference, userEmailId);
    return res;
  }

  getUserLoggedIn()async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res = sharedPreferences.getBool(userLoggedInSharedPreference);
    return res;
  }

   getUserEmail()async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res = sharedPreferences.getString(emailSharedPreference);
    return res;
  }
  SignOutSharedPreference()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var res = sharedPreferences.remove(emailSharedPreference);
  return res;
  }
}