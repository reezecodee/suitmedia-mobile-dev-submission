import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final _userController = UserController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _userController.addListener(() {
      setState(() {});
    });

    _scrollController.addListener(_onScroll);
    _userController.fetchUsers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _userController.fetchUsers();
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Screen'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF554AF0), size: 30),
      ),
      body: RefreshIndicator(
        child: _buildUserList(),
        onRefresh: () => _userController.refresh(),
      ),
    );
  }

  Widget _buildUserList() {
    if (_userController.users.isEmpty && _userController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_userController.users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount:
          _userController.users.length + (_userController.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _userController.users.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = _userController.users[index];
        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
                radius: 24.5,
              ),
              title: Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                user.email,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context, '${user.firstName} ${user.lastName}');
              },
            ),
            const Divider(
              height: 0,
              indent: 16,
              endIndent: 16,
              color: Colors.black12,
            ),
          ],
        );
      },
    );
  }
}
