import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory {
  String name;
  String description;

  Inventory({
    required this.name,
    required this.description
  });

  Map<String, dynamic > toJson (){
    return {
      "name" : name,
      "description" : description
    };
  }
  factory Inventory.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> json){
    return Inventory(name: json["name"], description: json["description"]);
  }

}
