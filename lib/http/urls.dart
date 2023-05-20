import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
class NotificationClass{


  Future<void> createNotification(String token, String title, String body) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer AAAAVg3yjbs:APA91bHxeahXsPSBnaXi-XpI5u9IfM8pSucsK5bGGtK6IMn8NPUfR06CUTuPokoEAkm5__n-3Zi6P6CVGzFwzDcbzF81AKNMXUTzbVUXOK9Da_MRVLzUheMXm9A1EP5fkc15tBh589c_'
    };
    var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": token,
      "notification": {
        "title": title,
        "body": body
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
    }
    else {
    log('http Error ${response.reasonPhrase}');
    }
  }
}