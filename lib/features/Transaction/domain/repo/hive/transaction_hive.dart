import 'package:hive/hive.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
part 'transaction_hive.g.dart';

@HiveType(typeId: 0)
class TransactionHive extends HiveObject {
  Transaction toDomain() => Transaction(
    amount: amount,
    messageId: messageId,
    title: title,
    description: description,
    dbId: dbId,
    type: TransactionType.values[type],
    categoryId: categoryId
  );

  static TransactionHive fromDomain(Transaction transaction) => TransactionHive(
    title: transaction.title,
    description: transaction.description,
    messageId: transaction.messageId,
    amount: transaction.amount,
    type: transaction.type.index,
    categoryId: transaction.categoryId,
    dbId:transaction.dbId
  );

  @HiveField(0)
  int? messageId;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  int type;
  @HiveField(4)
  int amount;

  @HiveField(5)
  int ?categoryId;

  
  @HiveField(6)
  int ?dbId;


  TransactionHive({
    this.messageId,
    this.title,
    this.description,
    this.categoryId,
    this.dbId,
    int? type,
    required this.amount,
  }) : type = type ?? TransactionType.income.index;
}
