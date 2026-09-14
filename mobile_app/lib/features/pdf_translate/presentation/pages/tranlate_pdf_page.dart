// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:mobile_app/features/pdf_translate/presentation/providers/translate_notifier.dart';
import 'package:mobile_app/features/pdf_translate/presentation/providers/translate_state.dart';

class TranslatePdfPage extends ConsumerStatefulWidget {
  const TranslatePdfPage({super.key});

  @override
  ConsumerState<TranslatePdfPage> createState() => _TranslatePdfPageState();
}

class _TranslatePdfPageState extends ConsumerState<TranslatePdfPage> {
  File? _pickedFile;
  final String _sourceLanguage = "en";
  final String _targetLanguage = "bn";

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _pickedFile = File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(translateNotifierProvider);
    final notifier = ref.read(translateNotifierProvider.notifier);
    ref.listen<TranslateState>(translateNotifierProvider, (previous, next) {
      if (next is TranslateFailed) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("PDF Translator")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _pickPdf,
              icon: const Icon(Icons.upload_file),
              label: const Text("Select PDF"),
            ),
            if (_pickedFile != null) ...[
              const SizedBox(height: 12),
              Text(_pickedFile!.path.split(Platform.pathSeparator).last),
            ],
            const SizedBox(height: 30),
            _buildActionArea(state, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildActionArea(TranslateState state, TranslateNotifier notifier) {
    return switch (state) {
      TranslateLoading() => const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text("translating......"),
        ],
      ),
      TranslateSuccess(result: final result) => Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 40),
          const SizedBox(height: 8),
          const Text("Translation completed!"),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => OpenFilex.open(result.localFilePath),
            child: const Text("Open PDF"),
          ),
          TextButton(
            onPressed: notifier.reset,
            child: const Text("Start Over"),
          ),
        ],
      ),
      _ => ElevatedButton(
        onPressed: _pickedFile == null
            ? null
            : () => notifier.translate(
                filePath: _pickedFile!.path,
                sourceLanguage: _sourceLanguage,
                targetLanguage: _targetLanguage,
              ),
        child: const Text("Translate"),
      ),
    };
  }
}
