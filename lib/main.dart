import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

// ─────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const TurismoApp());
}

// ─────────────────────────────────────────────────────
// COSTANTI COLORI E STILE
// ─────────────────────────────────────────────────────

const kGreen      = Color(0xFF1B4332);
const kGreenLight = Color(0xFF2D6A4F);
const kGold       = Color(0xFFE9A825);
const kCream      = Color(0xFFF7F5F0);
const kWhite      = Color(0xFFFFFFFF);
const kTextDark   = Color(0xFF1A1A1A);
const kTextMuted  = Color(0xFF6B7280);
const kCardRadius = 16.0;

// ─────────────────────────────────────────────────────
// MODELLI DATI
// ─────────────────────────────────────────────────────

class Posto {
  final String nome, descrizione, imageUrl, categoria, luogo;
  final bool isSecret;
  final double rating;
  const Posto({
    required this.nome,
    required this.descrizione,
    required this.imageUrl,
    required this.categoria,
    required this.luogo,
    required this.rating,
    this.isSecret = false,
  });
}

class Ristorante {
  final String nome, tipo, descrizione, imageUrl, priceRange, indirizzo, bookingUrl;
  final double rating;
  final List<String> tags;
  const Ristorante({
    required this.nome,
    required this.tipo,
    required this.descrizione,
    required this.imageUrl,
    required this.rating,
    required this.priceRange,
    required this.indirizzo,
    required this.bookingUrl,
    required this.tags,
  });
}

class Struttura {
  final String nome, tipo, descrizione, imageUrl, pricePerNight, bookingUrl;
  final double rating;
  final List<String> servizi;
  const Struttura({
    required this.nome,
    required this.tipo,
    required this.descrizione,
    required this.imageUrl,
    required this.rating,
    required this.pricePerNight,
    required this.bookingUrl,
    required this.servizi,
  });
}

class Evento {
  final String titolo, descrizione, imageUrl, data, luogo, organizzatore, categoria;
  final bool isGratuito;
  const Evento({
    required this.titolo,
    required this.descrizione,
    required this.imageUrl,
    required this.data,
    required this.luogo,
    required this.organizzatore,
    required this.categoria,
    required this.isGratuito,
  });
}

class Post {
  final String autore, avatarUrl, testo, tempo;
  final String? imageUrl;
  final int likes, commenti;
  const Post({
    required this.autore,
    required this.avatarUrl,
    required this.testo,
    required this.tempo,
    required this.likes,
    required this.commenti,
    this.imageUrl,
  });
}

// ─────────────────────────────────────────────────────
// MOCK DATA
// ─────────────────────────────────────────────────────

final mockPosti = const [
  Posto(
    nome: 'Cascata del Frassino',
    descrizione: 'Una cascata nascosta raggiungibile solo a piedi, immersa nel bosco. I locals ci vengono d\'estate per fare il bagno nelle pozze naturali.',
    imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
    categoria: 'Natura',
    luogo: '2.3 km dal centro',
    rating: 4.9,
    isSecret: true,
  ),
  Posto(
    nome: 'Torre Medievale',
    descrizione: 'Simbolo della città, offre una vista panoramica mozzafiato su tutta la vallata. Imperdibile al tramonto.',
    imageUrl: 'https://images.unsplash.com/photo-1533929736458-ca588d08c8be?w=800',
    categoria: 'Storia',
    luogo: 'Centro storico',
    rating: 4.7,
  ),
  Posto(
    nome: 'Vigneto della Collina',
    descrizione: 'Azienda agricola familiare che produce il vino locale DOC. Degustazioni su prenotazione, imperdibile il Rosso Riserva.',
    imageUrl: 'https://images.unsplash.com/photo-1504279807002-09854ccc9b6c?w=800',
    categoria: 'Enogastronomia',
    luogo: 'Contrada Belvedere',
    rating: 4.8,
    isSecret: true,
  ),
  Posto(
    nome: 'Lago delle Streghe',
    descrizione: 'Piccolo lago di origine glaciale circondato da leggende locali. Perfetto per trekking all\'alba con vista unica.',
    imageUrl: 'https://images.unsplash.com/photo-1439853949212-36689e9e4d57?w=800',
    categoria: 'Natura',
    luogo: '8 km nord',
    rating: 4.6,
    isSecret: true,
  ),
  Posto(
    nome: 'Piazza del Mercato',
    descrizione: 'Ogni sabato mattina si anima con il mercato degli agricoltori. Formaggi, salumi, verdure e artigianato.',
    imageUrl: 'https://images.unsplash.com/photo-1573246123716-6b1782bfc499?w=800',
    categoria: 'Tradizioni',
    luogo: 'Centro',
    rating: 4.5,
  ),
];

