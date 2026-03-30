import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../widgets/responsive.dart';
import '../widgets/side_menu.dart';
import 'dashboard_screen.dart';
import 'clients_list_screen.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final List<Widget> screens = [
      const DashboardScreen(),
      const ClientsListScreen(),
    ];

    return Obx(() {
      return Scaffold(
        key: scaffoldKey,
        appBar: Responsive.isMobile(context)
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                ),
              )
            : null,
        drawer: Responsive.isMobile(context)
            ? SideMenu(
                selectedIndex: controller.tabIndex.value,
                onItemSelected: (idx) {
                  controller.changeTabIndex(idx);
                  Navigator.pop(context); // Close drawer
                },
              )
            : null,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 2,
                child: SideMenu(
                   selectedIndex: controller.tabIndex.value,
                   onItemSelected: (idx) {
                     controller.changeTabIndex(idx);
                   },
                ),
              ),
            Expanded(
              flex: 8,
              child: screens[controller.tabIndex.value],
            ),
          ],
        ),
      );
    });
  }
}
