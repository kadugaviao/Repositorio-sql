CREATE TABLE clientes( 
	id_cliente serial PRIMARY KEY,
	nome varchar(30) NOT NULL,
	email varchar(30) NOT NULL
);

CREATE TABLE restaurante(
	id_restaurante serial PRIMARY KEY,
	nome varchar(30) NOT NULL
);

CREATE TABLE pedidos(
	id_pedidos serial PRIMARY KEY,
	id_cliente INTEGER REFERENCES clientes(id_cliente),
	id_restaurante INTEGER REFERENCES restaurante(id_restaurante),
	data_hora DATE DEFAULT CURRENT_DATE,
	status varchar(30)
);

CREATE TABLE prato (
	id_prato serial PRIMARY KEY,
	nome varchar(30),
	preco NUMERIC(10, 2) NOT NULL
);

CREATE TABLE item_pedido(
	id_item serial PRIMARY KEY,
	id_pedidos INTEGER REFERENCES pedidos(id_pedidos),
	id_prato INTEGER REFERENCES prato(id_prato),
	quantidade INTEGER NOT NULL
);

INSERT INTO clientes(nome, email)
VALUES
	('José Augusto', 'joseag@gmail.com'),
	('Pedro Henrique', 'phenrique@gmail.com');

INSERT INTO restaurante(nome)
VALUES
	('Restaurante 1');

INSERT INTO prato(nome, preco)
VALUES 
	('Picanha', 40.00),
	('Arroz com Feijão', 15.00);

INSERT INTO pedidos(id_cliente, id_restaurante, status)
VALUES(1, 1, 'Em preparo');

INSERT INTO item_pedido(id_pedidos, id_prato, quantidade)
VALUES
	(1, 1, 1),
	(1, 2, 1);

SELECT * 
FROM pedidos AS p
WHERE p.id_cliente = (
	SELECT c.id_cliente 
	FROM clientes AS c
	WHERE c.nome = 'José Augusto'
);

SELECT 
    SUM(pr.preco * ip.quantidade) AS total
FROM item_pedido AS ip, prato AS pr
WHERE ip.id_prato = pr.id_prato
AND ip.id_pedidos = 1;

SELECT pr.nome AS prato, ip.quantidade
FROM item_pedido AS ip, prato AS pr
WHERE ip.id_prato = pr.id_prato
AND ip.id_pedidos = 1;
