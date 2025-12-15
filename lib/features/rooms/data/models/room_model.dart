import '../../domain/entities/room_entity.dart';

class RoomModel extends Room {
  RoomModel({
    required super.id,
    required super.maPhong,
    required super.tenPhong,
    required super.loaiPhong,
    required super.giaPhong,
    super.giaKhuyenMai,
    required super.soKhachToiDa,
    required super.dienTich,
    required super.moTa,
    required super.tienNghi,
    required super.hinhAnh,
    super.video,
    required super.tinhTrang,
  });

  factory RoomModel.fromMap(Map<String, dynamic> map, String docId) {
    return RoomModel(
      id: docId,
      maPhong: map['maPhong'],
      tenPhong: map['tenPhong'],
      loaiPhong: map['loaiPhong'],
      giaPhong: (map['giaPhong'] ?? 0).toDouble(),
      giaKhuyenMai: map['giaKhuyenMai'] != null
          ? (map['giaKhuyenMai']).toDouble()
          : null,
      soKhachToiDa: map['soKhachToiDa'],
      dienTich: (map['dienTich'] ?? 0).toDouble(),
      moTa: map['moTa'],
      tienNghi: List<String>.from(map['tienNghi']),
      hinhAnh: List<String>.from(map['hinhAnh']),
      video: map['video'],
      tinhTrang: map['tinhTrang'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maPhong': maPhong,
      'tenPhong': tenPhong,
      'loaiPhong': loaiPhong,
      'giaPhong': giaPhong,
      'giaKhuyenMai': giaKhuyenMai,
      'soKhachToiDa': soKhachToiDa,
      'dienTich': dienTich,
      'moTa': moTa,
      'tienNghi': tienNghi,
      'hinhAnh': hinhAnh,
      'video': video,
      'tinhTrang': tinhTrang,
    };
  }
}
