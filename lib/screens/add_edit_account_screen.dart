import 'package:flutter/material.dart';
import '../models/demat_account.dart';
import '../services/demat_account_service.dart';
import '../theme/app_theme.dart';

class AddEditAccountScreen extends StatefulWidget {
  final DematAccount? account; // null for add, existing account for edit

  const AddEditAccountScreen({
    super.key,
    this.account,
  });

  @override
  State<AddEditAccountScreen> createState() => _AddEditAccountScreenState();
}

class _AddEditAccountScreenState extends State<AddEditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _applicantNameController = TextEditingController();
  final _panController = TextEditingController();
  final _dematIdController = TextEditingController(); // For CDSL
  final _dpIdController = TextEditingController(); // For NSDL
  final _clientIdController = TextEditingController(); // For NSDL
  final _upiIdController = TextEditingController();

  DPType _selectedDPType = DPType.cdsl;
  bool _isLoading = false;

  bool get isEditing => widget.account != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _populateFields();
    }
  }

  void _populateFields() {
    final account = widget.account!;
    _applicantNameController.text = account.applicantName;
    _panController.text = account.panNumber;
    _selectedDPType = account.dpType;

    if (account.dpType == DPType.cdsl) {
      _dematIdController.text = account.dematId ?? '';
    } else {
      _dpIdController.text = account.dpId ?? '';
      _clientIdController.text = account.clientId ?? '';
    }

    _upiIdController.text = account.upiId;
  }

  @override
  void dispose() {
    _applicantNameController.dispose();
    _panController.dispose();
    _dematIdController.dispose();
    _dpIdController.dispose();
    _clientIdController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Account' : 'Add Account'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildApplicantNameField(),
              const SizedBox(height: 16),
              _buildPANField(),
              const SizedBox(height: 16),
              _buildDPTypeField(),
              const SizedBox(height: 16),
              _buildAccountFields(),
              const SizedBox(height: 16),
              _buildUPIField(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isEditing ? 'Edit Demat Account' : 'Add New Demat Account',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Please fill in all the required details for your demat account',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantNameField() {
    return TextFormField(
      controller: _applicantNameController,
      decoration: InputDecoration(
        labelText: 'Applicant Name (as per PAN card)',
        prefixIcon: Icon(Icons.person_outlined, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter applicant name';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildPANField() {
    return TextFormField(
      controller: _panController,
      decoration: InputDecoration(
        labelText: 'PAN No.',
        prefixIcon: Icon(Icons.credit_card_outlined, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        hintText: 'ABCDE1234F',
      ),
      textCapitalization: TextCapitalization.characters,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter PAN number';
        }
        if (!DematAccount.isValidPAN(value.trim())) {
          return 'Please enter a valid PAN number';
        }
        return null;
      },
    );
  }

  Widget _buildDPTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            const Text(
              'DP Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: DPType.values.map((type) {
              return Expanded(
                child: Row(
                  children: [
                    Radio<DPType>(
                      value: type,
                      groupValue: _selectedDPType,
                      onChanged: (value) {
                        setState(() {
                          _selectedDPType = value!;
                          // Clear the fields when switching DP type
                          _dematIdController.clear();
                          _dpIdController.clear();
                          _clientIdController.clear();
                        });
                      },
                      activeColor: AppColors.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      type.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountFields() {
    if (_selectedDPType == DPType.cdsl) {
      return _buildDematIdField();
    } else {
      return Column(
        children: [
          _buildDpIdField(),
          const SizedBox(height: 16),
          _buildClientIdField(),
        ],
      );
    }
  }

  Widget _buildDematIdField() {
    return TextFormField(
      controller: _dematIdController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Demat ID (16 digits)',
        prefixIcon:
            Icon(Icons.account_balance_outlined, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(Icons.info_outline, color: AppColors.primary),
          onPressed: () => _showInfoDialog(
            'Demat ID Information',
            'If your DEMAT account is held with CDSL, your Demat number/ID will consist of sixteen digits. For instance, it might appear as 1208000012345678.\n\nTo find these details, you can access the profile section of your broker\'s website or app.',
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        hintText: '1234567890123456',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter Demat ID';
        }
        if (!DematAccount.isValidDematId(value.trim())) {
          return 'Please enter a valid 16-digit Demat ID';
        }
        return null;
      },
    );
  }

  Widget _buildDpIdField() {
    return TextFormField(
      controller: _dpIdController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'DP ID (8 digits)',
        prefixIcon: Icon(Icons.business_outlined, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(Icons.info_outline, color: AppColors.primary),
          onPressed: () => _showInfoDialog(
            'DP ID and Client ID Information',
            'If your DEMAT account is with NSDL, both the DP ID and Client ID will comprise eight characters each. The initial characters will always be \'IN\', followed by numeric characters. To illustrate, if your Demat number/ID is IN12345678912345, then the DP ID would be IN123456, and the Client ID would be 78912345.\n\nTo find these details, you can access the profile section of your broker\'s website or app.',
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        hintText: '12345678',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter DP ID';
        }
        if (!DematAccount.isValidDpId(value.trim())) {
          return 'Please enter a valid 8-digit DP ID';
        }
        return null;
      },
    );
  }

  Widget _buildClientIdField() {
    return TextFormField(
      controller: _clientIdController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Client ID (8 digits)',
        prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(Icons.info_outline, color: AppColors.primary),
          onPressed: () => _showInfoDialog(
            'DP ID and Client ID Information',
            'If your DEMAT account is with NSDL, both the DP ID and Client ID will comprise eight characters each. The initial characters will always be \'IN\', followed by numeric characters. To illustrate, if your Demat number/ID is IN12345678912345, then the DP ID would be IN123456, and the Client ID would be 78912345.\n\nTo find these details, you can access the profile section of your broker\'s website or app.',
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        hintText: '87654321',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter Client ID';
        }
        if (!DematAccount.isValidClientId(value.trim())) {
          return 'Please enter a valid 8-digit Client ID';
        }
        return null;
      },
    );
  }

  Widget _buildUPIField() {
    return TextFormField(
      controller: _upiIdController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'UPI ID',
        prefixIcon: Icon(Icons.payment_outlined, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(Icons.info_outline, color: AppColors.primary),
          onPressed: () => _showInfoDialog(
            'UPI ID Information',
            'Enter your UPI ID that you use for payments. Examples:\n\n'
                '• yourname@paytm\n'
                '• 9876543210@gpay\n'
                '• username@phonepe\n'
                '• yourname@oksbi\n\n'
                'Make sure the UPI ID is active and belongs to you.',
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        hintText: 'yourname@paytm or 9876543210@gpay',
        helperText: 'Enter your active UPI ID for payments',
        helperStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter UPI ID';
        }
        if (!DematAccount.isValidUPI(value.trim())) {
          return 'Please enter a valid UPI ID (e.g., name@paytm or 9876543210@gpay)';
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                isEditing ? 'Update Account' : 'Save Account',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = DematAccountService.instance;

      // Check for duplicates
      final panExists = await service.isPANExists(
        _panController.text.trim().toUpperCase(),
        excludeAccountId: isEditing ? widget.account!.id : null,
      );

      if (panExists) {
        _showErrorSnackBar('An account with this PAN number already exists');
        return;
      }

      // Check for duplicate account identifiers based on DP type
      if (_selectedDPType == DPType.cdsl) {
        final dematIdExists = await service.isDematIdExists(
          _dematIdController.text.trim(),
          excludeAccountId: isEditing ? widget.account!.id : null,
        );
        if (dematIdExists) {
          _showErrorSnackBar('An account with this Demat ID already exists');
          return;
        }
      } else {
        final dpClientComboExists = await service.isDpClientComboExists(
          _dpIdController.text.trim(),
          _clientIdController.text.trim(),
          excludeAccountId: isEditing ? widget.account!.id : null,
        );
        if (dpClientComboExists) {
          _showErrorSnackBar(
              'An account with this DP ID and Client ID combination already exists');
          return;
        }
      }

      final account = DematAccount(
        id: isEditing ? widget.account!.id : service.generateAccountId(),
        applicantName: _applicantNameController.text.trim(),
        panNumber: _panController.text.trim().toUpperCase(),
        dpType: _selectedDPType,
        dematId: _selectedDPType == DPType.cdsl
            ? _dematIdController.text.trim()
            : null,
        dpId:
            _selectedDPType == DPType.nsdl ? _dpIdController.text.trim() : null,
        clientId: _selectedDPType == DPType.nsdl
            ? _clientIdController.text.trim()
            : null,
        upiId: _upiIdController.text.trim(),
        createdAt: isEditing ? widget.account!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (isEditing) {
        success = await service.updateAccount(account);
      } else {
        success = await service.addAccount(account);
      }

      if (success) {
        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditing
                  ? 'Account updated successfully'
                  : 'Account added successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        _showErrorSnackBar('Failed to save account. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
