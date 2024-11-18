import 'package:flutter/material.dart';
import 'package:metamask_login_blog/ui/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/order.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  bool? _isAdmin;

  final List<Widget> _pages = [
    OrderBookPage(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    _loadTabIndex();
    super.initState();
  }

  void _loadTabIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentIndex = prefs.getInt('selectedTabIndex') ?? 0; // Default to 0
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          _onTabTapped(0);
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: Container(
            height: 80,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.transparent,
                  width: 0.0,
                ),
              ),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: _buildNavItem(
                    _currentIndex == 0
                        ? Icons.shopping_cart
                        : Icons.shopping_cart_outlined, // Order Icon
                    'Order',
                    _currentIndex == 0 ? Colors.black : Colors.black,
                    () => _onTabTapped(0),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: _buildNavItem(
                    _currentIndex == 1
                        ? Icons.person_rounded
                        : Icons.perm_identity_rounded, // Order Icon
                    'Profile',
                    _currentIndex == 0 ? Colors.black : Colors.black,
                    () => _onTabTapped(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String text, Color color, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: color),
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterNavItem(Widget icon) {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: icon,
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // _saveTabIndex(index); // Save the tab index whenever it changes
  }
}
