import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'file_state.dart';

class FileCubit extends Cubit<List<File>> {
  List<File>? initialState;
  FileCubit(initialState) : super(initialState);

  void changeFile(List<File> files) {
    emit(files);
  }

  void addFile(List<File> files) {
    initialState!.addAll(files);
    emit(initialState!);
  }
}
