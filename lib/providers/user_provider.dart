import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

// مدیریت کاربران
class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  List<UserModel> _allUsers = [];

  UserModel? get currentUser => _currentUser;
  List<UserModel> get allUsers => _allUsers;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == UserRole.admin;

  String get name => _currentUser?.name ?? '';
  String get email => _currentUser?.email ?? '';
  String get phone => _currentUser?.phone ?? '';
  String get username => _currentUser?.username ?? '';
  String get imagePath => _currentUser?.imagePath ?? '';
  UserRole? get role => _currentUser?.role;

  UserProvider() {
    _initializeDefaultAdmin();
    loadUserData();
  }

  Future<void> _initializeDefaultAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final userListData = prefs.getStringList('all_users') ?? [];

    // اگر ادمین در لیست وجود نداشت، اضافه کن
    if (!userListData.any((e) => UserModel.fromMap(jsonDecode(e)).username == 'admin')) {
      final admin = UserModel(
        name: 'ادمین',
        email: 'admin@example.com',
        phone: '09120000000',
        username: 'admin',
        password: 'admin123',
        imagePath: '',
        role: UserRole.admin,
      );
      userListData.add(jsonEncode(admin.toMap()));
      await prefs.setStringList('all_users', userListData);
    }
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    if (isLoggedIn) {
      final userJson = prefs.getString('logged_in_user');
      if (userJson != null) {
        _currentUser = UserModel.fromMap(jsonDecode(userJson));
      }
    }

    final userListData = prefs.getStringList('all_users') ?? [];
    _allUsers = userListData
        .map((userJson) => UserModel.fromMap(jsonDecode(userJson)))
        .whereType<UserModel>()
        .toList();

    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final newUser = UserModel(
      name: name,
      email: email,
      phone: phone,
      username: username,
      password: password,
      imagePath: '',
      role: UserRole.user,
    );

    final userListData = prefs.getStringList('all_users') ?? [];
    userListData.add(jsonEncode(newUser.toMap()));
    await prefs.setStringList('all_users', userListData);

    _allUsers.add(newUser);
    _currentUser = newUser;
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('logged_in_user', jsonEncode(newUser.toMap()));
    await loadUserData();

    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userListData = prefs.getStringList('all_users') ?? [];

    for (final jsonStr in userListData) {
      final user = UserModel.fromMap(jsonDecode(jsonStr));
      if (user.username == username && user.password == password) {
        _currentUser = user;
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('logged_in_user', jsonEncode(user.toMap()));
        await loadUserData();

        notifyListeners();

        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('logged_in_user');
    _currentUser = null;
    await loadUserData();

    notifyListeners();
  }

  Future<void> deleteUser(String username) async {
    if (username == 'admin') return; // ادمین پاک نشه

    final prefs = await SharedPreferences.getInstance();
    _allUsers.removeWhere((user) => user.username == username);
    await prefs.setStringList(
      'all_users',
      _allUsers.map((u) => jsonEncode(u.toMap())).toList(),
    );

    if (_currentUser?.username == username) {
      await logout();
    }

    await loadUserData();

    notifyListeners();
  }

  Future<void> saveUsersToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonList = _allUsers.map((user) => json.encode(user.toMap())).toList();
    await prefs.setStringList('all_users', userJsonList);
    print(prefs.getStringList('all_users'));
  }

  Future<void> updateUser({
    required String name,
    required String email,
    required String phone,
    String? imagePath,
  }) async {
    if (_currentUser == null) return;

    final updatedUser = UserModel(
      name: name,
      email: email,
      phone: phone,
      username: _currentUser!.username,
      password: _currentUser!.password,
      imagePath: imagePath ?? _currentUser!.imagePath,
      role: _currentUser!.role,
    );
    await updateUserByUsername(_currentUser!.username, updatedUser);
  }

  Future<void> updateUserByUsername(String username ,UserModel updated) async {
    final userIndex = _allUsers.indexWhere((user) => user.username == username);

    if (userIndex == -1) {
      throw Exception('کاربر پیدا نشد');
    }

    final oldUser = _allUsers[userIndex];

    final updatedUser = UserModel(
      username: oldUser.username,
      password: oldUser.password,
      name: updated.name,
      email: updated.email,
      phone: updated.phone,
      imagePath: updated.imagePath,
      role: oldUser.role,
    );

    _allUsers[userIndex] = updatedUser;

    // اگر currentUser هم همونه، بروزرسانی بشه:
    if (_currentUser?.username == username) {
      _currentUser = updatedUser;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_in_user', jsonEncode(_currentUser!.toMap()));
    }
    await saveUsersToPrefs();
    await loadUserData();
    notifyListeners();
  }

  Future<bool> changePassword(String username, String newPassword) async {
    try {
      final userIndex = _allUsers.indexWhere((user) => user.username == username);

      if (userIndex == -1) {
        throw Exception('Error to change password کاربر  پیدا نشد');
      }

      final oldUser = _allUsers[userIndex];
      final updatedUser = UserModel(
        username: oldUser.username,
        password: newPassword,
        name: oldUser.name,
        email: oldUser.email,
        phone: oldUser.phone,
        imagePath: oldUser.imagePath,
        role: oldUser.role,
      );

      _allUsers[userIndex] = updatedUser;

      if (_currentUser?.username == username) {
        _currentUser = updatedUser;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('logged_in_user', jsonEncode(_currentUser!.toMap()));
      }

      await saveUsersToPrefs();
      await loadUserData();

      notifyListeners();

      return true;
    }catch (e) {
      print('Error To Change Password : $e');
      return false;
    }
  }
}



