import 'package:flutter/material.dart';
import 'package:tenet_finance/features/Card/controller/card_controller.dart';
import 'package:tenet_finance/features/Card/domain/card_object.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/transaction_repo.dart';

class TransactionsListController extends ChangeNotifier {
  CardObject card;
  List<Transaction>? get transactions => card.transactions.reversed.toList();

  bool loading = true;

  TransactionsListController(this.card);
  // void load() async {
  //   loading = true;
  //   _transactions = await TransactionRepo.getAll();
  //   loading = false;
  //   notifyListeners();
  // }

  void add(Transaction transaction) async {
    final model = await TransactionRepo.add(transaction);
    card.addTransaction(model);
  }

  void set(int key, Transaction transaction) async {
    await TransactionRepo.set(key, transaction);
    card.setTransaction(key, transaction);
  }

  void reload() {
    notifyListeners();
  }

  void remove(int dbId) async {
    if (card.transactions == null) return;
    await TransactionRepo.remove(dbId);
    card.transactions!.removeWhere((e) => e.dbId == dbId);
    notifyListeners();
  }

  void write(Transaction transaction) async {
    if (transaction.dbId != null) {
      set(transaction.dbId!, transaction);
    } else {
      add(transaction);
    }
    notifyListeners();
  }
}
