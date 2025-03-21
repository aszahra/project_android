import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => FoodBottomBarSelectionService(),
          )
        ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
        initialRoute: '/',
        navigatorKey: Utils.mainAppNav,
        routes: {
            '/': (context) => SplashPage(),
            '/main': (context) => FoodShopMain()
        },
      )
    )
  );
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Utils.mainAppNav.currentState!.pushReplacementNamed('/main');
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
      drawer: Drawer(
        child: FoodSideMenu()
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Utils.mainDark),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset('assets/text.png', width: 350, height: 100),
      ),
      body: Column(
        children: [
          Expanded(
              child: Navigator(
                key: Utils.mainListNav,
                initialRoute: '/main',
                onGenerateRoute: (RouteSettings settings) {
                  Widget page;

                  switch(settings.name) {
                    case '/main':
                      page = Center(child: Text('main'));
                      break;
                    case '/favorites':
                      page = Center(child: Text('favorites'));
                      break;
                    case '/shoppingcart':
                      page = Center(child: Text('shoppingcart'));
                      break;
                    default:
                      page = Center(child: Text('main'));
                      break;
                  }

                  return PageRouteBuilder(pageBuilder: (_, __, ___) => page,
                  transitionDuration: const Duration(seconds: 0)
                  );
                },
              )
          ),
          FoodBottomBar()
        ],
      )
    );
  }
}

class FoodSideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Utils.mainColor,
      padding: EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Image.asset('assets/logo.png', width: 300,),
          ),
          Image.asset('assets/text.png', width: 150)
        ],
      ),
    );
  }
}

class FoodBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Consumer<FoodBottomBarSelectionService>(
        builder: (context, bottomBarSelectionService, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.trip_origin,
                      color: bottomBarSelectionService.tabSelection == 'main' ? Utils.mainDark : Utils.mainColor),
                  onPressed: () {
                    bottomBarSelectionService.setTabSelection('main');
              }
              ),
              IconButton(
                  icon: Icon(Icons.favorite,
                      color: bottomBarSelectionService.tabSelection == 'favorites' ? Utils.mainDark : Utils.mainColor),
                  onPressed: () {
                bottomBarSelectionService.setTabSelection('favorites');
              }
              ),
              IconButton(
                  icon: Icon(Icons.shopping_cart,
                      color: bottomBarSelectionService.tabSelection == 'shoppingcart' ? Utils.mainDark : Utils.mainColor),
                  onPressed: () {
                bottomBarSelectionService.setTabSelection('shoppingcart');
              }
              ),
            ],
          );
        }
      )
    );
  }
}

class FoodBottomBarSelectionService extends ChangeNotifier {

  String? tabSelection = 'main';

  void setTabSelection(String selection) {
    Utils.mainListNav.currentState!.pushReplacementNamed('/' + selection);
    tabSelection = selection;
    notifyListeners();
  }
}

class Utils {
  static GlobalKey<NavigatorState> mainListNav = GlobalKey();
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();

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