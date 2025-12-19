import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSection(context, 'Appearance', [
            _buildThemeTile(context, themeProvider, isDark),
          ]),
          const SizedBox(height: 24),
          
          _buildSection(context, 'General', [
            _buildSettingTile(context, Icons.notifications_outlined, 'Notifications', 'Manage reminders', isDark),
            _buildSettingTile(context, Icons.attach_money, 'Currency', 'USD (\$)', isDark),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Data', [
            _buildSettingTile(context, Icons.backup_outlined, 'Backup', 'Export your data', isDark),
            _buildSettingTile(context, Icons.restore, 'Restore', 'Import from backup', isDark),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'About', [
            _buildSettingTile(context, Icons.info_outline, 'Version', '1.0.0', isDark),
            _buildSettingTile(context, Icons.privacy_tip_outlined, 'Privacy Policy', '', isDark),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildThemeTile(BuildContext context, ThemeProvider themeProvider, bool isDark) {
    String themeText = 'System';
    if (themeProvider.themeMode == ThemeMode.dark) themeText = 'Dark';
    if (themeProvider.themeMode == ThemeMode.light) themeText = 'Light';
    
    return ListTile(
      leading: Icon(
        isDark ? Icons.dark_mode : Icons.light_mode,
        color: AppColors.primary,
      ),
      title: const Text('Theme', style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(themeText, style: const TextStyle(fontSize: 12)),
      trailing: PopupMenuButton<ThemeMode>(
        initialValue: themeProvider.themeMode,
        onSelected: (ThemeMode mode) {
          themeProvider.setThemeMode(mode);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: ThemeMode.system,
            child: Row(
              children: [
                Icon(Icons.phone_android, size: 20),
                SizedBox(width: 12),
                Text('System'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: ThemeMode.light,
            child: Row(
              children: [
                Icon(Icons.light_mode, size: 20),
                SizedBox(width: 12),
                Text('Light'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: ThemeMode.dark,
            child: Row(
              children: [
                Icon(Icons.dark_mode, size: 20),
                SizedBox(width: 12),
                Text('Dark'),
              ],
            ),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(themeText, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, String subtitle, bool isDark) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title - Coming soon!'), duration: const Duration(seconds: 1)),
        );
      },
    );
  }
}
