import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_remote_datasource.dart';
import '../models/room_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Room>> getRoomsStream() =>
      remoteDataSource.getRoomsStream();

  @override
  Future<void> addRoom(Room room) async {
    await remoteDataSource.addRoom(RoomModel(
      id: room.id,
      maPhong: room.maPhong,
      tenPhong: room.tenPhong,
      loaiPhong: room.loaiPhong,
      giaPhong: room.giaPhong,
      giaKhuyenMai: room.giaKhuyenMai,
      soKhachToiDa: room.soKhachToiDa,
      dienTich: room.dienTich,
      moTa: room.moTa,
      tienNghi: room.tienNghi,
      hinhAnh: room.hinhAnh,
      video: room.video,
      tinhTrang: room.tinhTrang,
    ));
  }

  @override
  Future<void> updateRoom(Room room) async {
    await remoteDataSource.updateRoom(RoomModel(
      id: room.id,
      maPhong: room.maPhong,
      tenPhong: room.tenPhong,
      loaiPhong: room.loaiPhong,
      giaPhong: room.giaPhong,
      giaKhuyenMai: room.giaKhuyenMai,
      soKhachToiDa: room.soKhachToiDa,
      dienTich: room.dienTich,
      moTa: room.moTa,
      tienNghi: room.tienNghi,
      hinhAnh: room.hinhAnh,
      video: room.video,
      tinhTrang: room.tinhTrang,
    ));
  }

  @override
  Future<void> deleteRoom(String id) =>
      remoteDataSource.deleteRoom(id);
}
