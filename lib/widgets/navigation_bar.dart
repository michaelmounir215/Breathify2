import 'package:flutter/material.dart';

class PatientNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const PatientNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  // Supabase icon URLs
  final String _homeIconUrl = 'https://cwzewtpnacschxszskps.supabase.co/storage/v1/object/public/app-icons/home.png';
  final String _profileIconUrl = 'https://cwzewtpnacschxszskps.supabase.co/storage/v1/object/public/app-icons/profile.png';
  final String _chatIconUrl = 'https://cwzewtpnacschxszskps.supabase.co/storage/v1/object/public/app-icons/chat.png';
  final String _reportsIconUrl = 'https://<project-id>.supabase.co/storage/v1/object/public/app-icons/reports.png';

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemTapped,
      destinations: [
        NavigationDestination(
          icon: Image.network(
            _homeIconUrl,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.medical_services),
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Image.network(
            _profileIconUrl,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
          ),
          label: 'Profile',
        ),
        NavigationDestination(
          icon: Image.network(
            _chatIconUrl,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.support_agent),
          ),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: Image.network(
            _reportsIconUrl,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.description),
          ),
          label: 'Reports',
        ),
      ],
    );
  }
}