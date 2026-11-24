
import 'package:postgres/postgres.dart';

class DatabaseConnection {
  static Connection? _connection;

  static Future<Connection> getConnection() async {
    if (_connection != null && _connection!.isOpen) {
      return _connection!;
    }

    const password = String.fromEnvironment('DB_PASSWORD');

    if (password.isEmpty) {
      throw Exception('Database password is not configured.');
    }

    _connection = await Connection.open(
      Endpoint(
        host: 'ep-holy-scene-ao04kb39-pooler.c-2.ap-southeast-1.aws.neon.tech',
        port: 5432,
        database: 'CaballeroSMS',
        username: 'neondb_owner',
        password: password,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require,
      ),
    );

    return _connection!;
  }

  static Future<void> closeConnection() async {
    if (_connection != null && _connection!.isOpen) {
      await _connection!.close();
    }

    _connection = null;
  }
}
