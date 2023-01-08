import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  var time = DateTime.now();
  var user;
  var message;

  Message(this.user, this.message);

  toMap() {
    return <String, dynamic>{
      'Time': DateTime.now(),
      'User': user,
      'Message': message,
    };
  }
}

Message toMessage(Map<String, dynamic> raw) {
  return (Message(raw['User'], raw['Message']));
}

var db = FirebaseFirestore.instance;

class FirestoreCRUD
{
  send(String collection, Message msg)
  async{
    await db.collection(collection).add(msg.toMap());
  }

  getMessagesStream(String collection)
  async{
    Stream myStream = db.collection(collection).snapshots();
    return myStream;
  }
}
