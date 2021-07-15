import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CallApi {

  // Change _url to bizzfitbackend.herokuapp.com for 'production' backend 
  // Also means you don't need to run the backend and database locally, so you can only work on the front end (here with flutter)
  // '192.168.178.207'; thuis
  // '192.168.2.8'; thuis thuis
  final String _url = '192.168.178.207:8000';
  FlutterSecureStorage storage = FlutterSecureStorage();


  postRequest(data, apiUrl) async {
    // Change to Uri.https for production, otherwise use Uri.http (local backend and database access does not require a secure connection so you do not use https)
    Uri fullUrl = Uri.http(_url, '/api' + apiUrl);
    final response = await http.post(fullUrl,
        body: jsonEncode(data), headers: await _setHeaders());
    final responseJson = jsonDecode(response.body);
    return responseJson;
  }

  getRequest(params, apiUrl) async {
    // Change to Uri.https for production, otherwise use Uri.http
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
