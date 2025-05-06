CREATE TABLE departamento (
  dep_numero INT         PRIMARY KEY,
  dep_nome   VARCHAR(30) NOT NULL,
  gerente_cpf CHAR(11)   NOT NULL
);

CREATE TABLE empregado (
  emp_cpf               CHAR(11)       PRIMARY KEY,
  emp_nome              VARCHAR(100)   NOT NULL,
  emp_endereco          VARCHAR(150),
  emp_data_nascimento   DATE,
  emp_salario           DECIMAL(10,2),
  emp_sexo              CHAR(1),
  supervisor_cpf        CHAR(11),
  dep_numero            INT,
  FOREIGN KEY (supervisor_cpf) REFERENCES empregado(emp_cpf),
  FOREIGN KEY (dep_numero)       REFERENCES departamento(dep_numero)
);

ALTER TABLE departamento
  ADD CONSTRAINT fk_departamento_gerente
    FOREIGN KEY (gerente_cpf) REFERENCES empregado(emp_cpf);

CREATE TABLE projeto (
  proj_numero INT         PRIMARY KEY,
  proj_nome   VARCHAR(50) NOT NULL,
  proj_local  VARCHAR(50),
  dep_numero  INT         NOT NULL,
  FOREIGN KEY (dep_numero) REFERENCES departamento(dep_numero)
);

CREATE TABLE trabalha_em (
  emp_cpf     CHAR(11) NOT NULL,
  proj_numero INT      NOT NULL,
  PRIMARY KEY (emp_cpf, proj_numero),
  FOREIGN KEY (emp_cpf)     REFERENCES empregado(emp_cpf),
  FOREIGN KEY (proj_numero) REFERENCES projeto(proj_numero)
);

CREATE TABLE dependente (
  emp_cpf             CHAR(11)      NOT NULL,
  dep_nome_dependente VARCHAR(100)  NOT NULL,
  dep_sexo            CHAR(1),
  dep_data_nascimento DATE,
  dep_parentesco      VARCHAR(20),
  PRIMARY KEY (emp_cpf, dep_nome_dependente),
  FOREIGN KEY (emp_cpf) REFERENCES empregado(emp_cpf)
);

-- 1. Liste o nome e a data de nascimento do empregado 'Joao Silva'.
SELECT emp_nome, emp_data_nascimento
FROM empregado
WHERE emp_nome = 'Joao Silva';

-- 2. Liste o nome e o endereço de todos os empregados que pertencem ao departamento 'Pesquisa'.
SELECT E.emp_nome, E.emp_endereco
FROM empregado E, departamento D
WHERE E.dep_numero = D.dep_numero
  AND D.dep_nome = 'Pesquisa';

-- 3. Para cada projeto localizado no 'Luxemburgo', liste o numero do projeto, o número do departamento que o controla e o nome, endereço e data de aniversário do gerente do departamento.
SELECT P.proj_numero,
       P.dep_numero,
       G.emp_nome AS gerente_nome,
       G.emp_endereco AS gerente_endereco,
       G.emp_data_nascimento AS gerente_data_nascimento
FROM projeto P, departamento D, empregado G
WHERE P.dep_numero = D.dep_numero
  AND D.gerente_cpf = G.emp_cpf
  AND P.proj_local  = 'Luxemburgo';

-- 4. Para cada empregado, recupere o seu nome e o nome de seu supervisor.
SELECT E.emp_nome AS empregado,
       S.emp_nome AS supervisor
FROM empregado E, empregado S
WHERE E.supervisor_cpf = S.emp_cpf;

-- 5. Selecione os empregados do departamento de número 1.
SELECT *
FROM empregado
WHERE dep_numero = 1;

-- 6. Liste todos os dados dos empregados que moram na 'Irai'.
SELECT *
FROM empregado
WHERE emp_endereco LIKE '%Irai%';

-- 7a. Liste o número de todos os projetos que possuem empregados com sobrenome 'Santos', como trabalhador
SELECT T.proj_numero
FROM trabalha_em T, empregado E
WHERE T.emp_cpf = E.emp_cpf
  AND E.emp_nome LIKE '%Santos%';

-- 7b. Liste o número de todos os projetos que possuem empregados com sobrenome 'Santos', como gerente do departamento que controla os projetos.
SELECT P.proj_numero
FROM projeto P, departamento D, empregado G
WHERE P.dep_numero    = D.dep_numero
  AND D.gerente_cpf   = G.emp_cpf
  AND G.emp_nome LIKE '%Santos%';

-- 8. Mostre o resultado do aumento de 20% sobre o salário dos empregados que trabalham no projeto de nome 'ProdX' (desafio).
SELECT E.emp_nome,
       E.emp_salario,
       E.emp_salario * 1.2 AS novo_salario
