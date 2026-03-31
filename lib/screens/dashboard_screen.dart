import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overview',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
           
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 3;
              if (width < 600) {
                crossAxisCount = 1;
              } else if (width < 900) {
                crossAxisCount = 2;
              }

              return Obx(() {
                if (controller.totalClients == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),
                        Lottie.asset('assets/lottie/Girl meditating.json', width: 250),
                        const SizedBox(height: 16),
                        const Text('No clients added yet.', style: TextStyle(color: AppTheme.fadedTextColor, fontSize: 16)),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: width < 600 ? 2 : 2.8,
                      children: [
                        _StatCard(
                          title: 'Total Clients',
                          value: controller.totalClients.toString(),
                          icon: Icons.group,
                          color: AppTheme.primaryColor,
                          filter: 'All',
                        ),
                        _StatCard(
                          title: 'Active Subs',
                          value: controller.activeClients.toString(),
                          icon: Icons.check_circle_outline,
                          color: AppTheme.successColor,
                          filter: 'Active',
                        ),
                        _StatCard(
                          title: 'Near Expiry!',
                          value: controller.nearExpiryClients.toString(),
                          icon: Icons.warning_amber_rounded,
                          color: AppTheme.warningColor,
                          filter: 'Near Expiry',
                        ),
                        _StatCard(
                          title: 'Expired Subs',
                          value: controller.expiredClients.toString(),
                          icon: Icons.error_outline,
                          color: AppTheme.errorColor,
                          filter: 'Expired',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text('Client Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: SfCircularChart(
                            legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                            series: <CircularSeries>[
                              DoughnutSeries<_ChartData, String>(
                                dataSource: [
                                  if (controller.activeClients > 0)
                                    _ChartData(category: 'Active', value: controller.activeClients, color: AppTheme.successColor),
                                  if (controller.nearExpiryClients > 0)
                                    _ChartData(category: 'Near Expiry', value: controller.nearExpiryClients, color: AppTheme.warningColor),
                                  if (controller.expiredClients > 0)
                                    _ChartData(category: 'Expired', value: controller.expiredClients, color: AppTheme.errorColor),
                                ],
                                xValueMapper: (_ChartData data, _) => data.category,
                                yValueMapper: (_ChartData data, _) => data.value,
                                pointColorMapper: (_ChartData data, _) => data.color,
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                innerRadius: '50%',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                     const SizedBox(height: 50),
                    const Text('powered By WorkFox', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold , color: Colors.grey),textAlign: TextAlign.center,),
                    const SizedBox(height: 16),
                  ],
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String filter;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final ctrl = Get.find<AppController>();
        ctrl.updateStatusFilter(filter);
        ctrl.changeTabIndex(1);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              offset: const Offset(0, 8),
              blurRadius: 24,
              spreadRadius: -4,
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.fadedTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData({required this.category, required this.value, required this.color});
  final String category;
  final int value;
  final Color color;
}

