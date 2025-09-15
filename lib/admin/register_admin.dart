import 'package:flutter/material.dart';
import 'package:envents/services/auth.dart';

class RegisterAdmin extends StatefulWidget {
  const RegisterAdmin({super.key});

  @override
  State<RegisterAdmin> createState() => _RegisterAdminState();
}

class _RegisterAdminState extends State<RegisterAdmin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng ký Admin")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: "Nhập email admin"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: "Nhập mật khẩu"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var user = await AuthMethods().signUpWithEmailAndPassword(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                if (user != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Đăng ký thành công")));
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Đăng ký thất bại")));
                }
              },
              child: Text("Đăng ký"),
            ),
          ],
        ),
      ),
    );
  }
}
