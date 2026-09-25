##################### ARQUIVO RESPONSÁVEL PELOS SELECTs #####################

### UTILIZE PRIMEIRO O SCRIPT DE CREATE ###
use db_tcc_ecoleta;

##################### Select para o Perfil do Estabelecimento #####################
create view vw_perfil_estabelecimento as
select
	tbl_estabelecimento.id as id_estabelecimento, tbl_estabelecimento.nome as nome_empresa, tbl_estabelecimento.cnpj, tbl_estabelecimento.senha_hash,
    tbl_email.id as id_email, tbl_email.email,
    tbl_telefone.id as id_telefone, tbl_telefone.numero as telefone,
    tbl_endereco.id as id_endereco, tbl_endereco.cep, tbl_endereco.logradouro, tbl_endereco.numero, tbl_endereco.bairro,
    tbl_estado.id as id_estado, tbl_estado.sigla,
	tbl_cidade.id as id_cidade, tbl_cidade.nome_cidade
    
from tbl_estabelecimento
	inner join tbl_email
		on tbl_email.id = tbl_estabelecimento.id_email
	inner join tbl_telefone
		on tbl_telefone.id = tbl_estabelecimento.id_telefone
	inner join tbl_endereco
		on tbl_endereco.id = tbl_estabelecimento.id_endereco
	inner join tbl_cidade
		on tbl_cidade.id = tbl_endereco.id_cidade
	inner join tbl_estado
		on tbl_estado.id = tbl_cidade.id_estado
where tbl_estabelecimento.id = 1;

-- ====== nome da view ======
select * from vw_perfil_estabelecimento;

##################### Select para o Perfil da Empresa Coletora #####################
create view vw_perfil_empresa_coletora as
select
	tbl_empresa_coletora.id as id_coletor, tbl_empresa_coletora.nome as nome_empresa, tbl_empresa_coletora.cnpj, tbl_empresa_coletora.senha_hash,
    tbl_email.id as id_email, tbl_email.email,
    tbl_telefone.id as id_telefone, tbl_telefone.numero as telefone,
    tbl_endereco.id as id_endereco, tbl_endereco.cep, tbl_endereco.logradouro, tbl_endereco.numero, tbl_endereco.bairro,
    tbl_estado.id as id_estado, tbl_estado.sigla,
	tbl_cidade.id as id_cidade, tbl_cidade.nome_cidade
    
from tbl_empresa_coletora
	inner join tbl_email
		on tbl_email.id = tbl_empresa_coletora.id_email
	inner join tbl_telefone
		on tbl_telefone.id = tbl_empresa_coletora.id_telefone
	inner join tbl_endereco
		on tbl_endereco.id = tbl_empresa_coletora.id_endereco
	inner join tbl_cidade
		on tbl_cidade.id = tbl_endereco.id_cidade
	inner join tbl_estado
		on tbl_estado.id = tbl_cidade.id_estado
where tbl_empresa_coletora.id = 2;

-- ====== nome da view ======
select * from vw_perfil_empresa_coletora;

##################### Select para a tela home #####################
select * from tbl_residuo;
select * from tbl_status_residuo;

select 
	(
		select
			count(distinct tbl_status_residuo_historico.id_residuo)
		from tbl_status_residuo_historico
			inner join tbl_status_residuo
				on tbl_status_residuo.id = tbl_status_residuo_historico.id_status_residuo
		where tbl_status_residuo.status = "Disponível"
    ) as residuos_disponiveis,
    (
		select
			coalesce(sum(tbl_residuo.quantidade), 0) -- Se não tiver dados na tabela, o resultado fica 0
		from tbl_residuo
			inner join tbl_status_residuo_historico
				on tbl_residuo.id = tbl_status_residuo_historico.id_residuo
			inner join tbl_status_residuo
				on tbl_status_residuo.id = tbl_status_residuo_historico.id_status_residuo
	) as soma_total_quantidade,
    (
		select count(*) from tbl_oferta_inicial
    ) as ofertas_recebidas,
    (
		select
			count(distinct tbl_coleta.id)
		from tbl_coleta
			inner join tbl_status_coleta_historico
				on tbl_coleta.id = tbl_status_coleta_historico.id_coleta
			inner join tbl_status_coleta
				on tbl_status_coleta.id = tbl_status_coleta_historico.id_status_coleta
		where tbl_status_coleta.status = "Agendada"
    ) as coletas_agendadas;
    




