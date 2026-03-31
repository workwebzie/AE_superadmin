class Client {
  final String id;
  final String name;
  final String email;
  final String adminEmail;
  final String baseUrl;
  final String companyCode;
  final DateTime subscriptionStart;
  final int subscriptionDurationDays;
  final String subscriptionPlan;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.adminEmail,
    required this.baseUrl,
    required this.companyCode,
    required this.subscriptionStart,
    required this.subscriptionDurationDays,
    this.subscriptionPlan = 'AE Free',
  });

  DateTime get expiryDate {
    return subscriptionStart.add(Duration(days: subscriptionDurationDays));
  }

  int get daysLeft {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }

  String get status {
    final left = daysLeft;
    if (left < 0) return 'Expired';
    if (left <= 7) return 'Near Expiry';
    return 'Active';
  }

  Client copyWith({
    String? id,
    String? name,
    String? email,
    String? adminEmail,
    String? baseUrl,
    String? companyCode,
    DateTime? subscriptionStart,
    int? subscriptionDurationDays,
    String? subscriptionPlan,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      adminEmail: adminEmail ?? this.adminEmail,
      baseUrl: baseUrl ?? this.baseUrl,
      companyCode: companyCode ?? this.companyCode,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionDurationDays: subscriptionDurationDays ?? this.subscriptionDurationDays,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
    );
  }
}
