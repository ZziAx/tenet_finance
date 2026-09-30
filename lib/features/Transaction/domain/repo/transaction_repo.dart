import 'package:hive/hive.dart';
import 'package:tenet_finance/core/constants/db/db.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_category_hive.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_hive.dart';

class TransactionRepo {
  static Box<TransactionHive> _getTransactionBox() =>
      Hive.box<TransactionHive>(TransactionBoxName);

  static Future<Transaction> add(Transaction transaction) async {
    final box = _getTransactionBox();
    final obj = TransactionHive.fromDomain(transaction);
    final dbId = await box.add(obj);
    transaction.setDbId(dbId);
    return transaction;
  }

  static Future<void> set(int key, Transaction transaction) async {
    final box = _getTransactionBox();
    final obj = TransactionHive.fromDomain(transaction);
    await box.put(key, obj);
  }

  static Future<Transaction> write(Transaction transaction) async {
    final box = _getTransactionBox();
    int? id = transaction.dbId;
    final obj = TransactionHive.fromDomain(transaction);
    if (box.containsKey(id)) {
      await box.put(id, obj);
    } else {
      final i = await box.add(obj);
      transaction.setDbId(i);
    }

    return transaction;
  }

  static Future remove(int dbId) async {
    final box = _getTransactionBox();
    await box.delete(dbId);
  }

  static Future<List<Transaction>> getAll() async {
    final box = _getTransactionBox();
    return box.values.map((e) => e.toDomain()).toList();
  }
}
