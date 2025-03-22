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
            ),
            ChangeNotifierProvider(
              create: (_) => FoodShoppingCartService(),
            ),
            ChangeNotifierProvider(create: (_) => FavoritesService()),
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
          title: Image.network(Utils.foodLogoDarkText, width: 180),
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
                        page = FavoritesPage();
                        break;
                      case '/shoppingcart':
                        page = FoodShoppingCartPage();
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
          Image.asset('assets/text.png', width: 230)
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
                icon: Icon(
                  Icons.trip_origin,
                  color: bottomBarSelectionService.tabSelection == 'main'
                      ? Utils.mainDark
                      : Utils.mainColor,
                ),
                onPressed: () {
                  bottomBarSelectionService.setTabSelection('main');
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: bottomBarSelectionService.tabSelection == 'favorites'
                      ? Utils.mainDark
                      : Utils.mainColor,
                ),
                onPressed: () {
                  bottomBarSelectionService.setTabSelection('favorites');
                },
              ),
              Consumer<FoodShoppingCartService>(
                builder: (context, cartService, child) {
                  int cartItems = cartService.cartFoods.length;

                  return GestureDetector(
                    onTap: () {
                      bottomBarSelectionService.setTabSelection('shoppingcart');
                    },
                    child: Container(
                      constraints: BoxConstraints(minHeight: 70),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cartItems > 0
                            ? (bottomBarSelectionService.tabSelection == 'shoppingcart'
                            ? Utils.mainDark
                            : Utils.mainColor)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          cartItems > 0
                              ? Text(
                            '$cartItems',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          )
                              : SizedBox(height: 17),
                          SizedBox(height: 10),
                          Icon(
                            Icons.shopping_cart,
                            color: cartItems > 0
                                ? Colors.white
                                : (bottomBarSelectionService.tabSelection == 'shoppingcart'
                                ? Utils.mainDark
                                : Utils.mainColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
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
              builder: (context, foodService, child) {
                return FoodList(foods: foodService.filteredFoods);
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
                    SizedBox(height: 10),
                    Text('${foodInfo!.name}',
                        style: TextStyle(
                            color: Utils.mainDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        )
                    ),
                    SizedBox(height: 5),
                    Container(
                        decoration: BoxDecoration(
                          color: Utils.mainColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 3, bottom: 3
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
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    FoodService foodService = Provider.of<FoodService>(context, listen: false);
    FavoritesService favoritesService = Provider.of<FavoritesService>(context, listen: false);
    FoodShoppingCartService cartService = Provider.of<FoodShoppingCartService>(context, listen: false);

    selectedFood = foodService.getSelecteFood();
    isFavorited = favoritesService.isFavorite(selectedFood!);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Utils.mainDark),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SizedBox(
          width: 120,
          child: Image.network(Utils.foodLogoDarkText, width: 180),
        ),
        actions: [
          FoodShoppingCartBadge(),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Hero(
              tag: selectedFood!.name!,
              child: Image.network(
                selectedFood!.imgUrl!,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${selectedFood!.name!}',
                          style: TextStyle(
                            color: Utils.mainDark,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_outline,
                          color: Utils.mainDark,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isFavorited) {
                              favoritesService.removeFromFavorites(selectedFood!);
                            } else {
                              favoritesService.addToFavorites(selectedFood!);
                            }
                            isFavorited = !isFavorited;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Utils.mainDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\Rp${selectedFood!.price!.toStringAsFixed(3)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${selectedFood!.weight!}',
                    style: TextStyle(
                      color: Utils.mainDark,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${selectedFood!.description!}',
                    style: TextStyle(
                      color: Utils.mainDark,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Consumer<FoodShoppingCartService>(
                    builder: (context, cartService, child) {
                      if (!cartService.isFoodInCart(selectedFood!)) {
                        return GestureDetector(
                          onTap: () {
                            cartService.addToCart(selectedFood!);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Utils.mainDark.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart, color: Utils.mainDark),
                                SizedBox(width: 20),
                                Text(
                                  'Add To Cart',
                                  style: TextStyle(color: Utils.mainDark),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_rounded, color: Utils.mainDark),
                            SizedBox(width: 20),
                            Text(
                              'Added to Cart',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Utils.mainDark,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodShoppingCartService extends ChangeNotifier {
  List<FoodModel> cartFoods = [];

  void addToCart(FoodModel food) {
    cartFoods.add(food);
    notifyListeners();
  }

  void removeFromCart(FoodModel food) {
    cartFoods.removeWhere((d) => d.name == food.name);
    notifyListeners();
  }

  void clearCart() {
    cartFoods.clear();
    notifyListeners();
  }

  double getTotal() {
    double cartTotal = 0.0;
    cartFoods.forEach((element) {
      cartTotal += element.price!;
    });
    return cartTotal;
  }

  bool isFoodInCart(FoodModel food) {
    return cartFoods.any((d) => d.name == food.name);
  }
}

class FoodShoppingCartBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Consumer<FoodShoppingCartService>(
        builder: (context, cartService, child) {

          if (cartService.cartFoods.isEmpty) {
            return SizedBox();
          }

          return Transform.scale(
              scale: 0.7,
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: Utils.mainColor,
                      borderRadius: BorderRadius.circular(40)
                  ),
                  child: Row(
                      children: [
                        Text('${cartService.cartFoods.length}', style: TextStyle(fontSize: 20,
                            color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.shopping_cart, size: 25, color: Colors.white)
                      ]
                  )
              )
          );
        }
    );
  }
}

class FoodShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FoodShoppingCartService cartService = Provider.of<FoodShoppingCartService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        actions: [
          if (cartService.cartFoods.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete, color: Utils.mainDark),
              onPressed: () {
                cartService.clearCart();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartService.cartFoods.length,
              itemBuilder: (context, index) {
                FoodModel food = cartService.cartFoods[index];
                return FoodShoppingListRow(
                  food: food,
                  onDeleteRow: () {
                    cartService.removeFromCart(food);
                  },
                );
              },
            ),
          ),
          if (cartService.cartFoods.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Divider(),
                  Text(
                    'Total: \Rp${cartService.getTotal().toStringAsFixed(3)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Utils.mainDark,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      cartService.clearCart();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Utils.mainColor,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class FoodShoppingListRow extends StatelessWidget {
  final FoodModel? food;
  final Function? onDeleteRow;

  FoodShoppingListRow({this.food, required this.onDeleteRow});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
      child: Row(
        children: [
          Image.network('${food!.imgUrl}', width: 80, height: 80),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${food!.name}',
                  style: TextStyle(
                    color: Utils.mainDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2, color: Utils.mainDark.withOpacity(0.2)),
                  ),
                  child: Text(
                    '\Rp${food!.price!.toStringAsFixed(3)}',
                    style: TextStyle(
                      color: Utils.mainDark.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              onDeleteRow!();
            },
            icon: Icon(Icons.delete_forever, color: Utils.mainColor),
          ),
        ],
      ),
    );
  }
}

class FoodShoppingList extends StatefulWidget {

  List<FoodModel>? foodCart;
  FoodShoppingCartService? cartService;
  FoodShoppingList({ this.foodCart, this.cartService });

  @override
  State<FoodShoppingList> createState() => _FoodShoppingListState();
}

class _FoodShoppingListState extends State<FoodShoppingList> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<FoodModel> insertedItems = [];

  @override
  void initState() {
    super.initState();

    var future = Future(() {});
    for (var i = 0; i < widget.foodCart!.length; i++) {
      future = future.then((_) {
        return Future.delayed(const Duration(milliseconds: 125), () {
          insertedItems.add(widget.foodCart![i]);
          _key.currentState!.insertItem(i);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _key,
      initialItemCount: insertedItems.length,
      itemBuilder: (context, index, animation) {
        FoodModel currentFood = widget.foodCart![index];

        return SlideTransition(
            position: Tween(
              begin: const Offset(0.0, 0.2),
              end: const Offset(0.0, 0.0),
            )
                .animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut
            )),
            child: FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0)
                    .animate(CurvedAnimation(parent: animation,
                    curve: Curves.easeInOut)),
                child: FoodShoppingListRow(
                    food: currentFood,
                    onDeleteRow: () {
                      widget.cartService!.removeFromCart(currentFood);
                    }
                )
            )
        );
      },
    );
  }
}

class FavoritesService extends ChangeNotifier {
  List<FoodModel> favoriteFoods = [];

  void addToFavorites(FoodModel food) {
    favoriteFoods.add(food);
    notifyListeners();
  }

  void removeFromFavorites(FoodModel food) {
    favoriteFoods.removeWhere((item) => item.id == food.id);
    notifyListeners();
  }

  bool isFavorite(FoodModel food) {
    return favoriteFoods.any((item) => item.id == food.id);
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FavoritesService favoritesService = Provider.of<FavoritesService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoritesService.favoriteFoods.length,
        itemBuilder: (context, index) {
          FoodModel food = favoritesService.favoriteFoods[index];
          return ListTile(
            leading: Image.network(food.imgUrl!, width: 50, height: 50),
            title: Text(food.name!),
            subtitle: Text('\Rp${food.price!.toStringAsFixed(3)}'),
          );
        },
      ),
    );
  }
}



class FoodFilterBarItem {
  String? id;
  String? label;

  FoodFilterBarItem({ this.id, this.label });
}

class FoodModel {
  String? imgUrl;
  String? name;
  String? description;
  double? price;
  String? type;
  double? qty;
  String? id;
  String? weight;

  FoodModel({
    this.imgUrl,
    this.name,
    this.description,
    this.price,
    this.type,
    this.qty,
    this.id,
    this.weight
  });
}

class Utils {
  static GlobalKey<NavigatorState> mainListNav = GlobalKey();
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();

  static const Color mainColor = Color(0xFFFFB30F);
  static const Color mainDark = Color(0xFF775208);
  static const String foodLogoWhiteText = 'assets/text-white.png';
  static const String foodLogoDarkText = 'assets/text-dark.png';
  static const String foodTitleFavorites = 'assets/myfav.png';
  static const String foodTitleMyFoods = 'assets/myfood.png';
  static const String foodPromo1 = 'assets/foodpromo2.jpg';
  static const String foodPromo2 = 'assets/foodpromo1.webp';
  static const String foodPromo3 = 'assets/foodpromo3.jpg';

  static List<FoodModel> foods = [
    FoodModel(
        imgUrl: 'assets/kacangcoklat.jpg',
        name: 'Martabak Manis Kacang Cokelat',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 25.000,
        type: 'manis',
        id: '01',
        qty: 15,
        weight: '500gram',
    ),
    FoodModel(
      imgUrl: 'assets/r-kejususu.jpg',
      name: 'Martabak Manis Keju Susu',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
      price: 30.000,
      type: 'manis',
      id: '02',
      qty: 10,
      weight: '500gram',
    ),
    FoodModel(
        imgUrl: 'assets/kejucokelat.jpg',
        name: 'Martabak Manis Cokelat Keju',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 38.000,
        type: 'manis',
        id: '03',
        qty: 20,
        weight: '500gram',
    ),
    FoodModel(
        imgUrl: 'assets/strawberry.jpg',
        name: 'Martabak Manis Strawberry Susu',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 37.000,
        type: 'manis',
        id: '04',
        qty: 15,
        weight: '500gram',
    ),
    FoodModel(
        imgUrl: 'assets/ayambiasa.jpg',
        name: 'Martabak Asin Ayam Biasa',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 30.000,
        type: 'asin',
        id: '05',
        qty: 25,
        weight: '600gram',
    ),
    FoodModel(
        imgUrl: 'assets/bebekbiasa.jpg',
        name: 'Martabak Asin Bebek Biasa',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 35.000,
        type: 'asin',
        id: '06',
        qty: 20,
        weight: '620gram',
    ),
    FoodModel(
        imgUrl: 'assets/ayamspesial.jpg',
        name: 'Martabak Asin Ayam Spesial',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 40.000,
        type: 'asin',
        id: '07',
        qty: 12,
        weight: '480gram',
    ),
    FoodModel(
        imgUrl: 'assets/bebekspesial.jpg',
        name: 'Martabak Asin Bebek Spesial',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 45.000,
        type: 'asin',
        id: '08',
        qty: 22,
        weight: '590gram',
    ),
    FoodModel(
        imgUrl: 'assets/kacangcoklat.jpg',
        name: 'Martabak Mini Kacang Cokelat',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 10.000,
        type: 'mini',
        id: '09',
        qty: 9,
        weight: '180gram',
    ),
    FoodModel(
        imgUrl: 'assets/m-kejususu.jpg',
        name: 'Martabak Mini Keju Susu',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 15.000,
        type: 'mini',
        id: '10',
        qty: 19,
        weight: '180gram',
    ),
    FoodModel(
        imgUrl: 'assets/strawberry.jpg',
        name: 'Martabak Mini Strawberry',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 15.000,
        type: 'mini',
        id: '11',
        qty: 2,
        weight: '180gram',
    ),
    FoodModel(
        imgUrl: 'assets/kejucokelat.jpg',
        name: 'Martabak Mini Cokelat Keju',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit, tellus condimentum cursus gravida, lorem augue venenatis elit, sit amet bibendum quam neque id sapien.',
        price: 15.000,
        type: 'mini',
        id: '12',
        qty: 5,
        weight: '180gram',
    )
  ];
}