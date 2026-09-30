import 'package:flutter/material.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction_category.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/category_repo.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/transaction_repo.dart';

class TransactionCategoriesController extends ChangeNotifier {
  bool loading = false;
  List<TransactionCategory> get categories => _categories ?? [];

  List<TransactionCategory>? _categories;
  TransactionCategoriesController({List<TransactionCategory>? categories})
    : _categories = categories ?? [];

  void load() async {
    loading = true;
    _categories = await CategoryRepo.getAll();
    loading = false;
    notifyListeners();
  }

  Future remove(int dbId) async {
    await CategoryRepo.remove(dbId);
    _categories!.removeWhere((e) => e.dbId == dbId);
    notifyListeners();
  }

  void write(TransactionCategory category) async {
    final e = await CategoryRepo.write(category);
    if (category.dbId == null) {
      _categories!.add(e.toDomain());
    } else {
      int index = _categories!.indexWhere((e) => e.dbId == category.dbId);
      _categories![index] = e.toDomain();
    }
    notifyListeners();
  }

  bool exist(int? id) {
    if (id == null) {
      return false;
    }
    return categories.any((e) => e.dbId == id);
  }

  void reload() {
    load();
  }

  String? getName(int? id) {
    if (id == null) return 'انتخاب دسته بندی';
    return _categories?.where((e) => e.dbId == id).firstOrNull?.name;
  }
}
