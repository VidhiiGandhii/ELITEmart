import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_shop/firebase/favourites_provider.dart';
import 'package:my_shop/screens/product_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Favourites',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            final favorites = favoritesProvider.favorites;
            return favorites.isEmpty
                ? Center(
                    child: Text(
                      'No favourites yet!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  )
                : ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final product = favorites[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Theme.of(context).colorScheme.surface,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(product: product),
                              ),
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product.images.first,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Theme.of(context).colorScheme.surface,
                                  child: Center(
                                      child: Text("Image Error",
                                          style: Theme.of(context).textTheme.bodySmall)),
                                );
                              },
                            ),
                          ),
                          title: Text(
                            product.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                            product.price,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.favorite, color: Theme.of(context).colorScheme.error),
                            onPressed: () {
                              favoritesProvider.toggleFavorite(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Removed from favourites!',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}