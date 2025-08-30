import 'package:envents/pages/bottom_nav.dart';
import 'package:envents/services/database.dart';
import 'package:envents/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return auth.currentUser;
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Bước 1: Người dùng chọn tài khoản Google
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn();

      // Bước 2: Lấy token từ tài khoản Google
      final GoogleSignInAuthentication? googleAuth =
          await googleSignInAccount?.authentication;

      // Bước 3: Tạo credential để đăng nhập vào Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      // Bước 4: Đăng nhập vào Firebase
      UserCredential result = await firebaseAuth.signInWithCredential(
        credential,
      );
      User? user = result.user;
      await SharedPreferenceHelper().saveUserEmail(user!.email!);
      await SharedPreferenceHelper().saveUserName(user.displayName!);
      await SharedPreferenceHelper().saveUserImage(user.photoURL!);
      await SharedPreferenceHelper().saveUserId(user.uid);

      Map<String, dynamic> userdata = {
        "Name": user.displayName,
        'Email': user.email,
        'Image': user.photoURL,
        'id': user.uid,
      };
      await DatabaseMethods().addUserDetail(userdata, user.uid).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("dang ky thanh cong"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      });

      // ✅ Đăng nhập thành công
      debugPrint("Đăng nhập thành công: ${user.displayName}, ${user.email}");
      return user;
    } catch (e) {
      debugPrint("Lỗi đăng nhập Google: $e");
      return null;
    }
  }
}
