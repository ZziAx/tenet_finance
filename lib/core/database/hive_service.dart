import 'package:hive_flutter/hive_flutter.dart';
import 'package:tenet_finance/core/constants/db/db.dart';
import 'package:tenet_finance/features/Card/domain/repo/hive/card_hive.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_category_hive.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_hive.dart';
// import '../../features/formula/data/models/formula_hive_model.dart';

Future<void> clearHiveDebug() async {
  await Hive.close();
  await Hive.deleteBoxFromDisk(TransactionBoxName);
  await Hive.deleteBoxFromDisk(TransactionCategoryBoxName);
}

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    // await clearHiveDebug();

    Hive.registerAdapter(TransactionHiveAdapter());
    Hive.registerAdapter(TransactionCategoryHiveAdapter());
    Hive.registerAdapter(CardHiveAdapter());

    await Hive.openBox<TransactionHive>(TransactionBoxName);
    await Hive.openBox<TransactionCategoryHive>(TransactionCategoryBoxName);
    await Hive.openBox<CardHive>(CardBoxName);

  }
}
