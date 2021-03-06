import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;
  //exponemos el estado del server
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    //dart client
    this._socket = IO.io('http://192.168.0.103:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
      // 'extraHeaders': {'foo': 'bar'}
    });
    this._socket.on('connect', (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    // this._socket.on('nuevo-mensaje', (payload) {
    //   // print('nuevo-mensaje:$payload');
    //   print('nombre: ${payload['nombre']}');
    //   print('mensaje: ${payload['mensaje']}');
    //   print('mensaje: ${payload['mensaje2']}');
    //   print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    // });
  }
}
