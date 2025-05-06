CREATE TABLE clientes (
	id_cliente SERIAL PRIMARY KEY,
	nome TEXT NOT NULL,
	email TEXT,
	data_cadastro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE pedidos (
	id_pedido SERIAL PRIMARY KEY,
	id_cliente INTEGER NOT NULL,
	valor_total NUMERIC(10, 2) NOT NULL, 
	data_pedido DATE DEFAULT CURRENT_DATE,
	FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

ALTER TABLE clientes 
ADD COLUMN telefone TEXT;

ALTER TABLE clientes
ADD COLUMN ativo BOOLEAN DEFAULT TRUE;

ALTER TABLE clientes
DROP COLUMN telefone;

ALTER TABLE pedidos 
RENAME TO vendas;

DROP TABLE vendas;