import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class pdfViewer extends StatefulWidget {
  late String pdfLink;
  pdfViewer(this.pdfLink, {Key? key}) : super(key: key);


  @override
  State<pdfViewer> createState() => _pdfViewer();

}

class _pdfViewer extends State<pdfViewer> {
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();

    loadDocument();
  }

  void loadDocument() async {
    document = await PDFDocument.fromURL(widget.pdfLink);

    setState(() => _isLoading = false);
  }

  // changePDF(value) async {
  //   setState(() => _isLoading = true);
  //   if (value == 1) {
  //     document = await PDFDocument.fromAsset('assets/sample2.pdf');
  //   } else if (value == 2) {
  //     document = await PDFDocument.fromURL(
  //       "https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf",
  //       /* cacheManager: CacheManager(
  //         Config(
  //           "customCacheKey",
  //           stalePeriod: const Duration(days: 2),
  //           maxNrOfCacheObjects: 10,
  //         ),
  //       ), */
  //     );
  //   } else {
  //     document = await PDFDocument.fromAsset('assets/sample.pdf');
  //   }
  //   setState(() => _isLoading = false);
  //   Navigator.pop(context);
  // }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      onPopInvoked: (back) async{
        print('lol');
        Navigator.maybePop(context);
      },
      child: SafeArea(
          child:  Scaffold(body : _isLoading ? Center(child: CircularProgressIndicator()) : PDFViewer(document: document,tooltip: PDFViewerTooltip(first: 'lol'),enableSwipeNavigation: true)),


      ),
    );
  }
}