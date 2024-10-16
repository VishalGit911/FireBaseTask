import 'package:firebase_testing_user/views/product_detail_screen.dart';
import 'package:flutter/material.dart';
import '../firebase/firebase_servicies.dart';
import '../model/product.dart';

class ProductListScreen extends StatefulWidget {
  // Category category;
  String categoryId;

  ProductListScreen({super.key, required this.categoryId});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: StreamBuilder(
            stream: FirebaseServicies().getAllProductParticularCategory(
                // categoryId: widget.category.id!),
                categoryId: widget.categoryId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                List<Product> productList = snapshot.data!;

                return GridView.builder(
                  itemCount: productList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                  product: productList[index]),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 1, color: Colors.black12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                image:
                                    NetworkImage(productList[index].imageUrl),
                                height: 100,
                                width: 100),
                            Text(productList[index].name),
                            Text(productList[index].price.toString())
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("No Product Found for this particular category"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:grocery_app_user/model/item.dart';
import 'package:grocery_app_user/widget/custom_button.dart';
import '../../firebase/firebase_service.dart';

class ItemDetailView extends StatefulWidget {
  final Item item;

  ItemDetailView({required this.item});

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  ValueNotifier<int> _quantity = ValueNotifier<int>(1); // Start with quantity 1

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  void _addToCart() {
    // Assuming FirebaseService is initialized with a userId somewhere in your app
    FirebaseService firebaseService = FirebaseService();

    firebaseService.addToCart(widget.item, quantity.value).then(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart')),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Hero(
                    tag: 'imageHero${widget.item.id}',
                    child: Image.network(widget.item.imageUrl)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.item.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: FirebaseService().getFavoriteNotifier(widget.item.id!),
                  builder: (context, isFavorite, _) {
                    return InkWell(
                      onTap: () => FirebaseService().toggleFavorite(widget.item.id!),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '${widget.item.price} /${widget.item.unit}',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FloatingActionButton(
                        heroTag: 'decreaseButton${widget.item.id}',
                        onPressed: () {
                          if (_quantity.value > 1) {
                            _quantity.value--;
                          }
                        },
                        child: Icon(Icons.remove),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        mini: true,
                      ),
                      SizedBox(width: 16),
                      ValueListenableBuilder<int>(
                        valueListenable: _quantity,
                        builder: (context, value, child) => Text(
                          '$value',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 16),
                      FloatingActionButton(
                        heroTag: 'increaseButton${widget.item.id}',
                        onPressed: () {
                          _quantity.value++;
                        },
                        child: Icon(Icons.add),
                        mini: true,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: _quantity,
                  builder: (context, value, child) => Text(
                    'Rs. ${(widget.item.price * value).toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.item.description,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        margin: EdgeInsets.all(16),
        child: CustomButton(
          backgroundColor: Colors.green.shade400,
          title: 'Add to Cart',
          foregroundColor: Colors.white,
          callback: _addToCart,
        ),
      ),
    );
  }
}
 */