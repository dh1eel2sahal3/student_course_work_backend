import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import 'add_user_screen.dart';
import 'edit_user_screen.dart';

// Shaashadda maamulista isticmaaleyaasha (Admin/Student Management)
class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({Key? key}) : super(key: key);

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Shaqada soo rarista xogta isticmaaleyaasha
  void _loadUsers() {
    _usersFuture = UserService.getUsers();
  }

  // Shaqada dib u cusboonaysiinta barta (Refresh)
  Future<void> _refresh() async {
    setState(() {
      _loadUsers();
    });
  }

  // Shaqada tirtirista isticmaalaha
  Future<void> _deleteUser(String id) async {
    final ok = await UserService.deleteUser(id);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Waa la tirtiray isticmaalaha")),
      );
      _refresh();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wuu fashilmay tirtiristii")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Maamulka Isticmaaleyaasha"),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddUserScreen()),
          );
          if (result == true) {
            _refresh();
          }
        },
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Error loading users"),
                  TextButton(onPressed: _refresh, child: const Text("Retry")),
                ],
              ),
            );
          }

          final users = snapshot.data;

          if (users == null || users.isEmpty) {
            return const Center(
              child: Text("No users found"),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final u = users[index];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.primaryColor,
                      child: Text(
                        u.username.isNotEmpty ? u.username[0].toUpperCase() : 'U',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      "${u.firstName} ${u.lastName}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Username: ${u.username}\nRole: ${u.role}",
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditUserScreen(user: u),
                              ),
                            );
                            if (result == true) {
                              _refresh();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Tirtir Isticmaalaha"),
                                content: const Text(
                                  "Ma hubtaa inaad rabto inaad tirtirto isticmaalahan?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Jooji"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteUser(u.id);
                                    },
                                    child: const Text(
                                      "Tirtir",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}