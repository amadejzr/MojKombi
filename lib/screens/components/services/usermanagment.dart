class Verify {
  String? uid;
  String? email;
  String? ime;
  String? priimek;
  bool? admin;
  bool? verified;

  Verify(
      {this.uid,
      this.ime,
      this.priimek,
      this.email,
      this.admin,
      this.verified});

  factory Verify.fromMap(map) {
    return Verify(verified: map['verified']);
  }

  Map<String, dynamic> toMap() {
    return {
      'verified': verified,
    };
  }
}
