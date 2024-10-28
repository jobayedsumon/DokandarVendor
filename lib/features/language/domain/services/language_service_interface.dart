import 'package:flutter/material.dart';
import 'package:dokandar_shop/features/language/domain/models/language_model.dart';

abstract class LanguageServiceInterface {
  bool setLTR(Locale locale);
  void updateHeader(Locale locale);
  Locale getLocaleFromSharedPref();
  int setSelectedLanguageIndex(List<LanguageModel> languages, Locale locale);
  void saveLanguage(Locale locale);
}