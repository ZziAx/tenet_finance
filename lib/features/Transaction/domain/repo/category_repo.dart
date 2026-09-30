import 'package:hive/hive.dart';
import 'package:tenet_finance/core/constants/db/db.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction_category.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_category_hive.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_hive.dart';

class CategoryRepo {

  static Box<TransactionCategoryHive> _getBox() =>
      Hive.box<TransactionCategoryHive>(TransactionCategoryBoxName);
      
  static Future<TransactionCategoryHive> write(
    TransactionCategory category,
  ) async {
    final box = _getBox();
    int? id = category.dbId;
    final obj = TransactionCategoryHive.fromDomain(category);
    if (id != null) {
      await box.put(id, obj);
    } else {
      await box.add(obj);
    }
    return obj;
  }

  static Future remove(int dbId) async {
    final box = _getBox();
    await box.delete(dbId);
  }

  static Future<List<TransactionCategory>> getAll() async {
    final box = _getBox();
    return box.values.map((e) => e.toDomain()).toList();
  }
}
