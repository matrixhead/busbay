import 'package:busbay/logic/Services/auth.dart';
import 'package:busbay/logic/Services/user.dart';
import 'package:busbay/logic/view_models/Passenger_view_model.dart';
import 'package:busbay/logic/view_models/driver_view_model.dart';
import 'package:busbay/logic/view_models/main_view_model.dart';
import 'package:busbay/logic/view_models/student_register_view.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());
  serviceLocator.registerLazySingleton<UserService>(() => UserService());

  serviceLocator.registerFactory(() => PassengerMapView());
  serviceLocator.registerFactory(() => StudentRegisterView());
  serviceLocator.registerFactory(() => MainViewModel());
  serviceLocator.registerFactory(() => DriverMapView());
}
