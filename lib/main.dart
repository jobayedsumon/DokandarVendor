import 'dart:async';
import 'dart:io';
import 'package:dokandar_shop/features/language/controllers/language_controller.dart';
import 'package:dokandar_shop/common/controllers/theme_controller.dart';
import 'package:dokandar_shop/features/notification/domain/models/notification_body_model.dart';
import 'package:dokandar_shop/helper/notification_helper.dart';
import 'package:dokandar_shop/helper/route_helper.dart';
import 'package:dokandar_shop/theme/dark_theme.dart';
import 'package:dokandar_shop/theme/light_theme.dart';
import 'package:dokandar_shop/util/app_constants.dart';
import 'package:dokandar_shop/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'agora/call_manager.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/splash/controllers/splash_controller.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if(!GetPlatform.isWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Map<String, Map<String, String>> languages = await di.init();

  NotificationBody? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  }catch(_) {}

  runApp(MyApp(languages: languages, body: body));
}

void _route() {
  Get.find<SplashController>().getConfigData().then((bool isSuccess) async {
    if (isSuccess) {
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<AuthController>().updateToken();
        // Initialize CallManager
        ProfileController profileController = Get.find<ProfileController>();
        await profileController.getProfile();
        Get.put(CallManager(profileController.profileModel!), permanent: true);
        Get.find<CallManager>();
      }
    }
  });
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;
  const MyApp({super.key, required this.languages, required this.body});

  @override
  Widget build(BuildContext context) {
    _route();
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          theme: themeController.darkTheme ? dark : light,
          locale: localizeController.locale,
          translations: Messages(languages: languages),
          fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
          initialRoute: RouteHelper.getSplashRoute(body),
          getPages: RouteHelper.routes,
          defaultTransition: Transition.topLevel,
          transitionDuration: const Duration(milliseconds: 500),
          builder: (BuildContext context, widget) {
            return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)), child: widget!);
          },
        );
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
