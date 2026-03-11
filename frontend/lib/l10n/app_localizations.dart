import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Taabat'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **' Sign Up'**
  String get signUp;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to Taabat'**
  String get welcomeBack;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your Taabat account'**
  String get createAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@email.com'**
  String get emailHint;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmail;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validEmail;

  /// No description provided for @emailAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'Email is already used, try another email'**
  String get emailAlreadyUsed;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// No description provided for @password8Chars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get password8Chars;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get reEnterPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterName;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select your role'**
  String get selectRole;

  /// No description provided for @selectRoleError.
  ///
  /// In en, this message translates to:
  /// **'Please select a role'**
  String get selectRoleError;

  /// No description provided for @farmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get farmer;

  /// No description provided for @shopper.
  ///
  /// In en, this message translates to:
  /// **'Shopper'**
  String get shopper;

  /// No description provided for @shareLocation.
  ///
  /// In en, this message translates to:
  /// **'Share my GPS location to show nearby farms and services.'**
  String get shareLocation;

  /// No description provided for @locationSaved.
  ///
  /// In en, this message translates to:
  /// **'Location saved'**
  String get locationSaved;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personalData;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Manage Permissions'**
  String get permissions;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @addFarm.
  ///
  /// In en, this message translates to:
  /// **'Add Farm'**
  String get addFarm;

  /// No description provided for @farmAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Adding Farm Successfully'**
  String get farmAddedSuccess;

  /// No description provided for @editFarm.
  ///
  /// In en, this message translates to:
  /// **'Edit Farm'**
  String get editFarm;

  /// No description provided for @saveFarm.
  ///
  /// In en, this message translates to:
  /// **'Save Farm'**
  String get saveFarm;

  /// No description provided for @farmName.
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get farmName;

  /// No description provided for @farmNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Farm name is required'**
  String get farmNameRequired;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location description (City, Area, Street) *'**
  String get location;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get locationRequired;

  /// No description provided for @selectFruits.
  ///
  /// In en, this message translates to:
  /// **'Select Fruits'**
  String get selectFruits;

  /// No description provided for @visibleToShoppers.
  ///
  /// In en, this message translates to:
  /// **'Visible to shoppers'**
  String get visibleToShoppers;

  /// No description provided for @disableArchiveFarm.
  ///
  /// In en, this message translates to:
  /// **'Disable to archive the farm'**
  String get disableArchiveFarm;

  /// No description provided for @selectAtLeastOneFruit.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one fruit'**
  String get selectAtLeastOneFruit;

  /// No description provided for @noFarmsYet.
  ///
  /// In en, this message translates to:
  /// **'No farms to manage yet'**
  String get noFarmsYet;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get deleteFailed;

  /// No description provided for @failedLoadingFarms.
  ///
  /// In en, this message translates to:
  /// **'Failed to load Farms'**
  String get failedLoadingFarms;

  /// No description provided for @farmLocationGps.
  ///
  /// In en, this message translates to:
  /// **'Farm Location (GPS) *'**
  String get farmLocationGps;

  /// No description provided for @getting.
  ///
  /// In en, this message translates to:
  /// **'Getting...'**
  String get getting;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @pickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick on Map'**
  String get pickOnMap;

  /// No description provided for @noLocationSelected.
  ///
  /// In en, this message translates to:
  /// **'No location selected'**
  String get noLocationSelected;

  /// No description provided for @farmGpsSet.
  ///
  /// In en, this message translates to:
  /// **'Farm GPS set'**
  String get farmGpsSet;

  /// No description provided for @noGpsSelected.
  ///
  /// In en, this message translates to:
  /// **'No GPS selected yet'**
  String get noGpsSelected;

  /// No description provided for @pleaseSetFarmGps.
  ///
  /// In en, this message translates to:
  /// **'Please set farm GPS (Current location or Pick on map)'**
  String get pleaseSetFarmGps;

  /// No description provided for @couldNotGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not get current location'**
  String get couldNotGetLocation;

  /// No description provided for @shareMyGPSLocation.
  ///
  /// In en, this message translates to:
  /// **'Share my GPS location to show nearby farms and services.'**
  String get shareMyGPSLocation;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @pleaseEnableLocation.
  ///
  /// In en, this message translates to:
  /// **'Please enable location permission to continue'**
  String get pleaseEnableLocation;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed:'**
  String get registrationFailed;

  /// No description provided for @gps.
  ///
  /// In en, this message translates to:
  /// **'GPS:'**
  String get gps;

  /// No description provided for @pickFarmLocation.
  ///
  /// In en, this message translates to:
  /// **'Pick Farm Location'**
  String get pickFarmLocation;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @unableLoadingWeather.
  ///
  /// In en, this message translates to:
  /// **'Unable to load weather right now.'**
  String get unableLoadingWeather;

  /// No description provided for @basedOnYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Based on your location'**
  String get basedOnYourLocation;

  /// No description provided for @farmWeather.
  ///
  /// In en, this message translates to:
  /// **'Farm weather'**
  String get farmWeather;

  /// No description provided for @uvIndex.
  ///
  /// In en, this message translates to:
  /// **'UV'**
  String get uvIndex;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @rain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get rain;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @classifyFruit.
  ///
  /// In en, this message translates to:
  /// **'Classify Fruit'**
  String get classifyFruit;

  /// No description provided for @classifyFruitDesc.
  ///
  /// In en, this message translates to:
  /// **'Identify fruit type using AI-powered camera'**
  String get classifyFruitDesc;

  /// No description provided for @noFruitAdded.
  ///
  /// In en, this message translates to:
  /// **'No fruits added'**
  String get noFruitAdded;

  /// No description provided for @manageFarm.
  ///
  /// In en, this message translates to:
  /// **'Manage Farm'**
  String get manageFarm;

  /// No description provided for @manageFarmDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage all your farms from here'**
  String get manageFarmDesc;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @viewHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'View harvest and activity history'**
  String get viewHistoryDesc;

  /// No description provided for @sampleLocation.
  ///
  /// In en, this message translates to:
  /// **'Your City'**
  String get sampleLocation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @chooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose Avatar'**
  String get chooseAvatar;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get nameTooShort;

  /// No description provided for @newPasswordOptional.
  ///
  /// In en, this message translates to:
  /// **'New Password (optional)'**
  String get newPasswordOptional;

  /// No description provided for @cameraAccess.
  ///
  /// In en, this message translates to:
  /// **'Camera Access'**
  String get cameraAccess;

  /// No description provided for @locationSharing.
  ///
  /// In en, this message translates to:
  /// **'Location Sharing'**
  String get locationSharing;

  /// No description provided for @profileupdatedsuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated Successfully'**
  String get profileupdatedsuccess;

  /// No description provided for @exploreFarms.
  ///
  /// In en, this message translates to:
  /// **'Explore Farms'**
  String get exploreFarms;

  /// No description provided for @noFarmsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No farms available yet'**
  String get noFarmsAvailable;

  /// No description provided for @unnamedFarm.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Farm'**
  String get unnamedFarm;

  /// No description provided for @noLocation.
  ///
  /// In en, this message translates to:
  /// **'No location'**
  String get noLocation;

  /// No description provided for @classifyDescription.
  ///
  /// In en, this message translates to:
  /// **'Identify fruit type using AI & Camera'**
  String get classifyDescription;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @unknownFarm.
  ///
  /// In en, this message translates to:
  /// **'Unknown Farm'**
  String get unknownFarm;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown location'**
  String get unknownLocation;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @banana.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get banana;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @kiwi.
  ///
  /// In en, this message translates to:
  /// **'Kiwi'**
  String get kiwi;

  /// No description provided for @grapes.
  ///
  /// In en, this message translates to:
  /// **'Grapes'**
  String get grapes;

  /// No description provided for @strawberry.
  ///
  /// In en, this message translates to:
  /// **'Strawberry'**
  String get strawberry;

  /// No description provided for @lemon.
  ///
  /// In en, this message translates to:
  /// **'Lemon'**
  String get lemon;

  /// No description provided for @majdoolDates.
  ///
  /// In en, this message translates to:
  /// **'Majdool Dates'**
  String get majdoolDates;

  /// No description provided for @asilDates.
  ///
  /// In en, this message translates to:
  /// **'Asil Dates'**
  String get asilDates;

  /// No description provided for @sukaryDates.
  ///
  /// In en, this message translates to:
  /// **'Sukary Dates'**
  String get sukaryDates;

  /// No description provided for @nutritionInformation.
  ///
  /// In en, this message translates to:
  /// **'Nutrition information · 100 g'**
  String get nutritionInformation;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @energyDescription.
  ///
  /// In en, this message translates to:
  /// **'Approximate energy in 100 g of {fruit}.'**
  String energyDescription(Object fruit);

  /// No description provided for @dailyIntake.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of a 2000 kcal daily intake'**
  String dailyIntake(Object percent);

  /// No description provided for @macronutrients.
  ///
  /// In en, this message translates to:
  /// **'Macronutrients'**
  String get macronutrients;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @totalFat.
  ///
  /// In en, this message translates to:
  /// **'Total Fat'**
  String get totalFat;

  /// No description provided for @carbsDescription.
  ///
  /// In en, this message translates to:
  /// **'Main energy source'**
  String get carbsDescription;

  /// No description provided for @proteinDescription.
  ///
  /// In en, this message translates to:
  /// **'Supports muscles'**
  String get proteinDescription;

  /// No description provided for @fatDescription.
  ///
  /// In en, this message translates to:
  /// **'Overall fat amount'**
  String get fatDescription;

  /// No description provided for @fiberSugar.
  ///
  /// In en, this message translates to:
  /// **'Fiber & Sugar'**
  String get fiberSugar;

  /// No description provided for @fiber.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get fiber;

  /// No description provided for @sugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get sugar;

  /// No description provided for @fiberDescription.
  ///
  /// In en, this message translates to:
  /// **'Helps digestion & satiety.'**
  String get fiberDescription;

  /// No description provided for @sugarDescription.
  ///
  /// In en, this message translates to:
  /// **'Natural sugar content.'**
  String get sugarDescription;

  /// No description provided for @micronutrients.
  ///
  /// In en, this message translates to:
  /// **'Micronutrients'**
  String get micronutrients;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @calcium.
  ///
  /// In en, this message translates to:
  /// **'Calcium'**
  String get calcium;

  /// No description provided for @iron.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get iron;

  /// No description provided for @nutritionDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'* All values are approximate and based on a 100 g portion.'**
  String get nutritionDisclaimer;

  /// No description provided for @noNutritionData.
  ///
  /// In en, this message translates to:
  /// **'No nutrition data found for {fruit}'**
  String noNutritionData(Object fruit);

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get loadingError;

  /// No description provided for @gram.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get gram;

  /// No description provided for @milligram.
  ///
  /// In en, this message translates to:
  /// **'mg'**
  String get milligram;

  /// No description provided for @kilocalorie.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kilocalorie;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'%'**
  String get percent;

  /// No description provided for @millimeter.
  ///
  /// In en, this message translates to:
  /// **'millimeter'**
  String get millimeter;

  /// No description provided for @kiloMeterPerHour.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get kiloMeterPerHour;

  /// No description provided for @noCameraFound.
  ///
  /// In en, this message translates to:
  /// **'No camera available on this device'**
  String get noCameraFound;

  /// No description provided for @errorAccessingCamera.
  ///
  /// In en, this message translates to:
  /// **'Error accessing camera:'**
  String get errorAccessingCamera;

  /// No description provided for @errorWhileScanning.
  ///
  /// In en, this message translates to:
  /// **'Error while scanning'**
  String get errorWhileScanning;

  /// No description provided for @errorWhileUploading.
  ///
  /// In en, this message translates to:
  /// **'Error whilr uploading'**
  String get errorWhileUploading;

  /// No description provided for @fruitCondition.
  ///
  /// In en, this message translates to:
  /// **'Fruit Condition'**
  String get fruitCondition;

  /// No description provided for @spotsFound.
  ///
  /// In en, this message translates to:
  /// **'Small spots found near plant'**
  String get spotsFound;

  /// No description provided for @fruitStructureIsStable.
  ///
  /// In en, this message translates to:
  /// **'Fruit structure is stable'**
  String get fruitStructureIsStable;

  /// No description provided for @unableDetectingFruitClearly.
  ///
  /// In en, this message translates to:
  /// **'Unable to detect fruit clearly, try again'**
  String get unableDetectingFruitClearly;

  /// No description provided for @seeDetailInformation.
  ///
  /// In en, this message translates to:
  /// **'See Detail Information'**
  String get seeDetailInformation;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @placeFruitInsideFrame.
  ///
  /// In en, this message translates to:
  /// **'Place the fruit inside the frame.'**
  String get placeFruitInsideFrame;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied'**
  String get cameraPermissionDenied;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
