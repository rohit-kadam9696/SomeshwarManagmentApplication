import 'dart:math';

class RandomString {
  static const String CHAR_LIST =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
  static const int RANDOM_STRING_LENGTH = 15;
  static const int RANDOM_NUMBER_LENGTH = 5;

  /// This method generates a random string
  static String generateRandomString() {
    StringBuffer randStr = StringBuffer();
    for (int i = 0; i < RANDOM_STRING_LENGTH; i++) {
      int number = getRandomNumber();
      randStr.write(CHAR_LIST[number]);
    }
    return randStr.toString();
  }

  /// This method generates a random string of specified length
  static String generateRandomStringWithLength(int len) {
    StringBuffer randStr = StringBuffer();
    for (int i = 0; i < len; i++) {
      int number = getRandomNumber();
      randStr.write(CHAR_LIST[number]);
    }
    return randStr.toString();
  }

  /// This method generates a random number
  static String generateRandomNumber() {
    StringBuffer randStr = StringBuffer();
    for (int i = 0; i < RANDOM_NUMBER_LENGTH; i++) {
      int number = getRandomNumberN();
      randStr.write(number);
    }
    return randStr.toString();
  }

  /// This method generates a random number between 0 and 61 (CHAR_LIST.length())
  static int getRandomNumber() {
    Random randomGenerator = Random();
    int randomInt = randomGenerator.nextInt(CHAR_LIST.length);
    return randomInt;
  }

  /// This method generates a random number between 0 and 9
  static int getRandomNumberN() {
    Random randomGenerator = Random();
    int randomInt = randomGenerator.nextInt(10);
    return randomInt;
  }

}