final mockRistoranti = const [
  Ristorante(
    nome: 'Trattoria della Nonna',
    tipo: 'Cucina tipica',
    descrizione: 'Ricette della tradizione regionale, pasta fatta a mano ogni giorno. Aperto dal 1962.',
    imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
    rating: 4.9,
    priceRange: '€€',
    indirizzo: 'Via Roma 12',
    bookingUrl: 'https://example.com/prenota/nonna',
    tags: ['Pasta fatta in casa', 'Vino locale', 'Senza glutine'],
  ),
  Ristorante(
    nome: 'Pizzeria da Rocco',
    tipo: 'Pizza napoletana',
    descrizione: 'Forno a legna, impasto con 48h di lievitazione. La margherita più buona della zona, parola di local.',
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
    rating: 4.7,
    priceRange: '€',
    indirizzo: 'Corso Italia 45',
    bookingUrl: 'https://example.com/prenota/rocco',
    tags: ['Pizza napoletana', 'Forno a legna', 'Asporto'],
  ),
  Ristorante(
    nome: 'Osteria del Borgo',
    tipo: 'Bistrot creativo',
    descrizione: 'Cucina che reinterpreta la tradizione con ingredienti a km zero. Menu degustazione da 5 portate.',
    imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
    rating: 4.8,
    priceRange: '€€€',
    indirizzo: 'Vicolo dei Fiori 3',
    bookingUrl: 'https://example.com/prenota/borgo',
    tags: ['Km zero', 'Menu degustazione', 'Vegetariano'],
  ),
  Ristorante(
    nome: 'Bar Centrale',
    tipo: 'Bar & Colazioni',
    descrizione: 'Il ritrovo dei locals dalle 7 del mattino. Cornetti artigianali, caffè torrefatto e aperitivo.',
    imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
    rating: 4.6,
    priceRange: '€',
    indirizzo: 'Piazza del Duomo 1',
    bookingUrl: 'https://example.com/prenota/centrale',
    tags: ['Colazione', 'Aperitivo', 'WiFi'],
  ),
];

final mockStrutture = const [
  Struttura(
    nome: 'Villa Belvedere',
    tipo: 'Hotel ★★★★',
    descrizione: 'Villa d\'epoca ristrutturata con vista panoramica sulla vallata. Piscina, spa e ristorante interno.',
    imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
    rating: 4.9,
    pricePerNight: 'da €185 / notte',
    bookingUrl: 'https://example.com/prenota/villa',
    servizi: ['Piscina', 'Spa', 'Colazione', 'WiFi', 'Parking'],
  ),
  Struttura(
    nome: 'Agriturismo Le Olive',
    tipo: 'Agriturismo',
    descrizione: 'Immerso negli ulivi, produce olio extravergine biologico. Colazione con prodotti freschi dell\'orto.',
    imageUrl: 'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=800',
    rating: 4.8,
    pricePerNight: 'da €95 / notte',
    bookingUrl: 'https://example.com/prenota/olive',
    servizi: ['Colazione inclusa', 'Animali ok', 'Piscina', 'WiFi'],
  ),
  Struttura(
    nome: 'B&B Casa Mia',
    tipo: 'B&B',
    descrizione: 'Nel cuore del centro storico, 4 camere accoglienti gestite dalla famiglia Rossi dal 1998.',
    imageUrl: 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800',
    rating: 4.7,
    pricePerNight: 'da €65 / notte',
    bookingUrl: 'https://example.com/prenota/bbcasamia',
    servizi: ['Colazione', 'WiFi', 'Centro storico'],
  ),
];

