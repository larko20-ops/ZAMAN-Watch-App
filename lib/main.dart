import 'package:flutter/material.dart';

void main() => runApp(const ZamanApp());

class Watch {
  final String name, category, price, description;
  final List<String> images;
  const Watch(this.name, this.category, this.price, this.description, this.images);
}

const rotary = Watch(
  'ROTARY',
  'کلاسیک',
  '١١٠,٠٠٠ د.ع',
  'سەعاتێکی کلاسیک بە دایڵی شینی تۆخ، بەستەری ڕەش و Swiss Made.',
  [
    'assets/rotary_1.jpg',
    'assets/rotary_2.jpg',
    'assets/rotary_3.jpg',
    'assets/rotary_4.jpg',
    'assets/rotary_5.jpg',
  ],
);

const watches = [
  rotary,
  Watch('ZAMAN Sport', 'سپۆرت', '١٥٠,٠٠٠ د.ع', 'سووک و گونجاو بۆ چالاکییەکان', ['assets/rotary_1.jpg']),
  Watch('ZAMAN Royal', 'لوکس', '٢٥٠,٠٠٠ د.ع', 'دیزاینی تایبەت و ستایلی لوکس', ['assets/rotary_2.jpg']),
];

class ZamanApp extends StatelessWidget {
  const ZamanApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZAMAN',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080808),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC99D5B),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String category = 'هەموو', query = '';
  List<Watch> get filtered => watches.where((w) {
    final catOk = category == 'هەموو' || w.category == category;
    final q = query.trim().toLowerCase();
    return catOk && (q.isEmpty || w.name.toLowerCase().contains(q) || w.description.toLowerCase().contains(q));
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(children: [
            Image.asset('assets/zaman_logo.png', width: 58, height: 42, fit: BoxFit.contain),
            const SizedBox(width: 8),
            const Text('ZAMAN', style: TextStyle(color: Color(0xFFD0A45F), fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: 3)),
          ]),
        ),
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('سەعاتەکان', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('سادە، شیک، و داواکارییەکی خێرا', style: TextStyle(color: Colors.grey.shade400)),
              const SizedBox(height: 14),
              TextField(
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  hintText: 'گەڕان بۆ سەعات...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true, fillColor: const Color(0xFF151515),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(height: 42, child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['هەموو','کلاسیک','سپۆرت','لوکس'].map((c) {
                  final active = c == category;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(c), selected: active,
                      onSelected: (_) => setState(() => category = c),
                      selectedColor: const Color(0xFF3A2B18),
                      side: BorderSide(color: active ? const Color(0xFFC99D5B) : Colors.grey.shade800),
                    ),
                  );
                }).toList(),
              )),
            ]),
          )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => WatchCard(watch: filtered[index]),
                childCount: filtered.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .66,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class WatchCard extends StatelessWidget {
  final Watch watch;
  const WatchCard({super.key, required this.watch});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WatchDetailPage(watch: watch))),
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade800)),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Image.asset(watch.images.first, width: double.infinity, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(11),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(watch.category, style: const TextStyle(color: Color(0xFFC99D5B), fontSize: 11)),
              const SizedBox(height: 3),
              Text(watch.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(watch.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
              const SizedBox(height: 7),
              Text(watch.price, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC99D5B), foregroundColor: Colors.black),
                onPressed: () => showOrderSheet(context, watch),
                child: const Text('داواکاری بکە', style: TextStyle(fontWeight: FontWeight.w800)),
              )),
            ]),
          ),
        ]),
      ),
    );
  }
}

class WatchDetailPage extends StatelessWidget {
  final Watch watch;
  const WatchDetailPage({super.key, required this.watch});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(watch.name)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: watch.images.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(watch.images[i], fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(watch.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(watch.description, style: TextStyle(color: Colors.grey.shade400, height: 1.6)),
            const SizedBox(height: 10),
            Text(watch.price, style: const TextStyle(color: Color(0xFFD0A45F), fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC99D5B), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: () => showOrderSheet(context, watch),
              child: const Text('داواکاری بکە', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}

void showOrderSheet(BuildContext context, Watch watch) {
  final name = TextEditingController(), phone = TextEditingController(), address = TextEditingController(), qty = TextEditingController(text: '1');
  showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: const Color(0xFF151515),
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(left:18,right:18,top:20,bottom:MediaQuery.of(context).viewInsets.bottom+20),
        child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('داواکاری سەعات', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height:5),
          Text('بەرهەم: ${watch.name}', style: const TextStyle(color: Color(0xFFC99D5B), fontWeight: FontWeight.w700)),
          const SizedBox(height:14),
          field(name,'ناوی کڕیار','ناوی تۆ'),
          field(phone,'ژمارەی مۆبایل','07xx xxx xxxx', keyboard: TextInputType.phone),
          field(address,'شوێنی گەیاندن','سلێمانی / ناونیشان'),
          field(qty,'ژمارەی دانە','1', keyboard: TextInputType.number),
          const SizedBox(height:8),
          const Text('پارەدان: کاش لە کاتی گەیاندن یان بانکی', style: TextStyle(color: Color(0xFFC99D5B))),
          const SizedBox(height:10),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC99D5B), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical:13)),
            onPressed: () {
              if (name.text.trim().isEmpty || phone.text.trim().isEmpty || address.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تکایە ناو، ژمارەی مۆبایل و ناونیشان پڕ بکەرەوە.')));
                return;
              }
              Navigator.pop(context);
              showDialog(context: context, builder: (_) => AlertDialog(
                title: const Text('داواکارییەکەت وەرگیرا ✓'),
                content: const Text('زانیارییەکانت تۆمار کران. بۆ پشتڕاستکردنەوە پەیوەندیت پێوە دەکرێت.'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('باشە'))],
              ));
            },
            child: const Text('ناردنی داواکاری', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ])),
      ),
    ),
  );
}

Widget field(TextEditingController c, String label, String hint, {TextInputType? keyboard}) => Padding(
  padding: const EdgeInsets.only(bottom:10),
  child: TextField(
    controller:c, keyboardType:keyboard,
    decoration: InputDecoration(labelText:label,hintText:hint,filled:true,fillColor:const Color(0xFF202020),border:OutlineInputBorder(borderRadius:BorderRadius.circular(11))),
  ),
);
