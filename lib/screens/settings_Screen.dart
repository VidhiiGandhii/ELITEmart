import 'package:flutter/material.dart';
import 'package:my_shop/theme/theme_manager.dart';
import 'package:provider/provider.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListTile(
             title: Text(
                "Dark Mode",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Switch(
                value: themeManager.isDark,
                onChanged: (value) {
                  themeManager.toggleTheme(value);
                },
                activeColor: Theme.of(context).colorScheme.primary,
                activeTrackColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}