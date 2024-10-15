import 'package:flutter/material.dart';

import '../firebase/firebase_servicies.dart';
import '../model/order.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // stream: FirebaseServicies().ordersScreen(),
        stream: FirebaseServicies().orderStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Order order = snapshot.data![index];
                  return Card(
                    color: Colors.amber.shade50,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      title: Text(
                        'Order ID: ${order.orderId}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          'User ID : ${order.userId}\nPayment ID : ${order.paymentId}\nTotal Price : ${order.totalPrice}\nStatus: ${order.status}\nShpping Address : ${order.shippingAddress!.address}, ${order.shippingAddress!.addressLine1}, ${order.shippingAddress!.addressLine2}, ${order.shippingAddress!.city}, ${order.shippingAddress!.pinCode}, ${order.shippingAddress!.state}',),
                      trailing: IconButton(
                          onPressed: () async {
                            // setState(() {});
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
