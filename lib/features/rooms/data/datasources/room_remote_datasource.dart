import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room_model.dart';

class RoomRemoteDataSource {
  final FirebaseFirestore firestore;

  RoomRemoteDataSource(this.firestore);

  Stream<List<RoomModel>> getRoomsStream() {
    return firestore.collection('rooms').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => RoomModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<String> addRoom(RoomModel room) async {
    final ref = await firestore.collection('rooms').add(room.toMap());
    return ref.id;
  }

  Future<void> updateRoom(RoomModel room) async {
    if (room.id.isEmpty) {
      throw Exception('ID không hợp lệ để cập nhật');
    }
    await firestore.collection('rooms').doc(room.id).update(room.toMap());
  }

  Future<void> deleteRoom(String id) async {
    if (id.isEmpty) {
      throw Exception('ID không hợp lệ để xóa');
    }
    await firestore.collection('rooms').doc(id).delete();
  }
}