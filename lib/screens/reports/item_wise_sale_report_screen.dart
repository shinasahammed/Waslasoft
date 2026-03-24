import 'package:flutter/material.dart';

import 'package:waslasoft/widgets/select_product_dialog.dart';

class ItemWiseSaleReportScreen extends StatefulWidget {
  const ItemWiseSaleReportScreen({super.key});

  @override
  State<ItemWiseSaleReportScreen> createState() =>
      _ItemWiseSaleReportScreenState();
}

class _ItemWiseSaleReportScreenState extends State<ItemWiseSaleReportScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedParty = "SELECT PRODUCT";
  DateTime _fromDate = DateTime(2026, 3, 13);
  DateTime _toDate = DateTime(2026, 3, 13);
  final List<Map<String, dynamic>> _stockItems = [
    {"product": "TWITTER", "stock": "23.00", "price": "0", "s_price": "55.00"},
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
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? _fromDate : _toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1F3A5F),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1F3A5F),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: ValueListenableBuilder<double>(
          valueListenable: _appBarOpacityNotifier,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: AppBar(
                backgroundColor: const Color(0xFF1F3A5F),
                elevation: 4 * opacity,
                toolbarHeight: 120,
                leadingWidth: 350,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24 * opacity),
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
                              "Item Wise Sale",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await showDialog<String>(
                                context: context,
                                builder: (context) =>
                                    const SelectProductDialog(),
                              );
                              if (result != null) {
                                setState(() {
                                  _selectedParty = result;
                                });
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 140, // Increased for readability
                              margin: const EdgeInsets.only(left: 45),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _selectedParty,
                                  style: const TextStyle(
                                    color: Color(0xFF1F3A5F),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.print,
                                color: Colors.blue[300],
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            const SizedBox(height: 170),
            _buildModernFilterCard(),
            const SizedBox(height: 24),

            // 3. Unified Activity Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 740,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildListHeader(),
                              const Divider(height: 1),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: _stockItems.length,
                                itemBuilder: (context, index) {
                                  final item = _stockItems[index];
                                  return _buildActivityCard(
                                    index: (index + 1).toString(),
                                    productName: item['product'],
                                    stock: item['stock'],
                                    price: item['price'],
                                    sPrice: item['s_price'],
                                    isLast: index == _stockItems.length - 1,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomSummaryBar(),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(color: Color(0xFF1F3A5F)),
      child: Row(
        children: [
          const SizedBox(width: 20),
          _tableCell(
            width: 80,
            content: Text("Bill No", style: _headerStyle()),
          ),
          _tableCell(width: 100, content: Text("Date", style: _headerStyle())),
          _tableCell(
            width: 220,
            content: Text("Item Name", style: _headerStyle()),
          ),
          _tableCell(
            width: 80,
            content: Text(
              "Qty",
              textAlign: TextAlign.center,
              style: _headerStyle(),
            ),
          ),
          _tableCell(
            width: 100,
            content: Text(
              "Rate",
              textAlign: TextAlign.right,
              style: _headerStyle(),
            ),
          ),
          _tableCell(
            width: 120,
            content: Text(
              "Total",
              textAlign: TextAlign.right,
              style: _headerStyle(),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w900,
    fontSize: 14,
    letterSpacing: 1.2,
  );

  Widget _buildActivityCard({
    required String index,
    required String productName,
    required String stock,
    required String price,
    required String sPrice,
    bool isLast = false,
  }) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                const SizedBox(width: 20),
                _tableCell(
                  width: 80,
                  content: Text(
                    index,
                    style: TextStyle(
                      color: Colors.blueGrey.withValues(alpha: 0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                _tableCell(
                  width: 100,
                  content: Text(
                    "13-3-2026", // Placeholder
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 14,
                    ),
                  ),
                ),
                _tableCell(
                  width: 220,
                  content: Text(
                    productName,
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _tableCell(
                  width: 80,
                  content: Text(
                    stock,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
                _tableCell(
                  width: 100,
                  content: Text(
                    price,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
                _tableCell(
                  width: 120,
                  content: Text(
                    sPrice,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              color: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
      ],
    );
  }

  Widget _tableCell({required double width, required Widget content}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: content,
    );
  }

  Widget _buildModernFilterCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildRefinedDatePicker("FROM", _fromDate, true)),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.withValues(alpha: 0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(child: _buildRefinedDatePicker("TO", _toDate, false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefinedDatePicker(String label, DateTime date, bool isFrom) {
    return InkWell(
      onTap: () => _selectDate(context, isFrom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.blueGrey.withValues(alpha: 0.6),
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: Colors.blue[400],
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "${date.day} ${_getMonth(date.month)}",
                style: const TextStyle(
                  color: Color(0xFF1F3A5F),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonth(int m) => [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ][m - 1];

  Widget _buildBottomSummaryBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1F3A5F),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem("TOTAL QTY", "23.00"),
          _buildSummaryItem("TOTAL Rate", "0.00"),
          _buildSummaryItem("TOTAL AMOUNT", "1,250.00"),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.orange[300],
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
