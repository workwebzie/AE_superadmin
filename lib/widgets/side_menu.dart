import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../theme/app_theme.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideMenu({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.bgColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.accentColor.withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height:100,
                  color: AppTheme.primaryColor,
                ),
           
              ],
            ),
          ),
          _DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard,
            isSelected: selectedIndex == 0,
            press: () => onItemSelected(0),
          ),
          _DrawerListTile(
            title: "Clients",
            icon: Icons.people,
            isSelected: selectedIndex == 1,
            press: () => onItemSelected(1),
          ),
          const Spacer(),
          Divider(color: AppTheme.accentColor.withOpacity(0.1)),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.errorColor),
            title: const Text('Logout', style: TextStyle(color: AppTheme.errorColor)),
            onTap: () {
              Get.find<AppController>().logout();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  const _DrawerListTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.press,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.5) : Colors.transparent,
        )
      ),
      child: ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          color: isSelected ? AppTheme.primaryColor : AppTheme.fadedTextColor,
          size: 24,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryColor : AppTheme.fadedTextColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
