import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

/// Professional UZ / RU / EN copy for Fleetora.
class AppStrings {
  final String lang;

  const AppStrings(this.lang);

  static AppStrings of(BuildContext context) {
    return context.watch<AppProvider>().strings;
  }

  Locale get locale => switch (lang) {
        'uz' => const Locale('uz'),
        'ru' => const Locale('ru'),
        _ => const Locale('en'),
      };

  String _t(String en, String uz, String ru) => switch (lang) {
        'uz' => uz,
        'ru' => ru,
        _ => en,
      };

  String navLabel(String key) => switch (key) {
        'nav.dashboard' => navDashboard,
        'nav.fleet' => navFleet,
        'nav.drivers' => navDrivers,
        'nav.liveMap' => navLiveMap,
        'nav.monitoring' => navMonitoring,
        'nav.alerts' => navAlerts,
        'nav.business' => navBusiness,
        'nav.analytics' => navAnalytics,
        'nav.system' => navSystem,
        'nav.settings' => navSettings,
        'group.main' => groupMain,
        'group.operations' => groupOperations,
        'group.monitoring' => groupMonitoring,
        'group.business' => groupBusiness,
        'group.system' => groupSystem,
        _ => key,
      };

  String pageTitle(int index) => switch (index) {
        0 => titleDashboard,
        1 => titleFleet,
        2 => titleDrivers,
        3 => titleLiveMap,
        4 => titleMonitoring,
        5 => titleAlerts,
        6 => titleBusiness,
        7 => titleAnalytics,
        8 => titleSystem,
        9 => titleSettings,
        _ => appName,
      };

  // Brand
  String get appName => _t('Fleetora', 'Fleetora', 'Fleetora');
  String get appSubtitle => _t('Enterprise OS', 'Korporativ OS', 'Корпоративная OS');

  // Nav
  String get navDashboard => _t('Dashboard', 'Boshqaruv', 'Панель');
  String get navFleet => _t('Fleet', 'Avtopark', 'Автопарк');
  String get navDrivers => _t('Drivers', 'Haydovchilar', 'Водители');
  String get navLiveMap => _t('Live Map', 'Jonli xarita', 'Живая карта');
  String get navMonitoring => _t('Monitoring', 'Monitoring', 'Мониторинг');
  String get navAlerts => _t('Alerts', 'Ogohlantirishlar', 'Оповещения');
  String get navBusiness => _t('Business', 'Biznes', 'Бизнес');
  String get navAnalytics => _t('Analytics', 'Analitika', 'Аналитика');
  String get navSystem => _t('System', 'Tizim', 'Система');
  String get navSettings => _t('Settings', 'Sozlamalar', 'Настройки');

  String get groupMain => _t('Main', 'Asosiy', 'Главное');
  String get groupOperations => _t('Operations', 'Operatsiya', 'Операции');
  String get groupMonitoring => _t('Monitoring', 'Kuzatuv', 'Контроль');
  String get groupBusiness => _t('Business', 'Biznes', 'Бизнес');
  String get groupSystem => _t('System', 'Tizim', 'Система');

  // Page titles
  String get titleDashboard => _t('Command Center', 'Boshqaruv markazi', 'Центр управления');
  String get titleFleet => _t('Fleet Management', 'Avtopark boshqaruvi', 'Управление автопарком');
  String get titleDrivers => _t('Driver Center', 'Haydovchilar markazi', 'Центр водителей');
  String get titleLiveMap => _t('Live Map', 'Jonli xarita', 'Живая карта');
  String get titleMonitoring => _t('Fleet Monitoring', 'Avtopark monitoringi', 'Мониторинг парка');
  String get titleAlerts => _t('Alerts & Incidents', 'Ogohlantirishlar', 'Инциденты');
  String get titleBusiness => _t('Business Partners', 'Biznes hamkorlar', 'Партнёры');
  String get titleAnalytics => _t('Analytics & BI', 'Analitika va BI', 'Аналитика и BI');
  String get titleSystem => _t('System & Security', 'Tizim va xavfsizlik', 'Система и безопасность');
  String get titleSettings => _t('Settings', 'Sozlamalar', 'Настройки');

