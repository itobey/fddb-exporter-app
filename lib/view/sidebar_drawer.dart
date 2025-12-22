import 'package:flutter/material.dart';
import '../routes/route_names.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Drawer(
      child: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: <Widget>[
          // Paint under the Android status bar so it matches the drawer color when open
          Container(height: topPadding, color: Theme.of(context).colorScheme.primary),
          // Compact header instead of the tall default DrawerHeader
          Container(
            color: Theme.of(context).colorScheme.primary,
            height: 56, // roughly kToolbarHeight for a compact look
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: Text(
              'FDDB Exporter',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: const Text('Query Day'),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.pushNamed(context, RouteNames.dailySearch);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Export Data'),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.pushNamed(context, RouteNames.exportData);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Product Search'),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.pushNamed(context, RouteNames.productSearch);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Stats'),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.pushNamed(context, RouteNames.stats);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.insights),
                  title: const Text('Stats Average'),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.pushNamed(context, RouteNames.statsAverage);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calculate_sharp),
                  title: const Text('Correlation'),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.pushNamed(context, RouteNames.correlation);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.pushNamed(context, RouteNames.settings);
            },
          ),
        ],
      ),
    ),
    );
  }
}