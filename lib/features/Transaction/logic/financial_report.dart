import 'package:flutter/material.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';

class FinancialReport extends ChangeNotifier{
  List<Transaction> transactions;
  FinancialReport({required this.transactions});
  int get totalIncome => _totalIncome();
  int get totalOutcome => _totalOutcome();
  double get ivo => _iVo();
  int get remained => _remained();

  int _totalIncome() => transactions.fold(
    0,
    (a, b) => a + (b.type == TransactionType.income ? b.amount : 0),
  );

  int _totalOutcome() => transactions.fold(
    0,
    (a, b) => a + (b.type == TransactionType.outcome ? b.amount : 0),
  );

  int _remained() => totalIncome - totalOutcome;

  double _iVo() => remained / totalIncome;
}
