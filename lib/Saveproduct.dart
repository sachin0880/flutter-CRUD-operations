import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product.dart';


class AddProductPage extends StatefulWidget {
  static const routeName = '/addProduct';

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _price = 0.0;
  File? _imageFile;
  bool _isSaving = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error picking image",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        Fluttertoast.showToast(
          msg: "Please select an image",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      _formKey.currentState!.save();
      setState(() {
        _isSaving = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? productsString = prefs.getString('products');
      List<Product> products = [];
      if (productsString != null) {
        products = Product.decode(productsString);
      }

      bool isDuplicate =
      products.any((product) => product.name.toLowerCase() == _name.toLowerCase());
      if (isDuplicate) {
        setState(() {
          _isSaving = false;
        });
        Fluttertoast.showToast(
          msg: "Product with this name already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }


      Product newProduct = Product(
        name: _name,
        price: _price,
        imagePath: _imageFile!.path,
      );
      products.add(newProduct);
      String encoded = Product.encode(products);
      await prefs.setString('products', encoded);
      setState(() {
        _isSaving = false;
      });
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( backgroundColor: Colors.orange ,
          title: Text('Add Product',style: TextStyle(color: Colors.white ),),
        ),
        body: _isSaving
            ? Center(child: CircularProgressIndicator())
            : Padding( padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                 //-----------------------------------------------
                    TextFormField( decoration: InputDecoration(labelText: 'Product Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!.trim();
                      },
                    ),
                    SizedBox(height: 16),
                  //---------------------------------------------
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType:
                      TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Price must be greater than zero';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _price = double.parse(value!.trim());
                      },
                    ),
                    SizedBox(height: 16),
                   // ------------------------------------------------
                    Row(
                      children: [
                        _imageFile != null
                            ? Image.file(_imageFile!,
                          width: 100, height: 100, fit: BoxFit.cover,)
                            : Container(width: 100, height: 100, color: Colors.grey[300],
                          child: Icon(Icons.image, size: 50, color: Colors.orange,),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton.icon( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange),  ) ,
                          onPressed: _pickImage, icon: Icon(Icons.photo ,color: Colors.white,),
                          label: Text('Select Image', style: TextStyle(fontSize: 18 ,color: Colors.white),),)
                      ],
                    ),
                    SizedBox(height: 32),
                    //--------------------------------------------------
                    ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange),  ) ,
                      onPressed: _saveProduct,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                        child: Text('Add Product', style: TextStyle(fontSize: 18 ,color: Colors.white),),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
