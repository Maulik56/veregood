import 'package:get/get.dart';

class AddVariationController extends GetxController {
  List<Map<String, dynamic>> _addVariation = [];

  List<Map<String, dynamic>> get addVariation => _addVariation;

  set addVariation(List<Map<String, dynamic>> value) {
    _addVariation = value;
  }

  List<String> _listOfVariation = [];

  List<String> get listOfVariation => _listOfVariation;

  set listOfVariation(List<String> value) {
    _listOfVariation = value;
  }
}
