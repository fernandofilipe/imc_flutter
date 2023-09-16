import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/enums/page_type.dart';
import 'package:imc_flutter/pages/imc/add_imc_page.dart';
import 'package:imc_flutter/pages/imc/imcs_page.dart';
import 'package:imc_flutter/pages/profile/profile_page.dart';
import 'package:imc_flutter/pages/user/add_user_page.dart';
import 'package:imc_flutter/pages/user/users_page.dart';
import 'package:imc_flutter/shared/widgets/custom_app_bar.dart';
import 'package:imc_flutter/shared/widgets/custom_navibar.dart';
import 'package:imc_flutter/shared/widgets/custom_navibar_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController =
      PageController(initialPage: PageType.imc.index);
  int pagePosition = PageType.imc.index;
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      extendBody: true,
      body: PageView(
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
      floatingActionButton: pagePosition == PageType.imc.index
          ? _showAddUserButton()
          : pagePosition == PageType.users.index
              ? _showAddImcButton()
              : const SizedBox(),
      bottomNavigationBar: CustomNavibar(
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
    );
  }

  _showAddUserButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Get.to(
          () => const AddImcPage(),
          preventDuplicates: true,
        );
      },
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }

  _showAddImcButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Get.to(
          () => const AddUserPage(),
          preventDuplicates: true,
        );
      },
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }
}
