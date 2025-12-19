import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../services/database_helper.dart';

class SubscriptionProvider with ChangeNotifier {
  List<Subscription> _subscriptions = [];
  double _totalSpend = 0.0;
  bool _isLoading = false;

  List<Subscription> get subscriptions => _subscriptions;
  double get totalSpend => _totalSpend;
  bool get isLoading => _isLoading;

  Future<void> fetchSubscriptions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _subscriptions = await DatabaseHelper.instance.readAllSubscriptions();
      _calculateTotalSpend();
    } catch (e) {
      debugPrint("Error fetching subscriptions: $e");
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void _calculateTotalSpend() {
    _totalSpend = 0;
    for (var sub in _subscriptions) {
      // Simple logic: Assume all costs are monthly for now, or check cycle
      // If adding cycle logic:
      // if (sub.cycle == 'Yearly') _totalSpend += sub.cost / 12;
      // else if (sub.cycle == 'Weekly') _totalSpend += sub.cost * 4;
      // else _totalSpend += sub.cost;
      
      // For MVP matching previous backend logic:
      _totalSpend += sub.cost;
    }
  }

  Future<bool> addSubscription(Subscription subscription) async {
    try {
      await DatabaseHelper.instance.create(subscription);
      await fetchSubscriptions(); // Refresh list
      return true;
    } catch (e) {
      debugPrint("Error adding subscription: $e");
      return false;
    }
  }
}
