import 'package:annisa_furniture/pages/admin/cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDropdown extends StatelessWidget {
  CategoryDropdown({Key? key}) : super(key: key);

  final List<String> _categoryProduct = [
    'Ruang Tamu',
    'Kamar Tidur',
    'Dapur',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, String>(
      builder: (context, state) {
        return DropdownButton<String>(
          isExpanded: true,
          value: state,
          items: _categoryProduct
              .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem<String>(
                  child: Text(e.toString()),
                  value: e.toString(),
                ),
              )
              .toList(),
          onChanged: (value) {
            context.read<CategoryCubit>().changeCategory(value);
          },
          hint: const Text('Select category'),
        );
      },
    );
  }
}
