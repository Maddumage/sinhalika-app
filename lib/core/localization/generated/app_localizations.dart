import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Sinhalika'**
  String get appName;

  /// Tagline shown on the splash screen
  ///
  /// In en, this message translates to:
  /// **'Learn today for a better tomorrow'**
  String get splashTagline;

  /// Loading label on splash screen
  ///
  /// In en, this message translates to:
  /// **'LOADING'**
  String get splashLoadingLabel;

  /// Loading subtitle on splash screen
  ///
  /// In en, this message translates to:
  /// **'Getting things ready...'**
  String get splashLoadingSubtitle;

  /// Skip button on onboarding
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Next CTA on onboarding pages 1 and 2
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingCtaNext;

  /// CTA on the last onboarding page
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingCtaGetStarted;

  /// Title on the onboarding language picker page
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get onboardingLangTitle;

  /// Subtitle on the onboarding language picker page
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in Settings'**
  String get onboardingLangSubtitle;

  /// Title on the onboarding mode picker page
  ///
  /// In en, this message translates to:
  /// **'Do you know Sinhala?'**
  String get onboardingModeTitle;

  /// Subtitle on the onboarding mode picker page
  ///
  /// In en, this message translates to:
  /// **'This helps us personalise your experience'**
  String get onboardingModeSubtitle;

  /// Native mode option title in onboarding
  ///
  /// In en, this message translates to:
  /// **'Yes, I know Sinhala'**
  String get onboardingModeNativeTitle;

  /// Native mode option subtitle in onboarding
  ///
  /// In en, this message translates to:
  /// **'Show me content in Sinhala first'**
  String get onboardingModeNativeSubtitle;

  /// Learner mode option title in onboarding
  ///
  /// In en, this message translates to:
  /// **'I’m learning Sinhala'**
  String get onboardingModeLearnerTitle;

  /// Learner mode option subtitle in onboarding
  ///
  /// In en, this message translates to:
  /// **'Guide me with translations and hints'**
  String get onboardingModeLearnerSubtitle;

  /// Tag chip on onboarding page 1
  ///
  /// In en, this message translates to:
  /// **'AYUBOWAN'**
  String get onboardingPage1Tag;

  /// White part of title on onboarding page 1
  ///
  /// In en, this message translates to:
  /// **'Explore the\n'**
  String get onboardingPage1Title;

  /// Blue part of title on onboarding page 1
  ///
  /// In en, this message translates to:
  /// **'Magic of\nSinhala'**
  String get onboardingPage1TitleBlue;

  /// Body text on onboarding page 1
  ///
  /// In en, this message translates to:
  /// **'Start a journey through stories, games, and traditional Sri Lankan culture.'**
  String get onboardingPage1Body;

  /// Blue title on onboarding page 2
  ///
  /// In en, this message translates to:
  /// **'Learning\nis Play'**
  String get onboardingPage2TitleBlue;

  /// Body text on onboarding page 2
  ///
  /// In en, this message translates to:
  /// **'Master vocabulary and verbs through interactive games designed for kids.'**
  String get onboardingPage2Body;

  /// White part of title on onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'Track Your\n'**
  String get onboardingPage3Title;

  /// Blue part of title on onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get onboardingPage3TitleBlue;

  /// Body text on onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'Earn badges, level up, and celebrate your progress as you learn Sinhala.'**
  String get onboardingPage3Body;

  /// Points stat label on onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'POINTS'**
  String get onboardingStatsPointsLabel;

  /// Points stat value on onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'1,250'**
  String get onboardingStatsPointsValue;

  /// Streak stat label on onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'STREAK'**
  String get onboardingStatsStreakLabel;

  /// Streak stat value on onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'7 Days'**
  String get onboardingStatsStreakValue;

  /// Headline on sign-in screen
  ///
  /// In en, this message translates to:
  /// **'Welcome.'**
  String get signInHeadline;

  /// Subtitle on sign-in screen
  ///
  /// In en, this message translates to:
  /// **'Your Sinhala adventure is waiting for you.'**
  String get signInSubtitle;

  /// Google sign-in button label
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// Guest sign-in button label
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get signInContinueAsGuest;

  /// Parental disclosure box heading
  ///
  /// In en, this message translates to:
  /// **'PARENTAL DISCLOSURE'**
  String get parentalDisclosureTitle;

  /// Parental disclosure body text
  ///
  /// In en, this message translates to:
  /// **'Sinhalika prioritizes your child\'s digital safety. We do not sell personal data or display third-party advertisements.'**
  String get parentalDisclosureBody;

  /// Child safety policy link label
  ///
  /// In en, this message translates to:
  /// **'Child Safety Policy'**
  String get childSafetyPolicy;

  /// Bottom nav Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav Lessons tab label
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get navLessons;

  /// Bottom nav Games tab label
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get navGames;

  /// Bottom nav Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Fallback name for anonymous users on home screen
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get homeGuestName;

  /// Fallback name for signed-in users with no display name
  ///
  /// In en, this message translates to:
  /// **'Learner'**
  String get homeLearnerName;

  /// Greeting on home screen
  ///
  /// In en, this message translates to:
  /// **'ආයුබෝවන්, {name}!'**
  String homeGreeting(String name);

  /// Subtitle below greeting on home screen
  ///
  /// In en, this message translates to:
  /// **'Ready to explore your heritage today?'**
  String get homeGreetingSubtitle;

  /// Game of the day chip label
  ///
  /// In en, this message translates to:
  /// **'GAME OF THE DAY'**
  String get homeGameOfDayChip;

  /// Game of the day title
  ///
  /// In en, this message translates to:
  /// **'The Lotus Collector'**
  String get homeGameOfDayTitle;

  /// Game of the day description
  ///
  /// In en, this message translates to:
  /// **'Match the Sinhala vowels with falling lotus flowers to win extra points!'**
  String get homeGameOfDayDescription;

  /// Play Now button on game of the day card
  ///
  /// In en, this message translates to:
  /// **'Play Now'**
  String get homeGameOfDayPlayButton;

  /// Vowels section title on home screen
  ///
  /// In en, this message translates to:
  /// **'Vowels'**
  String get homeVowelsTitle;

  /// Sinhala label for vowels section
  ///
  /// In en, this message translates to:
  /// **'ස්වර (Swara)'**
  String get homeVowelsSinhalaLabel;

  /// Consonants section title on home screen
  ///
  /// In en, this message translates to:
  /// **'Consonants'**
  String get homeConsonantsTitle;

  /// Sinhala label for consonants section
  ///
  /// In en, this message translates to:
  /// **'ව්‍යංජන (Wyanjana)'**
  String get homeConsonantsSinhalaLabel;

  /// Discover more section heading on home screen
  ///
  /// In en, this message translates to:
  /// **'Discover More'**
  String get homeDiscoverMoreTitle;

  /// See All link on home screen
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get homeDiscoverMoreSeeAll;

  /// Words discover grid item
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get homeDiscoverWords;

  /// Vocabulary discover grid item
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get homeDiscoverVocabulary;

  /// Phrases discover grid item
  ///
  /// In en, this message translates to:
  /// **'Phrases'**
  String get homeDiscoverPhrases;

  /// Culture discover grid item
  ///
  /// In en, this message translates to:
  /// **'Culture'**
  String get homeDiscoverCulture;

  /// Daily quest chip label on home screen
  ///
  /// In en, this message translates to:
  /// **'DAILY QUEST'**
  String get homeDailyQuestChip;

  /// Daily quest title
  ///
  /// In en, this message translates to:
  /// **'Greeting 5 People'**
  String get homeDailyQuestTitle;

  /// Daily quest description
  ///
  /// In en, this message translates to:
  /// **'Practice your Sinhala greetings with your family or friends today and earn the \"Lotus Badge\"!'**
  String get homeDailyQuestDescription;

  /// Daily quest progress label
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} completed'**
  String homeDailyQuestProgress(int done, int total);

  /// Lessons hub screen title
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessonsScreenTitle;

  /// Subheading on lessons hub screen
  ///
  /// In en, this message translates to:
  /// **'What would you like\nto learn today?'**
  String get lessonsScreenSubheading;

  /// Alphabet category card title
  ///
  /// In en, this message translates to:
  /// **'සිංහල හෝඩිය'**
  String get lessonCategoryAlphabetTitle;

  /// Alphabet category card subtitle
  ///
  /// In en, this message translates to:
  /// **'Sinhala Alphabet'**
  String get lessonCategoryAlphabetSubtitle;

  /// Nouns category card title
  ///
  /// In en, this message translates to:
  /// **'නාම පද'**
  String get lessonCategoryNounsTitle;

  /// Nouns category card subtitle
  ///
  /// In en, this message translates to:
  /// **'Nouns'**
  String get lessonCategoryNounsSubtitle;

  /// Phrases category card title
  ///
  /// In en, this message translates to:
  /// **'වාක්‍ය'**
  String get lessonCategoryPhrasesTitle;

  /// Phrases category card subtitle
  ///
  /// In en, this message translates to:
  /// **'Phrases'**
  String get lessonCategoryPhrasesSubtitle;

  /// Quiz category card title
  ///
  /// In en, this message translates to:
  /// **'ප්‍රශ්න පතුය'**
  String get lessonCategoryQuizTitle;

  /// Quiz category card subtitle
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get lessonCategoryQuizSubtitle;

  /// Hodiya screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'සිංහල හෝඩිය'**
  String get hodiyaScreenTitle;

  /// Hodiya banner tag label
  ///
  /// In en, this message translates to:
  /// **'අකුරු හදනාගමු'**
  String get hodiyaBannerTag;

  /// Hodiya banner title
  ///
  /// In en, this message translates to:
  /// **'ලස්සන සිංහල\nහෝඩිය ඉගෙන ගමු'**
  String get hodiyaBannerTitle;

  /// Nouns screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'The Heritage Playroom'**
  String get nounsScreenTitle;

  /// Nouns banner chip label
  ///
  /// In en, this message translates to:
  /// **'VOCABULARY BUILDERS'**
  String get nounsBannerChip;

  /// Nouns banner title
  ///
  /// In en, this message translates to:
  /// **'Nouns'**
  String get nounsBannerTitle;

  /// Nouns banner description
  ///
  /// In en, this message translates to:
  /// **'Learn everyday Sinhala nouns with pronunciation.'**
  String get nounsBannerDescription;

  /// Listen button on noun cards
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get nounsListenButton;

  /// Phrases screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Phrases (වාක්‍ය)'**
  String get phrasesScreenTitle;

  /// Phrases screen header title
  ///
  /// In en, this message translates to:
  /// **'Let\'s talk!'**
  String get phrasesHeaderTitle;

  /// Phrases screen header subtitle
  ///
  /// In en, this message translates to:
  /// **'Learn common Sinhala phrases for everyday fun.'**
  String get phrasesHeaderSubtitle;

  /// Greeting category chip
  ///
  /// In en, this message translates to:
  /// **'GREETING'**
  String get phrasesCategoryGreeting;

  /// Polite category chip
  ///
  /// In en, this message translates to:
  /// **'POLITE'**
  String get phrasesCategoryPolite;

  /// Morning category chip
  ///
  /// In en, this message translates to:
  /// **'MORNING'**
  String get phrasesCategoryMorning;

  /// Daily category chip
  ///
  /// In en, this message translates to:
  /// **'DAILY'**
  String get phrasesCategoryDaily;

  /// Farewell category chip
  ///
  /// In en, this message translates to:
  /// **'FAREWELL'**
  String get phrasesCategoryFarewell;

  /// Question category chip
  ///
  /// In en, this message translates to:
  /// **'QUESTION'**
  String get phrasesCategoryQuestion;

  /// Record practice button on phrase cards
  ///
  /// In en, this message translates to:
  /// **'Record Practice'**
  String get phrasesRecordPracticeButton;

  /// Today's goal banner title on phrases screen
  ///
  /// In en, this message translates to:
  /// **'Today\'s Goal'**
  String get phrasesTodayGoalTitle;

  /// Goal complete message on phrases screen
  ///
  /// In en, this message translates to:
  /// **'🌟 Goal complete! Amazing work!'**
  String get phrasesGoalComplete;

  /// Goal remaining message on phrases screen
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{# more phrase to reach your star!} other{# more phrases to reach your star!}}'**
  String phrasesGoalRemaining(int count);

  /// Games screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get gamesScreenTitle;

  /// Games coming soon title
  ///
  /// In en, this message translates to:
  /// **'Games Coming Soon'**
  String get gamesComingSoonTitle;

  /// Games coming soon subtitle
  ///
  /// In en, this message translates to:
  /// **'Fun vocabulary games are almost ready.'**
  String get gamesComingSoonSubtitle;

  /// Settings screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenTitle;

  /// Guest user name in settings
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get settingsGuestUserName;

  /// Guest user subtitle in settings
  ///
  /// In en, this message translates to:
  /// **'Sign in to save progress'**
  String get settingsGuestSubtitle;

  /// Appearance section header in settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// Theme row label in settings
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeLabel;

  /// System theme mode option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeModeSystem;

  /// Light theme mode option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeModeLight;

  /// Dark theme mode option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeModeDark;

  /// Language section header in settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// App language row label in settings
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsLanguageLabel;

  /// English language option in settings
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageOptionEn;

  /// Sinhala language option in settings
  ///
  /// In en, this message translates to:
  /// **'සිංහල'**
  String get settingsLanguageOptionSi;

  /// Preferences section header in settings
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsSectionPreferences;

  /// Notifications toggle label in settings
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsLabel;

  /// About section header in settings
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// App version label in settings
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get settingsAppVersionLabel;

  /// Account section header in settings
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSectionAccount;

  /// Sign out label in settings
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsSignOutLabel;

  /// Sign out confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsSignOutDialogTitle;

  /// Sign out confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get settingsSignOutConfirmMessage;

  /// Cancel button in sign out dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsSignOutCancel;

  /// Confirm sign out button in dialog
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsSignOutConfirm;

  /// Celebrations screen AppBar title (Sinhala)
  ///
  /// In en, this message translates to:
  /// **'සැමරුම්'**
  String get celebrationsScreenTitle;

  /// Celebrations screen title (English)
  ///
  /// In en, this message translates to:
  /// **'Celebrations'**
  String get celebrationsScreenTitleEn;

  /// Banner chip on celebrations screen
  ///
  /// In en, this message translates to:
  /// **'CULTURAL HERITAGE'**
  String get celebrationsBannerChip;

  /// Banner description on celebrations screen
  ///
  /// In en, this message translates to:
  /// **'Discover Sri Lanka\'s vibrant festivals and cultural traditions.'**
  String get celebrationsBannerDescription;

  /// Explore button label on celebration cards
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get celebrationsExploreLabel;

  /// Fun facts badge on celebration cards
  ///
  /// In en, this message translates to:
  /// **'{count} fun facts'**
  String celebrationsFunFacts(int count);

  /// Activity CTA heading in celebration detail sheet
  ///
  /// In en, this message translates to:
  /// **'Try at Home!'**
  String get celebrationsTryAtHome;

  /// Fun facts section heading in celebration detail sheet
  ///
  /// In en, this message translates to:
  /// **'Fun Facts 🌟'**
  String get celebrationsFunFactsTitle;

  /// Janaktha Ekathuwa screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'ජනකතා එකතුව'**
  String get janakthaScreenTitle;

  /// Banner chip on Janaktha screen
  ///
  /// In en, this message translates to:
  /// **'FOLK TALES'**
  String get janakthaBannerChip;

  /// Stories count on Janaktha banner
  ///
  /// In en, this message translates to:
  /// **'{count} stories to explore'**
  String janakthaStoriesCount(int count);

  /// Featured section label on Janaktha screen
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get janakthaFeaturedLabel;

  /// All stories section label on Janaktha screen
  ///
  /// In en, this message translates to:
  /// **'All Stories'**
  String get janakthaAllStoriesLabel;

  /// Read now CTA on featured story card
  ///
  /// In en, this message translates to:
  /// **'Read Now →'**
  String get janakthaReadNow;

  /// Listen to full story button on story details screen
  ///
  /// In en, this message translates to:
  /// **'Listen to Full Story'**
  String get storyDetailsListenFull;

  /// Stop listening button on story details screen
  ///
  /// In en, this message translates to:
  /// **'Stop Listening'**
  String get storyDetailsStopListening;

  /// Reading progress label on story details screen
  ///
  /// In en, this message translates to:
  /// **'Reading Progress'**
  String get storyDetailsReadingProgress;

  /// Hint text on story details screen
  ///
  /// In en, this message translates to:
  /// **'Tap a paragraph to hear it read aloud'**
  String get storyDetailsTapHint;

  /// Moral section title on story details screen
  ///
  /// In en, this message translates to:
  /// **'Moral of the Story'**
  String get storyDetailsMoralTitle;

  /// Minutes read label on story details
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String storyDetailsMinRead(int minutes);

  /// Parts count label on story details
  ///
  /// In en, this message translates to:
  /// **'{count} parts'**
  String storyDetailsParts(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
