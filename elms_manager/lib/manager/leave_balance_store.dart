import 'dart:math' as math;

import 'package:flutter/foundation.dart';

class LeaveBalanceStore {
  LeaveBalanceStore._();

  static final ValueNotifier<Map<String, int>> balances =
      ValueNotifier<Map<String, int>>(<String, int>{});

  static int balanceFor(String memberName, {required int fallbackDays}) {
    return balances.value[memberName] ?? fallbackDays;
  }

  static void ensureBalance(String memberName, int initialDays) {
    if (balances.value.containsKey(memberName)) {
      return;
    }
    final Map<String, int> next = Map<String, int>.from(balances.value);
    next[memberName] = initialDays;
    balances.value = next;
  }

  static void consumeLeave({
    required String memberName,
    required int daysTaken,
    int? fallbackBalance,
  }) {
    final int? current = balances.value[memberName] ?? fallbackBalance;
    if (current == null) {
      return;
    }
    final int updated = math.max(0, current - math.max(0, daysTaken));
    final Map<String, int> next = Map<String, int>.from(balances.value);
    next[memberName] = updated;
    balances.value = next;
  }

  static int parseFirstInt(String text, {int fallback = 0}) {
    final RegExpMatch? match = RegExp(r'(\d+)').firstMatch(text);
    if (match == null) {
      return fallback;
    }
    return int.tryParse(match.group(1) ?? '') ?? fallback;
  }

  static int extractRequestedDays(String datesText, {int fallback = 0}) {
    final RegExpMatch? match =
        RegExp(r'\((\d+)\s+days?\)', caseSensitive: false).firstMatch(datesText);
    if (match == null) {
      return fallback;
    }
    return int.tryParse(match.group(1) ?? '') ?? fallback;
  }

  static String remainingLabel(String memberName, {required int fallbackDays}) {
    final int days = balanceFor(memberName, fallbackDays: fallbackDays);
    return '$days days remaining';
  }
}
