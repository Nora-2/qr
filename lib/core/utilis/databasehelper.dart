import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    String path = join(await getDatabasesPath(), 'qrcodes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE qrcodes (
            id INTEGER PRIMARY KEY,
            qrCode TEXT,
            datetime TEXT
          )
        ''');
      },
    );
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
  Future<List<Map<String, dynamic>>> queryQRCodes(String query) async {
    final db = await database;

   
    return await db.query(
      'qrcodes',
      where:  'id LIKE ? OR qrCode LIKE ? or datetime LIKE ?',
      
         whereArgs:  ['%$query%', '%$query%','%$query%']
          
    );
  }


  Future<List<Map<String, dynamic>>> queryQRCodeById(String id) async {
    final db = await database;
    return await db.query(
      'qrcodes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

 Future<List<Map<String, dynamic>>> queryQRCodeBytime(String datetime) async {
  final db = await database;
  // Assuming datetime format is 'YYYY/MM/DD-HH:MM'
  // Extract the date part for comparison
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
}