### FALTA TERMINAR ###
#create view vw_home_estabelecimento as
select
    tbl_estabelecimento.id as id_estabelecimento,
    (
        ## Conta os resíduos que o último status é Disponível
        select 
			count(*) 
		from tbl_residuo
        inner join (
            ## Pega o último histórico de cada resíduo
            select
                tbl_status_residuo_historico.id_residuo,
                tbl_status_residuo_historico.id_status_residuo
                
            from tbl_status_residuo_historico
            where tbl_status_residuo_historico.id in (
                ## Pega o maior ID de cada grupo de resíduo (id_residuo e id_status_residuo)
                select
                    max(tbl_status_residuo_historico.id)
                from tbl_status_residuo_historico
                ## Separa os históricos por resíduo
                group by tbl_status_residuo_historico.id_residuo
            )
        ) as ultimo_status
            on ultimo_status.id_residuo = tbl_residuo.id
        inner join tbl_status_residuo
            on tbl_status_residuo.id = ultimo_status.id_status_residuo

        where tbl_status_residuo.status = 'Disponível'
            and tbl_residuo.id_estabelecimento = tbl_estabelecimento.id

    ) as residuos_disponiveis,

    (
        -- Soma a quantidade dos resíduos atualmente disponíveis
        select
            coalesce(sum(tbl_residuo.quantidade), 0)

        from tbl_residuo

        inner join (
            -- Pega o último status de cada resíduo
            select
                tbl_status_residuo_historico.id_residuo,
                tbl_status_residuo_historico.id_status_residuo

            from tbl_status_residuo_historico

            where tbl_status_residuo_historico.id in (
                select
                    max(tbl_status_residuo_historico.id)

                from tbl_status_residuo_historico

                group by tbl_status_residuo_historico.id_residuo
            )
        ) as ultimo_status
            on ultimo_status.id_residuo = tbl_residuo.id

        inner join tbl_status_residuo
            on tbl_status_residuo.id = ultimo_status.id_status_residuo

        where tbl_status_residuo.status = 'Disponível'
            and tbl_residuo.id_estabelecimento = tbl_estabelecimento.id

    ) as soma_total_quantidade,

    (
    -- Conta somente as ofertas que estão atualmente Pendentes
    select
        count(*)

    from tbl_oferta_inicial

    inner join tbl_residuo
        on tbl_residuo.id = tbl_oferta_inicial.id_residuo

    inner join (
        -- Pega o último status de cada oferta
        select
            tbl_status_oferta_historico.id_oferta_inicial,
            tbl_status_oferta_historico.id_status_oferta

        from tbl_status_oferta_historico

        where tbl_status_oferta_historico.id in (
            select
                max(tbl_status_oferta_historico.id)

            from tbl_status_oferta_historico

            group by tbl_status_oferta_historico.id_oferta_inicial
        )
    ) as ultimo_status
        on ultimo_status.id_oferta_inicial = tbl_oferta_inicial.id

    inner join tbl_status_oferta
        on tbl_status_oferta.id = ultimo_status.id_status_oferta

    where tbl_residuo.id_estabelecimento = tbl_estabelecimento.id
        and tbl_status_oferta.status = 'Pendente'

) as ofertas_recebidas,

    (
        -- Conta as coletas agendadas do estabelecimento
        select
            count(*)

        from tbl_coleta

        inner join (
            -- Pega o último status de cada coleta
            select
                tbl_status_coleta_historico.id_coleta,
                tbl_status_coleta_historico.id_status_coleta

            from tbl_status_coleta_historico

            where tbl_status_coleta_historico.id in (
                select
                    max(tbl_status_coleta_historico.id)

                from tbl_status_coleta_historico

                group by tbl_status_coleta_historico.id_coleta
            )
        ) as ultimo_status
            on ultimo_status.id_coleta = tbl_coleta.id

        inner join tbl_status_coleta
            on tbl_status_coleta.id = ultimo_status.id_status_coleta

        inner join tbl_oferta_final
            on tbl_oferta_final.id = tbl_coleta.id_oferta_final

        inner join tbl_oferta_inicial
            on tbl_oferta_inicial.id = tbl_oferta_final.id_oferta_inicial

        inner join tbl_residuo
            on tbl_residuo.id = tbl_oferta_inicial.id_residuo

        where tbl_status_coleta.status = 'Agendada'
            and tbl_residuo.id_estabelecimento = tbl_estabelecimento.id

    ) as coletas_agendadas

from tbl_estabelecimento
where tbl_estabelecimento.id = 4;




-- -------------------------- TESTE -------------------------------------------------
select 
	tbl_residuo.id as id_residuo, tbl_residuo.horario_inicial, tbl_residuo.horario_final, tbl_residuo.quantidade, tbl_residuo.data_disponivel, tbl_residuo.observacao,
	tbl_status_residuo.id as id_status, tbl_status_residuo.status
    
from tbl_residuo
	left join tbl_status_residuo_historico
		on tbl_residuo.id = tbl_status_residuo_historico.id_residuo
	left join tbl_status_residuo
		on tbl_status_residuo.id = tbl_status_residuo_historico.id_status_residuo

where tbl_status_residuo.status = "Disponível";