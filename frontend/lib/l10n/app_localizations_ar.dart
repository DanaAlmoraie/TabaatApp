// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'طابت';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => ' إنشاء حساب';

  @override
  String get welcomeBack => 'مرحباً بعودتك إلى طابت';

  @override
  String get hello => 'مرحباً';

  @override
  String get createAccount => 'أنشئ حسابك في طابت';

  @override
  String get home => 'الرئيسية';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'name@email.com';

  @override
  String get enterEmail => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get validEmail => 'بريد إلكتروني غير صالح';

  @override
  String get emailAlreadyUsed => 'البريد الإلكتروني مستخدم بالفعل، حاول استخدام بريد إلكتروني آخر';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get newPassword => 'كلمة مرور جديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordsNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get password8Chars => 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get forgotPassword => 'هل نسيت كلمة السر؟';

  @override
  String get reEnterPassword => 'أعد إدخال كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterFullName => 'أدخل اسمك الكامل';

  @override
  String get enterName => 'يرجى إدخال الاسم';

  @override
  String get role => 'الدور';

  @override
  String get selectRole => 'اختر الدور';

  @override
  String get selectRoleError => 'يرجى اختيار الدور';

  @override
  String get farmer => 'مزارع';

  @override
  String get shopper => 'متسوق';

  @override
  String get shareLocation => 'مشاركة موقعي لعرض المزارع والخدمات القريبة';

  @override
  String get locationSaved => 'تم حفظ الموقع';

  @override
  String get noAccount => ' ليس لديك حساب؟';

  @override
  String get haveAccount => 'لديك حساب بالفعل؟';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get personalData => 'البيانات الشخصية';

  @override
  String get permissions => 'الصلاحيات';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get language => 'اللغة';

  @override
  String get addFarm => 'إضافة مزرعة';

  @override
  String get farmAddedSuccess => 'تم أضافة المزرعة بنجاح';

  @override
  String get editFarm => 'تعديل مزرعة';

  @override
  String get saveFarm => 'حفظ المزرعة';

  @override
  String get farmName => 'اسم المزرعة';

  @override
  String get farmNameRequired => 'اسم المزرعة مطلوب';

  @override
  String get location => 'وصف الموقع (المدينة، الحي، الشارع) *';

  @override
  String get locationRequired => 'الموقع مطلوب';

  @override
  String get selectFruits => 'اختر الفواكه';

  @override
  String get visibleToShoppers => 'مرئية للمتسوقين';

  @override
  String get disableArchiveFarm => 'إيقافها يؤدي لأرشفة المزرعة';

  @override
  String get selectAtLeastOneFruit => 'يرجى اختيار فاكهة واحدة على الأقل';

  @override
  String get noFarmsYet => 'لا توجد مزارع حتى الآن';

  @override
  String get deleteFailed => 'فشل الحذف';

  @override
  String get failedLoadingFarms => 'فشل تحميل المزارع';

  @override
  String get farmLocationGps => 'موقع المزرعة (GPS) *';

  @override
  String get getting => 'جاري التحديد...';

  @override
  String get currentLocation => 'موقعي الحالي';

  @override
  String get pickOnMap => 'تحديد من الخريطة';

  @override
  String get noLocationSelected => 'لم يتم اختيار موقع';

  @override
  String get farmGpsSet => 'تم تحديد موقع المزرعة';

  @override
  String get noGpsSelected => 'لم يتم تحديد موقع GPS بعد';

  @override
  String get pleaseSetFarmGps => 'يرجى تحديد موقع المزرعة (الموقع الحالي أو اختيار من الخريطة)';

  @override
  String get couldNotGetLocation => 'تعذر الحصول على الموقع الحالي';

  @override
  String get shareMyGPSLocation => 'شارك موقعي عبر نظام تحديد المواقع العالمي (GPS) لعرض المزارع والخدمات القريبة.';

  @override
  String get locationPermissionDenied => 'تم رفض صلاحية الموقع';

  @override
  String get pleaseEnableLocation => 'يرجى تفعيل إذن الوصول إلى الموقع للمتابعة';

  @override
  String get registrationFailed => 'فشل التسجيل:';

  @override
  String get gps => 'GPS:';

  @override
  String get pickFarmLocation => 'اختر موقع المزرعة';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get unableLoadingWeather => 'لا يمكن تحميل بيانات الطقس حاليا.';

  @override
  String get basedOnYourLocation => 'بناءً على موقعك';

  @override
  String get farmWeather => 'طقس المزرعة';

  @override
  String get uvIndex => 'أشعة UV';

  @override
  String get moderate => 'متوسط';

  @override
  String get humidity => 'الرطوبة';

  @override
  String get rain => 'الأمطار';

  @override
  String get wind => 'الرياح';

  @override
  String get open => 'مفتوح';

  @override
  String get closed => 'مغلق';

  @override
  String get selected => 'تم الاختيار';

  @override
  String get error => 'خطأ';

  @override
  String get classifyFruit => 'تصنيف الفاكهة';

  @override
  String get classifyFruitDesc => 'تعرّف على نوع الفاكهة باستخدام الكاميرا الذكية';

  @override
  String get noFruitAdded => 'لم تتم إضافة أي فواكه';

  @override
  String get manageFarm => 'إدارة المزارع';

  @override
  String get manageFarmDesc => 'قم بإدارة جميع مزارعك من هنا';

  @override
  String get viewHistory => 'عرض السجل';

  @override
  String get viewHistoryDesc => 'عرض سجل الأنشطة والحصاد';

  @override
  String get sampleLocation => 'مدينتك';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get chooseAvatar => 'اختر الصورة الرمزية';

  @override
  String get name => 'الاسم';

  @override
  String get nameTooShort => 'الاسم يجب أن يكون 3 أحرف على الأقل';

  @override
  String get newPasswordOptional => 'كلمة مرور جديدة (اختياري)';

  @override
  String get cameraAccess => 'السماح بالكاميرا';

  @override
  String get locationSharing => 'مشاركة الموقع';

  @override
  String get profileupdatedsuccess => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get exploreFarms => 'استكشاف المزارع';

  @override
  String get noFarmsAvailable => 'لا توجد مزارع متاحة حالياً';

  @override
  String get unnamedFarm => 'مزرعة بدون اسم';

  @override
  String get noLocation => 'لا يوجد موقع';

  @override
  String get classifyDescription => 'التعرف على نوع الفاكهة باستخدام الكاميرا والذكاء الاصطناعي';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get unknownFarm => 'مزرعة غير معروفة';

  @override
  String get unknownLocation => 'موقع غير معروف';

  @override
  String get distance => 'المسافة';

  @override
  String get apple => 'تفاح';

  @override
  String get banana => 'موز';

  @override
  String get orange => 'برتقال';

  @override
  String get kiwi => 'كيوي';

  @override
  String get grapes => 'عنب';

  @override
  String get strawberry => 'فراولة';

  @override
  String get lemon => 'ليمون';

  @override
  String get majdoolDates => 'تمر مجدول';

  @override
  String get asilDates => 'تمر أصيل';

  @override
  String get sukaryDates => 'تمر سكري';

  @override
  String get nutritionInformation => 'المعلومات الغذائية · 100 جم';

  @override
  String get calories => 'السعرات الحرارية';

  @override
  String energyDescription(Object fruit) {
    return 'الطاقة التقريبية في 100 جم من $fruit.';
  }

  @override
  String dailyIntake(Object percent) {
    return '$percent% من الاحتياج اليومي (2000 سعرة حرارية)';
  }

  @override
  String get macronutrients => 'العناصر الغذائية الكبرى';

  @override
  String get carbs => 'الكربوهيدرات';

  @override
  String get protein => 'البروتين';

  @override
  String get totalFat => 'الدهون الكلية';

  @override
  String get carbsDescription => 'المصدر الرئيسي للطاقة';

  @override
  String get proteinDescription => 'يدعم العضلات';

  @override
  String get fatDescription => 'إجمالي كمية الدهون';

  @override
  String get fiberSugar => 'الألياف والسكريات';

  @override
  String get fiber => 'الألياف';

  @override
  String get sugar => 'السكر';

  @override
  String get fiberDescription => 'يساعد على الهضم والشعور بالشبع.';

  @override
  String get sugarDescription => 'السكر الطبيعي الموجود في الفاكهة.';

  @override
  String get micronutrients => 'العناصر الغذائية الدقيقة';

  @override
  String get water => 'الماء';

  @override
  String get calcium => 'الكالسيوم';

  @override
  String get iron => 'الحديد';

  @override
  String get nutritionDisclaimer => '* جميع القيم تقريبية وتعتمد على حصة مقدارها 100 جم.';

  @override
  String noNutritionData(Object fruit) {
    return 'لا توجد بيانات غذائية لـ $fruit';
  }

  @override
  String get loadingError => 'حدث خطأ أثناء تحميل البيانات';

  @override
  String get gram => 'جم';

  @override
  String get milligram => 'ملجم';

  @override
  String get kilocalorie => 'سعرة حرارية';

  @override
  String get percent => '%';

  @override
  String get millimeter => 'ملمتر';

  @override
  String get kiloMeterPerHour => 'كم/ساعة';

  @override
  String get noCameraFound => 'لا توجد كاميرا متاحة في هذا الجهاز';

  @override
  String get errorAccessingCamera => 'حدث خطأ أثناء الوصول إلى الكاميرا:';

  @override
  String get errorWhileScanning => 'حدث خطأ أثناء المسح الضوئي';

  @override
  String get errorWhileUploading => 'حدث خطأ أثناء التحميل';

  @override
  String get fruitCondition => 'حالة الفاكهة';

  @override
  String get spotsFound => 'تم اكتشاف بقع صغيرة في الفاكهة';

  @override
  String get fruitStructureIsStable => 'بنية الفاكهة مستقرة';

  @override
  String get unableDetectingFruitClearly => 'تعذر تحديد الفاكهة بوضوح؛ حاول مرة أخرى';

  @override
  String get seeDetailInformation => 'للاطلاع على المعلومات التفصيلية.';

  @override
  String get unknown => 'غير معروف';

  @override
  String get scan => 'امسح الفاكهة';

  @override
  String get scanning => 'يتم التقاط الفاكهة...';

  @override
  String get placeFruitInsideFrame => 'ضع الفاكهة داخل إطار التصوير.';

  @override
  String get upload => 'تحميل الصورة';

  @override
  String get cameraPermissionDenied => 'تم رفض إذن استخدام الكاميرا';
}
