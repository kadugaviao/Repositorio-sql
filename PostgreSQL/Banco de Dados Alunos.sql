CREATE TABLE alunos (
	id_aluno SERIAL PRIMARY KEY,
	nome VARCHAR(30) NOT NULL, 
	email VARCHAR(30)
);

CREATE TABLE curso (
	id_curso SERIAL PRIMARY KEY,
	nome_curso VARCHAR(20)
);

CREATE TABLE matriculas (
	id_aluno INTEGER NOT NULL,
	id_curso INTEGER NOT NULL,
	data_matricula DATE DEFAULT CURRENT_DATE,
	FOREIGN KEY(id_aluno) REFERENCES alunos(id_aluno),
	FOREIGN KEY(id_curso) REFERENCES curso(id_curso),
	PRIMARY KEY(id_aluno, id_curso)
);

INSERT INTO alunos(nome, email)
VALUES
	('José Augusto', 'joseag@gmail.com'),
	('Pedro Henrique', 'phenrique@gmail.com');

INSERT INTO curso(nome_curso)
VALUES
	('Sistemas de Informação'),
	('Administração');

INSERT INTO matriculas 
VALUES 
	(1, 1),
	(2, 2);

UPDATE curso
SET nome_curso = 'Banco de Dados Avançados'
WHERE id_curso = 1;

DELETE FROM matriculas
WHERE id_aluno = 2;

DELETE FROM alunos
WHERE id_aluno = 2;

SELECT * FROM alunos;

SELECT * FROM curso;

SELECT * FROM matriculas;