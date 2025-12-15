import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/datasources/room_remote_datasource.dart';
import '../../data/repositories/room_repository_impl.dart';
import '../../domain/entities/room_entity.dart';
import '../widgets/room_form.dart';
import 'package:ngoctran/core/presentation/widget/app_drawer.dart';

class RoomManagementPage extends StatefulWidget {
  const RoomManagementPage({super.key});

  @override
  State<RoomManagementPage> createState() => _RoomManagementPageState();
}

class _RoomManagementPageState extends State<RoomManagementPage> {
  late final RoomRepositoryImpl roomRepository;
  final TextEditingController searchController = TextEditingController();

  String selectedLoaiPhong = 'Tất cả';
  String selectedTinhTrang = 'Tất cả';

  final Color pastelPurple = const Color(0xFFE4B9F1);

  @override
  void initState() {
    super.initState();
    roomRepository = RoomRepositoryImpl(
      RoomRemoteDataSource(FirebaseFirestore.instance),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F4FB),
      appBar: _buildAppBar(),
      drawer: AppDrawer(user: user),
      floatingActionButton: _buildAddButton(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<Room>>(
          stream: roomRepository.getRoomsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Chưa có phòng nào'));
            }

            final rooms = snapshot.data!;
            final filteredRooms = _filterRooms(rooms);

            return Column(
              children: [
                _buildStatistics(rooms),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRooms.length,
                    itemBuilder: (_, index) =>
                        _buildRoomCard(filteredRooms[index]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ================== APP BAR ==================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Quản lý phòng'),
      backgroundColor: pastelPurple,
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildSearchBox(),
              const SizedBox(height: 8),
              _buildFilters(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Tìm theo mã phòng / tên phòng',
        prefixIcon: Icon(Icons.search, color: pastelPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedLoaiPhong,
            decoration: _filterDecoration('Loại phòng'),
            items: ['Tất cả', 'Standard', 'Deluxe', 'Suite', 'VIP']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => selectedLoaiPhong = v!),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedTinhTrang,
            decoration: _filterDecoration('Tình trạng'),
            items: ['Tất cả', 'Còn trống', 'Đã đặt']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => selectedTinhTrang = v!),
          ),
        ),
      ],
    );
  }

  InputDecoration _filterDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }

  // ================== STATISTICS ==================
  Widget _buildStatistics(List<Room> rooms) {
    final total = rooms.length;
    final empty = rooms.where((e) => e.tinhTrang == 'Còn trống').length;
    final booked = rooms.where((e) => e.tinhTrang == 'Đã đặt').length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statCard('Tổng', total, Icons.hotel, Colors.blue),
        _statCard('Trống', empty, Icons.meeting_room, Colors.green),
        _statCard('Đã đặt', booked, Icons.event_busy, Colors.red),
      ],
    );
  }

  Widget _statCard(String title, int value, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          Text('$value',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color)),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ================== ROOM CARD ==================
  Widget _buildRoomCard(Room room) {
    final image = room.hinhAnh.isNotEmpty
        ? room.hinhAnh.first
        : 'https://via.placeholder.com/150';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(14)),
            child: Image.network(image,
                width: 120, height: 120, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.tenPhong,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Mã: ${room.maPhong}'),
                    Text('Giá: ${room.giaPhong} VNĐ'),
                    if (room.giaKhuyenMai != null)
                      Text('KM: ${room.giaKhuyenMai} VNĐ',
                          style: const TextStyle(color: Colors.red)),
                    _statusChip(room.tinhTrang),
                  ]),
            ),
          ),
          _buildActions(room),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = status == 'Còn trống' ? Colors.green : Colors.red;
    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color),
    );
  }

  Widget _buildActions(Room room) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.edit, color: pastelPurple),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => RoomForm(
              room: room,
              onSubmit: (updatedRoom) async {
                try {
                  await roomRepository.updateRoom(updatedRoom);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật thành công')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi cập nhật: $e')),
                  );
                }
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            try {
              await roomRepository.deleteRoom(room.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Xóa thành công')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi xóa: $e')),
              );
            }
          },
        ),
      ],
    );
  }

  // ================== ADD ==================
  Widget _buildAddButton() {
    return FloatingActionButton.extended(
      backgroundColor: pastelPurple,
      icon: const Icon(Icons.add),
      label: const Text('Thêm phòng'),
      onPressed: () => showDialog(
        context: context,
        builder: (_) => RoomForm(
          onSubmit: (room) async {
            try {
              await roomRepository.addRoom(room);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thêm thành công')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi thêm: $e')),
              );
            }
          },
        ),
      ),
    );
  }

  // ================== FILTER ==================
  List<Room> _filterRooms(List<Room> rooms) {
    final keyword = searchController.text.toLowerCase();
    return rooms.where((r) {
      return (r.maPhong.toLowerCase().contains(keyword) ||
              r.tenPhong.toLowerCase().contains(keyword)) &&
          (selectedLoaiPhong == 'Tất cả' ||
              r.loaiPhong == selectedLoaiPhong) &&
          (selectedTinhTrang == 'Tất cả' ||
              r.tinhTrang == selectedTinhTrang);
    }).toList();
  }
}
