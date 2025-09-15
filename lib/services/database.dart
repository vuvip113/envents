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

  // Future addUserBooking(Map<String, dynamic> userInfoMap, String id) async {
  //   return await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(id)
  //       .collection('Booking')
  //       .add(userInfoMap);
  // }

  Future<String> addUserBooking(
    Map<String, dynamic> userInfoMap,
    String id,
  ) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Booking')
        .add(userInfoMap);
    return docRef.id; // trả về bookingId
  }

  // Future addAdminTicket(Map<String, dynamic> userInfoMap) async {
  //   return await FirebaseFirestore.instance
  //       .collection('Tickets')
  //       .add(userInfoMap);
  // }

  Future<void> addAdminTicket(
    Map<String, dynamic> userInfoMap,
    String ticketId,
  ) async {
    await FirebaseFirestore.instance
        .collection('Tickets')
        .doc(ticketId) // sử dụng cùng ID
        .set(userInfoMap);
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

  Future<QuerySnapshot> searchByFirstLetter(String firstChar) async {
    return await FirebaseFirestore.instance
        .collection('Event')
        .where('SearchKey', isEqualTo: firstChar)
        .get();
  }

  Future<DocumentSnapshot> getBookingById(
    String userId,
    String bookingId,
  ) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Booking')
        .doc(bookingId)
        .get();
  }

  Future<void> updateBookingChecked(String userId, String bookingId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Booking')
        .doc(bookingId)
        .update({'Checked': true});
  }

  Future<void> updateTicketChecked(String ticketId) async {
    await FirebaseFirestore.instance.collection('Tickets').doc(ticketId).update(
      {'Checked': true},
    );
  }
}
