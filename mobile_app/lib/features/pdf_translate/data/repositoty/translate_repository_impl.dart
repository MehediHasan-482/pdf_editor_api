import 'package:dio/dio.dart';
import 'package:mobile_app/core/error/failures.dart';
import 'package:mobile_app/core/usecase/result.dart';
import 'package:mobile_app/features/pdf_translate/data/datasources/translate_remote_data_source.dart';
import 'package:mobile_app/features/pdf_translate/domain/entities/tranlate_pdf.dart';
import 'package:mobile_app/features/pdf_translate/domain/repositories/translate_repository.dart';

class TranslateRepositoryImpl implements TranslateRepository {
  final TranslateRemoteDataSource remoteDataSource;

  TranslateRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<TranslatedPdf>> translatePdf({
    required String filePath,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final outputPath = await remoteDataSource.translatePdf(
        filePath: filePath,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );

      return Success(
        TranslatedPdf(
          localFilePath: outputPath,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
        ),
      );
    } on DioException catch (e) {
      return Error(_mapDioError(e));
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure(
        "Connection error. Please check your internet connection or server status.",
      );
    }

    final response = e.response;
    if (response != null) {
      String detail = "Server error";
      final data = response.data;
      if (data is List<int>) {
        try {
          detail = String.fromCharCodes(data);
        } catch (_) {}
      } else if (data is Map && data["detail"] != null) {
        detail = data["detail"].toString();
      }

      if (response.statusCode == 400 || response.statusCode == 422) {
        return InvalidFileFailure(detail);
      }
      return ServerFailure(detail);
    }

    return UnknownFailure(e.message ?? "Unknown error occurred.");
  }
}
