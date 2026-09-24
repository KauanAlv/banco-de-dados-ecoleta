##################### ARQUIVO RESPONSÁVEL PELOS INSERTs #####################

### UTILIZE PRIMEIRO O SCRIPT DE CREATE ###
use db_tcc_ecoleta;

-- ====== tabela de email ======
insert into tbl_email (email) values
('padariaitapevi@gmail.com'),
('autopecas@gmail.com'),
('comercioevariedade@gmail.com'),
('papelariasagrado@gmail.com'),
('coletoriateste@gmail.com'),
('coletoraxyz@gmail.com');

-- ====== tabela de telefone ======
insert into tbl_telefone (numero) values
('11912340001'),
('11912340002'),
('11912340003'),
('11912340004'),
('11912340005'),
('11912340006');

-- ====== tabela de estado ======
insert into tbl_estado (sigla, nome_estado) values
('sp', 'São Paulo'),
('rj', 'Rio de Janeiro');

-- ====== tabela de cidade ======
insert into tbl_cidade (nome_cidade, id_estado) values
('Barueri', 1),
('Itapevi', 1),
('Jandira', 1);

-- ====== tabela de endereço ======
insert into tbl_endereco (cep, logradouro, numero, bairro, latitude, longitude, id_cidade) values
('06401-000', 'Avenida Henriqueta Mendes Guerra', '100', 'Centro', -23.5115, -46.8763, 1),
('06454-000', 'Alameda Rio Negro', '500', 'Alphaville', -23.5002, -46.8521, 1),

('06653-000', 'Rua Luiz Manfrinato', '200', 'Centro', -23.5481, -46.9332, 2),
('06655-010', 'Avenida Presidente Vargas', '350', 'Vila Nova Itapevi', -23.5450, -46.9250, 2),

('06600-005', 'Rua Imirim', '50', 'Centro', -23.5302, -46.9031, 3),
('06612-010', 'Avenida Conceição Sammartino', '150', 'Sagrado Coração', -23.5280, -46.9100, 3);

-- ====== tabela de Status da Oferta ======
insert into tbl_status_oferta (status) values
('Pendente'),
('Aceita'),
('Recusada');

-- ====== tabela de Status da Coleta ======
insert into tbl_status_coleta (status) values 
('Agendada'),
('Concluída');

-- ====== tabela de Status do Resíduo ======
insert into tbl_status_residuo (status) values 
('Disponível'),
('Agendado'),
('Cancelado');

-- ====== tabela do Tipo do Material ======
insert into tbl_tipo_material (material) values
('Papel'),
('Plástico'),
('Papelão'),
('Metal'),
('Vidro');

-- ====== tabela do Estabelecimento - PRINCIPAL ======
insert into tbl_estabelecimento (nome, cnpj, senha_hash, id_email, id_telefone, id_endereco) values
('Padaria Central de Itapevi', '34.567.890/0001-03', '$2a$10$Z9xN7m1p4r5s6t7u8v9w0x1y2z3a4b5c6d7e8f9g0h1i2j3k4l5m', 1, 1, 3),
('Auto Peças Vila Nova', '45.678.901/0001-04', '$2a$10$A1bO8n2q5s6t7u8v9w0x1y2z3a4b5c6d7e8f9g0h1i2j3k4l5m6n', 2, 2, 4),

('Comércio e Variedades Jandira', '56.789.012/0001-05', '$2a$10$B2cP9o3r6t7u8v9w0x1y2z3a4b5c6d7e8f9g0h1i2j3k4l5m6n7o', 3, 3, 5),
('Papelaria Sagrado Coração', '67.890.123/0001-06', '$2a$10$C3dQ0p4s7u8v9w0x1y2z3a4b5c6d7e8f9g0h1i2j3k4l5m6n7o8p', 4, 4, 6);

-- ====== tabela da Empresa Coletora - PRINCIPAL ======
insert into tbl_empresa_coletora (nome, cnpj, senha_hash, id_email, id_telefone, id_endereco) values
('Coletoria Teste Logística', '11.111.111/0001-11', '$2a$10$D4eR1q5t8u9v0w1x2y3z4a5b6c7d8e9f0g1h2i3j4k5l6m7n8o9p0q', 5, 5, 1),
('Coletora XYZ Transportes', '22.222.222/0001-22', '$2a$10$E5fS2r6u9v0w1x2y3z4a5b6c7d8e9f0g1h2i3j4k5l6m7n8o9p0q1r', 6, 6, 2);

-- ====== tabela do Estabelecimento - PRINCIPAL ======
insert into tbl_distancia (distancia, id_estabelecimento, id_empresa_coletora) values
(12.2, 1, 1),
(9.5, 2, 1),
(5.7, 3, 2),
(4, 4, 2);

-- ====== tabela de Resíduo - PRINCIPAL ======
insert into tbl_residuo (horario_inicial, horario_final, quantidade, data_disponivel, observacao, id_tipo_material, id_estabelecimento) values
('08:00:00', '12:00:00', 5, '2026-06-10', 'Plástico limpo e empacotado', 2, 1),
('14:00:00', '18:00:00', 20, '2026-06-11', 'Sucata mista de metal', 4, 2);

insert into tbl_residuo (horario_inicial, horario_final, quantidade, data_disponivel, id_tipo_material, id_estabelecimento) values
('10:00:00', '13:00:00', 10, '2026-06-12', 5, 3),
('12:00:00', '16:00:00', 3, '2026-06-13', 1, 4),
('06:00:00', '18:00:00', 25, '2026-06-14', 3, 4),
('09:00:00', '15:00:00', 11, '2026-06-15', 3, 4);

-- ====== tabela intermediaria Histórico do Status do Resíduo ======
insert into tbl_status_residuo_historico (id_residuo, id_status_residuo) values
(1, 1),
(2, 2),
(3, 1),
(4, 2),
(5, 3),
(6, 1);

-- ====== tabela de Oferta Inicial - SEMIPRINCIPAL ======
insert into tbl_oferta_inicial (valor_ofertado, nome_ofertante, id_empresa_coletora, id_residuo) values
(12.00, 'Caio José', 1, 1),
(50.00, 'Pedro Matheus', 1, 2),
(20.00, 'Gustavo Miguel', 1, 3),
(4.00, 'Breno Machado', 2, 4),
(2.00, 'Fabio Mendes', 2, 6);

-- ====== tabela intermediaria Histórico do Status da Oferta ======
insert into tbl_status_oferta_historico (id_oferta_inicial, id_status_oferta) values
(1, 1),
(2, 2),
(3, 1),
(4, 2),
(5, 3);

-- ====== tabela de Oferta Aceita - SEMIPRINCIPAL ======
insert into tbl_oferta_aceita (nome_aceitante, id_estabelecimento) values
('José da Silva', 1),
('João Pereira', 2);

-- ====== tabela de Oferta Final - PRINCIPAL que depende das 2 tabelas de oferta SEMIPRINCIPAL ======
insert into tbl_oferta_final (id_oferta_inicial, id_oferta_aceita) values
(2, 1),
(4, 2);

-- ====== tabela de Coleta - PRINCIPAL ======
insert into tbl_coleta (id_oferta_final) values
(1),
(2);

-- ====== tabela intermediaria Histórico do Status da Coleta ======
insert into tbl_status_coleta_historico (id_coleta, id_status_coleta) values
(1, 1),
(2, 2);