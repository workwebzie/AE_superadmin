import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/app_controller.dart';
import '../models/client.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';
import 'add_client_screen.dart';

class ClientsListScreen extends StatelessWidget {
  const ClientsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Clients Directory',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddClientScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Client'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            onChanged: (val) => controller.updateSearchQuery(val),
            decoration: InputDecoration(
              hintText: 'Search by name or email...',
              prefixIcon: const Icon(Icons.search, color: AppTheme.fadedTextColor),
              filled: true,
              fillColor: AppTheme.cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.accentColor.withOpacity(0.3)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Active', 'Near Expiry', 'Expired'].map((status) {
                  final isSelected = controller.statusFilter.value == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(

                      label: Text(status),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          controller.updateStatusFilter(status);
                        }
                      },
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.fadedTextColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: AppTheme.cardColor,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        color : AppTheme.accentColor.withOpacity(0.3),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final clients = controller.filteredClients;
              return clients.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lottie/nodata.json', width: 200),
                          const SizedBox(height: 16),
                          const Text('No clients found.', style: TextStyle(color: AppTheme.fadedTextColor)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: clients.length,
                      itemBuilder: (context, index) {
                        final client = clients[index];
                        return _ClientCard(client: client);
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final Client client;

  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
      if (status == 'Active') return AppTheme.successColor;
      if (status == 'Near Expiry') return AppTheme.warningColor;
      return AppTheme.errorColor;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  foregroundColor: AppTheme.primaryColor,
                  child: Text(client.name[0].toUpperCase()),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      client.email,
                      style: const TextStyle(color: AppTheme.fadedTextColor, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Company Code: ${client.companyCode}',
                      style: const TextStyle(color: AppTheme.fadedTextColor, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      client.baseUrl,
                      style: const TextStyle(color: AppTheme.accentColor, fontSize: 13, decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20, color: AppTheme.primaryColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddClientScreen(client: client),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: AppTheme.errorColor),
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Delete Client',
                          middleText: 'Are you sure you want to delete ${client.name}?',
                          textConfirm: 'Delete',
                          textCancel: 'Cancel',
                          confirmTextColor: Colors.white,
                          buttonColor: AppTheme.errorColor,
                          cancelTextColor: AppTheme.primaryColor,
                          onConfirm: () {
                            Get.find<AppController>().deleteClient(client.id);
                            Get.back();
                          },
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.1),
                        border: Border.all(color: AppTheme.accentColor.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        client.subscriptionPlan,
                        style: const TextStyle(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(client.status).withOpacity(0.1),
                        border: Border.all(color: getStatusColor(client.status).withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        client.status,
                        style: TextStyle(
                          color: getStatusColor(client.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Expires: ${DateFormat('MMM dd, yyyy').format(client.expiryDate)}',
                  style: const TextStyle(fontSize: 12, color: AppTheme.fadedTextColor),
                ),
                Text(
                  '${client.daysLeft} days left',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
