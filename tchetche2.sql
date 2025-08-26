
CREATE DATABASE db_revenda_samuel;

\c db_revenda_seunome;

CREATE TABLE Fornecedores (
    id_fornecedor SERIAL PRIMARY KEY,
    nome_fornecedor VARCHAR(100) NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100) UNIQUE NOT NULL,
    endereco VARCHAR(200) NOT NULL
);

CREATE TABLE Produtos (
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    preco DECIMAL(10, 2) CHECK (preco > 0),
    quantidade_estoque INT,
    fornecedor_id INT NOT NULL,
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(id_fornecedor)
);

CREATE TABLE Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    email_cliente VARCHAR(100) UNIQUE NOT NULL,
    telefone_cliente VARCHAR(15) NOT NULL
);

CREATE TABLE Vendas (
    id_venda SERIAL PRIMARY KEY,
    id_cliente INT,
    data_venda DATE DEFAULT CURRENT_DATE,
    valor_total DECIMAL(10, 2) CHECK (valor_total >= 0),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE ItensVenda (
    id_venda INT,
    id_produto INT,
    quantidade INT,
    preco_unitario DECIMAL(10, 2) CHECK (preco_unitario > 0),
    PRIMARY KEY (id_venda, id_produto),
    FOREIGN KEY (id_venda) REFERENCES Vendas(id_venda),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

CREATE TABLE Pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_venda INT,
    tipo_pagamento VARCHAR(50) NOT NULL,
    valor_pago DECIMAL(10, 2) NOT NULL CHECK (valor_pago >= 0),
    data_pagamento DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_venda) REFERENCES Vendas(id_venda)
);

CREATE VIEW vw_vendas_itens AS
SELECT 
    v.id_venda,
    v.data_venda,
    c.nome_cliente,
    p.nome_produto,
    iv.quantidade,
    iv.preco_unitario,
    (iv.quantidade * iv.preco_unitario) AS valor_total_item
FROM 
    Vendas v
JOIN Clientes c ON v.id_cliente = c.id_cliente
JOIN ItensVenda iv ON v.id_venda = iv.id_venda
JOIN Produtos p ON iv.id_produto = p.id_produto;

CREATE VIEW vw_pagamentos_vendas AS
SELECT 
    p.id_pagamento,
    p.tipo_pagamento,
    p.valor_pago,
    p.data_pagamento,
    v.id_venda,
    v.data_venda,
    c.nome_cliente
FROM 
    Pagamentos p
JOIN Vendas v ON p.id_venda = v.id_venda
JOIN Clientes c ON v.id_cliente = c.id_cliente;

INSERT INTO Fornecedores (nome_fornecedor, telefone, email, endereco) 
VALUES 
('Fornecedor A', '11 91234-5678', 'fornecedora@exemplo.com', 'Rua A, 123'),
('Fornecedor B', '11 99876-5432', 'fornecedorb@exemplo.com', 'Rua B, 456'),
('Fornecedor C', '21 98765-4321', 'fornecedorC@exemplo.com', 'Rua C, 789'),
('Fornecedor D', '21 96543-2109', 'fornecedord@exemplo.com', 'Rua D, 101'),
('Fornecedor E', '31 93456-7890', 'fornecedore@exemplo.com', 'Rua E, 202'),
('Fornecedor F', '31 96543-2109', 'fornecedorf@exemplo.com', 'Rua F, 303');

INSERT INTO Produtos (nome_produto, categoria, preco, quantidade_estoque, fornecedor_id) 
VALUES 
('Produto A', 'Categoria 1', 50.00, 100, 1),
('Produto B', 'Categoria 2', 35.00, 200, 2),
('Produto C', 'Categoria 1', 75.00, 50, 3),
('Produto D', 'Categoria 3', 100.00, 30, 4),
('Produto E', 'Categoria 2', 150.00, 10, 5),
('Produto F', 'Categoria 3', 80.00, 150, 6);

INSERT INTO Clientes (nome_cliente, cpf, email_cliente, telefone_cliente) 
VALUES 
('Cliente A', '123.456.789-01', 'clienteA@exemplo.com', '11 92222-3333'),
('Cliente B', '234.567.890-12', 'clienteB@exemplo.com', '11 93333-4444'),
('Cliente C', '345.678.901-23', 'clienteC@exemplo.com', '21 94444-5555'),
('Cliente D', '456.789.012-34', 'clienteD@exemplo.com', '21 95555-6666'),
('Cliente E', '567.890.123-45', 'clienteE@exemplo.com', '31 96666-7777'),
('Cliente F', '678.901.234-56', 'clienteF@exemplo.com', '31 97777-8888');

INSERT INTO Vendas (id_cliente, valor_total) 
VALUES 
(1, 200.00),
(2, 120.00),
(3, 300.00),
(4, 450.00),
(5, 150.00),
(6, 100.00);

INSERT INTO ItensVenda (id_venda, id_produto, quantidade, preco_unitario) 
VALUES 
(1, 1, 2, 50.00),
(1, 2, 3, 35.00),
(2, 3, 1, 75.00),
(2, 4, 2, 100.00),
(3, 1, 4, 50.00),
(3, 5, 1, 150.00),
(4, 6, 5, 80.00),
(4, 2, 2, 35.00),
(5, 3, 1, 75.00),
(5, 6, 1, 80.00);

INSERT INTO Pagamentos (id_venda, tipo_pagamento, valor_pago) 
VALUES 
(1, 'Cartão', 200.00),
(2, 'Boleto', 120.00),
(3, 'Cartão', 300.00),
(4, 'Dinheiro', 450.00),
(5, 'Boleto', 150.00),
(6, 'Cartão', 100.00);

SELECT * FROM vw_vendas_itens;

SELECT * FROM vw_pagamentos_vendas;
