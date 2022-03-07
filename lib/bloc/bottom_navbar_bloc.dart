import 'dart:async';

enum NavBarItem { HOME, SOURCES, SEARCH }

class BottomNavBarBloc {
  final StreamController<NavBarItem> _navBarcontroller =
      StreamController<NavBarItem>.broadcast();
  NavBarItem defaultItem = NavBarItem.HOME;
  Stream<NavBarItem> get itemStream => _navBarcontroller.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarcontroller.sink.add(NavBarItem.HOME);
        break;
      case 1:
        _navBarcontroller.sink.add(NavBarItem.SOURCES);
        break;
      case 2:
        _navBarcontroller.sink.add(NavBarItem.SEARCH);
        break;
    }
  }

  close() {
    _navBarcontroller?.close();
  }
}
