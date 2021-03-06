import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sona_magazine/screens/userpanel/datetime.dart';
import 'package:sona_magazine/screens/sigup.dart';
import 'package:sona_magazine/services/auth.dart';
import 'package:sona_magazine/services/preferences.dart';
import 'package:intl/intl.dart';
import 'package:sona_magazine/services/database.dart';
import 'package:path/path.dart' as Path ;
class CreatePost extends StatefulWidget {
  const CreatePost({ Key? key }) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late double _height;
  late double _width;
  
  final FirebaseAuth auth = FirebaseAuth.instance;
  Database uploadData = Database();
  CustomDate customDate = CustomDate();
  var date = DateTime.now();

  bool isImageAvaliable = false;
  bool isTitleFilled = false;
  bool isDescriptionFilled = false;
  bool isDateFilled = false;
  bool isTimeFilled = false;
  
  String imagePath="";
  File? file;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  late double height;
  late double width;
  late String setTime, setDate;
  late String hour, minute, time;
  late String dateTime;
  String? filename,imagename ;
  // ignore: unused_field
  var category;
  var academicyear;
  var academiccategory;
  var docid;
  var x;
   DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
List images = [];

getdocid(String name){
  return name;
}
  pickImage(source)async{
    final selectedImage = await picker.pickImage(source: source);
    if(selectedImage != null){
      final imagepath = selectedImage.name.toString();
      File? croppedFile = await ImageCropper.cropImage(
        sourcePath: selectedImage.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ),
        );
        if(croppedFile != null){
            setState(() {
        imagePath = croppedFile.path;
        imagename = selectedImage.path;
        file = croppedFile;
        filename=Path.basename(file!.path);
        images.add(filename);
      });
        }
    }
  }

  selectPhoto()async{
    await showModalBottomSheet(
                context: context, builder: (context)=>BottomSheet(
                   builder: (context)=> Container(
                     height: MediaQuery.of(context).size.height*0.2,
                     child: Column(
                       children: [
                         ListTile(
                           leading: Icon(Icons.camera),
                           title: Text("camera"),
                           onTap: (){
                             Navigator.of(context).pop();
                             pickImage(ImageSource.camera);
                             setState(() {
                          isImageAvaliable = true;
                        });
                           },
                         ),
                         ListTile(
                           leading: Icon(Icons.filter),
                           title: Text("gallery"),
                           onTap: (){
                             Navigator.of(context).pop();
                             pickImage(ImageSource.gallery);
                             setState(() {
                          isImageAvaliable = true;
                        });
                           },
                         ),
                       ],
                     ),
                   ), onClosing: () {  },
                  )
                );

  }

  
 
  currentUser()async{
    final User? user = auth.currentUser;
    final email = user!.email;
    print(email.toString());
  }
  
  selectDate(BuildContext context)async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat.yMd().format(selectedDate);
        x = Timestamp.fromDate(selectedDate);
      });
    }
  }
   Future<Null> selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: selectedTime,
  );
  if (picked != null) {
    setState(() {
      selectedTime = picked;
      hour = selectedTime.hour.toString();
      minute = selectedTime.minute.toString();
      time = hour + ' : ' + minute;
      timeController.text = time;
      timeController.text = formatDate(
          DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
          [hh, ':', nn, " ", am]).toString();
    });
  }}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
       appBar: AppBar(
        backgroundColor:  Color(0xffd17842),
        centerTitle: true,
        leading:GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,color: Colors.black
          ),
        ),
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
      ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                imagePath != ""?Column(
                  children: [
                    Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.3,
                    padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                    child: Image.file(File(imagePath),fit: BoxFit.contain,),
              ),
                Container(
                alignment: Alignment.center,
                child: Text(filename!),
              ),
                  ],
                ):Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add_photo_alternate_outlined,size: 50,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                child: ElevatedButton(
                  
                  onPressed: (){
                    selectPhoto();
                    
                  },
                  child: Text("select image"),
                ),
              ),
    
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Title",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                child: TextField(
                  
                  autofocus: false,
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (val){
                    setState(() {
                      isTitleFilled==true;
                    });
                  },
                  decoration: InputDecoration(
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
              SizedBox(height: 10.0,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Description",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                child: TextField(
                  onChanged: (val){
                    setState(() {
                      isDescriptionFilled==true;
                    });
                  },
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
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
              SizedBox(height: 10.0,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Event Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                child: TextField(
                  onChanged: (val){
                    setState(() {
                      isDescriptionFilled==true;
                    });
                  },
                  controller: eventNameController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                child: Text(
                  "[ Note : Event Name Should be Unique ]",
                  style: TextStyle(
                    color: Colors.red
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Academic Year & Archive category",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10.0)),
                margin:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                padding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: academicyear,
                    elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: <String>[
                      '2018 - 2019',
                      '2019 - 2020',
                      '2020 - 2021',
                      '2021 - 2022',
                      '2022 - 2023',
                      '2023 - 2024',
                      '2024 - 2025',
                      '2025 - 2026',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Academic Year ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (value) {
                      setState(() {
                        academicyear = value!;
                      });
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10.0)),
                margin:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                padding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: academiccategory,
                    elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: <String>[
                      'Fine Arts',
                      'Awards',
                      'Upcoming Events',
                      'Funded Projects',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Academic Category ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (value) {
                      setState(() {
                        academiccategory = value!;
                      });
                    },
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Category",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: category,
                    elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: <String>[
                      'Technology',
                      'Sports',
                      'Placement',
                      'Institution',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Please select a Category",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (value) {
                      setState(() {
                        category = value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "choose Date and time when the event was Organized",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "select Date",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            selectDate(context);
                          },
                          child: Container(
                            width: width*0.4,
                            height: height*0.08,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0)
                              ),
                            child: TextFormField(
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: dateController,
                              onSaved: (val) {
                                setDate = val!;
                                setState(() {
                                  isDateFilled == true;
                                });
                              },
                              decoration: const InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  // labelText: 'Time',
                                  contentPadding: EdgeInsets.only(top: 0.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "select time",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        InkWell(
                    onTap: () {
                      selectTime(context);
                    },
                    child: Container(
                      width: width*0.4,
                      height: height*0.08,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: TextFormField(
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                        onSaved: ( val) {
                          setTime = val!;
                          setState(() {
                            isTimeFilled == true;
                          });
                        },
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: timeController,
                        decoration: const InputDecoration(
                            disabledBorder:
                                UnderlineInputBorder(borderSide: BorderSide.none),
                            // labelText: 'Time',
                            contentPadding: EdgeInsets.all(5)),
                      ),
                    ),
                  ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: height*0.13,
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 30.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: ElevatedButton(
                  onPressed: ()async{
                    if (isImageAvaliable == true &&
                        titleController.text != "" &&
                        descriptionController.text != "" &&
                        dateController.text != "" &&
                        timeController.text != "" &&
                        category.toString() != "" &&
                        academicyear.toString() !=""&&
                        academiccategory.toString() !="" &&
                        eventNameController.text != "") {
                      await uploadData.uploadImage(
                          file,
                          filename,
                          titleController.text,
                          descriptionController.text,
                          x,
                          timeController.text,
                          category.toString().toLowerCase(),
                          eventNameController.text.toLowerCase(),
                          eventNameController.text.toUpperCase(),
                          academicyear.toString(),
                          academiccategory.toString().toLowerCase(),
                        );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("uploaded successfully")),
                      );
                      Navigator.of(context).pop();
                    } else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("all field must be field")),
                      );
                    }
                   
                  },
                  child: Text("Upload"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('academic', academicyear));
  }
}
