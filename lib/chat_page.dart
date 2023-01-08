import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_class.dart';

class ChatScreen extends StatelessWidget {
  String user;
  ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ChatLayout(userName: user),
    ));
  }
}

class ChatLayout extends StatefulWidget {
  String userName;
  ChatLayout({Key? key, required this.userName}) : super(key: key);

  @override
  State<ChatLayout> createState() => _State();
}

class _State extends State<ChatLayout> {
  List<String> presentGenres = ['text_active', 'code', 'movie', 'music'];
  String topic = 'TEXT';

  var newMessageController = TextEditingController();
  String newMessage = '';

  var scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.red,
          ),
          width: 70,
          child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: presentGenres.length,
                      itemBuilder: (context, index) => GestureDetector(
                        child: GenreIcon(genre: presentGenres[index]),
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < presentGenres.length; i++) {
                              if (presentGenres[i].contains('active')) {
                                presentGenres[i] = presentGenres[i]
                                    .substring(0, presentGenres[i].length - 7);
                              }
                            }
                            topic = presentGenres[index].toUpperCase();
                            presentGenres[index] = '${presentGenres[index]}_active';
                          });
                        },
                      ),
                    ),
                  ),

                  Container(
                    child: Transform.scale(
                        scaleX: -1,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ))),
                  ),
                ],
              ),
        ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppBar(
                        title: Text(
                          topic,
                          style: GoogleFonts.ubuntu(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection(topic).orderBy('Time').snapshots(),
                            builder: (context, snapshot) {
                              if(snapshot.connectionState == ConnectionState.waiting)
                                {
                                  return Center(
                                    child: Text('Loading..',
                                    style: GoogleFonts.ubuntu(
                                      color: Colors.red,
                                    ),),
                                  );
                                }
                              else if(snapshot.hasError)
                                {
                                  return Text(
                                    'Something went wrong',
                                    style: GoogleFonts.ubuntu(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              else
                                {
                                  List messageList = snapshot.data!.docs.map((e) => toMessage(e.data())).toList();
                                  return ListView.builder(
                                    controller: scrollController,
                                      itemCount: messageList.length,
                                      itemBuilder: (context, index) {
                                        if (messageList[index].user ==
                                            widget.userName) {
                                          return Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(4))
                                              ),
                                              margin: const EdgeInsets.fromLTRB(120, 10, 10, 10),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(widget.userName,
                                                      style: GoogleFonts
                                                          .ubuntu(color: Colors.white,
                                                      ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(messageList[index]
                                                        .message,
                                                    style: const TextStyle(color: Colors.white),),
                                                  ),
                                                ],
                                              )
                                          );
                                        }
                                        else {
                                          return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                  borderRadius: const BorderRadius
                                                      .all(Radius.circular(4))
                                              ),
                                              margin: const EdgeInsets.fromLTRB(10, 10, 120, 10),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(messageList[index].user,
                                                      style: GoogleFonts
                                                          .ubuntu(color: Colors.red),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(messageList[index]
                                                        .message),
                                                  ),
                                                ],
                                              )
                                          );
                                        }
                                      }
                                      );
                                }
                            }
                          )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: TextField(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(5)),
                                      ),
                                      hintText: 'New message',
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.red,
                                      ))),
                              controller: newMessageController,
                              onChanged: (value) => newMessage = value
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: () {},
                              backgroundColor: Colors.red,
                              child: IconButton(
                                onPressed: () {
                                  if(newMessage != '')
                                    {
                                      var temp = Message(widget.userName, newMessage);
                                      FirestoreCRUD().send(topic, temp);
                                      newMessageController.clear();
                                    }
                                },
                                icon: const Icon(Icons.send),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}

class GenreIcon extends StatelessWidget {
  String genre;
  GenreIcon({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.red,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: genre.contains('active') ? Colors.white : Colors.red,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          width: 50,
          height: 50,
          child: Image.asset('lib/Images/${genre}_icon.png'),
        ),
      ),
    );
  }
}
