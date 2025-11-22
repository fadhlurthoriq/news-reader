import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_reader/core/constants/api_constants.dart';
import 'package:news_reader/core/exceptions/news_exceptions.dart';
import 'package:news_reader/data/models/news_model.dart';

class NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSource({required this.client});

  /// GET Top Headlines by Category
  Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.topHeadlines}"
        "?country=${ApiConstants.defaultCountry}"
        "&category=$category"
        "&apiKey=${ApiConstants.apiKey}",
      );

      final response =
          await client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<dynamic> articles = data['articles'] ?? [];

        return articles
            .map((article) => NewsModel.fromJson(article))
            .toList();
      } else {
        throw NewsException(
          'Failed to fetch news: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw NewsException("Network error: $e");
    }
  }

  /// SEARCH NEWS (Everything endpoint)
  Future<List<NewsModel>> searchNews(String query) async {
    try {
      final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.everything}"
        "?q=$query"
        "&apiKey=${ApiConstants.apiKey}",
      );

      final response =
          await client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<dynamic> articles = data['articles'] ?? [];

        return articles
            .map((article) => NewsModel.fromJson(article))
            .toList();
      } else {
        throw NewsException(
          'Failed to search news: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw NewsException("Search error: $e");
    }
  }
}
