
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../firebase/firebase_servicies.dart';
import '../model/address.dart';
import '../model/order.dart';
import '../model/orderdata.dart';
import '../model/user.dart';
import 'address_manage.dart';
import 'dashboard/home.dart';

class AddressListScreen extends StatefulWidget {
  OrderData orderData;
  AddressListScreen({super.key, required this.orderData});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late Razorpay _razorpay;
  late UserData userData;
  late BuildContext _context;

  @override
  void initState() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  void openCheckOut(OrderData data) async {
    FirebaseServicies().getUserData().then((user) {
      if (user != null) {
        userData = user;
        var options = {
          'key':
              'rzp_test_WPdwgyMkdAgItn', // Replace with your Razorpay API key
          'amount': data.totalAmount! *
              100, // Razorpay takes the amount in the smallest currency unit (e.g., paise for INR)
          'name': 'Grocery Store',

          'contact': user.contact,
          'prefill': {'email': user.email ?? 'test@gmail.com'},
          'external': {
            'wallets': ['paytm']
          }
        };

        try {
          _razorpay.open(options);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Select Address"),
      ),
      body: StreamBuilder<List<Address>>(
        stream: FirebaseServicies().getAllAddress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Address address = snapshot.data![index];
                return Card(
                  elevation: 3,
                  color: Colors.amber.shade50,
                  child: ListTile(
                    onTap: () {
                      widget.orderData.address = address;
                      openCheckOut(widget.orderData);
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    title: Text(address.address),
                    subtitle: Text(
                        "${address.addressLine1}, ${address.addressLine2}, ${address.city}, ${address.state}, ${address.pinCode}"),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddressManageScreen(),
              ));
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        tooltip: 'Add Address',
        child: const Icon(Icons.add),
      ),
    );
  }

// id payment success
  _handlePaymentSuccess(PaymentSuccessResponse response) {
    final String paymentId = response.paymentId!;
    _storeOrderDetails(paymentId, widget.orderData);
  }

  // if get error in payment time
  _handlePaymentError(PaymentFailureResponse response) {
    // final String code = response.code.toString();
    final String message = response.message!;
    ScaffoldMessenger.of(_context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  _handleExternalWallet() {}

  void _storeOrderDetails(String paymentId, OrderData data) {
    Order order = Order(
      items: data.cartItems,
      orderDate: DateTime.now().millisecondsSinceEpoch,
      paymentId: paymentId,
      shippingAddress: data.address,
      status: 'pending',
      totalPrice: data.totalAmount,
      userId: userData.id,
    );

    FirebaseServicies().placeOrder(order).then((value) {
      // ScaffoldMessenger.of(_context).showSnackBar(
      //     const SnackBar(content: Text('Order placed successfully')));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    });
  }
}
