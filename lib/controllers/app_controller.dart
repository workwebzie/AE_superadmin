import 'package:get/get.dart';
import '../models/client.dart';

class AppController extends GetxController {
  final RxBool isAuthenticated = false.obs;
  
  final RxList<Client> clients = <Client>[].obs;
  
  final RxString searchQuery = ''.obs;
  final RxString statusFilter = 'All'.obs;
  
  final RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Add some dummy data to start
    final now = DateTime.now();
    clients.addAll([
      Client(
        id: '1',
        name: 'Alice Cooper',
        email: 'alice@example.com',
        adminEmail: 'admin@example.com',
        baseUrl: 'https://app1.example.com',
        companyCode: 'CMP001',
        subscriptionStart: now.subtract(const Duration(days: 30)),
        subscriptionDurationDays: 365,
        subscriptionPlan: 'AE Advanced',
      ),
      Client(
        id: '2',
        name: 'Bob Ross',
        email: 'bob@example.com',
        adminEmail: 'bob.admin@example.com',
        baseUrl: 'https://ecom.example.com',
        companyCode: 'ECOMM2',
        subscriptionStart: now.subtract(const Duration(days: 300)),
        subscriptionDurationDays: 305, // near expiry
        subscriptionPlan: 'AE Pro',
      ),
      Client(
        id: '3',
        name: 'Charlie Chaplin',
        email: 'charlie@example.com',
        adminEmail: 'charlie@example.com',
        baseUrl: 'https://social.example.com',
        companyCode: 'SOC3',
        subscriptionStart: now.subtract(const Duration(days: 360)),
        subscriptionDurationDays: 300, // expired
        subscriptionPlan: 'AE Free',
      )
    ]);
  }

  void login(String username, String password) {
    if (username == 'admin' && password == 'password') {
      isAuthenticated.value = true;
    }
  }

  void logout() {
    isAuthenticated.value = false;
  }

  void addClient(Client client) {
    clients.add(client);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateStatusFilter(String status) {
    statusFilter.value = status;
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void deleteClient(String id) {
    clients.removeWhere((c) => c.id == id);
  }

  void updateClient(Client updatedClient) {
    final index = clients.indexWhere((c) => c.id == updatedClient.id);
    if (index != -1) {
      clients[index] = updatedClient;
      clients.refresh();
    }
  }

  List<Client> get filteredClients {
    var result = clients.toList();
    if (statusFilter.value != 'All') {
      result = result.where((c) => c.status == statusFilter.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      result = result.where((client) {
        return client.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            client.email.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
    return result;
  }

  int get totalClients => clients.length;
  int get activeClients => clients.where((c) => c.status == 'Active').length;
  int get nearExpiryClients => clients.where((c) => c.status == 'Near Expiry').length;
  int get expiredClients => clients.where((c) => c.status == 'Expired').length;
}
