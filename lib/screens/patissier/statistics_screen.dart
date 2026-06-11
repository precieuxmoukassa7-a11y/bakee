import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatissierStatisticsScreen extends StatefulWidget {
  const PatissierStatisticsScreen({super.key});

  @override
  State<PatissierStatisticsScreen> createState() => _PatissierStatisticsScreenState();
}

class _PatissierStatisticsScreenState extends State<PatissierStatisticsScreen> {
  String _selectedPeriod = 'Cette semaine';
  final List<String> _periods = ['Aujourd\'hui', 'Cette semaine', 'Ce mois', 'Cette année'];

  // Données statistiques
  Map<String, dynamic> _statistics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    // Simuler le chargement
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _statistics = _generateStatistics();
      _isLoading = false;
    });
  }

  Map<String, dynamic> _generateStatistics() {
    final now = DateTime.now();
    final dateFormat = DateFormat('dd/MM');

    // Données en fonction de la période
    Map<String, dynamic> data;

    switch (_selectedPeriod) {
      case 'Aujourd\'hui':
        data = {
          'total_orders': 23,
          'total_revenue': 437.50,
          'average_basket': 19.02,
          'new_clients': 5,
          'orders_growth': '+8%',
          'revenue_growth': '+12%',
          'top_products': [
            {'name': 'Croissant', 'quantity': 48, 'revenue': 72.00},
            {'name': 'Pain au chocolat', 'quantity': 42, 'revenue': 63.00},
            {'name': 'Tarte aux fraises', 'quantity': 15, 'revenue': 67.50},
          ],
          'chart_data': [
            {'hour': '08h', 'orders': 2},
            {'hour': '09h', 'orders': 5},
            {'hour': '10h', 'orders': 4},
            {'hour': '11h', 'orders': 3},
            {'hour': '12h', 'orders': 2},
            {'hour': '14h', 'orders': 1},
            {'hour': '15h', 'orders': 2},
            {'hour': '16h', 'orders': 2},
            {'hour': '17h', 'orders': 1},
            {'hour': '18h', 'orders': 1},
          ],
          'status_distribution': [
            {'status': 'Livrée', 'count': 18, 'percentage': 78},
            {'status': 'En préparation', 'count': 3, 'percentage': 13},
            {'status': 'Confirmée', 'count': 2, 'percentage': 9},
          ],
        };
        break;

      case 'Cette semaine':
        data = {
          'total_orders': 156,
          'total_revenue': 2847.50,
          'average_basket': 18.25,
          'new_clients': 32,
          'orders_growth': '+15%',
          'revenue_growth': '+22%',
          'top_products': [
            {'name': 'Croissant', 'quantity': 342, 'revenue': 513.00},
            {'name': 'Pain au chocolat', 'quantity': 289, 'revenue': 433.50},
            {'name': 'Tarte aux fraises', 'quantity': 127, 'revenue': 571.50},
            {'name': 'Éclair au chocolat', 'quantity': 98, 'revenue': 313.60},
            {'name': 'Macaron', 'quantity': 234, 'revenue': 421.20},
          ],
          'chart_data': [
            {'day': 'Lun', 'orders': 18, 'revenue': 342.50},
            {'day': 'Mar', 'orders': 22, 'revenue': 418.00},
            {'day': 'Mer', 'orders': 25, 'revenue': 475.00},
            {'day': 'Jeu', 'orders': 20, 'revenue': 380.00},
            {'day': 'Ven', 'orders': 32, 'revenue': 608.00},
            {'day': 'Sam', 'orders': 28, 'revenue': 532.00},
            {'day': 'Dim', 'orders': 11, 'revenue': 209.00},
          ],
          'status_distribution': [
            {'status': 'Livrée', 'count': 98, 'percentage': 62.8},
            {'status': 'En attente', 'count': 23, 'percentage': 14.7},
            {'status': 'Confirmée', 'count': 15, 'percentage': 9.6},
            {'status': 'En préparation', 'count': 12, 'percentage': 7.7},
            {'status': 'Prête', 'count': 5, 'percentage': 3.2},
            {'status': 'Annulée', 'count': 3, 'percentage': 2.0},
          ],
        };
        break;

      case 'Ce mois':
        data = {
          'total_orders': 589,
          'total_revenue': 11250.00,
          'average_basket': 19.10,
          'new_clients': 89,
          'orders_growth': '+23%',
          'revenue_growth': '+28%',
          'top_products': [
            {'name': 'Croissant', 'quantity': 1245, 'revenue': 1867.50},
            {'name': 'Pain au chocolat', 'quantity': 1098, 'revenue': 1647.00},
            {'name': 'Macaron', 'quantity': 892, 'revenue': 1605.60},
            {'name': 'Tarte aux fraises', 'quantity': 456, 'revenue': 2052.00},
            {'name': 'Éclair au chocolat', 'quantity': 387, 'revenue': 1238.40},
          ],
          'chart_data': [
            {'week': 'S1', 'orders': 120, 'revenue': 2280.00},
            {'week': 'S2', 'orders': 145, 'revenue': 2755.00},
            {'week': 'S3', 'orders': 158, 'revenue': 3002.00},
            {'week': 'S4', 'orders': 166, 'revenue': 3213.00},
          ],
          'status_distribution': [
            {'status': 'Livrée', 'count': 412, 'percentage': 70},
            {'status': 'En attente', 'count': 67, 'percentage': 11.4},
            {'status': 'Confirmée', 'count': 45, 'percentage': 7.6},
            {'status': 'En préparation', 'count': 38, 'percentage': 6.5},
            {'status': 'Prête', 'count': 15, 'percentage': 2.5},
            {'status': 'Annulée', 'count': 12, 'percentage': 2.0},
          ],
        };
        break;

      default:
        data = {
          'total_orders': 2450,
          'total_revenue': 48500.00,
          'average_basket': 19.80,
          'new_clients': 356,
          'orders_growth': '+45%',
          'revenue_growth': '+52%',
          'top_products': [
            {'name': 'Croissant', 'quantity': 5200, 'revenue': 7800.00},
            {'name': 'Pain au chocolat', 'quantity': 4800, 'revenue': 7200.00},
            {'name': 'Macaron', 'quantity': 3500, 'revenue': 6300.00},
            {'name': 'Tarte aux fraises', 'quantity': 1800, 'revenue': 8100.00},
            {'name': 'Éclair au chocolat', 'quantity': 1500, 'revenue': 4800.00},
          ],
          'chart_data': [
            {'month': 'Jan', 'orders': 180, 'revenue': 3420.00},
            {'month': 'Fév', 'orders': 195, 'revenue': 3705.00},
            {'month': 'Mar', 'orders': 210, 'revenue': 3990.00},
            {'month': 'Avr', 'orders': 225, 'revenue': 4275.00},
            {'month': 'Mai', 'orders': 240, 'revenue': 4560.00},
            {'month': 'Juin', 'orders': 260, 'revenue': 4940.00},
          ],
          'status_distribution': [
            {'status': 'Livrée', 'count': 1715, 'percentage': 70},
            {'status': 'Confirmée', 'count': 245, 'percentage': 10},
            {'status': 'En préparation', 'count': 196, 'percentage': 8},
            {'status': 'En attente', 'count': 147, 'percentage': 6},
            {'status': 'Annulée', 'count': 147, 'percentage': 6},
          ],
        };
    }

    return data;
  }

  String get _periodSubtitle {
    final now = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy');
    switch (_selectedPeriod) {
      case 'Aujourd\'hui':
        return dateFormat.format(now);
      case 'Cette semaine':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return "${dateFormat.format(startOfWeek)} - ${dateFormat.format(endOfWeek)}";
      case 'Ce mois':
        return DateFormat('MMMM yyyy', 'fr').format(now);
      case 'Cette année':
        return now.year.toString();
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2C2A),
        elevation: 0,
        title: const Text(
          "Statistiques",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _loadStatistics();
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF4A2C2A)),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sélecteur de période
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8DADA),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPeriod,
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4A2C2A)),
                      items: _periods.map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(
                            period,
                            style: const TextStyle(color: Color(0xFF4A2C2A)),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPeriod = value!;
                          _isLoading = true;
                          _loadStatistics();
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8DADA),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    _periodSubtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4A2C2A),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Cartes KPI
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildKPICard(
                  title: "Commandes",
                  value: _statistics['total_orders'].toString(),
                  icon: Icons.shopping_bag,
                  color: const Color(0xFF4A2C2A),
                  growth: _statistics['orders_growth'],
                ),
                _buildKPICard(
                  title: "Chiffre d'affaires",
                  value: "${(_statistics['total_revenue'] as double).toStringAsFixed(2)} €",
                  icon: Icons.euro,
                  color: const Color(0xFF6B3A2A),
                  growth: _statistics['revenue_growth'],
                ),
                _buildKPICard(
                  title: "Panier moyen",
                  value: "${(_statistics['average_basket'] as double).toStringAsFixed(2)} €",
                  icon: Icons.shopping_cart,
                  color: const Color(0xFF8B5A3A),
                ),
                _buildKPICard(
                  title: "Nouveaux clients",
                  value: _statistics['new_clients'].toString(),
                  icon: Icons.people,
                  color: const Color(0xFFA0826B),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Graphique des ventes
            const Text(
              "Évolution des ventes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C2A),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8DADA),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: _buildBarChart(),
                  ),
                  const SizedBox(height: 12),
                  _buildChartLabels(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Top produits
            const Text(
              "Produits les plus vendus",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C2A),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8DADA),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (_statistics['top_products'] as List).length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final product = _statistics['top_products'][index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A2C2A).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A2C2A),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${product['quantity']} vendus",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${(product['revenue'] as double).toStringAsFixed(2)} €",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF4A2C2A),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Distribution des statuts
            const Text(
              "Statut des commandes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C2A),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8DADA),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 160,
                    child: _buildDonutChart(),
                  ),
                  const SizedBox(height: 16),
                  ...(_statistics['status_distribution'] as List).map((status) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getStatusColor(status['status']),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              status['status'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            "${status['count']} (${status['percentage'].toStringAsFixed(1)}%)",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? growth,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 28, color: color),
              if (growth != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: growth.contains('+') ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        growth.contains('+') ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 10,
                        color: growth.contains('+') ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        growth,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: growth.contains('+') ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final chartData = _statistics['chart_data'] as List;
    final maxOrders = (chartData.map((d) {
      if (_selectedPeriod == 'Aujourd\'hui') return d['orders'] as int;
      return d['orders'] as int;
    }).reduce((a, b) => a > b ? a : b)).toDouble();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: chartData.map((item) {
        final orders = _selectedPeriod == 'Aujourd\'hui'
            ? item['orders'] as int
            : item['orders'] as int;
        final height = (orders / maxOrders) * 150;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              orders.toString(),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              width: _selectedPeriod == 'Aujourd\'hui' ? 25 : 35,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFF4A2C2A),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildChartLabels() {
    final chartData = _statistics['chart_data'] as List;
    final labelKey = _selectedPeriod == 'Aujourd\'hui' ? 'hour' :
    (_selectedPeriod == 'Cette semaine' ? 'day' :
    (_selectedPeriod == 'Ce mois' ? 'week' : 'month'));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: chartData.map((item) {
        return Text(
          item[labelKey],
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDonutChart() {
    final statuses = _statistics['status_distribution'] as List;
    double startAngle = -90;
    final List<Map<String, dynamic>> slices = [];

    for (var status in statuses) {
      final angle = (status['percentage'] as double) * 3.6;
      slices.add({
        'color': _getStatusColor(status['status']),
        'angle': angle,
        'startAngle': startAngle,
      });
      startAngle += angle;
    }

    return Center(
      child: CustomPaint(
        size: const Size(160, 160),
        painter: DonutChartPainter(slices: slices),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Livrée':
        return Colors.green;
      case 'En attente':
        return Colors.orange;
      case 'Confirmée':
        return Colors.blue;
      case 'En préparation':
        return Colors.purple;
      case 'Prête':
        return Colors.teal;
      case 'Annulée':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Painter pour le donut chart
class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> slices;

  DonutChartPainter({required this.slices});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 35
      ..strokeCap = StrokeCap.round;

    for (var slice in slices) {
      paint.color = slice['color'];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 15),
        slice['startAngle'] * 3.14159 / 180,
        slice['angle'] * 3.14159 / 180,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}