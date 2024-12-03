import 'dart:convert';
import 'package:addmission_app/services/models/getEntityDetails.dart';
import 'package:addmission_app/services/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Map<String, dynamic>? querySnapshot;
  // List<>

  Future addStudentDetails(Map<String, dynamic> studentInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection(Variables.collectionName)
        .doc(id)
        .set(studentInfoMap);
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getStudentDetails() async {
  // Future<void> getStudentDetails()async{
    var collection = FirebaseFirestore.instance.collection(Variables.collectionName);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection.get();
    List<DocumentSnapshot> queryList = querySnapshot.docs;
    var data = queryList[0].data();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      // List data1 = jsonDecode(data);
      // List<EntityDetailsModel> entityList = data.map((key, value) => EntityDetailsModel.fromJson(key, value)).toList();
      // can fill variables when needed like String name = data["Name"};
    }
    var querySnapshotStream = FirebaseFirestore.instance.collection(Variables.collectionName);
    return querySnapshotStream.snapshots();
  }

  Future updateStudentDetail(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance.collection(Variables.collectionName).doc(id).update(updateInfo);
  }

  Future deleteStudentDetail(String id) async {
    return await FirebaseFirestore.instance.collection(Variables.collectionName).doc(id).delete();
  }

  // New method to add call logs
  Future<void> addCallLogs(String contactId, List<Map<String, dynamic>> callLogs) async {
    await FirebaseFirestore.instance.collection("CallLogs").doc(contactId).set({
      'callHistory': callLogs,
    });
  }
}
