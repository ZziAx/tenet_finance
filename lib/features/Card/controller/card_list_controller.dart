import 'package:flutter/material.dart';
import 'package:tenet_finance/features/Card/domain/card_object.dart';
import 'package:tenet_finance/features/Card/domain/repo/card_repo.dart';

class CardListController extends ChangeNotifier {
  List<CardObject>? get cards => _cards;

  List<CardObject>? _cards;
  CardListController([List<CardObject>? cards]) : _cards = cards;

  Future load() async {
    _cards = await CardRepo.getAll();
    notifyListeners();
    return _cards;
  }

  void add(CardObject card) async {
    final hiveCard = await CardRepo.write(card);
    _cards?.add(hiveCard.toDomain());
    notifyListeners();
  }
}
