import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashPage()
      )
  );
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FoodShopMain())
      );
    });

    return Scaffold(
      backgroundColor: Utils.mainColor,
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Image.asset('assets/logo.png', width: 350, height: 150),
          Image.asset('assets/text.png', width: 350, height: 100),
          SizedBox(
            height: 200
          ),
          CircularProgressIndicator()
      ],
    ),
    ),
    );
  }
}

class FoodShopMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Utils.mainDark),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('FoodASZtic',
        style:
          TextStyle(

          ))
      ),
      body: Center(
        child: Text('Hello, Welcome to martabak asz`s!'),
      ),
    );
  }
}

class Utils {
  static const Color mainColor = Color(0xFFFFB30F);
  static const Color mainDark = Color(0xFF775208);
  static const String donutLogoWhiteText = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_shop_text_reversed.png';
  static const String donutLogoRedText = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_shop_text.png';
  static const String donutTitleFavorites = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_favorites_title.png';
  static const String donutTitleMyDonuts = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_mydonuts_title.png';
  static const String donutPromo1 = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_promo1.png';
  static const String donutPromo2 = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_promo2.png';
  static const String donutPromo3 = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_promo3.png';
}