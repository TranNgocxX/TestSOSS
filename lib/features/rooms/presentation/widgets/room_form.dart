import 'package:flutter/material.dart';
import '../../domain/entities/room_entity.dart';

class RoomForm extends StatefulWidget {
  final Room? room;
  final Function(Room) onSubmit;

  const RoomForm({super.key, this.room, required this.onSubmit});

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  final _formKey = GlobalKey<FormState>();
  final _c = <String, TextEditingController>{};

  String loaiPhong = 'Standard';
  String tinhTrang = 'Còn trống';

  @override
  void initState() {
    super.initState();
    _init('maPhong', widget.room?.maPhong);
    _init('tenPhong', widget.room?.tenPhong);
    _init('giaPhong', widget.room?.giaPhong);
    _init('giaKhuyenMai', widget.room?.giaKhuyenMai);
    _init('dienTich', widget.room?.dienTich);
    _init('soKhach', widget.room?.soKhachToiDa);
    _init('moTa', widget.room?.moTa);
    _init('anh', widget.room?.hinhAnh.join(', '));
    _init('video', widget.room?.video);
    _init('tienNghi', widget.room?.tienNghi.join(', '));

    loaiPhong = widget.room?.loaiPhong ?? 'Standard';
    tinhTrang = widget.room?.tinhTrang ?? 'Còn trống';
  }

  void _init(String k, dynamic v) {
    _c[k] = TextEditingController(text: v?.toString() ?? '');
  }

  TextEditingController c(String k) => _c[k]!;

  // ================= VALIDATORS VỚI E-CODE =================

