import 'dart:io';
import 'package:flutter/material.dart';
import 'product.dart';


class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  ProductItem({required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: product.imagePath.isNotEmpty
              ? Image.file(
            File(product.imagePath),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          )
              : Container(
            width: 50,
            height: 50,
            color: Colors.grey[300],
            child: Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
          title: Text(product.name),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Confirm deletion
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Product'),
                    content: Text(
                        'Are you sure you want to delete "${product.name}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ));
            },
          ),
        ));
  }
}
