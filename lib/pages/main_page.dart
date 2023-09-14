import 'package:flutter/material.dart';
import 'package:imc_flutter/pages/home_page.dart';
import 'package:imc_flutter/pages/profile_page.dart';
import 'package:imc_flutter/pages/users_page.dart';
import 'package:imc_flutter/shared/widgets/custom_navibar.dart';
import 'package:imc_flutter/shared/widgets/custom_navibar_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int pagePosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (pos) {
                setState(() {
                  pagePosition = pos;
                });
              },
              children: const [
                HomePage(),
                UsersPage(),
                ProfilePage(),
              ],
            ),
          ),
          CustomNavibar(
            onTap: (value) {
              _pageController.jumpToPage(value);
            },
            items: const <Widget>[
              CustomNavibarItem(
                icon: Icons.home,
              ),
              CustomNavibarItem(
                icon: Icons.person_add_alt_1,
              ),
              CustomNavibarItem(
                icon: Icons.person,
              ),
            ],
            index: pagePosition,
          ),
        ],
      ),
    );
  }
}
