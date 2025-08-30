import 'package:envents/pages/sign_up.dart';
import 'package:envents/services/auth.dart';
import 'package:envents/services/shared_pref.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email, id;

  getthesharepref() async {
    id = await SharedPreferenceHelper().getUserId();
    image = await SharedPreferenceHelper().getUserImage();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();

    setState(() {});
  }

  ontheload() async {
    await getthesharepref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar (ảnh nếu có, fallback = chữ cái đầu)
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.teal[700],
              backgroundImage: (image != null && image!.isNotEmpty)
                  ? NetworkImage(image!)
                  : null,
              child: (image == null || image!.isEmpty)
                  ? Text(
                      (name != null && name!.isNotEmpty)
                          ? name![0].toUpperCase()
                          : "U",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),

            const SizedBox(height: 24),

            // Name
            if (name != null)
              InfoBox(icon: Icons.person, label: 'Name', value: name!),

            const SizedBox(height: 12),

            // Email
            if (email != null)
              InfoBox(icon: Icons.email, label: 'Email', value: email!),

            const SizedBox(height: 12),

            // Contact Us
            ActionBox(
              icon: Icons.contact_page,
              text: 'Contact Us',
              onTap: () {
                // TODO: Contact action
              },
            ),

            const SizedBox(height: 12),

            // Logout
            ActionBox(
              icon: Icons.logout,
              text: 'LogOut',
              onTap: () {
                AuthMethods().signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                });
              },
            ),

            const SizedBox(height: 12),

            // Delete Account
            ActionBox(
              icon: Icons.delete,
              text: 'Delete Account',
              onTap: () {
                AuthMethods().deleteUser().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoBox({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActionBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;

  const ActionBox({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      splashColor: Colors.blue.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
