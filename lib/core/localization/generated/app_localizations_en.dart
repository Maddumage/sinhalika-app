// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sinhalika';

  @override
  String get splashTagline => 'Learn today for a better tomorrow';

  @override
  String get splashLoadingLabel => 'LOADING';

  @override
  String get splashLoadingSubtitle => 'Getting things ready...';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingCtaNext => 'Next';

  @override
  String get onboardingCtaGetStarted => 'Get Started';

  @override
  String get onboardingPage1Tag => 'AYUBOWAN';

  @override
  String get onboardingPage1Title => 'Explore the\n';

  @override
  String get onboardingPage1TitleBlue => 'Magic of\nSinhala';

  @override
  String get onboardingPage1Body =>
      'Start a journey through stories, games, and traditional Sri Lankan culture.';

  @override
  String get onboardingPage2TitleBlue => 'Learning\nis Play';

  @override
  String get onboardingPage2Body =>
      'Master vocabulary and verbs through interactive games designed for kids.';

  @override
  String get onboardingPage3Title => 'Track Your\n';

  @override
  String get onboardingPage3TitleBlue => 'Adventure';

  @override
  String get onboardingPage3Body =>
      'Earn badges, level up, and celebrate your progress as you learn Sinhala.';

  @override
  String get onboardingStatsPointsLabel => 'POINTS';

  @override
  String get onboardingStatsPointsValue => '1,250';

  @override
  String get onboardingStatsStreakLabel => 'STREAK';

  @override
  String get onboardingStatsStreakValue => '7 Days';

  @override
  String get signInHeadline => 'Welcome.';

  @override
  String get signInSubtitle => 'Your Sinhala adventure is waiting for you.';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInContinueAsGuest => 'Continue as Guest';

  @override
  String get parentalDisclosureTitle => 'PARENTAL DISCLOSURE';

  @override
  String get parentalDisclosureBody =>
      'Sinhalika prioritizes your child\'s digital safety. We do not sell personal data or display third-party advertisements.';

  @override
  String get childSafetyPolicy => 'Child Safety Policy';

  @override
  String get navHome => 'Home';

  @override
  String get navLessons => 'Lessons';

  @override
  String get navGames => 'Games';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeGuestName => 'Explorer';

  @override
  String get homeLearnerName => 'Learner';

  @override
  String homeGreeting(String name) {
    return 'ආයුබෝවන්, $name!';
  }

  @override
  String get homeGreetingSubtitle => 'Ready to explore your heritage today?';

  @override
  String get homeGameOfDayChip => 'GAME OF THE DAY';

  @override
  String get homeGameOfDayTitle => 'The Lotus Collector';

  @override
  String get homeGameOfDayDescription =>
      'Match the Sinhala vowels with falling lotus flowers to win extra points!';

  @override
  String get homeGameOfDayPlayButton => 'Play Now';

  @override
  String get homeVowelsTitle => 'Vowels';

  @override
  String get homeVowelsSinhalaLabel => 'ස්වර (Swara)';

  @override
  String get homeConsonantsTitle => 'Consonants';

  @override
  String get homeConsonantsSinhalaLabel => 'ව්‍යංජන (Wyanjana)';

  @override
  String get homeDiscoverMoreTitle => 'Discover More';

  @override
  String get homeDiscoverMoreSeeAll => 'See All';

  @override
  String get homeDiscoverWords => 'Words';

  @override
  String get homeDiscoverVocabulary => 'Vocabulary';

  @override
  String get homeDiscoverPhrases => 'Phrases';

  @override
  String get homeDiscoverCulture => 'Culture';

  @override
  String get homeDailyQuestChip => 'DAILY QUEST';

  @override
  String get homeDailyQuestTitle => 'Greeting 5 People';

  @override
  String get homeDailyQuestDescription =>
      'Practice your Sinhala greetings with your family or friends today and earn the \"Lotus Badge\"!';

  @override
  String homeDailyQuestProgress(int done, int total) {
    return '$done of $total completed';
  }

  @override
  String get lessonsScreenTitle => 'Lessons';

  @override
  String get lessonsScreenSubheading => 'What would you like\nto learn today?';

  @override
  String get lessonCategoryAlphabetTitle => 'සිංහල හෝඩිය';

  @override
  String get lessonCategoryAlphabetSubtitle => 'Sinhala Alphabet';

  @override
  String get lessonCategoryNounsTitle => 'නාම පද';

  @override
  String get lessonCategoryNounsSubtitle => 'Nouns';

  @override
  String get lessonCategoryPhrasesTitle => 'වාක්‍ය';

  @override
  String get lessonCategoryPhrasesSubtitle => 'Phrases';

  @override
  String get hodiyaScreenTitle => 'සිංහල හෝඩිය';

  @override
  String get hodiyaBannerTag => 'අකුරු හදනාගමු';

  @override
  String get hodiyaBannerTitle => 'ලස්සන සිංහල\nහෝඩිය ඉගෙන ගමු';

  @override
  String get nounsScreenTitle => 'The Heritage Playroom';

  @override
  String get nounsBannerChip => 'VOCABULARY BUILDERS';

  @override
  String get nounsBannerTitle => 'Nouns';

  @override
  String get nounsBannerDescription =>
      'Learn everyday Sinhala nouns with pronunciation.';

  @override
  String get nounsListenButton => 'Listen';

  @override
  String get phrasesScreenTitle => 'Phrases (වාක්‍ය)';

  @override
  String get phrasesHeaderTitle => 'Let\'s talk!';

  @override
  String get phrasesHeaderSubtitle =>
      'Learn common Sinhala phrases for everyday fun.';

  @override
  String get phrasesCategoryGreeting => 'GREETING';

  @override
  String get phrasesCategoryPolite => 'POLITE';

  @override
  String get phrasesCategoryMorning => 'MORNING';

  @override
  String get phrasesCategoryDaily => 'DAILY';

  @override
  String get phrasesCategoryFarewell => 'FAREWELL';

  @override
  String get phrasesCategoryQuestion => 'QUESTION';

  @override
  String get phrasesRecordPracticeButton => 'Record Practice';

  @override
  String get phrasesTodayGoalTitle => 'Today\'s Goal';

  @override
  String get phrasesGoalComplete => '🌟 Goal complete! Amazing work!';

  @override
  String phrasesGoalRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# more phrases to reach your star!',
      one: '# more phrase to reach your star!',
    );
    return '$_temp0';
  }

  @override
  String get gamesScreenTitle => 'Games';

  @override
  String get gamesComingSoonTitle => 'Games Coming Soon';

  @override
  String get gamesComingSoonSubtitle =>
      'Fun vocabulary games are almost ready.';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get settingsGuestUserName => 'Guest User';

  @override
  String get settingsGuestSubtitle => 'Sign in to save progress';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsThemeModeSystem => 'System';

  @override
  String get settingsThemeModeLight => 'Light';

  @override
  String get settingsThemeModeDark => 'Dark';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsLanguageLabel => 'App Language';

  @override
  String get settingsLanguageOptionEn => 'English';

  @override
  String get settingsLanguageOptionSi => 'සිංහල';

  @override
  String get settingsSectionPreferences => 'Preferences';

  @override
  String get settingsNotificationsLabel => 'Notifications';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsAppVersionLabel => 'App Version';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsSignOutLabel => 'Sign Out';

  @override
  String get settingsSignOutDialogTitle => 'Sign Out';

  @override
  String get settingsSignOutConfirmMessage =>
      'Are you sure you want to sign out?';

  @override
  String get settingsSignOutCancel => 'Cancel';

  @override
  String get settingsSignOutConfirm => 'Sign Out';
}
