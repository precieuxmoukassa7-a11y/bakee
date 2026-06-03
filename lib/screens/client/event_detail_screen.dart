import 'package:flutter/material.dart';

// ✅ Exporter la classe EventData pour qu'elle soit accessible
class EventData {
  final IconData icon;
  final String label;
  final Color color;
  final String description;
  final String fullDescription;
  final List<String> offers;
  final List<String> galleryImages;

  EventData({
    required this.icon,
    required this.label,
    required this.color,
    required this.description,
    required this.fullDescription,
    required this.offers,
    required this.galleryImages,
  });
}

class EventDetailScreen extends StatelessWidget {
  final EventData event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: event.color,
        elevation: 0,
        title: Text(
          event.label,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec icône
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    event.color,
                    event.color.withOpacity(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    event.icon,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    event.label,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("📋 Description"),
                  const SizedBox(height: 8),
                  _buildDescriptionCard(event.fullDescription),
                  const SizedBox(height: 20),
                  _buildSectionTitle("🎁 Ce que nous proposons"),
                  const SizedBox(height: 8),
                  ...event.offers.map((offer) => _buildOfferCard(offer)),
                  const SizedBox(height: 20),
                  _buildSectionTitle("📞 Contactez-nous"),
                  const SizedBox(height: 8),
                  _buildContactCard(),
                  const SizedBox(height: 20),
                  _buildSectionTitle("✨ Galerie"),
                  const SizedBox(height: 8),
                  _buildGallery(),
                  const SizedBox(height: 30),
                  _buildOrderButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4A2C2A),
      ),
    );
  }

  Widget _buildDescriptionCard(String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8DADA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        description,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildOfferCard(String offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A2C2A).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4A2C2A), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              offer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A2C2A),
            const Color(0xFF6B3A2A),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildContactRow(Icons.phone, "+237 6 XX XX XX XX"),
          const SizedBox(height: 10),
          _buildContactRow(Icons.email, "contact@bakee.com"),
          const SizedBox(height: 10),
          _buildContactRow(Icons.location_on, "Douala, Cameroun"),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildGallery() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: event.galleryImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8DADA),
              borderRadius: BorderRadius.circular(12),
              image: event.galleryImages[index].isNotEmpty
                  ? DecorationImage(
                image: AssetImage(event.galleryImages[index]),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: event.galleryImages[index].isEmpty
                ? const Icon(Icons.cake, size: 40, color: Color(0xFF4A2C2A))
                : null,
          );
        },
      ),
    );
  }

  Widget _buildOrderButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Demande pour ${event.label} envoyée !"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A2C2A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "COMMANDER MAINTENANT",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}