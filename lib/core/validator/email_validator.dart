class EmailValidator {
  static final RegExp _emailRegExp = RegExp(
    r'^[\w\.-]+@[\w\.-]+\.\w{2,}$',
  );

  static bool isValid(String email) {
    return _emailRegExp.hasMatch(email);
  }
}