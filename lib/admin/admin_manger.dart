import 'package:envents/admin/ticket_event.dart';
import 'package:envents/admin/upload_event.dart';
import 'package:envents/widgets/scan_ticket_page.dart';
import 'package:flutter/material.dart';

class AdminManger extends StatelessWidget {
  const AdminManger({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEFFF),
      appBar: AppBar(
        title: const Text(
          'Home Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // không có nút back
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              Navigator.pop(context); // logout về login
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AdminButton(
              iconWidget: Image.asset(
                'assets /images/up.png',
                width: 75,
                height: 75,
              ),
              label: 'Upload Events',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadEvent()),
                );
              },
            ),
            const SizedBox(height: 20),
            AdminButton(
              iconWidget: Image.asset(
                'assets /images/ticket.png',
                width: 75,
                height: 75,
              ),
              label: 'Event Tickets',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TicketEvent()),
                );
              },
            ),
            const SizedBox(height: 20),
            AdminButton(
              iconWidget: ClipOval(
                child: Image.asset(
                  'assets /images/profile.png',
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                ),
              ),
              label: 'Manage Profiles',
              onPressed: () {
                // TODO: Chuyển sang màn quản lý hồ sơ
              },
            ),
            const SizedBox(height: 20),
            AdminButton(
              iconWidget: ClipOval(
                child: Image.asset(
                  'assets /images/scan.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              label: 'Scan ticket',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanTicketPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AdminButton extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final VoidCallback onPressed;
  final Color? iconColor;

  const AdminButton({
    super.key,
    this.icon,
    this.iconWidget,
    required this.label,
    required this.onPressed,
    this.iconColor,
  }) : assert(
         icon != null || iconWidget != null,
         'Bạn phải cung cấp icon hoặc iconWidget!',
       );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shadowColor: Colors.grey.withOpacity(0.3),
          elevation: 5,
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(double.infinity, 70),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget ??
                Icon(icon, size: 40, color: iconColor ?? Colors.black),
            const SizedBox(width: 15),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
