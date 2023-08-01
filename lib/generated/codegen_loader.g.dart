// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "noNotes": "No notes",
  "myNotes": "My Notes",
  "newNote": "New Note",
  "updateNote": "Update note",
  "mood": "Mood",
  "text": "Text"
};
static const Map<String,dynamic> ru = {
  "noNotes": "Нет заметок",
  "myNotes": "Мои Заметки",
  "newNote": "Новая Заметка",
  "updateNote": "Редактирование",
  "mood": "Заголовок",
  "text": "Текст"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ru": ru};
}
