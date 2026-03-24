import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> reports = [
    {
      'name': 'Sales Report',
      'icon': Icons.trending_up,
      'color': Colors.blue,
      'route': '/salesReport',
    },
    {
      'name': 'Order Report',
      'icon': Icons.assignment,
      'color': Colors.green,
      'route': '/orderReport',
    },
    {
      'name': 'Receipt Report',
      'icon': Icons.receipt,
      'color': Colors.orange,
      'route': '/receiptReport',
    },
    {
      'name': 'Ledger Report',
      'icon': Icons.book,
      'color': Colors.purple,
      'route': '/ledgerReport',
    },
    {
      'name': 'Outstanding Balance Report',
      'icon': Icons.account_balance_wallet,
      'color': Colors.red,
      'route': '/outstandingBalanceReport',
    },
    {
      'name': 'Stock Report',
      'icon': Icons.inventory,
      'color': Colors.teal,
      'route': '/stockReport',
    },
    {
      'name': 'Auditing Report',
      'icon': Icons.gavel,
      'color': Colors.blueGrey,
      'route': '/auditingReport',
    },
    {
      'name': 'Intrans Report',
      'icon': Icons.moving,
      'color': Colors.indigo,
      'route': '/intransReport',
    },
    {
      'name': 'Payment Report',
      'icon': Icons.payments,
      'color': Colors.cyan,
      'route': '/paymentReport',
    },
    {
      'name': 'Expense Report',
      'icon': Icons.money_off,
      'color': Colors.amber,
      'route': '/expenseReport',
    },
    {
      'name': 'Tax Summary',
      'icon': Icons.description,
      'color': Colors.brown,
      'route': '/taxSummary',
    },
    {
      'name': 'PNL Report',
      'icon': Icons.calculate,
      'color': Colors.deepOrange,
      'route': '/pnlReport',
    },
    {
      'name': 'Intrans Ledger',
      'icon': Icons.list_alt,
      'color': Colors.deepPurple,
      'route': '/intransLedger',
    },
    {
      'name': 'Purchase Report',
      'icon': Icons.shopping_cart,
      'color': Colors.lightBlue,
      'route': '/purchaseReport',
    },
    {
      'name': 'SalesReturn Report',
      'icon': Icons.keyboard_return,
      'color': Colors.pink,
      'route': '/salesReturnReport',
    },
    {
      'name': 'Outlet Wise SalesReport',
      'icon': Icons.store,
      'color': Colors.lime,
      // 'route': '/outletWiseSalesReport',
    },
    {
      'name': 'Market Survey Report',
      'icon': Icons.poll,
      'color': Colors.blueAccent,
      'route': '/marketSurveyReport',
    },
    {
      'name': 'Item Wise Sale Report',
      'icon': Icons.category,
      'color': Colors.indigoAccent,
      'route': '/itemWiseSaleReport',
    },
    {
      'name': 'Holding Report',
      'icon': Icons.pause_circle_filled,
      'color': Colors.orangeAccent,
      'route': '/holdingReport',
    },
    {
      'name': 'Purchase Return Report',
      'icon': Icons.assignment_return,
      'color': Colors.redAccent,
      'route': '/purchaseReturnReport',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    // AppBar Opacity - Matching the premium sharp fade (divisor 60)
    final newOpacity = (1.0 - (offset / 60)).clamp(0.0, 1.0);
    if (_appBarOpacityNotifier.value != newOpacity) {
      _appBarOpacityNotifier.value = newOpacity;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _appBarOpacityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // Modern off-white
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ValueListenableBuilder<double>(
          valueListenable: _appBarOpacityNotifier,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: AppBar(
                backgroundColor: const Color(0xFF1F3A5F),
                elevation: 5 * opacity,
                toolbarHeight: 80,
                leadingWidth: 300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20 * opacity),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BackButton(color: Colors.white),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Image.asset(
                                "assets/images/logo.jpeg",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              "Reports",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const SizedBox(height: 110),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: _buildReportGrid(reports),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildReportGrid(List<Map<String, dynamic>> reportList) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: reportList.length,
      itemBuilder: (context, index) {
        final report = reportList[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return InkWell(
      onTap: () {
        if (report['route'] != null) {
          Navigator.pushNamed(context, report['route']);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: report['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(report['icon'], color: report['color'], size: 28),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                report['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
