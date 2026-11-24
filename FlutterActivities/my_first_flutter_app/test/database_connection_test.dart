
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_flutter_app/core/db_connection.dart';

void main() {
  test('Connect to Neon database', () async {
    final connection =
        await DatabaseConnection.getConnection();

    try {
      final result = await connection.execute('SELECT 1');

      expect(result.first.first, 1);
    } finally {
      await DatabaseConnection.closeConnection();
    }
  });
}
