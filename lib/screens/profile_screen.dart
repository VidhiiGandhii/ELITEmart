import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_shop/screens/loginScreen.dart';
import 'package:my_shop/theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      return {'name': 'Guest', 'email': 'Not signed in'};
    }
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return {
        'name': doc.data()?['name'] ?? 'Unknown',
        'email': doc.data()?['email'] ?? user.email ?? 'Unknown',
      };
    }
    return {'name': user.email ?? 'Unknown', 'email': user.email ?? 'Unknown'};
  }

  void _showComingSoon(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        content: Text("This feature will be available soon!", style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Logout", style: Theme.of(context).textTheme.titleLarge),
        content: Text("Are you sure you want to logout?", style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Text(
              "Logout",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.redAccent,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<Map<String, String>>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}", style: Theme.of(context).textTheme.bodyMedium));
              }

              final userData = snapshot.data ?? {'name': 'Unknown', 'email': 'Unknown'};

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    child: SvgPicture.asset('images/profile_pic.svg', width: 80),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData['name']!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userData['email']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 30),
                  buildListTile(context, Icons.person, "Edit Profile"),
                  const Divider(),
                  buildListTile(context, Icons.lock, "Change Password"),
                  const Divider(),
                  buildListTile(context, Icons.history, "Order History"),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.redAccent),
                    title: Text('Logout', style: Theme.of(context).textTheme.bodyMedium),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.onSurface),
                    onTap: () => _logout(context),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.onSurface),
      onTap: () => _showComingSoon(context, title),
    );
  }
}