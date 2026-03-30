class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String details;
  final DateTime subscriptionStart;
  final int subscriptionDurationDays;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.details,
    required this.subscriptionStart,
    required this.subscriptionDurationDays,
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
    String? phone,
    String? details,
    DateTime? subscriptionStart,
    int? subscriptionDurationDays,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      details: details ?? this.details,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionDurationDays: subscriptionDurationDays ?? this.subscriptionDurationDays,
    );
  }
}
