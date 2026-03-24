import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPartyScreen extends StatefulWidget {
  const AddPartyScreen({super.key});

  @override
  State<AddPartyScreen> createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _nationalAddressController =
      TextEditingController();
  final TextEditingController _stateCodeController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  String _selectedPartyType = "CUSTOMER";
  final List<String> _partyTypes = ["CUSTOMER", "PURCHASE PARTY", "EXPENSE"];

  final Color _primaryBlue = const Color(0xFF1F3A5F);
  final Color _bgSubtle = const Color(0xFFF8FAFC);
  final Color _fieldBg = Colors.white;

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
      backgroundColor: _bgSubtle,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ValueListenableBuilder<double>(
          valueListenable: _appBarOpacityNotifier,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: AppBar(
                backgroundColor: const Color(0xFF1F3A5F),
                elevation: 5 * opacity,
                toolbarHeight: 70,
                leadingWidth: 311,
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
                              "List Party",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.mapLocationDot,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),
                            ],
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 110),
              _buildSectionHeader("BASIC INFORMATION"),
              _buildModernField(
                label: "Party Name",
                controller: _nameController,
                hint: "Enter party/client name",
                icon: Icons.person_outline,
              ),
              _buildModernField(
                label: "Code/Number",
                controller: _codeController,
                hint: "Internal reference code",
                icon: Icons.tag,
              ),
              _buildDropdownField(),

              const SizedBox(height: 32),
              _buildSectionHeader("CONTACT & ADDRESS"),
              _buildModernField(
                label: "Phone Number",
                controller: _phoneController,
                hint: "+91 0000 000000",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              _buildModernField(
                label: "Address Line 1",
                controller: _address1Controller,
                hint: "Street address, area",
                icon: Icons.location_on_outlined,
              ),
              _buildModernField(
                label: "Address Line 2",
                controller: _address2Controller,
                hint: "Building, landmark",
                icon: Icons.map_outlined,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildModernField(
                      label: "State and Code",
                      controller: _stateCodeController,
                      hint: "e.g. Kerala (32)",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              _buildSectionHeader("TAX & FINANCIALS"),
              _buildModernField(
                label: "TAX / VAT Number",
                controller: _taxController,
                hint: "Enter tax registration number",
                icon: Icons.receipt_long_outlined,
              ),
              _buildModernField(
                label: "National Address",
                controller: _nationalAddressController,
                hint: "Official government address",
                icon: Icons.account_balance_outlined,
              ),
              _buildModernField(
                label: "Opening Balance",
                controller: _balanceController,
                hint: "0.00",
                icon: Icons.account_balance_wallet_outlined,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 48),
              _buildSaveButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: _primaryBlue.withValues(alpha: 0.6),
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildModernField({
    required String label,
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: _fieldBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14),
                prefixIcon: icon != null
                    ? Icon(icon, color: _primaryBlue, size: 20)
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: _fieldBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            value: _selectedPartyType,
            decoration: InputDecoration(
              labelText: "Party Type",
              labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.category_outlined,
                color: _primaryBlue,
                size: 20,
              ),
            ),
            items: _partyTypes.map((String type) {
              return DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPartyType = value!;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saving Party Details...')),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushNamed(context, "/listparty");
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB74D),
          foregroundColor: Colors.black,
          elevation: 4,
          shadowColor: const Color(0xFFFFB74D).withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "SAVE PARTY",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _codeController.dispose();
  //   _address1Controller.dispose();
  //   _address2Controller.dispose();
  //   _phoneController.dispose();
  //   _taxController.dispose();
  //   _nationalAddressController.dispose();
  //   _stateCodeController.dispose();
  //   _balanceController.dispose();
  //   super.dispose();
  // }
}
