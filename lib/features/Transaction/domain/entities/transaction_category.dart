import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';

class TransactionCategory {
  String name;
  String? description;
  List<Transaction>? transactions;
  int? dbId;
  TransactionCategory({
    required this.name,
    this.dbId,
    this.description,
    this.transactions,
  });

  TransactionCategory copy() => TransactionCategory(
    name: name,
    dbId: dbId,
    description: description,
    transactions: transactions?.map((e) => e.copy()).toList(),
  );

  void setName(String name) {
    this.name = name;
  }

    void setDescription(String description) {
    this.description = description;
  }
}
