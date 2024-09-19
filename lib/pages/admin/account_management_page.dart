import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_example/components/my_app_bar.dart';
import 'package:login_example/components/my_circular_progress_indicator.dart';
import 'package:login_example/components/my_drawer_item.dart';
import 'package:login_example/models/user_model.dart';

class AccountManagementPage extends StatelessWidget {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<UserModel>> getAdmin() {
    return firebaseFirestore.collection('users').where('isManager', isEqualTo: true).snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());
  }

  Stream<List<UserModel>> getUsers() {
    return firebaseFirestore.collection('users').where('isManager', isEqualTo: false).snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());
  }

  AccountManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Account Management'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: StreamBuilder(
                stream: getAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: MyCircularProgressIndicator(strokeWidth: 5.0),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching accounts'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No admin found'),
                    );
                  }
                  final admins = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: admins.length,
                    itemBuilder: (context, index) {
                      final admin = admins[index];
                      return Column(
                        children: [
                          MyDrawerItem(
                            icon: Icons.admin_panel_settings_rounded,
                            text: admin.email,
                            subtitle: const Text(
                              'Admin',
                            ),
                          ),
                          if (index < admins.length - 1) const Divider(),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: StreamBuilder(
                stream: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: MyCircularProgressIndicator(strokeWidth: 5.0),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching accounts'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No users found'),
                    );
                  }
                  final users = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length + 1,
                    itemBuilder: (context, index) {
                      if (index == users.length) {
                        return MyDrawerItem(
                          icon: Icons.add_rounded,
                          text: 'Add an account',
                        );
                      }
                      final user = users[index];
                      return Column(
                        children: [
                          MyDrawerItem(
                            icon: Icons.person,
                            text: user.email,
                            subtitle: const Text(
                              'Customer',
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
