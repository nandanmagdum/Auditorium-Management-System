import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EMailNotifications {
  static void sendEmail_TO_ALL(String emailBody, List<String> audience) async {
    String username = 'codinghero1234@gmail.com'; // Your email
    String password = 'rqdfitlbhzeyfbxb';
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.addAll(audience)
      ..subject = 'New Event at GCEK Auditorium'
      ..text = emailBody; // Body of the email
    try {
      final sendReport = await send(message, smtpServer);
      // print('Message sent: ' + sendReport.toString());
    } catch (e) {
      // print('Error occurred: $e');
    }
  }

  static void sendEmail(String emailBody, String requester) async {
    String username = 'codinghero1234@gmail.com'; // Your email
    String password = 'rqdfitlbhzeyfbxb';
    final smtpServer = gmail(username, password);
    // TODO : admins only
    final message = Message()
      ..from = Address(username)
      ..recipients.add(requester)
      ..subject = 'GCEK Auditorium App Rejected your slot request !'
      ..text = emailBody; // Body of the email
    try {
      final sendReport = await send(message, smtpServer);
      // print('Message sent: ' + sendReport.toString());
    } catch (e) {
      // print('Error occurred: $e');
    }
  }
}
