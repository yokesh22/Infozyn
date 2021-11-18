import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database{
List name = [];
List downurl = [];

 getDataFromFirestore()async{
   List items = [];
   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
   final res = await firebaseFirestore.collection("wrapper").doc().snapshots();
   return res;
 }

   Future getlastestfeed() async {
    List items=[];
    await FirebaseFirestore.instance.collection("wrapper").orderBy('realdate',descending: true).get().then((querysnapshots){
      querysnapshots.docs.forEach((element) {
        items.add(element.data());
      });
    });
    return items;
  }


    Future searchCategory(categoryname) async {
    List items=[];
    await FirebaseFirestore.instance.collection("wrapper").where('categoryname',isEqualTo: categoryname).
    get().then((querysnapshots){
      querysnapshots.docs.forEach((element) {
        items.add(element.data());
      });
    });
    return items;
  }

    Future searchEvent(eventname) async {
    List items=[];
    await FirebaseFirestore.instance.collection("wrapper").where('eventname',isEqualTo: eventname).
    get().then((querysnapshots){
      querysnapshots.docs.forEach((element) {
        items.add(element.data());
      });
    });
    return items;
  }


  uploadLikes(int likes,docname)async{
    String docid = docname.toString();
    var res = await FirebaseFirestore.instance.collection("wrapper").doc(docid).update({'likes':likes});
    return res;
  }

  //CRUD operations.....

  uploadImage(image,filename,title,description,date,time,categoryName,eventName,docname)async{
    String url;
    String doc = eventName.toString();
    if(image!=null){
      final destination = 'images/$filename';
      try{
        Reference reference = FirebaseStorage.instance.ref(destination);
        final FirebaseAuth auth = FirebaseAuth.instance;
        UploadTask uploadTask = reference.putFile(image);
        uploadTask.whenComplete(()async{
          try{
             url = await reference.getDownloadURL();
             await FirebaseFirestore.instance.collection("wrapper").doc(doc).set({
                "title": title,
                 "description":description,
                 "date":date,
                 "time":time,
                 "imageurl": url,
                 "realdate": DateTime.now(),
                 "likes": 0,
                 "categoryname":categoryName,
                 "eventname":eventName
             });

          }catch(e){
            e.toString();
          }
        });
        name.add(filename);
      }catch(e){
        e.toString();
      }
    }
  }

   Future<List> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
          await FirebaseFirestore.instance.collection('wrapper').orderBy('realdate',descending: true).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "eventname": doc['eventname'],
            "imageurl": doc["imageurl"],
            "title":doc['title'],
            "description":doc['description'],
            "time":doc['time'],
            "date":doc['date'],
            "categoryname":doc['categoryname']
              };
          docs.add(a);
        }
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }

   Future<void> update(id,title,description,date,time,categoryName,eventName) async {
      
              try{
             await FirebaseFirestore.instance.collection("wrapper").doc(id).update({
                "title": title,
                 "description":description,
                 "date":date,
                 "time":time,
                 "realdate": DateTime.now(),
                 "categoryname":categoryName,
                 "eventname":eventName
             });

          }catch(e){
            e.toString();
          }
        }

    Future<void> delete(String id) async {
    try {
      await FirebaseFirestore.instance.collection("wrapper").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }
} 

