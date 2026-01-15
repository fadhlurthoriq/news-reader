# API Documentation – News Reader App

## 1. Gambaran Umum API
API yang digunakan pada aplikasi **News Reader** adalah **NewsAPI**, sebuah REST API yang menyediakan data berita dari berbagai sumber terpercaya di seluruh dunia.

### Informasi Umum
- **Base URL**
https://newsapi.org/v2
- **Tipe API**  
REST API
- **Format Data**  
JSON
- **Autentikasi**  
API Key dikirim melalui query parameter: apiKey=YOUR_API_KEY
- **Default Country**
id (Indonesia)

---

## 2. Daftar Endpoint

| Endpoint | Method | Deskripsi |
|--------|--------|----------|
| `/top-headlines` | GET | Mengambil berita utama berdasarkan negara dan kategori |
| `/everything` | GET | Mencari berita berdasarkan kata kunci |
| `/sources` | GET | Mengambil daftar sumber berita |

---

## 3. Endpoint: Top Headlines

### URL
GET /top-headlines


### Deskripsi
Endpoint ini digunakan untuk mengambil berita utama (headline) berdasarkan negara dan kategori tertentu.

### Query Parameter

| Parameter | Tipe | Wajib | Deskripsi |
|---------|------|-------|----------|
| country | String | Ya | Kode negara (contoh: id) |
| category | String | Tidak | Kategori berita (business, sports, technology, dll) |
| apiKey | String | Ya | API Key |

### Contoh Request
https://newsapi.org/v2/top-headlines?country=id&category=technology&apiKey=YOUR_API_KEY

### Contoh Response Sukses
```json
{
  "status": "ok",
  "totalResults": 38,
  "articles": [
    {
      "source": {
        "id": null,
        "name": "Kompas.com"
      },
      "author": "Kompas Cyber Media",
      "title": "Perkembangan Teknologi AI di Indonesia",
      "description": "Teknologi AI semakin berkembang pesat di Indonesia...",
      "url": "https://tekno.kompas.com/read/...",
      "urlToImage": "https://asset.kompas.com/...",
      "publishedAt": "2024-01-01T10:00:00Z",
      "content": "Teknologi kecerdasan buatan kini banyak digunakan..."
    }
  ]
}
