import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weight_tracker/models/weight_record.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userRef = Firestore.instance.collection('users');

  Future addWeightRecord(String weight, String date) async {
    return await userRef
        .document(uid)
        .collection('records')
        .document(date)
        .setData({'weight': weight});
  }

  List<WeightRecord> _weightRecordListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((document) => WeightRecord.fromQuerySnapshot(document))
        .toList();
  }

  Stream<List<WeightRecord>> get weightRecords {
    return userRef
        .document(uid)
        .collection('records')
        .snapshots()
        .map((_weightRecordListFromSnapshot));
  }
}
