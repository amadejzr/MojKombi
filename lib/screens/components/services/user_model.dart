class UserModel {
  String? uid;
  String? email;
  String? ime;
  String? priimek;
  String? state;
  List<dynamic>? sposojeniKombiji;

  UserModel(
      {this.uid,
      this.ime,
      this.priimek,
      this.email,
      this.state,
      this.sposojeniKombiji});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        ime: map['ime'],
        priimek: map['priimek'],
        email: map['email'],
        state: map['state'],
        sposojeniKombiji: map['sposojeniKombiji']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'ime': ime,
      'priimek': priimek,
      'email': email,
      'state': state,
      'sposojeniKombiji': sposojeniKombiji
    };
  }
}
