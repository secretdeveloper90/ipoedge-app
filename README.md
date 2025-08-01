# IPO Edge

A comprehensive Flutter application for tracking and analyzing Initial Public Offerings (IPOs) in the Indian stock market.

## Features

### 📊 IPO Tracking
- **Real-time IPO Data**: Track current, upcoming, and closed IPOs
- **Comprehensive Information**: Company details, Offer Prices, issue sizes, and dates
- **Category Filtering**: Separate views for Mainboard and SME IPOs
- **Status Indicators**: Visual status indicators for different IPO phases

### 💰 Financial Analysis
- **GMP Tracking**: Grey Market Premium data with percentage calculations
- **Subscription Data**: Real-time subscription rates for retail, HNI, and QIB categories
- **Financial Charts**: Visual representation of company financial performance
- **Valuation Metrics**: P/E ratios, ROE, ROCE, and other key financial indicators

### 🔍 Search & Filter
- **Smart Search**: Search by company name or sector
- **Advanced Filters**: Filter by status (upcoming, current, closed) and category
- **Real-time Results**: Instant search results with dynamic filtering

### 📱 User Experience
- **Modern UI**: Clean, professional design optimized for financial data
- **Responsive Design**: Works seamlessly across different screen sizes
- **Loading States**: Smooth shimmer loading effects
- **Animations**: Subtle animations for better user experience

## Screenshots

The app features:
- **Home Screen**: Overview of all IPOs with bottom navigation
- **IPO List**: Categorized listing of IPOs with key metrics
- **IPO Details**: Comprehensive company information and analysis
- **Search**: Advanced search and filtering capabilities
- **Profile**: User preferences and app information

## Technical Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── ipo.dart             # IPO data structures
│   └── ipo_model.dart       # Main IPO model
├── services/                 # Business logic
│   └── ipo_service.dart     # IPO data service
├── screens/                  # UI screens
│   ├── home_screen.dart     # Main navigation
│   ├── ipo_list_screen.dart # IPO listing
│   ├── ipo_detail_screen.dart # IPO details
│   ├── search_screen.dart   # Search functionality
│   └── profile_screen.dart  # User profile
├── widgets/                  # Reusable components
│   ├── ipo_card.dart        # IPO display card
│   ├── financial_chart.dart # Financial visualization
│   ├── info_section.dart    # Information sections
│   └── loading_shimmer.dart # Loading animations
└── theme/                    # App theming
    └── app_theme.dart       # Colors and styles
```

### Key Technologies
- **Flutter**: Cross-platform mobile development framework
- **Material Design 3**: Modern UI components and design system
- **Provider Pattern**: State management (ready for implementation)
- **Cached Network Images**: Efficient image loading and caching
- **HTTP**: API communication (ready for real data integration)

## Getting Started

### Prerequisites
- Flutter SDK (3.4.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ipo_edge
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **For web development**
   ```bash
   flutter run -d chrome
   ```

2. **For mobile development**
   ```bash
   flutter run -d <device-id>
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

## Data Structure

The app uses a comprehensive data model that includes:

- **Company Information**: Name, logo, sector, description
- **IPO Details**: Offer Price, issue size, lot size, dates
- **Financial Data**: Revenue, profit, assets, borrowings (3-year history)
- **Market Metrics**: GMP, subscription rates, valuations
- **Analysis**: Strengths, weaknesses, issue objectives
- **Regulatory Info**: Registrar, lead managers, exchanges

## Future Enhancements

### Planned Features
- [ ] Real-time API integration
- [ ] Push notifications for IPO updates
- [ ] Watchlist functionality
- [ ] Portfolio tracking
- [ ] Advanced charting with technical indicators
- [ ] News integration
- [ ] Social features and discussions
- [ ] Dark mode support
- [ ] Offline data caching

### Technical Improvements
- [ ] State management with Provider/Riverpod
- [ ] Unit and integration test coverage
- [ ] CI/CD pipeline setup
- [ ] Performance optimization
- [ ] Accessibility improvements
- [ ] Internationalization support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the excellent framework
- Material Design team for the design system
- IPO data providers for market information
- Open source community for various packages used

---

**Note**: This app currently uses mock data for demonstration purposes. For production use, integrate with real IPO data APIs and implement proper authentication and data management systems.
