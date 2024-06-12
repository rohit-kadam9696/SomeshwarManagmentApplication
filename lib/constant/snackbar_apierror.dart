import 'package:flutter/material.dart';
class SnackbarHelper {
  static void showSnackBar2(BuildContext context,{String? msg, Duration duration = const Duration(seconds: 5),
    double? height,})
  {
    final card = SizedBox(
      // height:  (height ?? 100.0) - 50.0,
      child: Card(
        margin: EdgeInsets.only(left: 16, top: 10),
        color: Colors.red,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$msg',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final snackBarOverlay = Stack(
      children: [
        Positioned(
          left: 0,
          bottom: 20,
          right: 20,
          child: card,
        ),
      ],
    );
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => snackBarOverlay,
    ));
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pop(context);
    });
  }



  // static void showSnackBar2(BuildContext context, {String? msg, double? height, Duration duration = const Duration(seconds: 10)}) {
  //   final snackBar = SnackBar(
  //     content: SizedBox(
  //       // height:  (height ?? 100.0) - 50.0,
  //       child: Card(
  //         margin: EdgeInsets.only(left: 16, top: 10),
  //         color: Colors.red,
  //         shape: RoundedRectangleBorder(
  //           side: BorderSide(
  //             color: Colors.green,
  //             width: 2.0,
  //           ),
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 '$msg',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 20.0,
  //                 ),
  //               ),
  //               SizedBox(height: 8.0),
  //
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     duration: duration,
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
  //

  static void showSnackbar(
      BuildContext context, {
        String? msg,
        double? height,}
      )
  {
    final card = SizedBox(
      // height:  (height ?? 100.0) - 50.0,
      child: Card(
        margin: EdgeInsets.only(left: 16, top: 10),
        color: Colors.red,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$msg',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(

                    onPressed: () {
                    //  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.green,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );


    // Wrap the main content in a Stack
    final snackBarOverlay = Stack(
      children: [
        Positioned(
          left: 0,
          bottom: 20,
          right: 20,
          child: card,
        ),
      ],
    );

    // Display the Snackbar overlay
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => snackBarOverlay,
    ));
  }
}

