// ignore_for_file: unnecessary_import, implementation_imports, unused_import, prefer_const_constructors, sort_child_properties_last, prefer_is_empty, unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_travel_app/models/user.dart';
import 'package:me_travel_app/utils/db_helper.dart';
import 'package:me_travel_app/views/register_ui.dart';
import 'package:me_travel_app/views/travel_home_ui.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  //สร้างตัวแปร(ตัว Controller) ไว้เก็บค่าจาก TextField
  TextEditingController usernameCtrl = TextEditingController(text: '');
  TextEditingController passwordCtrl = TextEditingController(text: '');

  //สร้างตัวแปรที่ใช้กับการเปิดปิดการมองเห็นรหัสผ่าน
  bool isShowPassword = false;

  //สร้างเมธอดแสดง Dialog ข้อความเตือน
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

  //สร้างเมธอด checkSignin เพื่อตรวจสอบ username และ password
  checkSignin(BuildContext context) async {
    //ตรวจสอบว่า username และ password มีในฐานข้อมูลหรือไม่
    //โดยจะเก็บผลลัพธ์ไว้ในตัวแปร
    User? user = await DBHelper.signinUser(
      usernameCtrl.text,
      passwordCtrl.text,
    );

    //ถ้า user เป็น null แสดงว่า username หรือ password ไม่ถูกต้อง
    if (user == null) {
      //แสดง Dialog เตือน แปลว่า username/pasword ไม่ถูกต้อง
      showWarningDialog(context, 'username/pasword ไม่ถูกต้อง');
    } else {
      //แปลว่า username/pasword ถูกต้อง เปิดไปหน้า TravelHomeUI
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TravelHomeUI(user: user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'บันทึกการเดินทาง',
          style: GoogleFonts.kanit(),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.08,
              ),
              Text(
                'เข้าใช้งานแอปพลิเคชัน',
                style: GoogleFonts.kanit(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              Text(
                'บันทึกการเดินทาง',
                style: GoogleFonts.kanit(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  color: Colors.amber,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.08,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                ),
                child: Row(
                  children: [
                    Text(
                      'ชื่อผู้ใช้ :',
                      style: GoogleFonts.kanit(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                ),
                child: TextField(
                  controller: usernameCtrl,
                  style: GoogleFonts.kanit(),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                ),
                child: Row(
                  children: [
                    Text(
                      'รหัสผ่าน :',
                      style: GoogleFonts.kanit(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                ),
                child: TextField(
                  controller: passwordCtrl,
                  style: GoogleFonts.kanit(),
                  obscureText: !isShowPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      icon: isShowPassword == true
                          ? Icon(
                              Icons.visibility,
                              color: Colors.amber,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Colors.amber,
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.125,
              ),
              ElevatedButton(
                onPressed: () {
                  //Validate ค่าที่รับมาจาก TextField ว่าว่างหรือไม่
                  // if (usernameCtrl.text.isEmpty) { หรือ
                  if (usernameCtrl.text.trim().length == 0) {
                    showWarningDialog(context, 'กรุณากรอกชื่อผู้ใช้');
                  } else if (passwordCtrl.text.isEmpty) {
                    showWarningDialog(context, 'กรุณากรอกรหัสผ่าน');
                  } else {
                    //ถ้าไม่ว่างให้ทำการเช็คค่าที่รับมาว่าตรงกับข้อมูลในฐานข้อมูลหรือไม่
                    //ถ้าตรงให้ทำการเข้าสู่ระบบ เปิดไปหน้าจอถัดไป TravelHomeUI
                    //ถ้าไม่ตรงให้แสดง Dialog แจ้งเตือน
                    checkSignin(context);
                  }
                },
                child: Text(
                  'SIGN IN',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (val) {},
                  ),
                  Text(
                    'จำค่าการเข้าใช้งานแอปพลิเคชัน',
                    style: GoogleFonts.kanit(),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.025,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterUI(),
                    ),
                  );
                },
                child: Text(
                  'ลงทะเบียนเข้าใช้งาน',
                  style: GoogleFonts.kanit(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
