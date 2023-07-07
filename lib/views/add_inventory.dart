import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inventory_app/models/inventory.dart';
import 'package:inventory_app/providers/firestore_services.dart';

import '../notif.dart';

class AddInventory extends StatefulWidget {
  const AddInventory({Key? key, this.inventory, this.id}) : super(key: key);

  final Inventory? inventory;
  final String? id;

  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    Noti.initialize(flutterLocalNotificationsPlugin);

    if (widget.inventory != null) {
      nameController.text = widget.inventory!.name;
      descriptionController.text = widget.inventory!.description;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Inventory"),
        actions: [
          IconButton(
              onPressed: () async {
                if (widget.inventory != null) {
                  await FirestoreService.editInventory(
                      Inventory(
                          name: nameController.text,
                          description: descriptionController.text),
                      widget.id!);
                } else {
                  FirestoreService.addInventory(Inventory(
                      name: nameController.text,
                      description: descriptionController.text));

                }
                Noti.showBigTextNotification(title: "Barang Anda Telah di Tambahkan", body: "${nameController.text} telah ditambahkan", fln: flutterLocalNotificationsPlugin,);
                Navigator.pop(context);
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Masukan Nama Barang..."),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration:
                  InputDecoration(hintText: "Masukan Deskripsi Barang..."),
              controller: descriptionController,
            )
          ],
        ),
      ),
    );
  }
}
