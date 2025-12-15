// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bootstrap/flutter_bootstrap.dart';
// import 'package:go_router/go_router.dart';

// import 'package:ngoctran/core/routing/app_routes.dart';
// import 'package:ngoctran/core/presentation/widget/app_drawer.dart';
// import 'package:ngoctran/features/rooms/data/datasources/room_remote_datasource.dart';
// import 'package:ngoctran/features/rooms/domain/entities/room_entity.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final RoomRemoteDataSource roomDataSource =
//       RoomRemoteDataSource(FirebaseFirestore.instance);

//   final User? user = FirebaseAuth.instance.currentUser;

//   String searchQuery = '';
//   String? selectedLoaiPhong;
//   double? minPrice;
//   double? maxPrice;

//   @override
//   Widget build(BuildContext context) {
//     bootstrapGridParameters(gutterSize: 10);

//     return Scaffold(
//       backgroundColor: const Color(0xfffafafa),
//       appBar: AppBar(
//         title: const Text(
//           'Trang chủ',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFFECA7E9),
//         centerTitle: true,
//       ),
//       drawer: AppDrawer(user: user),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             // 🔍 Search + Filter Button
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Tìm kiếm phòng theo tên, mã hoặc mô tả...',
//                       prefixIcon:
//                           const Icon(Icons.search, color: Colors.purple),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     onChanged: (value) =>
//                         setState(() => searchQuery = value.toLowerCase()),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 IconButton(
//                   icon: const Icon(Icons.filter_list,
//                       color: Colors.purple, size: 30),
//                   onPressed: () => _showFilterDialog(context),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),

//             // 📦 Danh sách phòng (chỉ phòng trống)
//             Expanded(
//               child: StreamBuilder<List<Room>>(
//                 stream: roomDataSource.getRoomsStream(),
//                 builder: (context, snapshot) {
//                   // Loading
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   // Error
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text(
//                         'Lỗi tải dữ liệu: ${snapshot.error}',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     );
//                   }

//                   // No data or empty
//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(
//                         child: Text('Hiện chưa có phòng nào sẵn sàng.'));
//                   }

//                   // Lọc danh sách phòng
//                   final allRooms = snapshot.data!;
//                   final filteredRooms = allRooms.where((room) {
//                     // Chỉ hiển thị phòng còn trống
//                     if (room.tinhTrang != 'Còn trống') return false;

//                     // Tìm kiếm theo từ khóa
//                     final matchesSearch = searchQuery.isEmpty ||
//                         room.tenPhong.toLowerCase().contains(searchQuery) ||
//                         room.maPhong.toLowerCase().contains(searchQuery) ||
//                         room.moTa.toLowerCase().contains(searchQuery);

//                     // Lọc loại phòng
//                     final matchesType = selectedLoaiPhong == null ||
//                         room.loaiPhong == selectedLoaiPhong;

//                     // Lọc giá
//                     final matchesMin =
//                         minPrice == null || room.giaPhong >= minPrice!;
//                     final matchesMax =
//                         maxPrice == null || room.giaPhong <= maxPrice!;

//                     return matchesSearch &&
//                         matchesType &&
//                         matchesMin &&
//                         matchesMax;
//                   }).toList();

//                   if (filteredRooms.isEmpty) {
//                     return const Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.search_off, size: 60, color: Colors.grey),
//                           SizedBox(height: 16),
//                           Text('Không tìm thấy phòng phù hợp với bộ lọc.'),
//                         ],
//                       ),
//                     );
//                   }

//                   // Hiển thị lưới phòng
//                   return SingleChildScrollView(
//                     child: BootstrapContainer(
//                       fluid: true,
//                       children: [
//                         BootstrapRow(
//                           children: filteredRooms
//                               .map(
//                                 (room) => BootstrapCol(
//                                   sizes: 'col-12 col-sm-6 col-md-4 col-lg-3',
//                                   child: _buildRoomCard(context, room),
//                                 ),
//                               )
//                               .toList(),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🏨 Card phòng
//   Widget _buildRoomCard(BuildContext context, Room room) {
//     final imageUrl = room.hinhAnh.isNotEmpty
//         ? room.hinhAnh.first
//         : 'https://via.placeholder.com/300x200.png?text=Không+có+ảnh';

//     return GestureDetector(
//       onTap: () {
//         context.push(
//           '${AppRoutes.roomDetail}/${room.id}',
//           extra: room,
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Ảnh phòng
//             ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(16)),
//               child: Image.network(
//                 imageUrl,
//                 width: double.infinity,
//                 height: 140,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     height: 140,
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.broken_image,
//                         size: 50, color: Colors.grey),
//                   );
//                 },
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     room.tenPhong,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 15),
//                   ),
//                   Text(
//                     'Mã: ${room.maPhong}',
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     room.moTa,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(fontSize: 12, color: Colors.grey[700]),
//                   ),
//                   const SizedBox(height: 10),

