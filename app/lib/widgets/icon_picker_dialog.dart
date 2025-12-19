import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../constants.dart';

// Popular services with their icons and colors
const List<Map<String, dynamic>> _popularServices = [
  {'name': 'Netflix', 'icon': 'N', 'color': 0xFFE50914},
  {'name': 'Spotify', 'icon': 'S', 'color': 0xFF1DB954},
  {'name': 'YouTube', 'icon': 'Y', 'color': 0xFFFF0000},
  {'name': 'Amazon', 'icon': 'A', 'color': 0xFFFF9900},
  {'name': 'Disney+', 'icon': 'D', 'color': 0xFF113CCF},
  {'name': 'Apple', 'icon': '', 'color': 0xFF000000},
  {'name': 'HBO', 'icon': 'H', 'color': 0xFF5822B4},
  {'name': 'Hulu', 'icon': 'h', 'color': 0xFF1CE783},
  {'name': 'Twitch', 'icon': 'T', 'color': 0xFF9146FF},
  {'name': 'Dropbox', 'icon': 'D', 'color': 0xFF0061FF},
  {'name': 'iCloud', 'icon': 'i', 'color': 0xFF3693F3},
  {'name': 'Adobe', 'icon': 'A', 'color': 0xFFFF0000},
  {'name': 'Microsoft', 'icon': 'M', 'color': 0xFF00A4EF},
  {'name': 'Google', 'icon': 'G', 'color': 0xFF4285F4},
  {'name': 'Notion', 'icon': 'N', 'color': 0xFF000000},
  {'name': 'Slack', 'icon': 'S', 'color': 0xFF4A154B},
  {'name': 'Zoom', 'icon': 'Z', 'color': 0xFF2D8CFF},
  {'name': 'LinkedIn', 'icon': 'in', 'color': 0xFF0A66C2},
  {'name': 'GitHub', 'icon': 'G', 'color': 0xFF181717},
  {'name': 'ChatGPT', 'icon': 'C', 'color': 0xFF10A37F},
];

// Category icons
const List<Map<String, dynamic>> _categoryIconsData = [
  {'name': 'Entertainment', 'iconCode': 0xe02c, 'color': 0xFFE91E63},
  {'name': 'Music', 'iconCode': 0xe415, 'color': 0xFF9C27B0},
  {'name': 'Gaming', 'iconCode': 0xea28, 'color': 0xFF673AB7},
  {'name': 'Cloud', 'iconCode': 0xe2bd, 'color': 0xFF2196F3},
  {'name': 'News', 'iconCode': 0xeb81, 'color': 0xFF00BCD4},
  {'name': 'Fitness', 'iconCode': 0xe317, 'color': 0xFF4CAF50},
  {'name': 'Food', 'iconCode': 0xe56c, 'color': 0xFFFF9800},
  {'name': 'Shopping', 'iconCode': 0xf37b, 'color': 0xFFFF5722},
  {'name': 'Education', 'iconCode': 0xe559, 'color': 0xFF795548},
  {'name': 'Finance', 'iconCode': 0xe84f, 'color': 0xFF607D8B},
  {'name': 'Health', 'iconCode': 0xe3f3, 'color': 0xFFF44336},
  {'name': 'Utilities', 'iconCode': 0xe0e9, 'color': 0xFFFFEB3B},
  {'name': 'Insurance', 'iconCode': 0xe32a, 'color': 0xFF3F51B5},
  {'name': 'Phone', 'iconCode': 0xe324, 'color': 0xFF009688},
  {'name': 'Internet', 'iconCode': 0xe63e, 'color': 0xFF00BCD4},
  {'name': 'Software', 'iconCode': 0xe86f, 'color': 0xFF9E9E9E},
];

class IconPickerDialog extends StatefulWidget {
  final String? currentIcon;
  
  const IconPickerDialog({super.key, this.currentIcon});

