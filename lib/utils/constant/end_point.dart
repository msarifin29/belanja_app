class EndPoint {
  // Change with your api key
  static const String apiKey = "AIzaSyDAz48d9JimT7lqTLBTvtw4xNhfEJIEm4I";
  static const String googleApis = "https://identitytoolkit.googleapis.com";
  static const String signUp = "$googleApis/v1/accounts:signUp?key=$apiKey";
  static const String logIn =
      "$googleApis/v1/accounts:signInWithPassword?key=$apiKey";

  // Change with your url
  static const String firebaseDatabase =
      "https://cassiere-7a631-default-rtdb.asia-southeast1.firebasedatabase.app";
}