  // E1: Mã phòng bị trùng
  String? _maPhongValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Mã phòng không được bỏ trống'; // E1
    if (!_regex(r'^[a-zA-Z0-9]+$', v)) return 'Mã phòng chỉ được chữ và số'; // E1
    // TODO: Kiểm tra trùng trên Firestore → nếu trùng: return 'Mã phòng đã tồn tại'; // E1
    return null;
  }

  // E2-E5: Tên phòng

  String? _tenPhongValidator(String? v) {
    if (v == null || v.trim().isEmpty)     // E2
      return 'Tên phòng không được để trống'; 
    if (!_regex(r'^[a-zA-Z0-9\s]+$', v))     // E3
      return 'Tên phòng không được chứa ký tự đặc biệt'; 
    if (v.length > 150)     // E4
      return 'Tên phòng không được vượt quá 150 ký tự'; 

    return null;
  }

  // E6: Loại phòng

  String? _loaiPhongValidator(String? v) {
    if (v == null || v.isEmpty) return 'Vui lòng chọn loại phòng'; // E6
    return null;
  }

  // E7-E9: Giá phòng
  String? _giaPhongValidator(String? v) {

    if (v == null || v.trim().isEmpty) return 'Giá phòng không được để trống'; 

    if (!_regex(r'^\d+(\.\d+)?$', v)) return 'Giá phòng phải là số hợp lệ và không được chứa chữ/ký tự đặc biệt'; 

    if (double.parse(v) <= 0) return 'Giá phòng phải là số dương lớn hơn 0'; 

    return null;
  }

  // E10-E12: Giá khuyến mãi
  // không bắt buộc 
  String? _giaKhuyenMaiValidator(String? v) {
    if (v == null || v.trim().isEmpty) {
      return null;
    }

    if (!_regex(r'^\d+(\.\d+)?$', v)){
      return 'Giá khuyến mãi phải là số hợp lệ và không được chứa chữ/ký tự đặc biệt'; // E11
    }

    final km = double.parse(v);
    if (km <= 0){
      return 'Giá khuyến mãi phải > 0'; // E10
    }

    final gia = double.tryParse(c('giaPhong').text) ?? 0;
    if (km > gia){
      return 'Giá khuyến mãi phải nhỏ hơn hoặc bằng giá phòng gốc'; // E12
    } 

    return null;
  }

  // E13-E14: Số khách tối đa

  String? _soKhachValidator(String? v) {
    if (v == null || v.trim().isEmpty) 
      return 'Số lượng khách tối đa không được để trống.'; 

    if (!_regex(r'^[1-9]\d*$', v))
     return 'Số khách tối đa phải là số nguyên dương và không được chứa chữ/ký tự đặc biệt'; 

    return null;
  }

  // E15-E16: Mô tả
  String? _moTaValidator(String? v) {

    if (v == null || v.trim().isEmpty) 
      return 'Mô tả phòng không được để trống'; // E15
    
    if (v.length > 2000) 
      return 'Mô tả phòng không được vượt quá 2000 ký tự'; // E16

    return null;
  }

  // E17-E19: Diện tích phòng
  String? _dienTichValidator(String? v) {

    if (v == null || v.trim().isEmpty)
     return 'Vui lòng nhập diện tích phòng'; // E17

    if (!_regex(r'^\d+(\.\d+)?$', v))
     return 'Diện tích phòng phải là số hợp lệ và không được chứa chữ/ký tự đặc biệt'; // E19

    if (double.parse(v) <= 0)
     return 'Diện tích phòng phải lớn hơn 0'; // E18

    return null;
  }

  // E20: Tiện nghi
  String? _tienNghiValidator(String? v) {
    if (v == null || v.trim().isEmpty) 
      return 'Vui lòng chọn ít nhất 1 tiện nghi'; // E20
      
    return null;
  }

  // E21-E23: Hình ảnh

  String? _hinhAnhValidator(String? v) {
    if (v == null || v.trim().isEmpty) 
      return 'Hình ảnh phòng không được để trống'; // E-21
    for (final img in v.split(',')) {
      final i = img.trim();
      if (!i.endsWith('.jpg') && !i.endsWith('.png')) 
        return 'Ảnh phải có định dạng jpg hoặc png.'; // E-22
    }
    return null;
  }

  // E24-E25: Video
  // không bắt buộc 
  String? _videoValidator(String? v) {
    if (v == null || v.trim().isEmpty) 
      return null;

    if (!v.endsWith('.mp4') && !v.endsWith('.mov')) 
      return 'Vui lòng tải lên video hợp lệ (mp4, mov)'; // E-24

    return null;
  }

  bool _regex(String pattern, String value) =>
      RegExp(pattern).hasMatch(value);

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _f('Mã phòng', c('maPhong'), _maPhongValidator),
                _f('Tên phòng', c('tenPhong'), _tenPhongValidator),
                _f('Giá phòng', c('giaPhong'), _giaPhongValidator, num: true),
                _f('Giá khuyến mãi', c('giaKhuyenMai'), _giaKhuyenMaiValidator, num: true),
                _f('Diện tích (m²)', c('dienTich'), _dienTichValidator, num: true),
                _f('Số khách tối đa', c('soKhach'), _soKhachValidator, num: true),
                _f('Tiện nghi (cách ,)', c('tienNghi'), _tienNghiValidator),
                _f('Hình ảnh (jpg/png)', c('anh'), _hinhAnhValidator),
                _f('Video (mp4/mov)', c('video'), _videoValidator),
                _f('Mô tả', c('moTa'), _moTaValidator, max: 3),

                DropdownButtonFormField(
                  value: loaiPhong,
                  decoration: const InputDecoration(labelText: 'Loại phòng'),
                  items: ['Standard', 'Deluxe', 'Suite', 'VIP']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => loaiPhong = v!),
                  validator: _loaiPhongValidator,
                ),

                const SizedBox(height: 20),
                ElevatedButton(onPressed: _submit, child: const Text('Lưu phòng')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _f(String label, TextEditingController c,
      String? Function(String?) validator,
      {bool num = false, int max = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        maxLines: max,
        keyboardType: num ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label),
        validator: validator,
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(Room(
      id: widget.room?.id ?? '',
      maPhong: c('maPhong').text.trim(),
      tenPhong: c('tenPhong').text.trim(),
      loaiPhong: loaiPhong,
      giaPhong: double.parse(c('giaPhong').text),
      giaKhuyenMai: c('giaKhuyenMai').text.isEmpty
          ? null
          : double.parse(c('giaKhuyenMai').text),
      soKhachToiDa: int.parse(c('soKhach').text),
      dienTich: double.parse(c('dienTich').text),
      moTa: c('moTa').text.trim(),
      tienNghi: c('tienNghi').text.split(',').map((e) => e.trim()).toList(),
      hinhAnh: c('anh').text.split(',').map((e) => e.trim()).toList(),
      video: c('video').text.isEmpty ? null : c('video').text.trim(),
      tinhTrang: tinhTrang,
    ));

    Navigator.pop(context);
  }
}
