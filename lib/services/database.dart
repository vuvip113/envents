import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  Future addEvent(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Event')
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getallEvents() async {
    return FirebaseFirestore.instance.collection('Event').snapshots();
  }

  Future addUserBooking(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Booking')
        .add(userInfoMap);
  }

  Future addAdminTicket(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('Tickets')
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getBooking(String id) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Booking')
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getEventCategories(String categoty) async {
    return FirebaseFirestore.instance
        .collection('Event')
        .where('Category', isEqualTo: categoty)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getTickets() async {
    return FirebaseFirestore.instance.collection('Tickets').snapshots();
  }
}
