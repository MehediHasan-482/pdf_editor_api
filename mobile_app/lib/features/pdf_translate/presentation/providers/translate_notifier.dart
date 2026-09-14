import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/pdf_translate/domain/usecases/translate_pdf.dart';
import 'package:mobile_app/features/pdf_translate/presentation/providers/translate_providers.dart';
import 'package:mobile_app/features/pdf_translate/presentation/providers/translate_state.dart';

class TranslateNotifier extends StateNotifier<TranslateState> {
  final TranslatePdf _translatePdfUseCase;

  TranslateNotifier(this._translatePdfUseCase) : super(const TranslateIdle());

  Future<void> translate({
    required String filePath,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    state = const TranslateLoading();

    final result = await _translatePdfUseCase(
      TranslatePdfParams(
        filePath: filePath,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      ),
    );

    state = result.when(
      success: (data) => TranslateSuccess(data),
      failure: (failure) => TranslateFailed(failure.message),
    );
  }

  void reset() => state = const TranslateIdle();
}

final translateNotifierProvider =
    StateNotifierProvider<TranslateNotifier, TranslateState>((ref) {
      return TranslateNotifier(ref.watch(translatePdfUseCaseProvider));
    });
