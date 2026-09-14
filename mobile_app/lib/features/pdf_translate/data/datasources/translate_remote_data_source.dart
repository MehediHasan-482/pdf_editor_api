import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

abstract class TranslateRemoteDataSource {
  Future<String> translatePdf({
    required String filePath,
    required String sourceLanguage,
    required String targetLanguage,
  });
}

class TranslateRemoteDataSourceImpl implements TranslateRemoteDataSource {
  final Dio dio;

  TranslateRemoteDataSourceImpl(this.dio);

  @override
  Future<String> translatePdf({
    required String filePath,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath,
        filename: filePath.split(Platform.pathSeparator).last,
      ),
      "source_language": sourceLanguage,
      "target_language": targetLanguage,
    });

    final response = await dio.post(
      "/api/translate-pdf",
      data: formData,
      options: Options(responseType: ResponseType.bytes),
    );

    final dir = await getTemporaryDirectory();
    final outputPath =
        "${dir.path}/translated_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(response.data as List<int>);

    return outputPath;
  }
}
