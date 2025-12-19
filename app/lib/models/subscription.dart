class Subscription {
  final int? id;
  final String name;
  final double cost;
  final String currency;
  final String firstPaymentDate;
  final String cycle;
  final String? description;
  final String? iconUrl;

  Subscription({
    this.id,
    required this.name,
    required this.cost,
    this.currency = 'USD',
    required this.firstPaymentDate,
    this.cycle = 'Monthly',
    this.description,
    this.iconUrl,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      name: json['name'],
      cost: (json['cost'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
      firstPaymentDate: json['firstPaymentDate'],
      cycle: json['cycle'] ?? 'Monthly',
      description: json['description'],
      iconUrl: json['iconUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cost': cost,
      'currency': currency,
      'firstPaymentDate': firstPaymentDate,
      'cycle': cycle,
      'description': description,
      'iconUrl': iconUrl,
    };
  }
}