  // Static method to get icon widget from iconKey
  static Widget getIconWidget(String? iconKey, {double size = 50}) {
    if (iconKey == null || iconKey.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(Icons.subscriptions, color: Colors.white, size: size * 0.5),
        ),
      );
    }

    // Custom uploaded image
    if (iconKey.startsWith('custom_')) {
      final imagePath = iconKey.replaceFirst('custom_', '');
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: FileImage(File(imagePath)),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (iconKey.startsWith('service_')) {
      final serviceName = iconKey.replaceFirst('service_', '');
      Map<String, dynamic>? service;
      for (var s in _popularServices) {
        if (s['name'] == serviceName) {
          service = s;
          break;
        }
      }
      service ??= {'icon': 'S', 'color': 0xFF666666};
      
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(service['color']),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            service['icon'] ?? 'S',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.4,
            ),
          ),
        ),
      );
    }

    if (iconKey.startsWith('category_')) {
      final categoryName = iconKey.replaceFirst('category_', '');
      Map<String, dynamic>? category;
      for (var c in _categoryIconsData) {
        if (c['name'] == categoryName) {
          category = c;
          break;
        }
      }
      category ??= {'iconCode': 0xe574, 'color': 0xFF666666};
      
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(category['color']),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            IconData(category['iconCode'], fontFamily: 'MaterialIcons'),
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
      );
    }

    // Fallback
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.subscriptions, color: Colors.white, size: size * 0.5),
      ),
    );
  }

  @override
  State<IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<IconPickerDialog> {
  String? _selectedIcon;
  int _selectedTab = 0;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.currentIcon;
  }

  Future<void> _pickCustomIcon() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 200,
        maxHeight: 200,
        imageQuality: 80,
      );
      
      if (image != null) {
        // Copy to app directory for persistence
        final appDir = await getApplicationDocumentsDirectory();
        final iconsDir = Directory('${appDir.path}/icons');
        if (!await iconsDir.exists()) {
          await iconsDir.create(recursive: true);
        }
        
        final fileName = 'icon_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
        final savedPath = '${iconsDir.path}/$fileName';
        await File(image.path).copy(savedPath);
        
        setState(() {
          _selectedIcon = 'custom_$savedPath';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 340,
        height: 520,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose Icon',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Upload Custom Button
            GestureDetector(
              onTap: _pickCustomIcon,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Upload from Gallery',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Tabs
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Services',
                          style: TextStyle(
                            color: _selectedTab == 0 ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            color: _selectedTab == 1 ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Preview selected custom icon
            if (_selectedIcon != null && _selectedIcon!.startsWith('custom_'))
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    IconPickerDialog.getIconWidget(_selectedIcon, size: 40),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Custom icon selected',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            
            // Grid
            Expanded(
              child: _selectedTab == 0
                  ? _buildServicesGrid(isDark)
                  : _buildCategoriesGrid(isDark),
            ),
            
            const SizedBox(height: 16),
            
            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedIcon != null
                    ? () => Navigator.pop(context, _selectedIcon)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Select', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid(bool isDark) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _popularServices.length,
      itemBuilder: (context, index) {
        final service = _popularServices[index];
        final iconKey = 'service_${service['name']}';
        final isSelected = _selectedIcon == iconKey;
        
        return GestureDetector(
          onTap: () => setState(() => _selectedIcon = iconKey),
          child: Container(
            decoration: BoxDecoration(
              color: Color(service['color']),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)]
                  : null,
            ),
            child: Center(
              child: Text(
                service['icon'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesGrid(bool isDark) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _categoryIconsData.length,
      itemBuilder: (context, index) {
        final category = _categoryIconsData[index];
        final iconKey = 'category_${category['name']}';
        final isSelected = _selectedIcon == iconKey;
        
        return GestureDetector(
          onTap: () => setState(() => _selectedIcon = iconKey),
          child: Container(
            decoration: BoxDecoration(
              color: Color(category['color']),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)]
                  : null,
            ),
            child: Center(
              child: Icon(
                IconData(category['iconCode'], fontFamily: 'MaterialIcons'),
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }
}
