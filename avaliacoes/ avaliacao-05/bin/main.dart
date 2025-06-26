import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';

//fiz no replit para não fazer as instalações do dart :D

void main() async {
  String username = 'brenda.gonzaga07@aluno.ifce.edu.br';
  String password =
      'mpae uqqe mlbq wjtm'; // Senha gerada para nao utilizar a original

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Brenda via Dart')
    ..recipients
        .add('brendamonicag@gmail.com') 
    ..subject = 'Teste envio email'
    ..text = 'Veja o gatinho!!!!'
    ..attachments.add(FileAttachment(File('gato.jpg')));

  try {
    final sendReport = await send(message, smtpServer);
    print(' Email enviado com sucesso!');
    print(sendReport.toString());
  } on MailerException catch (e) {
    print(' Falha ao enviar o e-mail: $e');
  }
}
