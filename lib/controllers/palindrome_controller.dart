class PalindromeController {
  static bool isPalindrome(String text){
    if(text.isEmpty) return false;
    String cleanText = text.toLowerCase().replaceAll(' ', '');
    String reversedText = cleanText.split('').reversed.join('');
    return cleanText == reversedText;
  }
}