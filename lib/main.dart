import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget { 
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'MyApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MyApp")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PDFViewerPage()),
            );
          },
          child: Text('View PDF'),
        ),
      ),
    );
  }
}

class PDFViewerPage extends StatefulWidget {

  const PDFViewerPage({super.key});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? pdfPath;
  bool isPdfLoaded = false;

  @override
  void initState() {
    super.initState();
    loadPdfFromNetwork();
  }

  Future<void> loadPdfFromNetwork() async {
    final url =
        'https://dn790007.ca.archive.org/0/items/The_World_of_Interiors_October_2015_UK/The_World_of_Interiors_October_2015_UK.pdf';
    try {
      final Directory dir = await getApplicationDocumentsDirectory();
      final filename = basename(url);
      final File file = File('${dir.path}/$filename');
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      
      await file.writeAsBytes(bytes, flush: true);
            setState(() {
        pdfPath = file.path;
        isPdfLoaded = true;
      });
    } catch (e) {
      setState(() {
        isPdfLoaded = false;
        pdfPath = null;
      });
          }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: Center(
        child:
            isPdfLoaded
                ? PDFView(
                  filePath: pdfPath!,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageSnap: true,
                  pageFling: true,
                  onError: (error) {},
                )
                : const CircularProgressIndicator(),
      ),
    );
  }
}
