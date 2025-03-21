import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => FoodBottomBarSelectionService(),
          ),
          ChangeNotifierProvider(
              create: (_) => FoodService(),
          )
        ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
        initialRoute: '/',
        navigatorKey: Utils.mainAppNav,
        routes: {
            '/': (context) => SplashPage(),
            '/main': (context) => FoodShopMain(),
            '/details': (context) => FoodShopDetails(),
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
                      page = FoodMainPage();
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

class FoodMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FoodPager(),
        FoodFilterBar(),
        Expanded(
            child: Consumer<FoodService>(
                builder: (context, FoodService, child) {
                  return FoodList(foods: FoodService.filteredFoods);
                },
            )
        )
      ],
    );
  }
}

class FoodPager extends StatefulWidget {
  @override
  State<FoodPager> createState() => _FoodPagerState();
}

class _FoodPagerState extends State<FoodPager> {

  List<FoodPage> pages = [
    FoodPage(imgUrl: Utils.foodPromo1, logoImgUrl: 'assets/text-white.png'),
    FoodPage(imgUrl: Utils.foodPromo2, logoImgUrl: 'assets/text-white.png'),
    FoodPage(imgUrl: Utils.foodPromo3, logoImgUrl: 'assets/text-white.png'),
  ];

  int currentPage = 0;
  PageController? controller;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              pageSnapping: true,
              controller: controller,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: List.generate(pages.length, (index) {
                FoodPage currentPage = pages[index];

                return Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0.0, 5.0),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(currentPage.imgUrl!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), // Efek gelap
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Image.network(currentPage.logoImgUrl!, width: 120),
                );
              }),
            ),
          ),
          PageViewIndicator(
            controller: controller,
            numberOfPages: pages.length,
            currentPage: currentPage,
          )
        ],
      ),
    );
  }
}

class FoodPage extends StatelessWidget {
  final String imgUrl;
  final String logoImgUrl;

  FoodPage({required this.imgUrl, required this.logoImgUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          child: Image.asset(imgUrl, fit: BoxFit.cover),
        ),
        Center(child: Image.asset(logoImgUrl)), // Teks/logo di atas
      ],
    );
  }
}

class PageViewIndicator extends StatelessWidget {
  PageController? controller;
  int? numberOfPages;
  int? currentPage;

  PageViewIndicator({ this.controller, this.numberOfPages, this.currentPage });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numberOfPages!, (index) {
        return GestureDetector(
          onTap: () {
            controller!.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 15,
            height: 15,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: currentPage == index ?
                Utils.mainColor : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)
            )
          )
        );
      })
    );
  }
}

class FoodFilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Consumer<FoodService>(
        builder: (context, foodService, child) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  foodService.filterBarItems.length, (index) {

                    FoodFilterBarItem item = foodService.filterBarItems[index];

                    return GestureDetector(
                      onTap: () {
                        foodService.filteredFoodByType(item.id!);
                      },
                      child: Container(
                          child: Text('${item.label!}',
                              style: TextStyle(
                                  color: foodService.selectedFoodType == item.id ?
                                  Utils.mainColor : Colors.black, fontWeight: FontWeight.bold)
                          )
                      )
                    );
                }
                )
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    alignment: alignmentBasedOnTap(foodService.selectedFoodType),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 20,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Utils.mainColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                  )
                ],
              )
            ]
          );
        }
      )
    );
  }
  
  Alignment alignmentBasedOnTap(filterBarId) {
    switch(filterBarId) {
      case 'manis':
        return Alignment.centerLeft;
      case 'asin':
        return Alignment.center;
      case 'mini':
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }
}

class FoodFilterBarItem {
  String? id;
  String? label;

  FoodFilterBarItem({ this.id, this.label });
}

class FoodService extends ChangeNotifier {
  List<FoodFilterBarItem> filterBarItems = [
    FoodFilterBarItem(id: 'manis', label: 'Manis'),
    FoodFilterBarItem(id: 'asin', label: 'Asin'),
    FoodFilterBarItem(id: 'mini', label: 'Mini'),
  ];

  String? selectedFoodType;
  List<FoodModel> filteredFoods = [];
  late FoodModel selectedFood;

  FoodModel getSelecteFood() {
    return selectedFood;
  }

  void onFoodSelected(FoodModel food) {
    selectedFood = food;
    Utils.mainAppNav.currentState!.pushNamed('/details');
  }

  FoodService() {
    selectedFoodType = filterBarItems.first.id;
    filteredFoodByType(selectedFoodType!);
  }

  void filteredFoodByType(String type) {
    selectedFoodType = type;
    filteredFoods = Utils.foods.where(
        (d) => d.type == selectedFoodType).toList();

    notifyListeners();
  }
}

class FoodList extends StatefulWidget {
  List<FoodModel>? foods;

  FoodList({ this.foods });

  @override
  State<FoodList> createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<FoodModel> insertedItems = [];

