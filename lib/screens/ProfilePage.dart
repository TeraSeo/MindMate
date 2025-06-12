import 'package:ai_chatter/constants/ProfileOptions.dart';
import 'package:ai_chatter/widgets/subscription/SubscriptionPage.dart';
import 'package:ai_chatter/widgets/user/PersonalInfoForm.dart';
import 'package:ai_chatter/widgets/subscription/SubscriptionCard.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String _selectedGender = 'Male';
  String _selectedAge = '18-24';
  bool _notificationsEnabled = true;
  bool _isLoading = true;
  late UserProvider _userProvider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _userProvider = Provider.of<UserProvider>(context);
      _loadUserData();
      _isInitialized = true;
    }
  }

  void _loadUserData() {
    final user = _userProvider.user;
    
    if (user != null) {
      setState(() {
        _nameController.text = user.name ?? '';
        _selectedAge = user.age ?? '18-24';
        _selectedGender = user.gender ?? 'Male';
        _notificationsEnabled = user.notificationsEnabled;
        _isLoading = false;
      });
    } else {
      // Listen for user data changes
      _userProvider.addListener(_onUserDataChanged);
    }
  }

  void _onUserDataChanged() {
    final user = _userProvider.user;
    
    if (user != null) {
      setState(() {
        _nameController.text = user.name ?? '';
        _selectedAge = user.age ?? '18-24';
        _selectedGender = user.gender ?? 'Male';
        _notificationsEnabled = user.notificationsEnabled;
        _isLoading = false;
      });
      _userProvider.removeListener(_onUserDataChanged);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    if (_isInitialized) {
      _userProvider.removeListener(_onUserDataChanged);
    }
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _userProvider.updateUserProfile(
        name: _nameController.text,
        age: _selectedAge,
        gender: _selectedGender,
        notificationsEnabled: _notificationsEnabled,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated)),
      );
    }
  }

  void _showSubscriptionPlans() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SubscriptionPage()),
    );
  }

  Widget _buildSubscriptionInfo() {
    final user = _userProvider.user;
    final subscription = user?.subscription ?? 'free';
    
    return SubscriptionCard(
      isPremium: subscription == 'premium',
      onUpgrade: _showSubscriptionPlans,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final horizontalPadding = isSmallScreen ? BoxSize.pagePadding : size.width * 0.1;
    final maxWidth = isSmallScreen ? double.infinity : 600.0;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.profile,
            style: TextStyle(fontSize: FontSize.h6),
          ),
          backgroundColor: ConstantColor.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.profile,
          style: TextStyle(fontSize: FontSize.h6),
        ),
        backgroundColor: ConstantColor.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: BoxSize.pagePadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubscriptionInfo(),
                    SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
                    Text(
                      l10n.personalInformation,
                      style: TextStyle(
                        fontSize: isSmallScreen ? FontSize.h4 : FontSize.h3,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.primaryColor,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? BoxSize.spacingL : BoxSize.spacingXL),
                    PersonalInfoForm(
                      nameController: _nameController,
                      selectedAge: _selectedAge,
                      selectedGender: _selectedGender,
                      ageGroups: ProfileOptions.ageGroups,
                      genderOptions: ProfileOptions.genderOptions,
                      onAgeChanged: (val) => setState(() => _selectedAge = val),
                      onGenderChanged: (val) => setState(() => _selectedGender = val),
                    ),
                    SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
                    Text(
                      l10n.notifications,
                      style: TextStyle(
                        fontSize: isSmallScreen ? FontSize.h4 : FontSize.h3,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.primaryColor,
                      ),
                    ),
                    SizedBox(height: BoxSize.spacingM),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(BoxSize.cardRadius),
                        side: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(BoxSize.cardPadding),
                        child: SwitchListTile(
                          title: Text(
                            l10n.enableNotifications,
                            style: TextStyle(fontSize: FontSize.bodyLarge),
                          ),
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
                    SizedBox(
                      width: double.infinity,
                      height: BoxSize.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantColor.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(BoxSize.buttonRadius),
                          ),
                        ),
                        child: Text(
                          l10n.saveChanges,
                          style: TextStyle(fontSize: FontSize.buttonMedium),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 