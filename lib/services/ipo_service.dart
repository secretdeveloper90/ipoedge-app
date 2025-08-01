import '../models/ipo_model.dart';
import '../data/mock_ipo_data.dart';

class IPOService {
  static final IPOService _instance = IPOService._internal();
  factory IPOService() => _instance;
  IPOService._internal();

  // Get all IPOs
  Future<List<IPO>> getAllIPOs() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return mockIPOData.map((json) => IPO.fromJson(json)).toList();
  }

  // Get IPOs by category
  Future<List<IPO>> getIPOsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allIPOs = await getAllIPOs();
    return allIPOs.where((ipo) => ipo.category.name == category).toList();
  }

  // Get IPO by ID
  Future<IPO?> getIPOById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final allIPOs = await getAllIPOs();
    try {
      return allIPOs.firstWhere((ipo) => ipo.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search IPOs by name
  Future<List<IPO>> searchIPOs(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) return getAllIPOs();

    final allIPOs = await getAllIPOs();
    return allIPOs
        .where((ipo) =>
            ipo.name.toLowerCase().contains(query.toLowerCase()) ||
            ipo.sector.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get IPOs by status
  Future<List<IPO>> getIPOsByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allIPOs = await getAllIPOs();
    return allIPOs
        .where((ipo) => ipo.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // Get IPOs by category and status
  Future<List<IPO>> getIPOsByCategoryAndStatus(
      String category, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allIPOs = await getAllIPOs();
    return allIPOs
        .where((ipo) =>
            ipo.category.name == category &&
            ipo.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // Get current IPOs by category
  Future<List<IPO>> getCurrentIPOsByCategory(String category) async {
    return getIPOsByCategoryAndStatus(category, 'current');
  }

  // Get upcoming IPOs by category
  Future<List<IPO>> getUpcomingIPOsByCategory(String category) async {
    return getIPOsByCategoryAndStatus(category, 'upcoming');
  }
}
