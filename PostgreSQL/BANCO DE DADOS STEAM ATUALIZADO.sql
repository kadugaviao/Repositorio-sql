-- Usuários: credenciais e data de registro
CREATE TABLE usuario ( 
	id_usuario SERIAL PRIMARY KEY,
	nome_usuario VARCHAR(32) NOT NULL, 
	email VARCHAR(320) NOT NULL,
	senha VARCHAR(30) NOT NULL,
	data_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Publishers: empresas que publicam jogos
CREATE TABLE publisher (
	id_publisher SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	pais VARCHAR(50)
);

-- Desenvolvedores: estúdios que criam jogos
CREATE TABLE desenvolvedor (
	id_dev SERIAL PRIMARY KEY, 
	nome VARCHAR(100) NOT NULL,
	pais VARCHAR(50)	
);

-- Gêneros de jogo (Ação, RPG, etc.)
CREATE TABLE genero (
	id_genero SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL
);

-- Jogos: catálogo principal
CREATE TABLE jogo (
	id_jogo SERIAL PRIMARY KEY,
	titulo VARCHAR(150) NOT NULL,
	descricao VARCHAR(300), 
	data_lancamento DATE,
	preco_base NUMERIC(8,2) NOT NULL,
	id_publisher INTEGER NOT NULL REFERENCES publisher(id_publisher)
);

-- Relação N:N entre jogos e desenvolvedores
CREATE TABLE jogoDesenvolvedor (
	id_jogo INTEGER NOT NULL REFERENCES jogo(id_jogo),
	id_dev INTEGER NOT NULL REFERENCES desenvolvedor(id_dev),
	PRIMARY KEY (id_jogo, id_dev)
);

-- Relação N:N entre jogos e gêneros
CREATE TABLE jogoGenero (
	id_jogo INTEGER NOT NULL REFERENCES jogo(id_jogo),
	id_genero INTEGER NOT NULL REFERENCES genero(id_genero),
	PRIMARY KEY (id_jogo, id_genero)
);

-- Compras realizadas pelos usuários
CREATE TABLE compra (
	id_compra SERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario),
	id_jogo INTEGER NOT NULL REFERENCES jogo(id_jogo),
	data_compra TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	preco_pago NUMERIC(8,2) NOT NULL
);

-- Avaliações de jogos pelos usuários
CREATE TABLE avaliacao (
	id_avaliacao SERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario),
	id_jogo INTEGER NOT NULL REFERENCES jogo(id_jogo),
	nota SMALLINT NOT NULL CHECK (nota BETWEEN 0 AND 10),
	comentario VARCHAR(8000),
	data_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Amizades entre usuários
CREATE TABLE amizade (
	id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario),
	amigo_id INTEGER NOT NULL REFERENCES usuario(id_usuario),
	data_amizade TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id_usuario, amigo_id)
);

-- Conquistas disponíveis em cada jogo
CREATE TABLE conquista (
	id_conquista SERIAL PRIMARY KEY,
	id_jogo INTEGER NOT NULL REFERENCES jogo(id_jogo),
	nome VARCHAR(100) NOT NULL,
	descricao VARCHAR(100),
	pontos INTEGER NOT NULL DEFAULT 0
);

-- Relação N:N entre usuários e conquistas (conquistas obtidas)
CREATE TABLE usuarioConquista (
	id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario),
	id_conquista INTEGER NOT NULL REFERENCES conquista(id_conquista),
	data_conquista TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id_usuario, id_conquista)
);

-- DLCs (conteúdo adicional) de jogos
CREATE TABLE dlc (
	id_dlc SERIAL PRIMARY KEY,
	id_jogo_base INTEGER NOT NULL REFERENCES jogo(id_jogo),
	nome VARCHAR(100) NOT NULL, 
	preco NUMERIC(8,2) NOT NULL
);

-- Lista de desejos dos usuários
CREATE TABLE listaDeDesejos (
	id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario),
	id_jogo INTEGER NOT NULL REFERENCES jogo(id_jogo),
	data_adicao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id_usuario, id_jogo)
);

-- Cartas colecionáveis dos jogos
CREATE TABLE cartas (
	id_carta SERIAL PRIMARY KEY,
	id_jogo INTEGER NOT NULL REFERENCES jogo(id_jogo),
	nome VARCHAR(100) NOT NULL
);

-- Relação N:N entre usuários e cartas (coleção de cartas)
CREATE TABLE cartaUsuario (
	id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario),
	id_carta INTEGER NOT NULL REFERENCES cartas(id_carta),
	quantidade INTEGER NOT NULL DEFAULT 1,
	PRIMARY KEY (id_usuario, id_carta)
);

