import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final _scrollController = ScrollController();

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserController>(context, listen: false).fetchUsers();
    });
    
    _scrollController.addListener(_onScroll);
  }

  void _onScroll(){
    final userController = context.read<UserController>();

    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
      userController.fetchUsers();
    }
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final userController = context.read<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Screen'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(), 
          icon: const Icon(Icons.chevron_left)
        ),
      ),
      body: RefreshIndicator(
        child: Consumer<UserController>(
          builder: (context, controller, child){
            if(controller.users.isEmpty && controller.isLoading){
              return const Center(
                child: CircularProgressIndicator()
              );
            }

            if(controller.users.isEmpty){
              return const Center(
                child: Text('No users found')
              );
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: controller.users.length + (controller.hasMore ? 1 : 0),
              itemBuilder: (context, index){
                if(index == controller.users.length){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final user = controller.users[index];

                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                        radius: 25.5,
                      ),
                      title: Text('${user.firstName} ${user.lastName}'),
                      subtitle: Text(user.email),
                      onTap: (){
                        Navigator.pop(context, '${user.firstName} ${user.lastName}');
                      },
                    ),
                    const Divider(
                      height: 0,
                      indent: 16,
                      endIndent: 16,
                      color: Colors.black12,
                    )
                  ],
                );
              },
            );
          },
        ), 
        onRefresh: () => userController.refresh()
      ),
    );
  }
}
