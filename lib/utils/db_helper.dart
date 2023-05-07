//ไฟล์นี้เป็นไฟล์ที่จะทำงานกับ Database: Sqlite
//ทั้งการสร้าง Database, สร้าง Table
//ทั้งการเพิ่ม ลบ แก้ไข ค้นหา ดู ดึง ข้อมูลจาก Table

// ignore_for_file: prefer_is_empty

import 'package:me_travel_app/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  //โค้ดคำสั่งสร้าง database ***
  static Future<Database> db() async {
    return openDatabase(
      'metravelapp.db',
      version: 1,
      onCreate: (Database database, int version) async {
        await createTable(database);
      },
    );
  }

  //โค้ดคำสั่งสร้าง table ***
  static Future<void> createTable(Database database) async {
    await database.execute("""
        CREATE TABLE usertb(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          fullname TEXT,
          email TEXT,
          phone TEXT,
          username TEXT,
          password TEXT,
          picture TEXT
        )
      """);
  }

  //------------------------------------------------------------
  //โค้ดคำสั่ง เพิ่ม ลบ แก้ไข ค้นหา ดู ดึง ข้อมูลจาก Table (อันนี้จะเยอะหน่อย)
  //สร้างเมธอด เพิ่มข้อมูลลงตาราง usertb
  static Future<int> createUser(User user) async {
    //ติดต่อ Database
    final db = await DBHelper.db();

    //เพิ่มข้อมูลลง Table ใน Database
    final id = await db.insert(
      'usertb',
      user.toMap(),
    );

    return id;
  }

  //สร้างเมธอด signin โดยดูข้อมูลจากตาราง usertb
  static Future<User?> signinUser(String? username, String? password) async {
    //ติดต่อ Database
    final db = await DBHelper.db();

    //เอาข้อมูล username, password ที่ส่งมาไปดูว่ามีในตาราง usertb ไหม
    List<Map<String, dynamic>> result = await db.query(
      'usertb',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    //ตรวจสอบผลการดูข้อมูลว่ามีไหม
    if (result.length > 0) {
      return User.fromMap(result[0]);
    } else {
      return null;
    }
  }
}
