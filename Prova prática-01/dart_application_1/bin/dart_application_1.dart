import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// Classe Pedido Venda
class PedidoVenda {
  String codigo;
  DateTime data;
  double valorPedido;
  List<ItemPedido> itemPedido;

  PedidoVenda(this.codigo, this.data, this.valorPedido, this.itemPedido);

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'data': data.toIso8601String(),
    'valorPedido': valorPedido,
    'itensPedido': itemPedido.map((item) => item.toJson()).toList(),
  };
}

// Classe Cliente
class Cliente {
  int codigo;
  String nome;
  int tipoCliente;

  Cliente(this.codigo, this.nome, this.tipoCliente);

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'nome': nome,
    'tipoCliente': tipoCliente,
  };
}

// Classe Vendedor
class Vendedor {
  int codigo;
  String nome;
  double comissao;

  Vendedor(this.codigo, this.nome, this.comissao);

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'nome': nome,
    'comissao': comissao,
  };
}

// Classe Item Pedido
class ItemPedido {
  int sequencial;
  String descricao;
  int quantidade;
  double valor;

  ItemPedido(this.sequencial, this.descricao, this.quantidade, this.valor);

  Map<String, dynamic> toJson() => {
    'sequencial': sequencial,
    'descricao': descricao,
    'quantidade': quantidade,
    'valor': valor,
  };
}

// Classe Veiculo
class Veiculo {
  int codigo;
  String descricao;
  double valor;

  Veiculo(this.codigo, this.descricao, this.valor);

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'descricao': descricao,
    'valor': valor,
  };
}

Future<void> main() async {
  // Criação de dados(objetos)
  var item1 = ItemPedido(1, 'Retrovisor', 2, 60.50);
  var item2 = ItemPedido(2, 'Caixa de som', 1, 150.0);
  var item3 = ItemPedido(2, 'Garrafa Inox', 1, 99.90);
  var item4 = ItemPedido(2, 'Tapete de couro para carro', 4, 120.00);

  var cliente1 = Cliente(1, 'Brenda', 1);
  var vendedor1 = Vendedor(1, 'Milena Pereira', 160.0);
  var veiculo1 = Veiculo(1, 'Palio 2001', 12000.0);

  var pedidoVenda = PedidoVenda('PEDIDO 145', DateTime.now(), 111.0, [
    item1,
    item2,
    item3,
    item4,
  ]);

  // JSON
  String pedidoVendaJson = jsonEncode(pedidoVenda.toJson());

  // Dados do email
  String username = 'brenda.gonzaga07@aluno.ifce.edu.br';
  String password = 'avbf qwqb rqri xzvk';
  final smtpServer = gmail(username, password);

  final message =
      Message()
        ..from = Address(username, 'Brenda via Dart')
        ..recipients.add('taveira@ifce.edu.br')
        ..subject = 'Envio de email - Avaliação prática 01'
        ..text = pedidoVendaJson;

  try {
    final sendReport = await send(message, smtpServer);
    print('Email enviado com sucesso!');
    print(sendReport.toString());
  } on MailerException catch (e) {
    print('Falha ao enviar o e-mail:');
  }
}
