import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_testing_user/model/cart.dart';
import 'package:firebase_testing_user/model/category.dart';
import 'package:firebase_testing_user/model/product.dart';
import 'package:flutter/cupertino.dart';
import '../model/address.dart';
import '../model/order.dart';
import '../model/user.dart';

class FirebaseServicies {
  // create object for firebase
  static FirebaseServicies instance = FirebaseServicies.named();

  FirebaseServicies.named();

  factory FirebaseServicies() {
    return instance;
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  Stream<List<Category>> getCategory() {
    return firebaseDatabase.ref().child("category").onValue.map(
      (event) {
        List<Category> categoryList = [];

        if (event.snapshot.exists) {
          Map<dynamic, dynamic> categoryMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          categoryMap.forEach(
            (key, value) {
              Category category = Category.fromJson(value);
              categoryList.add(category);
            },
          );
        }

        return categoryList;
      },
    );
  }

  Stream<List<Product>> getAllProductParticularCategory(
      {required String categoryId}) {
    return firebaseDatabase
        .ref()
        .child("product")
        .orderByChild("categoryId")
        .equalTo(categoryId)
        .onValue
        .map(
      (event) {
        List<Product> productList = [];
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> productMap =
              event.snapshot.value as Map<dynamic, dynamic>;

          productMap.forEach(
            (key, value) {
              Product product = Product.fromJson(value);
              productList.add(product);
            },
          );
        }

        return productList;
      },
    );
  }

