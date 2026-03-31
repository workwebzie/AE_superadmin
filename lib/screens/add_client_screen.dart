import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/app_controller.dart';
import '../models/client.dart';
import '../theme/app_theme.dart';
import 'dart:math';

class AddClientScreen extends StatefulWidget {
  final Client? client;
  const AddClientScreen({Key? key, this.client}) : super(key: key);

  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _baseUrlController = TextEditingController();
  final _companyCodeController = TextEditingController();
  final _durationController = TextEditingController(text: '30');

  DateTime _startDate = DateTime.now();
  String _selectedPlan = 'AE Free';
  bool _sameAsEmail = false;

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _nameController.text = widget.client!.name;
      _emailController.text = widget.client!.email;
      _adminEmailController.text = widget.client!.adminEmail;
      _baseUrlController.text = widget.client!.baseUrl;
      _companyCodeController.text = widget.client!.companyCode;
      _sameAsEmail = widget.client!.email == widget.client!.adminEmail;
      _durationController.text = widget.client!.subscriptionDurationDays.toString();
      _startDate = widget.client!.subscriptionStart;
      _selectedPlan = widget.client!.subscriptionPlan;
    }
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<AppController>();
      
      final client = Client(
        id: widget.client?.id ?? Random().nextInt(10000).toString(),
        name: _nameController.text,
        email: _emailController.text,
        adminEmail: _sameAsEmail ? _emailController.text : _adminEmailController.text,
        baseUrl: _baseUrlController.text,
        companyCode: _companyCodeController.text,
        subscriptionStart: _startDate,
        subscriptionDurationDays: int.parse(_durationController.text),
        subscriptionPlan: _selectedPlan,
      );

      if (widget.client != null) {
        controller.updateClient(client);
      } else {
        controller.addClient(client);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        title: Text(widget.client != null ? 'Edit Client' : 'Add New Client'),
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor),
        titleTextStyle: const TextStyle(color: AppTheme.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    color: AppTheme.primaryColor.withOpacity(0.03),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/Girl meditating.json',
                            height: 400,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            widget.client != null ? 'Refine Client Details' : 'Onboard New Client',
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Supercharge their workspace with AE Superadmin.',
                            style: TextStyle(fontSize: 16, color: AppTheme.fadedTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildForm(context),
                ),
              ],
            );
          }
          
          return Column(
            children: [
              Container(
                width: double.infinity,
                color: AppTheme.primaryColor.withOpacity(0.03),
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Lottie.asset(
                  'assets/lottie/Girl meditating.json',
                  height: 200,
                ),
              ),
              Expanded(child: _buildForm(context)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
             constraints: const BoxConstraints(maxWidth: 600),
             padding: const EdgeInsets.all(32),
             decoration: BoxDecoration(
               color: AppTheme.cardColor,
               borderRadius: BorderRadius.circular(24),
               border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
               boxShadow: [
                 BoxShadow(
                   color: AppTheme.primaryColor.withOpacity(0.15),
                   offset: const Offset(0, 8),
                   blurRadius: 24,
                   spreadRadius: -4,
                 )
               ],
             ),
             child: Form(
               key: _formKey,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   const Text(
                     'Client Information',
                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                   ),
                   const SizedBox(height: 24),
                   TextFormField(
                     controller: _nameController,
                     decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                     validator: (v) => v!.isEmpty ? 'Required' : null,
                   ),
                   const SizedBox(height: 16),
                   TextFormField(
                     controller: _emailController,
                     decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email)),
                     validator: (v) => v!.isEmpty || !v.contains('@') ? 'Invalid Email' : null,
                   ),
                   const SizedBox(height: 16),
                   const SizedBox(height: 16),
                   CheckboxListTile(
                     title: const Text('Admin Email same as Client Email?', style: TextStyle(color: AppTheme.textColor)),
                     value: _sameAsEmail,
                     onChanged: (val) {
                       setState(() => _sameAsEmail = val ?? false);
                       if (_sameAsEmail) {
                          _adminEmailController.text = _emailController.text;
                       } else {
                          _adminEmailController.clear();
                       }
                     },
                     controlAffinity: ListTileControlAffinity.leading,
                     contentPadding: EdgeInsets.zero,
                     activeColor: AppTheme.primaryColor,
                   ),
                   if (!_sameAsEmail) ...[
                     const SizedBox(height: 16),
                     TextFormField(
                       controller: _adminEmailController,
                       decoration: const InputDecoration(labelText: 'Admin Email', prefixIcon: Icon(Icons.admin_panel_settings)),
                       validator: (v) => v!.isEmpty || !v.contains('@') ? 'Invalid Email' : null,
                     ),
                   ],
                   const SizedBox(height: 16),
                   TextFormField(
                     controller: _baseUrlController,
                     decoration: const InputDecoration(labelText: 'Base URL', prefixIcon: Icon(Icons.link)),
                   ),
                   const SizedBox(height: 16),
                   TextFormField(
                     controller: _companyCodeController,
                     decoration: const InputDecoration(labelText: 'Company Code', prefixIcon: Icon(Icons.business)),
                   ),
                   const SizedBox(height: 32),
                    const Text(
                      'Subscription Detail',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Select Plan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textColor),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildPlanCard('AE Free', 'Basic features', '0'),
                            _buildPlanCard('AE Pro', 'Advanced access', '49'),
                            _buildPlanCard('AE Advanced', 'Full features', '99'),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                     children: [
                       Expanded(
                         child: TextFormField(
                           controller: _durationController,
                           decoration: const InputDecoration(labelText: 'Duration (Days)', prefixIcon: Icon(Icons.timer)),
                           keyboardType: TextInputType.number,
                           validator: (v) => int.tryParse(v ?? '') == null ? 'Invalid Number' : null,
                         ),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: InkWell(
                           onTap: () async {
                             final picked = await showDatePicker(
                               context: context,
                               initialDate: _startDate,
                               firstDate: DateTime(2000),
                               lastDate: DateTime(2100),
                             );
                             if (picked != null) {
                               setState(() => _startDate = picked);
                             }
                           },
                           child: InputDecorator(
                             decoration: const InputDecoration(labelText: 'Start Date', prefixIcon: Icon(Icons.calendar_today)),
                             child: Text(
                               "${_startDate.month}/${_startDate.day}/${_startDate.year}",
                               style: const TextStyle(color: AppTheme.textColor),
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(height: 48),
                   ElevatedButton(
                     onPressed: _saveClient,
                     child: Text(widget.client != null ? 'UPDATE CLIENT' : 'CREATE CLIENT'),
                   ),
                 ],
               ),
             ),
          ),
      ),
    );
  }

  Widget _buildPlanCard(String title, String subtitle, String price) {
    final isSelected = _selectedPlan == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.accentColor.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: AppTheme.fadedTextColor, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Text(
              'AED ${price} /mo',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