final mockEventi = const [
  Evento(
    titolo: 'Sagra del Fungo Porcino',
    descrizione: 'La tradizionale sagra autunnale con degustazioni, musica folk dal vivo e mercato dell\'artigianato.',
    imageUrl: 'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=800',
    data: 'Sab 21 – Dom 22 Ott',
    luogo: 'Piazza del Mercato',
    organizzatore: 'Pro Loco',
    categoria: 'Sagra',
    isGratuito: true,
  ),
  Evento(
    titolo: 'Concerto al Castello',
    descrizione: 'Orchestra da camera nel cortile del castello medievale. Musica barocca e serale sotto le stelle.',
    imageUrl: 'https://images.unsplash.com/photo-1499364615650-ec38552f4f34?w=800',
    data: 'Ven 27 Ott ore 21:00',
    luogo: 'Castello Medievale',
    organizzatore: 'Associazione Musica Viva',
    categoria: 'Musica',
    isGratuito: false,
  ),
  Evento(
    titolo: 'Mostra: Arte e Territorio',
    descrizione: 'Esposizione di 30 artisti locali. Vernissage con aperitivo incluso il giorno di apertura.',
    imageUrl: 'https://images.unsplash.com/photo-1531243269054-5ebf6f34081e?w=800',
    data: 'Dal 15 Nov al 10 Dic',
    luogo: 'Palazzo delle Arti',
    organizzatore: 'Comune',
    categoria: 'Arte',
    isGratuito: true,
  ),
  Evento(
    titolo: 'Trekking Guidato al Lago',
    descrizione: 'Escursione al Lago delle Streghe con guida naturalistica. Prenotazione obbligatoria. Max 15 partecipanti.',
    imageUrl: 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=800',
    data: 'Dom 29 Ott ore 8:00',
    luogo: 'Ritrovo Piazza Roma',
    organizzatore: 'Club Alpino',
    categoria: 'Sport',
    isGratuito: false,
  ),
];

final mockPost = const [
  Post(
    autore: 'Marco Bianchi',
    avatarUrl: 'https://i.pravatar.cc/100?img=3',
    testo: 'Finalmente ho trovato la Cascata del Frassino! Un posto magico, ci tornerò sicuramente. Portatevi il costume 🏊‍♂️',
    imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
    likes: 47,
    commenti: 12,
    tempo: '2 ore fa',
  ),
  Post(
    autore: 'Giulia Ferretti',
    avatarUrl: 'https://i.pravatar.cc/100?img=9',
    testo: 'Consiglio vivamente la Trattoria della Nonna per chi cerca sapori autentici. I tortellini in brodo erano incredibili ❤️',
    imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
    likes: 31,
    commenti: 8,
    tempo: '5 ore fa',
  ),
  Post(
    autore: 'Luca Montanari',
    avatarUrl: 'https://i.pravatar.cc/100?img=15',
    testo: 'Ho scoperto una stradina nel borgo vecchio con una vista incredibile al tramonto. Sapete dove andate a scattare? Vi mostro il posto!',
    likes: 23,
    commenti: 19,
    tempo: 'Ieri',
  ),
  Post(
    autore: 'Chiara Romano',
    avatarUrl: 'https://i.pravatar.cc/100?img=23',
    testo: 'Il Vigneto della Collina mi ha cambiato la vita. Il loro Rosso DOC è una bomba. Chiamate prima per prenotare la degustazione! 🍷',
    imageUrl: 'https://images.unsplash.com/photo-1504279807002-09854ccc9b6c?w=800',
    likes: 58,
    commenti: 15,
    tempo: '2 giorni fa',
  ),
];

