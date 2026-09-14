import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/features/pdf_translate/data/datasources/translate_remote_data_source.dart';
import 'package:mobile_app/features/pdf_translate/data/repositoty/translate_repository_impl.dart';
import 'package:mobile_app/features/pdf_translate/domain/repositories/translate_repository.dart';
import 'package:mobile_app/features/pdf_translate/domain/usecases/translate_pdf.dart';
import 'package:riverpod/riverpod.dart';

final dioProvider = Provider((ref) => DioClient.create());

final translateRemoteDataSourceProvider = Provider<TranslateRemoteDataSource>((
  ref,
) {
  return TranslateRemoteDataSourceImpl(ref.watch(dioProvider));
});

final translateRepositoryProvider = Provider<TranslateRepository>((ref) {
  return TranslateRepositoryImpl(ref.watch(translateRemoteDataSourceProvider));
});

final translatePdfUseCaseProvider = Provider<TranslatePdf>((ref) {
  return TranslatePdf(ref.watch(translateRepositoryProvider));
});
