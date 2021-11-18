import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sona_magazine/screens/admin/update.dart';
import 'package:sona_magazine/screens/admin/upload.dart';
import 'package:sona_magazine/screens/sigup.dart';
import 'package:sona_magazine/services/auth.dart';
import 'package:sona_magazine/services/database.dart';
import 'package:sona_magazine/services/preferences.dart';
class FirebaseItems extends StatefulWidget {
  const FirebaseItems({ Key? key }) : super(key: key);

  @override
  _FirebaseItemsState createState() => _FirebaseItemsState();
}

class _FirebaseItemsState extends State<FirebaseItems> {

  Database db = Database();
  AuthMethods authMethods = AuthMethods();
  SharedPreferenceFunctions sharedPreferenceFunctions = SharedPreferenceFunctions();
  List docs = [];
  initialise()async{
    db.read().then((value){
      setState(() {
        docs = value;
      });
    });
  }
  signOut()async{
    await authMethods.signOut();
    await sharedPreferenceFunctions.SignOutSharedPreference();
    setState(() {
      sharedPreferenceFunctions.isUserLoggedIn(false);
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUp()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialise();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xffd17842),
        centerTitle: true,
       title: Text(
          "INFOZYN",
          style: GoogleFonts.graduate(
              textStyle: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  letterSpacing: 1
                  )
              ),
        ),
         actions: [
            GestureDetector(
              onTap: (){
                signOut();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: const Icon(
                  Icons.vpn_key_sharp
                ),
              ),
            ),
          ],
      ),
      body:Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.white54,
                margin: EdgeInsets.all(10),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UpdateOperation(data: docs[index], db: db)))
                        .then((value) => {
                              if (value != null) {initialise()}
                            });
                  },
                  contentPadding: EdgeInsets.only(right: 30, left: 36),
                  title: Text(
                    docs[index]['eventname'],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: (){
                      showDialog(
                        context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Delete"),
                            content: Text("do you really want to delete this post ?"),
                            actions: [
                              TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      // style: TextStyle(color: Colors.white),
                                    )),
                              TextButton(
                                    onPressed: ()async {
                                      db.delete(docs[index]['id']);
                                      await initialise();
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(
                                      "Confirm",
                                      // style: TextStyle(color: Colors.white),
                                    )),
                            ],
                          );
                        });
                    },
                    child: Icon(
                      Icons.delete,color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
            child: ElevatedButton(
              onPressed: (){
                initialise();
              },
             child: Text("Refresh")
             ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffd17842),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatePost()));   
          initialise();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add,color: Colors.white,size: 35,),
        ),
      
    );
  }
}