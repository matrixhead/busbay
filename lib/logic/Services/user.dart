import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:busbay/logic/Services/Model.dart';
import 'package:busbay/logic/Services/userData.dart';

class UserService{

  final String uid;
  UserService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String department,String email) async{
    return await userCollection.doc(uid).set({
      'name': name,
      'department':department,
      'email':email
    });
  }
  List<Model> _modelListFromSnapshot(QuerySnapshot snapshot){
      return snapshot.docs.map((doc){
          return Model(
            name: doc.data()['name'] ??'',
            email: doc.data()['email'] ??'',
            department: doc.data()['department'] ??'Nill',
          );
      }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      email: snapshot.data()['email'],
      department: snapshot.data()['department'],
    );
  }
  Stream<List<Model>> get pass{
    return userCollection.snapshots()
    .map(_modelListFromSnapshot);
  }

  Stream<UserData> get userData{
    return userCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }
}