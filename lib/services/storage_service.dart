import 'package:ai_pet_companion_pro/data/datasources/local_datasource.dart';

class StorageService {
  final LocalDataSource _localDataSource = LocalDataSource();
  bool _initialized = false;

  LocalDataSource get dataSource => _localDataSource;

  Future<void> init() async {
    if (!_initialized) {
      await _localDataSource.init();
      _initialized = true;
    }
  }

  bool get isInitialized => _initialized;
}
