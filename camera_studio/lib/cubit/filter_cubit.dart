import 'package:camera_studio/cubit/filter_states.dart';
import 'package:camera_studio/filters/filters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(NoFilterState());

  void applyFilter(Filter filter) {
    if (filter is NoFilter) {
      emit(NoFilterState());
    } else {
      emit(ApplayFilterState(filter: filter));
    }
  }
}
