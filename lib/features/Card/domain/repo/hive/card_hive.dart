import 'package:hive/hive.dart';
import 'package:tenet_finance/features/Card/domain/card_object.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_hive.dart';
part 'card_hive.g.dart';

@HiveType(typeId: 2)
class CardHive extends HiveObject {
  CardObject toDomain() => CardObject(
    dbId: key,
    name: name,
    number: number,
    transactions: transactions.map((e) => e.toDomain()).toList(),
  );

  static CardHive fromDomain(CardObject card) => CardHive(
    dbId: card.dbId,
    name: card.name,
    number: card.number,
    transactions:
        card.transactions.map((e) => TransactionHive.fromDomain(e)).toList(),
  );

  @HiveField(0)
  int ?dbId;

  @HiveField(1)
  String name;
  @HiveField(2)
  String number;
  @HiveField(3)
  List<TransactionHive> transactions;
  CardHive({
    required this.dbId,
    required this.transactions,
    required this.name,
    required this.number,
  });
}
