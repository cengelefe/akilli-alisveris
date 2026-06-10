import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/state/shopping_state.dart';
import '../../data/models/product.dart';
import '../../data/models/category.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Harcama Analizi')),
      body: Consumer<ShoppingState>(
        builder: (context, state, child) {
          final allItems = state.allListItems;
          final products = state.products;
          final categories = state.categories;

          if (allItems.isEmpty) {
            return const Center(
              child: Text('Henüz hiç harcama verisi yok.', style: TextStyle(fontSize: 16)),
            );
          }

          // Calculate category totals
          Map<int, double> categoryTotals = {};
          double grandTotal = 0;

          for (var item in allItems) {
            final prod = products.firstWhere((p) => p.id == item.productId,
                orElse: () => Product(name: 'Bilinmeyen', categoryId: 0, defaultPrice: 0));
            final itemTotal = item.price * item.quantity;
            categoryTotals[prod.categoryId] = (categoryTotals[prod.categoryId] ?? 0) + itemTotal;
            grandTotal += itemTotal;
          }

          List<PieChartSectionData> pieSections = [];
          final colors = [
            Colors.blue, Colors.red, Colors.green, Colors.orange, 
            Colors.purple, Colors.teal, Colors.amber
          ];

          int colorIndex = 0;
          categoryTotals.forEach((catId, total) {
            final cat = categories.firstWhere((c) => c.id == catId,
                orElse: () => Category(name: 'Bilinmeyen', icon: 'unknown'));
            final double percentage = grandTotal > 0 ? (total / grandTotal) * 100 : 0.0;
            if (percentage > 0) {
              pieSections.add(
                PieChartSectionData(
                  color: colors[colorIndex % colors.length],
                  value: percentage,
                  title: '${percentage.toStringAsFixed(1)}%',
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  badgeWidget: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                    child: Text(cat.name, style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                  badgePositionPercentageOffset: 1.3,
                ),
              );
              colorIndex++;
            }
          });

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Kategorilere Göre Harcamalar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: pieSections,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Aylık Harcama Trendi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (grandTotal > 0 ? grandTotal : 2000) * 1.2,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);
                              Widget text;
                              switch (value.toInt()) {
                                case 0: text = const Text('Oca', style: style); break;
                                case 1: text = const Text('Şub', style: style); break;
                                case 2: text = const Text('Mar', style: style); break;
                                case 3: text = const Text('Nis', style: style); break;
                                case 4: text = const Text('May', style: style); break;
                                case 5: text = const Text('Haz', style: style); break;
                                default: text = const Text('', style: style); break;
                              }
                              return SideTitleWidget(meta: meta, child: text);
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        // For demo, just plotting the grand total on the current month (Haziran/June - index 5)
                        BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 0, color: Colors.blue)]),
                        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 0, color: Colors.blue)]),
                        BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 0, color: Colors.blue)]),
                        BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 0, color: Colors.blue)]),
                        BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 0, color: Colors.blue)]),
                        BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: grandTotal, color: Colors.blue)]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
