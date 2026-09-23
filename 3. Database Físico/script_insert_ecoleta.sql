##################### ARQUIVO RESPONSÁVEL PELOS INSERTs #####################

### UTILIZE PRIMEIRO O SCRIPT DE CREATE ###
use db_tcc_ecoleta;

-- ====== tabela de email ======
insert into tbl_email (email) values
('mercadoze@gmail.com'),
('coletoriateste@gmail.com'),
('coletoraxyz@gmail.com'),
('restaurantex@gmail.com');

-- ====== tabela de telefone ======
insert into tbl_telefone (numero) values
('11912340001'),
('11912340002'),
('11912340003'),
('11912340004');

-- ====== tabela de estado ======
insert into tbl_estado (sigla, nome_estado) values
('sp', 'São Paulo'),
('rj', 'Rio de Janeiro');

-- ====== tabela de cidade ======
insert into tbl_cidade (nome_cidade, id_estado) values
('Jandira', 1),
('Barueri', 1),
('Volta Redonda', 2);

-- ====== tabela de endereço ======
insert into tbl_endereco (cep, logradouro, numero, bairro, latitude, longitude, id_cidade) values
('01310-200', 'Avenida Paulista', '1578', 'Bela Vista', -23.561500, -46.656000, 1),
('05415-012', 'Rua Fradique Coutinho', '900', 'Pinheiros', -23.557800, -46.686500, 1),
('22041-001', 'Avenida Atlântica', '1702', 'Copacabana', -22.969100, -43.178800, 2),
('22640-100', 'Avenida das Américas', '4666', 'Barra da Tijuca', -23.002300, -43.341200, 2);

