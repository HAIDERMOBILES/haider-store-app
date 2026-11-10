import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'theme/store_themes.dart';

const String apiBase = 'https://haiderstore.shop/api';
const String siteBase = 'https://haiderstore.shop';

void main() => runApp(const HaiderStoreApp());

class StoreApi {
  Future<Map<String, dynamic>> _get(String path) async {
    final response = await http.get(Uri.parse('$apiBase/$path')).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) throw Exception('Server response: ${response.statusCode}');
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['success'] != true) {
      throw Exception(decoded is Map ? (decoded['message'] ?? 'API error').toString() : 'Invalid API response');
    }
    return decoded;
  }

  Future<String> theme() async {
    final json = await _get('themes.php');
    return (json['data']?['selected_theme'] ?? 'gold').toString();
  }

  Future<List<dynamic>> categories() async {
    final json = await _get('categories.php');
    return (json['data'] as List?) ?? [];
  }

  Future<List<dynamic>> products({int page = 1, String search = '', String? category}) async {
    final uri = Uri.parse('$apiBase/products.php').replace(queryParameters: {
      'page': '$page', 'per_page': '20',
      if (search.trim().isNotEmpty) 'search': search.trim(),
      if (category != null && category.isNotEmpty) 'category': category,
    });
    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) throw Exception('Server response: ${response.statusCode}');
    final json = jsonDecode(response.body);
    if (json is! Map<String, dynamic> || json['success'] != true) throw Exception('Products load nahi huay');
    return (json['data']?['items'] as List?) ?? [];
  }
}

class HaiderStoreApp extends StatefulWidget {
  const HaiderStoreApp({super.key});
  @override
  State<HaiderStoreApp> createState() => _HaiderStoreAppState();
}

class _HaiderStoreAppState extends State<HaiderStoreApp> {
  final api = StoreApi();
  String themeKey = 'gold';
  bool themeLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final key = await api.theme();
      if (mounted) setState(() { themeKey = key; themeLoaded = true; });
    } catch (_) {
      if (mounted) setState(() => themeLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = StoreThemes.get(themeKey);
    return MaterialApp(
      title: 'Haider Store', debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: palette.background,
        colorScheme: ColorScheme.fromSeed(seedColor: palette.primary, brightness: palette.isDark ? Brightness.dark : Brightness.light),
        appBarTheme: AppBarTheme(backgroundColor: palette.surface, foregroundColor: palette.text, elevation: 0)),
      home: StoreHomePage(api: api, palette: palette, onRefreshTheme: _loadTheme, themeLoaded: themeLoaded),
    );
  }
}

