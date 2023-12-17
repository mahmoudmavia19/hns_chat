import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auths;
import 'package:hns_chat/app/utils/constants/constant.dart';
import 'package:hns_chat/data/models/user.dart';

abstract class RemoteDataSource {
  Future<void> register(User user, String password);
  Future<User?> login(String email, String password);
  Future<void> forgetPassword(String email);
  Future<List<User>?> getUsers();
  Future<User?> getUserInfo();
  Future<bool> checkLogin();
  Future<bool> logout();
}

class ImplRemoteDataSource implements RemoteDataSource {
  auths.FirebaseAuth auth;
  FirebaseFirestore firestore;

  ImplRemoteDataSource({required this.auth, required this.firestore});

  @override
  Future<void> register(User user, String password) async {
    await auth
        .createUserWithEmailAndPassword(email: user.email!, password: password)
        .then((registerData) {
      user.id = registerData.user!.uid;
      firestore
          .collection(FireStoreEndPoints.users)
          .doc(registerData.user!.uid)
          .set(user.toJson())
          .then((value) {});
    });
  }

  @override
  Future<User?> login(String email, String password) async {
    User? user;
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await firestore
          .collection(FireStoreEndPoints.users)
          .doc(value.user!.uid)
          .get()
          .then((response) {
        user = User.fromJson(response.data()!);
        return user;
      }).catchError((error) {
        print(error.toString());
      });
    });
    return user;
  }

  @override
  Future<List<User>?> getUsers() async {
    return (await firestore.collection(FireStoreEndPoints.users).get())
        .docs.where((element) => element.id!=auth.currentUser?.uid)
        .map((e) => User.fromJson(e.data()))
        .toList();
  }

  @override
  Future<User?> getUserInfo() async{
    if(auth.currentUser!=null){
      return User.fromJson((await firestore.collection(FireStoreEndPoints.users).doc(auth.currentUser!.uid).get()).data()!);
    }
    return null;
  }

  @override
  Future<void> forgetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<bool> checkLogin() async{
   return auth.currentUser !=null ;
  }

  @override
  Future<bool> logout() async{
     auth.signOut();
     return checkLogin();
  }
}
