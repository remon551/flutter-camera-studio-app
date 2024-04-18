import 'package:camera_studio/filters/filters.dart';

class FilterState{}

class NoFilterState  extends FilterState{}

class ApplayFilterState extends FilterState {
  final Filter filter;
  ApplayFilterState({required this.filter});
}
