import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/category.dart';

final transactionBoxProvider = Provider<Box<Transaction>>((ref) {
  return Hive.box<Transaction>('transactions');
});

final categoryBoxProvider = Provider<Box<ExpenseCategory>>((ref) {
  return Hive.box<ExpenseCategory>('categories');
});

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final Box<Transaction> box;

  TransactionNotifier(this.box) : super(box.values.toList()) {
    box.listenable().addListener(() {
      state = box.values.toList();
    });
  }

  void addTransaction(Transaction transaction) {
    box.put(transaction.id, transaction);
  }

  void deleteTransaction(String id) {
    box.delete(id);
  }
}

final transactionsProvider = StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  final box = ref.watch(transactionBoxProvider);
  return TransactionNotifier(box);
});

class CategoryNotifier extends StateNotifier<List<ExpenseCategory>> {
  final Box<ExpenseCategory> box;

  CategoryNotifier(this.box) : super(box.values.toList()) {
    if (state.isEmpty) {
      _initDefaultCategories();
    }
    box.listenable().addListener(() {
      state = box.values.toList();
    });
  }

  void _initDefaultCategories() {
    final defaults = [
      ExpenseCategory(id: '1', name: 'Food', colorValue: 0xFFFF5252, iconCode: 0xe532),
      ExpenseCategory(id: '2', name: 'Transport', colorValue: 0xFF448AFF, iconCode: 0xe1d5),
      ExpenseCategory(id: '3', name: 'Shopping', colorValue: 0xFFFF4081, iconCode: 0xe5fc),
      ExpenseCategory(id: '4', name: 'Salary', colorValue: 0xFF69F0AE, iconCode: 0xe065),
    ];
    for (var cat in defaults) {
      box.put(cat.id, cat);
    }
  }

  void addCategory(ExpenseCategory category) {
    box.put(category.id, category);
  }
}

final categoriesProvider = StateNotifierProvider<CategoryNotifier, List<ExpenseCategory>>((ref) {
  final box = ref.watch(categoryBoxProvider);
  return CategoryNotifier(box);
});

// Filter Providers

final selectedYearProvider = StateProvider<int>((ref) => DateTime.now().year);
final selectedMonthProvider = StateProvider<int>((ref) => DateTime.now().month);

final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final year = ref.watch(selectedYearProvider);
  final month = ref.watch(selectedMonthProvider);

  return transactions.where((t) => t.date.year == year && t.date.month == month).toList();
});
