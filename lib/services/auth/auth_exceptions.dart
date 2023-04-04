// login exception classes

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Register exception classes

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Generic exception classes

class GenericAuthException implements Exception {}

class UserNotLoggedIndAuthException implements Exception {}
