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

-- ====== PROCEDURE PARA A TELA DE ESTABELECIMENTOS ======
DELIMITER $$
create procedure procTelaEstabelecimentosEmpresaColetora(
    IN operacao varchar(30),
    IN id_empresa_coletora_param int,
    IN id_tipo_material_param int
)
BEGIN
	if operacao = 'SELECT_ALL' then
        select
            vw_estabelecimentos_empresa_coletora.*,
            tbl_distancia.distancia
        from vw_estabelecimentos_empresa_coletora
        left join tbl_distancia
            on tbl_distancia.id_estabelecimento = vw_estabelecimentos_empresa_coletora.id_estabelecimento
            and tbl_distancia.id_empresa_coletora = id_empresa_coletora_param
        order by
            tbl_distancia.distancia is null asc,
            tbl_distancia.distancia asc,
            vw_estabelecimentos_empresa_coletora.id_estabelecimento,
            vw_estabelecimentos_empresa_coletora.id_residuo;

    elseif operacao = 'SELECT_BY_MATERIAL' then
        select
            vw_estabelecimentos_empresa_coletora.*,
            tbl_distancia.distancia
        from vw_estabelecimentos_empresa_coletora
        left join tbl_distancia
            on tbl_distancia.id_estabelecimento = vw_estabelecimentos_empresa_coletora.id_estabelecimento
            and tbl_distancia.id_empresa_coletora = id_empresa_coletora_param
        where exists (
        select 1
        from vw_estabelecimentos_empresa_coletora as filtro
        where filtro.id_estabelecimento = vw_estabelecimentos_empresa_coletora.id_estabelecimento
        and filtro.id_tipo_material = id_tipo_material_param
        )
        order by
            tbl_distancia.distancia is null asc,
			tbl_distancia.distancia asc,
            vw_estabelecimentos_empresa_coletora.id_estabelecimento,
            vw_estabelecimentos_empresa_coletora.id_residuo;

    else
        signal sqlstate '45000'
        set message_text =
            'Operação inválida na procTelaEstabelecimentosEmpresaColetora.';
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

