# 📦 Projeto de Teste Técnico - Sistema de Pedidos (Delphi + MySQL)

Este projeto foi desenvolvido como parte de um teste técnico para a vaga de desenvolvedor Delphi, com foco em organização, lógica de programação, persistência de dados e interface funcional.

---

## 🚀 Tecnologias Utilizadas

- **Delphi 12 Athens**
- **MySQL** (via FireDAC)
- **Componentes**: `TFDMemTable`, `TDBGrid`, `TDataSource`
- Leitura de `.ini` para configuração da conexão

---

## 🖼️ Funcionalidades

✅ Cadastro de pedido com múltiplos produtos  
✅ Cálculo automático do valor total  
✅ Inserção, edição e exclusão de itens no grid  
✅ Gravação do pedido e produtos no banco de dados  
✅ Interface simples, funcional e responsiva  
✅ Estrutura em camadas: Model / DAO / Form  

---

## 🧱 Estrutura do Projeto

```
/ProjetoPedidos/
├── config/
│   └── config.ini             ← configurações da conexão
├── db/
│   └── dump_teste.sql         ← estrutura e inserts do banco
├── lib/
│   └── libmysql.dll           ← biblioteca MySQL para execução
├── src/
│   ├── Forms/
│   │   └── UFrmPedido.pas     ← tela principal
│   ├── DAO/
│   │   └── UPedidoDAO.pas     ← acesso ao banco
│   ├── Model/
│   │   └── UPedidoModel.pas   ← classes de domínio
│   └── UConexaoDB.pas         ← conexão dinâmica via .ini
```

---

## ⚙️ Como Executar

1. Configure o arquivo `config.ini` (pasta `/config`) com os dados do seu banco:
```ini
[conexao]
host=localhost
porta=3306
banco=teste_pedidos
usuario=root
senha=
```

2. Importe o script `db/dump_teste.sql` no seu MySQL

3. Compile o projeto no Delphi 12 Athens

4. Execute o sistema e utilize a tela de pedidos

---

## 🧑‍💻 Desenvolvido por

Kauê Sanches Ferreira.
https://www.linkedin.com/in/kaue-sanches/
https://github.com/KaueSanchesFerreira
