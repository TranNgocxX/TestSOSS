import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ngoctran/core/presentation/widget/app_drawer.dart';
import 'package:ngoctran/core/routing/app_routes.dart';
import 'package:ngoctran/features/rooms/data/models/room_model.dart';
import 'package:ngoctran/features/rooms/data/datasources/room_remote_datasource.dart';

class RoomDetailPage extends StatelessWidget {
  final RoomModel room;

  RoomDetailPage({super.key, required this.room});

  final RoomRemoteDataSource roomDataSource =
      RoomRemoteDataSource(FirebaseFirestore.instance);

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.purpleAccent;
    const Color accentColor = Colors.purpleAccent;
    const Color backgroundColor = Colors.white;

    const double maxContentWidth = 1200;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isLargeScreen = constraints.maxWidth > maxContentWidth + 100;

        return Scaffold(
          backgroundColor: backgroundColor,

          // Drawer
          drawer: AppDrawer(user: user),

          appBar: AppBar(
            backgroundColor: primaryColor,
            centerTitle: true,
            title: Text(
              room.tenPhong,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= ẢNH PHÒNG =================
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? 20 : 0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(isLargeScreen ? 15 : 30),
                          bottomRight: Radius.circular(isLargeScreen ? 15 : 30),
                        ),
                        child: Image.network(
                          room.hinhAnh.first,
                          width: double.infinity,
                          height: isLargeScreen ? 350 : 280,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // ================= CHI TIẾT =================
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${room.loaiPhong} - ${room.tenPhong}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(Icons.people_outline,
                                  size: 20, color: Colors.blueGrey),
                              const SizedBox(width: 6),
                              Text(
                                'Tối đa ${room.soKhachToiDa} khách · ${room.dienTich} m²',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                            '${room.giaPhong.toStringAsFixed(0)} VNĐ / đêm',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),

                          if (room.giaKhuyenMai != null)
                            Text(
                              'Khuyến mãi: ${room.giaKhuyenMai!.toStringAsFixed(0)} VNĐ',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.redAccent,
                              ),
                            ),

                          const SizedBox(height: 25),
                          const Divider(),

                          // ================= MÔ TẢ =================
                          const Text(
                            'Mô tả chi tiết',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            room.moTa,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 25),

                          // ================= TIỆN NGHI =================
                          const Text(
                            'Tiện nghi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: room.tienNghi
                                .map(
                                  (e) => Chip(
                                    label: Text(e),
                                    backgroundColor:
                                        accentColor.withOpacity(0.15),
                                  ),
                                )
                                .toList(),
                          ),

                          const SizedBox(height: 40),

                          // ================= ĐẶT PHÒNG =================
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: room.tinhTrang == 'Còn trống'
                                  ? () {
                                      context.push(
                                        AppRoutes.booking,
                                        extra: room,
                                      );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'ĐẶT NGAY',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ================= PHÒNG TƯƠNG TỰ =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: const Text(
                        'Có thể bạn sẽ thích ✨',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 210,
                      child: StreamBuilder<List<RoomModel>>(
                        stream: roomDataSource.getRoomsStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final relatedRooms = snapshot.data!
                              .where(
                                (r) =>
                                    r.id != room.id &&
                                    r.loaiPhong == room.loaiPhong,
                              )
                              .take(5)
                              .toList();

                          if (relatedRooms.isEmpty) {
                            return const Center(
                              child: Text('Không có phòng tương tự'),
                            );
                          }

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: relatedRooms.length,
                            itemBuilder: (_, index) {
                              final other = relatedRooms[index];
                              return Container(
                                width: 160,
                                margin: const EdgeInsets.only(right: 16),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                        child: Image.network(
                                          other.hinhAnh.first,
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              other.tenPhong,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${other.giaPhong.toStringAsFixed(0)} VNĐ/đêm',
                                              style: const TextStyle(
                                                color: accentColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
