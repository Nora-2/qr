// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_app/core/widgets/AwesomeDiaglog.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;
  final StreamController<List<Map<String, dynamic>>> _qrcodesController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception('Could not access external storage directory.');
    }

    String path = '${directory.path}/QRCodes.db';
    print('Database path: $path');
    return await openDatabase(
      path,
      version: 2, // Increment the version number
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE qrcodes (
            id INTEGER PRIMARY KEY,
            qrCode TEXT,
            datetime TEXT,
            Company TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE companies(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            company TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE companies(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              company TEXT
            )
          ''');
           await db.execute('''
            ALTER TABLE qrcodes ADD COLUMN  Company TEXT
          ''');
        }
      },
    );
  }

 // Method to add a company if it doesn't already exist
Future<void> addCompany(String company) async {
    final db = await database;

    // Check if the company already exists
    List<Map<String, dynamic>> existingCompanies = await db.query(
      'companies',
      where: 'company = ?',
      whereArgs: [company],
    );

    // If the company doesn't exist, insert it
    if (existingCompanies.isEmpty) {
      await db.insert('companies', {'company': company});
      print('Company added: $company');
    } else {
      throw Exception('Company already exists');
    }
  }

  // Method to get all companies
  Future<List<Map<String, dynamic>>> getAllCompanies() async {
    final db = await database;
    return await db.query('companies');
  }

  // Method to update a company
  Future<void> updateCompany(int id, String newName) async {
    final db = await database;
    await db.update('companies', {'company': newName}, where: 'id = ?', whereArgs: [id]);
  }

  // Method to delete a company
  Future<void> deleteCompany(int id) async {
    final db = await database;
    await db.delete('companies', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> initDatabase() async {
    await _initDatabase();
  }

  Stream<List<Map<String, dynamic>>> get qrcodesStream =>
      _qrcodesController.stream;

  Future<int> insertQRCode(Map<String, dynamic> row) async {
    Database db = await database;
    int id = await db.insert('qrcodes', row);
    await _updateQRCodesStream();
    return id;
  }

  Future<List<Map<String, dynamic>>> queryAllQRCodes() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('qrcodes');
    return result;
  }

  Future<int> updateQRCode(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    int result =
        await db.update('qrcodes', row, where: 'id = ?', whereArgs: [id]);
    await _updateQRCodesStream();
    return result;
  }

  Future<int> deleteQRCode(int id) async {
    Database db = await database;
    int result = await db.delete('qrcodes', where: 'id = ?', whereArgs: [id]);
    await rearrangeIds(); // Rearrange IDs after deletion
    await _updateQRCodesStream();
    return result;
  }

  Future<void> deleteAllQRCodes() async {
    Database db = await database;
    await db.delete('qrcodes');
    await resetIds(); // Reset IDs after deleting all
    await _updateQRCodesStream();
  }

  Future<void> _updateQRCodesStream() async {
    List<Map<String, dynamic>> qrcodes = await queryAllQRCodes();
    _qrcodesController.sink.add(qrcodes);
  }

  Future<void> rearrangeIds() async {
    Database db = await database;
    List<Map<String, dynamic>> qrcodes = await queryAllQRCodes();
    Batch batch = db.batch();

    for (int i = 0; i < qrcodes.length; i++) {
      batch.update(
        'qrcodes',
        {'id': i + 1},
        where: 'id = ?',
        whereArgs: [qrcodes[i]['id']],
      );
    }

    await batch.commit(noResult: true);
    await _updateQRCodesStream();
  }

  Future<void> resetIds() async {
    Database db = await database;
    await db
        .delete('sqlite_sequence', where: 'name = ?', whereArgs: ['qrcodes']);
    await _updateQRCodesStream();
  }

  void dispose() {
    _qrcodesController.close();
  }

  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null; // Reset database instance
    }
  }

  Future<List<Map<String, dynamic>>> queryQRCodeById(String id) async {
    final db = await database;
    return await db.query(
      'qrcodes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<String>> fetchCompanyNames() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT DISTINCT Company FROM qrcodes');
    
    List<String> companyNames = List.generate(maps.length, (i) {
      return maps[i]['Company'] as String;
    });

    return companyNames;
  }

  Future<void> deleteselectedData(List<int> docIds, BuildContext context) async {
    try {
      final db = await _initDatabase();
      
      // Use batch for efficient multiple deletions
      Batch batch = db.batch();
      
      for (int docId in docIds) {
        batch.delete(
          'qrcodes',
          where: 'id = ?',
          whereArgs: [docId],
        );
      }
      
      await batch.commit(noResult: true);
      await rearrangeAndSetCurrentId();
      
      // Display success dialog
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Success',
        description: 'All Barcodes deleted successfully! \n تم حذف الباركود كل بنجاح',
        buttonColor: const Color(0xff00CA71),
      ).show();
    } catch (e) {
      // Display error dialog
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        description: 'Error deleting the selected Barcodes',
        buttonColor: const Color(0xffD93E47),
      ).show();

      print('Error in deleteData: $e');
    }
  }

  Future<void> rearrangeAndSetCurrentId() async {
    final db = await _initDatabase();
    
    // Fetch all records ordered by current ID
    List<Map<String, dynamic>> allRecords = await db.query(
      'qrcodes',
      orderBy: 'id',
    );

    // Reset IDs in sequence
    Batch batch = db.batch();
    for (int i = 0; i < allRecords.length; i++) {
      batch.update(
        'qrcodes',
        {'id': i + 1},
        where: 'id = ?',
        whereArgs: [allRecords[i]['id']],
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> queryQRCodeBytime(String datetime) async {
    final db = await database;
    return await db.query(
      'qrcodes',
      where: 'datetime LIKE ?',
      whereArgs: ['%$datetime%'],
    );
  }

  Future<List<Map<String, dynamic>>> queryQRCodeBycode(String qrCode) async {
    final db = await database;
    return await db.query(
      'qrcodes',
      where: 'qrCode = ?',
      whereArgs: [qrCode],
    );
  }

  Future<List<Map<String, dynamic>>> queryQRCodeBycompainy(String company) async {
    final db = await database;
    return await db.query(
      'qrcodes',
      where: 'Company = ?',
      whereArgs: [company],
    );
  }
}
  