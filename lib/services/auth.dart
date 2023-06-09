import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  Future<void> createUserWithPhoneNumber({
    required String phoneNumber,
    required void Function(String, int?) callbackCodeSent
  })async{
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential){
          print("------------Verification Completed-------------");
          print(phoneAuthCredential);
          print('------------------------------------------------');
        },
        verificationFailed: (e){
          // TODO: add a toast to show the error message
        },
        codeSent: callbackCodeSent,
        codeAutoRetrievalTimeout: (e){
          // TODO: implement timeout exception
        }
    );
  }

  Future<void> verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
    }) async{
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode
    );

    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> resetPassword({
    required String email
}) async{
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signInWithGoogle() async{
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );

    UserCredential user = await _firebaseAuth.signInWithCredential(credential);
  }
}