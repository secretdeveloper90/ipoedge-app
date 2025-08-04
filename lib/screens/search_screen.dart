import 'package:flutter/material.dart';
import '../models/ipo_model.dart';
import '../services/ipo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ipo_card.dart';
import '../widgets/common_app_bar.dart';
import 'ipo_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final SearchType searchType;
  final String? initialHint;

  const SearchScreen({
    super.key,
    this.searchType = SearchType.all,
    this.initialHint,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final IPOService _ipoService = IPOService();
  final TextEditingController _searchController = TextEditingController();

  List<IPO> _searchResults = [];
  List<IPO> _allIPOs = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String _selectedStatus = 'all';
  String _selectedCategory = 'all';

  final List<String> _statusOptions = [
    'all',
    'upcoming',
    'current',
    'listed',
  ];

  final List<String> _categoryOptions = [
    'all',
    'mainboard',
    'sme',
  ];

  @override
  void initState() {
    super.initState();
    _loadAllIPOs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllIPOs() async {
    try {
      final ipos = await _ipoService.getAllIPOs();
      setState(() {
        _allIPOs = ipos;
      });
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      List<IPO> results;

      if (query.isEmpty) {
        results = List.from(_allIPOs);
      } else {
        results = await _ipoService.searchIPOs(query);
      }

      // Apply filters
      if (_selectedStatus != 'all') {
        results = results
            .where((ipo) =>
                ipo.status.toLowerCase() == _selectedStatus.toLowerCase())
            .toList();
      }

      if (_selectedCategory != 'all') {
        results = results
            .where((ipo) => ipo.category.name == _selectedCategory)
            .toList();
      }

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _hasSearched = false;
      _selectedStatus = 'all';
      _selectedCategory = 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchHeader(),
          _buildFilters(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.background,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                       fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            widget.initialHint ?? widget.searchType.searchHint,
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.7),
                         fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.search_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color:
                                      AppColors.textSecondary.withOpacity(0.7),
                                  size: 16,
                                ),
                                onPressed: _clearSearch,
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      onSubmitted: (value) => _performSearch(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _performSearch,
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.white,
                             fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: _buildModernDropdown(
                label: 'Status',
                value: _selectedStatus,
                options: _statusOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                  if (_hasSearched) _performSearch();
                },
                getDisplayText: (status) =>
                    status == 'all' ? 'All Status' : status.toUpperCase(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildModernDropdown(
                label: 'Category',
                value: _selectedCategory,
                options: _categoryOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                  if (_hasSearched) _performSearch();
                },
                getDisplayText: (category) => category == 'all'
                    ? 'All Categories'
                    : category.toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDropdown({
    required String label,
    required String value,
    required List<String> options,
    required Function(String?) onChanged,
    required String Function(String) getDisplayText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.cardBorder.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            dropdownColor: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            elevation: 8,
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    getDisplayText(option),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: option == value
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            icon: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary,
                size: 16,
              ),
            ),
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Searching IPOs...',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Finding the best investment opportunities for you',
              style: TextStyle(
               fontSize: 15,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primaryLight.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ready to Discover IPOs?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use the search bar above to find companies,\nsectors, or specific IPO opportunities',
                style: TextStyle(
                 fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Try "tech", "pharma", or company names',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.textSecondary.withOpacity(0.1),
                      AppColors.textSecondary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 40,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No IPOs Found',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We couldn\'t find any IPOs matching your search.\nTry different keywords or adjust your filters.',
                style: TextStyle(
                 fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tips_and_updates_outlined,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Try broader terms or reset filters',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.warning,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.success,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_searchResults.length} IPO${_searchResults.length == 1 ? '' : 's'} found',
                      style: const TextStyle(
                       fontSize: 15,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final ipo = _searchResults[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: IPOCard(
                  ipo: ipo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IPODetailScreen(ipo: ipo),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
