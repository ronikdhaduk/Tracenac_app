import 'dart:convert';
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///----- Working Ok For ----///

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    log("My LogData ==> _initDatabase path $databasesPath");
    final path = join(databasesPath, 'my_database.db');
    log("My LogData ==> _initDatabase path $path");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE dealers (
        id INTEGER PRIMARY KEY,
        Name TEXT,
        DealerId INTEGER,
        Creation_Type INTEGER
      )
    ''');

        await db.execute('''
          CREATE TABLE reports (
            id INTEGER PRIMARY KEY,
            DealerId INTEGER,
            ReportId TEXT,
            Last Ins Date TEXT,
            Creation_Type INTEGER,
            FOREIGN KEY (DealerId) REFERENCES dealers(DealerId)
            
          )
          ''');
        await db.execute('''
          CREATE TABLE products_data (
            id INTEGER PRIMARY KEY,
            ReportId TEXT,
            Creation_Type TEXT, 
            Last Ins Date TEXT,
            ScanCode TEXT,
            Product TEXT,
            Unit TEXT,
            Fake TEXT,
            warrenty_already_claimed TEXT,
            out_of_warenty TEXT,
            item_in_warenty TEXT,
            FOREIGN KEY (ReportId) REFERENCES reports(ReportId)
          )
          ''');
        await db.execute('''
          CREATE TABLE scan_data (
            id INTEGER PRIMARY KEY,
            ReportId TEXT,
            Creation_Type TEXT,
            ScanCode TEXT,                        
            Product TEXT,
            Scan LIST,
            Unit TEXT,
            Fake TEXT,
            warrenty_already_claimed TEXT,
            out_of_warenty TEXT,
            item_in_warenty TEXT,
            FOREIGN KEY (ReportId) REFERENCES reports(ReportId)
          )
          ''');

        await db.execute('''
    CREATE TRIGGER delete_report_if_no_product_data
    AFTER DELETE ON products_data
    FOR EACH ROW
    WHEN NOT EXISTS (
      SELECT 1
      FROM products_data
      WHERE ReportId = OLD.ReportId
    )
    BEGIN
      DELETE FROM reports WHERE id = OLD.ReportId;
    END
  ''');
      },
    );
  }

  Future<void> insertDealer(dealerName, dealerId, Creation) async {
    log("My LogData ==> insertDealer $dealerId");
    final db = await database;
    // await db.insert('dealers', {'Name': dealerName, 'DealerId': dealerId});

    // Check if the dealer exists
    final existingDealers = await db.query(
      'dealers',
      where: 'DealerId = ?',
      whereArgs: [dealerId],
    );

    log("My LogData ==> insertOrUpdateReport 2  ${existingDealers.toString()}");

    if (existingDealers.isEmpty) {
      // Dealer doesn't exist, insert dealer data
      await db.insert('dealers', {
        'Name': dealerName,
        'DealerId': dealerId,
        'Creation_Type': Creation,
      });

      log(
        "My LogData ==> insertOrUpdateReport 3  ${existingDealers.toString()}",
      );
    }
  }

  Future<void> insertReport(dealerId, reportId, Creation) async {
    log("My LogData ==> insertReport $reportId");
    final db = await database;

    final existingReports = await db.query(
      'reports',
      where: 'DealerId = ? AND ReportId = ?',
      whereArgs: [dealerId, reportId],
    );
    log("My LogData ==> insertOrUpdateReport 4  ${existingReports.toString()}");
    if (existingReports.isEmpty) {
      // Report doesn't exist, insert report and product data
      final reportData = {
        'DealerId': dealerId,
        'ReportId': reportId,
        'Creation_Type': Creation,
      };
      log("My LogData ==> insertOrUpdateReport 11  ${reportData.toString()}");

      await db.insert('reports', reportData);
    }
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('products', product);
  }

  Future<List<Map<String, dynamic>>> getDealers() async {
    final db = await database;
    return await db.query('dealers');
  }

  Future<List<Map<String, dynamic>>> getReportsByDealerId(int dealerId) async {
    final db = await database;
    return await db.query(
      'reports',
      where: 'DealerId = ?',
      whereArgs: [dealerId],
    );
  }

  Future<List<Map<String, dynamic>>> getScanProductsByReportId(
    String reportId,
  ) async {
    final db = await database;
    return await db.query(
      'scan_data',
      where: 'ReportId = ?',
      whereArgs: [reportId],
    );
  }

  Future<List<Map<String, dynamic>>> getManualProductsByReportId(
    String reportId,
  ) async {
    final db = await database;
    return await db.query(
      'products_data',
      where: 'ReportId = ?',
      whereArgs: [reportId],
    );
  }

  Future<void> addOrUpdateReportDate(
    String reportId,
    lastInspectionDate,
  ) async {
    final db = await instance.database;

    final existingReport = await db.rawQuery(
      'SELECT * FROM reports WHERE ReportId = ?',
      [reportId],
    );
    if (existingReport.isNotEmpty) {
      // Update existing report
      await db.rawUpdate('UPDATE reports SET Last = ? WHERE ReportId = ?', [
        lastInspectionDate,
        reportId,
      ]);
    }
  }

  Future<String?> getReportLastDate(String reportId) async {
    final db = await database;
    final result = await db.query(
      'reports',
      where: 'ReportId = ?',
      whereArgs: [reportId],
    );
    if (result.isNotEmpty) {
      final lastDate = result.first['Last'] as String?;
      return lastDate;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getProductsByReportId(
    String reportId,
  ) async {
    final db = await database;

    final productsQuery = await db.query(
      'products_data',
      where: 'ReportId = ?',
      whereArgs: [reportId],
    );

    final scanQuery = await db.query(
      'scan_data',
      where: 'ReportId = ?',
      whereArgs: [reportId],
    );

    return [...productsQuery, ...scanQuery];
  }

  Future<void> deleteProductDataByName(String reportId, productName) async {
    log(
      "My LogDAta ==> deleteProductDataByName $reportId productName $productName",
    );
    final db = await instance.database;
    final rowsAffected = await db.delete(
      'products_data',
      where: 'ReportId = ? AND Product = ?',
      whereArgs: [reportId, productName],
    );
    log("My LogData ==> rowsAffected $rowsAffected");
  }

  Future<void> deleteReportAndData(String reportId, dealerId) async {
    /// After API Call Delete Data From Local Storage
    final db = await instance.database;

    // Delete product data for the report
    await db.delete(
      'products_data',
      where: 'ReportId = ?',
      whereArgs: [reportId],
    );
    await db.delete('scan_data', where: 'ReportId = ?', whereArgs: [reportId]);

    // Delete the report
    await db.delete('reports', where: 'ReportId = ?', whereArgs: [reportId]);

    // Check if the reportId is not present in the reports table
    final reportCount = Sqflite.firstIntValue(
      await db.rawQuery(
        '''
      SELECT COUNT(*) FROM reports WHERE DealerId = ? 
    ''',
        [dealerId],
      ),
    );

    log("My LogData ==> reportCount $reportCount");
    log("My LogData ==> reportCount $dealerId");
    if (reportCount == 0) {
      // Delete the dealer from the dealers table
      await db.delete('dealers', where: 'DealerId = ?', whereArgs: [dealerId]);
    }
  }

  Future<void> insertOrUpdateReport({
    required String Creation,
    required int DealerId,
    required String dealerName,
    required String ReportId,
    required List ScanCode,
    required String productName,
    required int units,
    fake,
    out_of_warenty,
    item_in_warenty,
    warrenty_already_claimed,
  }) async {
    final db = await database;
    final dealerId = DealerId;
    final reportId = ReportId;
    log("My LogData ==> insertOrUpdateReport $productName");
    log("My LogData ==> insertOrUpdateReport $ScanCode");
    log("My LogData ==> insertOrUpdateReport Creation $Creation");

    // Check if the dealer exists
    final existingDealers = await db.query(
      'dealers',
      where: 'DealerId = ?',
      whereArgs: [dealerId],
    );
    // final existingDealers = await db.query(
    //     'dealers', where: 'id = ?', whereArgs: [dealerId]);

    log("My LogData ==> insertOrUpdateReport 2  ${existingDealers.toString()}");

    if (existingDealers.isEmpty) {
      // Dealer doesn't exist, insert dealer data
      await db.insert('dealers', {'Name': dealerName, 'DealerId': dealerId});

      log(
        "My LogData ==> insertOrUpdateReport 3  ${existingDealers.toString()}",
      );
    }

    // Check if the report exists
    final existingReports = await db.query(
      'reports',
      where: 'DealerId = ? AND ReportId = ?',
      whereArgs: [dealerId, reportId],
    );
    log("My LogData ==> insertOrUpdateReport 4  ${existingReports.toString()}");
    if (existingReports.isEmpty) {
      // Report doesn't exist, insert report and product data
      final reportData = {
        'DealerId': dealerId,
        'ReportId': reportId,
        'Creation_Type': Creation,
      };
      log("My LogData ==> insertOrUpdateReport 11  ${reportData.toString()}");

      await db.insert('reports', reportData);
    }

    Future<bool> isReportIdAndProductExist(
      String reportId,
      String productName,
    ) async {
      final db = await database;
      final productsQuery = await db.query(
        'products_data',
        where: 'ReportId = ? AND Product = ?',
        whereArgs: [reportId, productName],
      );
      final scanQuery = await db.query(
        'scan_data',
        where: 'ReportId = ? AND Product = ?',
        whereArgs: [reportId, productName],
      );
      return (productsQuery.isNotEmpty || scanQuery.isNotEmpty);
    }

    if (isReportIdAndProductExist == false) {
      log("My LogData ==> existingProducts 1 ");
      if (Creation == "M") {
        log("My LogData ==> existingProducts 2 ");
        final productData = {
          'ReportId': reportId,
          'ScanCode': "",
          'Creation_Type': Creation,
          'Product': productName,
          'Unit': units,
          'Fake': fake ?? 0,
          'out_of_warenty': out_of_warenty ?? 0,
          'item_in_warenty': item_in_warenty ?? 0,
          'warrenty_already_claimed': warrenty_already_claimed ?? 0,
        };
        await db.insert('products_data', productData);
      } else {
        log("My LogData ==> existingProducts 3 ");
        final productData = {
          'ReportId': reportId,
          'ScanCode': jsonEncode(ScanCode) ?? "",
          'Creation_Type': Creation,
          'Product': productName,
          'Unit': units,
          'Fake': fake ?? 0,
          'out_of_warenty': out_of_warenty ?? 0,
          'item_in_warenty': item_in_warenty ?? 0,
          'warrenty_already_claimed': warrenty_already_claimed ?? 0,
        };
        await db.insert('scan_data', productData);
      }
    } else {
      log("My LogData ==> existingProducts 4 ");

      final existingProductsproducts_data = await db.query(
        'products_data',
        where: 'ReportId = ? AND Product = ? ',
        whereArgs: [reportId, productName],
      );
      final existingProductsscan_data = await db.query(
        'scan_data',
        where: 'ReportId = ? AND Product = ? ',
        whereArgs: [reportId, productName],
      );

      if (Creation == "M" && existingProductsproducts_data.isNotEmpty) {
        log("My LogData ==> existingProducts 5 $warrenty_already_claimed");
        await db.update(
          'products_data',
          {
            'ScanCode': '',
            'Unit': units,
            'Fake': fake ?? 0,
            'out_of_warenty': out_of_warenty ?? 0,
            'item_in_warenty': item_in_warenty ?? 0,
            'warrenty_already_claimed': warrenty_already_claimed ?? 0,
          },
          where: 'ReportId = ? AND Product = ?',
          whereArgs: [reportId, productName],
        );
      } else if (Creation == "M" && existingProductsproducts_data.isEmpty) {
        log("My LogData ==> existingProducts 6 $warrenty_already_claimed");
        final productData = {
          'ReportId': reportId,
          'ScanCode': "",
          'Creation_Type': Creation,
          'Product': productName,
          'Unit': units,
          'Fake': fake ?? 0,
          'out_of_warenty': out_of_warenty ?? 0,
          'item_in_warenty': item_in_warenty ?? 0,
          'warrenty_already_claimed': warrenty_already_claimed ?? 0,
        };
        await db.insert('products_data', productData);
      } else if (Creation == "S" && existingProductsscan_data.isNotEmpty) {
        log("My LogData ==> existingProducts 7 $warrenty_already_claimed");
        await db.update(
          'scan_data',
          {
            'ScanCode': jsonEncode(ScanCode),
            'Unit': units,
            'Fake': fake ?? 0,
            'out_of_warenty': out_of_warenty ?? 0,
            'item_in_warenty': item_in_warenty ?? 0,
            'warrenty_already_claimed': warrenty_already_claimed ?? 0,
          },
          where: 'ReportId = ? AND Product = ?',
          whereArgs: [reportId, productName],
        );
      } else {
        log("My LogData ==> existingProducts 8 $warrenty_already_claimed");
        final productData = {
          'ReportId': reportId,
          'ScanCode': jsonEncode(ScanCode),
          'Creation_Type': Creation,
          'Product': productName,
          'Unit': units,
          'Fake': fake ?? 0,
          'out_of_warenty': out_of_warenty ?? 0,
          'item_in_warenty': item_in_warenty ?? 0,
          'warrenty_already_claimed': warrenty_already_claimed ?? 0,
        };
        await db.insert('scan_data', productData);
      }
      // }
    }
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await database;

    final allDataQuery = '''
     SELECT d.Name AS DealerName,d.DealerId,d.Creation_Type, r.ReportId
      FROM dealers AS d
      LEFT JOIN reports AS r ON d.DealerId = r.DealerId
    ''';

    final allData = await db.rawQuery(allDataQuery);
    log("My LogData ==> getAllData $allData");
    return allData;
  }
}
