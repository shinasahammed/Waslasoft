import 'package:flutter/material.dart';
import 'package:waslasoft/models/purchase_data_model.dart';
import 'package:waslasoft/models/expense_data_model.dart';
import 'package:waslasoft/services/app_config.dart';
import 'printoption_screen.dart';
import '../services/session_service.dart';

class OrderSummaryScreen extends StatefulWidget {
  final List<PurchaseItem> items;
  final Map<int, int> initialQuantities;
  final Map<int, bool> initialUnits;
  final Expensedatamodel? selectedParty;

  const OrderSummaryScreen({
    super.key,
    required this.items,
    required this.initialQuantities,
    required this.initialUnits,
    this.selectedParty,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late Map<int, int> _cartQuantities;
  late Map<int, bool> _cartUnits;

  @override
  void initState() {
    super.initState();
    _cartQuantities = Map.from(widget.initialQuantities);
    _cartUnits = Map.from(widget.initialUnits);
  }

  double get _totalAmount {
    double total = 0;
    _cartQuantities.forEach((itemId, qty) {
      try {
        final item = widget.items.firstWhere(
          (element) => (element.itemId ?? element.id) == itemId,
        );
        total += (double.tryParse(item.price ?? '0') ?? 0) * qty;
      } catch (e) {}
    });
    return total;
  }

  double get _totalVat {
    if (!AppConfig.isTaxEnabled) return 0.0;
    double total = 0;
    _cartQuantities.forEach((itemId, qty) {
      try {
        final item = widget.items.firstWhere(
          (element) => (element.itemId ?? element.id) == itemId,
        );
        total += (double.tryParse(item.taxAmount ?? '0') ?? 0) * qty;
      } catch (e) {}
    });
    return total;
  }

  int get _totalItems =>
      _cartQuantities.values.fold(0, (sum, qty) => sum + qty);

  void _updateQuantity(PurchaseItem item, int newQuantity) {
    final id = item.itemId ?? item.id;
    if (id == null) return;
    setState(() {
      if (newQuantity <= 0) {
        _cartQuantities.remove(id);
        _cartUnits.remove(id);
      } else {
        _cartQuantities[id] = newQuantity;
      }
    });
  }

  void _updateUnit(PurchaseItem item, bool isPcs) {
    final id = item.itemId ?? item.id;
    if (id == null) return;
    setState(() {
      _cartUnits[id] = isPcs;
    });
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
                "Purchase Successful",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F3A5F),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Do you want to print a bill for this transaction?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Store transaction details for automatic pre-filling in the Payment screen
                        SessionService.setPendingPayment(
                          widget.selectedParty,
                          _totalAmount + _totalVat,
                        );

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Purchase confirmed"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xFF1F3A5F),
                          ),
                        );
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
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
                      onPressed: () {
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
                        final orderDate =
                            "${now.day} ${months[now.month - 1]} ${now.year}";
                        final orderId =
                            "#WSL-PUR-${now.millisecondsSinceEpoch % 10000}";

                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrintOptionScreen(
                              orderId: orderId,
                              orderDate: orderDate,
                              totalAmount: grandTotal,
                              selectedParty: widget.selectedParty,
                            ),
                          ),
                        );
                      },
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
          "Order Summary",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F3A5F),
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context, {
            'quantities': _cartQuantities,
            'units': _cartUnits,
          }),
        ),
      ),
      body: Column(
        children: [
          // Vendor Info Section
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
                      widget.selectedParty?.name?[0].toUpperCase() ?? "?",
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
                        widget.selectedParty?.name ?? "No Vendor Selected",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.selectedParty?.openBalance != null
                            ? "Balance: ₹${widget.selectedParty!.openBalance}"
                            : "New Transaction",
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
                          "Your cart is empty",
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
                      final isPcs = _cartUnits[itemId] ?? true;
                      final item = widget.items.firstWhere(
                        (e) => (e.itemId ?? e.id) == itemId,
                      );
                      final price = double.tryParse(item.price ?? '0') ?? 0;

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
                                    "₹${price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Unit Toggle Button
                            GestureDetector(
                              onTap: () => _updateUnit(item, !isPcs),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F4F8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      isPcs ? "PCS" : "KG",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F3A5F),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.swap_horiz,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
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
                    "CONFIRM PURCHASE",
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
