/// Provider untuk mengelola state berita.

import 'package:flutter/material.dart';
import 'package:news_reader/data/models/news_model.dart';
import 'package:news_reader/domain/repositories/news_repository.dart';
import 'package:news_reader/core/exceptions/news_exceptions.dart';

/// Class ini berfungsi untuk:
/// - Mengambil data dari repository
/// - Menyimpan state loading, error, dan data
/// - Menyediakan data ke UI menggunakan Provider
class NewsProvider with ChangeNotifier {

  /// Repository yang digunakan untuk mengakses data berita
  final NewsRepository newsRepository;

   /// Constructor NewsProvider
  NewsProvider({required this.newsRepository});

  /// Daftar berita yang ditampilkan
  List<NewsModel> _news = [];

  /// Daftar berita yang dibookmark
  List<NewsModel> _bookmarks = [];

  /// Kategori berita yang sedang dipilih
  String _selectedCategory = 'all';

  /// Kata kunci pencarian
  String _searchQuery = '';

  /// Menandakan apakah data sedang dimuat
  bool _isLoading = false;

  /// Pesan error jika terjadi kegagalan
  String _errorMessage = '';

  /// Menandakan apakah sedang dalam mode pencarian
  bool _isSearching = false;

  /// Getters untuk semua keperluan di applikasi, sama seperti di atas
  List<NewsModel> get news => _news;
  List<NewsModel> get bookmarks => _bookmarks;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get isSearching => _isSearching;

  /// Mengambil berita utama dari repository.
  ///
  /// Method ini akan memperbarui state loading dan error.
  Future<void> loadTopHeadlines() async {
    _isLoading = true;
    _errorMessage = '';
    _isSearching = false;
    notifyListeners();

    try {
      _news = await newsRepository.getTopHeadlines();
    } on NewsException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mengambil berita berdasarkan kategori tertentu.
  ///
  /// [category] adalah kategori berita yang dipilih.
  Future<void> loadNewsByCategory(String category) async {
    _isLoading = true;
    _errorMessage = '';
    _selectedCategory = category;
    _isSearching = false;
    notifyListeners();

    try {
      _news = await newsRepository.getNewsByCategory(category);
    } on NewsException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Melakukan pencarian berita berdasarkan kata kunci.
  ///
  /// [query] adalah kata kunci pencarian.
  Future<void> searchNews(String query) async {
    _isLoading = true;
    _errorMessage = '';
    _searchQuery = query;
    _isSearching = query.isNotEmpty;
    notifyListeners();

    try {
      _news = await newsRepository.searchNews(query);
    } on NewsException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mengambil daftar bookmark dari repository.
  Future<void> loadBookmarks() async {
    _bookmarks = await newsRepository.getBookmarkedNews();
    notifyListeners();
  }

  /// Menambah atau menghapus bookmark sebuah berita.
  ///
  /// Jika berita sudah dibookmark, maka akan dihapus.
  /// Jika belum, maka akan ditambahkan.
  Future<void> toggleBookmark(NewsModel news) async {
    if (newsRepository.isBookmarked(news)) {
      await newsRepository.removeBookmark(news);
    } else {
      await newsRepository.bookmarkNews(news);
    }
    await loadBookmarks();
    notifyListeners();
  }
  /// Mengecek apakah sebuah berita sudah dibookmark.
  bool isBookmarked(NewsModel news) {
    return newsRepository.isBookmarked(news);
  }

  /// Menghapus pesan error.
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  /// Mereset pencarian dan menampilkan berita utama kembali.
  void resetSearch() {
    _searchQuery = '';
    _isSearching = false;
    loadTopHeadlines();
  }
}
