import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsProvider extends ChangeNotifier {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  StreamSubscription? _contactsSubscription;

  List<Contact>? get contacts => _contacts;
  bool get permissionDenied => _permissionDenied;

  Future<void> initialize() async {
    // I referenced the contacts_main sample here and kept the database listener
    _contactsSubscription = FlutterContacts.onDatabaseChange.listen((_) {
      fetchContacts();
    });

    await fetchContacts();
  }

  Future<void> fetchContacts() async {
    final status = await FlutterContacts.permissions.request(
      PermissionType.readWrite,
    );

    if (status == PermissionStatus.denied) {
      _permissionDenied = true;
      notifyListeners();
      return;
    }

    final fetchedContacts = await FlutterContacts.getAll(
      properties: ContactProperties.all,
    );

    fetchedContacts.sort((a, b) {
      final aName = (a.displayName ?? '').toLowerCase();
      final bName = (b.displayName ?? '').toLowerCase();
      return aName.compareTo(bName);
    });

    _contacts = fetchedContacts;
    _permissionDenied = false;
    notifyListeners();
  }

  Future<void> addContact({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  }) async {
    final newContact = Contact(
      name: Name(
        first: firstName.trim(),
        last: lastName.trim(),
      ),
      phones: phoneNumber.trim().isNotEmpty
          ? [Phone(number: phoneNumber.trim())]
          : [],
      emails: email.trim().isNotEmpty
          ? [Email(address: email.trim())]
          : [],
    );

    await FlutterContacts.create(newContact);

    await fetchContacts();
  }

  Future<Contact?> getFullContact(String id) async {
    return FlutterContacts.get(
      id,
      properties: ContactProperties.all,
    );
  }

  Future<void> deleteContact(Contact contact) async {
    await FlutterContacts.delete(contact.id!);

    await fetchContacts();
  }

  @override
  void dispose() {
    _contactsSubscription?.cancel();
    super.dispose();
  }
}