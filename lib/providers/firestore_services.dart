import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:inventory_app/models/inventory.dart';

class FirestoreService {
  static Future<void> addInventory(Inventory inventory) async {
    await FirebaseFirestore.instance
        .collection("inventory")
        .add(inventory.toJson());
  }
  static Future<void> deleteInventory(String id)async{
    await FirebaseFirestore.instance.collection("inventory").doc(id).delete();
  }

  static Future<void> editInventory(Inventory inventory,String id)async{
    await FirebaseFirestore.instance.collection("inventory").doc(id).update(inventory.toJson());
  }


}
