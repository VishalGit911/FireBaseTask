import 'package:firebase_testing_user/firebase/firebase_servicies.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';
import '../widgets/custom_button.dart';

class ProductDetailScreen extends StatefulWidget {
  Product product;

  ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isLoading = false;

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            Center(
                child: Container(
              height: 225,
              width: 225,
              decoration: BoxDecoration(
                  color: Colors.purple,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.product.imageUrl))),
            )),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(child: Text("Product Name : ${widget.product.name}")),
                const SizedBox(
                  height: 30,
                ),

                // ), ValueListenableBuilder<bool>(
                //   valueListenable: FirebaseServicies().getFavoriteNotifier(widget.item.id!),
                //   builder: (context, isFavorite, _) {
                //     return InkWell(
                //       onTap: () => FirebaseServicies().toggleFavorite(widget.item.id!),
                //       child: Icon(
                //         isFavorite ? Icons.favorite : Icons.favorite_border,
                //         color: Colors.red,
                //       ),
                //     );
                //   },
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text("Product Description : ${widget.product.description}"),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Product. Price : ${widget.product.price}",
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity--;
                      }
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(quantity.toString()),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {});
                    quantity++;
                  },
                  child: const Icon(Icons.add),
                ),
                const Spacer(),
                Text(
                  "T Price: ${quantity * widget.product.price}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: CustomButton(
                  title: "Add to Cart",
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white70,
                  callback: () {
                    FirebaseServicies().addProductIntoCart(
                        product: widget.product,
                        quantity: quantity,
                        context: context);

                    Navigator.pop(context);
                  },
                  isLoading: isLoading),
            )
          ],
        ),
      ),
    );
  }
}
