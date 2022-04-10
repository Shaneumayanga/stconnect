import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class ViewPaperPage extends StatefulWidget {
  final link;
  ViewPaperPage(this.link);
  @override
  _ViewPaperPageState createState() => _ViewPaperPageState();
}

class _ViewPaperPageState extends State<ViewPaperPage> {
  bool isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.link);
  }

  loaddocument() async {
    this.document = await PDFDocument.fromURL(widget.link);
    setState(() {
      this.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? Center(
                child: Text(
                  "Loading.....",
                  style: TextStyle(color: Colors.black54),
                ),
              )
            : PDFViewer(document: this.document),
      ),
    );
  }
}
