import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:senior_design_pd/models/user.dart';

final medsDBS = DatabaseService<UserMedication>("Medications", fromDS: (id, data) => UserMedication.fromDS(id, data), toMap: (event) => event.toMap(), );

class FirestoreService {

  final CollectionReference _usersCollectionRef = FirebaseFirestore.instance.collection('Users');
  final CollectionReference _devicesCollectionRef = FirebaseFirestore.instance.collection('ArduinoDevices');
  final CollectionReference _medicationCollectionRef = FirebaseFirestore.instance.collection('Medications');

  Future createUser(CustomUser user) async {
    try {
      await _usersCollectionRef.doc(user.uid).set(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future saveDevice(UserDevice d, CustomUser user) async {
    try {
      await _devicesCollectionRef.doc(d.id).set(d.toJson());
      await _usersCollectionRef.doc(user.uid).update({'deviceID': d.id, "deviceConnected": true});
    } catch(e) {
      return e.toString();
    }
  }

  Future<List<MedicationDosage>> getMedicationDosages(DocumentReference userRef, String id) async {
    try {
      List<MedicationDosage> medDosages = [];
      var dos = await userRef.collection("medications").doc(id).collection("dosages").get().then((dosSnapShot) => {
        dosSnapShot.docs.forEach((ddoc) { 
          print(ddoc.data());
          MedicationDosage md = new MedicationDosage(isCompleted: ddoc.data()["completed"],  time: ddoc.data()["time"]);
          medDosages.add(md);
        })
      });
      return medDosages;
    } catch(e) {
      return null;
    }

  }

  Future<List<UserMedication>> getUserMedications(String userID) async {
    try {
      List<UserMedication> meds = [];
      var medList = await _medicationCollectionRef.doc(userID).get();
      medList.data()["meds"].foreach((med) {
        UserMedication um = new UserMedication(name: med["name"], frequency: med["frequency"]);
        meds.add(um);
      });
      return meds;
    } catch (e) {
      return null;
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionRef.doc(uid).get();
      var userMeds = await getUserMedications(userData.data()["id"]);
      var  dID = userData.data()['deviceID'];
      Map<String, dynamic> tmp = {};
      var devicesData = await _devicesCollectionRef.doc(userData.data()['deviceID']).get();
      return CustomUser.fromData(userData.data(), dID != "" ? devicesData.data() : tmp, userMeds);
    } catch (e) {
      return e.toString();
    }
  }


}