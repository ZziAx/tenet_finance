import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenet_finance/features/Transaction/controllers/transaction_categories_controller.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';

class SortFilter {
  bool income;
  bool outcome;
  SortFilter({this.income = true, this.outcome = true});

  List<Transaction> process(List<Transaction> transactions) {
    return transactions.where((e) {
      if (e.type == TransactionType.income && income) {
        return true;
      }
      if (e.type == TransactionType.outcome && outcome) {
        return true;
      }
      return false;
    }).toList();
  }
}

class TransactionSortController extends ChangeNotifier {
  List<Transaction> get transactions => _transactions;
  List<int> get categories => _categories;

  List<int> _categories;
  SortFilter get filter => _filter;

  SortFilter _filter;
  bool ascending;
  List<Transaction> _transactions;
  TransactionSortController(
    List<Transaction>? transactions, {
    SortFilter? filter,
    List<int>? categories,
    this.ascending = true,
  }) : _categories = categories ?? [],
       _filter = filter ?? SortFilter(),
       _transactions = transactions ?? [];

  void toggleAscending(bool ascending) {
    this.ascending = ascending;
    notifyListeners();
  }

  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  void setFilter({bool? income, bool? outcome}) {
    filter.income = income ?? filter.income;
    filter.outcome = outcome ?? filter.outcome;
    notifyListeners();
  }

  void toggleCategoryState(int dbId) {
    if (_categories.contains(dbId)) {
      _categories.remove(dbId);
    } else {
      _categories.add(dbId);
    }
    notifyListeners();
  }

  void toggleFilter({bool? income, bool? outcome}) {
    if (filter.income) {
      filter.income = !filter.income;
    }
    if (filter.outcome) {
      filter.outcome = !filter.outcome;
    }
    notifyListeners();
  }

  void clearCategories() {
    _categories.clear();
    notifyListeners();
  }

  void removeCategorie(int id) {
    _categories.remove(id);
    notifyListeners();
  }
  List<Transaction> sort(BuildContext context) {
    List<Transaction> result = filter.process(_transactions);

    if (_categories.isNotEmpty) {
      _categories.removeWhere(
        (a) => !context.read<TransactionCategoriesController>().exist(a),
      );
      result =
          result
              .where(
                (e) =>
                    e.categoryId != null && _categories.contains(e.categoryId),
              )
              .toList();
    }
    if (ascending) {
      return result.reversed.toList();
    } else {
      return result;
    }
  }

  void resort() {
    notifyListeners();
  }

  bool categorySelected(int id) {
    return _categories.contains(id);
  }
}
