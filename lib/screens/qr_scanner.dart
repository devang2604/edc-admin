import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vp_admin/constants.dart';
import 'package:vp_admin/models/ticket_data.dart';
import 'package:vp_admin/services/database.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Coloes,/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 5, child: _buildQrView(context)),
          Expanded(
            flex: 2,
            child: Container(
              // margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (result != null)
                    // Text(
                    //     'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                    _buildResultView()
                  else
                    const Center(
                      child: Text(
                        'Scan a code',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 240.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: kViolet,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        //Flash Light Button
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: IconButton(
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
                icon: FutureBuilder(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    bool? isFlashOn = snapshot.data;
                    if (isFlashOn == null) {
                      return const Icon(Icons.flash_off);
                    }
                    return isFlashOn
                        ? const Icon(Icons.flash_on)
                        : const Icon(Icons.flash_off);
                  },
                )),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _buildResultView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              //Reset Button
              IconButton(
                onPressed: () {
                  setState(() {
                    result = null;
                  });
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            'Code Detected: ${result!.code}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          //Verify ticket id
          FutureBuilder<TicketData?>(
            future: DatabaseService().verifyTicketId(result!.code),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                TicketData ticketData = snapshot.data!;
                //Show gif
                return Row(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset('assets/gifs/success.gif'),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Ticket Verified',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    FutureBuilder<bool>(
                      future:
                          DatabaseService().isUserAdmitted(ticketData.ticketId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final isAdmitted = snapshot.data!;
                          if (isAdmitted) {
                            return const Text(
                              "User is admitted",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            );
                          } else {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 50),
                              ),
                              onPressed: () async {
                                DatabaseService.addTicketToAdmittedUser(
                                    ticketData);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("User added"),
                                  ),
                                );
                                setState(() {});
                              },
                              child: const Text("Admit User"),
                            );
                          }
                        } else {
                          return const LinearProgressIndicator();
                        }
                      },
                    )
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ticket Not Found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/gifs/not-found.gif',
                      height: 100,
                      width: 100,
                    ),
                  ],
                );
              }
            },
          )
        ],
      ),
    );
  }
}
