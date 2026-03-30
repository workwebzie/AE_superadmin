import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final _phoneController = TextEditingController();
  final _detailsController = TextEditingController();
  final _durationController = TextEditingController(text: '30');

  DateTime _startDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _nameController.text = widget.client!.name;
      _emailController.text = widget.client!.email;
      _phoneController.text = widget.client!.phone;
      _detailsController.text = widget.client!.details;
      _durationController.text = widget.client!.subscriptionDurationDays.toString();
      _startDate = widget.client!.subscriptionStart;
    }
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<AppController>();
      
      final client = Client(
        id: widget.client?.id ?? Random().nextInt(10000).toString(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        details: _detailsController.text,
        subscriptionStart: _startDate,
        subscriptionDurationDays: int.parse(_durationController.text),
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
      appBar: AppBar(
        title: Text(widget.client != null ? 'Edit Client' : 'Add New Client'),
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
      ),
      body: Center(
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
                   TextFormField(
                     controller: _phoneController,
                     decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
                   ),
                   const SizedBox(height: 16),
                   TextFormField(
                     controller: _detailsController,
                     maxLines: 3,
                     decoration: const InputDecoration(labelText: 'App Details / Notes', alignLabelWithHint: true),
                   ),
                   const SizedBox(height: 32),
                   const Text(
                     'Subscription Detail',
                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
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
                               "\${_startDate.month}/\${_startDate.day}/\${_startDate.year}",
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
      ),
    );
  }
}
