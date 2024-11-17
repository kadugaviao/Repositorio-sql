-- Exemplo 1. Selecionando todas as linhas e colunas da:
-- a) tabela pedidos
SELECT * FROM pedidos;

-- b) tabela clientes
SELECT * FROM clientes;

-- c) tabela locais
SELECT * FROM locais;

-- d) tabela lojas
SELECT * FROM lojas;

-- e) tabela pedidos
SELECT * FROM pedidos;

-- f) tabela produtos
SELECT * FROM produtos;


-- Exemplo 2. Selecionar apenas algumas colunas da tabela clientes
SELECT 
	ID_Cliente AS 'ID Cliente', 
	Nome AS 'Nome do Cliente', 
    Data_Nascimento AS 'Data de Nascimento', 
    Email AS 'E-mail do Cliente' 
FROM clientes;


-- Exemplo 3. Selecionar apenas as 5 primeiras linhas da tabela de produtos
SELECT 
	ID_Produto AS 'ID do Produto',
    Nome_Produto AS 'Nome do Produto',
    ID_Categoria AS 'ID da Categoria',
    Marca_Produto AS 'Marca do Produto',
    Num_Serie AS 'Número de Série',
    Preco_Unit AS 'Preço por Unidade',
    Custo_Unit AS 'Custo por Unidade'
FROM produtos
LIMIT 8;

-- Exemplo 4. Selecionar todas as linhas da tabela produtos, mas
-- ordenando pela coluna Preco_Unit
SELECT * FROM produtos
ORDER BY Preco_Unit DESC;
