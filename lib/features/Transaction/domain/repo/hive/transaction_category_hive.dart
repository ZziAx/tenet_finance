import 'package:hive/hive.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction_category.dart';
import 'package:tenet_finance/features/Transaction/domain/repo/hive/transaction_hive.dart';
part 'transaction_category_hive.g.dart';

@HiveType(typeId: 1)
class TransactionCategoryHive extends HiveObject {
  TransactionCategory toDomain() => TransactionCategory(
    name: name,
    description: description,
    transactions: transactions?.map((e) => e.toDomain()).toList(),
    dbId: key,
  );


static TransactionCategoryHive fromDomain(TransactionCategory category) => TransactionCategoryHive(
    name: category.name,
    description: category.description,
    transactions: category.transactions?.map((e)=>TransactionHive.fromDomain(e)).toList(),
  );
  @HiveField(0)
  String name;
  @HiveField(1)
  String? description;
  @HiveField(2)
  List<TransactionHive>? transactions;
  TransactionCategoryHive({
    required this.name,
    this.description,
    this.transactions,
  });
}
