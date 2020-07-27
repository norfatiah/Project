import 'package:fa_cosmetic/product.dart';
import 'package:flutter/material.dart';
import 'cart.dart';
import 'menu.dart';


class MainScreen extends StatefulWidget {
 final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List<Product> _menu = List<Product>();

  List<Product> _cartList = List<Product>();

  @override
  void initState() {
    super.initState();
    _listMenu();
  }


  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  bool _isadmin = false;
  String titlecenter = "Loading products...";
  String server = "https://slumberjer.com/grocery";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Menu',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 36.0,
                  ),
                  if (_cartList.length > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Text(
                          _cartList.length.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () {
                if (_cartList.isNotEmpty)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Cart(_cartList),
                    ),
                  );
              },
            ),
          )
        ],
      ),
      body: _buildGridView(),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      itemCount: _menu.length,
      itemBuilder: (context, index) {
        var item = _menu[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 2.0,
          ),
          child: Card(
            elevation: 4.0,
            child: ListTile(
              leading: Icon(
                item.icon,
                color: item.color,
              ),
              title: Text(item.name),
              trailing: GestureDetector(
                child: (!_cartList.contains(item))
                    ? Icon(
                        Icons.add_circle,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                onTap: () {
                  setState(() {
                    if (!_cartList.contains(item))
                      _cartList.add(item);
                    else
                      _cartList.remove(item);
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }

  GridView _buildGridView() {
    return GridView.builder(
        padding: const EdgeInsets.all(4.0),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _menu.length,
        itemBuilder: (context, index) {
          var item = _menu[index];
          return Card(
              elevation: 4.0,
              child: Stack(
                fit: StackFit.loose,
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        color: (_cartList.contains(item))
                            ? Colors.grey
                            : item.color,
                        size: 100.0,
                      ),
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subhead,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        child: (!_cartList.contains(item))
                            ? Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                        onTap: () {
                          setState(() {
                            if (!_cartList.contains(item))
                              _cartList.add(item);
                            else
                              _cartList.remove(item);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  void _listMenu() {
    var list = <Menu>[
      Menu(
        name: 'Drink',
        price: 4.00,
        icon: Icons.local_drink,
        color: Colors.blue,
      ),
      Menu(
        name: 'Burger Set',
        price: 10.00,
        icon: Icons.fastfood,
        color: Colors.deepOrange,
      ),
      Menu(
        name: 'Nasi Lemak',
        price: 12.00,
        icon: Icons.whatshot,
        color: Colors.red,
      ),
      Menu(
        name: 'Curry Chicken',
        price: 15.00,
        icon: Icons.lightbulb_outline,
        color: Colors.green,
      ),
      Menu(
        name: 'Salad',
        price: 8.00,
        icon: Icons.star,
        color: Colors.purple,
      ),
      Menu(
        name: 'Birthday Cake',
        price: 50.00,
        icon: Icons.cake,
        color: Colors.pink,
      ),
      Menu(
        name: 'Soft drink',
        price: 6.00,
        icon: Icons.local_drink,
        color: Colors.lightGreenAccent,
      ),
      Menu(
        name: 'Wastern Food',
        price: 20.00,
        icon: Icons.favorite,
        color: Colors.deepPurple,
      ),
    ];

    setState(() {
      _menu = list;
    });
  }
}


