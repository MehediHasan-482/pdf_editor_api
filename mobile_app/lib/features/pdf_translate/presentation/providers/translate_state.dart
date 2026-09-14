import 'package:mobile_app/features/pdf_translate/domain/entities/tranlate_pdf.dart';

sealed class TranslateState {
  const TranslateState();
}

class TranslateIdle extends TranslateState {
  const TranslateIdle();
}

class TranslateLoading extends TranslateState {
  const TranslateLoading();
}

class TranslateSuccess extends TranslateState {
  final TranslatedPdf result;
  const TranslateSuccess(this.result);
}

class TranslateFailed extends TranslateState {
  final String message;
  const TranslateFailed(this.message);
}
