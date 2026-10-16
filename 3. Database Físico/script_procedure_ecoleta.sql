##################### ARQUIVO RESPONSÁVEL PELAS PROCEDURES #####################

### UTILIZE PRIMEIRO O SCRIPT DE CREATE ###
use db_tcc_ecoleta;

-- ====== TABELA DE EMAIL ======
delimiter $$

create procedure procEmail(
    in operacao varchar(20),
    in id_param int,
    in email_param varchar(256)
)
begin
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
end $$

delimiter ;