class UrlValidator {
  const UrlValidator();

  bool isValid(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null) {
      return false;
    }
    return uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }
}
