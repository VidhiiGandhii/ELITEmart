import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop/firebase/product.dart';

class FirestoreService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  // Add a new product to Firestore
  Future<void> addProduct(Product product) async {
    try {
      await _productsCollection.add({
        'title': product.title,
        'images': product.images,
        'price': product.price,
        'reviews': product.reviews,
        'description': product.description,
        'category': product.category,
      });
      print('Product added successfully: ${product.title}');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Stream of all products
  Stream<List<Product>> getProducts() {
    return _productsCollection.snapshots().map((snapshot) {
      for (var doc in snapshot.docs) {
        print('Firestore document data for ID ${doc.id}: ${doc.data()}');
      }
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}