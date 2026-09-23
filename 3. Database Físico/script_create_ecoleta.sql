##################### ARQUIVO RESPONSÁVEL PELOS CREATEs #####################

-- Criação do Datase para armazenar os dados sobre o:
-- TCC do Senai para o gerenciamento de Resíduos entre Estabelecimentos e Empresas que possam coletar o resíduo (Ecoleta)

-- Criação do database
create database db_tcc_ecoleta;

-- Utilização do database
use db_tcc_ecoleta;

-- ====== TABELAS AUXILIARES ======
-- Tabela de Email
create table tbl_email (
id 		int not null auto_increment primary key,
email 	varchar(256) not null
);

-- Tabela de Telefone
create table tbl_telefone (
id 		int not null auto_increment primary key,
numero 	varchar(25) not null
);

-- Tabela de Estado
create table tbl_estado (
id 			int not null auto_increment primary key,
sigla 		varchar(3) not null,
nome_estado varchar(30) not null
);

-- Tabela de Cidade
create table tbl_cidade (
id 			int not null auto_increment primary key,
nome_cidade varchar(60) not null,
id_estado 	int not null,

constraint 	FK_ESTADO_CIDADE
foreign key (id_estado)
references 	tbl_estado(id)
);

-- Tabela de Endereço
create table tbl_endereco (
id 			int not null auto_increment primary key,
cep 		varchar(12) not null,
logradouro 	varchar(100) not null,
numero 		int not null,
bairro		varchar(80) not null,
latitude	decimal(10,7) not null,
longitude	decimal(10,7) not null,
id_cidade	int not null,

constraint	FK_CIDADE_ENDERECO
foreign key	(id_cidade)
references	tbl_cidade(id)
);

-- =============== CRIAÇÃO DAS TABELAS QUE FORNECEM CHAVE ESTRANGEIRA (FK) ===============
-- Tabela de Status da Oferta
create table tbl_status_oferta (
id 		int not null auto_increment primary key,
status 	varchar(20) not null
);

-- Tabela de Status da Coleta
create table tbl_status_coleta (
id 		int not null auto_increment primary key,
status 	varchar(20) not null
);

-- Tabela de Status do Resíduo
create table tbl_status_residuo (
id 		int not null auto_increment primary key,
status 	varchar(20) not null
);

-- Tabela do Tipo do Material
create table tbl_tipo_material (
id 			int not null auto_increment primary key,
material	varchar(50) not null
);

-- =============== CRIAÇÃO DAS TABELAS QUE RECEBEM CHAVE ESTRANGEIRA (FK) ===============
-- Tabela do Estabelecimento - PRINCIPAL
create table tbl_estabelecimento (
id 			int not null auto_increment primary key,
nome 		varchar(100) not null,
cnpj 		varchar(25) not null,
senha_hash 	varchar(512) not null,
id_email 	int not null,
id_telefone	int not null,
id_endereco	int not null,

constraint 	FK_EMAIL_ESTABELECIMENTO
foreign key	(id_email)
references	tbl_email(id),

constraint 	FK_TELEFONE_ESTABELECIMENTO
foreign key	(id_telefone)
references	tbl_telefone(id),

constraint 	FK_ENDERECO_ESTABELECIMENTO
foreign key	(id_endereco)
references	tbl_endereco(id)
);

-- Tabela da Empresa Coletora - PRINCIPAL
create table tbl_empresa_coletora (
id 			int not null auto_increment primary key,
nome 		varchar(100) not null,
cnpj 		varchar(25) not null,
senha_hash 	varchar(512) not null,
id_email 	int not null,
id_telefone	int not null,
id_endereco	int not null,

constraint 	FK_EMAIL_EMPRESACOLETORA
foreign key	(id_email)
references	tbl_email(id),

constraint 	FK_TELEFONE_EMPRESACOLETORA
foreign key	(id_telefone)
references	tbl_telefone(id),

constraint 	FK_ENDERECO_EMPRESACOLETORA
foreign key	(id_endereco)
references	tbl_endereco(id)
);

-- Tabela de Distância - PRINCIPAL 
-- (Dados serão adicionados automaticamente através do cálculo da distância
--  entre o Estabelecimento e a Empresa Coletora)
create table tbl_distancia (
id 					int not null auto_increment primary key,
distancia 			decimal(8,2) not null,
data_calculo 		datetime not null default current_timestamp,
id_estabelecimento 	int not null,
id_empresa_coletora int not null,

constraint	FK_ESTABELECIMENTO_DISTANCIA
foreign key	(id_estabelecimento)
references	tbl_estabelecimento(id),

constraint	FK_EMPRESA_COLETORA_DISTANCIA
foreign key	(id_empresa_coletora)
references	tbl_empresa_coletora(id)
);

