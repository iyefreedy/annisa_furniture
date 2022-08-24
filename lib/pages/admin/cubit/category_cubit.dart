import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<String> {
  CategoryCubit(String value) : super(value);

  void changeCategory(String? value) {
    emit(value!);
  }
}
