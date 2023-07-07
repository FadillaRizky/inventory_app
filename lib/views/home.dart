import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory_app/providers/firestore_services.dart';
import 'package:inventory_app/views/add_inventory.dart';
import 'package:inventory_app/views/login.dart';

import '../models/inventory.dart';
import '../notif.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.photoUrl, this.userName}) : super(key: key);
  final String? photoUrl;
  final String? userName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  GoogleSignIn _googleSignIn = GoogleSignIn();

  void signOut() async {
    try {
      await _googleSignIn.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      // Perform any other logout-related operations here
      // For example, clear user data or navigate to the login screen
    } catch (error) {
      // Handle any errors that occur during the sign-out process
      print('Error signing out: $error');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Halo ${widget.userName}"),
          actions: [
            SizedBox(
              height: 70,
              width: 70,
              child: PopupMenuButton(
                icon: CircleAvatar(
                    radius: 50, // Specify the radius of the avatar
                    backgroundImage: NetworkImage(
                      "${widget.photoUrl}",
                    )),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'btnLogout',
                    child: Text('Log Out'),
                  ),
                ],
                onSelected: (item) {
                  switch (item) {
                    case "btnLogout":
                      signOut();
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddInventory()));
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              FirebaseFirestore.instance.collection("inventory").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var Inventories = snapshot.data!.docs
                  .map((inventory) => Inventory.fromSnapshot(inventory))
                  .toList();
              return ListView.builder(
                  itemCount: Inventories.length,
                  itemBuilder: (context, index) {
                    var id = snapshot.data!.docs[index].id;
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddInventory(
                                      inventory: Inventories[index],
                                      id: id,
                                    )));
                      },
                      title: Text(Inventories[index].name),
                      subtitle: Text(Inventories[index].description),
                      trailing: IconButton(
                          onPressed: () {
                            FirestoreService.deleteInventory(id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

// Column(
// children: [
// ListTile(
// onTap: (){
// },
// title: Text(
// "Nama Barang"
// ),
// subtitle: Text(
// "deskripsi"
// ),
// )
// ],
// )
