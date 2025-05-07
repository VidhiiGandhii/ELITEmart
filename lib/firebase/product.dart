class Product {
  final String id;
  final String title;
  final List<String> images; // Changed to a list of image paths
  final String price;
  final String reviews;
  final String description;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.images,
    required this.price,
    required this.reviews,
    this.description = '',
    this.category = '',
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String docId) {
    print('Parsing Firestore document: $data'); // Debug
    return Product(
      id: docId,
      title: data['title'] as String? ?? '',
      images: (data['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['images/placeholder.png'],
      price: data['price'] as String? ?? '',
      reviews: data['reviews'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'images': images,
      'price': price,
      'reviews': reviews,
      'description': description,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, images: $images, price: $price, reviews: $reviews, description: $description, category: $category)';
  }
}