// ─────────────────────────────────────────────────────
// APP ROOT
// ─────────────────────────────────────────────────────

class TurismoApp extends StatelessWidget {
  const TurismoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scopri la Regione',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kGreen,
          brightness: Brightness.light,
        ).copyWith(primary: kGreen, secondary: kGold),
        scaffoldBackgroundColor: kCream,
        textTheme: GoogleFonts.outfitTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: kCream,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: kTextDark),
        ),
      ),
      home: const MainNavigator(),
    );
  }
}

// ─────────────────────────────────────────────────────
// NAVIGATORE PRINCIPALE
// ─────────────────────────────────────────────────────

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});
  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MangiScreen(),
    DormiScreen(),
    EventiScreen(),
    CommunityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: kWhite,
        elevation: 8,
        shadowColor: Colors.black12,
        indicatorColor: kGreen.withOpacity(0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore, color: kGreen),
            label: 'Scopri',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant, color: kGreen),
            label: 'Mangia',
          ),
          NavigationDestination(
            icon: Icon(Icons.bed_outlined),
            selectedIcon: Icon(Icons.bed, color: kGreen),
            label: 'Dormi',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event, color: kGreen),
            label: 'Eventi',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people, color: kGreen),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// WIDGET CONDIVISI
// ─────────────────────────────────────────────────────

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  const StarRating({super.key, required this.rating, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size, color: kGold),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size - 1, fontWeight: FontWeight.w600, color: kTextDark),
        ),
      ],
    );
  }
}

class ChipTag extends StatelessWidget {
  final String label;
  const ChipTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: kGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: kGreenLight, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class SecretBadge extends StatelessWidget {
  const SecretBadge({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(20)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_open_rounded, size: 10, color: Colors.white),
          SizedBox(width: 3),
          Text('Posto segreto', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

Widget netImg(String url, {double? height, BoxFit fit = BoxFit.cover}) {
  return Image.network(
    url,
    height: height,
    width: double.infinity,
    fit: fit,
    loadingBuilder: (ctx, child, progress) {
      if (progress == null) return child;
      return Container(
        height: height,
        color: kGreen.withOpacity(0.05),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: kGreen)),
      );
    },
    errorBuilder: (ctx, err, st) => Container(
      height: height,
      color: kGreen.withOpacity(0.06),
      child: const Icon(Icons.landscape_rounded, color: kGreenLight, size: 40),
    ),
  );
}

// ─────────────────────────────────────────────────────
// HOME / SCOPRI
// ─────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 230,
            floating: false,
            pinned: true,
            backgroundColor: kGreen,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scopri la Regione',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'Posti, sapori e segreti locali',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  netImg(
                    'https://images.unsplash.com/photo-1525874684015-58379d421a52?w=900',
                    height: 230,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x22000000), Color(0xDD1B4332)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: kTextMuted, size: 20),
                        const SizedBox(width: 10),
                        Text('Cerca posti, ristoranti, eventi...', style: TextStyle(color: kTextMuted, fontSize: 14)),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Categorie rapide
                  Text('Esplora per categoria',
                    style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700, color: kTextDark)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _QuickCat(icon: Icons.park_rounded, label: 'Natura'),
                      _QuickCat(icon: Icons.account_balance_rounded, label: 'Storia'),
                      _QuickCat(icon: Icons.wine_bar_rounded, label: 'Vino'),
                      _QuickCat(icon: Icons.hiking_rounded, label: 'Trekking'),
                    ],
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 28),

                  // In evidenza
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Da non perdere',
                        style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700, color: kTextDark)),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Tutti', style: TextStyle(color: kGreenLight, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  ...mockPosti.take(2).toList().asMap().entries.map((e) =>
                    PostoCardLarge(posto: e.value)
                      .animate(delay: Duration(milliseconds: e.key * 80))
                      .fadeIn()
                      .slideY(begin: 0.08, end: 0),
                  ),

                  const SizedBox(height: 8),

                  // Posti segreti dei local
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kGold.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kGold.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lock_open_rounded, color: kGold, size: 18),
                            const SizedBox(width: 8),
                            Text('Posti segreti dei local',
                              style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w700, color: kTextDark)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text('Luoghi che non trovi sulle guide turistiche',
                          style: TextStyle(fontSize: 12, color: kTextMuted)),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 160,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: mockPosti
                              .where((p) => p.isSecret)
                              .map((p) => Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: _PostoCardSmall(posto: p),
                              ))
                              .toList(),
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 200.ms).fadeIn(),

                  const SizedBox(height: 28),

                  Text('Altri luoghi',
                    style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700, color: kTextDark)),
                  const SizedBox(height: 4),

                  ...mockPosti.skip(2).toList().asMap().entries.map((e) =>
                    PostoCardLarge(posto: e.value)
                      .animate(delay: Duration(milliseconds: e.key * 80))
                      .fadeIn()
                      .slideY(begin: 0.08, end: 0),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickCat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(18)),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kTextDark)),
      ],
    );
  }
}

