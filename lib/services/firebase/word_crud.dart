import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/favorite_model.dart';


class WordCRUD {
   Future create({required String word, required String lang}) async {
    String user = FirebaseAuth.instance.currentUser!.uid;

    var data = FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('favorites')
        .doc();
    await data.set(
      {
        'id': data.id,
        'word': word,
        'created_date': DateTime.now(),
        'lang': lang,
      },
    );
  }

   Future delete(String word) async {
    String user = FirebaseAuth.instance.currentUser!.uid;

    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('favorites')
        .where('word', isEqualTo: word)
        .get();

    String id = doc.docs[0].id;
    var data = FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('favorites')
        .doc(id);

    await data.delete();
  }

   Stream<List<FavoriteModel>> getFavorites() {
    String user = FirebaseAuth.instance.currentUser!.uid;

    Stream<List<FavoriteModel>> data = FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('favorites')
        .orderBy('created_date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavoriteModel.fromJson(doc.data()))
            .toList());
    ;
    return data;
  }
}
