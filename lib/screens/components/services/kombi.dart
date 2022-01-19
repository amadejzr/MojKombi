class Kombi {
  String? kid;
  String? uid;
  String? znamka;
  String? model;
  String? gorivo;
  String? opis;
  int? cena;
  bool? approved;
  String? leto;
  DateTime? dateTime;

  Kombi(
      {this.kid,
      this.uid,
      this.znamka,
      this.model,
      this.gorivo,
      this.opis,
      this.cena,
      this.approved,
      this.leto,
      this.dateTime});

  factory Kombi.fromMap(map) {
    return Kombi(
        kid: map['kid'],
        uid: map['uid'],
        znamka: map['znamka'],
        model: map['model'],
        gorivo: map['gorivo'],
        opis: map['opis'],
        cena: map['cena'],
        approved: map['approved'],
        leto: map['leto'],
        dateTime: map['dateTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      'kid': kid,
      'uid': uid,
      'znamka': znamka,
      'model': model,
      'gorivo': gorivo,
      'opis': opis,
      'cena': cena,
      'approved': approved,
      'leto': leto,
      'dateTime': dateTime
    };
  }
}
