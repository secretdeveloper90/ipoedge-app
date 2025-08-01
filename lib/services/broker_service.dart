import '../models/broker.dart';
import '../data/mock_broker_data.dart';

class BrokerService {
  static final BrokerService _instance = BrokerService._internal();
  factory BrokerService() => _instance;
  BrokerService._internal();

  List<Broker> _brokers = [];

  Future<List<Broker>> getBrokers({String category = 'all'}) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (_brokers.isEmpty) {
        _loadBrokersFromMockData();
      }

      if (category == 'all') {
        return _brokers;
      }

      return _brokers
          .where((broker) =>
              broker.type.toLowerCase().contains(category.toLowerCase()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Broker?> getBrokerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_brokers.isEmpty) {
      _loadBrokersFromMockData();
    }

    try {
      return _brokers.firstWhere((broker) => broker.id == id);
    } catch (e) {
      return null;
    }
  }

  void _loadBrokersFromMockData() {
    try {
      _brokers = [];

      for (int i = 0; i < mockBrokerData.length; i++) {
        try {
          final broker = Broker.fromJson(mockBrokerData[i]);
          _brokers.add(broker);
        } catch (e) {
          // Continue loading other brokers instead of failing completely
          // This allows the app to work even if some broker data has issues
        }
      }
    } catch (e) {
      _brokers = [];
      rethrow;
    }
  }
}
