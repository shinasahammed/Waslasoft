import 'package:flutter/material.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();

  // State for all 47+ features
  final Map<String, bool> _featureStates = {
    'WAREHOUSE WISE STOCK ENABLE': true,
    'USER WISE PARTY ENABLE': true,
    'ACTIVITY SALES ENABLE': true,
    'SALES RETURN EDIT': true,
    'ACTIVITY ORDER EDIT': true,
    'ACTIVITY RECEIPT EDIT': true,
    'ACTIVITY PAYMENT, EXPENSE EDIT': true,
    'ALL SERVER DB REPORTS': true,
    'WEB UPLOADED REPORTS': false,
    'UNIT IN INVOICE': true,
    'HIDE QR': false,
    'MASTER EDIT': false,
    'SHOW OLD BALANCE IN INVOICE': true,
    'MINUS STOCK ENABLE': true,
    'PRICE EDIT DISABLE': true,
    'ENABLE NEW SALESBILL': false,
    'LOCATION ENABLE': true,
    'COST ENABLE': true,
    'ITEM WISE DISCOUNT ENABLE': false,
    'SALES INVOICE SMS ON/OFF': true,
    'RECEIPT SMS ON/OFF': true,
    'IS DISCOUNT': true,
    'SHOW COST IN STOCK REPORT': true,
    'ENABLE SUB TAX': true,
    'ENABLE PAYMENT': false,
    'ENABLE EXPENSE': false,
    'ENABLE SALARY': true,
    'ACTIVITY PURCHASE EDIT': true,
    'CHECK COST IN SALES': true,
    'VIEW MULTI-UNITS': true,
    'ENABLE HOLD ITEMS': true,
    'ACTIVITY PURCHASE-RETURN EDIT': true,
    'GEOS ACCESS': false,
    'EMPLOYEE WISE SERVER REPORTS': true,
  };

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: ValueListenableBuilder<double>(
          valueListenable: _appBarOpacityNotifier,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: AppBar(
                backgroundColor: const Color(0xFF1F3A5F),
                elevation: 5 * opacity,
                toolbarHeight: 90,
                leadingWidth: 216,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20 * opacity),
                  ),
                ),
                leading: Row(
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
                      "Admin Panel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Text(
                        "ADMIN",
                        style: TextStyle(
                          color: Color(0xFFFFB74D),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
        child: Column(
          children: [
            const SizedBox(height: 105),

            _buildSectionHeader("ADMINISTRATIVE"),
            _buildActionCard([
              _buildListTile(
                Icons.app_registration,
                "APPLICATION ACTIVATED",
                () {},
              ),
              _buildDivider(),
              _buildListTile(Icons.business, "COMPANY REGISTRATION", () {}),
              _buildDivider(),
              _buildListTile(Icons.account_balance, "BANK DETAILS", () {}),
              _buildDivider(),
              _buildListTile(Icons.pin, "ADMIN CODE CHANGE", () {}),
              _buildDivider(),
              _buildListTile(Icons.menu_open, "MENU MANAGEMENT", () {}),
              _buildDivider(),
              _buildListTile(Icons.settings_suggest, "OTHER SETTINGS", () {}),
            ]),

            _buildSectionHeader("SALES & BILLING"),
            _buildActionCard([
              _buildSwitchTile("ENABLE NEW SALESBILL", Icons.add_shopping_cart),
              _buildDivider(),
              _buildSwitchTile("ACTIVITY SALES ENABLE", Icons.point_of_sale),
              _buildDivider(),
              _buildSwitchTile("SALES RETURN EDIT", Icons.assignment_return),
              _buildDivider(),
              _buildSwitchTile("ACTIVITY ORDER EDIT", Icons.edit_note),
              _buildDivider(),
              _buildSwitchTile("ACTIVITY RECEIPT EDIT", Icons.receipt),
              _buildDivider(),
              _buildSwitchTile(
                "ACTIVITY PAYMENT, EXPENSE EDIT",
                Icons.payments,
              ),
              _buildDivider(),
              _buildSwitchTile("ACTIVITY PURCHASE EDIT", Icons.shopping_basket),
              _buildDivider(),
              _buildSwitchTile(
                "ACTIVITY PURCHASE-RETURN EDIT",
                Icons.keyboard_return,
              ),
              _buildDivider(),
              _buildSwitchTile("SALES INVOICE SMS ON/OFF", Icons.sms),
              _buildDivider(),
              _buildSwitchTile("RECEIPT SMS ON/OFF", Icons.sms_failed),
            ]),

            _buildSectionHeader("STOCK & PRODUCTS"),
            _buildActionCard([
              _buildSwitchTile(
                "MINUS STOCK ENABLE",
                Icons.remove_circle_outline,
              ),
              _buildDivider(),
              _buildSwitchTile("WAREHOUSE WISE STOCK ENABLE", Icons.warehouse),
              _buildDivider(),
              _buildSwitchTile(
                "USER WISE PARTY ENABLE",
                Icons.person_pin_circle,
              ),
              _buildDivider(),
              _buildSwitchTile("PRICE EDIT DISABLE", Icons.price_change),
              _buildDivider(),
              _buildListTile(Icons.bar_chart, "PRICE CHART", () {}),
              _buildDivider(),
              _buildSwitchTile("ITEM WISE DISCOUNT ENABLE", Icons.discount),
              _buildDivider(),
              _buildSwitchTile("IS DISCOUNT", Icons.percent),
              _buildDivider(),
              _buildSwitchTile("CHECK COST IN SALES", Icons.monetization_on),
              _buildDivider(),
              _buildSwitchTile("SHOW COST IN STOCK REPORT", Icons.assessment),
              _buildDivider(),
              _buildSwitchTile("ENABLE SUB TAX", Icons.receipt_long),
              _buildDivider(),
              _buildSwitchTile("VIEW MULTI-UNITS", Icons.layers),
              _buildDivider(),
              _buildSwitchTile("ENABLE HOLD ITEMS", Icons.pause_circle_filled),
            ]),

            _buildSectionHeader("REPORTS & SERVER"),
            _buildActionCard([
              _buildSwitchTile("ALL SERVER DB REPORTS", Icons.storage),
              _buildDivider(),
              _buildSwitchTile("WEB UPLOADED REPORTS", Icons.cloud_done),
              _buildDivider(),
              _buildSwitchTile("UNIT IN INVOICE", Icons.description),
              _buildDivider(),
              _buildSwitchTile("HIDE QR", Icons.qr_code_scanner),
              _buildDivider(),
              _buildSwitchTile("MASTER EDIT", Icons.edit_attributes),
              _buildDivider(),
              _buildSwitchTile(
                "SHOW OLD BALANCE IN INVOICE",
                Icons.account_balance_wallet,
              ),
              _buildDivider(),
              _buildSwitchTile("GEOS ACCESS", Icons.map),
              _buildDivider(),
              _buildSwitchTile("EMPLOYEE WISE SERVER REPORTS", Icons.badge),
              _buildDivider(),
              _buildListTile(
                Icons.image_search,
                "UPLOAD IMAGE DATA SYNC",
                () {},
              ),
            ]),

            _buildSectionHeader("SYSTEM & DATABASE"),
            _buildActionCard([
              _buildListTile(Icons.file_download, "DATABASE IMPORT", () {}),
              _buildDivider(),
              _buildListTile(Icons.system_update, "DATABASE UPDATES", () {}),
              _buildDivider(),
              _buildSwitchTile("LOCATION ENABLE", Icons.location_on),
              _buildDivider(),
              _buildSwitchTile("COST ENABLE", Icons.attach_money),
              _buildDivider(),
              _buildListTile(
                Icons.currency_exchange,
                "CHANGE MONEY TYPE",
                () {},
              ),
              _buildDivider(),
              _buildSwitchTile("ENABLE PAYMENT", Icons.payment),
              _buildDivider(),
              _buildSwitchTile("ENABLE EXPENSE", Icons.money_off),
              _buildDivider(),
              _buildSwitchTile("ENABLE SALARY", Icons.person_add_alt_1),
              _buildDivider(),
              _buildListTile(Icons.delete_forever, "CLEAR DB", () {}),
            ]),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blueGrey[700],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildActionCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? const Color(0xFF1F3A5F)).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color ?? const Color(0xFF1F3A5F), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(String title, IconData icon, {Color? color}) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? const Color(0xFF1F3A5F)).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color ?? const Color(0xFF1F3A5F), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
      value: _featureStates[title] ?? false,
      activeColor: const Color(0xFF1F3A5F),
      onChanged: (v) => setState(() => _featureStates[title] = v),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 0.5, color: Colors.grey[200]);
  }
}
