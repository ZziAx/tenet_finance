import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/transaction_repo.dart';

class TransactionController extends ChangeNotifier {
  Transaction get transaction => _transaction;

  Transaction _transaction;
  
  TransactionController(Transaction? transaction, {TransactionType? type})
    : _transaction =
          (transaction?.copyWith(type: type) ??
              Transaction(amount: 0, type: type));

  void setTitle(String title) {
    _transaction.setTitle(title);
  }

  void setAmount(dynamic amount) {
    _transaction.amount =
        amount is String ? int.parse(amount.toEnglishDigit().replaceAll(',', '')) : amount;
  }
}