-- Badges (insígnias) gerais
CREATE TABLE badge (
	id_badge SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	nivel INTEGER NOT NULL DEFAULT 1
);

-- Badges conquistadas pelos usuários
CREATE TABLE badgeUsuario (
	id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario),
	id_badge INTEGER NOT NULL REFERENCES badge(id_badge),
	data_badge TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id_usuario, id_badge)
);

-- Dispositivos remotos autorizados
CREATE TABLE dispositivoRemoto (
	id_disp SERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario),
	nome_disp  VARCHAR(100) NOT NULL,
	data_autorizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Sessões de jogo via dispositivo remoto
CREATE TABLE sessaoRemota (
	id_sessao SERIAL PRIMARY KEY,
	id_dispositivo INTEGER NOT NULL REFERENCES dispositivoRemoto(id_disp),
	id_jogo INTEGER NOT NULL REFERENCES jogo(id_jogo),
	data_inicio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	data_fim TIMESTAMP  
);

-- Inserts

INSERT INTO usuario (nome_usuario, email, senha) 
VALUES
	('jogador1', 'jogador01@gmail.com', 'abc123'),
	('jogador2', 'jogador02@gmail.com', 'def456'),
	('jogador3', 'jogador03@gmail.com', 'ghi789');

INSERT INTO publisher (nome, pais) 
VALUES
	('Valve', 'Estados Unidos'),
	('Ubisoft', 'França'),
	('CD Projekt RED', 'Polônia');

INSERT INTO desenvolvedor (nome, pais) 
VALUES
	('Valve Software', 'Estados Unidos'),
	('Ubisoft Montreal', 'Canadá'),
	('CD Projekt Red', 'Polônia');

INSERT INTO genero (nome) 
VALUES 
	('Ação'), ('Aventura'), ('RPG'), ('Simulação');

INSERT INTO jogo (titulo, descricao, data_lancamento, preco_base, id_publisher) VALUES
	('Half-Life 2', 'FPS clássico de ficção científica.', '2004-11-16', 32.99, 1),
	('Assassin''s Creed 2', 'Ação e aventura histórica.', '2009-11-17', 60.00, 2),
	('The Witcher 3', 'RPG de mundo aberto premiado.', '2015-05-19', 129.99, 3);

INSERT INTO jogoDesenvolvedor (id_jogo, id_dev) 
VALUES
	(1,1), (2,2), (3,3);

INSERT INTO jogoGenero (id_jogo, id_genero) 
VALUES
	(1,1), (1,2),
	(2,2), (2,3),
	(3,1), (3,2);

INSERT INTO compra (id_usuario, id_jogo, preco_pago) 
VALUES
	(1,1,32.99),
	(2,2,60.00),
	(3,3,129.99);

INSERT INTO avaliacao (id_usuario, id_jogo, nota, comentario) 
VALUES
	(1,1,10,'Clássico absoluto!'),
	(2,2,9,'Melhor RPG da geração.'),
	(3,3,8,'Bom, mas com bugs.'),
	(1,2,9,'Adorei cada detalhe.');

INSERT INTO amizade (id_usuario, amigo_id) 
VALUES
	(1,2), (2,1), (1,3);

INSERT INTO conquista (id_jogo, nome, descricao, pontos) 
VALUES
	(1, 'Trusty Hardware','Adquira o crowbar.', 5),
	(2, 'Fist of the South Star','Derrote um oponente em um combate sem receber dano.',15),
	(2, 'The Birth of an Assassin', 'Renascido como Ezio Auditore da Firenze.', 10);

INSERT INTO usuarioConquista (id_usuario, id_conquista) 
VALUES
	(1,1), (2,2), (3,3);

INSERT INTO dlc (id_jogo_base, nome, preco) 
VALUES
	(2,'Blood and Wine',14.99),
	(3, 'Battle of Forlì', 0.00),
	(3, 'Bonfire of the Vanities', 0.00);

INSERT INTO listaDeDesejos (id_usuario, id_jogo) 
VALUES
	(1,2),(2,3),(3,1);

INSERT INTO cartas (id_jogo, nome) 
VALUES
	(1,'G-Man'),   
	(2,'Geralt'),
	(2,'Eredin');

