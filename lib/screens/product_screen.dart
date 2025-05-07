import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:my_shop/firebase/product.dart';
import 'package:my_shop/firebase/favourites_provider.dart';
import 'package:my_shop/theme/colors.dart';
import 'package:my_shop/widgets/product_details_popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductScreen extends StatelessWidget {
  final Product product;

  const ProductScreen({super.key, required this.product});

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
          .doc(product.id)
          .set({
        'productId': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.images.isNotEmpty ? product.images[0] : 'images/placeholder.png',
        'quantity': 1,
      }, SetOptions(merge: true)); // Merge to update quantity if item exists

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart!'),
          duration: Duration(seconds: 1),
          backgroundColor: AppColors.softTeal,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug: Log the product details with all fields
    print('ProductScreen loaded with product: $product');

    // Use all images from the product with fallback
    final imagesLink = product.images.isNotEmpty ? product.images : ['images/placeholder.png'];

    // Debug: Verify imagesLink content
    print('imagesLink: $imagesLink, length: ${imagesLink.length}');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title.isNotEmpty ? product.title : 'Product Details',
          style: TextStyle(color: Colors.black),
        ),
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favorites, child) {
              return IconButton(
                icon: Icon(
                  favorites.isFavorite(product)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favorites.isFavorite(product)
                      ? Colors.red
                      : AppColors.softTeal,
                ),
                onPressed: () {
                  favorites.toggleFavorite(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        favorites.isFavorite(product)
                            ? 'Added to favourites!'
                            : 'Removed from favourites!',
                      ),
                      duration: Duration(seconds: 1),
                      backgroundColor: AppColors.softTeal,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carousel with fixed height
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: imagesLink.isNotEmpty
                      ? FanCarouselImageSlider.sliderType1(
                          imagesLink: imagesLink,
                          isAssets: true,
                          autoPlay: true,
                          sliderHeight: 350,
                          showIndicator: imagesLink.length > 1,
                          indicatorActiveColor: AppColors.softPink,
                          imageFitMode: BoxFit.cover,
                         displayIndicatorOnSlider: true,
                        )
                      : Container(
                          height: 350,
                          color: Colors.grey[200],
                          child: Center(
                            child: Text(
                              'No Images Available',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title.isNotEmpty ? product.title : 'No Title',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.category.isNotEmpty ? product.category : 'General',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.price.isNotEmpty ? product.price : 'N/A',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: AppColors.softTeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: double.tryParse(product.reviews) ?? 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 25,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print('Updated rating: $rating');
                      },
                    ),
                    const SizedBox(width: 10),
                    Text(
                      product.reviews.isNotEmpty
                          ? '(${product.reviews} reviews)'
                          : '(0 reviews)',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  product.description.isNotEmpty
                      ? product.description
                      : 'No Description',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.shopping_cart_checkout_rounded),
                          label: Text("Add to cart"),
                          onPressed: () => addToCart(context), // Updated to add to Firestore
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.softTeal,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                         
                        ),
                      ),
                    ),
                    ProductDetailsPopUp(product: product,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}