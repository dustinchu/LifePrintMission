import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<String> requestMethod(String data) async {
    var url = "http://218.161.26.98:5000/getGcode";
    var body = json.encode({"title": "$data"});

    Map<String,String> headers = {
      'Content-type' : 'application/json', 
      'Accept': 'application/json',
    };

    final response =
        await http.post(url, body: body, headers: headers);
    final responseJson = json.decode(response.body);
    // print(responseJson['gcode']);
    
    return responseJson['gcode'];
}