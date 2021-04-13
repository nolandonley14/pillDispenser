import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomUser {

  final String uid;
  final String name;
  final String email;
  bool deviceConnected;
  UserDevice device;
  List<UserMedication> medications;

  CustomUser({ this.uid, this.name, this.email, this.deviceConnected, this.device, this.medications });

  CustomUser.fromData(Map<String, dynamic> data, Map<String, dynamic> deviceData, List<UserMedication> med)
    : uid = data['id'],
      name = data['name'],
      email = data['email'],
      deviceConnected = data['deviceConnected'],
      device = deviceData != null ? UserDevice.fromData(deviceData) : UserDevice(),
      medications = med;

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'name': name,
      'email': email,
      'deviceConnected': deviceConnected,
      'deviceID': device.id == null ? "" : device.id,
    };
  }

}

class UserMedication {
  String frequency;
  String name;

  UserMedication( {this.name, this.frequency} ); 

  UserMedication.fromData(Map<String, dynamic> data)
    : frequency = data["frequency"],
    name = data["name"];

  factory UserMedication.fromDS(String id, Map<String, dynamic> data) {
    if (data == null) return null;

    return UserMedication(
      frequency: data["frequency"],
      name: data["name"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'frequency': frequency,
      'name': name,
    };
  }
}

class MedicationDosage {
  bool isCompleted;
  Timestamp time;

  MedicationDosage( {this.isCompleted, this.time} );

  MedicationDosage.fromData(Map<String, dynamic> data)
    : isCompleted = data["completed"],
    time = data["time"];
}

class UserDevice {
  String name;
  String id;
  String service;

  UserDevice( {this.name, this.id, this.service} );

  UserDevice.fromData(Map<String, dynamic> data)
    : name = data['name'],
    id = data['id'],
    service = data['serviceUuid'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'serviceUuid': "fa14accf-9e11-41ee-a85b-d0c13e94f3cf",
    };
  }
}
