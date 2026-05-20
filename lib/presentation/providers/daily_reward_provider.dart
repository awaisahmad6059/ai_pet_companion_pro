import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/core/constants/app_constants.dart';
import 'package:ai_pet_companion_pro/data/datasources/local_datasource.dart';
import 'package:ai_pet_companion_pro/presentation/providers/theme_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/player_provider.dart';

enum ClaimResult { success, alreadyClaimed }

class DailyRewardState {
  final DateTime? lastClaimTime;
  final Duration timeRemaining;
  final bool canClaim;
  final bool isInitialized;
  final bool isLoading;

  const DailyRewardState({
    this.lastClaimTime,
    this.timeRemaining = Duration.zero,
    this.canClaim = false,
    this.isInitialized = false,
    this.isLoading = false,
  });

  DailyRewardState copyWith({
    DateTime? lastClaimTime,
    Duration? timeRemaining,
    bool? canClaim,
    bool? isInitialized,
    bool? isLoading,
  }) {
    return DailyRewardState(
      lastClaimTime: lastClaimTime ?? this.lastClaimTime,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      canClaim: canClaim ?? this.canClaim,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DailyRewardNotifier extends StateNotifier<DailyRewardState> {
  final LocalDataSource _dataSource;
  final Ref _ref;
  Timer? _countdownTimer;
  bool _isClaiming = false;
  bool _initialized = false;

  DailyRewardNotifier(this._dataSource, this._ref)
      : super(const DailyRewardState(canClaim: false)) {
    Future.microtask(_initAsync);
  }

  Future<void> _initAsync() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final lastClaim = await _dataSource.loadLastClaimTime();
      debugPrint('[DailyReward] _initAsync loaded lastClaimTime: $lastClaim');
      if (lastClaim == null) {
        state = DailyRewardState(
          canClaim: true,
          isInitialized: true,
        );
        debugPrint('[DailyReward] _initAsync: no previous claim, canClaim=true');
        return;
      }
      _recomputeFrom(lastClaim);
    } catch (e) {
      debugPrint('[DailyReward] _initAsync error: $e');
      state = DailyRewardState(
        canClaim: true,
        isInitialized: true,
      );
    }
  }

  void _recomputeFrom(DateTime lastClaim) {
    final now = DateTime.now();
    final elapsed = now.difference(lastClaim);
    final remaining = AppConstants.claimCooldown - elapsed;

    debugPrint('[DailyReward] _recomputeFrom: lastClaim=$lastClaim, now=$now, elapsed=${elapsed.inHours}h');

    if (remaining <= Duration.zero) {
      state = DailyRewardState(
        lastClaimTime: lastClaim,
        canClaim: true,
        isInitialized: true,
        timeRemaining: Duration.zero,
      );
      debugPrint('[DailyReward] _recomputeFrom: cooldown expired, canClaim=true');
    } else {
      state = DailyRewardState(
        lastClaimTime: lastClaim,
        canClaim: false,
        isInitialized: true,
        timeRemaining: remaining,
      );
      debugPrint('[DailyReward] _recomputeFrom: cooldown active (${remaining.inHours}h), canClaim=false');
      _startCountdown();
    }
  }

  Future<ClaimResult> claim() async {
    // === GUARD 1: Hard reentrant lock ===
    if (_isClaiming) {
      debugPrint('[DailyReward] claim() BLOCKED: _isClaiming=true');
      return ClaimResult.alreadyClaimed;
    }

    // === GUARD 2: State-based check ===
    if (!state.canClaim) {
      debugPrint('[DailyReward] claim() BLOCKED: canClaim=false');
      return ClaimResult.alreadyClaimed;
    }

    // === GUARD 3: Wait for initialization ===
    if (!state.isInitialized) {
      debugPrint('[DailyReward] claim() BLOCKED: not initialized');
      return ClaimResult.alreadyClaimed;
    }

    // === ACQUIRE LOCK + IMMEDIATE UI DISABLE ===
    _isClaiming = true;
    state = state.copyWith(isLoading: true);
    debugPrint('[DailyReward] claim() isLoading=true, canClaim=${state.canClaim}');

    try {
      final now = DateTime.now();
      debugPrint('[DailyReward] claim() START at $now');

      // === GUARD 4: Cross-check with persisted storage ===
      // Reload directly from SharedPreferences to catch any stale state
      final persisted = await _dataSource.loadLastClaimTime();
      if (persisted != null) {
        final elapsed = now.difference(persisted);
        if (elapsed < AppConstants.claimCooldown) {
          debugPrint('[DailyReward] claim() BLOCKED: storage says claimed ${elapsed.inHours}h ago');
          state = state.copyWith(
            canClaim: false,
            lastClaimTime: persisted,
            timeRemaining: AppConstants.claimCooldown - elapsed,
          );
          _startCountdown();
          return ClaimResult.alreadyClaimed;
        }
      }

      // === STEP 1: Update state IMMEDIATELY (before any async I/O) ===
      // This synchronously marks the button as disabled so no second tap can enter
      _countdownTimer?.cancel();
      state = DailyRewardState(
        lastClaimTime: now,
        canClaim: false,
        isInitialized: true,
        timeRemaining: AppConstants.claimCooldown,
      );
      debugPrint('[DailyReward] claim() state set to canClaim=false');

      // === STEP 2: Persist to SharedPreferences (await completion) ===
      await _dataSource.saveLastClaimTime(now);
      debugPrint('[DailyReward] claim() saveLastClaimTime completed');

      // === VERIFY: Double-check that the write took effect ===
      final verify = await _dataSource.loadLastClaimTime();
      debugPrint('[DailyReward] claim() verify readback: $verify');
      if (verify == null || now.difference(verify).inSeconds > 5) {
        // Write didn't persist properly — retry
        debugPrint('[DailyReward] claim() WARNING: write verification failed, retrying...');
        await _dataSource.saveLastClaimTime(now);
      }

      // === STEP 3: Award coins ===
      _ref.read(playerProvider.notifier).addCoins(AppConstants.dailyRewardCoins);
      debugPrint('[DailyReward] claim() coins awarded: +${AppConstants.dailyRewardCoins}');

      // === STEP 4: Start countdown timer ===
      _startCountdown();

      debugPrint('[DailyReward] claim() SUCCESS');
      return ClaimResult.success;

    } catch (e) {
      debugPrint('[DailyReward] claim() ERROR: $e');
      // On error, try to persist anyway so the user doesn't get infinite retries
      try {
        await _dataSource.saveLastClaimTime(DateTime.now());
        debugPrint('[DailyReward] claim() error recovery save completed');
      } catch (_) {}
      return ClaimResult.alreadyClaimed;

    } finally {
      state = state.copyWith(isLoading: false);
      _isClaiming = false;
      debugPrint('[DailyReward] claim() lock released');
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final lastClaim = state.lastClaimTime;
      if (lastClaim == null) {
        _countdownTimer?.cancel();
        return;
      }
      final now = DateTime.now();
      final elapsed = now.difference(lastClaim);
      final remaining = AppConstants.claimCooldown - elapsed;

      if (remaining <= Duration.zero) {
        debugPrint('[DailyReward] countdown: cooldown expired, enabling claim');
        state = state.copyWith(canClaim: true, timeRemaining: Duration.zero);
        _countdownTimer?.cancel();
      } else {
        state = state.copyWith(timeRemaining: remaining);
      }
    });
  }

  void reset() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _isClaiming = false;
    _initialized = false;
    _dataSource.clearLastClaimTime();
    state = const DailyRewardState(
      canClaim: true,
      isInitialized: true,
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}

final dailyRewardProvider =
    StateNotifierProvider<DailyRewardNotifier, DailyRewardState>((ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  return DailyRewardNotifier(dataSource, ref);
});
