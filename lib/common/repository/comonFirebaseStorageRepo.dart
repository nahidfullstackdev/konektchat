import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Commonfirebasestoragerepo {
  final FirebaseStorage firebaseStorage;
  Commonfirebasestoragerepo({
    required this.firebaseStorage,
  });

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
