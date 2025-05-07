import 'package:flutter/material.dart';
import 'package:my_shop/screens/order_confirm_screen.dart';
import 'package:my_shop/theme/colors.dart';

class ShippingAddress extends StatelessWidget {
  const ShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Add Shipping Address",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color.fromARGB(255, 86, 74, 117),
      ),
      body: SingleChildScrollView(
        child: SafeArea(child: Padding(padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 40),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Full Name",
              ),
            ),
            SizedBox(height: 10),
             TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mobile Number",
              ),
            ),
            SizedBox(height: 10),
             TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Address",
              ),
            ),
            SizedBox(height: 10),
             TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "City",
              ),
            ),
            SizedBox(height: 10),
             TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "State/Province/Region",
              ),
            ),
            SizedBox(height: 10),
             TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Zip Code(Postal Code)",
              ),
            ),
            SizedBox(height: 10),
             TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Country",
              ),
            ),
            SizedBox(height:20),
             InkWell(
                    onTap: () {
                    
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lavenderPurple,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderConfirmScreen(),
                        ),
                      );
                      },
                      child: Text('Add Address'),
                    ),
                  ),
          ],
        ),
        
        )),
      ),
    );
  }
}