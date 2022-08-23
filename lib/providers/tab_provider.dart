import 'package:flutter/cupertino.dart';
import 'package:radioanaunia/pages/app_tab_type.dart';

class TabProvider with ChangeNotifier {
  AppTab _value = AppTab.radio;

  AppTab get value => _value;
  void set value(tab) {
    _value = tab;
    notifyListeners();
  }
}
