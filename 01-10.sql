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

-- Ex 10: Estabelecer relacionamento entre as tabelas de turma e curso

-- UMA TURMA REALIZA UM CURSO
-- UM CURSO PODE TER VÁRIAS TURMAS

CREATE TABLE tbTurma(
id_turma INT PRIMARY KEY,
nome VARCHAR(50) NOT NULL,
data_inicio DATE NOT NULL,
horario TIME NOT NULL,
id_curso INT, -- Receberá o identificador da tabela dos cursos
FOREIGN KEY (id_curso) REFERENCES tbCurso(id_curso)
-- A chave estrangeira id_curso referencia a tabela curso e pega sua chave primária
);

DESCRIBE tbTurma;

-- Ex 11: Tornando obrigatório um professor por turma

-- UMA TURMA DEVE TER UM PROFESSOR
-- PROFESSOR JÁ DEVERÁ EXISTIR NO CADASTRO DA TURMA

USE dbEscolaIdiomas;

ALTER TABLE tbTurma ADD COLUMN id_professor INT NOT NULL;

DESCRIBE tbTurma;

-- Ex 12: Criando tabela para cadastro de alunos

USE dbEscolaIdiomas;

CREATE TABLE tbAluno(
id_aluno INT PRIMARY KEY,
nome VARCHAR(150) NOT NULL,
cpf VARCHAR(11) NOT NULL UNIQUE,
data_nascimento DATE,
email VARCHAR(150) UNIQUE,
data_cadastro DATETIME,
ativo BOOL DEFAULT TRUE
);

-- Ex 13: Implementando tabela intermediária que garante a relação entre aluno/turma

-- UM ALUNO PODERÁ PARTICIPAR DE VÁRIAS TURMAS
-- UMA TURMA TERÁ VÁRIOS ALUNOS

CREATE TABLE tbMatricula(
id_aluno INT,
id_turma INT,
data_matricula DATE NOT NULL,
situacao VARCHAR(20) NOT NULL,

PRIMARY KEY (id_aluno, id_turma), -- identifica a matrícula e impede duplas matrículas

FOREIGN KEY (id_aluno) REFERENCES tbAluno(id_aluno),
FOREIGN KEY (id_turma) REFERENCES tbTurma(id_turma)
);

DESCRIBE tbMatricula;

/*
Ex 14: Importância da normalização

A normalização é primordial para garantir uma base de dados SEM redundâncias, portanto, repetições 
desnecessárias. Cada tabela se torna um "molde" responsável por armazenar o que é necessário e o 
fato das mesmas estarem ligadas entre si, não se torna preciso repetir o que uma/outra já possui.
*/

DESCRIBE tbAluno;
DESCRIBE tbMatricula;

-- Ex 15: Alterando estrutura já existe para realmente ser condizente as necessidades do projeto

CREATE DATABASE dbClienteHomologacao;

USE dbClienteHomologacao;

CREATE TABLE tbCliente ( 
id_cliente INT, 
nome VARCHAR(100), 
cpf CHAR(11), 
ativo BOOLEAN 
);

/*
Ausências:

- Restrição que torna id chave primária/identificador
- Restrição not null no nome
- Restrições no cpf
- Valor padrão no ativo
*/

ALTER TABLE tbCliente MODIFY id_cliente INT PRIMARY KEY;
ALTER TABLE tbCliente MODIFY nome VARCHAR(100) NOT NULL;
ALTER TABLE tbCliente MODIFY cpf CHAR(11) NOT NULL UNIQUE;
ALTER TABLE tbCliente MODIFY ativo BOOLEAN DEFAULT TRUE;

DESCRIBE tbCliente;

-- Ex 16: Testando projeto de uma   locadora

CREATE DATABASE dbLocadoraTeste;

USE dbLocadoraTeste;

CREATE TABLE tbCliente(
id_cliente INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(150) NOT NULL,
doc CHAR(14) NOT NULL UNIQUE,
telefone CHAR(11),
situacao BOOL DEFAULT TRUE
);

CREATE TABLE tbCategoria(
id_categoria INT PRIMARY KEY,
nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE tbEquipamento(
id_equipamento INT PRIMARY KEY,
nome VARCHAR(120) NOT NULL,
id_categoria INT NOT NULL REFERENCES tbCategoria(id_categoria),
valor_diario DECIMAL(6,2) CHECK(valor_diario > 0),
situacao CHAR(12) DEFAULT 'DISPONÍVEL'
);

CREATE TABLE tbLocacao(
id_locacao INT PRIMARY KEY,
id_cliente INT NOT NULL REFERENCES tbCliente(id_cliente),
data_retirada DATETIME,
data_devolucao TIME,
situacao CHAR(12) DEFAULT 'DISPONÍVEL'
);

CREATE TABLE tbItem_Locacao (
id_locacao INT NOT NULL,
id_equipamento INT NOT NULL,
valor_diario DECIMAL(6,2) NOT NULL,

PRIMARY KEY (id_locacao, id_equipamento), -- Formam identificador único do item
    
FOREIGN KEY (id_locacao) REFERENCES tbLocacao(id_locacao),
FOREIGN KEY (id_equipamento) REFERENCES tbEquipamento(id_equipamento)
);

-- Ex 17: Fazendo alterações solicitadas

ALTER TABLE tbEquipamento MODIFY nome VARCHAR(180);
ALTER TABLE tbEquipamento ADD COLUMN marca VARCHAR(80) NOT NULL;
ALTER TABLE tbEquipamento RENAME COLUMN valor_diario TO valor_locacao;
ALTER TABLE tbCategoria RENAME TO tbTipo_Equipamento;

-- Ex 18: Criando e testando tabela temporária

USE dbLocadoraTeste;

CREATE TABLE tbEquipamento_Importacao(
codigo INT PRIMARY KEY,
descricao VARCHAR(300),
quantidade INT
);

-- Situação A: TRUNCATE TABLE esvazia dados da tabela sem apagar sua estrutura.
-- Situação B: DROP TABLE apaga permanentemente todos os dados e toda a estrutura da tabela.

-- Ex 19: Encerrando ambientes/bases de dados de teste

SHOW DATABASES;

DROP DATABASE IF EXISTS dbClienteHomologacao;
DROP DATABASE IF EXISTS dbLocadoraTeste;

SHOW DATABASES;