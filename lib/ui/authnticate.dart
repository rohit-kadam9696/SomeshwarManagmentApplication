import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticatePage extends StatefulWidget {
  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {
  TextEditingController _pinController = TextEditingController();
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool authenticated = false;
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  final LocalAuthentication auth = LocalAuthentication();





  Future<void> _authenticateWithBiometrics() async {

    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint  to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
    if (authenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticate'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _pinController,
                  decoration: InputDecoration(
                    hintText: 'Enter PIN',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot PIN',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      '|',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Change PIN',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 120.0,
                        height: 120.0,
                        child: ElevatedButton(

                          onPressed: _authenticateWithBiometrics,
                          // onPressed: () async {
                          //   // Call startAuth method of FingerprintHandler
                          // //  String enteredPin = _pinController.text;
                          //   //await FingerprintHandler(context).startAuth(_localAuthentication, enteredPin);
                          // },
                          child: Icon(
                            Icons.fingerprint,
                            size: 60.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Touch ID Authentication',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Use your fingerprint to authenticate.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Error Message Here',
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: Text(
              'Note: Additional note text here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }
}

class FingerprintHandler {
  final BuildContext context;

  FingerprintHandler(this.context);



  Future<void> startAuth(LocalAuthentication localAuth, String enteredPin) async {
    try {
      bool authenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to proceed',
          options: const AuthenticationOptions(biometricOnly: false,useErrorDialogs: true,stickyAuth: true,),

        //useErrorDialogs: true, // Add this parameter
      );
      if (authenticated) {
        // If fingerprint authentication successful, check PIN
        bool pinMatch = await checkPIN(enteredPin); // Implement checkPIN function
        if (pinMatch) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          update("PIN doesn't match.");
        }
      }
    } on PlatformException catch (e) {
      update("Fingerprint Authentication error\n${e.message}");
    }
  }

  Future<bool> checkPIN(String enteredPin) {
    // Implement your PIN verification logic here
    // For demonstration, let's say correct PIN is '1234'
    String correctPin = '1234';
    return Future.value(enteredPin == correctPin);
  }

  void update(String e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e),
      ),
    );
  }
}
