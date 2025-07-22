class DeletedStaffManager {
  static final DeletedStaffManager _instance = DeletedStaffManager._internal();

  factory DeletedStaffManager() => _instance;

  DeletedStaffManager._internal();

  final List<Map<String, dynamic>> _deletedStaff = [];

  List<Map<String, dynamic>> get deletedStaff => _deletedStaff;

  void add(Map<String, dynamic> staff) {
    if (!_deletedStaff.any((e) => e['id'] == staff['id'])) {
      _deletedStaff.add(staff);
    }
  }

  void remove(int id) {
    _deletedStaff.removeWhere((e) => e['id'] == id);
  }
}
