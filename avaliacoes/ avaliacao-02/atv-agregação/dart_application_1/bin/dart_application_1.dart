// Agregação e Composição
import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    _nome = nome;
  }
  Map toJson()=>{
    'nome': _nome
  };
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    _nome = nome;
    _dependentes = dependentes;
  }
  Map toJson()=>{
    'nome': _nome,
    'dependentes': _dependentes
  };
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map toJson()=>{
    'nome': _nomeProjeto,
    'funcionarios': _funcionarios 
  };
}
void main() {
  // 1. Criar varios objetos Dependentes
  Dependente d1 = Dependente("Brenda");
  Dependente d2 = Dependente("Bruna");
  Dependente d3 = Dependente("José");
  Dependente d4 = Dependente("Anthony");

  // 2. Criar varios objetos Funcionario
  // 3. Associar os Dependentes criados aos respectivos funcionarios

  Funcionario func01 = Funcionario("João", [d1]);
  Funcionario func02 = Funcionario("Leonard", [d1, d2]);
  Funcionario func03 = Funcionario("Cristinna", [d3, d4]);
  Funcionario func04 = Funcionario("Amy", [d3]);

  // 4. Criar uma lista de Funcionarios
  List<Funcionario> funcionarios = [func01, func02, func03, func04];

  // 5. criar um objeto Equipe Projeto chamando o metodo contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario
  EquipeProjeto eqpProjeto = EquipeProjeto("Design app", funcionarios);

  // 6. Printar no formato JSON o objeto Equipe Projeto.
  String equipeProjeto1 = jsonEncode(eqpProjeto);
  print(jsonEncode(equipeProjeto1));
}