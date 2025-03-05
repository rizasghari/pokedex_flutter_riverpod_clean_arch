import 'package:get_it/get_it.dart';

import '../services/http_service.dart';

class ServiceLocator {
  static GetIt sl = GetIt.instance;
  static Future<void> setUp() async {
    sl.registerSingleton<HttpService>(
      HttpService(),
    );
  }
}