  @override
  void initState() {
    super.initState();

    var future = Future(() {});
    for (var i = 0; i < widget.foods!.length; i++) {
      future = future.then((_) {
        return Future.delayed(const Duration(milliseconds: 125), () {
          insertedItems.add(widget.foods![i]);
          _key.currentState!.insertItem(i);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _key,
        scrollDirection: Axis.horizontal,
        initialItemCount: insertedItems.length,
        itemBuilder: (context, index, animation) {

          FoodModel currentFood = widget.foods![index];

          return SlideTransition(
            position: Tween(
              begin: const Offset(0.2, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: FadeTransition(
              opacity: Tween(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: FoodCard(foodInfo: currentFood),
            ),
          );
        }
    );
  }
}

class FoodCard extends StatelessWidget {
  FoodModel? foodInfo;
  FoodCard({ this.foodInfo });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var foodService = Provider.of<FoodService>(context, listen: false);
        foodService.onFoodSelected(foodInfo!);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            padding: EdgeInsets.all(15),
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0.0, 4.0)
                  )
                ]
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.network(
                      foodInfo!.imgUrl!,
                      width: 150, height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text('${foodInfo!.name}',
                      style: TextStyle(
                          color: Utils.mainDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      )
                  ),
                  SizedBox(height: 20),
                  Container(
                      decoration: BoxDecoration(
                        color: Utils.mainColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5
                      ),
                      child: Text('\Rp${foodInfo!.price!.toStringAsFixed(3)}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          )
                      )
                  ),
                ]
            ),
          )
        ],
      )
    );
  }
}

class FoodShopDetails extends StatefulWidget {
  @override
  State<FoodShopDetails> createState() => _FoodShopDetailsState();
}

class _FoodShopDetailsState extends State<FoodShopDetails> {
  FoodModel? selectedFood;

  @override
  Widget build(BuildContext context) {
    selectedFood = Utils.foods[0];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Utils.mainDark),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: SizedBox(
              width: 200,
              child: Image.asset('assets/text.png')
          ),
        ),
        ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Stack(
              children: [
                Image.network(selectedFood!.imgUrl!,
                width: MediaQuery.of(context).size.width * 1.25,
                fit: BoxFit.contain
                )
              ],
            )
          ),
          Expanded(
            child:
            Padding(padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text('${selectedFood!.name!}',
                        style: TextStyle(color: Utils.mainDark,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)
                        )
                    ),
                    SizedBox(width: 50),
                    IconButton(
                      icon: Icon(Icons.favorite_outline),
                      color: Utils.mainDark,
                      onPressed: () {}
                    )
                  ]
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Utils.mainDark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('\Rp${selectedFood!.price!.toStringAsFixed(3)}',
                  style: TextStyle(color: Colors.white)
                  ),
                ),
                SizedBox(height: 20),
                Text('${selectedFood!.description!}'),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Utils.mainDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, color: Utils.mainDark),
                      SizedBox(width: 20),
                      Text('Add to Cart', style: TextStyle(color: Utils.mainDark)),
                    ],
                  ),
                )
              ],
            )
            )
          )
        ]
      )
    );
  }
}

class FoodModel {
  String? imgUrl;
  String? name;
  String? description;
  double? price;
  String? type;

  FoodModel({
    this.imgUrl,
    this.name,
    this.description,
    this.price,
    this.type
  });
}

class Utils {
  static List<FoodModel> foods = [
    FoodModel(
        imgUrl: 'assets/kacangcoklat.jpg',
        name: 'Martabak Manis Kacang Cokelat',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 25.000,
        type: 'manis'
    ),
    FoodModel(
      imgUrl: 'assets/r-kejususu.jpg',
      name: 'Martabak Manis Keju Susu',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
      price: 30.000,
      type: 'manis',
    ),
    FoodModel(
        imgUrl: 'assets/kejucokelat.jpg',
        name: 'Martabak Manis Cokelat Keju',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 38.000,
        type: 'manis'
    ),
    FoodModel(
        imgUrl: 'assets/strawberry.jpg',
        name: 'Martabak Manis Strawberry Susu',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 37.000,
        type: 'manis'
    ),
    FoodModel(
        imgUrl: 'assets/ayambiasa.jpg',
        name: 'Martabak Asin Ayam Biasa',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 30.000,
        type: 'asin'
    ),
    FoodModel(
        imgUrl: 'assets/bebekbiasa.jpg',
        name: 'Martabak Asin Bebek Biasa',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 35.000,
        type: 'asin'
    ),
    FoodModel(
        imgUrl: 'assets/ayamspesial.jpg',
        name: 'Martabak Asin Ayam Spesial',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 40.000,
        type: 'asin'
    ),
    FoodModel(
        imgUrl: 'assets/bebekspesial.jpg',
        name: 'Martabak Asin Bebek Spesial',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 45.000,
        type: 'asin'
    ),
    FoodModel(
        imgUrl: 'assets/kacangcoklat.jpg',
        name: 'Martabak Mini Kacang Cokelat',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 10.000,
        type: 'mini'
    ),
    FoodModel(
        imgUrl: 'assets/m-kejususu.jpg',
        name: 'Martabak Mini Keju Susu',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 15.000,
        type: 'mini'
    ),
    FoodModel(
        imgUrl: 'assets/strawberry.jpg',
        name: 'Martabak Mini Strawberry',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 15.000,
        type: 'mini'
    ),
    FoodModel(
        imgUrl: 'assets/kejucokelat.jpg',
        name: 'Martabak Mini Cokelat Keju',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 15.000,
        type: 'mini'
    )
  ];

  static GlobalKey<NavigatorState> mainListNav = GlobalKey();
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();

  static const Color mainColor = Color(0xFFFFB30F);
  static const Color mainDark = Color(0xFF775208);
  static const String donutLogoWhiteText = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_shop_text_reversed.png';
  static const String donutLogoRedText = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_shop_text.png';
  static const String donutTitleFavorites = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_favorites_title.png';
  static const String donutTitleMyDonuts = 'https://romanejaquez.github.io/flutter-codelab4/assets/donut_mydonuts_title.png';
  static const String foodPromo1 = 'assets/foodpromo2.jpg';
  static const String foodPromo2 = 'assets/foodpromo1.webp';
  static const String foodPromo3 = 'assets/foodpromo3.jpg';
}