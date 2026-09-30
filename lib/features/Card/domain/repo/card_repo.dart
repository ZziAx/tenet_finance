import 'package:hive/hive.dart';
import 'package:tenet_finance/core/constants/db/db.dart';
import 'package:tenet_finance/features/Card/domain/card_object.dart';
import 'package:tenet_finance/features/Card/domain/repo/hive/card_hive.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction_category.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_category_hive.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_hive.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/transaction_repo.dart';

class CardRepo {
  static Box<CardHive> _getBox() => Hive.box<CardHive>(CardBoxName);

  static Future<CardHive> write(CardObject card) async {
    final box = _getBox();
    int? id = card.dbId;
    final obj = CardHive.fromDomain(card);
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

  static void addTransaction(int cardKey, Transaction transaction) async {
    final box = _getBox();
    final card = box.get(cardKey);
    card!.transactions.add(TransactionHive.fromDomain(transaction));
    await box.put(cardKey,card);
  }

  static void setTransaction(
    int cardKey,
    int transactionId,
    Transaction transaction,
  ) async {
    final box = _getBox();
    final card = box.get(cardKey);
    final index = card!.transactions.indexWhere((e) => e.dbId == transactionId);
    card.transactions[index] = TransactionHive.fromDomain(transaction);
    await box.put(cardKey, card);
  }

  static Future<Transaction?> writeTransaction(
    int key,
    Transaction transaction,
  ) async {
    final box = _getBox();
    final card = box.get(key);

    if (card == null) {
      return null;
    }

    final transactionHive = await TransactionRepo.write(transaction);
    final index = card.transactions.indexWhere(
      (e) => e.key == transactionHive.dbId,
    );

    if (index != -1) {
      card.transactions[index] = TransactionHive.fromDomain(transaction);
    } else {
      card.transactions.add(TransactionHive.fromDomain(transaction));
    }
    await box.put(key, card);

    return transactionHive;
  }

  static Future<List<CardObject>> getAll() async {
    final box = _getBox();
    return box.values.map((e) => e.toDomain()).toList();
  }
}
