import 'package:mobile_app/core/usecase/result.dart';
import 'package:mobile_app/features/pdf_translate/domain/entities/tranlate_pdf.dart';

abstract class TranslateRepository {
  Future<Result<TranslatedPdf>> translatePdf({
    required String filePath,
    required String sourceLanguage,
    required String targetLanguage,
  });
}
