import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaxSummaryReportScreen extends StatefulWidget {
  const TaxSummaryReportScreen({super.key});

  @override
  State<TaxSummaryReportScreen> createState() => _TaxSummaryReportScreenState();
}

class _TaxSummaryReportScreenState extends State<TaxSummaryReportScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(1.0);
  final ScrollController _scrollController = ScrollController();
  
  DateTime _fromDate = DateTime(2026, 3, 16);
  DateTime _toDate = DateTime(2026, 3, 16);

  final List<Map<String, dynamic>> _taxItems = [
    {
      "sno": "1",
      "party": "SALES DETAILS",
      "taxNo": "GSTIN12345",
      "nonTaxTotal": "10000.00",
      "taxAmt": "500.00",
      "netTotal": "10500.00",
      "typ": "B2B"
    },
    {
      "sno": "2",
      "party": "PURCHASE DETAILS",
      "taxNo": "GSTIN67890",
      "nonTaxTotal": "5000.00",
      "taxAmt": "250.00",
      "netTotal": "5250.00",
      "typ": "B2B"
    },
    {
      "sno": "3",
      "party": "PRT DETAILS",
      "taxNo": "---",
      "nonTaxTotal": "1200.00",
      "taxAmt": "60.00",
      "netTotal": "1260.00",
      "typ": "PRT"
    },
    {
      "sno": "4",
      "party": "SALES RETURN DETAILS",
      "taxNo": "GSTIN12345",
      "nonTaxTotal": "800.00",
      "taxAmt": "40.00",
      "netTotal": "840.00",
      "typ": "B2C"
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
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
      backgroundColor: const Color(0xFFF8FAFC),
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
                elevation: 4 * opacity,
                toolbarHeight: 80,
                leadingWidth: 350,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24 * opacity),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const BackButton(color: Colors.white),
                      Container(
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
                      const SizedBox(width: 15),
                      const Text(
                        "Tax Summary",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.solidFileExcel,
                          color: Colors.white,
                          size: 22,
                        ),
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
        child: Column(
          children: [
            const SizedBox(height: 110),
            _buildModernFilterCard(),
            const SizedBox(height: 24),
            _buildReportTable(),
            const SizedBox(height: 100),
          ],
        ),
      ),
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
                "${date.day} ${_getMonth(date.month)} ${date.year}",
                style: const TextStyle(
                  color: Color(0xFF1F3A5F),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonth(int m) => [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ][m - 1];

  Widget _buildReportTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
              width: 750,
              child: Column(
                children: [
                  _buildTableHeader(),
                  const Divider(height: 1),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: _taxItems.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _taxItems[index];
                      return _buildTableRow(
                        sno: item['sno'],
                        party: item['party'],
                        taxNo: item['taxNo'],
                        nonTaxTotal: item['nonTaxTotal'],
                        taxAmt: item['taxAmt'],
                        netTotal: item['netTotal'],
                        typ: item['typ'],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(color: Color(0xFF1F3A5F)),
      child: Row(
        children: [
          const SizedBox(width: 20),
          _tableCell(width: 50, content: Text("#", style: _headerStyle())),
          _tableCell(width: 150, content: Text("Party", style: _headerStyle())),
          _tableCell(width: 100, content: Text("taxNo", style: _headerStyle())),
          _tableCell(width: 120, content: Center(child: Text("TotalnonTax", style: _headerStyle()))),
          _tableCell(width: 100, content: Text("TaxAmt", style: _headerStyle(), textAlign: TextAlign.right)),
          _tableCell(width: 110, content: Text("NetTotal", style: _headerStyle(), textAlign: TextAlign.right)),
          _tableCell(width: 80, content: Text("Typ", style: _headerStyle(), textAlign: TextAlign.center)),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildTableRow({
    required String sno,
    required String party,
    required String taxNo,
    required String nonTaxTotal,
    required String taxAmt,
    required String netTotal,
    required String typ,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const SizedBox(width: 20),
          _tableCell(width: 50, content: Text(sno, style: _rowStyle())),
          _tableCell(width: 150, content: Text(party, style: _rowStyle(), overflow: TextOverflow.ellipsis)),
          _tableCell(width: 100, content: Text(taxNo, style: _rowStyle())),
          _tableCell(width: 120, content: Center(child: Text(nonTaxTotal, style: _rowStyle()))),
          _tableCell(width: 100, content: Text(taxAmt, style: _rowStyle(color: Colors.red[600]!), textAlign: TextAlign.right)),
          _tableCell(width: 110, content: Text(netTotal, style: _rowStyle(color: Colors.teal), textAlign: TextAlign.right)),
          _tableCell(width: 80, content: Text(typ, style: _rowStyle(), textAlign: TextAlign.center)),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _tableCell({required double width, required Widget content}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: content,
    );
  }

  TextStyle _headerStyle() => const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );

  TextStyle _rowStyle({Color color = const Color(0xFF374151)}) => TextStyle(
    color: color,
    fontWeight: FontWeight.w600,
    fontSize: 13,
  );
}
