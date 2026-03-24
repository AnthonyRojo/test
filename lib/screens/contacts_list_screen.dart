import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/contacts_provider.dart';
import 'add_contact_screen.dart';
import 'contact_details_screen.dart';

class ContactsListScreen extends StatelessWidget {
  const ContactsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsProvider = context.watch<ContactsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Own Contacts App'),
      ),
      body: _buildBody(context, contactsProvider),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddContactScreen(),
            ),
          );
        },
        child: const Icon(Icons.contact_page),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ContactsProvider contactsProvider) {
    if (contactsProvider.permissionDenied) {
      return const Center(
        child: Text('Permission denied'),
      );
    }

    if (contactsProvider.contacts == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: contactsProvider.contacts!.length,
      itemBuilder: (context, index) {
        final contact = contactsProvider.contacts![index];

        return ListTile(
          title: Text(contact.displayName ?? "..."),
          onTap: () async {
            final fullContact = await contactsProvider.getFullContact(
              contact.id!,
            );

            if (!context.mounted || fullContact == null) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ContactDetailsScreen(contact: fullContact),
              ),
            );
          },
        );
      },
    );
  }
}