-- Inserções na tabela 'badge'
INSERT INTO badge (nome, nivel) 
VALUES
	('Half-Life 2 - Nível 1', 1),
	('Half-Life 2 - Nível 2', 2),
	('Half-Life 2 - Nível 3', 3),
	('Half-Life 2 - Nível 4', 4),
	('Half-Life 2 - Nível 5', 5),
	('Half-Life 2 - Foil', 6),
	('Assassin''s Creed 2 - Nível 1', 1),
	('Assassin''s Creed 2 - Nível 2', 2),
	('Assassin''s Creed 2 - Nível 3', 3),
	('Assassin''s Creed 2 - Nível 4', 4),
	('Assassin''s Creed 2 - Nível 5', 5),
	('Assassin''s Creed 2 - Foil', 6),
	('The Witcher 3 - Nível 1', 1),
	('The Witcher 3 - Nível 2', 2),
	('The Witcher 3 - Nível 3', 3),
	('The Witcher 3 - Nível 4', 4),
	('The Witcher 3 - Nível 5', 5),
	('The Witcher 3 - Foil', 6);

INSERT INTO badgeUsuario (id_usuario, id_badge) 
VALUES
	(1, 1),
	(1, 6), 
	(2, 7), 
	(2, 12), 
	(3, 13),
	(3, 18);

INSERT INTO dispositivoRemoto (id_usuario, nome_disp) 
VALUES
	(1, 'PC Gamer'),
	(2, 'Notebook ASUS'),
	(3, 'Steam Deck');

INSERT INTO sessaoRemota (id_dispositivo, id_jogo, data_inicio, data_fim) 
VALUES
	(1, 1, '2025-05-01 15:00:00', '2025-05-01 17:00:00'),
	(2, 2, '2025-05-01 16:00:00', '2025-05-01 18:00:00'),
	(3, 3, '2025-05-01 17:00:00', NULL);

-- Listar todos os jogos com seus gêneros
SELECT j.titulo, g.nome AS genero
FROM jogo AS j, jogoGenero AS jg, genero AS g
WHERE j.id_jogo = jg.id_jogo AND jg.id_genero = g.id_genero
ORDER BY j.titulo;

-- Exibir usuários com suas conquistas e jogos correspondentes
SELECT u.nome_usuario AS usuario, c.nome AS conquista, j.titulo AS jogo
FROM usuario AS u,  usuarioConquista AS uc, conquista AS c, jogo AS j
WHERE u.id_usuario = uc.id_usuario 
  AND uc.id_conquista = c.id_conquista 
  AND c.id_jogo = j.id_jogo
ORDER BY u.nome_usuario;

-- Total gasto por usuário
SELECT u.nome_usuario AS usuario, SUM(cp.preco_pago) AS total_gasto
FROM usuario AS u, compra AS cp
WHERE u.id_usuario = cp.id_usuario
GROUP BY u.nome_usuario
ORDER BY total_gasto DESC;

-- Sessões remotas em andamento (data_fim IS NULL)
SELECT u.nome_usuario AS usuario, d.nome_disp AS dispositivo, j.titulo AS jogo, s.data_inicio AS inicio
FROM sessaoRemota AS s,  dispositivoRemoto AS d, usuario AS u, jogo AS j
WHERE s.id_dispositivo = d.id_disp 
  AND d.id_usuario = u.id_usuario 
  AND s.id_jogo = j.id_jogo 
  AND s.data_fim IS NULL;

-- Média de avaliação por jogo
SELECT j.titulo, ROUND(AVG(a.nota),2) AS media_nota
FROM jogo AS j, avaliacao AS a
WHERE j.id_jogo = a.id_jogo
GROUP BY j.titulo
ORDER BY media_nota DESC;

-- Lista de desejos de cada usuário
SELECT u.nome_usuario AS usuario, j.titulo AS jogo_desejado, l.data_adicao AS quando
FROM listaDeDesejos AS l, usuario AS u, jogo AS j
WHERE l.id_usuario = u.id_usuario 
  AND l.id_jogo = j.id_jogo
ORDER BY u.nome_usuario,  l.data_adicao;

-- Usuários com badges nível 6 (Foil)
SELECT u.nome_usuario AS usuario, b.nome AS badge
FROM badgeUsuario AS bu, badge AS b, usuario AS u
WHERE bu.id_badge = b.id_badge 
  AND bu.id_usuario = u.id_usuario 
  AND b.nivel = 6;

-- Listar amizades (pares únicos)
SELECT u1.nome_usuario AS usuario, u2.nome_usuario AS amigo
FROM amizade AS a, usuario AS u1, usuario AS u2
WHERE a.id_usuario = u1.id_usuario 
  AND a.amigo_id = u2.id_usuario 
  AND u1.id_usuario < u2.id_usuario
ORDER BY u1.nome_usuario;


