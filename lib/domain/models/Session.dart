class Session {
  Session({
    this.id,
    required this.score,
    required this.corrects,
    required this.incorrects, 
    required this.op,
  });

  int? id;
  int score;
  List<String> corrects;
  List<String> incorrects;
  String op;
  int get getScore => score;

  List<String> get getCorrects => corrects;
  List<String> get getIncorrects => incorrects;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json["id"],
        score: json["score"] ?? "someScore",
        corrects: json["corrects"] ?? "someCorrects",
        incorrects: json["incorrects"] ?? "someincorrects",
        op: json["op"] ?? "someOp",
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "score": score,
        "corrects": corrects,
        "incorrects": incorrects,
        "op": op,
      };
}
