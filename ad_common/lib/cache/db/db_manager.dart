import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DBManager {
  static Database? _db;
  static const String DB_NAME = "flutter_db";

  static final _lock = Lock();

  static Future<Database?> getDatabase() async {
    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) await init();
      });
    }
    return _db;
  }

  /// 初始化数据库并创建对应的表
  static Future<void> init({
    int version = 1,
    String name = DB_NAME,
    OnDatabaseVersionChangeFn? changeCallback,
  }) async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "/" + DB_NAME;
    // 根据数据库文件路径和数据库版本号创建数据库表
    _db = await openDatabase(
      path,
      version: version,
      onUpgrade: changeCallback,
    );
  }
}
