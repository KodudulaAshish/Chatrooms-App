import 'package:chatrooms_app/chat_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  var userNameController = TextEditingController();
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                padding: EdgeInsets.all(20),
                height: 500,
                child: Center(
                  child: Image.asset('lib/Images/chat_icon.png', scale: 0.01),
                ),
              ),
            ),
            Container(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(35),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.red,
                        )),
                        hintText: 'User Name',
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (userNameController.text != '') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(user: userNameController.text)));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(title: Text('User Name pls!!'),));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 40),
                    backgroundColor: Colors.red[600],
                  ),
                  child: const Text('CHAT'),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
