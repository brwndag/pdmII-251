import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;

void main() {
  final dbPath = p.join(Directory.current.path, 'alunos.db');
  final db = sqlite3.open(dbPath);

  // Criação tabela
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL
    );
  ''');

  while (true) {
    print('\n1. Inserir aluno');
    print('2. Listar alunos');
    print('3. Sair');
    stdout.write('Escolha uma opção: ');
    final opcao = stdin.readLineSync();

    if (opcao == '1') {
      stdout.write('Digite o nome do aluno: ');
      final nome = stdin.readLineSync();

      if (nome != null && nome.isNotEmpty) {
        final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?);');
        stmt.execute([nome]);
        stmt.dispose();
        print('Aluno inserido com sucesso!');
      } else {
        print('Nome inválido.');
      }

    } else if (opcao == '2') {
      final ResultSet result = db.select('SELECT * FROM TB_ALUNO;');
      print('\n=== Lista de Alunos ===');
      for (final row in result) {
        print('ID: ${row['id']}, Nome: ${row['nome']}');
      }

    } else if (opcao == '3') {
      print('Encerrando...');
      db.dispose();
      break;
    } else {
      print('Opção inválida.');
    }
  }
}