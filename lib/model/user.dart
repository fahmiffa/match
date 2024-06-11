import 'dart:convert';

class User {
  final String code;
  final String name;
  final String contest;
  final String type;
  final int status;
  final List peserta;

  User(
      {required this.code,
      required this.name,
      required this.contest,
      required this.peserta,
      required this.type,
      required this.status});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      code: json['key'],
      name: json['name'],
      type: json['type'],
      status: int.parse(json['status']),
      contest: json['contest'],
      peserta: json['peserta'],
    );
  }
}

class Status {
  final int status;

  Status({required this.status});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      status: int.parse(json['status']),
    );
  }
}

List<Point> pointFromJson(String str) =>
    List<Point>.from(json.decode(str).map((x) => Point.fromJson(x)));

class Point {
  int id;
  String name;
  int point;

  Point({
    required this.id,
    required this.name,
    required this.point,
  });

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        id: json["id"],
        name: json["name"],
        point: int.parse(json["point"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "point": point,
      };
}

Value valueFromJson(String str) => Value.fromJson(json.decode(str));

String valueToJson(Value data) => json.encode(data.toJson());

class Value {
  List<Point> point;
  List<Peserta> peserta;

  Value({
    required this.point,
    required this.peserta,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        point: List<Point>.from(json["point"].map((x) => Point.fromJson(x))),
        peserta:
            List<Peserta>.from(json["peserta"].map((x) => Peserta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "point": List<dynamic>.from(point.map((x) => x.toJson())),
        "peserta": List<dynamic>.from(peserta.map((x) => x.toJson())),
      };
}

class Peserta {
  int id;
  String name;

  Peserta({
    required this.id,
    required this.name,
  });

  factory Peserta.fromJson(Map<String, dynamic> json) => Peserta(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
