import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CreatePDF extends StatefulWidget {
  const CreatePDF({Key? key}) : super(key: key);

  @override
  State<CreatePDF> createState() => _CreatePDFState();
}

class _CreatePDFState extends State<CreatePDF> {
  TextEditingController textEditingController = TextEditingController();
  FilePickerResult? result;
  // PdfDocument? document;
  // PdfTextExtractor? extractorText;
  File? file;


  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blue,
        title: const Text(
          'P D F V I E W',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  textEditingController.text = value;
                  textEditingController.selection = TextSelection.collapsed(
                    offset: value.length,
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        selectPDF();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        child: const Text(
                          'Select PDF',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        createPDF();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        child: const Text(
                          'Create PDF',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void selectPDF() async {
    result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    final path = result?.files.single.path;
    file = File(path!);

    // final image = pw.MemoryImage(file!.readAsBytesSync());
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Text('Xin chaoooooooo', style: pw.TextStyle(color: PdfColors.red)),
      ); // Center
    }));
    await file!.writeAsBytes(await pdf.save());

    // document = PdfDocument(inputBytes: file?.readAsBytesSync());
    //
    // const String paragraphText =
    //     'Adobe Systems Incorporated\'s Portable Document Format (PDF) is the de facto'
    //     'standard for the accurate, reliable, and platform-independent representation of a paged'
    //     'document.';
    //
    // extractorText = PdfTextExtractor(document!);
    // String text = extractorText!.extractText();
    // log('text: $text');
    // setState(() {
    //   textEditingController.text = text;
    // });
  }

  void createPDF() async {
    // Create a new PDF text element class and draw the flow layout text.
    // final PdfLayoutResult layoutResult = PdfTextElement(
    //   text: textEditingController.text,
    //   font: PdfStandardFont(PdfFontFamily.courier, 13),
    //   brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    // ).draw(
    //   page: document?.pages[0],
    //   bounds: Rect.fromLTWH(
    //       50,
    //       80,
    //       document!.pages[0].getClientSize().width - 100,
    //       document!.pages[0].getClientSize().height),
    //   format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
    // )!;
    // file?.writeAsBytes(document!.saveSync());
    // log('textEditingController: ${textEditingController.text}');
    // textEditingController.clear();
    // // _showResult(text);
    // document!.dispose();
  }

  void _showResult(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Extracted text'),
            content: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Text(text),
            ),
            actions: [
              InkWell(
                child: const Text('Close'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
