import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserController with ChangeNotifier {
  List<User> _users = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (_isLoading || (!isRefresh && !_hasMore)) return;

    _isLoading = true;
    if (isRefresh) {
      _currentPage = 1;
      _users = [];
      _totalPages = 1;
      _hasMore = true;
    }
    notifyListeners();

    try {
      final apiKey = 'reqres-free-v1';
      final response = await http.get(
        Uri.parse(
          'https://reqres.in/api/users?page=$_currentPage&per_page=10&api_key=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (_currentPage == 1) {
          _totalPages = data['total_pages'];
        }

        final List<dynamic> userList = data['data'];
        final List<User> fetchedUsers = userList
            .map((json) => User.fromJson(json))
            .toList();

        _users.addAll(fetchedUsers);

        _hasMore = _currentPage < _totalPages;

        if (_hasMore) {
          _currentPage++;
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchUsers(isRefresh: true);
  }
}
