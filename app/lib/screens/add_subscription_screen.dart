import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../services/database_helper.dart';
import '../widgets/icon_picker_dialog.dart';

class AddSubscriptionScreen extends StatefulWidget {
  final Subscription? existingSubscription; // For edit mode
  
  const AddSubscriptionScreen({super.key, this.existingSubscription});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _cycle = 'Monthly';
  DateTime _firstPaymentDate = DateTime.now();
  String _currency = 'USD';
  bool _remindMe = true;
  String? _selectedIcon;

  bool get isEditMode => widget.existingSubscription != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final sub = widget.existingSubscription!;
      _amountController.text = sub.cost.toString();
      _nameController.text = sub.name;
      _descriptionController.text = sub.description ?? '';
      _cycle = sub.cycle;
      _currency = sub.currency;
      _selectedIcon = sub.iconUrl;
      try {
        _firstPaymentDate = DateTime.parse(sub.firstPaymentDate);
      } catch (_) {}
    }
  }

  Future<void> _showIconPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => IconPickerDialog(currentIcon: _selectedIcon),
    );
    if (result != null) {
      setState(() => _selectedIcon = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? 'Edit Subscription' : 'New Subscription',
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon Picker
                  GestureDetector(
                    onTap: _showIconPicker,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            IconPickerDialog.getIconWidget(_selectedIcon, size: 80),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isDark ? AppColors.surfaceDark : Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.edit, size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to change icon',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text('Monthly Cost', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('\$', style: TextStyle(fontSize: 30, color: Colors.grey, fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Service Name
                  _buildInputCard(
                    context,
                    label: 'Service Name',
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Netflix, Spotify...',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  _buildInputCard(
                    context,
                    label: 'Description (Optional)',
                    child: TextField(
                      controller: _descriptionController,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Standard Plan',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Billing Details
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Billing Details', style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Cycle Selector
                  Container(
                    height: 50,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                    ),
                    child: Row(
                      children: ['Monthly', 'Yearly', 'Weekly'].map((cycle) {
                        final isSelected = _cycle == cycle;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _cycle = cycle),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)] : [],
                              ),
                              child: Text(
                                cycle,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dates & Currency Group
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsRow(
                          context,
                          icon: Icons.calendar_month,
                          iconColor: Colors.blue,
                          iconBg: Colors.blue.withOpacity(0.1),
                          label: 'First Payment',
                          trailing: TextButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _firstPaymentDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (date != null) setState(() => _firstPaymentDate = date);
                            },
                            child: Text(
                              "${_firstPaymentDate.year}-${_firstPaymentDate.month.toString().padLeft(2, '0')}-${_firstPaymentDate.day.toString().padLeft(2, '0')}",
                              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                        _buildSettingsRow(
                          context,
                          icon: Icons.attach_money,
                          iconColor: Colors.green,
                          iconBg: Colors.green.withOpacity(0.1),
                          label: 'Currency',
                          trailing: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _currency,
                              items: ['USD', 'EUR', 'GBP', 'LYD'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                              onChanged: (v) => setState(() => _currency = v!),
                              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                   Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Settings', style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                   Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: _remindMe,
                          onChanged: (v) => setState(() => _remindMe = v),
                          title: const Text('Remind me', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Get notified before payment', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.notifications, color: Colors.orange, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                ),
                child: Text(
                  isEditMode ? 'Update Subscription' : 'Save Subscription', 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(BuildContext context, {required String label, required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
          child,
        ],
      ),
    );
  }

  Widget _buildSettingsRow(BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required Widget trailing
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }

  void _saveSubscription() async {
    final name = _nameController.text;
    final cost = double.tryParse(_amountController.text) ?? 0.0;
    
    if (name.isEmpty || cost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid name and cost')));
      return;
    }

    final sub = Subscription(
      id: widget.existingSubscription?.id, // Keep ID for updates
      name: name,
      cost: cost,
      cycle: _cycle,
      currency: _currency,
      firstPaymentDate: "${_firstPaymentDate.year}-${_firstPaymentDate.month.toString().padLeft(2, '0')}-${_firstPaymentDate.day.toString().padLeft(2, '0')}",
      description: _descriptionController.text,
      iconUrl: _selectedIcon ?? "",
    );

    bool success;
    if (isEditMode) {
      // Update existing
      await DatabaseHelper.instance.update(sub);
      success = true;
    } else {
      // Add new
      success = await Provider.of<SubscriptionProvider>(context, listen: false).addSubscription(sub);
    }
    
    if (mounted) {
      if (success) {
        Provider.of<SubscriptionProvider>(context, listen: false).fetchSubscriptions();
        Navigator.pop(context);
        if (isEditMode) {
          Navigator.pop(context); // Pop detail screen too
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save subscription')));
      }
    }
  }
}
