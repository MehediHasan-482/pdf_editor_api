import 'package:mobile_app/core/usecase/result.dart';
import 'package:mobile_app/core/usecase/usecase.dart';
import 'package:mobile_app/features/pdf_translate/domain/entities/tranlate_pdf.dart';
import 'package:mobile_app/features/pdf_translate/domain/repositories/translate_repository.dart';

class TranslatePdfParams {
  final String filePath;
  final String sourceLanguage;
  final String targetLanguage;

  const TranslatePdfParams({
    required this.filePath,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}

class TranslatePdf implements UseCase<TranslatedPdf, TranslatePdfParams> {
  final TranslateRepository repository;

  TranslatePdf(this.repository);

  @override
  Future<Result<TranslatedPdf>> call(TranslatePdfParams params) {
    return repository.translatePdf(
      filePath: params.filePath,
      sourceLanguage: params.sourceLanguage,
      targetLanguage: params.targetLanguage,
    );
  }
}
