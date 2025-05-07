import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_shop/firebase/firestore_service.dart';
import 'package:my_shop/firebase/product.dart';
import 'package:my_shop/screens/loginScreen.dart';
import 'package:my_shop/screens/navigation_screen.dart';
import 'package:my_shop/screens/splash_screen.dart';
import 'package:my_shop/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:my_shop/firebase/favourites_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options for web
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBgmtU0UAQik4CC7OGB_KxY6XmLMpB-1GE",
      authDomain: "my-shop-v1.firebaseapp.com",
      projectId: "my-shop-v1",
      storageBucket: "my-shop-v1.firebasestorage.app",
      messagingSenderId: "1070882229371",
      appId: "1:1070882229371:web:543a4fe2b8c83c4f76e6de",
    ),
  );

  final firestoreService = FirestoreService();
  final productsCollection = FirebaseFirestore.instance.collection('products');
  final snapshot = await productsCollection.limit(1).get();
  if (snapshot.docs.isEmpty) {
    final initialProducts = [
      Product(
        id: '1',
        title: 'The Jacket',
        images: ['images/denimJacket.jpg', 'images/jacketBack.jpg'],
        price: 'Rs. 2000',
        reviews: '4.5',
        description: 'The coolest denim jacket around that you found! Get yours now!',
        category: 'Jacket',
      ),
      Product(
        id: '2',
        title: 'Stylish Hoodie',
        images: ['images/image1.jpg', 'images/scarf.jpeg'],
        price: 'Rs. 1500',
        reviews: '4.2',
        description: 'A trendy hoodie for all seasons!',
        category: 'Hoodie',
      ),
      Product(
        id: '3',
        title: 'HighNeck Warmer',
        images: ['images/image2.jpg', 'images/highneck.jpeg'],
        price: 'Rs. 2500',
        reviews: '4.2',
        description: 'Keeps you warm in the coldest of weather!',
        category: 'Warmer',
      ),
      Product(
        id: '4',
        title: 'Skirt',
        images: ['images/skirt.jpeg', 'images/skirt1.jpeg'],
        price: 'Rs. 1500',
        reviews: '4.9',
        description: 'Keeps you cool and add the flow in life!',
        category: 'Bottoms',
      ),
      Product(
        id: '5',
        title: 'StreetPulse Tee',
        images: ['images/tshirt.jpg', 'images/tshirt1.jpeg'],
        price: 'Rs. 1900',
        reviews: '4.0',
        description: 'Turn up the vibe with ultra-soft cotton, bold graphics, and a laid-back fit that moves with you. Perfect for when you are keeping it casual but still making a statement.',
        category: 'Topwear',
      ),
      Product(
        id: '6',
        title: 'Black Opium',
        images: ['images/perfume.jpg', 'images/perfume2.jpg', 'images/perfume3.jpg'],
        price: 'Rs. 7000',
        reviews: '4.9',
        description: 'Wear it',
        category: 'Fragrance',
      ),
      Product(
        id: '7',
        title: 'Dino Set',
        images: ['images/kidsSet.avif', 'images/kidsSet1.avif'],
        price: 'Rs. 2500',
        reviews: '4.2',
        description: 'Doodled dinos for kids',
        category: 'Kids',
      ),
      Product(
        id: '8',
        title: 'Itni sundar ghadi',
        images: ['images/watch.jpeg', 'images/watch1.jpeg', 'images/watch2.jpeg'],
        price: 'Rs. 7000',
        reviews: '4.2',
        description: 'Time to move on with the time!',
        category: 'Accessories',
      ),
    ];

    for (var product in initialProducts) {
      await firestoreService.addProduct(product);
      print('Seeded product: ${product.title}');
    }
  } else {
    print('Products already exist in Firestore, skipping seeding.');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeManager.themeMode,
            home: SplashScreen(),
          );
        },
      ),
    ),
  );
}

class AppColors {
  static const softPink = Color(0xFFF7CFD8);
  static const paleLemon = Color(0xFFF4F8D3);
  static const softTeal = Color(0xFFA6D6D6);
  static const lavenderPurple = Color(0xFF8E7DBE);
}