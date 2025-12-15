import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';

class UpdateRoom {
  final RoomRepository repository;

  UpdateRoom(this.repository);

  Future<void> call(Room room) {
    if (room.id.trim().isEmpty) {
      throw Exception('Không tìm thấy ID phòng để cập nhật');
    }

    if (room.maPhong.trim().isEmpty ||
        room.tenPhong.trim().isEmpty ||
        room.loaiPhong.trim().isEmpty ||
        room.giaPhong <= 0 ||
        room.soKhachToiDa <= 0 ||
        room.dienTich <= 0 ||
        room.moTa.trim().isEmpty ||
        room.tienNghi.isEmpty ||
        room.hinhAnh.isEmpty) {
      throw Exception('Dữ liệu phòng không hợp lệ');
    }

    return repository.updateRoom(room);
  }
}
