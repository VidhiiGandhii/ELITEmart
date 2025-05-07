import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/screens/order_success_screen.dart';
import 'package:my_shop/screens/payment_method_screen.dart';
import 'package:my_shop/screens/shipping_address.dart';
import 'package:my_shop/theme/colors.dart';

class OrderConfirmScreen extends StatefulWidget {
  const OrderConfirmScreen({super.key});

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> _fetchShippingAddress() async {
    final user = _auth.currentUser;
    if (user == null) {
      return {
        'fullName': 'Dear Customer',
        'street': '3 NewBridge Court',
        'cityStateZip': 'Chino Hills, CA, 97545, United States'
      };
    }
    // Assuming address is stored in a subcollection 'addresses' under user document
    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .doc('primary')
        .get();
    if (doc.exists) {
      return {
        'fullName': doc.data()?['fullName'] ?? 'Dear Customer',
        'street': doc.data()?['street'] ?? '3 NewBridge Court',
        'cityStateZip':
            doc.data()?['cityStateZip'] ?? 'Chino Hills, CA, 97545, United States'
      };
    }
    // Fallback to default address if not found
    return {
      'fullName': 'Dear Customer',
      'street': '3 NewBridge Court',
      'cityStateZip': 'Chino Hills, CA, 97545, United States'
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Confirm Order",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<Map<String, String>>(
              future: _fetchShippingAddress(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error: ${snapshot.error}",
                          style: Theme.of(context).textTheme.bodyMedium));
                }

                final address = snapshot.data ??
                    {
                      'fullName': 'Dear Customer',
                      'street': '3 NewBridge Court',
                      'cityStateZip': 'Chino Hills, CA, 97545, United States'
                    };

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Shipping Address",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withOpacity(0.12),
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                address['fullName']!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ShippingAddress(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Change",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 18,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            address['street']!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                ),
                          ),
                          Text(
                            address['cityStateZip']!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment Method",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaymentMethodScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Change",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor.withOpacity(0.12),
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Image.asset("images/mastercard.png"),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "**** **** **** 3947",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Delivery Method",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor.withOpacity(0.12),
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                "images/icon3.png",
                                height: 25,
                              ),
                              Text(
                                "2-7 Days",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          height: 60,
                          width: 130,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor.withOpacity(0.12),
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Home Delivery",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              Text(
                                "2-7 Days",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shipping Fee',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        Text(
                          'Rs. 130',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 30,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Payment',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Rs. 1130',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrderSuccessScreen()),
                        );
                      },
                      child: Text(
                        'Confirm Order',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}