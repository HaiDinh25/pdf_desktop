import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../create_pdf/create_pdf.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<XFile> _list = [];

  bool _dragging = false;

  var pdfPinchController =
      PdfControllerPinch(document: PdfDocument.openAsset(''));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'P D F V I E W',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _list.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: PdfViewPinch(
                    controller: pdfPinchController,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black12,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _list.clear();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Center(
                              child: Text(
                                'Click to open new pdf file',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreatePDF()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Center(
                              child: Text(
                                'Convert to word',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: DottedBorder(
                padding: EdgeInsets.zero,
                strokeWidth: 2,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: Colors.black12,
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                      height: 200,
                      width: 200,
                      child: DropTarget(
                        onDragDone: (detail) {
                          setState(() {
                            _list.addAll(detail.files);
                            pdfPinchController = PdfControllerPinch(
                              document:
                                  PdfDocument.openFile(detail.files.first.path),
                            );
                          });
                        },
                        onDragEntered: (detail) {
                          setState(() {
                            _dragging = true;
                          });
                        },
                        onDragExited: (detail) {
                          setState(() {
                            _dragging = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: () async {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 200,
                              width: 200,
                              color: _dragging
                                  ? Colors.blue.withOpacity(0.4)
                                  : Colors.black12,
                              child: const Center(child: Text("Drop here")),
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ),
    );
  }
}
