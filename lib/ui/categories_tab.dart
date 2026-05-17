import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/data_provider.dart';

final timeFilterProvider = StateProvider<String>((ref) => 'Monthly');

class CategoriesTab extends ConsumerWidget {
  const CategoriesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final transactions = ref.watch(transactionsProvider);
    final timeFilter = ref.watch(timeFilterProvider);

    // Calculate aggregated amounts
    Map<String, double> categoryTotals = {};
    for (var cat in categories) {
      categoryTotals[cat.id] = 0.0;
    }

    // Filter transactions by timeFilter (Simplified for prototype)
    final now = DateTime.now();
    for (var t in transactions) {
      if (!t.isIncome) {
        if (timeFilter == 'Monthly' && t.date.month == now.month && t.date.year == now.year) {
          categoryTotals[t.categoryId] = (categoryTotals[t.categoryId] ?? 0) + t.amount;
        } else if (timeFilter == 'Yearly' && t.date.year == now.year) {
          categoryTotals[t.categoryId] = (categoryTotals[t.categoryId] ?? 0) + t.amount;
        } else if (timeFilter == 'All Time') {
          categoryTotals[t.categoryId] = (categoryTotals[t.categoryId] ?? 0) + t.amount;
        }
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('By Category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
                  ]
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: timeFilter,
                    items: ['Monthly', 'Yearly', '6 Months', 'All Time']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(timeFilterProvider.notifier).state = val;
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final total = categoryTotals[cat.id] ?? 0.0;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(cat.colorValue).withOpacity(0.1),
                      child: Icon(IconData(cat.iconCode, fontFamily: 'MaterialIcons'), color: Color(cat.colorValue)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: total > 0 ? 0.5 : 0.0, // Simplified for prototype
                            backgroundColor: Colors.grey.shade200,
                            color: Color(cat.colorValue),
                            borderRadius: BorderRadius.circular(10),
                            minHeight: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
