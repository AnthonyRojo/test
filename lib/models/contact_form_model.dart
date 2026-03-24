class ContactFormModel {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String? imagePath;

  ContactFormModel({
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.email = '',
    this.imagePath,
  });

  bool get isValid =>
      firstName.trim().isNotEmpty && phoneNumber.trim().isNotEmpty;
}