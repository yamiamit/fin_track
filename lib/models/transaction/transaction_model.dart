class TransactionModel {
   TransactionModel({
    required this.id,
    required this.amount,
    required this.isExpense,// checking whether this is an expense/income for toggling feature
    required this.category,
    required this.date,
    required this.note,
  });

  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final bool isExpense;
  final String note;


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isExpense': isExpense,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory TransactionModel.fromMap(Map<dynamic, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      isExpense: map['isExpense'] as bool,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      note: (map['note'] as String?) ?? '',
    );
  }
}