//                   // Giá khuyến mãi hoặc giá thường
//                   if (room.giaKhuyenMai != null) ...[
//                     Text(
//                       '${room.giaPhong.toStringAsFixed(0)} VNĐ',
//                       style: const TextStyle(
//                         decoration: TextDecoration.lineThrough,
//                         fontSize: 13,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     Text(
//                       '${room.giaKhuyenMai!.toStringAsFixed(0)} VNĐ/đêm',
//                       style: const TextStyle(
//                         color: Colors.purpleAccent,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ] else
//                     Text(
//                       '${room.giaPhong.toStringAsFixed(0)} VNĐ/đêm',
//                       style: const TextStyle(
//                         color: Colors.purpleAccent,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🎛️ Dialog bộ lọc
//   void _showFilterDialog(BuildContext context) {
//     final loaiPhongOptions = ['Standard', 'Deluxe', 'Suite', 'Presidential'];
//     final minController =
//         TextEditingController(text: minPrice?.toStringAsFixed(0) ?? '');
//     final maxController =
//         TextEditingController(text: maxPrice?.toStringAsFixed(0) ?? '');

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => Padding(
//         padding: EdgeInsets.only(
//           left: 16,
//           right: 16,
//           top: 20,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Bộ lọc tìm kiếm',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             DropdownButtonFormField<String?>(
//               value: selectedLoaiPhong,
//               decoration: const InputDecoration(
//                 labelText: 'Loại phòng',
//                 border: OutlineInputBorder(),
//               ),
//               items: [
//                 const DropdownMenuItem<String?>(
//                     value: null, child: Text('Tất cả loại phòng')),
//                 ...loaiPhongOptions
//                     .map((e) =>
//                         DropdownMenuItem<String?>(value: e, child: Text(e)))
//                     .toList(),
//               ],
//               onChanged: (value) {
//                 setState(() => selectedLoaiPhong = value);
//               },
//             ),

//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: minController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Giá từ (VNĐ)',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: TextField(
//                     controller: maxController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Đến (VNĐ)',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 24),

//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       setState(() {
//                         selectedLoaiPhong = null;
//                         minPrice = null;
//                         maxPrice = null;
//                         minController.clear();
//                         maxController.clear();
//                       });
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Xóa bộ lọc'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         minPrice = double.tryParse(minController.text);
//                         maxPrice = double.tryParse(maxController.text);
//                       });
//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.purpleAccent,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                     child:
//                         const Text('Áp dụng', style: TextStyle(fontSize: 16)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:go_router/go_router.dart';

import 'package:ngoctran/core/routing/app_routes.dart';
import 'package:ngoctran/core/presentation/widget/app_drawer.dart';
import 'package:ngoctran/features/rooms/data/datasources/room_remote_datasource.dart';
import 'package:ngoctran/features/rooms/domain/entities/room_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RoomRemoteDataSource roomDataSource =
      RoomRemoteDataSource(FirebaseFirestore.instance);

  final User? user = FirebaseAuth.instance.currentUser;

  String searchQuery = '';
  String? selectedLoaiPhong;
  double? minPrice;
  double? maxPrice;

  // Controller cho filter
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bootstrapGridParameters(gutterSize: 10);

    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        title: const Text('Trang chủ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFECA7E9),
        centerTitle: true,
      ),
      drawer: AppDrawer(user: user),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // 🔍 Search + Filter Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm phòng theo tên, mã hoặc mô tả...',
                      prefixIcon: const Icon(Icons.search, color: Colors.purple),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
                    onSubmitted: (_) => _validateSearch(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.purple, size: 30),
                  onPressed: () => _showFilterDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 📦 Danh sách phòng
            Expanded(
              child: StreamBuilder<List<Room>>(
                stream: roomDataSource.getRoomsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi tải dữ liệu: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Hiện chưa có phòng nào sẵn sàng.'));
                  }

                  final allRooms = snapshot.data!;
                  final filteredRooms = allRooms.where((room) {
                    if (room.tinhTrang != 'Còn trống') return false;

                    final matchesSearch = searchQuery.isEmpty ||
                        room.tenPhong.toLowerCase().contains(searchQuery) ||
                        room.maPhong.toLowerCase().contains(searchQuery) ||
                        room.moTa.toLowerCase().contains(searchQuery);

                    final matchesType = selectedLoaiPhong == null ||
                        room.loaiPhong == selectedLoaiPhong;

                    final matchesMin = minPrice == null || room.giaPhong >= minPrice!;
                    final matchesMax = maxPrice == null || room.giaPhong <= maxPrice!;

                    return matchesSearch && matchesType && matchesMin && matchesMax;
                  }).toList();

                  if (filteredRooms.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Không tìm thấy phòng phù hợp với bộ lọc.'),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: BootstrapContainer(
                      fluid: true,
                      children: [
                        BootstrapRow(
                          children: filteredRooms
                              .map(
                                (room) => BootstrapCol(
                                  sizes: 'col-12 col-sm-6 col-md-4 col-lg-3',
                                  child: _buildRoomCard(context, room),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🏨 Room Card
  Widget _buildRoomCard(BuildContext context, Room room) {
    final imageUrl = room.hinhAnh.isNotEmpty
        ? room.hinhAnh.first
        : 'https://via.placeholder.com/300x200.png?text=Không+có+ảnh';

    return GestureDetector(
      onTap: () {
        context.push('${AppRoutes.roomDetail}/${room.id}', extra: room);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh phòng
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.tenPhong, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('Mã: ${room.maPhong}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 6),
                  Text(room.moTa, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                  const SizedBox(height: 10),
                  if (room.giaKhuyenMai != null) ...[
                    Text('${room.giaPhong.toStringAsFixed(0)} VNĐ',
                        style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 13, color: Colors.grey)),
                    Text('${room.giaKhuyenMai!.toStringAsFixed(0)} VNĐ/đêm',
                        style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                  ] else
                    Text('${room.giaPhong.toStringAsFixed(0)} VNĐ/đêm',
                        style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔧 Filter Modal
  void _showFilterDialog(BuildContext context) {
    final loaiPhongOptions = ['Standard', 'Deluxe', 'Suite', 'Presidential'];
    _minController.text = minPrice?.toStringAsFixed(0) ?? '';
    _maxController.text = maxPrice?.toStringAsFixed(0) ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bộ lọc tìm kiếm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            DropdownButtonFormField<String?>(
              value: selectedLoaiPhong,
              decoration: const InputDecoration(labelText: 'Loại phòng', border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('Tất cả loại phòng')),
                ...loaiPhongOptions.map((e) => DropdownMenuItem<String?>(value: e, child: Text(e))).toList(),
              ],
              onChanged: (value) => setState(() => selectedLoaiPhong = value),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Giá từ (VNĐ)', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Đến (VNĐ)', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedLoaiPhong = null;
                        minPrice = null;
                        maxPrice = null;
                        _minController.clear();
                        _maxController.clear();
                      });
                      Navigator.of(context).maybePop();
                    },
                    child: const Text('Xóa bộ lọc'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final error = _validateFilter();
                      if (error != null) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(title: const Text('Lỗi'), content: Text(error), actions: [
                            TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('OK'))
                          ]),
                        );
                        return;
                      }

                      setState(() {
                        minPrice = double.tryParse(_minController.text);
                        maxPrice = double.tryParse(_maxController.text);
                      });
                      Navigator.of(context).maybePop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Áp dụng', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


String? _validateSearch() {
  final v = _searchController.text.trim();
  if (v.isEmpty)
   return _showError('Vui lòng nhập từ khoá trước khi tìm kiếm'); // E-1

  if (!_regex(r'^[a-zA-Z0-9\s]+$', v)) 
    return _showError('Từ khóa tìm kiếm không hợp lệ. Vui lòng không dùng ký tự đặc biệt.'); // E-2

  return null;
}

String? _validateFilter() {
  final min = double.tryParse(_minController.text.trim());
  final max = double.tryParse(_maxController.text.trim());

  if (_minController.text.trim().isNotEmpty && min == null)
   return 'Giá tối thiểu phải là số hợp lệ.'; // E-3

  if (_maxController.text.trim().isNotEmpty && max == null)
   return 'Giá tối đa phải là số hợp lệ.';   // E-6
   
  if (min != null && min < 0)
   return 'Giá tối thiểu phải lớn hơn hoặc bằng 0.';                        // E-4

  if (max != null && max < 0)
   return 'Giá tối đa phải lớn hơn hoặc bằng 0.';                           // E-5

  if (min != null && max != null && max < min)
   return 'Giá tối đa phải lớn hơn hoặc bằng giá tối thiểu.'; // E-7

  const validLoaiPhong = ['Standard', 'Deluxe', 'Suite', 'Presidential'];

  if (selectedLoaiPhong != null && !validLoaiPhong.contains(selectedLoaiPhong)) 
    return 'Loại phòng không hợp lệ. Vui lòng chọn từ danh sách có sẵn.'; // E-8

  return null;
}

  String _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(msg),
        actions: [TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('OK'))],
      ),
    );
    return msg;
  }

  bool _regex(String pattern, String value) => RegExp(pattern).hasMatch(value);
}
