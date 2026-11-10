import 'package:flutter/material.dart';

class StorePalette {
  final Color primary;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color text;
  final Color muted;
  final bool isDark;

  const StorePalette({
    required this.primary,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.text,
    required this.muted,
    required this.isDark,
  });
}

class StoreThemes {
  static const Map<String, StorePalette> _themes = {
    'orange': StorePalette(primary: Color(0xFFFF7A00), onPrimary: Colors.white, background: Color(0xFFFFF8F1), surface: Colors.white, text: Color(0xFF24180F), muted: Color(0xFF806B5B), isDark: false),
    'ocean': StorePalette(primary: Color(0xFF0787B5), onPrimary: Colors.white, background: Color(0xFFF1FAFD), surface: Colors.white, text: Color(0xFF102B38), muted: Color(0xFF607D8B), isDark: false),
    'emerald': StorePalette(primary: Color(0xFF16865D), onPrimary: Colors.white, background: Color(0xFFF1FAF5), surface: Colors.white, text: Color(0xFF17382A), muted: Color(0xFF638071), isDark: false),
    'purple': StorePalette(primary: Color(0xFF8051C7), onPrimary: Colors.white, background: Color(0xFFF8F4FD), surface: Colors.white, text: Color(0xFF2B1D3B), muted: Color(0xFF786A88), isDark: false),
    'rose': StorePalette(primary: Color(0xFFD64D78), onPrimary: Colors.white, background: Color(0xFFFFF5F8), surface: Colors.white, text: Color(0xFF3B202A), muted: Color(0xFF8A6875), isDark: false),
    'dark': StorePalette(primary: Color(0xFFB7B7B7), onPrimary: Colors.black, background: Color(0xFF101010), surface: Color(0xFF1C1C1C), text: Colors.white, muted: Color(0xFFB0B0B0), isDark: true),
    'sunset': StorePalette(primary: Color(0xFFE56B45), onPrimary: Colors.white, background: Color(0xFFFFF5EF), surface: Colors.white, text: Color(0xFF3C241D), muted: Color(0xFF8D6B5F), isDark: false),
    'gold': StorePalette(primary: Color(0xFFD4AF37), onPrimary: Color(0xFF17130A), background: Color(0xFF090B10), surface: Color(0xFF151922), text: Color(0xFFF8F2DE), muted: Color(0xFFB8B1A0), isDark: true),
    'mint': StorePalette(primary: Color(0xFF46BFA0), onPrimary: Colors.black, background: Color(0xFFF1FCF8), surface: Colors.white, text: Color(0xFF17352D), muted: Color(0xFF66877D), isDark: false),
    'crimson': StorePalette(primary: Color(0xFFC6283D), onPrimary: Colors.white, background: Color(0xFFFFF4F5), surface: Colors.white, text: Color(0xFF35151B), muted: Color(0xFF8B6269), isDark: false),
    'midnight': StorePalette(primary: Color(0xFF607DCE), onPrimary: Colors.white, background: Color(0xFF0B1020), surface: Color(0xFF171F35), text: Colors.white, muted: Color(0xFFAAB5D0), isDark: true),
    'forest': StorePalette(primary: Color(0xFF719B55), onPrimary: Colors.white, background: Color(0xFF101A12), surface: Color(0xFF1B2A1D), text: Colors.white, muted: Color(0xFFB0C1AE), isDark: true),
    'lavender': StorePalette(primary: Color(0xFFA58AD8), onPrimary: Colors.black, background: Color(0xFFFAF7FF), surface: Colors.white, text: Color(0xFF302641), muted: Color(0xFF81758F), isDark: false),
    'coffee': StorePalette(primary: Color(0xFF9A6A45), onPrimary: Colors.white, background: Color(0xFF211912), surface: Color(0xFF30251C), text: Color(0xFFFFF4E8), muted: Color(0xFFC7B5A3), isDark: true),
    'sky': StorePalette(primary: Color(0xFF4D9FE8), onPrimary: Colors.white, background: Color(0xFFF2F9FF), surface: Colors.white, text: Color(0xFF183149), muted: Color(0xFF6A8298), isDark: false),
    'lime': StorePalette(primary: Color(0xFF83A91E), onPrimary: Colors.black, background: Color(0xFFF8FCEB), surface: Colors.white, text: Color(0xFF2C3515), muted: Color(0xFF78845B), isDark: false),
    'peach': StorePalette(primary: Color(0xFFE99A78), onPrimary: Colors.black, background: Color(0xFFFFF7F2), surface: Colors.white, text: Color(0xFF422A21), muted: Color(0xFF927568), isDark: false),
    'slate': StorePalette(primary: Color(0xFF718096), onPrimary: Colors.white, background: Color(0xFFF4F6F8), surface: Colors.white, text: Color(0xFF202A35), muted: Color(0xFF687582), isDark: false),
    'aurora': StorePalette(primary: Color(0xFF4DC6C1), onPrimary: Color(0xFF071B20), background: Color(0xFF0A151E), surface: Color(0xFF142632), text: Colors.white, muted: Color(0xFFB0C8CE), isDark: true),
    'candy': StorePalette(primary: Color(0xFFE56CB5), onPrimary: Colors.white, background: Color(0xFFFFF4FB), surface: Colors.white, text: Color(0xFF3B2032), muted: Color(0xFF8D6A81), isDark: false),
  };

  static StorePalette get(String key) => _themes[key] ?? _themes['gold']!;
  static List<String> get keys => _themes.keys.toList(growable: false);
}
