import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQRPage extends StatelessWidget {
  final String ticketCode, userTicket; // mã vé hoặc ID booking
  final Map<String, dynamic> bookingInfo; // thông tin vé để hiển thị

  const TicketQRPage({
    super.key,
    required this.ticketCode,
    required this.userTicket,
    required this.bookingInfo,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = '{"userId":"$userTicket","bookingId":"$ticketCode"}';
    return Scaffold(
      appBar: AppBar(title: Text('Your Ticket')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(data: qrData, version: QrVersions.auto, size: 250),
            SizedBox(height: 20),
            Text(
              bookingInfo['Event'],
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            // Text("Date: ${bookingInfo['Date']}"),
            // Text("data: $qrData"),
            // Text("Location: ${bookingInfo['Location']}"),
            // Text("Total: ${bookingInfo['Total']}"),
          ],
        ),
      ),
    );
  }
}
