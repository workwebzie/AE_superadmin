import 'package:get/get.dart';
import '../models/client.dart';

class AppController extends GetxController {
  final RxBool isAuthenticated = false.obs;
  
  final RxList<Client> clients = <Client>[].obs;
  
  final RxString searchQuery = ''.obs;
  
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
        phone: '123-456-7890',
        details: 'Premium App Template',
        subscriptionStart: now.subtract(const Duration(days: 30)),
        subscriptionDurationDays: 365,
      ),
      Client(
        id: '2',
        name: 'Bob Ross',
        email: 'bob@example.com',
        phone: '098-765-4321',
        details: 'E-commerce platform',
        subscriptionStart: now.subtract(const Duration(days: 300)),
        subscriptionDurationDays: 305, // near expiry
      ),
      Client(
        id: '3',
        name: 'Charlie Chaplin',
        email: 'charlie@example.com',
        phone: '555-555-5555',
        details: 'Social network app',
        subscriptionStart: now.subtract(const Duration(days: 360)),
        subscriptionDurationDays: 300, // expired
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
    if (searchQuery.value.isEmpty) return clients;
    return clients.where((client) {
      return client.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          client.email.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  int get totalClients => clients.length;
  int get activeClients => clients.where((c) => c.status == 'Active').length;
  int get nearExpiryClients => clients.where((c) => c.status == 'Near Expiry').length;
  int get expiredClients => clients.where((c) => c.status == 'Expired').length;
}
