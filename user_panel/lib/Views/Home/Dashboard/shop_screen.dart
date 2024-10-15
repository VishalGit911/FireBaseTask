import 'package:flutter/material.dart';
import 'package:user_panel/FireBase/firebase_services.dart';
import 'package:user_panel/Model/product_model.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 5),
                  child: Text("Top Category",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                allCatogoryWithProduct()
              ],
            ),
          ),
        ),
      ),
    ));
  }

  topProductItem() {
    return StreamBuilder(
        stream: FirebaseServices().getallproduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            List<ProductModel> data = snapshot.data!;

            return GridView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           ProductDetailScreen(product: data[index]),
                      //     ));
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.2),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70),
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image(
                              image: NetworkImage(data[index].imageUrl),
                              height: 50,
                              width: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Name : ${data[index].name}"),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Price : ${data[index].price}")
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        });
  }

    allCatogoryWithProduct() {
      return Container(
        height: 200,
        child: StreamBuilder(
          stream: FirebaseServices().getAllCategory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: Image.network(snapshot.data![index].imageUrl),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Container(),
              );
            }
          },
        ),
      );
    }
}
