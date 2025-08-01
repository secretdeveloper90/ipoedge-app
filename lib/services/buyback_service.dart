import '../models/buyback_model.dart';
import '../data/mock_buyback_data.dart';

class BuybackService {
  static List<Buyback> getAllBuybacks() {
    return mockBuybackData.map((data) => Buyback.fromJson(data)).toList();
  }

  static List<Buyback> getUpcomingBuybacks() {
    return getAllBuybacks().where((buyback) => buyback.isUpcoming).toList();
  }

  static List<Buyback> getOpenBuybacks() {
    return getAllBuybacks().where((buyback) => buyback.isOpen).toList();
  }

  static List<Buyback> getClosedBuybacks() {
    return getAllBuybacks().where((buyback) => buyback.isClosed).toList();
  }

  static Buyback? getBuybackById(String id) {
    try {
      return getAllBuybacks().firstWhere((buyback) => buyback.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Buyback> searchBuybacks(String query) {
    if (query.isEmpty) return getAllBuybacks();
    
    return getAllBuybacks().where((buyback) {
      return buyback.companyName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  static List<Buyback> getBuybacksByStatus(String status) {
    return getAllBuybacks().where((buyback) => 
        buyback.status.toLowerCase() == status.toLowerCase()).toList();
  }

  static List<Buyback> getBuybacksByMethod(String method) {
    return getAllBuybacks().where((buyback) => 
        buyback.method.toLowerCase() == method.toLowerCase()).toList();
  }

  static Map<String, int> getBuybackStats() {
    final allBuybacks = getAllBuybacks();
    return {
      'total': allBuybacks.length,
      'upcoming': getUpcomingBuybacks().length,
      'open': getOpenBuybacks().length,
      'closed': getClosedBuybacks().length,
    };
  }
}
