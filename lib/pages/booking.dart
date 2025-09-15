import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envents/services/database.dart';
import 'package:envents/services/shared_pref.dart';
import 'package:envents/widgets/ticketQR_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Stream? bookingStream;
  String? id;

  getthesharepref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharepref();
    bookingStream = await DatabaseMethods().getBooking(id!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  Widget allBookings() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  String inputDate = ds['Date'];
                  DateTime parsedDate = DateTime.parse(inputDate);
                  String formattedDated = DateFormat(
                    'MMM, dd ,yyy',
                  ).format(parsedDate);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketQRPage(
                            ticketCode: ds.id,
                            userTicket: id!,
                            bookingInfo: {
                              'Event': ds['Event'],
                              'Date': ds['Date'],
                              'Location': ds['Location'],
                              'Total': ds['Total'],
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black38, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          // toàn bộ nội dung chính
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    ds['Location'],
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
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        ds['EventImage'],
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
                                          ds['Event'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.date_range_rounded,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              formattedDated,
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
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              ds['Number'],
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 50),
                                            Icon(
                                              Icons.monetization_on_rounded,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              ds['Total'],
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
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

                          Positioned(
                            top: 18,
                            right: -30,
                            child: Transform.rotate(
                              angle: 0.785398, // 45 độ
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 5,
                                ),
                                color: (ds['Checked'] && ds['Checked'] == true)
                                    ? Colors.green
                                    : Colors.red,
                                child: Text(
                                  (ds['Checked'] && ds['Checked'] == true)
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
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Bokings',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height / 1.24,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Expanded(child: allBookings()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
