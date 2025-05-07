import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/screens/payment_method_screen.dart';
import 'package:my_shop/widgets/container_button_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _selectAll = false;
  Map<String, bool> _selectedItems = {};

  double calculateTotal(List<Map<String, dynamic>> cartItems) {
    double total = 0.0;
    for (var item in cartItems) {
      if (_selectedItems[item['id']] ?? false) {
        String priceString = item['price'].replaceAll('Rs. ', '');
        double price = double.tryParse(priceString) ?? 0.0;
        int quantity = item['quantity'] ?? 1;
        total += price * quantity;
      }
    }
    return total;
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeFromCart(cartItemId);
      return;
    }

    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(cartItemId)
          .update({'quantity': newQuantity});
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(cartItemId)
          .delete();
      setState(() {
        _selectedItems.remove(cartItemId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text("Cart", style: Theme.of(context).textTheme.titleLarge),
          leading: const BackButton(),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            "Please log in to view your cart",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Cart", style: Theme.of(context).textTheme.titleLarge),
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}",
                    style: Theme.of(context).textTheme.bodyMedium));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text("Your cart is empty",
                    style: Theme.of(context).textTheme.bodyMedium));
          }

          final cartItems = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'productId': data['productId'],
              'title': data['title'],
              'price': data['price'],
              'image': data['image'],
              'quantity': data['quantity'],
            };
          }).toList();

          for (var item in cartItems) {
            _selectedItems.putIfAbsent(item['id'], () => false);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: cartItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              splashRadius: 20,
                              activeColor: Theme.of(context).colorScheme.error,
                              value: _selectedItems[item['id']] ?? false,
                              onChanged: (val) {
                                setState(() {
                                  _selectedItems[item['id']] = val ?? false;
                                  _selectAll = _selectedItems.values.every((selected) => selected);
                                });
                              },
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item['image'],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 80,
                                    width: 80,
                                    color: Theme.of(context).colorScheme.surface,
                                    child: Center(
                                        child: Text("Image Error",
                                            style: Theme.of(context).textTheme.bodySmall)),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18,
                                          ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Hooded Jackets", // Make dynamic if needed
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            fontSize: 14,
                                          ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      item['price'],
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.error,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    updateQuantity(item['id'], item['quantity'] - 1);
                                  },
                                  child: Icon(CupertinoIcons.minus,
                                      color: Theme.of(context).colorScheme.secondary),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  item['quantity'].toString(),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    updateQuantity(item['id'], item['quantity'] + 1);
                                  },
                                  child: Icon(CupertinoIcons.plus,
                                      color: Theme.of(context).colorScheme.error),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        splashRadius: 20,
                        activeColor: Theme.of(context).colorScheme.error,
                        value: _selectAll,
                        onChanged: (val) {
                          setState(() {
                            _selectAll = val ?? false;
                            _selectedItems = Map.fromIterables(
                              cartItems.map((item) => item['id']),
                              cartItems.map((_) => _selectAll),
                            );
                          });
                        },
                      ),
                      Text(
                        "Select All",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 30,
                    thickness: 1,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Payment",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        "Rs. ${calculateTotal(cartItems).toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      if (_selectedItems.values.any((selected) => selected)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentMethodScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Please select at least one item to checkout",
                                  style: Theme.of(context).textTheme.bodyMedium)),
                        );
                      }
                    },
                    child: ContainerButtonModel(
                      itext: "Checkout",
                      containerWidth: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}