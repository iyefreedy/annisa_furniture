import 'package:annisa_furniture/models/message.dart';
import 'package:annisa_furniture/models/order.dart';
import 'package:annisa_furniture/models/product.dart';
import 'package:annisa_furniture/models/room.dart';
import 'package:annisa_furniture/services/cloud/cloud_storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseCloudStorage {
  // Singleton
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  // Initialize collection
  final user = FirebaseFirestore.instance.collection('users');
  final productRef = FirebaseFirestore.instance.collection('products');
  final order = FirebaseFirestore.instance.collection('orders');
  final cart = FirebaseFirestore.instance.collection('carts');
  final rooms = FirebaseFirestore.instance.collection('rooms');
  final images = FirebaseStorage.instance.ref();

  Future<String> getUserRole({required String userId}) async {
    final document = await user.doc(userId).get();

    return document.data()!['role'];
  }

  Future<Product> createProduct({
    required String name,
    required String category,
    required double price,
    required List<String> image,
    required String description,
  }) async {
    final document = await productRef.add({
      productNameField: name,
      productCategoryField: category,
      productPriceField: price,
      productImageField: image,
      descriptionField: description,
      createdAtField: DateTime.now().toString(),
      updatedAtField: DateTime.now().toString(),
    });

    debugPrint('Product created');

    final fetchedProduct = await document.get();

    return Product(
      id: fetchedProduct.id,
      name: fetchedProduct.data()?[productNameField],
      category: fetchedProduct.data()?[productCategoryField],
      price: fetchedProduct.data()?[productPriceField],
      image: fetchedProduct.data()?[productImageField],
      description: fetchedProduct.data()?[descriptionField],
      createdAt: fetchedProduct.data()?[createdAtField],
      updatedAt: fetchedProduct.data()?[updatedAtField],
    );
  }

  Future<void> deleteProduct({required String productId}) async {
    try {
      await productRef.doc(productId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Product> getProduct({required String productId}) async {
    final fetchedProduct = await productRef.doc(productId).get();

    return Product(
      id: fetchedProduct.id,
      name: fetchedProduct.data()?[productNameField],
      category: fetchedProduct.data()?[productCategoryField],
      price: fetchedProduct.data()?[productPriceField],
      image: fetchedProduct.data()?[productImageField],
      description: fetchedProduct.data()?[descriptionField],
      createdAt: fetchedProduct.data()?[createdAtField],
      updatedAt: fetchedProduct.data()?[updatedAtField],
    );
  }

  Future<Product> updateProduct({
    required String productId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await productRef.doc(productId).update(data);

      final fetchedProduct = await productRef.doc(productId).get();
      return Product(
        id: fetchedProduct.id,
        name: fetchedProduct.data()?[productNameField],
        category: fetchedProduct.data()?[productCategoryField],
        price: fetchedProduct.data()?[productPriceField],
        image: fetchedProduct.data()?[productImageField],
        description: fetchedProduct.data()?[descriptionField],
        createdAt: fetchedProduct.data()?[createdAtField],
        updatedAt: fetchedProduct.data()?[updatedAtField],
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<Product>> allProducts() {
    final allProducts = productRef.snapshots().map(
        (event) => event.docs.map((e) => Product.fromSnapshot(e)).toList());
    return allProducts;
  }

  Stream<List<Order>> allOrdersUser({required String userId}) {
    final allOrders = order
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((event) => event.docs.map((e) => Order.fromFirestore(e)).toList());

    return allOrders;
  }

  Future<Order> addOrder({
    required String productId,
    required String userId,
    required int quantity,
  }) async {
    final document = await order.add({
      'product_id': productId,
      'user_id': userId,
      'quantity': quantity,
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    });

    final fetchedProduct = await productRef.doc(productId).get();

    final fetchetOrder = await document.get();

    return Order(
      id: fetchetOrder.id,
      userId: userId,
      productId: fetchetOrder.data()!['product_id'],
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );
  }

  Stream<List<Order>> allOrders() {
    final allOrders = order
        .snapshots()
        .map((event) => event.docs.map((e) => Order.fromFirestore(e)).toList());

    return allOrders;
  }

  Future<Room> createRoom({
    required String userId,
    required String productId,
  }) async {
    final roomQuery = await rooms
        .where('user_id', isEqualTo: userId)
        .where('product_id', isEqualTo: productId)
        .limit(1)
        .get();

    if (roomQuery.docs.isEmpty) {
      final room = await rooms.add({
        'product_id': productId,
        'user_id': userId,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      });

      final fetchedRoom = await room.get();

      return Room(
        id: fetchedRoom.id,
        userId: fetchedRoom.data()!['user_id'],
        phoneNumber: fetchedRoom.data()!['phone_number'],
        productId: fetchedRoom.data()!['product_id'],
        createdAt: fetchedRoom.data()!['created_at'],
        updatedAt: fetchedRoom.data()!['updated_at'],
      );
    }

    return Room.fromSnapshot(roomQuery.docs.first);
  }

  Future<Room> getRoom({required String roomId}) async {
    final room = await rooms.doc(roomId).get();

    return Room(
      id: room.id,
      userId: room.data()!['user_id'],
      productId: room.data()!['product_id'],
      phoneNumber: room.data()!['phone_number'],
      createdAt: room.data()!['created_at'],
      updatedAt: room.data()!['updated_at'],
    );
  }

  Stream<List<Room>> getRooms() {
    final allRooms = rooms
        .snapshots()
        .map((event) => event.docs.map((e) => Room.fromSnapshot(e)).toList());
    return allRooms;
  }

  Stream<List<Message>> getMessage({required String roomId}) {
    final messages = rooms
        .doc(roomId)
        .collection('message')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
            (event) => event.docs.map((e) => Message.fromSnapshot(e)).toList());

    return messages;
  }

  Future<void> addToCart({required Product prodcut}) async {}

  void sendMessage({
    required String text,
    required String authorId,
    required String roomId,
  }) async {
    await rooms.doc(roomId).collection('message').add({
      'text': text,
      'author_id': authorId,
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    });
  }
}
