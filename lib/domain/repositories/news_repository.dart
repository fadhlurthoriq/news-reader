/// Kontrak (interface) repository untuk fitur berita.

import 'package:news_reader/data/datasources/news_remote_data_source.dart';
import 'package:news_reader/data/models/news_model.dart';
import 'package:news_reader/core/exceptions/news_exceptions.dart';

/// Repository berfungsi sebagai penghubung antara
/// data source dan layer presentation.

abstract class NewsRepository {
   /// Mengambil berita utama (top headlines)
  Future<List<NewsModel>> getTopHeadlines();

  /// Mengambil berita berdasarkan kategori tertentu
  Future<List<NewsModel>> getNewsByCategory(String category);

  /// Melakukan pencarian berita berdasarkan kata kunci
  Future<List<NewsModel>> searchNews(String query);

  /// Mengambil daftar berita yang disimpan sebagai bookmark
  Future<List<NewsModel>> getBookmarkedNews();

  /// Menyimpan berita ke dalam bookmark
  Future<void> bookmarkNews(NewsModel news);

  /// Menghapus berita dari bookmark
  Future<void> removeBookmark(NewsModel news);

  /// Mengecek apakah sebuah berita sudah dibookmark
  bool isBookmarked(NewsModel news);
}

/// Implementasi dari [NewsRepository].
/// Class ini mengatur:
/// - Pengambilan data berita dari API
/// - Penyimpanan bookmark secara lokal (sementara)
class NewsRepositoryImpl implements NewsRepository {

  /// Remote data source untuk mengambil data dari API
  final NewsRemoteDataSource remoteDataSource;

  /// List untuk menyimpan berita yang dibookmark
  final List<NewsModel> _bookmarks = [];

  /// Constructor untuk NewsRepositoryImpl
  NewsRepositoryImpl({required this.remoteDataSource});

  /// Mengambil berita utama dengan kategori default.
  /// Return berupa daftar berita utama.
  @override
  Future<List<NewsModel>> getTopHeadlines() async {
    try {
      return await remoteDataSource.getNewsByCategory('all');
    } catch (e) {
      throw NewsException('Failed to get top headlines: $e');
    }
  }

  /// Mengambil berita berdasarkan kategori tertentu.
  /// [category] adalah kategori berita.
  @override
  Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      return await remoteDataSource.getNewsByCategory(category);
    } catch (e) {
      throw NewsException('Failed to get news by category: $e');
    }
  }

  /// Melakukan pencarian berita.
  /// Jika [query] kosong, maka akan mengambil berita utama.
  @override
  Future<List<NewsModel>> searchNews(String query) async {
    try {
      if (query.isEmpty) return await getTopHeadlines();
      return await remoteDataSource.searchNews(query);
    } catch (e) {
      throw NewsException('Failed to search news: $e');
    }
  }

  /// Mengambil daftar berita yang disimpan sebagai bookmark.
  @override
  Future<List<NewsModel>> getBookmarkedNews() async {
    // Dalam implementasi real, ini akan membaca dari shared_preferences
    return _bookmarks;
  }

  /// Menyimpan berita ke bookmark jika belum ada.
  @override
  Future<void> bookmarkNews(NewsModel news) async {
    if (!_bookmarks.any((item) => item.url == news.url)) {
      _bookmarks.add(news);
    }
  }

  /// Menghapus berita dari bookmark.
  @override
  Future<void> removeBookmark(NewsModel news) async {
    _bookmarks.removeWhere((item) => item.url == news.url);
  }

  /// Mengecek apakah berita sudah ada di bookmark.
  @override
  bool isBookmarked(NewsModel news) {
    return _bookmarks.any((item) => item.url == news.url);
  }
}
