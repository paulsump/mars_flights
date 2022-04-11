// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:mars_flights/buttons/position.dart';
import 'package:mars_flights/buttons/position_to_unit.dart';

/// Used to create various buttons e.g. [HexagonBorderButton]
Path calcHexagonPath(Offset center, double radius) {
  return Path()
    ..addPolygon(
        getHexagonCornerOffsets()
            .map((offset) => offset * radius + center)
            .toList(),
        true);
}

UnmodifiableListView<Offset> getHexagonCornerOffsets() => UnmodifiableListView(
    List<Offset>.generate(6, (i) => positionToUnitOffset(_corners[i + 1])));

/// Cube corners (from Cube Painter)
const _corners = <Position>[
  Position.zero, // c center
  // anti clockwise from top right
  // /_/|
  // |_|/
  Position(1, 1), // tr
  Position(0, 1), // t
  Position(-1, 0), // tl
  Position(-1, -1), // bl
  Position(0, -1), // b bottom
  Position(1, 0), // br
];
