-- Ex 01: Criando primeiros ambientes de trabalho

CREATE DATABASE dbVeterinaria;
CREATE DATABASE dbOficina;
CREATE DATABASE dbEscolaIdiomas;
CREATE DATABASE dbMateriais;

SHOW DATABASES; -- Mostra bases de dados existentes

USE dbOficina; -- Põe determina base de dados em uso

-- Ex 02: Criando novo ambiente de trabalho

CREATE DATABASE dbAcademia;

SHOW DATABASES;

USE dbAcademia;

-- Ex 03: Criando tabela Veículo da base da dados da oficina

USE dbOficina;

CREATE TABLE tbVeiculo(
id_veiculo INT,
placa VARCHAR(10) NOT NULL UNIQUE,
modelo VARCHAR(100) NOT NULL,
ano YEAR,
valor_estimado DECIMAL(6,2),
ativo BOOL DEFAULT TRUE
);

SHOW TABLES; -- Mostra tabelas já criadas

DESCRIBE Veiculo; -- Descreve o que está presente na tebela

-- Ex 04: Analisando tabela criada e a alterando se necessário

DESCRIBE Veiculo;

ALTER TABLE tbVeiculo MODIFY id_veiculo INT NOT NULL PRIMARY KEY;

DESCRIBE tbVeiculo;

-- Ex 05: Atualizando tabela Veiculo

USE dbOficina;

ALTER TABLE tbVeiculo ADD COLUMN marca VARCHAR(50) NOT NULL;
ALTER TABLE tbVeiculo ADD COLUMN cor VARCHAR(30);
ALTER TABLE tbVeiculo MODIFY modelo VARCHAR(150);
ALTER TABLE tbVeiculo RENAME COLUMN valor_estimado TO valor_mercado;

DESCRIBE tbVeiculo;

-- Ex 06: Excluindo base de dados da veterinária

DROP DATABASE IF EXISTS dbVeterinaria; -- Apaga base se ela existir e caso não, somente notifica, não retorna erro

SHOW DATABASES;

-- Ex 07: Criando ambientes de homologação/análise

CREATE DATABASE dbOficinaHomologacao;
CREATE DATABASE dbEscolaHomologacao;

SHOW DATABASES; -- Confere suas respectivas criações

DROP DATABASE IF EXISTS dboficinahomologacao;
DROP DATABASE IF EXISTS dbescolahomologacao; -- As apaga após uso

-- Ex 08: Conferir o que, atualmente, existe no servidor

SHOW DATABASES;

USE dbOficina;
SHOW TABLES;
DESCRIBE tbVeiculo;

USE dbEscolaIdiomas;
SHOW TABLES;

USE dbOficina;

-- Ex 09: Implementando primeiras tabelas a base de dados da escola

USE dbEscolaIdiomas;

CREATE TABLE tbCurso(
id_curso INT PRIMARY KEY,
nome VARCHAR(100) NOT NULL UNIQUE,
carga_horaria INT NOT NULL,
valor DECIMAL(5,2) NOT NULL CHECK (valor > 0), -- Determina condição que deve ser seguida
ativo BOOL DEFAULT TRUE
);

CREATE TABLE tbProfessor(
id_professor INT PRIMARY KEY,
nome VARCHAR(120) NOT NULL,
email VARCHAR(150) NOT NULL UNIQUE,
data_admissao DATE,
ativo BOOL DEFAULT TRUE
);

SHOW TABLES;

-- Ex 10: Estabelece relacionamento entre as tabelas de turma e curso

-- UMA TURMA REALIZA UM CURSO
-- UM CURSO PODE TER VÁRIAS TURMAS

CREATE TABLE tbTurma(
id_turma INT PRIMARY KEY,
nome varchar(50) NOT NULL,
data_inicio DATE NOT NULL,
horario TIME NOT NULL,
id_curso INT, -- Receberá o identificador da tabela dos cursos
FOREIGN KEY (id_curso) REFERENCES tbCurso(id_curso)
-- A chave estrangeira id_curso referencia a tabela curso e pega sua chave primária
);

DESCRIBE tbTurma;