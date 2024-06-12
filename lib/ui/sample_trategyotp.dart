import 'package:otp_autofill/otp_autofill.dart';

class SampleStrategy extends OTPStrategy {
  @override
  String parseOTP(String message) {
    // Implement your logic to parse the OTP from the message
    // This is just a sample, you need to customize it based on your requirements
    final RegExp exp = RegExp(r'(\d{5})');
    return exp.stringMatch(message) ?? '';
  }

  @override
  Future<String> listenForCode() {
    // TODO: implement listenForCode
    throw UnimplementedError();
  }
}
