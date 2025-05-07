import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_shop/screens/shipping_address.dart';
import 'package:my_shop/theme/colors.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _selectedType = 1;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 1,
      'name': 'PhonePe',
      'icon': 'images/phonepe.svg',
      'isSvg': true,
    },
    {
      'id': 2,
      'name': 'Google Pay',
      'icon': 'images/icon2.png',
      'isSvg': false,
    },
    {
      'id': 3,
      'name': 'Credit Card',
      'icons': ['images/visa.png', 'images/mastercard.png'],
      'isMultipleIcons': true,
    },
    {
      'id': 4,
      'name': 'PayPal',
      'icon': 'images/pp.png',
      'isSvg': false,
    },
    {
      'id': 5,
      'name': 'Cash On Delivery',
      'isIcons': true, // Flutter icons
    },
  ];

  void _handleRadio(int id) {
    setState(() {
      _selectedType = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Method",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        foregroundColor: Color.fromARGB(255, 86, 74, 117),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Payment Options
                Column(
                  children: paymentMethods.map((method) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        border: _selectedType == method['id']
                            ? Border.all(width: 1.5, color: AppColors.softTeal)
                            : Border.all(width: 0.5, color: AppColors.lavenderPurple),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _handleRadio(method['id']),
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: method['id'],
                                    groupValue: _selectedType,
                                    onChanged: (value) => _handleRadio(value as int),
                                    activeColor: AppColors.softTeal,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    method['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedType == method['id']
                                          ? AppColors.lavenderPurple
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              if (method['isSvg'] == true)
                                SvgPicture.asset(method['icon'], width: 30, height: 30)
                              else if (method['isMultipleIcons'] == true)
                                Row(
                                  children: (method['icons'] as List<String>).map((iconPath) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Image.asset(iconPath, width: 30, height: 30),
                                    );
                                  }).toList(),
                                )
                              else if (method['isIcons'] == true)
                                Row(
                                  children: const [
                                    Icon(Icons.currency_rupee_outlined),
                                    SizedBox(width: 4),
                                    Icon(Icons.money),
                                  ],
                                )
                              else
                                Image.asset(method['icon'], width: 50, height: 50),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),

                // Payment Summary
                _buildSummaryRow('Sub-Total', 'Rs. 1000'),
                const SizedBox(height: 10),
                _buildSummaryRow('Shipping Fee', 'Rs. 130'),
                const Divider(height: 30, color: Colors.black12),
                _buildSummaryRow('Total Payment', 'Rs. 1130', isTotal: true),
                const SizedBox(height: 30),

                // Confirm Payment Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lavenderPurple,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShippingAddress()),
                    );
                  },
                  child: const Text('Confirm Payment', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Color.fromARGB(255, 86, 74, 117) : Colors.black,
          ),
        ),
      ],
    );
  }
}
