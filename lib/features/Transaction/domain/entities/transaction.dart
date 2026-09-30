enum TransactionType { outcome, income }

class Transaction {
  String get title => _title ?? '';
  String get description => _description ?? '';
  TransactionType get type => _type;

  int? get dbId => _dbId;
  int? get messageId => _messageId;
  int? get categoryId => _categoryId;

  TransactionType _type;

  int? _dbId;
  int? _messageId;
  String? _title;
  String? _description;
  int? _categoryId;
  int amount;
  Transaction({
    String? title,
    String? description,
    int? dbId,
    int? messageId,
    TransactionType? type,
    int? categoryId,
    required this.amount,
  }) : _categoryId = categoryId,
       _title = title,
       _type = type ?? TransactionType.income,
       _dbId = dbId,
       _messageId = messageId,
       _description = description;

  void setTitle(String title) => _title = title;
  Transaction copy() => Transaction(
    title: _title,
    description: _description,
    dbId: _dbId,
    messageId: _messageId,
    amount: amount,
    type: type,
    categoryId: categoryId,
  );

  void setDbId(int id) => _dbId = id;
  Transaction copyWith({TransactionType? type}) => Transaction(
    title: _title,
    description: _description,
    dbId: _dbId,
    messageId: _messageId,
    amount: amount,
    type: type ?? this.type,
    categoryId: categoryId,
  );

  void setCategory(int id) => _categoryId = id;
  void removeCategory() => _categoryId = null;
}
