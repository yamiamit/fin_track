import 'package:fin_track/models/transaction/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TransactionController extends ChangeNotifier {
  static const String boxName = 'transactions_box';
  String? _initError;
  String? get initError => _initError;

  bool get hasError => _initError != null;

  static const List<String> predefinedCategories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Salary',
    'Health',
    'Entertainment',
  ];

  Box<dynamic>? _box;
  bool _isReady = false;
  List<TransactionModel> _transactions = const [];

  bool get isReady => _isReady;

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  List<TransactionModel> get recentTransactions {
    return transactions.take(6).toList();
  }

  double get totalIncome =>
      _transactions
          .where((transaction) =>
      !transaction.isExpense) // if its not an expense
          .fold(0, (sum, transaction) =>
      sum +
          transaction.amount); // add this to totalincome

  double get totalExpense =>
      _transactions
          .where((transaction) => transaction.isExpense)
          .fold(0, (sum, transaction) => sum + transaction.amount);

  double get netBalance => totalIncome - totalExpense;

  Map<String, double> get expenseByCategory {
    final totals = <String, double>{};

    for (final transaction in _transactions.where((entry) => entry.isExpense)) {
      totals.update(
        transaction.category,
            (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map<String, double>.fromEntries(entries);
  }

  Future<void> initialize() async {
    if (_isReady) return;

    try {
      _box = await Hive.openBox(boxName);
      await _reloadTransactions();
      _isReady = true;
      notifyListeners();
    } catch (e, stackTrace) {
      print('Error initializing storage: $e');
      print(stackTrace);

      // Set error state
      _initError = e.toString();
      _isReady = false; // Ensure it's false
      notifyListeners();
      // Optionally rethrow if you want the caller to handle it
      // rethrow;
    }

  }

  Future<void> addTransaction({
    required String id,
    required bool isExpense,
    required double amount,
    required String category,
    required DateTime date,
    required String note,
  }) async {
    try {
      if (_box == null) {
        await initialize();
      }

      final transaction = TransactionModel(
        id: id,
        amount: amount,
        isExpense: isExpense,
        category: category,
        date: date,
        note: note.trim(),
      );

      await _box!.put(transaction.id, transaction.toMap());
      print('Successfully stored in the box');

      await _reloadTransactions();

      if (!_isReady) {
        _isReady = true;
      }

      notifyListeners();
    } catch (e) {
      print('Error adding transaction: $e');
      // Optionally rethrow or handle appropriately
      rethrow;
    }
  }

  Future<void> _reloadTransactions() async {
    final box = _box;
    if (box == null) return;

    try {
      _transactions = box.values
          .whereType<Map<String, dynamic>>()
          .map(TransactionModel.fromMap)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      // Only notify if this is an explicit reload (not during initialization)
      // Or move notifyListeners() to the caller
    } catch (e) {
      print('Error reloading transactions: $e');
      _transactions = [];
    }
  }
}



class CategoryVisual {
  const CategoryVisual({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;
}

CategoryVisual categoryVisualFor(String category) {
  switch (category.toLowerCase()) {
    case 'food':
      return const CategoryVisual(
        icon: Icons.restaurant_rounded,
        color: Color(0xFFFF8A65),
      );
    case 'travel':
      return const CategoryVisual(
        icon: Icons.flight_takeoff_rounded,
        color: Color(0xFF4FC3F7),
      );
    case 'shopping':
      return const CategoryVisual(
        icon: Icons.shopping_bag_rounded,
        color: Color(0xFFBA68C8),
      );
    case 'bills':
      return const CategoryVisual(
        icon: Icons.receipt_long_rounded,
        color: Color(0xFFFFD54F),
      );
    case 'salary':
      return const CategoryVisual(
        icon: Icons.account_balance_wallet_rounded,
        color: Color(0xFF81C784),
      );
    case 'health':
      return const CategoryVisual(
        icon: Icons.favorite_rounded,
        color: Color(0xFFEF5350),
      );
    case 'entertainment':
      return const CategoryVisual(
        icon: Icons.movie_creation_rounded,
        color: Color(0xFF7986CB),
      );
    default:
      return const CategoryVisual(
        icon: Icons.category_rounded,
        color: Color(0xFF90A4AE),
      );
  }
}
