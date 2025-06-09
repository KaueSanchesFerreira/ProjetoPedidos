-- Dump SQL - Estrutura atualizada com campo autoincremento em pedidos_produtos

-- Banco de dados
DROP DATABASE IF EXISTS teste_pedidos;
CREATE DATABASE teste_pedidos CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE teste_pedidos;

-- Tabela de clientes
CREATE TABLE clientes (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2)
);

-- Tabela de produtos
CREATE TABLE produtos (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL
);

-- Tabela de pedidos
CREATE TABLE pedidos (
    numero_pedido INT PRIMARY KEY,
    data_emissao DATE NOT NULL,
    codigo_cliente INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (codigo_cliente) REFERENCES clientes(codigo)
);

-- Tabela de itens do pedido com campo autoincremento
CREATE TABLE pedidos_produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_pedido INT,
    codigo_produto INT,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (numero_pedido) REFERENCES pedidos(numero_pedido),
    FOREIGN KEY (codigo_produto) REFERENCES produtos(codigo)
);

-- Inserção de clientes (20 registros)
INSERT INTO clientes (codigo, nome, cidade, uf) VALUES
(1, 'João da Silva', 'São Paulo', 'SP'),
(2, 'Maria Oliveira', 'Rio de Janeiro', 'RJ'),
(3, 'Carlos Souza', 'Belo Horizonte', 'MG'),
(4, 'Ana Paula Mendes', 'Curitiba', 'PR'),
(5, 'Rafael Costa', 'Fortaleza', 'CE'),
(6, 'Fernanda Lima', 'Salvador', 'BA'),
(7, 'Bruno Rocha', 'Brasília', 'DF'),
(8, 'Luciana Martins', 'Manaus', 'AM'),
(9, 'Eduardo Alves', 'Recife', 'PE'),
(10, 'Patrícia Gomes', 'Porto Alegre', 'RS'),
(11, 'Daniel Pereira', 'Goiânia', 'GO'),
(12, 'Juliana Ramos', 'Natal', 'RN'),
(13, 'Rodrigo Teixeira', 'João Pessoa', 'PB'),
(14, 'Camila Dias', 'Campo Grande', 'MS'),
(15, 'André Fernandes', 'Cuiabá', 'MT'),
(16, 'Isabela Souza', 'São Luís', 'MA'),
(17, 'Thiago Lima', 'Maceió', 'AL'),
(18, 'Sabrina Moraes', 'Teresina', 'PI'),
(19, 'Leandro Vieira', 'Aracaju', 'SE'),
(20, 'Renata Barbosa', 'Florianópolis', 'SC');

-- Inserção de produtos (20 registros)
INSERT INTO produtos (descricao, preco_venda) VALUES
('Caneta Azul', 2.50),
('Caderno 96 folhas', 12.90),
('Lápis Preto', 1.00),
('Borracha', 0.80),
('Apontador', 1.20),
('Régua 30cm', 3.50),
('Tesoura Escolar', 5.75),
('Cola Branca 250ml', 4.60),
('Corretivo Líquido', 3.90),
('Marcador Permanente', 6.80),
('Bloco de Notas', 2.10),
('Canetinha Hidrocor', 11.90),
('Compasso Escolar', 7.20),
('Transferidor 180°', 2.95),
('Esquadro 45°', 3.15),
('Esquadro 60°', 3.15),
('Caderno de Desenho', 14.50),
('Pincel Atômico', 4.90),
('Papel Sulfite A4 (pacote)', 16.00),
('Clips Coloridos (100 un)', 2.70);
