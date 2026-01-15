/// Data source untuk mengambil data berita dari REST API.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_reader/core/constants/api_constants.dart';
import 'package:news_reader/core/exceptions/news_exceptions.dart';
import 'package:news_reader/data/models/news_model.dart';

/// Class ini bertanggung jawab untuk:
/// - Mengirim request HTTP ke News API
/// - Mengambil data berita berdasarkan kategori atau pencarian
/// - Mengubah response JSON menjadi objek NewsModel
class NewsRemoteDataSource {

  /// HTTP client yang digunakan untuk melakukan request API

  final http.Client client;

  /// Constructor untuk NewsRemoteDataSource
  /// [client] digunakan untuk melakukan request HTTP

  NewsRemoteDataSource({required this.client});

  /// Mengambil daftar berita berdasarkan kategori tertentu.
  /// [category] adalah kategori berita yang ingin diambil
  /// (contoh: business, sports, technology).
  /// Return berupa `Future<List<NewsModel>>` yang berisi daftar berita.
  /// Akan melempar [NewsException] jika request gagal atau terjadi error jaringan.

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

  /// Melakukan pencarian berita berdasarkan kata kunci.
  /// [query] adalah kata kunci pencarian berita.
  /// Return berupa `Future<List<NewsModel>>` hasil pencarian berita.
  /// Akan melempar [NewsException] jika proses pencarian gagal.

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
