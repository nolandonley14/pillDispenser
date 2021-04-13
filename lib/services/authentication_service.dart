import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:senior_design_pd/models/user.dart';
import 'package:senior_design_pd/services/firestore_service.dart';

class AuthenticationService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirestoreService _firestoreService = FirestoreService();

  CustomUser _currentUser;
  CustomUser get currentUser => _currentUser;

  String name;
  String email;
  String imageUrl;
  
  // sign in with google
  Future signInWithGoogle() async {

    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      // Store the retrieved data
      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;

      return user != null;

    } catch (e) {
      print(e.toString());
      return null;
    }

  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      await _populateCurrentUser(user);
      return user != null;
    } catch (e) {
      return e.message;
    }
  }

  //70FB204F-F8EC-4F0A-05CA-9DF546CC1D88

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password); 
      User user = result.user;
      
      _currentUser = CustomUser(
        uid: user.uid,
        email: email,
        name: name,
        deviceConnected: false,
      );
      await _firestoreService.createUser(_currentUser);
        

      return user != null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> isUserLoggedIn() async {
    await _populateCurrentUser(_auth.currentUser);
    return _auth.currentUser != null;
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
    }
  }


  // sign out of google
  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    signOut();
    print("User Signed Out");
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

  