-- ====== TABELA DA OFERTA INICIAL ======
DELIMITER $$
create procedure procOfertaInicial(
    IN operacao varchar(30),
    IN valor_ofertado_param decimal(8,2),
    IN nome_ofertante_param varchar(100),
    IN id_empresa_coletora_param int,
    IN id_residuo_param int,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_oferta_inicial (
            valor_ofertado,
            nome_ofertante,
            id_empresa_coletora,
            id_residuo
        ) values (
            valor_ofertado_param,
            nome_ofertante_param,
            id_empresa_coletora_param,
            id_residuo_param
        );
        select last_insert_id() as id;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_oferta_inicial.id as id_oferta_inicial, tbl_oferta_inicial.valor_ofertado, tbl_oferta_inicial.nome_ofertante, tbl_oferta_inicial.data_hora_oferta,
            tbl_empresa_coletora.id as id_empresa_coletora, tbl_empresa_coletora.nome as nome_empresa_coletora,
            tbl_residuo.id as id_residuo,
            tbl_status_oferta.id as id_status_oferta, tbl_status_oferta.status as status_oferta,
            tbl_status_oferta_historico.data_hora_status
        from tbl_oferta_inicial
        left join tbl_empresa_coletora
            on tbl_empresa_coletora.id = tbl_oferta_inicial.id_empresa_coletora
        left join tbl_residuo
            on tbl_residuo.id = tbl_oferta_inicial.id_residuo
        left join tbl_status_oferta_historico
            on tbl_status_oferta_historico.id = (
                select max(historico.id)
                from tbl_status_oferta_historico as historico
                where historico.id_oferta_inicial = tbl_oferta_inicial.id
            )
        left join tbl_status_oferta
            on tbl_status_oferta.id = tbl_status_oferta_historico.id_status_oferta
        order by tbl_oferta_inicial.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_oferta_inicial.id as id_oferta_inicial, tbl_oferta_inicial.valor_ofertado, tbl_oferta_inicial.nome_ofertante, tbl_oferta_inicial.data_hora_oferta,
            tbl_empresa_coletora.id as id_empresa_coletora, tbl_empresa_coletora.nome as nome_empresa_coletora,
            tbl_residuo.id as id_residuo,
            tbl_status_oferta.id as id_status_oferta, tbl_status_oferta.status as status_oferta,
            tbl_status_oferta_historico.data_hora_status
        from tbl_oferta_inicial
        left join tbl_empresa_coletora
            on tbl_empresa_coletora.id = tbl_oferta_inicial.id_empresa_coletora
        left join tbl_residuo
            on tbl_residuo.id = tbl_oferta_inicial.id_residuo
        left join tbl_status_oferta_historico
            on tbl_status_oferta_historico.id = (
                select max(historico.id)
                from tbl_status_oferta_historico as historico
                where historico.id_oferta_inicial = tbl_oferta_inicial.id
            )
        left join tbl_status_oferta
            on tbl_status_oferta.id = tbl_status_oferta_historico.id_status_oferta
        where tbl_oferta_inicial.id = id_param;

    elseif operacao = 'SELECT_PENDING' then
        -- Verifica se a empresa coletora já possui uma oferta pendente para o mesmo resíduo
        select
            tbl_oferta_inicial.id as id_oferta_inicial
        from tbl_oferta_inicial
        inner join tbl_status_oferta_historico
            on tbl_status_oferta_historico.id = (
                select max(historico.id)
                from tbl_status_oferta_historico as historico
                where historico.id_oferta_inicial = tbl_oferta_inicial.id
            )
        inner join tbl_status_oferta
            on tbl_status_oferta.id = tbl_status_oferta_historico.id_status_oferta
        where tbl_oferta_inicial.id_empresa_coletora = id_empresa_coletora_param
          and tbl_oferta_inicial.id_residuo = id_residuo_param
          and tbl_status_oferta.status = 'Pendente'
        limit 1;

    elseif operacao = 'SELECT_RESIDUO_FOR_UPDATE' then
        -- Consulta o resíduo e bloqueia sua linha durante a transação para evitar ofertas simultâneas da mesma coletora
        select
            tbl_residuo.id as id_residuo,
            (
                select tbl_status_residuo.status
                from tbl_status_residuo_historico
                inner join tbl_status_residuo
                    on tbl_status_residuo.id =
                       tbl_status_residuo_historico.id_status_residuo
                where tbl_status_residuo_historico.id_residuo =
                      tbl_residuo.id
                order by tbl_status_residuo_historico.id desc
                limit 1
            ) as status_residuo
        from tbl_residuo
        where tbl_residuo.id = id_residuo_param
        for update;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procOfertaInicial.';
    end if;
END $$
DELIMITER ;

-- ====== TABELA DO HISTÓRICO DO STATUS DA OFERTA ======
DELIMITER $$
create procedure procStatusOfertaHistorico(
    IN operacao varchar(30),
    IN id_oferta_inicial_param int,
    IN id_status_oferta_param int,
    IN id_param int
)
BEGIN
    declare id_status_pendente int default null;

    if operacao = 'INSERT_PENDENTE' then
        -- Passa o id que tem o status pendente para ser o id_status_pendente
        select id into id_status_pendente 
        from tbl_status_oferta
        where status = 'Pendente'
        limit 1;

        -- Verifica se o status Pendente existe
        if id_status_pendente is null then
            signal sqlstate '45000'
            set message_text = 'Status Pendente não encontrado.';
        end if;

        -- Insere o primeiro status da oferta
        insert into tbl_status_oferta_historico (
            id_oferta_inicial,
            id_status_oferta
        ) values (
            id_oferta_inicial_param,
            id_status_pendente
        );
        select last_insert_id() as id;

    elseif operacao = 'INSERT' then
        -- Insere uma nova alteração no histórico da oferta
        insert into tbl_status_oferta_historico (
            id_oferta_inicial,
            id_status_oferta
        ) values (
            id_oferta_inicial_param,
            id_status_oferta_param
        );
        select last_insert_id() as id;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_status_oferta_historico.id as id_historico, tbl_status_oferta_historico.id_oferta_inicial,
            tbl_status_oferta.id as id_status_oferta, tbl_status_oferta.status as status_oferta,
            tbl_status_oferta_historico.data_hora_status
        from tbl_status_oferta_historico
        inner join tbl_status_oferta
            on tbl_status_oferta.id = tbl_status_oferta_historico.id_status_oferta
        order by tbl_status_oferta_historico.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_status_oferta_historico.id as id_historico, tbl_status_oferta_historico.id_oferta_inicial,
            tbl_status_oferta.id as id_status_oferta, tbl_status_oferta.status as status_oferta,
            tbl_status_oferta_historico.data_hora_status
        from tbl_status_oferta_historico
        inner join tbl_status_oferta
            on tbl_status_oferta.id = tbl_status_oferta_historico.id_status_oferta
        where tbl_status_oferta_historico.id = id_param;

    elseif operacao = 'SELECT_BY_OFERTA' then
        select
            tbl_status_oferta_historico.id as id_historico, tbl_status_oferta_historico.id_oferta_inicial,
            tbl_status_oferta.id as id_status_oferta, tbl_status_oferta.status as status_oferta,
            tbl_status_oferta_historico.data_hora_status
        from tbl_status_oferta_historico
        inner join tbl_status_oferta
            on tbl_status_oferta.id = tbl_status_oferta_historico.id_status_oferta
        where tbl_status_oferta_historico.id_oferta_inicial = id_oferta_inicial_param
        order by tbl_status_oferta_historico.id desc;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procStatusOfertaHistorico.';
    end if;
END $$
DELIMITER ;