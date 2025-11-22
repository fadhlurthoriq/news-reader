class ApiConstants {
  // Base URL NewsAPI.org
  static const String baseUrl = "https://newsapi.org/v2";

  // MASUKKAN API KEY NEWSAPI KAMU DI SINI
  static const String apiKey = "42e8c3c6922b494780132ca5b9bb7144";

  // Default queries
  static const String defaultCountry = "id";

  // Endpoint paths
  static const String topHeadlines = "/top-headlines";
  static const String everything = "/everything";
  static const String sources = "/sources";
}


class AppConstants {
  static const String appName = 'News Reader';

  static const List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];
}