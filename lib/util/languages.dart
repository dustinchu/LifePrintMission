import 'package:flutter/material.dart';

const english = Language(
  englishName: 'Branding Meeting',
  nativeName: 'Discussion on social media branding at 9:00 a.m.',
);

const french = Language(
  englishName: 'Branding Meeting',
  nativeName: 'Discussion on social media branding at 9:00 a.m.',
);

const german = Language(
  englishName: 'Branding Meeting',
  nativeName: 'Discussion on social media branding at 9:00 a.m.',
);

const spanish = Language(
  englishName: 'Branding Meeting',
  nativeName: 'Discussion on social media branding at 9:00 a.m.',
);

const chinese = Language(
  englishName: 'Branding Meeting',
  nativeName: 'Discussion on social media branding at 9:00 a.m.',
);

const danish = Language(
  englishName: 'Branding Meeting',
  nativeName: 'Discussion on social media branding at 9:00 a.m.',
);

const hindi = Language(
  englishName: 'Branding Meeting',
  nativeName: 'Discussion on social media branding at 9:00 a.m.',
);

const afrikaans = Language(
  englishName: 'Branding Meeting',
  nativeName: 'Discussion on social media branding at 9:00 a.m.',
);

const portuguese = Language(
  englishName: 'Branding Meeting',
  nativeName: 'Discussion on social media branding at 9:00 a.m.',
);

const List<Language> languages = [
  english,
  french,
  german,
  spanish,
  chinese,
  danish,
  hindi,
  afrikaans,
  portuguese,
];

class Language {
  final String englishName;
  final String nativeName;
  const Language({
    @required this.englishName,
    @required this.nativeName,
  });

  @override
  String toString() =>
      'Language englishName: $englishName, nativeName: $nativeName';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Language &&
        o.englishName == englishName &&
        o.nativeName == nativeName;
  }

  @override
  int get hashCode => englishName.hashCode ^ nativeName.hashCode;
}
