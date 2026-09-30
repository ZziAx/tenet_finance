// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardHiveAdapter extends TypeAdapter<CardHive> {
  @override
  final int typeId = 2;

  @override
  CardHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardHive(
      dbId: fields[0] as int?,
      transactions: (fields[3] as List).cast<TransactionHive>(),
      name: fields[1] as String,
      number: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CardHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dbId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.transactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
