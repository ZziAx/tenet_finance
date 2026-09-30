import 'package:flutter/material.dart';
import 'package:tenet_finance/features/Card/domain/card_object.dart';
import 'package:tenet_finance/features/Card/domain/repo/card_repo.dart';
import 'package:tenet_finance/features/Transaction/controllers/transactions_list_controller.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_hive.dart';

class CardController extends ChangeNotifier {
  bool get visible => _visible;
  bool _visible;
  TransactionsListController transactionsListController;
  CardObject card;
  CardController(this.card, {bool visible = true})
    : transactionsListController = TransactionsListController(card),
      _visible = visible;
  // Future<Transaction?> writeTransaction(Transaction transaction) async {
  //   return await CardRepo.writeTransaction(card.dbId!, transaction);
  // }

  void writeTransaction(Transaction transaction) {
    if (transaction.dbId != null) {
      transactionsListController.set(transaction.dbId!, transaction);
    } else {
      transactionsListController.add(transaction);
    }
  }

  void setSettings({String? name, String? number}) async {
    card.name = name ?? card.name;
    card.number = number ?? card.number;
    await CardRepo.write(card);
    notifyListeners();
  }

  void toggleVisibility() {
    _visible = !_visible;
    notifyListeners();
  }

  void setVisibility(bool visible) {
    _visible = visible;
    notifyListeners();
  }
}
