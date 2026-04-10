import 'package:flutter/material.dart';
import 'package:waslasoft/models/expense_data_model.dart';
import 'package:waslasoft/services/supplier_data_service.dart';

class SelectpurchasePartyDialog extends StatefulWidget {
  final Future<List<Expensedatamodel>> Function()? onRefresh;
  final String title;
  final String subTitle;

  const SelectpurchasePartyDialog({
    super.key,
    this.onRefresh,
    this.title = "Select Purchase Account",
    this.subTitle = "Choose an account for this purchase",
  });

  @override
  State<SelectpurchasePartyDialog> createState() =>
      _SelectpurchasePartyDialogState();
}

class _SelectpurchasePartyDialogState extends State<SelectpurchasePartyDialog> {
  final TextEditingController _searchController = TextEditingController();
  final Color _primaryBlue = const Color(0xFF1F3A5F);
  final SupplierDataService _service = SupplierDataService();

  bool _isLoading = false;
  List<Expensedatamodel> _allParties = [];
  List<Expensedatamodel> _filteredParties = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadData();
  }

  Future<void> _showAddAccountDialog() async {
    final nameController = TextEditingController();
    final balanceController = TextEditingController(text: "0.00");
    bool isSaving = false;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Add Account",
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.add_business_rounded,
                            color: _primaryBlue),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "New Account",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Account Name",
                          prefixIcon: const Icon(Icons.person_outline),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: balanceController,
                        decoration: InputDecoration(
                          labelText: "Opening Balance",
                          prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                    ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              if (nameController.text.trim().isEmpty) return;
                              setDialogState(() => isSaving = true);
                              try {
                                  final success = await SupplierDataService()
                                      .createSupplier(
                                    name: nameController.text.trim(),
                                    openingBalance: balanceController.text.trim(),
                                  );
                                if (success != null && context.mounted) {
                                  Navigator.pop(context, success);
                                  await _loadData(); // Refresh list
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          "Account created successfully!",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green[600],
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                }
                              } finally {
                                if (context.mounted) {
                                  setDialogState(() => isSaving = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text("Create Account"),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadData() async {
    // Only show the main loader if we don't have any data yet
    if (_allParties.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final data = await _service.fetchData();
      
      setState(() {
        _allParties = data;
        _filteredParties = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error if needed
    }
  }

  void _onSearchChanged() {
    setState(() {
      _filteredParties = _allParties
          .where(
            (party) => (party.name ?? "")
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    List<String> words = name.split(" ");
    if (words.length >= 2) {
      return (words[0][0] + words[1][0]).toUpperCase();
    } else if (words.isNotEmpty && words[0].length >= 2) {
      return words[0].substring(0, 2).toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return "?";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      elevation: 20,
      backgroundColor: Colors.white,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: _primaryBlue,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subTitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // No add button for expense accounts unless requested
              IconButton(
                onPressed: _showAddAccountDialog,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: _primaryBlue, size: 24),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Modern Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              decoration: InputDecoration(
                hintText: "Find purchase account...",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: _primaryBlue.withValues(alpha: 0.5),
                  size: 24,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Account List
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        color: _primaryBlue,
                        strokeWidth: 2.5,
                        onRefresh: _loadData,
                        child: _filteredParties.isEmpty
                            ? _buildEmptyState()
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: _filteredParties.length,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  indent: 72,
                                  color: Colors.grey[100],
                                ),
                                itemBuilder: (context, index) {
                                  final party = _filteredParties[index];
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop(party);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: _primaryBlue.withValues(
                                                  alpha: 0.08,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  _getInitials(
                                                      party.name ?? "?"),
                                                  style: TextStyle(
                                                    color: _primaryBlue,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    party.name ?? "Unknown",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[800],
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: -0.2,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    "Bal: ₹${party.openBalance ?? "0.00"}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: _primaryBlue
                                                          .withValues(
                                                              alpha: 0.6),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              color: Colors.grey[300],
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(40),
        height: 300, // Fixed height to allow scrolling
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_rounded,
                  size: 64, color: Colors.grey[200]),
              const SizedBox(height: 16),
              Text(
                "No Account Found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Try searching with a different name",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
