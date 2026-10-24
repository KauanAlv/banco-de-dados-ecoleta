##################### ARQUIVO RESPONSÁVEL PELAS PROCEDURES #####################

### UTILIZE PRIMEIRO O SCRIPT DE CREATE ###
use db_tcc_ecoleta;

-- -----------------------------------------------------
-- ---                 AUXILIARES                 ------
-- -----------------------------------------------------

-- ====== TABELA DE EMAIL ======
DELIMITER $$
create procedure procEmail(
    IN operacao varchar(30),
    IN email_param varchar(256),
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_email (
            email
        ) values (
            email_param
        );
        select last_insert_id() as id;
        
    elseif operacao = 'UPDATE' then
        update tbl_email
        set email = email_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select * from tbl_email order by id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select * from tbl_email where id = id_param;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procEmail.';
    end if;
END $$
DELIMITER ;

-- ====== TABELA DE TELEFONE ======
DELIMITER $$
create procedure procTelefone(
    IN operacao varchar(30),
    IN numero_param varchar(25),
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_telefone (
            numero
        ) values (
            numero_param
        );
        select last_insert_id() as id;
        
    elseif operacao = 'UPDATE' then
        update tbl_telefone
        set numero = numero_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select * from tbl_telefone order by id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select * from tbl_telefone where id = id_param;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procTelefone.';
    end if;
END $$
DELIMITER ;

-- ====== TABELA DE ESTADO ======
DELIMITER $$
create procedure procEstado(
    IN operacao varchar(30),
    IN sigla_param varchar(3),
    IN nome_estado_param varchar(30),
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_estado (
            sigla,
            nome_estado
        ) values (
            sigla_param,
            nome_estado_param
        );
        select last_insert_id() as id;
        
    elseif operacao = 'UPDATE' then
        update tbl_estado
		set 
			sigla = sigla_param,
			nome_estado = nome_estado_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select * from tbl_estado order by id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select * from tbl_estado where id = id_param;
        
	elseif operacao = 'SELECT_BY_SIGLA' then
		select id
		from tbl_estado
		where sigla = sigla_param;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procEstado.';
    end if;
END $$
DELIMITER ;

-- ====== TABELA DE CIDADE ======
DELIMITER $$
create procedure procCidade(
	IN operacao varchar(30),
    IN nome_cidade_param varchar(60),
    IN id_estado_param int,
    IN id_param int
)
BEGIN
	 if operacao = 'INSERT' then
        insert into tbl_cidade (
            nome_cidade,
            id_estado
        ) values (
            nome_cidade_param,
            id_estado_param
        );
        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_cidade
        set
            nome_cidade = nome_cidade_param,
            id_estado = id_estado_param
        where id = id_param;

        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
			tbl_cidade.id as id_cidade, tbl_cidade.nome_cidade,
			tbl_estado.id as id_estado, tbl_estado.sigla, tbl_estado.nome_estado
        from tbl_cidade
        left join tbl_estado
			on tbl_estado.id = tbl_cidade.id_estado
        order by tbl_cidade.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
			tbl_cidade.id as id_cidade, tbl_cidade.nome_cidade,
			tbl_estado.id as id_estado, tbl_estado.sigla, tbl_estado.nome_estado
        from tbl_cidade
        left join tbl_estado
			on tbl_estado.id = tbl_cidade.id_estado
		where tbl_cidade.id = id_param;

    elseif operacao = 'SELECT_BY_NOME_ESTADO' then
        select tbl_cidade.id
        from tbl_cidade
        where tbl_cidade.nome_cidade = nome_cidade_param
        and tbl_cidade.id_estado = id_estado_param;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procCidade.';
    end if;
END $$
DELIMITER ;

-- ====== TABELA DE ENDEREÇO ======
DELIMITER $$
create procedure procEndereco(
	IN operacao varchar(30),
    IN cep_param varchar(12),
    IN logradouro_param varchar(100),
    IN numero_param int,
    IN bairro_param varchar(80),
    IN latitude_param decimal(10,7),
    IN longitude_param decimal(10,7),
    IN id_cidade_param int,
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
        insert into tbl_endereco (
            cep,
            logradouro,
            numero,
            bairro,
            latitude,
            longitude,
            id_cidade
        ) values (
            cep_param,
            logradouro_param,
            numero_param,
            bairro_param,
            latitude_param,
            longitude_param,
            id_cidade_param
        );
        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_endereco
        set
            cep = cep_param,
            logradouro = logradouro_param,
            numero = numero_param,
            bairro = bairro_param,
            latitude = latitude_param,
            longitude = longitude_param,
            id_cidade = id_cidade_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_endereco.id as id_endereco, tbl_endereco.cep, tbl_endereco.logradouro, tbl_endereco.numero, tbl_endereco.bairro, tbl_endereco.latitude,  tbl_endereco.longitude,
            tbl_cidade.id as id_cidade, tbl_cidade.nome_cidade,
            tbl_estado.id as id_estado, tbl_estado.sigla, tbl_estado.nome_estado
        from tbl_endereco
        left join tbl_cidade
            on tbl_cidade.id = tbl_endereco.id_cidade
        left join tbl_estado
            on tbl_estado.id = tbl_cidade.id_estado
        order by tbl_endereco.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_endereco.id as id_endereco, tbl_endereco.cep, tbl_endereco.logradouro, tbl_endereco.numero, tbl_endereco.bairro, tbl_endereco.latitude,  tbl_endereco.longitude,
            tbl_cidade.id as id_cidade, tbl_cidade.nome_cidade,
            tbl_estado.id as id_estado, tbl_estado.sigla, tbl_estado.nome_estado
        from tbl_endereco
        left join tbl_cidade
            on tbl_cidade.id = tbl_endereco.id_cidade
        left join tbl_estado
            on tbl_estado.id = tbl_cidade.id_estado
        where tbl_endereco.id = id_param;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procEndereco.';
    end if;
END $$
DELIMITER ;

-- ====== TABELA DE DISTÂNCIA ======
DELIMITER $$
create procedure procDistancia(
    IN operacao varchar(30),
    IN distancia_param decimal(8,2),
    IN id_estabelecimento_param int,
    IN id_empresa_coletora_param int,
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
		insert into tbl_distancia (
			distancia,
			id_estabelecimento,
			id_empresa_coletora
		) values (
			distancia_param,
			id_estabelecimento_param,
			id_empresa_coletora_param
		)
		on duplicate key update
			distancia = distancia_param,
			data_calculo = current_timestamp;

		select id
		from tbl_distancia
		where id_estabelecimento = id_estabelecimento_param
		  and id_empresa_coletora = id_empresa_coletora_param;

    elseif operacao = 'UPDATE' then
		update tbl_distancia
		set
			distancia = distancia_param,
			data_calculo = current_timestamp,
			id_estabelecimento = id_estabelecimento_param,
			id_empresa_coletora = id_empresa_coletora_param
		where id = id_param;
		select row_count() as affectedRows;
    
    elseif operacao = 'SELECT_ALL' then
        select
            tbl_distancia.id as id_distancia, tbl_distancia.distancia, tbl_distancia.data_calculo,
            tbl_distancia.id_estabelecimento,
            tbl_estabelecimento.nome as nome_estabelecimento,
            tbl_distancia.id_empresa_coletora,
            tbl_empresa_coletora.nome as nome_empresa_coletora
        from tbl_distancia

        left join tbl_estabelecimento
            on tbl_estabelecimento.id = tbl_distancia.id_estabelecimento
        left join tbl_empresa_coletora
            on tbl_empresa_coletora.id = tbl_distancia.id_empresa_coletora
        order by tbl_distancia.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_distancia.id as id_distancia, tbl_distancia.distancia, tbl_distancia.data_calculo,
            tbl_distancia.id_estabelecimento,
            tbl_estabelecimento.nome as nome_estabelecimento,
            tbl_distancia.id_empresa_coletora,
            tbl_empresa_coletora.nome as nome_empresa_coletora
        from tbl_distancia

        left join tbl_estabelecimento
            on tbl_estabelecimento.id = tbl_distancia.id_estabelecimento
        left join tbl_empresa_coletora
            on tbl_empresa_coletora.id = tbl_distancia.id_empresa_coletora
        where tbl_distancia.id = id_param;

    elseif operacao = 'SELECT_BY_ESTABELECIMENTO' then
        select
            tbl_distancia.id as id_distancia, tbl_distancia.distancia, tbl_distancia.data_calculo,
            tbl_distancia.id_empresa_coletora,
            tbl_empresa_coletora.nome as nome_empresa_coletora
        from tbl_distancia

        left join tbl_empresa_coletora
            on tbl_empresa_coletora.id = tbl_distancia.id_empresa_coletora
        where tbl_distancia.id_estabelecimento = id_estabelecimento_param
        order by tbl_distancia.distancia asc;

    elseif operacao = 'SELECT_BY_EMPRESA_COLETORA' then
        select
            tbl_distancia.id as id_distancia, tbl_distancia.distancia, tbl_distancia.data_calculo,
            tbl_distancia.id_estabelecimento,
            tbl_estabelecimento.nome as nome_estabelecimento
        from tbl_distancia

        left join tbl_estabelecimento
            on tbl_estabelecimento.id = tbl_distancia.id_estabelecimento
        where tbl_distancia.id_empresa_coletora = id_empresa_coletora_param
        order by tbl_distancia.distancia asc;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procDistancia.';
    end if;      
END $$
DELIMITER ;


-- -----------------------------------------------------
-- ---              ESTABELECIMENTO               ------
-- -----------------------------------------------------

-- ====== TABELA DO ESTABELECIMENTO ======
DELIMITER $$
create procedure procEstabelecimento(
    IN operacao varchar(30),
    IN nome_param varchar(100),
    IN cnpj_param varchar(25),
    IN senha_hash_param varchar(512),
    IN id_email_param int,
    IN id_telefone_param int,
    IN id_endereco_param int,
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
        insert into tbl_estabelecimento (
            nome,
            cnpj,
            senha_hash,
            id_email,
            id_telefone,
            id_endereco
        ) values (
            nome_param,
            cnpj_param,
            senha_hash_param,
            id_email_param,
            id_telefone_param,
            id_endereco_param
        );
        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_estabelecimento
        set
            nome = nome_param,
            cnpj = cnpj_param,
            senha_hash = senha_hash_param,
            id_email = id_email_param,
            id_telefone = id_telefone_param,
            id_endereco = id_endereco_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_estabelecimento.id as id_estabelecimento, tbl_estabelecimento.nome, tbl_estabelecimento.cnpj,
            tbl_email.id as id_email, tbl_email.email,
            tbl_telefone.id as id_telefone, tbl_telefone.numero as numero_telefone,
            tbl_endereco.id as id_endereco, tbl_endereco.cep, tbl_endereco.logradouro,
            tbl_endereco.numero as numero_endereco, tbl_endereco.bairro,
            tbl_endereco.latitude, tbl_endereco.longitude,
            tbl_cidade.id as id_cidade, tbl_cidade.nome_cidade,
            tbl_estado.id as id_estado, tbl_estado.sigla, tbl_estado.nome_estado
        from tbl_estabelecimento

        left join tbl_email
            on tbl_email.id = tbl_estabelecimento.id_email
        left join tbl_telefone
            on tbl_telefone.id = tbl_estabelecimento.id_telefone
        left join tbl_endereco
            on tbl_endereco.id = tbl_estabelecimento.id_endereco
        left join tbl_cidade
            on tbl_cidade.id = tbl_endereco.id_cidade
        left join tbl_estado
            on tbl_estado.id = tbl_cidade.id_estado
        order by tbl_estabelecimento.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_estabelecimento.id as id_estabelecimento, tbl_estabelecimento.nome, tbl_estabelecimento.cnpj,
            tbl_email.id as id_email, tbl_email.email,
            tbl_telefone.id as id_telefone, tbl_telefone.numero as numero_telefone,
            tbl_endereco.id as id_endereco, tbl_endereco.cep, tbl_endereco.logradouro,
            tbl_endereco.numero as numero_endereco, tbl_endereco.bairro,
            tbl_endereco.latitude, tbl_endereco.longitude,
            tbl_cidade.id as id_cidade, tbl_cidade.nome_cidade,
            tbl_estado.id as id_estado, tbl_estado.sigla, tbl_estado.nome_estado
        from tbl_estabelecimento

        left join tbl_email
            on tbl_email.id = tbl_estabelecimento.id_email
        left join tbl_telefone
            on tbl_telefone.id = tbl_estabelecimento.id_telefone
        left join tbl_endereco
            on tbl_endereco.id = tbl_estabelecimento.id_endereco
        left join tbl_cidade
            on tbl_cidade.id = tbl_endereco.id_cidade
        left join tbl_estado
            on tbl_estado.id = tbl_cidade.id_estado
        where tbl_estabelecimento.id = id_param;

    elseif operacao = 'SELECT_BY_CNPJ' then
        select
            tbl_estabelecimento.id as id_estabelecimento,
            tbl_estabelecimento.nome,
            tbl_estabelecimento.cnpj,
            tbl_estabelecimento.senha_hash
        from tbl_estabelecimento
        where tbl_estabelecimento.cnpj = cnpj_param;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procEstabelecimento.';
    end if;
END $$
DELIMITER ;



-- -----------------------------------------------------
-- ---              EMPRESA COLETORA              ------
-- -----------------------------------------------------

-- ====== TABELA DA EMPRESA COLETORA ======
DELIMITER $$
create procedure procEmpresaColetora(
    IN operacao varchar(30),
    IN nome_param varchar(100),
    IN cnpj_param varchar(25),
    IN senha_hash_param varchar(512),
    IN id_email_param int,
    IN id_telefone_param int,
    IN id_endereco_param int,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_empresa_coletora (
            nome,
            cnpj,
            senha_hash,
            id_email,
            id_telefone,
            id_endereco
        ) values (
            nome_param,
            cnpj_param,
            senha_hash_param,
            id_email_param,
            id_telefone_param,
            id_endereco_param
        );
        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_empresa_coletora
        set
            nome = nome_param,
            cnpj = cnpj_param,
            senha_hash = senha_hash_param,
            id_email = id_email_param,
            id_telefone = id_telefone_param,
            id_endereco = id_endereco_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_empresa_coletora.id as id_empresa_coletora, tbl_empresa_coletora.nome, tbl_empresa_coletora.cnpj,
            tbl_email.id as id_email, tbl_email.email,
            tbl_telefone.id as id_telefone, tbl_telefone.numero as numero_telefone,
            tbl_endereco.id as id_endereco, tbl_endereco.cep, tbl_endereco.logradouro,
            tbl_endereco.numero as numero_endereco, tbl_endereco.bairro,
            tbl_endereco.latitude, tbl_endereco.longitude,
            tbl_cidade.id as id_cidade, tbl_cidade.nome_cidade,
            tbl_estado.id as id_estado, tbl_estado.sigla, tbl_estado.nome_estado
        from tbl_empresa_coletora

        left join tbl_email
            on tbl_email.id = tbl_empresa_coletora.id_email
        left join tbl_telefone
            on tbl_telefone.id = tbl_empresa_coletora.id_telefone
        left join tbl_endereco
            on tbl_endereco.id = tbl_empresa_coletora.id_endereco
        left join tbl_cidade
            on tbl_cidade.id = tbl_endereco.id_cidade
        left join tbl_estado
            on tbl_estado.id = tbl_cidade.id_estado
        order by tbl_empresa_coletora.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_empresa_coletora.id as id_empresa_coletora, tbl_empresa_coletora.nome, tbl_empresa_coletora.cnpj,
            tbl_email.id as id_email, tbl_email.email,
            tbl_telefone.id as id_telefone, tbl_telefone.numero as numero_telefone,
            tbl_endereco.id as id_endereco, tbl_endereco.cep, tbl_endereco.logradouro, tbl_endereco.numero as numero_endereco, tbl_endereco.bairro, tbl_endereco.latitude, tbl_endereco.longitude,
            tbl_cidade.id as id_cidade, tbl_cidade.nome_cidade,
            tbl_estado.id as id_estado, tbl_estado.sigla, tbl_estado.nome_estado
        from tbl_empresa_coletora
        left join tbl_email
            on tbl_email.id = tbl_empresa_coletora.id_email
        left join tbl_telefone
            on tbl_telefone.id = tbl_empresa_coletora.id_telefone
        left join tbl_endereco
            on tbl_endereco.id = tbl_empresa_coletora.id_endereco
        left join tbl_cidade
            on tbl_cidade.id = tbl_endereco.id_cidade
        left join tbl_estado
            on tbl_estado.id = tbl_cidade.id_estado
        where tbl_empresa_coletora.id = id_param;
        
	elseif operacao = 'SELECT_BY_CNPJ' then
		select
			tbl_empresa_coletora.id as id_empresa_coletora, tbl_empresa_coletora.nome, tbl_empresa_coletora.cnpj, tbl_empresa_coletora.senha_hash
		from tbl_empresa_coletora
        where tbl_empresa_coletora.cnpj = cnpj_param;
    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procEmpresaColetora.';
    end if;
END $$
DELIMITER ;

-- ====== TABELA DO STATUS DA OFERTA ======
DELIMITER $$
create procedure procStatusOferta(
    in operacao varchar(30),
    in status_param varchar(30),
    in id_param int
)
BEGIN
	if operacao = 'INSERT' then
        insert into tbl_status_oferta (
            status
        ) values (
            status_param
        );
        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_status_oferta
        set
            status = status_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select * from tbl_status_oferta order by id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select * from tbl_status_oferta where id = id_param;
        
	elseif operacao = 'DELETE' then
		delete from tbl_status_oferta where id = id_param;
		select row_count() as affectedRows;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procStatusOferta.';
    end if;
END $$
DELIMITER ;