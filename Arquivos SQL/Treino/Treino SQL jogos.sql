CREATE DATABASE loja_de_videogames;

USE loja_de_videogames;

CREATE TABLE jogos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL, 
    genero VARCHAR(50),
    plataforma VARCHAR(50),
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT DEFAULT 0
);

INSERT INTO jogos (nome, genero, plataforma, preco, estoque)
VALUES 
	('The Legend of Zelda: Breath of the Wild', 'Ação e Aventura', 'Nintendo Switch', 299.99, 10),
	('Devil May Cry 5', 'Ação e Aventura, Hack\'n\'Slash', 'Playstation, Xbox e PC', 164.99, 15),
    ('Dark Souls 3', 'RPG de Ação', 'Playstation, Xbox e PC', 174.99, 8),
    ('God of War Ragnarok', 'Ação e Aventura', 'Playstation', 299.90, 5),
    ('FIFA 24', 'Esporte', 'Playstation, Xbox e PC', 349.90, 25);

CREATE TABLE clientes (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL, 
    telefone VARCHAR(15), 
    endereco VARCHAR(255)
    );

CREATE TABLE pedidos (
	id INT AUTO_INCREMENT PRIMARY KEY, 
    cliente_id INT NOT NULL,
    jogo_id INT NOT NULL,
    quantidade INT NOT NULL, 
    total DECIMAL(10, 2) NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (jogo_id) REFERENCES jogos(id)
    );

DESCRIBE jogos;
DESCRIBE clientes;
DESCRIBE pedidos;

SHOW TABLES;

INSERT INTO clientes (nome, email, telefone, endereco)
VALUES
	('João Silva', 'joao@gmail.com', '9999-12345', 'Rua A, 123'), 
    ('Maria Oliveira', 'maria@gmail.com', '9999-23456', 'Rua B, 456');
    
INSERT INTO pedidos (cliente_id, jogo_id, quantidade, total)
VALUES  (1, 3, 1, 174.99);

SELECT * FROM jogos;

SELECT * FROM clientes;

SELECT * FROM pedidos;

SELECT pedidos.id AS pedido_id,
	clientes.nome AS cliente, 
    jogos.nome AS jogo,
    pedidos.quantidade,
    pedidos.total,
    pedidos.data_pedido
FROM pedidos
JOIN clientes ON pedidos.cliente_id = clientes.id
JOIN jogos ON pedidos.jogo_id = jogos.id;

DELETE FROM pedidos
WHERE id NOT IN (
    SELECT MIN(id)
    FROM pedidos
    GROUP BY cliente_id, jogo_id, quantidade, total
);

    