class StoreHomePage extends StatefulWidget {
  final StoreApi api;
  final StorePalette palette;
  final Future<void> Function() onRefreshTheme;
  final bool themeLoaded;
  const StoreHomePage({super.key, required this.api, required this.palette, required this.onRefreshTheme, required this.themeLoaded});
  @override
  State<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  late Future<List<dynamic>> categoriesFuture;
  late Future<List<dynamic>> productsFuture;
  final searchController = TextEditingController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    categoriesFuture = widget.api.categories();
    productsFuture = widget.api.products();
  }

  @override
  void dispose() { searchController.dispose(); super.dispose(); }

  void _reloadProducts() {
    setState(() => productsFuture = widget.api.products(search: searchController.text, category: selectedCategory));
  }

  String _imageUrl(dynamic value) {
    final file = (value ?? '').toString().trim();
    if (file.isEmpty) return '';
    if (file.startsWith('http://') || file.startsWith('https://')) return file;
    return '$siteBase/uploads/${Uri.encodeComponent(file)}';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    return Scaffold(
      appBar: AppBar(title: const Text('HAIDER STORE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1)),
        actions: [IconButton(onPressed: () async { await widget.onRefreshTheme(); if (mounted) _reloadProducts(); }, tooltip: 'Refresh', icon: const Icon(Icons.refresh))]),
      body: RefreshIndicator(onRefresh: () async { await widget.onRefreshTheme(); _reloadProducts(); }, child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24), children: [
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
            gradient: LinearGradient(colors: [p.surface, p.background], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20), border: Border.all(color: p.primary.withValues(alpha: .55)),
            boxShadow: [BoxShadow(color: p.primary.withValues(alpha: .12), blurRadius: 18, offset: const Offset(0, 6))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('WELCOME TO', style: TextStyle(color: p.primary, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 7), Text('Haider Store', style: TextStyle(color: p.text, fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 7), Text('Mobiles, accessories aur rozmarra ki technology products.', style: TextStyle(color: p.muted)),
              const SizedBox(height: 14), Text('Cash on Delivery Available', style: TextStyle(color: p.primary, fontWeight: FontWeight.w700)),
            ])),
          const SizedBox(height: 18),
          TextField(controller: searchController, textInputAction: TextInputAction.search,
            onSubmitted: (_) => _reloadProducts(), decoration: InputDecoration(hintText: 'Search products...', prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(onPressed: _reloadProducts, icon: const Icon(Icons.arrow_forward)), filled: true, fillColor: p.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
          const SizedBox(height: 20),
          _sectionTitle('Shop by Category', p), const SizedBox(height: 10),
          SizedBox(height: 48, child: FutureBuilder<List<dynamic>>(future: categoriesFuture, builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text('Categories load nahi huin', style: TextStyle(color: p.muted)));
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final cats = snapshot.data!;
            return ListView(scrollDirection: Axis.horizontal, children: [
              _categoryChip('All', null, p),
              ...cats.map((c) => _categoryChip((c['name'] ?? '').toString(), (c['name'] ?? '').toString(), p)),
            ]);
          })),
          const SizedBox(height: 20), _sectionTitle('Latest Products', p), const SizedBox(height: 12),
          FutureBuilder<List<dynamic>>(future: productsFuture, builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Padding(padding: EdgeInsets.all(30), child: Center(child: CircularProgressIndicator()));
            if (snapshot.hasError) return _errorCard(snapshot.error.toString(), p);
            final items = snapshot.data ?? [];
            if (items.isEmpty) return _errorCard('Is category mein products nahi mile.', p);
            return GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .64),
              itemBuilder: (context, index) => _productCard(items[index], p));
          }),
          const SizedBox(height: 12), Center(child: Text('Haider Store • haiderstore.shop', style: TextStyle(color: p.muted, fontSize: 12))),
        ])),
      bottomNavigationBar: BottomNavigationBar(type: BottomNavigationBarType.fixed, backgroundColor: p.surface, selectedItemColor: p.primary, unselectedItemColor: p.muted,
        currentIndex: 0, onTap: (i) { if (i == 1) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Categories upar available hain.'))); } else if (i > 1) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account aur orders aglay development phase mein add honge.'))); } },
        items: const [BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'), BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Categories'), BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'), BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Account')]),
    );
  }

  Widget _sectionTitle(String title, StorePalette p) => Text(title, style: TextStyle(color: p.text, fontSize: 19, fontWeight: FontWeight.bold));

  Widget _categoryChip(String label, String? value, StorePalette p) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(label), selected: selectedCategory == value,
    onSelected: (_) { setState(() => selectedCategory = value); _reloadProducts(); }, selectedColor: p.primary.withValues(alpha: .25), side: BorderSide(color: p.primary.withValues(alpha: .45))));

  Widget _productCard(dynamic item, StorePalette p) {
    final name = (item['name'] ?? 'Product').toString();
    final image = _imageUrl(item['image']);
    final price = (item['price'] as num?)?.toDouble() ?? 0;
    final original = (item['original_price'] as num?)?.toDouble() ?? price;
    final discount = (item['discount_percent'] as num?)?.toDouble() ?? 0;
    return Container(decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.primary.withValues(alpha: .18))),
      clipBehavior: Clip.antiAlias, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Stack(fit: StackFit.expand, children: [
          Container(color: p.isDark ? Colors.white : Colors.black.withValues(alpha: .03), child: image.isEmpty ? Icon(Icons.image_outlined, size: 48, color: p.muted) : Image.network(image, fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported_outlined, size: 42, color: p.muted))),
          if (discount > 0) Positioned(top: 8, left: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: p.primary, borderRadius: BorderRadius.circular(7)), child: Text('${discount.toStringAsFixed(0)}% OFF', style: TextStyle(color: p.onPrimary, fontSize: 10, fontWeight: FontWeight.bold)))),
        ])),
        Padding(padding: const EdgeInsets.fromLTRB(10, 9, 10, 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: p.text, fontWeight: FontWeight.w700, fontSize: 12.5, height: 1.25)),
          const SizedBox(height: 7), Text('Rs. ${price.toStringAsFixed(0)}', style: TextStyle(color: p.primary, fontWeight: FontWeight.w900, fontSize: 16)),
          if (discount > 0) Text('Rs. ${original.toStringAsFixed(0)}', style: TextStyle(color: p.muted, fontSize: 11, decoration: TextDecoration.lineThrough)),
          const SizedBox(height: 3), Text((item['stock'] as num? ?? 0) > 0 ? 'In Stock' : 'Out of Stock', style: TextStyle(color: (item['stock'] as num? ?? 0) > 0 ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.w600)),
        ])),
      ]));
  }

  Widget _errorCard(String message, StorePalette p) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14)), child: Text(message, style: TextStyle(color: p.muted)));
}
