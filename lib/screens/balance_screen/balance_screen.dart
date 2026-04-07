import 'package:fin_track/models/transaction/transaction_controller.dart';
import 'package:fin_track/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({
    super.key,
    required this.transactionController,
  });

  final TransactionController transactionController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor = primaryTextColor.withValues(alpha: 0.65);
    final spendRatio = transactionController.totalIncome <= 0
        ? 0.0
        : (transactionController.totalExpense / transactionController.totalIncome)
            .clamp(0.0, 1.0);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔝 FIXED TOP BAR
            const TopBar(),

            const SizedBox(height: 10),

            // 📜 SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Title
                    Text(
                      "Your Balances",
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Manage your multi-currency accounts",
                      style: TextStyle(color: secondaryTextColor),
                    ),

                    const SizedBox(height: 30),

                    // Gauge
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 180,
                                width: 180,
                                child: CircularProgressIndicator(
                                  value: spendRatio,
                                  strokeWidth: 10,
                                  backgroundColor: isDarkMode
                                      ? const Color(0xFF1A2235)
                                      : const Color(0xFFDDE5F0),
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.teal,
                                  ),
                                ),
                              ),
                              Text(
                                "\$${transactionController.netBalance.toStringAsFixed(0)}",
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Net balance after tracked transactions",
                            style: TextStyle(color: primaryTextColor),
                          ),
                          Text(
                            "${transactionController.transactions.length} transactions loaded",
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "Available Currencies",
                      style: TextStyle(color: primaryTextColor),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("🇨🇦", style: TextStyle(fontSize: 20)),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "CAD",
                                    style: TextStyle(color: primaryTextColor),
                                  ),
                                  Text(
                                    "Canadian Dollar",
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.star_border, color: primaryTextColor),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? const Color(0xFF0B1220)
                                      : const Color(0xFFE6ECF5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 14,
                                      color: primaryTextColor,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Enable",
                                      style: TextStyle(color: primaryTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Chart
                    SizedBox(
                      height: 220,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                6,
                                (index) => Container(
                                  width: 20,
                                  height: (index + 1) * 20.0,
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Current margin: April Spendings",
                                style: TextStyle(color: secondaryTextColor),
                              ),
                              Text(
                                "\$${transactionController.totalExpense.toStringAsFixed(2)} / \$${transactionController.totalIncome.toStringAsFixed(2)}",
                                style: TextStyle(color: colorScheme.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80), // space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
