import 'package:flutter_test/flutter_test.dart';
import 'package:mars_flights/favorites_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Test the shared preferences loads and saves.
void main() {
  group('Favorites load', () {
    test('returns a Map if the http call completes successfully', () async {
      final favorites = <String>['id1', 'id2'];

      final Map<String, Object> values = <String, Object>{
        'favorites': favorites
      };
      SharedPreferences.setMockInitialValues(values);

      final favoritesNotifier = FavoritesNotifier();
      await favoritesNotifier.loadInitialValues();

      for (final id in favorites) {
        expect(favoritesNotifier.contains(id), true);
      }
    });
  });
}