-- Tabela de Resíduo - PRINCIPAL
create table tbl_residuo (
id 					int not null auto_increment primary key,
horario_inicial 	time not null,
horario_final 		time not null,
quantidade 			decimal(6,2) not null,
data_disponivel 	date not null,
observacao 			text,
id_tipo_material 	int not null,
id_estabelecimento 	int not null,

constraint	FK_TIPOMATERIAL_RESIDUO
foreign key	(id_tipo_material)
references	tbl_tipo_material(id),

constraint	FK_ESTABELECIMENTO_RESIDUO
foreign key	(id_estabelecimento)
references	tbl_estabelecimento(id)
);

-- Tabela de Histórico do Status do Resíduo
create table tbl_status_residuo_historico (
id int not null auto_increment primary key,
id_residuo int not null,
id_status_residuo int not null,

constraint	FK_RESIDUO_STATUSRESIDUOHISTORICO
foreign key	(id_residuo)
references	tbl_residuo(id),

constraint	FK_STATUSRESIDUO_STATUSRESIDUOHISTORICO
foreign key	(id_status_residuo)
references	tbl_status_residuo(id)
);

-- Tabela de Oferta Inicial - SEMIPRINCIPAL
-- (Tabela em que a empresa coletora dará uma oferta para o resíduo, 
--  data_hora_oferta deve ser automaticamente no click do enviar oferta)
create table tbl_oferta_inicial (
id 					int not null auto_increment primary key,
valor_ofertado 		decimal(8,2) not null,
nome_ofertante 		varchar(100) not null,
data_hora_oferta 	datetime not null default current_timestamp,
id_empresa_coletora int not null,
id_residuo 			int not null,

constraint	FK_EMPRESACOLETORA_OFERTAINICIAL
foreign key	(id_empresa_coletora)
references	tbl_empresa_coletora(id),

constraint	FK_RESIDUO_OFERTAINICIAL
foreign key	(id_residuo)
references	tbl_residuo(id)
);

-- Tabela de Histórico do Status da Oferta
create table tbl_status_oferta_historico (
id 					int not null auto_increment primary key,
id_oferta_inicial 	int not null,
id_status_oferta 	int not null,

constraint	FK_OFERTAINICIAL_STATUSOFERTAHISTORICO
foreign key	(id_oferta_inicial)
references	tbl_oferta_inicial(id),

constraint	FK_STATUSOFERTA_STATUSOFERTAHISTORICO
foreign key	(id_status_oferta)
references	tbl_status_oferta(id)
);

-- Tabela de Oferta Aceita - SEMIPRINCIPAL
-- (Tabela em que o estabelecimento visualizará a oferta e vai aceitar ou não, 
--  data_hora_aceita deve ser automaticamente no click do aceitar)
create table tbl_oferta_aceita (
id 					int not null auto_increment primary key,
nome_aceitante 		varchar(100) not null,
data_hora_aceita 	datetime not null default current_timestamp,
id_estabelecimento 	int not null,

constraint	FK_ESTABELECIMENTO_OFERTAACEITA
foreign key	(id_estabelecimento)
references	tbl_estabelecimento(id)
);

-- Tabela de Oferta Final - PRINCIPAL que depende das 2 tabelas de oferta SEMIPRINCIPAL
create table tbl_oferta_final (
id 					int not null auto_increment primary key,
id_oferta_inicial 	int not null,
id_oferta_aceita 	int not null,

constraint	FK_OFERTAINICIAL_OFERTAFINAL
foreign key	(id_oferta_inicial)
references	tbl_oferta_inicial(id),

constraint	FK_OFERTAACEITA_OFERTAFINAL
foreign key	(id_oferta_aceita)
references	tbl_oferta_aceita(id)
);

-- Tabela de Coleta - PRINCIPAL
-- A coleta é criada após a criação da oferta final.
-- Os dados da realização da coleta são preenchidos
-- depois pela empresa coletora.
create table tbl_coleta (
id 				int not null auto_increment primary key,
nome_coletor 	varchar(100),
placa_veiculo 	varchar(12),
data_coleta 	date,
hora_coleta 	time,
id_oferta_final int not null,

constraint	FK_OFERTAFINAL_COLETA
foreign key	(id_oferta_final)
references	tbl_oferta_final(id)
);

-- Tabela de Histórico do Status da Coleta
create table tbl_status_coleta_historico (
id 					int not null auto_increment primary key,
id_coleta 			int not null,
id_status_coleta 	int not null,

constraint	FK_COLETA_STATUSCOLETAHISTORICO
foreign key	(id_coleta)
references	tbl_coleta(id),

constraint	FK_STATUSCOLETA_STATUSCOLETAHISTORICO
foreign key	(id_status_coleta)
references	tbl_status_coleta(id)
);