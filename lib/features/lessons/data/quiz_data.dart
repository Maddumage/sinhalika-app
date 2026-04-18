import '../../../core/models/quiz_item.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Quiz lessons data — Sinhala folk-tales & culture themed questions
// ─────────────────────────────────────────────────────────────────────────────

const List<QuizLesson> quizLessons = [
  QuizLesson(
    id: 'lesson_01',
    lessonNumber: 1,
    titleSinhala: 'ප්‍රශ්න පතුය (Quiz)',
    questions: [
      QuizQuestion(
        questionSinhala: 'සිංහල හෝඩියේ ස්වර කීයක් තිබේද?',
        questionEnglish: 'How many vowels are in the Sinhala alphabet?',
        options: ['14', '18', '16', '20'],
        correctIndex: 1,
        contextLabelSinhala: 'සිංහල හෝඩිය',
        imageAsset: 'assets/images/learning_kid.png',
      ),
      QuizQuestion(
        questionSinhala: 'මහදනමුත්තා කතාවේ සිටින ප්‍රධාන චරිතය කවුද?',
        questionEnglish:
            'Choose the correct main character. (Choose the correct main character).',
        options: ['කොටියා', 'මහදනමුත්තා', 'නරියා', 'භාවා'],
        correctIndex: 1,
        contextLabelSinhala: 'මහදනමුත්තා (Story Context)',
        imageAsset: 'assets/images/study_room.png',
      ),
      QuizQuestion(
        questionSinhala: '"ආයුබෝවන්" යනු කුමන අවස්ථාවේ කියන වදනක්ද?',
        questionEnglish:
            'In which occasion is the word "Ayubowan" used? (Choose the correct answer).',
        options: ['සමු ගැනීමේ', 'සුභ පැතීමේ', 'ශෝකයේ', 'ආහාර ගැනීමේ'],
        correctIndex: 1,
        contextLabelSinhala: 'සුභ පැතීම',
        imageAsset: 'assets/images/drawing_kid.png',
      ),
      QuizQuestion(
        questionSinhala: 'ශ්‍රී ලංකාවේ ජාතික කුසලානය කුමක්ද?',
        questionEnglish:
            'What is the national flower of Sri Lanka? (Choose the correct answer).',
        options: ['රෝස', 'නෙළුම', 'ජාසිමිය', 'ලිලී'],
        correctIndex: 1,
        contextLabelSinhala: 'ශ්‍රී ලංකා සංස්කෘතිය',
        imageAsset: 'assets/images/learning_pets.png',
      ),
      QuizQuestion(
        questionSinhala: '"ස" "ශ" "ෂ" යන අකුරු කුමන කාණ්ඩයට අයිතිද?',
        questionEnglish:
            'Which category do the letters "ස", "ශ", "ෂ" belong to?',
        options: ['ස්වර', 'ව්‍යංජන', 'ගාරාළ', 'යොදා ගැනීම'],
        correctIndex: 1,
        contextLabelSinhala: 'සිංහල හෝඩිය',
        imageAsset: 'assets/images/learning_kid.png',
      ),
      QuizQuestion(
        questionSinhala: 'සිංහල නව වසර සැමරෙන්නේ කුමන මාසයේද?',
        questionEnglish: 'In which month is the Sinhala New Year celebrated?',
        options: ['මාර්තු', 'අපේ‍්‍රල්', 'ජනවාරි', 'ජූනි'],
        correctIndex: 1,
        contextLabelSinhala: 'ශ්‍රී ලංකා උත්සව',
        imageAsset: 'assets/images/treasure_box.png',
      ),
      QuizQuestion(
        questionSinhala: 'කිරිදෙල් ව්‍යායාමය සිදු කෙරෙන්නේ කොහෙද?',
        questionEnglish:
            'Where is the traditional Kiri Del game usually played?',
        options: ['නගරයේ', 'ගමේ', 'ජල යටතේ', 'ශාලාවේ'],
        correctIndex: 1,
        contextLabelSinhala: 'ජන ක්‍රීඩා',
        imageAsset: 'assets/images/study_room.png',
      ),
      QuizQuestion(
        questionSinhala: '"ප" ට දීර්ඝ ස්වරය කුමක්ද?',
        questionEnglish: 'What is the long vowel form of "ප"?',
        options: ['ප', 'පා', 'පි', 'පු'],
        correctIndex: 1,
        contextLabelSinhala: 'සිංහල හෝඩිය',
        imageAsset: 'assets/images/drawing_kid.png',
      ),
      QuizQuestion(
        questionSinhala: 'ජනකතාවේ "නරියා" යනු කුමන සතාද?',
        questionEnglish: 'In folk tales, "Nariya" refers to which animal?',
        options: ['කොටියා', 'ලිහිණියා', 'නරියා', 'ඇතා'],
        correctIndex: 2,
        contextLabelSinhala: 'ජනකතා',
        imageAsset: 'assets/images/learning_pets.png',
      ),
      QuizQuestion(
        questionSinhala: 'ශ්‍රී ලංකාවේ ජාතික ගස කුමක්ද?',
        questionEnglish: 'What is the national tree of Sri Lanka?',
        options: ['පොල් ගස', 'නා ගස', 'ඇට ගස', 'රබර් ගස'],
        correctIndex: 1,
        contextLabelSinhala: 'ශ්‍රී ලංකා සංස්කෘතිය',
        imageAsset: 'assets/images/treasure_box.png',
      ),
    ],
  ),
  QuizLesson(
    id: 'lesson_02',
    lessonNumber: 2,
    titleSinhala: 'ප්‍රශ්න පතුය (Quiz)',
    questions: [
      QuizQuestion(
        questionSinhala: '"අ" යනු කුමන ස්වරයද?',
        questionEnglish: 'What type of vowel is "අ"?',
        options: ['දීර්ඝ', 'හ්‍රස්ව', 'සංයෝග', 'ගාරාළ'],
        correctIndex: 1,
        contextLabelSinhala: 'ස්වර',
        imageAsset: 'assets/images/learning_kid.png',
      ),
      QuizQuestion(
        questionSinhala: 'ශ්‍රී ලංකාවේ ජාතික ක්‍රීඩාව කුමක්ද?',
        questionEnglish: 'What is the national sport of Sri Lanka?',
        options: ['ක‍්‍රිකට්', 'රග්බි', 'ෆුට්බෝල්', 'නෙට්බෝල්'],
        correctIndex: 0,
        contextLabelSinhala: 'ශ්‍රී ලංකාව',
        imageAsset: 'assets/images/study_room.png',
      ),
      QuizQuestion(
        questionSinhala: '"ක" "ග" "ඟ" "ච" "ඡ" — මේවා මොනවාද?',
        questionEnglish: 'What are "ක", "ග", "ඟ", "ච", "ඡ"?',
        options: ['ස්වර', 'ව්‍යංජන', 'ගාරාළ', 'ශුද්ධ'],
        correctIndex: 1,
        contextLabelSinhala: 'ව්‍යංජන',
        imageAsset: 'assets/images/drawing_kid.png',
      ),
      QuizQuestion(
        questionSinhala: 'ශ්‍රී ලංකාවේ ජාතික ජනතාව කතා කරන ප්‍රධාන භාෂා?',
        questionEnglish: 'What are the main languages spoken in Sri Lanka?',
        options: [
          'සිංහල',
          'සිංහල හා දෙමළ',
          'ඉංග්‍රීසි',
          'සිංහල, දෙමළ, ඉංග්‍රීසි',
        ],
        correctIndex: 3,
        contextLabelSinhala: 'ශ්‍රී ලංකා සංස්කෘතිය',
        imageAsset: 'assets/images/treasure_box.png',
      ),
      QuizQuestion(
        questionSinhala: 'ජනකතාවේ "කොට්ටාල ගේ" කතාව ගැන?',
        questionEnglish: 'What is the folk tale "Kottala Ge" about?',
        options: ['රජෙකු ගැන', 'ළමා ගැන', 'ගජ රජු ගැන', 'ජලය ගැන'],
        correctIndex: 0,
        contextLabelSinhala: 'ජනකතා',
        imageAsset: 'assets/images/learning_pets.png',
      ),
      QuizQuestion(
        questionSinhala: 'ශ්‍රී ලංකාවේ ජාතික ජල ශ්‍රී ය කුමක්ද?',
        questionEnglish: 'What is the national bird of Sri Lanka?',
        options: ['ලිහිණියා', 'ජාතික ජලා ශ්‍රී ය', 'ඩොඩු', 'රාජාලියා'],
        correctIndex: 3,
        contextLabelSinhala: 'ශ්‍රී ලංකා සංස්කෘතිය',
        imageAsset: 'assets/images/study_room.png',
      ),
      QuizQuestion(
        questionSinhala: 'සිංහල හෝඩියේ කීයද?',
        questionEnglish: 'How many letters are in the Sinhala alphabet?',
        options: ['36', '54', '48', '60'],
        correctIndex: 1,
        contextLabelSinhala: 'සිංහල හෝඩිය',
        imageAsset: 'assets/images/learning_kid.png',
      ),
      QuizQuestion(
        questionSinhala: '"ධ" යනු සිංහල හෝඩියේ කුමන ස්ථානයේ ලේඛනයක්ද?',
        questionEnglish: 'Which category does "ධ" belong to in Sinhala?',
        options: ['ස්වර', 'ව්‍යංජන', 'ශ්‍රව්‍ය', 'නාදය'],
        correctIndex: 1,
        contextLabelSinhala: 'ව්‍යංජන',
        imageAsset: 'assets/images/drawing_kid.png',
      ),
      QuizQuestion(
        questionSinhala: 'ශ්‍රී ලංකාවේ රාජ්‍ය ආගම කුමක්ද?',
        questionEnglish: 'What is the state religion of Sri Lanka?',
        options: ['ක‍්‍රිස්තියානිය', 'ඉස්ලාම්', 'හින්දු', 'බෞද්ධ'],
        correctIndex: 3,
        contextLabelSinhala: 'ශ්‍රී ලංකා සංස්කෘතිය',
        imageAsset: 'assets/images/treasure_box.png',
      ),
      QuizQuestion(
        questionSinhala: '"සේව" යනු කිනම් ක‍්‍රියාවද?',
        questionEnglish: 'What does "sewa" mean in Sinhala?',
        options: ['ආදරය', 'ශ්‍රමය', 'සේවය', 'ශ්‍රේෂ්ඨ'],
        correctIndex: 2,
        contextLabelSinhala: 'සිංහල භාෂාව',
        imageAsset: 'assets/images/learning_pets.png',
      ),
    ],
  ),
];
