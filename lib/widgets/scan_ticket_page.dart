import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envents/services/database.dart';
import 'package:envents/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanTicketPage extends StatefulWidget {
  const ScanTicketPage({super.key});

  @override
  State<ScanTicketPage> createState() => _ScanTicketPageState();
}

class _ScanTicketPageState extends State<ScanTicketPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = "";
  Map<String, dynamic>? bookingData;

  // Fix camera hot reload cho Android/iOS
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) controller!.pauseCamera();
    controller!.resumeCamera();
  }

  String? userId;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      final scannedString = scanData.code!;
      final Map<String, dynamic> qrMap = jsonDecode(scannedString);

      userId = qrMap['userId'];
      final String bookingId = qrMap['bookingId'];

      print("userId: $userId");
      print("bookingId: $bookingId");

      DocumentSnapshot bookingDoc = await DatabaseMethods().getBookingById(
        userId!,
        bookingId,
      );

      setState(() {
        scannedData = bookingId;
        bookingData = bookingDoc.exists
            ? bookingDoc.data() as Map<String, dynamic>
            : null;
      });

      controller.pauseCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Ticket')),
      body: Column(
        children: [
          SizedBox(
            height: 350,
            width: MediaQuery.of(context).size.width,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Center(
                child: bookingData == null
                    ? Text(
                        scannedData.isEmpty
                            ? "Scan a ticket QR code"
                            : "Booking not found",
                        style: TextStyle(fontSize: 20),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Scanned ID: $scannedData",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Booking info:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          bookingData == null
                              ? Text("Booking not found")
                              : Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black38,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      /// Nội dung chính
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                bookingData!['Location'],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              bottom: 10,
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.network(
                                                    bookingData!['EventImage'],
                                                    width: 120,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      bookingData!['Event'],
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .date_range_rounded,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          bookingData!['Date'], // hoặc formattedDate
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.group,
                                                          color: Colors.red,
                                                          size: 30,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          bookingData!['Number']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        SizedBox(width: 50),
                                                        Icon(
                                                          Icons
                                                              .monetization_on_rounded,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          bookingData!['Total']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      /// Ribbon chéo góc
                                      Positioned(
                                        top: 17,
                                        right: -30,
                                        child: Transform.rotate(
                                          angle: 0.785398, // 45 độ (pi/4 rad)
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 30,
                                              vertical: 5,
                                            ),
                                            color:
                                                (bookingData!['Checked'] ==
                                                    true)
                                                ? Colors.green
                                                : Colors.red,
                                            child: Text(
                                              (bookingData!['Checked'] == true)
                                                  ? "CHECKED"
                                                  : "CHƯA CHECK",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(height: 30),
                          bookingData!['Checked'] == false
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (bookingData != null) {
                                        try {
                                          await DatabaseMethods()
                                              .updateBookingChecked(
                                                userId!,
                                                scannedData,
                                              );
                                          await DatabaseMethods()
                                              .updateTicketChecked(scannedData);

                                          // Cập nhật lại UI sau khi check
                                          setState(() {
                                            bookingData!['Checked'] = true;
                                          });

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Ticket đã được xác nhận!",
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Lỗi khi xác nhận: $e",
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text(
                                      "Xac nhan ticket",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
