import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/contact_form_model.dart';
import '../provider/contacts_provider.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  final ContactFormModel _formModel = ContactFormModel();

  bool _isSubmitting = false;

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const UnderlineInputBorder(),
    );
  }

  Future<void> _takeProfilePicture() async {
    // I referenced the imagepicker_main sample here and adapted it
    // so the image is taken using the camera and displayed only in the form.
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      _formModel.imagePath = image == null ? null : image.path;
    });
  }

  Future<void> _submitContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    _formModel.firstName = _firstNameController.text;
    _formModel.lastName = _lastNameController.text;
    _formModel.phoneNumber = _phoneNumberController.text;
    _formModel.email = _emailController.text;

    await context.read<ContactsProvider>().addContact(
          firstName: _formModel.firstName,
          lastName: _formModel.lastName,
          phoneNumber: _formModel.phoneNumber,
          email: _formModel.email,
        );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _formModel.imagePath;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _takeProfilePicture,
                child: imagePath == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 56,
                        color: Colors.black54,
                      )
                    : CircleAvatar(
                        radius: 42,
                        backgroundImage: FileImage(File(imagePath)),
                      ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _firstNameController,
                decoration: _inputDecoration('First Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: _inputDecoration('Last Name'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('Phone Number'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email'),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 130,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEADFF7),
                    foregroundColor: const Color(0xFF6F5AA6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Add Contact'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}