import 'package:hive/hive.dart';

part 'session_db.g.dart';

@HiveType(typeId: 0)
class SessionDb extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String user;

  @HiveField(2)
  int score;

  @HiveField(3)
  List<String> corrects;

  @HiveField(4)
  List<String> incorrects;

  @HiveField(5)
  String op;

  SessionDb({
    this.id,
    required this.user,
    required this.score,
    required this.corrects,
    required this.incorrects,
    required this.op,
  });
}
