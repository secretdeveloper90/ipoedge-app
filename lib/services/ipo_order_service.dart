import '../models/ipo_order.dart';

class IpoOrderService {
  static final IpoOrderService _instance = IpoOrderService._internal();
  factory IpoOrderService() => _instance;
  IpoOrderService._internal();

  static IpoOrderService get instance => _instance;

  final List<IpoOrder> _orders = [];
  bool _demoDataAdded = false;

  Future<void> addDemoData() async {
    if (_demoDataAdded) return;

    final demoOrders = [
      IpoOrder(
        id: '1',
        ipoName: 'Tata Technologies IPO',
        companyName: 'Tata Technologies Limited',
        status: OrderStatus.allotted,
        orderType: OrderType.retail,
        appliedQuantity: 100,
        allottedQuantity: 50,
        pricePerShare: 500.0,
        totalAmount: 50000.0,
        refundAmount: 25000.0,
        applicationDate: DateTime(2024, 1, 15),
        allotmentDate: DateTime(2024, 1, 25),
        allotmentNumber: 'TT2024001',
        dematAccountId: '1',
        applicantName: 'John Doe',
      ),
      IpoOrder(
        id: '2',
        ipoName: 'IREDA IPO',
        companyName: 'Indian Renewable Energy Development Agency',
        status: OrderStatus.notAllotted,
        orderType: OrderType.retail,
        appliedQuantity: 200,
        allottedQuantity: 0,
        pricePerShare: 32.0,
        totalAmount: 6400.0,
        refundAmount: 6400.0,
        applicationDate: DateTime(2023, 11, 20),
        allotmentDate: DateTime(2023, 11, 30),
        allotmentNumber: null,
        dematAccountId: '1',
        applicantName: 'John Doe',
      ),
      IpoOrder(
        id: '3',
        ipoName: 'Nexus Select Trust IPO',
        companyName: 'Nexus Select Trust',
        status: OrderStatus.applied,
        orderType: OrderType.retail,
        appliedQuantity: 150,
        allottedQuantity: null,
        pricePerShare: 100.0,
        totalAmount: 15000.0,
        refundAmount: null,
        applicationDate: DateTime(2024, 2, 10),
        allotmentDate: null,
        allotmentNumber: null,
        dematAccountId: '2',
        applicantName: 'Jane Smith',
      ),
      IpoOrder(
        id: '4',
        ipoName: 'Bharti Hexacom IPO',
        companyName: 'Bharti Hexacom Limited',
        status: OrderStatus.allotted,
        orderType: OrderType.hni,
        appliedQuantity: 500,
        allottedQuantity: 300,
        pricePerShare: 570.0,
        totalAmount: 285000.0,
        refundAmount: 114000.0,
        applicationDate: DateTime(2024, 3, 5),
        allotmentDate: DateTime(2024, 3, 15),
        allotmentNumber: 'BH2024002',
        dematAccountId: '1',
        applicantName: 'John Doe',
      ),
      IpoOrder(
        id: '5',
        ipoName: 'Go Digit General Insurance IPO',
        companyName: 'Go Digit General Insurance Company',
        status: OrderStatus.applied,
        orderType: OrderType.retail,
        appliedQuantity: 75,
        allottedQuantity: null,
        pricePerShare: 380.0,
        totalAmount: 28500.0,
        refundAmount: null,
        applicationDate: DateTime(2024, 3, 20),
        allotmentDate: null,
        allotmentNumber: null,
        dematAccountId: '2',
        applicantName: 'Jane Smith',
      ),
      IpoOrder(
        id: '6',
        ipoName: 'Ola Electric IPO',
        companyName: 'Ola Electric Mobility Limited',
        status: OrderStatus.refunded,
        orderType: OrderType.retail,
        appliedQuantity: 100,
        allottedQuantity: 0,
        pricePerShare: 76.0,
        totalAmount: 7600.0,
        refundAmount: 7600.0,
        applicationDate: DateTime(2024, 8, 2),
        allotmentDate: DateTime(2024, 8, 12),
        allotmentNumber: null,
        dematAccountId: '1',
        applicantName: 'John Doe',
      ),
    ];

    _orders.addAll(demoOrders);
    _demoDataAdded = true;
  }

  Future<List<IpoOrder>> getAllOrders() async {
    return List.from(_orders);
  }

  Future<List<IpoOrder>> getCurrentOrders() async {
    return _orders.where((order) => order.isCurrent).toList();
  }

  Future<List<IpoOrder>> getPastOrders() async {
    return _orders.where((order) => order.isPast).toList();
  }

  Future<List<IpoOrder>> getRecentOrders({int limit = 2}) async {
    final sortedOrders = List<IpoOrder>.from(_orders);
    sortedOrders.sort((a, b) => b.applicationDate.compareTo(a.applicationDate));
    return sortedOrders.take(limit).toList();
  }

  Future<IpoOrder?> getOrderById(String id) async {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addOrder(IpoOrder order) async {
    try {
      _orders.add(order);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOrder(IpoOrder updatedOrder) async {
    try {
      final index = _orders.indexWhere((order) => order.id == updatedOrder.id);
      if (index != -1) {
        _orders[index] = updatedOrder;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteOrder(String id) async {
    try {
      _orders.removeWhere((order) => order.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, int>> getOrderStats() async {
    return {
      'total': _orders.length,
      'current': _orders.where((order) => order.isCurrent).length,
      'allotted': _orders.where((order) => order.status == OrderStatus.allotted).length,
      'notAllotted': _orders.where((order) => order.status == OrderStatus.notAllotted).length,
    };
  }
}
