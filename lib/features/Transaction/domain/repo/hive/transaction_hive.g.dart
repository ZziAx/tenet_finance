// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionHiveAdapter extends TypeAdapter<TransactionHive> {
  @override
  final int typeId = 0;

  @override
  TransactionHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionHive(
      messageId: fields[0] as int?,
      title: fields[1] as String?,
      description: fields[2] as String?,
      categoryId: fields[5] as int?,
      dbId: fields[6] as int?,
      type: fields[3] as int?,
      amount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.dbId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
