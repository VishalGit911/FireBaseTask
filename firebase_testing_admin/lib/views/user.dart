import 'package:flutter/material.dart';
import '../firebase/firebase_servicies.dart';
import '../model/user.dart';


class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "User Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          actions: const [
           // IconButton(
            //   onPressed: () async {
            //     try {
            //       await FirebaseAuth.instance.signOut();
            //       if (!context.mounted) return;
            //       Navigator.pushAndRemoveUntil(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => LoginScreen(),
            //           ),
            //               (route) => false);
            //     } catch (e) {
            //       log(e.toString());
            //     }
            //   },
            //   icon: Icon(Icons.logout, color: Colors.white),
            // )
          ],
          backgroundColor: Colors.green,
        ),
        body: StreamBuilder(
          stream: FirebaseServicies().userData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.hasError.toString()),
              );
            } else if (snapshot.hasData) {
              // build your widget ui
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  UserData userData = snapshot.data![index];

                  // List = [(),()];

                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 8),
                    child: Card(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      elevation: 10,
                      shadowColor: Colors.green,
                      // margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userData.name),
                            Text(userData.email),
                            Text(userData.contact)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("User Not Found"),
              );
            }
          },
        ));
  }
}
