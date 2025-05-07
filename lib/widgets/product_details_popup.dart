import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/theme/colors.dart';
import 'package:my_shop/widgets/container_button_model.dart';
import 'package:my_shop/firebase/product.dart'; // Assuming you have a Product model

class ProductDetailsPopUp extends StatefulWidget {
  final Product product;

  const ProductDetailsPopUp({super.key, required this.product});

  @override
  State<ProductDetailsPopUp> createState() => _ProductDetailsPopUpState();
}

class _ProductDetailsPopUpState extends State<ProductDetailsPopUp> {
  final TextStyle iStyle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  int _quantity = 1;
  int _selectedSizeIndex = -1; // -1 means no size selected
  int _selectedColorIndex = -1; // -1 means no color selected

  // List of available sizes (dynamic or static based on product)
  final List<String> sizes = ['S', 'M', 'L', 'XL'];

  // Dynamic colors based on product (for now, using the provided list)
  final List<Color> clrs = [Colors.red, Colors.green, Colors.indigo, Colors.amber];

  // Calculate total payment
  double calculateTotal() {
    String priceString = widget.product.price.replaceAll('Rs. ', '');
    double price = double.tryParse(priceString) ?? 0.0;
    return price * _quantity;
  }

  // Add to cart in Firestore
  Future<void> addToCart(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add items to cart!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(widget.product.id)
          .set({
        'productId': widget.product.id,
        'title': widget.product.title,
        'price': widget.product.price,
        'image': widget.product.images.isNotEmpty ? widget.product.images[0] : 'images/placeholder.png',
        'quantity': _quantity,
        'size': _selectedSizeIndex != -1 ? sizes[_selectedSizeIndex] : null,
        'color': _selectedColorIndex != -1 ? clrs[_selectedColorIndex].value.toRadixString(16) : null,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart!'),
          duration: Duration(seconds: 1),
          backgroundColor: AppColors.softTeal,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height / 1.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Size: ", style: iStyle),
                      SizedBox(width: 20),
                      Text("Color: ", style: iStyle),
                      SizedBox(width: 20),
                      Text("Total: ", style: iStyle),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Sizes Row
                  Row(
                    children: [
                      for (int i = 0; i < sizes.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSizeIndex = i;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedSizeIndex == i
                                    ? AppColors.lavenderPurple
                                    : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              sizes[i],
                              style: iStyle.copyWith(
                                color: _selectedSizeIndex == i
                                    ? AppColors.lavenderPurple
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Colors Row
                  Row(
                    children: [
                      for (int i = 0; i < clrs.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColorIndex = i;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: clrs[i],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _selectedColorIndex == i
                                    ? AppColors.lavenderPurple
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Quantity control Row
                  Row(
                    children: [
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (_quantity > 1) _quantity--;
                          });
                        },
                        child: Text("-", style: iStyle),
                      ),
                      SizedBox(width: 30),
                      Text(_quantity.toString(), style: iStyle),
                      SizedBox(width: 30),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                        child: Text("+", style: iStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Total Payment Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Payment", style: iStyle),
                      Text(
                        "Rs. ${calculateTotal().toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lavenderPurple,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Checkout Button
                  InkWell(
                    onTap: () => addToCart(context),
                    child: ContainerButtonModel(
                      containerWidth: MediaQuery.of(context).size.width,
                      itext: "Checkout",
                      bgColor: AppColors.lavenderPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: ContainerButtonModel(
        containerWidth: MediaQuery.of(context).size.width / 2,
        itext: "Buy Now",
        bgColor: AppColors.lavenderPurple,
      ),
    );
  }
}