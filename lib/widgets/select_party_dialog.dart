import 'package:flutter/material.dart';

class SelectPartyDialog extends StatefulWidget {
  const SelectPartyDialog({super.key});

  @override
  State<SelectPartyDialog> createState() => _SelectPartyDialogState();
}

class _SelectPartyDialogState extends State<SelectPartyDialog> {
  final TextEditingController _searchController = TextEditingController();
  final Color _primaryBlue = const Color(0xFF1F3A5F);

  // Mock list of parties
  final List<String> _allParties = [
    "ASWIN",
    "ASWINPP",
    "FHFHGG",
    "RAHIM",
    "TABUK COMPANY FOR INVESTMENT WALSYYYAH",
    "GLOBAL TRADING CO",
    "SURESH BHARAT",
    "TECH SOLUTIONS LTD",
    "WASLA SOFTWARES",
  ];

  List<String> _filteredParties = [];

  @override
  void initState() {
    super.initState();
    _filteredParties = _allParties;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _filteredParties = _allParties
          .where(
            (party) => party.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Party",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: _primaryBlue,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Choose a customer to proceed",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryBlue, _primaryBlue.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/addparty');
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.add, color: Colors.white, size: 24),
                    ),
                  ),
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
                hintText: "Find party by name...",
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

          // Party List
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _filteredParties.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _filteredParties.length,
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                                          _getInitials(party),
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
                                            party,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.2,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Credit Customer",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[400],
                                              fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_search_rounded,
              size: 64,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 16),
            Text(
              "No Party Found",
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
    );
  }
}
