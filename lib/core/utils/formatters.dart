int formatPrice(int price) {
  // Simple comma formatting for RWF-style prices.
  return int.parse(price.toString().replaceAllMapped(
    RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'),
    (m) => '${m[1]},',
  ).replaceAll(',', ''));
}

String formatPriceWithCommas(int price) {
  return price.toString().replaceAllMapped(
    RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'),
    (m) => '${m[1]},',
  );
}

