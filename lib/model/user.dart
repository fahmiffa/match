import 'dart:convert';

class User {
  final int id;
  final String code;
  final String name;
  final String contest;
  final String partai;
  final String kelas;
  final String type;
  final String point;
  final int status;
  final int jurus;
  final String babak;
  final List peserta;
  final List side;
  final List kontingen;

  User({
    required this.id,
    required this.code,
    required this.name,
    required this.contest,
    required this.partai,
    required this.peserta,
    required this.kelas,
    required this.type,
    required this.point,
    required this.status,
    required this.jurus,
    required this.babak,
    required this.side,
    required this.kontingen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        code: json['key'],
        name: json['name'],
        partai: json['partai'],
        kelas: json['kelas'],
        type: json['type'],
        point: json['point'].toString(),
        status:
            json['status'] is int ? json['status'] : int.parse(json['status']),
        jurus: json['jurus'] is int ? json['jurus'] : int.parse(json['jurus']),
        contest: json['contest'],
        babak: json['number'],
        peserta: json['peserta'],
        side: json['side'],
        kontingen: json['kontingen']);
  }
}

class Status {
  final int status;
  final int move;
  final int ver;

  Status({required this.status, required this.move, required this.ver});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      status:
          json['status'] is int ? json['status'] : int.parse(json['status']),
      move: json['move'] is int ? json['move'] : int.parse(json['move']),
      ver: json['ver'] is int ? json['ver'] : int.parse(json['ver']),
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
        point: json["point"] is int ? json["point"] : int.parse(json["point"]),
        // point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "point": point,
      };
}

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
  String type;
  String kontingen;

  Peserta({
    required this.id,
    required this.name,
    required this.type,
    required this.kontingen,
  });

  factory Peserta.fromJson(Map<String, dynamic> json) => Peserta(
        id: int.parse(json["type"]),
        name: json["name"],
        type: json["type"],
        kontingen: json["kontingen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "kontingen": kontingen,
      };
}

class Waktu {
  int id;
  int contestId;
  String key;
  String status;
  String time;

  Waktu({
    required this.id,
    required this.contestId,
    required this.key,
    required this.status,
    required this.time,
  });

  factory Waktu.fromJson(Map<String, dynamic> json) => Waktu(
        id: json["id"],
        contestId: json["contest_id"] is int
            ? json["contest_id"]
            : int.parse(json["contest_id"]),
        key: json["key"],
        status: json["status"],
        time: json["time"],
      );
}

class WebSocketData {
  final int type;
  final String data;

  WebSocketData({required this.type, required this.data});

  factory WebSocketData.fromJson(Map<String, dynamic> json) {
    return WebSocketData(
      type: json['type'],
      data: json['data'],
    );
  }
}

class Mod {
  final String val;

  Mod({required this.val});

  factory Mod.fromJson(Map<String, dynamic> json) {
    return Mod(
      val: json['val'].toString(),
    );
  }
}