  Stream<List<Product>> topSellingProducts() {
    return firebaseDatabase
        .ref()
        .child("product")
        .orderByChild("inTop")
        .equalTo(true)
        .onValue
        .map((event) {
      List<Product> productList = [];

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> topSelling =
            event.snapshot.value as Map<dynamic, dynamic>;

        topSelling.forEach((key, value) {
          Product product = Product.fromJson(value);
          productList.add(product);
        });
      }

      return productList;
    });
  }

  // void toggleFavorite(String productId) {
  //   if (firebaseAuth.currentUser != null) {
  //     final ref = firebaseDatabase
  //         .ref('userFavorites')
  //         .child(firebaseAuth.currentUser!.uid)
  //         .child(productId);
  //
  //     ref.get().then((snapshot) async {
  //       final isFavoriteNow = !snapshot.exists;
  //       if (isFavoriteNow) {
  //         await ref.set(true);
  //       } else {
  //         await ref.remove();
  //       }
  //
  //       // Update the local ValueNotifier for this product's favorite status
  //       _favorites[productId]?.value = isFavoriteNow;
  //     });
  //   }
  // }

  void removeFavorite(String productId) {
    if (firebaseAuth.currentUser != null) {
      firebaseDatabase
          .ref('userFavorites')
          .child(firebaseAuth.currentUser!.uid)
          .child(productId)
          .remove();
    }
  }

  Future<bool> getFavorite(String productId) async {
    if (firebaseAuth.currentUser != null) {
      final snapshot = await firebaseDatabase
          .ref('userFavorites')
          .child(firebaseAuth.currentUser!.uid)
          .child(productId)
          .get();
      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  // ValueNotifier<bool> getFavoriteNotifier(String productId) {
  //   // If the notifier doesn't exist, create it with a default value of false
  //   _favorites.putIfAbsent(productId, () => ValueNotifier<bool>(false));
  //   return _favorites[productId]!;
  // }
  //
  // void updateFavorites(bool isFavorite, String productId) {
  //   _favorites[productId]?.value = isFavorite;
  // }

  Future<List<String>> fetchUserFavoriteItemIds(String userId) async {
    final snapshot =
        await firebaseDatabase.ref().child('userFavorites/$userId').get();
    if (snapshot.exists && snapshot.value != null) {
      Map<dynamic, dynamic> favorites =
          Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
      return favorites.keys.cast<String>().toList();
    } else {
      return [];
    }
  }

  Future<bool> createUserAndStoreInDatabase(UserData userData) async {
    try {
      await firebaseDatabase
          .ref()
          .child('users')
          .child(userData.id)
          .set(userData.toJson());

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<UserData?> getUserData() async {
    try {
      var user = FirebaseAuth.instance.currentUser!.uid;

      log("user : $user");

      DataSnapshot dataSnapshot =
          await firebaseDatabase.ref().child("users").child(user).get();

      log("DataSnapshot : ${dataSnapshot.value}");

      UserData userData = UserData.fromJson(dataSnapshot.value);

      log(userData.id);
      log(userData.name);
      log(userData.email);

      return userData;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> userExistOrNot(String userId) async {
    try {
      DataSnapshot snapshot =
          await firebaseDatabase.ref().child("user").child(userId).get();

      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> addProductIntoCart(
      {required Product product,
      required int quantity,
      required BuildContext context}) async {
    try {
      String userId = firebaseAuth.currentUser!.uid;

      DatabaseReference ref = firebaseDatabase
          .ref()
          .child("cart")
          .child(userId)
          .child("product")
          .child(product.id!);

      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        ref.update({
          "quantity": quantity,
          "totalPrice": (quantity * product.price).toDouble()
        });
      } else {
        Cart cart = Cart(
            id: product.id!,
            name: product.name,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl,
            quantity: quantity,
            createdAt: DateTime.now().microsecondsSinceEpoch,
            totalPrice: (product.price * quantity).toDouble());

        ref.set(cart.toJson());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<Cart>> productGetFromCart() {
    String userId = firebaseAuth.currentUser!.uid;

    return firebaseDatabase
        .ref()
        .child("cart")
        .child(userId)
        .child("product")
        .onValue
        .map((event) {
      List<Cart> cartList = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> cartMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        cartMap.forEach((key, value) {
          Cart cart = Cart.fromJson(value);

          cartList.add(cart);
        });
      }

      return cartList;
    });
  }

  void updateCartProduct({required String cartId, required Cart cart}) {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      firebaseDatabase
          .ref()
          .child("cart")
          .child(userId)
          .child("product")
          .child(cartId)
          .update(cart.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Cart>> getTotalPriceForCheckOut() async {
    String userId = firebaseAuth.currentUser!.uid;

    List<Cart> cartListForPrice = [];

    DatabaseReference reference =
        firebaseDatabase.ref().child("cart").child(userId).child("product");

    DataSnapshot snapshot = await reference.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> totalPriceMap =
          snapshot.value as Map<dynamic, dynamic>;

      print(totalPriceMap);

      totalPriceMap.forEach((key, value) {
        Cart cart = Cart.fromJson(value);
        cartListForPrice.add(cart);
      });
    }

    return cartListForPrice;
  }

  Future<void> saveAddressInDatabase(Address address) async {
    try {
      String userId = firebaseAuth.currentUser!.uid;

      DatabaseReference database = FirebaseDatabase.instance
          .ref()
          .child("UserAddress")
          .child(userId)
          .child("Address");

      String? addressId = database.push().key;

      address.id = addressId!;

      await database.child(addressId).set(address.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<Address>> getAllAddress() {
    String userId = firebaseAuth.currentUser!.uid;
    return firebaseDatabase
        .ref()
        .child("UserAddress")
        .child(userId)
        .child("Address")
        .onValue
        .map((event) {
      List<Address> addressList = [];

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> addressMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        addressMap.forEach((key, value) {
          Address address = Address.fromJson(value);
          addressList.add(address);
        });
      }

      return addressList;
    });
  }

  Future<void> placeOrder(Order order) async {
    String? id = firebaseDatabase.ref().child('Orders').push().key;
    order.orderId = id;
    if (id != null) {
      await firebaseDatabase
          .ref()
          .child('orders')
          .child(id)
          .set(order.toJson());

      await firebaseDatabase.ref().child('cart').child(order.userId!).remove();
    }
  }

  Stream<List<Order>> orderStream() {
    var userId = firebaseAuth.currentUser!.uid;

    return firebaseDatabase
        .ref()
        .child('orders')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue
        .map((event) {
      dynamic ordersMap = event.snapshot.value ?? {};
      List<Order> orders = [];
      ordersMap.forEach((key, value) {
        orders.add(
          Order.fromJson(
            Map<String, dynamic>.from(value),
          ),
        );
      });
      return orders;
    });
  }
}
