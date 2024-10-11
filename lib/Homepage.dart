
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tast/product.dart';
import 'package:tast/productdata.dart';
import 'Saveproduct.dart';
import 'auth1.dart';
import 'loginpage.dart';



class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productsString = prefs.getString('products');
    if (productsString != null) {
      _products = Product.decode(productsString);
    }
    setState(() {
      _filteredProducts = _products;
      _isLoading = false;
    });
  }

  Future<void> _saveProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encoded = Product.encode(_products);
    await prefs.setString('products', encoded);
  }


  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products
          .where((product) =>
          product.name.toLowerCase().contains(query))
          .toList();
    });
  }


  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
      _filteredProducts = _products;
    });
    _saveProducts();
    Fluttertoast.showToast(
      msg: "Product deleted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }


  Future<void> _navigateToAddProduct() async {
    bool? isAdded = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductPage()),
    );
    if (isAdded != null && isAdded) {
      _loadProducts();
      Fluttertoast.showToast(
        msg: "Product added successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }


  Future<void> _handleLogout() async {
    await AuthService.logout();
    Navigator.pushReplacementNamed(context, '/login');
    Fluttertoast.showToast(
      msg: "Logged out successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.orange ,
          title: Text('Task App' ,style: TextStyle(color: Colors.white ),),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _handleLogout,
              tooltip: 'Logout',
              color: Colors.white,
            )
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            //-----------------------------------
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Products', prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)),),
                ),
              ),
            ),
            //--------------------------------
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(child: Text('No Product Found'))
                  : ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  int actualIndex = _products.indexOf(product);
                  return ProductItem(
                    product: product,
                    onDelete: () {
                      _deleteProduct(actualIndex);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        //--------------------------------
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddProduct,
          child: Icon(Icons.add),
          tooltip: 'Add Product',
        ));
  }
}
