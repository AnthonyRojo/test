import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';

import '../provider/contacts_provider.dart';

class ContactDetailsScreen extends StatelessWidget {
  final Contact contact;

  const ContactDetailsScreen({
    super.key,
    required this.contact,
  });

  Future<void> _deleteContact(BuildContext context) async {
    await context.read<ContactsProvider>().deleteContact(contact);

    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.displayName ?? "..."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('First name: ${contact.name?.first ?? ''}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Last name: ${contact.name?.last ?? ''}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: () => _deleteContact(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEADFF7),
                    foregroundColor: const Color(0xFF6F5AA6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Delete Contact'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}