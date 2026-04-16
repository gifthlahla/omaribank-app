import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omari_bank_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:omari_bank_app/features/auth/presentation/screens/login_screen.dart';
import 'package:omari_bank_app/features/auth/presentation/screens/register_screen.dart';
import 'package:omari_bank_app/features/wallet/presentation/screens/home_screen.dart';
import 'package:omari_bank_app/features/transactions/presentation/screens/deposit_screen.dart';
import 'package:omari_bank_app/features/transactions/presentation/screens/withdraw_screen.dart';
import 'package:omari_bank_app/features/transactions/presentation/screens/send_money_screen.dart';
import 'package:omari_bank_app/features/transactions/presentation/screens/transaction_history_screen.dart';
import 'package:omari_bank_app/features/transactions/presentation/screens/transaction_detail_screen.dart';
import 'package:omari_bank_app/features/transactions/domain/transaction_model.dart';
import 'package:omari_bank_app/features/profile/presentation/screens/profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading) return null;
      
      final isAuth = authState.value != null;
      final isGoingToLogin = state.uri.path == '/login';
      final isGoingToRegister = state.uri.path == '/register';
      
      if (!isAuth && !isGoingToLogin && !isGoingToRegister) {
        return '/login';
      }
      
      if (isAuth && (state.uri.path == '/' || isGoingToLogin || isGoingToRegister)) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/deposit',
        builder: (context, state) => const DepositScreen(),
      ),
      GoRoute(
        path: '/withdraw',
        builder: (context, state) => const WithdrawScreen(),
      ),
      GoRoute(
        path: '/send',
        builder: (context, state) => const SendMoneyScreen(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionHistoryScreen(),
      ),
      GoRoute(
        path: '/transaction_detail',
        builder: (context, state) => TransactionDetailScreen(
          transaction: state.extra as TransactionModel,
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
