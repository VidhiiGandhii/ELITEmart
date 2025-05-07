import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_shop/screens/settings_Screen.dart';
import 'package:provider/provider.dart';
import 'package:my_shop/firebase/product.dart';
import 'package:my_shop/firebase/favourites_provider.dart';
import 'package:my_shop/screens/product_screen.dart';
import 'package:my_shop/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> tabs = ["All", "Jacket", "Topwear", "Bottoms", "Kids", "Fragrance", "Accessories"];
  String selectedTab = "All";
     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "ELITEmart",
          style: TextStyle(
            letterSpacing: 2,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          Icon(CupertinoIcons.hare,size: 30,)
        ],
       
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: selectedTab == "All"
            ? FirebaseFirestore.instance.collection('products').snapshots()
            : FirebaseFirestore.instance
                .collection('products')
                .where('category', isEqualTo: selectedTab)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final products = snapshot.data!.docs.map((doc) {
            return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search and Notification Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black12.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search, color: AppColors.softTeal),
                                border: InputBorder.none,
                                hintText: "Find what you're looking for?",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.softTeal,
                                blurRadius: 1,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(Icons.notifications, color: AppColors.lavenderPurple),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Promo Banner
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.softPink,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.softTeal,
                            blurRadius: 1,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: SvgPicture.asset("images/main.svg"),
                    ),
                    const SizedBox(height: 20),

                    // Category Tabs
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tabs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => setState(() => selectedTab = tabs[index]),
                            child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: selectedTab == tabs[index]
                                    ? AppColors.softTeal.withOpacity(0.2)
                                    : Colors.black12.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  tabs[index],
                                  style: selectedTab == tabs[index]
                                      ? Theme.of(context).textTheme.labelMedium
                                      : Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Featured Products Horizontal List
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Consumer<FavoritesProvider>(
                            builder: (context, favorites, child) {
                              return Container(
                                width: 320,
                                margin: const EdgeInsets.only(right: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Image with Favorite Button
                                    SizedBox(
                                      height: 180,
                                      width: 150,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProductScreen(product: product),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: product.images.isNotEmpty
                                                  ? Image.network(
                                                      product.images.first,
                                                      fit: BoxFit.cover,
                                                      height: 150,
                                                      width: 150,
                                                      errorBuilder: (_, __, ___) => const Icon(Icons.error),
                                                    )
                                                  : const Placeholder(),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () => favorites.toggleFavorite(product),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Icon(
                                                  favorites.isFavorite(product)
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: favorites.isFavorite(product)
                                                      ? Colors.red
                                                      : AppColors.softTeal,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // Product Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            product.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 20),
                                              Text('(${product.reviews})'),
                                              const Spacer(),
                                              Text(
                                                product.price,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.softTeal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // New Arrivals Section
                    const Text(
                      "New Arrivals",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    // Grid View of Products
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Consumer<FavoritesProvider>(
                          builder: (context, favorites, child) {
                            return InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductScreen(product: product),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image with Favorite Button
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: product.images.isNotEmpty
                                            ? Image.network(
                                                product.images.first,
                                                height: 180,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => const Placeholder(),
                                              )
                                            : const Placeholder(),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () => favorites.toggleFavorite(product),
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Icon(
                                              favorites.isFavorite(product)
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: favorites.isFavorite(product)
                                                  ? Colors.red
                                                  : AppColors.softTeal,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Product Details
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 18),
                                      Text('(${product.reviews})'),
                                      const Spacer(),
                                      Text(
                                        product.price,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.softTeal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}