// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:math';

import 'package:mars_flights/buttons/hexagon_path.dart';
import 'package:mars_flights/buttons/position_to_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

bool equalsOffsetList(List<Offset> a, List<Offset> b) {
  final int n = a.length;

  if (n != b.length) {
    return false;
  }
  for (int i = 0; i < n; ++i) {
    if (!_equalsOffset(a[i], b[i])) {
      return false;
    }
  }
  return true;
}

bool _equalsDouble(double a, double b) {
  return (a - b).abs() == 0.0;
}

bool _equalsOffset(Offset a, Offset b) {
  return _equalsDouble(a.dx, b.dx) && _equalsDouble(a.dy, b.dy);
}

void main() {
  group('Testing calcHexagonOffsets()', () {
    final List<Offset> offsets = getHexagonCornerOffsets();

    const double x = root3over2;
    const double y = 0.5;

    test('offset 0', () {
      expect(offsets[0].dx, equals(x));
      expect(offsets[0].dy, equals(-y));
    });
    test('offset 1', () {
      expect(offsets[1].dx, equals(0));
      expect(offsets[1].dy, equals(-1));
    });
    test('offset 2', () {
      expect(offsets[2].dx, equals(-x));
      expect(offsets[2].dy, equals(-y));
    });
    test('offset 3', () {
      expect(offsets[3].dx, equals(-x));
      expect(offsets[3].dy, equals(y));
    });
    test('offset 4', () {
      expect(offsets[4].dx, equals(0));
      expect(offsets[4].dy, equals(1));
    });
    test('offset 5', () {
      expect(offsets[5].dx, equals(x));
      expect(offsets[5].dy, equals(y));
    });
  });

  group('calcHexagonPath origin, unit radius:', () {
    const center = Offset.zero;
    const radius = 1.0;

    final Path path = calcHexagonPath(center, radius);
    final rect = path.getBounds();

    test('center', () {
      expect(rect.center, equals(center));
    });
    test('width', () {
      const double delta = 0.000001;
      expect(rect.width, closeTo(sqrt(3), delta));
      expect(rect.width, equals(1.7320507764816284));
    });
    test('height', () {
      expect(rect.height, equals(radius * 2));
    });
  });

  group('calcHexagonPath offset, unit radius:', () {
    const center = Offset(2, 3);
    const radius = 1.0;

    final Path path = calcHexagonPath(center, radius);
    final rect = path.getBounds();

    test('center', () {
      expect(rect.center, equals(center));
    });
    test('width', () {
      const double delta = 0.000001;
      expect(rect.width, closeTo(sqrt(3), delta));
      expect(rect.width, equals(1.732050895690918));
    });
    test('height', () {
      expect(rect.height, equals(radius * 2));
    });
  });

  group('calcHexagonPath origin, radius 2:', () {
    const center = Offset.zero;
    const radius = 2.0;

    final Path path = calcHexagonPath(center, radius);
    final rect = path.getBounds();

    test('center', () {
      expect(rect.center, equals(center));
    });
    test('width', () {
      const double delta = 0.000001;
      expect(rect.width, closeTo(sqrt(3) * radius, delta));
      expect(rect.width, equals(1.7320507764816284 * radius));
    });
    test('height', () {
      expect(rect.height, equals(radius * 2));
    });
  });

  group('calcHexagonPath offset, radius 2:', () {
    const center = Offset(-3, 7);
    const radius = 2.0;

    final Path path = calcHexagonPath(center, radius);
    final rect = path.getBounds();

    test('center x', () {
      expect(rect.center.dx, closeTo(center.dx, 0.0000001));
      expect(rect.center.dx, equals(-3.0000000596046448));
    });
    test('center y', () {
      expect(rect.center.dy, equals(center.dy));
    });
    test('width', () {
      const double delta = 0.000001;
      expect(rect.width, closeTo(sqrt(3) * radius, delta));
      expect(rect.width, equals(3.4641016721725464));
    });
    test('height', () {
      expect(rect.height, equals(radius * 2));
    });
  });
}
