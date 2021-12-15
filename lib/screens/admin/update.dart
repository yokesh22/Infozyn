import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sona_magazine/screens/userpanel/datetime.dart';
import 'package:sona_magazine/services/database.dart';
import 'package:path/path.dart' as Path ;
class UpdateOperation extends StatefulWidget {
  UpdateOperation({ Key? key ,required this.data,required this.db }) : super(key: key);
  Map data;
  Database db;

  @override
  _UpdateOperationState createState() => _UpdateOperationState();
}

class _UpdateOperationState extends State<UpdateOperation> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  CustomDate customDate = CustomDate();
  var date = DateTime.now();
  var x;


  
  late String setTime, setDate;
  late String hour, minute, time;
  late String dateTime;
  late String filename,imagename ;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
List images = [];
var category;
  
  String imagePath="";
  File? file;
  final picker = ImagePicker();

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
                             
                           },
                         ),
                         ListTile(
                           leading: Icon(Icons.filter),
                           title: Text("gallery"),
                           onTap: (){
                             Navigator.of(context).pop();
                             pickImage(ImageSource.gallery);
                             
                           },
                         ),
                       ],
                     ),
                   ), onClosing: () {  },
                  )
                );

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
    titleController.text = widget.data['title'];
    descriptionController.text = widget.data['description'];
    // dateController.text = widget.data['date'];
    Timestamp y = widget.data['date'];
    DateTime dateTime = DateTime.parse(y.toDate().toString());
    dateController.text = DateFormat().add_yMd().format(dateTime);
    timeController.text = widget.data['time'];
    eventNameController.text = widget.data['eventname'];
    imagePath = widget.data['imageurl'];
    filename = "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.blue,
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
      body: GestureDetector(
        onTap:(){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:10),
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
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.08,
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
                        width: MediaQuery.of(context).size.width*0.4,
                        height: MediaQuery.of(context).size.height*0.08,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          onSaved: ( val) {
                            setTime = val!;
                            
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
                  height: MediaQuery.of(context).size.height*0.13,
                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 30.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: ElevatedButton(
                    onPressed: ()async{
                      if (
                          titleController.text != "" &&
                          descriptionController.text != "" &&
                          dateController.text != "" &&
                          timeController.text != "" &&
                          category.toString() != "" &&
                          eventNameController.text != "") {
                        await widget.db.update(
                            widget.data['id'],
                            titleController.text,
                            descriptionController.text,
                            x,
                            timeController.text,
                            category.toString().toLowerCase(),
                            eventNameController.text.toLowerCase(),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("uploaded successfully")),
                        );
                      } else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("all field must be field")),
                        );
                      }
                     
                    },
                    child: Text("Update"),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}