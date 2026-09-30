import 'package:hive/hive.dart';
import 'package:tenet_finance/features/Card/domain/repo/card_repo.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_hive.dart';

class CardObject {
  int? dbId;
  String name;
  String number;
  List<Transaction> transactions;
  CardObject({
    this.dbId,
    List<Transaction>? transactions,
    this.name = '',
    required this.number,
  }) : transactions = transactions ?? [];

  void addTransaction(Transaction transaction) async {
    transactions.add(transaction);
    CardRepo.addTransaction(dbId!, transaction);
  }

  void setTransaction(int key, Transaction transaction) async {
    int index = transactions.indexWhere((e) => e.dbId == key);
    transactions[index] = transaction;
    CardRepo.setTransaction(dbId!, key, transaction);
  }
}
