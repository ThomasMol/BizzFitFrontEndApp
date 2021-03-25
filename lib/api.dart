import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CallApi {
  final String _url = '192.168.178.13';
  FlutterSecureStorage storage = FlutterSecureStorage();

  postRequest(data, apiUrl) async {
    Uri fullUrl = Uri.http(_url, '/api' + apiUrl);
    final response = await http.post(fullUrl,
        body: jsonEncode(data), headers: await _setHeaders());
    final responseJson = jsonDecode(response.body);
    return responseJson;
  }

  getRequest(params, apiUrl) async {
    Uri fullUrl = Uri.http(_url, '/api' + apiUrl, params);
    final response = await http.get(fullUrl, headers: await _setHeaders());
    final responseJson = jsonDecode(response.body);
    return responseJson;
  }

  _setHeaders() async {
    String token = await _getToken();
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token
    };
  }

  _getToken() async {
    String token = await storage.read(key: 'access_token');
    return 'Bearer $token';
  }
}
