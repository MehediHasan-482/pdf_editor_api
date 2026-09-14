/// এটা domain entity — শুধু business-relevant ডেটা রাখে।
/// data layer এর কোনো detail (bytes, file path handling ইত্যাদি) এখানে নেই।
class TranslatedPdf {
  final String localFilePath;
  final String sourceLanguage;
  final String targetLanguage;

  const TranslatedPdf({
    required this.localFilePath,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}
