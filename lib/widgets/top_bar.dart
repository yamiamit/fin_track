import 'package:flutter/material.dart';
import 'package:fin_track/utils/theme/app_theme.dart';
import 'package:fin_track/utils/theme/theme_controller.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeController = context.watch<ThemeController>();
    final isDarkMode = themeController.isDarkMode;
    final iconColor = theme.iconTheme.color ?? colorScheme.onSurface;
    final dividerColor = colorScheme.onSurface.withValues(alpha: 0.15);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFFE6EBF2)
                          : colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "P",
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.black
                              : colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text("PayU", style: TextStyle(color: colorScheme.onSurface)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.search, color: iconColor),
                  const SizedBox(width: 16),
                  Stack(
                    children: [
                      Icon(Icons.notifications_none, color: iconColor),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "2",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: isDarkMode
                        ? 'Switch to light mode'
                        : 'Switch to dark mode',
                    onPressed: context.read<ThemeController>().toggleTheme,
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: iconColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Divider(color: dividerColor, height: 1),
      ],
    );
  }
}
