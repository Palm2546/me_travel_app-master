// ignore_for_file: prefer_const_constructors, unnecessary_import, implementation_imports, unused_import, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_is_empty
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:me_travel_app/models/user.dart';
import 'package:me_travel_app/utils/db_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  //สร้างตัวควบคุม TextFiled เพื่อจะนำไปใช้ในการเขียนโค้ด
  TextEditingController fullnameCtrl = TextEditingController(text: '');
  TextEditingController emailCtrl = TextEditingController(text: '');
  TextEditingController phoneCtrl = TextEditingController(text: '');
  TextEditingController usernameCtrl = TextEditingController(text: '');
  TextEditingController passwordCtrl = TextEditingController(text: '');

  //สร้างตัวแปรควบคุมการแสดงรหัสผ่าน
  bool passwordShowFlag = true;

  //สร้างตัวแปรเพื่อใช้อ้างอิงกับรูปที่มาจาก Gallery/Camera เพื่อใช้แสดงที่หน้าจอ
  File? imgFile;

  //สร้างตัวแปรเก็บตำแหน่งรูปที่ถ่าย/เลือก เพื่อจะเก็บใน Database: Sqlite
  String pictureDir = '';

  //สร้างเมธอดเปิด Gallery
  selectImageFromGallery() async {
    //เลือกรูปจาก Gallery
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (img == null) return; //กรณีเปิด Gallery แล้วไม่เลือกให้ยกเลิก

    //จะเปลี่ยนชื่อรูปและนำรูปไปไว้ในไดเรคทอรี่ของแอป
    Directory directory = await getApplicationDocumentsDirectory();
    String newFileDir = directory.path + Uuid().v4();
    pictureDir = newFileDir; //กำหนดที่อยู่รูปให้กับตัวแปรที่สร้างไว้เพื่อเก็บใน Database

    //แสดงรูปที่หน้าจอ
    File imgFileNew = File(newFileDir);
    await imgFileNew.writeAsBytes(File(img.path).readAsBytesSync());
    setState(() {
      imgFile = imgFileNew;
    });
  }

  //สร้างเมธอดเปิด Camera
  selectImageFromCamera() async {
    //ถ่ายรูปจาก Camera
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (img == null) return; //กรณีเปิด Camera แล้วไม่ถ่ายให้ยกเลิก

    //จะเปลี่ยนชื่อรูปและนำรูปไปไว้ในไดเรคทอรี่ของแอป
    Directory directory = await getApplicationDocumentsDirectory();
    String newFileDir = directory.path + Uuid().v4();

    pictureDir = newFileDir; //กำหนดที่อยู่รูปให้กับตัวแปรที่สร้างไว้เพื่อเก็บใน Database

    //แสดงรูปที่หน้าจอ
    File imgFileNew = File(newFileDir);
    await imgFileNew.writeAsBytes(File(img.path).readAsBytesSync());
    setState(() {
      imgFile = imgFileNew;
    });
  }

  //สร้างเมธอดแสดง Dialog เป็นข้อความเตือน
  showWarningDialog(BuildContext context, String msg) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'คำเตือน',
            style: GoogleFonts.kanit(),
          ),
          content: Text(
            msg,
            style: GoogleFonts.kanit(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: GoogleFonts.kanit(),
              ),
            ),
          ],
        );
      },
    );
  }

  //สร้างเมธอดแสดง Dialog เป็นข้อความเมื่อทำงานเสร็จ
  Future showCompleteDialog(BuildContext context, String msg) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'ผลการทำงาน',
            style: GoogleFonts.kanit(),
          ),
          content: Text(
            msg,
            style: GoogleFonts.kanit(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: GoogleFonts.kanit(),
              ),
            ),
          ],
        );
      },
    );
  }

  //สร้างเมธอดบันทึกข้อมูล User
  saveUserToDB(context) async {
    int id = await DBHelper.createUser(
      User(
        fullname: fullnameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        username: usernameCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
        picture: pictureDir,
      ),
    );

    if (id != 0) {
      showCompleteDialog(context, 'บันทึกข้อมูลเรียบร้อยแล้ว').then((value) {
        Navigator.pop(context);
      });
    } else {
      showCompleteDialog(context, 'มีข้อผิดพลาดเกิดขึ้นในการบันทึกข้อมูล');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'ลงทะเบียนเข้าใช้งาน',
          style: GoogleFonts.kanit(),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  imgFile == null
                      ? CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.2,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.2,
                          backgroundImage: FileImage(
                            imgFile!,
                          ),
                        ),
                  IconButton(
                    onPressed: () {
                      //แสดงเป็น ModalBottom ให้ผู้ใช้เลือกว่าจะเป็น Gallery/Camera
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {
                                  //ถ่ายรูปจาก Camera
                                  selectImageFromCamera();
                                  //เมื่อเสร็จแล้วปิด Modal
                                  Navigator.pop(context);
                                },
                                leading: Icon(FontAwesomeIcons.camera),
                                title: Text(
                                  'ถ่ายรูป',
                                  style: GoogleFonts.kanit(),
                                ),
                              ),
                              Divider(),
                              ListTile(
                                onTap: () {
                                  //เลือกรูปจาก Gallery
                                  selectImageFromGallery();
                                  //เมื่อเสร็จแล้วปิด Modal
                                  Navigator.pop(context);
                                },
                                leading: Icon(Icons.camera),
                                title: Text(
                                  'เลือกรูป',
                                  style: GoogleFonts.kanit(),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.cameraRetro,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                  bottom: MediaQuery.of(context).size.width * 0.05,
                ),
                child: TextField(
                  controller: fullnameCtrl,
                  style: GoogleFonts.kanit(),
                  decoration: InputDecoration(
                    labelText: 'ชื่อ-สกุล',
                    labelStyle: GoogleFonts.kanit(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'ป้อนชื่อและนามสกุล',
                    hintStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                  bottom: MediaQuery.of(context).size.width * 0.05,
                ),
                child: TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.kanit(),
                  decoration: InputDecoration(
                    labelText: 'อีเมล์',
                    labelStyle: GoogleFonts.kanit(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'ป้อนอีเมล์',
                    hintStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                  bottom: MediaQuery.of(context).size.width * 0.05,
                ),
                child: TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.kanit(),
                  decoration: InputDecoration(
                    labelText: 'เบอร์โทร',
                    labelStyle: GoogleFonts.kanit(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'ป้อนเบอร์โทร',
                    hintStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                  bottom: MediaQuery.of(context).size.width * 0.05,
                ),
                child: TextField(
                  controller: usernameCtrl,
                  style: GoogleFonts.kanit(),
                  decoration: InputDecoration(
                    labelText: 'ชื่อผู้ใช้',
                    labelStyle: GoogleFonts.kanit(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'ป้อนชื่อผู้ใช้',
                    hintStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                  bottom: MediaQuery.of(context).size.width * 0.05,
                ),
                child: TextField(
                  controller: passwordCtrl,
                  obscureText: passwordShowFlag,
                  style: GoogleFonts.kanit(),
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    labelStyle: GoogleFonts.kanit(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'ป้อนรหัสผ่าน',
                    hintStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (passwordShowFlag == true) {
                            passwordShowFlag = false;
                          } else {
                            passwordShowFlag = true;
                          }
                        });
                      },
                      icon: Icon(
                        passwordShowFlag == true ? Icons.visibility_off : Icons.visibility,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              ElevatedButton(
                onPressed: () {
                  //Validate หน้าจอ ณ ที่นี้คือ ตรวจสอบว่าป้อนครบไหม เลือก/ถ่ายรูปยัง
                  //หากยังให้แสดง Dialog เตือน
                  //ป้อนครบเรียบร้อยแล้ว ให้บันทึกลง Database: SQLite แล้วกลับไปหน้า Login
                  if (fullnameCtrl.text.trim().length == 0) {
                    //หรือใช้ if (fullnameCtrl.text.trim().isEmpty)
                    showWarningDialog(context, 'ป้อนชื่อ-สกุลด้วย....');
                  } else if (emailCtrl.text.trim().length == 0) {
                    showWarningDialog(context, 'ป้อนอีเมล์ด้วย....');
                  } else if (phoneCtrl.text.trim().length == 0) {
                    showWarningDialog(context, 'ป้อนเบอร์โทรด้วย....');
                  } else if (usernameCtrl.text.trim().length == 0) {
                    showWarningDialog(context, 'ป้อนชื่อผู้ใช้ด้วย....');
                  } else if (passwordCtrl.text.trim().length == 0) {
                    showWarningDialog(context, 'ป้อนรหัสผ่านด้วย....');
                  } else if (pictureDir.length == 0) {
                    showWarningDialog(context, 'เลือกหรือถ่ายรูปด้วย....');
                  } else {
                    //ผ่าน if ทั้งหมดมาได้แปลว่าพร้อมที่จะนำข้อมูลเก็บลง Database: Sqlite
                    saveUserToDB(context);
                  }
                },
                child: Text(
                  'ลงทะเบียน',
                  style: GoogleFonts.kanit(),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.7,
                    MediaQuery.of(context).size.width * 0.125,
                  ),
                  backgroundColor: Colors.amber,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
