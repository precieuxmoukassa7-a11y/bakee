import 'package:flutter/material.dart';

// ================= ONBOARDING =================
import '../views/onboarding/onboarding1.dart';
import '../views/onboarding/onboarding2.dart';
import '../views/onboarding/onboarding3.dart';

// ================= AUTH =================
import '../views/auth/choix_profil.dart';
import '../views/auth/login.dart';
import '../views/auth/register_client.dart';
import '../views/auth/register_patisserie.dart';
import '../views/auth/register_admin.dart';

// ================= CLIENT =================
import '../views/client/home.dart';
import '../views/client/cart.dart';

// ================= PATISSERIE =================
import '../views/patisserie/dashboard.dart';

// ================= LIVREUR =================
import '../views/livreur/dashboard.dart';

// ================= ADMIN =================
import '../views/admin/dashboard.dart';

class AppRoutes {
  // ===== ONBOARDING =====
  static const String onboarding1 = "/";
  static const String onboarding2 = "/onboarding2";
  static const String onboarding3 = "/onboarding3";

  // ===== AUTH =====
  static const String choixProfil = "/choix-profil";
  static const String login = "/login";
  static const String registerClient = "/register-client";
  static const String registerPatisserie = "/register-patisserie";
  static const String registerAdmin = "/register-admin";

  // ===== CLIENT =====
  static const String homeClient = "/home-client";
  static const String cart = "/cart";

  // ===== PATISSERIE =====
  static const String patisserieDashboard = "/patisserie-dashboard";

  // ===== LIVREUR =====
  static const String livreurDashboard = "/livreur-dashboard";

  // ===== ADMIN =====
  static const String adminDashboard = "/admin-dashboard";

  // ===== ROUTES MAP =====
  static Map<String, WidgetBuilder> routes = {
    // ONBOARDING
    onboarding1: (context) => Onboarding1(),
    onboarding2: (context) => Onboarding2(),
    onboarding3: (context) => Onboarding3(),

    // AUTH
    choixProfil: (context) => ChoixProfilPage(),
    login: (context) => LoginPage(),
    registerClient: (context) => RegisterClientPage(),
    registerPatisserie: (context) => RegisterPatisseriePage(),
    registerAdmin: (context) => RegisterAdminPage(),

    // CLIENT
    homeClient: (context) => HomePage(),
    cart: (context) => CartPage(),

    // PATISSERIE
    patisserieDashboard: (context) => PatisserieDashboard(),

    // LIVREUR
    livreurDashboard: (context) => LivreurDashboard(),

    // ADMIN
    adminDashboard: (context) => AdminDashboard(),
  };
}