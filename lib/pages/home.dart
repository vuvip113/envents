import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envents/pages/categories_event.dart';
import 'package:envents/pages/detail_page.dart';
import 'package:envents/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? eventStream;

  ontheload() async {
    eventStream = await DatabaseMethods().getallEvents();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  bool search = false;

  var queryResultSet = [];
  var tempSearchStore = [];

  TextEditingController searchController = TextEditingController();

  initiateSearch(String value) async {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        search = false;
      });
      return;
    }

    String searchText = value.toUpperCase();
    String firstChar = searchText[0];

    // Nếu queryResultSet rỗng hoặc ký tự đầu tiên khác trước đó → query Firestore
    if (queryResultSet.isEmpty ||
        queryResultSet.first['SearchKey'] != firstChar) {
      QuerySnapshot docs = await DatabaseMethods().searchByFirstLetter(
        firstChar,
      );
      queryResultSet = docs.docs
          .map((e) => e.data() as Map<String, dynamic>)
          .toList();
    }

    // Filter tiếp trên Flutter
    tempSearchStore = [];
    for (var element in queryResultSet) {
      if (element['UpdatedName'] != null &&
          element['UpdatedName'].startsWith(searchText)) {
        tempSearchStore.add(element);
      }
    }

    setState(() {
      search = true;
    });
  }

  Widget allEvents() {
    return StreamBuilder(
      stream: eventStream,
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
                    'MMM, dd',
                  ).format(parsedDate);

                  DateTime currentDate = DateTime.now();
                  bool hasPassed = currentDate.isAfter(parsedDate);
                  return hasPassed
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  date: ds['Date'],
                                  detail: ds['Detail'],
                                  image: ds['Image'],
                                  location: ds['Location'],
                                  name: ds['Name'],
                                  price: ds['Price'],
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(10),
                                      child: Image.network(
                                        ds['Image'],
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 10,
                                        top: 10,
                                      ),
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        formattedDated,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ds['Name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Text(
                                      '\$' + ds['Price'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          4,
                                          255,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_rounded),
                                  Text(
                                    ds['Location'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                },
              )
            : Container();
      },
    );
  }

  Widget buildResultcard(Map<String, dynamic> element) {
    return GestureDetector(
      onTap: () {
        // xử lý khi click vào kết quả (ví dụ: mở trang profile / details)
        print("Bạn chọn: ${element['UpdatedName']}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              date: element['Date'],
              detail: element['Detail'],
              image: element['Image'],
              location: element['Location'],
              name: element['Name'],
              price: element['Price'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Avatar
                element["Image"] != null && element["Image"] != ""
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(element["Image"]),
                        radius: 25,
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 25,
                        child: Icon(Icons.person, color: Colors.white),
                      ),

                const SizedBox(width: 12),

                // Thông tin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        element["UpdatedName"] ?? "No Name",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$' + element["Price"],
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(Icons.add, size: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50, bottom: 50, left: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_rounded),
                Text(
                  'khoi 8 thi tran dak to',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Hello, Vanitas',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'there are 13 events\naround your location',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xff6351ec),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(right: 20),
              padding: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      queryResultSet = [];
                      tempSearchStore = [];
                      search = false; // thêm để ẩn list khi xoá hết text
                    });
                  } else {
                    initiateSearch(value);
                    setState(() {
                      search = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search_rounded),
                  border: InputBorder.none,
                  hintText: 'Tim kiem vi tri',
                ),
              ),
            ),
            SizedBox(height: 20),
            search
                ? ListView(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    primary: false,
                    shrinkWrap: true,
                    children: tempSearchStore.map((element) {
                      return buildResultcard(element);
                    }).toList(),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoriesEvent(eventcategory: 'Music'),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Material(
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 130,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets /images/musical.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        Text(
                                          'Music',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoriesEvent(
                                      eventcategory: 'Clothing',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Material(
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 130,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets /images/tshirt.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        Text(
                                          'Clothing',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoriesEvent(
                                      eventcategory: 'Festival',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Material(
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 130,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets /images/confetti.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        Text(
                                          'Festival',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoriesEvent(eventcategory: 'Food'),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Material(
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 130,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets /images/dish.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        Text(
                                          'Food',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upcoming events',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        // height: 200,
                        // width: MediaQuery.of(context).size.width,
                        child: allEvents(),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