FROM empregado E, trabalha_em T, projeto P
WHERE E.emp_cpf     = T.emp_cpf
  AND T.proj_numero = P.proj_numero
  AND P.proj_nome   = 'ProdX';

-- 9. Liste o nome dos empregados do departamento 3 que possuem salário entre R$800,00 e R$1.200,00 (desafio).
SELECT emp_nome, emp_salario
FROM empregado
WHERE dep_numero = 3
  AND emp_salario BETWEEN 800 AND 1200;

-- 10. Liste o nome dos empregados, o nome dos seus departamentos e o nome dos projetos em que eles trabalham, ordenados pelo departamento e projeto.
SELECT E.emp_nome    AS empregado,
       D.dep_nome    AS departamento,
       P.proj_nome   AS projeto
FROM empregado E, departamento D, trabalha_em T, projeto P
WHERE E.dep_numero = D.dep_numero
  AND E.emp_cpf    = T.emp_cpf
  AND T.proj_numero = P.proj_numero
ORDER BY D.dep_nome, P.proj_nome;

-- 11. Liste os colegas de trabalho de 'Joao Silva', ou seja, empregados que trabalham nos mesmos projetos (exceto ele mesmo).
SELECT E2.emp_nome
FROM empregado E1, trabalha_em T1, trabalha_em T2, empregado E2
WHERE E1.emp_cpf     = T1.emp_cpf
  AND T1.proj_numero = T2.proj_numero
  AND T2.emp_cpf     = E2.emp_cpf
  AND E1.emp_nome    = 'Joao Silva'
  AND E2.emp_nome   <> 'Joao Silva';

-- 12. Liste os nomes dos empregados que não possuem supervisores.
SELECT emp_nome
FROM empregado
WHERE supervisor_cpf IS NULL;

-- 13. Liste o nome dos empregados e o nome de seus dependentes, para empregados que possuem mais de dois dependentes.
SELECT E.emp_nome, D.dep_nome_dependente
FROM empregado E, dependente D
WHERE E.emp_cpf = D.emp_cpf
  AND E.emp_cpf IN (
    SELECT emp_cpf
    FROM dependente
    GROUP BY emp_cpf
    HAVING COUNT(*) > 2
);

-- 14. Calcule a soma, média, maior e menor salário dos empregados.
SELECT SUM(emp_salario) AS soma,
       AVG(emp_salario) AS media,
       MAX(emp_salario) AS maior,
       MIN(emp_salario) AS menor
FROM empregado;

-- 15. Calcule a soma, média, maior e menor salário dos empregados do departamento 'Pesquisa'.
SELECT SUM(E.emp_salario) AS soma,
       AVG(E.emp_salario) AS media,
       MAX(E.emp_salario) AS maior,
       MIN(E.emp_salario) AS menor
FROM empregado E, departamento D
WHERE E.dep_numero = D.dep_numero
  AND D.dep_nome = 'Pesquisa';

-- 16. Liste o nome dos supervisores e a quantidade de empregados que supervisionam.
SELECT S.emp_nome AS supervisor,
       (SELECT COUNT(*) FROM empregado E WHERE E.supervisor_cpf = S.emp_cpf) AS num_supervisionados
FROM empregado S
WHERE EXISTS (
  SELECT 1 FROM empregado E WHERE E.supervisor_cpf = S.emp_cpf
);

-- 17. Liste os projetos e a quantidade de empregados que trabalham em cada um deles.
SELECT P.proj_nome AS projeto,
       (SELECT COUNT(*) FROM trabalha_em T WHERE T.proj_numero = P.proj_numero) AS num_empregados
FROM projeto P;

-- 18. Liste os projetos que têm mais de dois empregados.
SELECT P.proj_nome AS projeto,
       (SELECT COUNT(*) FROM trabalha_em T WHERE T.proj_numero = P.proj_numero) AS qtd_empregados
FROM projeto P
WHERE (SELECT COUNT(*) FROM trabalha_em T WHERE T.proj_numero = P.proj_numero) > 2;

-- 19. Liste os nomes dos empregados, o nome do departamento e salário, para departamentos com mais de dois empregados com salário acima de R$800,00.
SELECT D.dep_nome AS departamento, E.emp_nome, E.emp_salario
FROM empregado E, departamento D
WHERE E.dep_numero = D.dep_numero
  AND D.dep_numero IN (
    SELECT dep_numero
    FROM empregado
    WHERE emp_salario > 800
    GROUP BY dep_numero
    HAVING COUNT(*) > 2 
);