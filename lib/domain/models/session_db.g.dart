// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionDbAdapter extends TypeAdapter<SessionDb> {
  @override
  final int typeId = 0;

  @override
  SessionDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionDb(
      id: fields[0] as int?,
      user: fields[1] as String,
      score: fields[2] as int,
      corrects: (fields[3] as List).cast<String>(),
      incorrects: (fields[4] as List).cast<String>(),
      op: fields[5] as String,
    )..isSynced = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, SessionDb obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.corrects)
      ..writeByte(4)
      ..write(obj.incorrects)
      ..writeByte(5)
      ..write(obj.op)
      ..writeByte(6)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
