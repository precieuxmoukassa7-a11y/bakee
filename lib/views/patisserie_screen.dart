import 'package:flutter/material.dart';
import'../controler/commande & paiement.dart';
import'../controler/consultation des produits.dart';
import'../controler/gestion du panier.dart';
import'../controler/inscription & connexion.dart';
import'../controler/livraison.dart';
import'../controler/notifications.dart';
import'../controler/profil utilisateur.dart';



class PatisserieScreen extends StatelessWidget {
  const PatisserieScreen({super.key}); // note le "const" ici

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pâtisseries"),
      ),
      body: const Center(
        child: Text("Bienvenue dans l'app "),
      ),
    );
  }
}

