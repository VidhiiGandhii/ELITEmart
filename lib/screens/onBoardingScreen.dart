import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:my_shop/screens/loginScreen.dart';

class Onboardingscreen extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  Onboardingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ) ?? const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      bodyTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 19,
          ) ?? const TextStyle(fontSize: 19),
      imagePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      pageColor: Theme.of(context).scaffoldBackgroundColor,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pages: [
        PageViewModel(
          title: "Shop Now",
          body:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
          image: Image.asset("images/splash1.png", width: 200),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Free Delivery",
          body:
              "It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          image: Image.asset("images/splash2.png", width: 200),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Big Discount",
          body:
              "It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          image: Image.asset("images/splash3.png", width: 200),
          decoration: pageDecoration,
          footer: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Let's Shop",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                    ),
              ),
            ),
          ),
        ),
      ],
      showSkipButton: false,
      showDoneButton: false,
      showBackButton: true,
      back: Text(
        "Back",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
      next: Text(
        "Next",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10),
        activeSize: const Size(20, 20),
        activeColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        spacing: const EdgeInsets.symmetric(horizontal: 3),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}