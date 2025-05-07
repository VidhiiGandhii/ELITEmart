import 'package:flutter/material.dart';
import 'package:my_shop/screens/navigation_screen.dart';
import 'package:my_shop/theme/colors.dart';
import 'package:my_shop/widgets/container_button_model.dart';

class OrderSuccessScreen extends StatelessWidget {
    const OrderSuccessScreen({super.key});
@override
Widget build(BuildContext context) {
    return Material(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Column(
                    children: [
                        Image.asset(
                            "images/success.png",
                            height: 250,
                            ), // Image.asset
                            SizedBox(height: 15),
                    Text(
                            "Success!",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                            ), // TextStyle
                        ), // Text
                        SizedBox(height: 20),
                    Text(
                            "Your order will be delivered soon",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                            ), // TextStyle
                        ), // Text
                    Text(
                            "Thank You! for choosing our app.",
                                style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                            ), // TextStyle
                        ), // Text
                    ],
                ), // Column
                SizedBox(height:40),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                        onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavigationScreen(),
                                )); // MaterialPageRoute
                        },
                    
                    child: ContainerButtonModel(
                        itext: "Continue Shopping",
                        containerWidth: MediaQuery.of(context).size.width,
                        bgColor: AppColors.lavenderPurple,
                    ), // ContainerBuutonModel
                    )
                ), // Padding
            ],
        ), // Column
    ); // Material
}
}