class PostoCardLarge extends StatelessWidget {
  final Posto posto;
  const PostoCardLarge({super.key, required this.posto});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 14)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(kCardRadius)),
            child: Stack(
              children: [
                netImg(posto.imageUrl, height: 185),
                Positioned(
                  top: 12, left: 12,
                  child: ChipTag(label: posto.categoria),
                ),
                if (posto.isSecret)
                  const Positioned(top: 12, right: 12, child: SecretBadge()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(posto.nome,
                        style: GoogleFonts.playfairDisplay(fontSize: 17, fontWeight: FontWeight.w700, color: kTextDark)),
                    ),
                    StarRating(rating: posto.rating),
                  ],
                ),
                const SizedBox(height: 6),
                Text(posto.descrizione,
                  style: const TextStyle(fontSize: 13, color: kTextMuted, height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: kGreenLight),
                    const SizedBox(width: 4),
                    Text(posto.luogo, style: const TextStyle(fontSize: 12, color: kGreenLight, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostoCardSmall extends StatelessWidget {
  final Posto posto;
  const _PostoCardSmall({required this.posto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: netImg(posto.imageUrl, height: 90),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(posto.nome,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kTextDark),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                StarRating(rating: posto.rating, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// MANGIA SCREEN
// ─────────────────────────────────────────────────────

class MangiScreen extends StatelessWidget {
  const MangiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dove Mangiare',
              style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: kTextDark)),
            const Text('Ristoranti · Pizzerie · Bar',
              style: TextStyle(fontSize: 12, color: kTextMuted, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.tune_rounded, color: kGreen), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockRistoranti.length,
        itemBuilder: (ctx, i) => _RistoranteCard(ristorante: mockRistoranti[i])
          .animate(delay: Duration(milliseconds: i * 80))
          .fadeIn().slideY(begin: 0.08, end: 0),
      ),
    );
  }
}

class _RistoranteCard extends StatelessWidget {
  final Ristorante ristorante;
  const _RistoranteCard({required this.ristorante});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 14)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(kCardRadius)),
            child: Stack(
              children: [
                netImg(ristorante.imageUrl, height: 165),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 20, 14, 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.65)],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ristorante.tipo,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                          child: Text(ristorante.priceRange,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kTextDark)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(ristorante.nome,
                        style: GoogleFonts.playfairDisplay(fontSize: 17, fontWeight: FontWeight.w700, color: kTextDark)),
                    ),
                    StarRating(rating: ristorante.rating),
                  ],
                ),
                const SizedBox(height: 6),
                Text(ristorante.descrizione,
                  style: const TextStyle(fontSize: 13, color: kTextMuted, height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: ristorante.tags.map((t) => ChipTag(label: t)).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: kTextMuted),
                    const SizedBox(width: 4),
                    Text(ristorante.indirizzo, style: const TextStyle(fontSize: 12, color: kTextMuted)),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => launchUrl(Uri.parse(ristorante.bookingUrl)),
                    icon: const Icon(Icons.calendar_today_rounded, size: 16),
                    label: const Text('Prenota un tavolo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// DORMI SCREEN
// ─────────────────────────────────────────────────────

class DormiScreen extends StatelessWidget {
  const DormiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dove Dormire',
              style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: kTextDark)),
            const Text('Hotel · B&B · Agriturismi · Camping',
              style: TextStyle(fontSize: 12, color: kTextMuted, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_business_rounded, size: 15),
              label: const Text('Iscriviti', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockStrutture.length,
        itemBuilder: (ctx, i) => _StrutturaCard(struttura: mockStrutture[i])
          .animate(delay: Duration(milliseconds: i * 80))
          .fadeIn().slideY(begin: 0.08, end: 0),
      ),
    );
  }
}

