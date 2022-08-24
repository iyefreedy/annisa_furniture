import 'dart:io';

import 'package:annisa_furniture/constants/app_constants.dart';
import 'package:annisa_furniture/i10n/currency_input_formatter.dart';
import 'package:annisa_furniture/models/product.dart';
import 'package:annisa_furniture/pages/admin/cubit/category_cubit.dart';
import 'package:annisa_furniture/pages/admin/cubit/file_cubit.dart';
import 'package:annisa_furniture/pages/admin/widgets/category_dropdown.dart';
import 'package:annisa_furniture/services/cloud/firebase_cloud_storage.dart';
import 'package:annisa_furniture/utils/dialogs/generic_dialog.dart';
import 'package:annisa_furniture/utils/generics/get_arguments.dart';
import 'package:annisa_furniture/utils/utilities.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

class CreateUpdateProductPage extends StatefulWidget {
  const CreateUpdateProductPage({Key? key}) : super(key: key);

  @override
  State<CreateUpdateProductPage> createState() =>
      _CreateUpdateProductPageState();
}

class _CreateUpdateProductPageState extends State<CreateUpdateProductPage>
    with SingleTickerProviderStateMixin {
  late AnimationController loadingController;
  late FirebaseCloudStorage _cloudServices;

  List<File>? _files;
  Product? _product;
  String? category;

  late TextEditingController _priceController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  late DropdownButton dropdownButton;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _setupTextControllerListner(Product? data) {
    if (data != null) {
      _nameController.text = data.name!;
      _priceController.text = formatCurrency(data.price!);
      _descriptionController.text = data.description!;
    }
  }

  Future<Product> createOrGetExisitingProduct(BuildContext context) async {
    final widgetProduct = context.getArgument<Product>();

    if (widgetProduct != null) {
      debugPrint('Product from widget');
      _product = widgetProduct;
      _nameController.text = widgetProduct.name ?? '';
      _priceController.text = formatCurrency(widgetProduct.price);
      _descriptionController.text = widgetProduct.description ?? '';
      _files = widgetProduct.image!.map((e) => File(e)).toList();

      return widgetProduct;
    }

    final existingProduct = _product;
    if (existingProduct != null) {
      debugPrint('Product from exist');
      return existingProduct;
    }

    final newProduct = await _cloudServices.createProduct(
      name: '',
      category: 'Kamar Tidur',
      price: 0,
      image: [defaultProductImageUrl],
      description: '',
    );

    _files = newProduct.image!.map((e) => File(e)).toList();

    debugPrint('Product created');
    _product = newProduct;

    return newProduct;
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
      allowMultiple: true,
    );

    if (result != null) {
      List<File> files = result.files.map((e) => File(e.path!)).toList();

      if (_files != null) {
        context.read<FileCubit>().addFile(files);
      } else {
        context.read<FileCubit>().changeFile(files);
      }
    }

    loadingController.forward();
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    _cloudServices = FirebaseCloudStorage();

    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    loadingController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.arrow_back),
          onTap: () async {
            if (!_formKey.currentState!.validate()) {
              await _cloudServices.deleteProduct(productId: _product!.id);
            }
            print('validated');

            Navigator.of(context).pop();
          },
        ),
        title: const Text('Form Product'),
        backgroundColor: Colors.orange.shade400,
      ),
      body: FutureBuilder<Product>(
        future: createOrGetExisitingProduct(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;
            _setupTextControllerListner(snapshot.data!);
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Masukkan nama produk',
                      ),
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? 'Enter some text'
                            : null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _priceController,
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? 'Enter some text'
                            : null;
                      },
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          locale: 'id_ID',
                          symbol: 'Rp. ',
                          decimalDigits: 0,
                        )
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Enter product price',
                      ),
                    ),
                    BlocProvider(
                      create: (context) => CategoryCubit(product!.category!),
                      child: BlocListener<CategoryCubit, String>(
                        listener: (context, state) {
                          category = state;
                        },
                        child: CategoryDropdown(),
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: null,
                      minLines: 6,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Enter description here...',
                      ),
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? 'Enter some text'
                            : null;
                      },
                    ),
                    const SizedBox(height: 8.0),
                    BlocProvider<FileCubit>(
                      create: (context) => FileCubit(_files),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: BlocConsumer<FileCubit, List<File>?>(
                          listener: (context, state) {
                            _files = state;
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['png', 'jpg', 'jpeg'],
                                  allowMultiple: true,
                                );

                                if (result != null) {
                                  List<File> files = result.files
                                      .map((e) => File(e.path!))
                                      .toList();

                                  context.read<FileCubit>().changeFile(files);
                                }

                                loadingController.forward();
                              },
                              child: const Text('Pilih Gambar'),
                            );
                          },
                        ),
                      ),
                    ),
                    BlocProvider<FileCubit>(
                      create: (context) => FileCubit(_files),
                      child: Container(
                        height: 70.0,
                        padding: const EdgeInsets.all(12.0),
                        child: BlocConsumer<FileCubit, List<File>>(
                          listener: (context, state) {
                            _files = state;
                          },
                          builder: (context, state) {
                            return Row(
                              children: _files!
                                  .map<Widget>(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Stack(
                                        children: [
                                          Image.network(
                                            e.path,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.file(File(e.path));
                                            },
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: 5,
                                              color: Colors.redAccent,
                                              child: LinearProgressIndicator(
                                                value: loadingController.value,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onPressedUpdateProduct,
                      child: const Text('Masukkan'),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _onPressedUpdateProduct() async {
    if (_formKey.currentState!.validate()) {
      final removedStringFromPrice =
          _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
      debugPrint('Removed String : $removedStringFromPrice');
      final price = int.parse(removedStringFromPrice);
      debugPrint('final price : $price');

      List<String> listPath = [defaultProductImageUrl];
      List<String> newListPath = [];

      if (_files != null && _files!.first.path != defaultProductImageUrl) {
        for (var file in _files!) {
          if (file.path != defaultProductImageUrl) {
            final productReference =
                FirebaseStorage.instance.ref().child('products');

            final task = await productReference
                .child(path.basename(file.path))
                .putFile(File(file.path));

            final url = await task.ref.getDownloadURL();
            newListPath.add(url);
          }
        }

        listPath = newListPath;
      }

      Product cloudProduct = await _cloudServices.updateProduct(
        productId: _product!.id,
        data: {
          'name': _nameController.text,
          'category': category,
          'price': price,
          'image': listPath,
          'description': _descriptionController.text,
        },
      );

      _product = cloudProduct;
      showGenericDialog(
        context: context,
        title: 'Info',
        content: const Text('Data telah disimpan'),
        optionsBuilder: () => {'Ok': null},
      );
    } else {
      showGenericDialog(
        context: context,
        title: 'Error',
        content: const Text('Silahkan masukkan semua data'),
        optionsBuilder: () => {'Ok': null},
      );
    }
  }

  GestureDetector selectFile() {
    return GestureDetector(
      onTap: _selectFile,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DottedBorder(
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.folder_open,
                  color: Colors.blue,
                  size: 40,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Select your file',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
