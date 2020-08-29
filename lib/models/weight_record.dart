import 'package:cloud_firestore/cloud_firestore.dart';

class WeightRecord {
  final String weight;
  final String date;

  WeightRecord({this.weight, this.date});

  factory WeightRecord.fromQuerySnapshot(DocumentSnapshot document) {
    return WeightRecord(
      weight: document.data['weight'],
      date: document.documentID,
    );
  }
}
