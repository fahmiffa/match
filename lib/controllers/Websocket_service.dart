import 'dart:async';
import 'dart:convert';
import '../model/ApiService.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService extends GetxController {
  static const String _socketUrl = ApiService.socketUrl;
  IOWebSocketChannel? _channel;
  late StreamSubscription _streamSubscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  RxBool Connected = false.obs;
  bool _isConnecting = false;
  bool _shouldReconnect = true;
  final int _pingIntervalSeconds = 25;
  final int _reconnectIntervalSeconds = 5;
  RxString logger = ''.obs;

  @override
  void onInit() {
    super.onInit();
    connect();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }

  void connect() {
    if (_isConnected || _isConnecting) return;

    _isConnecting = true;
    _channel = IOWebSocketChannel.connect(_socketUrl);
    _streamSubscription = _channel!.stream.listen(
      _onMessageReceived,
      onDone: _onDone,
      onError: _onError,
    );
    _isConnected = true;
    Connected.value = true;
    logger.value = 'Connected';
    _isConnecting = false;
    _startPing();
  }

  void _onMessageReceived(dynamic message) {
    print('connected');
    logger.value = 'connected';
  }

  void _onDone() {
    print('WebSocket disconnected');
    logger.value = 'Disconnected';
    _isConnected = false;
    Connected.value = false;
    _pingTimer?.cancel();
    if (_shouldReconnect) {
      _startReconnect();
    }
  }

  void _onError(error) {
    print('WebSocket error: $error');
    logger.value = error;
    _isConnected = false;
    Connected.value = false;
    _pingTimer?.cancel();
    if (_shouldReconnect) {
      _startReconnect();
    }
  }

  void _startPing() {
    _pingTimer =
        Timer.periodic(Duration(seconds: _pingIntervalSeconds), (timer) {
      if (_isConnected) {
        print('ping connecting');
        logger.value = 'connecting';
        Map<String, dynamic> jsonMap = {
          "type": 11,
          "data": 'ping',
        };
        String jsonString = jsonEncode(jsonMap);
        _channel?.sink.add(jsonString);
      }
    });
  }

  void _startReconnect() {
    if (!_shouldReconnect) return;

    _reconnectTimer?.cancel();
    _reconnectTimer =
        Timer.periodic(Duration(seconds: _reconnectIntervalSeconds), (timer) {
      if (!_isConnected) {
        print('Attempting to reconnect...');
        logger.value = 'Reconnect';
        connect();
      }
    });
  }

  void disconnect() {
    _shouldReconnect = false;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _streamSubscription.cancel();
    _isConnected = false;
    Connected.value = false;
    print('WebSocket disconnected');
    logger.value = 'Disconnected';
  }

  void toggleReconnect(bool reconnect) {
    _shouldReconnect = reconnect;
    if (reconnect && !_isConnected && !_isConnecting) {
      connect();
    }
  }

  bool isConnected() {
    Connected.value = true;
    logger.value = 'Connected';
    return _isConnected;
  }

  bool isConnecting() {
    logger.value = 'Connecting';
    return _isConnecting;
  }
}
