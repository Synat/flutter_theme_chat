import 'package:states_rebuilder/states_rebuilder.dart';

class NavigationBarState extends StatesRebuilder {
  int index = 0;

  void onChangeIndex(int index) {
    this.index = index;
    rebuildStates();
  }
}
