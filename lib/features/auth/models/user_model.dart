/// Model user mahasiswa.
/// Field disesuaikan dengan response Laravel API.
class UserModel {
  final int id;
  final String nama;
  final String nim;
  final String email;
  final int? dosenId;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.nama,
    required this.nim,
    required this.email,
    this.dosenId,
    this.createdAt,
  });

  /// Parse dari JSON response Laravel API.
  ///
  /// Expected format:
  /// ```json
  /// {
  ///   "id": 1,
  ///   "nama": "Budi Santoso",
  ///   "nim": "2021001",
  ///   "email": "budi@student.com",
  ///   "dosen_id": 2
  /// }
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
      email: json['email'] ?? '',
      dosenId: json['dosen_id'] is int ? json['dosen_id'] : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'nim': nim,
        'email': email,
        'dosen_id': dosenId,
        'created_at': createdAt?.toIso8601String(),
      };

  /// Getter untuk backward-compatibility di UI yang pakai `name`.
  String get name => nama;
}
