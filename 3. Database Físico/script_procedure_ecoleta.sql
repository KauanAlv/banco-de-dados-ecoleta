##################### ARQUIVO RESPONSÁVEL PELAS PROCEDURES #####################

### UTILIZE PRIMEIRO O SCRIPT DE CREATE ###
use db_tcc_ecoleta;

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
        select * from tbl_cidade order by id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select * from tbl_cidade where id = id_param;

    elseif operacao = 'SELECT_BY_NOME_ESTADO' then
        select id
        from tbl_cidade
        where nome_cidade = nome_cidade_param
        and id_estado = id_estado_param;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procCidade.';
    end if;
END $$
DELIMITER ;