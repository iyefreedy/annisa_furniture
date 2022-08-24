import 'package:annisa_furniture/services/cloud/cloud_storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String? name;
  final String? category;
  final dynamic price;
  final List<dynamic>? image;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  Product.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        name = snapshot.data()[productNameField],
        category = snapshot.data()[productCategoryField],
        price = snapshot.data()[productPriceField],
        image = snapshot.data()[productImageField],
        description = snapshot.data()[descriptionField],
        createdAt = snapshot.data()[createdAtField],
        updatedAt = snapshot.data()[updatedAtField];

  Product.fromDocument(DocumentSnapshot<Map<String, dynamic>> document)
      : this(
          id: document.id,
          name: document.data()![productNameField],
          category: document.data()![productCategoryField],
          price: document.data()![productPriceField],
          image: document.data()![productImageField],
          description: document.data()![descriptionField],
          createdAt: document.data()![createdAtField],
          updatedAt: document.data()![updatedAtField],
        );

  // CloudProduct.fromDocumentSnapshot(
  //     QuerySnapshot<Map<String, dynamic>> snapshot)
  //     : id = snapshot,
  //       name = snapshot.data()?['name'],
  //       category = snapshot.data()?['category'],
  //       price = snapshot.data()?['price'],
  //       image = snapshot.data()?['image'],
  //       createdAt = snapshot.data()?['created_at'],
  //       updatedAt = snapshot.data()?['updated_at'];
}
