import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants.dart';
import '../providers/subscription_provider.dart';
import '../models/subscription.dart';
import 'subscription_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  // Get subscriptions for a specific day
  List<Subscription> _getSubscriptionsForDay(DateTime day, List<Subscription> allSubscriptions) {
    return allSubscriptions.where((sub) {
      try {
        final paymentDate = DateTime.parse(sub.firstPaymentDate);
        // Check if same day/month (recurring logic)
        // For monthly: same day of month
        // For yearly: same day and month
        // For weekly: calculate if it falls on this day
        
        if (sub.cycle == 'Monthly') {
          return paymentDate.day == day.day;
        } else if (sub.cycle == 'Yearly') {
          return paymentDate.day == day.day && paymentDate.month == day.month;
        } else if (sub.cycle == 'Weekly') {
          // Same day of week
          return paymentDate.weekday == day.weekday;
        }
        return isSameDay(paymentDate, day);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  // Get all days that have subscriptions (for markers)
  Map<DateTime, List<Subscription>> _getEventMap(List<Subscription> subscriptions) {
    final Map<DateTime, List<Subscription>> events = {};
    
    // Generate events for the visible month range
    final start = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
    final end = DateTime(_focusedDay.year, _focusedDay.month + 2, 0);
    
    for (var day = start; day.isBefore(end); day = day.add(const Duration(days: 1))) {
      final subs = _getSubscriptionsForDay(day, subscriptions);
      if (subs.isNotEmpty) {
        events[DateTime(day.year, day.month, day.day)] = subs;
      }
    }
    
    return events;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubscriptionProvider>(context);
    final eventMap = _getEventMap(provider.subscriptions);
    final selectedDaySubs = _selectedDay != null 
        ? _getSubscriptionsForDay(_selectedDay!, provider.subscriptions)
        : <Subscription>[];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate total for selected day
    double selectedDayTotal = 0;
    for (var sub in selectedDaySubs) {
      selectedDayTotal += sub.cost;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Calendar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  if (selectedDaySubs.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\$${selectedDayTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Calendar
            TableCalendar<Subscription>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) {
                final normalizedDay = DateTime(day.year, day.month, day.day);
                return eventMap[normalizedDay] ?? [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              onPageChanged: (focusedDay) {
                setState(() => _focusedDay = focusedDay);
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
                markerSize: 6,
                markerMargin: const EdgeInsets.symmetric(horizontal: 1),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
                formatButtonTextStyle: const TextStyle(color: AppColors.primary),
              ),
            ),

            const SizedBox(height: 8),

            // Selected day subscriptions
            Expanded(
              child: selectedDaySubs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_available,
                            size: 48,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No payments on this day',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: selectedDaySubs.length,
                      itemBuilder: (context, index) {
                        final sub = selectedDaySubs[index];
                        return _buildSubscriptionTile(context, sub, isDark);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionTile(BuildContext context, Subscription sub, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubscriptionDetailScreen(subscription: sub)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  sub.name.isNotEmpty ? sub.name[0].toUpperCase() : 'S',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub.cycle,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '\$${sub.cost.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