  // Common
  String get live => _t('LIVE', 'JONLI', 'ОНЛАЙН');
  String get aiAssistant => _t('AI Assistant', 'AI Yordamchi', 'AI Помощник');
  String get darkMode => _t('Dark', 'Qorong\'u', 'Тёмная');
  String get lightMode => _t('Light', 'Yorug\'', 'Светлая');
  String get saveChanges => _t('Save Changes', 'Saqlash', 'Сохранить');
  String get export => _t('Export', 'Eksport', 'Экспорт');
  String get all => _t('All', 'Hammasi', 'Все');
  String get active => _t('Active', 'Faol', 'Активные');
  String get idle => _t('Idle', 'Kutish', 'Простой');
  String get maintenance => _t('Maintenance', 'Texnik xizmat', 'Обслуживание');

  // Telemetry
  String get liveTelemetry => _t('LIVE TELEMETRY', 'JONLI TELEMETRIYA', 'ЖИВАЯ ТЕЛЕМЕТРИЯ');
  String get vehicleDiagnostics => _t('Vehicle Diagnostics', 'Transport diagnostikasi', 'Диагностика ТС');
  String get fuelLevel => _t('Fuel Level', 'Yoqilg\'i', 'Топливо');
  String get engineTemp => _t('Engine Temp', 'Dvigatel harorati', 'Темп. двигателя');
  String get battery => _t('Battery', 'Batareya', 'Аккумулятор');
  String get tirePressure => _t('Tire Pressure', 'Shina bosimi', 'Давление шин');
  String get engineDiagnostics => _t('Engine Diagnostics', 'Dvigatel diagnostikasi', 'Диагностика двигателя');
  String get driverBehavior => _t('Driver Behavior', 'Haydovchi xulqi', 'Поведение водителя');
  String get telemetryLog => _t('Telemetry Log', 'Telemetriya jurnali', 'Журнал телеметрии');
  String get fuelAnalytics => _t('Fuel Analytics', 'Yoqilg\'i analitikasi', 'Аналитика топлива');
  String get engineOptimal => _t('Engine Optimal', 'Dvigatel optimal', 'Двигатель в норме');
  String get allSystemsOk => _t('All systems operational', 'Barcha tizimlar ishlayapti', 'Все системы в норме');

  // Modules (merged sections)
  String get routesPlanning => _t('Route Planning', 'Marshrut rejalashtirish', 'Планирование маршрутов');
  String get routesDesc => _t('Multi-stop routes & ETA optimization', 'Ko\'p nuqtali marshrutlar va ETA', 'Маршруты и оптимизация ETA');
  String get maintenanceHub => _t('Maintenance Hub', 'Texnik xizmat markazi', 'Центр обслуживания');
  String get maintenanceDesc => _t('Service intervals & work orders', 'Xizmat intervallari va buyurtmalar', 'Интервалы ТО и заказы');
  String get financeOverview => _t('Finance Overview', 'Moliya ko\'rinishi', 'Финансовый обзор');
  String get reportsCenter => _t('Reports Center', 'Hisobotlar markazi', 'Центр отчётов');
  String get clientsPartners => _t('Active Clients', 'Faol mijozlar', 'Активные клиенты');
  String get usersRoles => _t('Users & Roles', 'Foydalanuvchilar va rollar', 'Пользователи и роли');

  // Auth
  String get signIn => _t('Sign In', 'Kirish', 'Войти');
  String get demoLogin => _t('Demo account login', 'Demo hisob bilan kirish', 'Вход демо-аккаунта');
  String get email => _t('Email', 'Email', 'Email');
  String get password => _t('Password', 'Parol', 'Пароль');
}