class _StrutturaCard extends StatelessWidget {
  final Struttura struttura;
  const _StrutturaCard({required this.struttura});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 14)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(kCardRadius),
              bottomLeft: Radius.circular(kCardRadius),
            ),
            child: SizedBox(
              width: 115,
              height: 145,
              child: netImg(struttura.imageUrl, height: 145),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChipTag(label: struttura.tipo),
                  const SizedBox(height: 6),
                  Text(struttura.nome,
                    style: GoogleFonts.playfairDisplay(fontSize: 15, fontWeight: FontWeight.w700, color: kTextDark)),
                  const SizedBox(height: 4),
                  Text(struttura.descrizione,
                    style: const TextStyle(fontSize: 12, color: kTextMuted, height: 1.3),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StarRating(rating: struttura.rating),
                      const SizedBox(width: 8),
                      ...struttura.servizi.take(2).map((s) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          switch (s) {
                            'Piscina' => Icons.pool_rounded,
                            'WiFi' => Icons.wifi_rounded,
                            'Colazione inclusa' || 'Colazione' => Icons.free_breakfast_rounded,
                            'Spa' => Icons.spa_rounded,
                            'Parking' => Icons.local_parking_rounded,
                            _ => Icons.check_circle_outline_rounded,
                          },
                          size: 14, color: kGreenLight,
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(struttura.pricePerNight,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kGreen)),
                      ElevatedButton(
                        onPressed: () => launchUrl(Uri.parse(struttura.bookingUrl)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Prenota', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// EVENTI SCREEN
// ─────────────────────────────────────────────────────

class EventiScreen extends StatelessWidget {
  const EventiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Eventi',
              style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: kTextDark)),
            const Text('Sagre · Concerti · Mostre · Sport',
              style: TextStyle(fontSize: 12, color: kTextMuted, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('+ Evento', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockEventi.length,
        itemBuilder: (ctx, i) => _EventoCard(evento: mockEventi[i])
          .animate(delay: Duration(milliseconds: i * 80))
          .fadeIn().slideY(begin: 0.08, end: 0),
      ),
    );
  }
}

class _EventoCard extends StatelessWidget {
  final Evento evento;
  const _EventoCard({required this.evento});

  static const _catColors = {
    'Sagra': Color(0xFFE9793A),
    'Musica': Color(0xFF7C4DFF),
    'Arte': Color(0xFFD81B60),
    'Sport': Color(0xFF00897B),
  };

  @override
  Widget build(BuildContext context) {
    final catColor = _catColors[evento.categoria] ?? kGreenLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 14)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(kCardRadius)),
            child: Stack(
              children: [
                netImg(evento.imageUrl, height: 155),
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.circular(20)),
                    child: Text(evento.categoria,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ),
                if (evento.isGratuito)
                  Positioned(
                    top: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: const Text('GRATUITO',
                        style: TextStyle(color: kGreenLight, fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(evento.titolo,
                  style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w700, color: kTextDark)),
                const SizedBox(height: 6),
                Text(evento.descrizione,
                  style: const TextStyle(fontSize: 13, color: kTextMuted, height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: kGreenLight),
                    const SizedBox(width: 4),
                    Text(evento.data,
                      style: const TextStyle(fontSize: 12, color: kTextDark, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 14),
                    const Icon(Icons.location_on_outlined, size: 14, color: kGreenLight),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(evento.luogo,
                        style: const TextStyle(fontSize: 12, color: kTextMuted),
                        overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.people_outline_rounded, size: 14, color: kTextMuted),
                    const SizedBox(width: 4),
                    Text('Organizzato da ${evento.organizzatore}',
                      style: const TextStyle(fontSize: 12, color: kTextMuted)),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border_rounded, size: 16),
                    label: const Text('Salva questo evento'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kGreen,
                      side: const BorderSide(color: kGreen),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// COMMUNITY SCREEN
// ─────────────────────────────────────────────────────

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _tab = 0;
  final List<String> _tabs = ['Feed', 'Recensioni', 'Forum', 'Segnala'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Community',
              style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: kTextDark)),
            const Text('Condividi le tue esperienze',
              style: TextStyle(fontSize: 12, color: kTextMuted, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: kGreen),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: Container(
            color: kWhite,
            child: Row(
              children: _tabs.asMap().entries.map((e) {
                final selected = e.key == _tab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tab = e.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selected ? kGreen : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        e.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                          color: selected ? kGreen : kTextMuted,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: _tab == 0
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockPost.length,
              itemBuilder: (ctx, i) => _PostCard(post: mockPost[i])
                .animate(delay: Duration(milliseconds: i * 80))
                .fadeIn().slideY(begin: 0.08, end: 0),
            )
          : _PlaceholderTab(label: _tabs[_tab]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: kGreen,
        icon: const Icon(Icons.edit_rounded, color: Colors.white),
        label: const Text('Condividi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String label;
  const _PlaceholderTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.construction_rounded, size: 48, color: kGreenLight.withOpacity(0.4)),
          const SizedBox(height: 12),
          Text('Sezione $label', style: GoogleFonts.playfairDisplay(fontSize: 18, color: kTextMuted)),
          const SizedBox(height: 6),
          const Text('In sviluppo nella versione finale',
            style: TextStyle(fontSize: 13, color: kTextMuted)),
        ],
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final Post post;
  const _PostCard({required this.post});
  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 14)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    widget.post.avatarUrl,
                    width: 42, height: 42, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(color: kGreen.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.person_rounded, color: kGreenLight, size: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.post.autore,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kTextDark)),
                      Text(widget.post.tempo,
                        style: const TextStyle(fontSize: 11, color: kTextMuted)),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz_rounded, color: kTextMuted),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Text(widget.post.testo,
              style: const TextStyle(fontSize: 14, color: kTextDark, height: 1.45)),
          ),
          if (widget.post.imageUrl != null)
            ClipRRect(
              child: netImg(widget.post.imageUrl!, height: 210),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _liked = !_liked),
                  child: Row(
                    children: [
                      Icon(
                        _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 20,
                        color: _liked ? Colors.red : kTextMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.post.likes + (_liked ? 1 : 0)}',
                        style: TextStyle(fontSize: 13, color: _liked ? Colors.red : kTextMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: kTextMuted),
                    const SizedBox(width: 4),
                    Text('${widget.post.commenti}',
                      style: const TextStyle(fontSize: 13, color: kTextMuted)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.share_outlined, size: 20, color: kTextMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
