class Room {
  final String id;

  final String maPhong;
  final String tenPhong;
  final String loaiPhong;

  final double giaPhong;
  final double? giaKhuyenMai;

  final int soKhachToiDa;
  final double dienTich;

  final String moTa;
  final List<String> tienNghi;

  final List<String> hinhAnh;
  final String? video;

  final String tinhTrang; // Còn trống / Đã đặt

  Room({
    required this.id,
    required this.maPhong,
    required this.tenPhong,
    required this.loaiPhong,
    required this.giaPhong,
    this.giaKhuyenMai,
    required this.soKhachToiDa,
    required this.dienTich,
    required this.moTa,
    required this.tienNghi,
    required this.hinhAnh,
    this.video,
    required this.tinhTrang,
  });
}
