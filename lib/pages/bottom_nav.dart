import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:envents/pages/booking.dart';
import 'package:envents/pages/home.dart';
import 'package:envents/pages/profile.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  late Home home;
  late Booking booking;
  late Profile profile;
  int currenTabIdex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    home = Home();
    booking = Booking();
    profile = Profile();
    pages = [home, booking, profile];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currenTabIdex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.book, color: Colors.white),
          Icon(Icons.person_outline, color: Colors.white),
        ],
      ),
      body: pages[currenTabIdex],
    );
  }
}
