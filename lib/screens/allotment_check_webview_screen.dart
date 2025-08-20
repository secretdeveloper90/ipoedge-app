import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class AllotmentCheckWebViewScreen extends StatefulWidget {
  final String url;
  final String companyName;

  const AllotmentCheckWebViewScreen({
    super.key,
    required this.url,
    required this.companyName,
  });

  @override
  State<AllotmentCheckWebViewScreen> createState() =>
      _AllotmentCheckWebViewScreenState();
}

class _AllotmentCheckWebViewScreenState
    extends State<AllotmentCheckWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  Timer? _loadingTimeout;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    // Start with a shorter initial loading timeout
    _startInitialLoadingTimeout();
  }

  void _startInitialLoadingTimeout() {
    // Hide loader after 3 seconds if page hasn't started loading
    Timer(const Duration(seconds: 3), () {
      if (_isLoading && mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('WebView loading progress: $progress%');
            // Hide loader when we reach 80% progress for faster perceived loading
            if (progress >= 80 && _isLoading) {
              _cancelLoadingTimeout();
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            print('WebView page started loading: $url');
            _cancelLoadingTimeout();
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
            // Reduced timeout to 10 seconds for faster response
            _startLoadingTimeout();
          },
          onPageFinished: (String url) {
            print('WebView page finished loading: $url');
            _cancelLoadingTimeout();
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            _cancelLoadingTimeout();
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = error.description;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _startLoadingTimeout() {
    _loadingTimeout = Timer(const Duration(seconds: 10), () {
      print('WebView loading timeout reached');
      if (_isLoading && mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _cancelLoadingTimeout() {
    _loadingTimeout?.cancel();
    _loadingTimeout = null;
  }

  @override
  void dispose() {
    _cancelLoadingTimeout();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Allotment Check',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.companyName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
        actions: [
          // Refresh button
          IconButton(
            onPressed: _refreshPage,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
          // Open in browser button
          IconButton(
            onPressed: _openInBrowser,
            icon: const Icon(Icons.open_in_browser_rounded),
            tooltip: 'Open in Browser',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_hasError)
            _buildErrorView()
          else
            WebViewWidget(controller: _controller),
          if (_isLoading) _buildLoadingView(),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading allotment page...',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load page',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage.isNotEmpty
                  ? _errorMessage
                  : 'Unable to load the allotment check page. Please check your internet connection and try again.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _refreshPage,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _openInBrowser,
                  icon: const Icon(Icons.open_in_browser_rounded, size: 18),
                  label: const Text('Open in Browser'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _refreshPage() {
    _cancelLoadingTimeout();
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    _startLoadingTimeout();
    _controller.reload();
  }

  Future<void> _openInBrowser() async {
    try {
      final uri = Uri.parse(widget.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open URL in browser'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening URL: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
