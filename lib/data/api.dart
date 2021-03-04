import 'package:http/http.dart' as http;
import 'dart:convert';

class Api{
  static const String API_URL = "https://script.google.com/macros/s/AKfycbx1d80VJMCk_Iliem6iFITDw6QW7aPWBEJPpCXnFupAVdJXJv5UUez9e6k_4XIOTqs7Jw/exec";

  _performRequest({String params}) async{
    try{
      var response = await http.get("$API_URL?$params");
      return json.decode(response.body);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // user routes
  Future loginUser(String name, String password) async{
    String params = "action=loginUser&name=$name&password=$password";
    var json = await _performRequest(params: params);
    return json;
  }

  Future getUsers(String name, String password) async{
    String params = "action=getUsers&name=$name&password=$password";
    var json = await _performRequest(params: params);
    return json;
  }

  Future removeUser(String name) async{
    String params = "action=removeUser&name=$name";
    var json = await _performRequest(params: params);
    return json;
  }

  Future addUser(String name, String role, String password) async{
    String params = "action=addUser&name=$name&role=$role&password=$password";
    var json = await _performRequest(params: params);
    return json;
  }

  // Calendar routes
  Future getDay(String date) async{
    String params = "action=getDaySlots&date=$date";
    var json = await _performRequest(params: params);
    return json;
  }

  Future fillSlot({String name, String password, String date, String label, String room, String doctor, String endTime}) async{
    String params = "action=fillSlot&name=$name&password=$password&date=$date&label=$label&room=$room&doctor=$doctor&endTime=$endTime";
    var json = await _performRequest(params: params);
    return json;
  }

  Future deleteSlot(String name, String password, String date) async{
    String params = "action=deleteSlot&name=$name&password=$password&date=$date";
    var json = await _performRequest(params: params);
    return json;
  }

  Future getWeek(String date) async{
    String params = "action=getWeek&date=$date";
    var json = await _performRequest(params: params);
    return json;
  }
}

