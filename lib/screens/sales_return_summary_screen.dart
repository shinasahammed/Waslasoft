import 'package:flutter/material.dart';
import 'package:waslasoft/models/sales_return_model.dart';
import 'package:waslasoft/models/expense_data_model.dart';
import 'package:waslasoft/services/app_config.dart';
import 'package:waslasoft/models/sales_data_model.dart' as sales_model;
import 'printoption_screen.dart';
import '../storage/transaction_storage.dart';

class SalesReturnSummaryScreen extends StatefulWidget {
  final List<SalesReturnItem> items;
  final Map<int, int> initialQuantities;
  final Expensedatamodel? selectedParty;

  const SalesReturnSummaryScreen({
    super.key,
    required this.items,
    required this.initialQuantities,
    required this.selectedParty,
  });

  @override
  State<SalesReturnSummaryScreen> createState() =>
      _SalesReturnSummaryScreenState();
}

class _SalesReturnSummaryScreenState extends State<SalesReturnSummaryScreen> {
  late Map<int, int> _cartQuantities;

  @override
  void initState() {
    super.initState();
    _cartQuantities = Map.from(widget.initialQuantities);
  }

  double get _totalAmount {
    double total = 0;
    _cartQuantities.forEach((itemId, qty) {
      try {
        final item = widget.items.firstWhere((element) => element.id == itemId);
        total += (double.tryParse(item.returnAmount ?? '0') ?? 0) * qty;
      } catch (e) {
        debugPrint("Item not found: $itemId");
      }
    });
    return total;
  }

  double get _totalVat {
    if (!AppConfig.isTaxEnabled) return 0.0;
    double total = 0;
    _cartQuantities.forEach((itemId, qty) {
      // Assuming 0 tax for returns as per sales_return_screen logic
      total += 0 * qty;
    });
    return total;
  }

  int get _totalItems =>
      _cartQuantities.values.fold(0, (sum, qty) => sum + qty);

  void _updateQuantity(SalesReturnItem item, int newQuantity) {
    final id = item.id;
    if (id == null) return;
    setState(() {
      if (newQuantity <= 0) {
        _cartQuantities.remove(id);
      } else {
        _cartQuantities[id] = newQuantity;
      }
    });
  }

  Future<void> _saveTransaction(bool print) async {
    final grandTotal = _totalAmount + _totalVat;
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final orderDate = "${now.day} ${months[now.month - 1]} ${now.year}";
    final orderIdStr = "#WSL-SRET-${now.millisecondsSinceEpoch % 10000}";

    final transaction = sales_model.Datum(
      orderNo: orderIdStr,
      saleDate: now,
      grandTotal: grandTotal.toStringAsFixed(2),
      invoiceAmount: _totalAmount.toStringAsFixed(2),
      name: widget.selectedParty?.name ?? "Cash Customer",
      // Mapping return items to sale items for storage consistency
      saleItems: widget.items
          .map(
            (e) => sales_model.SaleItem(
              id: e.id,
              product: e.product,
              price: e.returnAmount,
              qty: _cartQuantities[e.id]?.toString(),
            ),
          )
          .toList(),
    );

    await TransactionStorage.saveSalesReturnTransaction(transaction);

    Navigator.pop(context);

    if (print) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrintOptionScreen(
            orderId: orderIdStr,
            orderDate: orderDate,
            totalAmount: grandTotal,
            selectedParty: widget.selectedParty,
            hidePaymentOption: true,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Return saved successfully"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF1F3A5F),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _showPrintConfirmation() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB74D).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.print_rounded,
                  color: Color(0xFFFFB74D),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Return Processed",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F3A5F),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Do you want to print a return receipt?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _saveTransaction(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("No"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _saveTransaction(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB74D),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Yes, Print",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = _cartQuantities.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Sales Return Summary",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F3A5F),
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () =>
              Navigator.pop(context, {'quantities': _cartQuantities}),
        ),
      ),
      body: Column(
        children: [
          // Customer Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1F3A5F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.selectedParty != null &&
                              widget.selectedParty!.name != null &&
                              widget.selectedParty!.name!.isNotEmpty
                          ? widget.selectedParty!.name![0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selectedParty?.name ?? "No Customer Selected",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.selectedParty?.openBalance != null
                            ? "Balance: ₹${widget.selectedParty!.openBalance}"
                            : "B2B Customer Sale Return",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Your return cart is empty",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final itemId = cartItems[index];
                      final qty = _cartQuantities[itemId]!;
                      final item = widget.items.firstWhere(
                        (e) => e.id == itemId,
                      );
                      final price =
                          double.tryParse(item.returnAmount ?? '0') ?? 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product ?? "Unknown Product",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "₹${price.toStringAsFixed(2)} per item",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            // Quantity Controls
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _updateQuantity(item, qty - 1),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      size: 16,
                                      color: Color(0xFF1F3A5F),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "$qty",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => _updateQuantity(item, qty + 1),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1F3A5F),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Detailed Bill Footer
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subtotal",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      "₹${_totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (AppConfig.isTaxEnabled) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "VAT",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      Text(
                        "₹${_totalVat.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Items",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      "$_totalItems",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Grand Total",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "₹${(_totalAmount + _totalVat).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFF1F3A5F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: (_totalItems > 0 && widget.selectedParty != null)
                      ? _showPrintConfirmation
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB74D),
                    foregroundColor: Colors.black87,
                    minimumSize: const Size(double.infinity, 56),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "SAVE & PRINT",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
