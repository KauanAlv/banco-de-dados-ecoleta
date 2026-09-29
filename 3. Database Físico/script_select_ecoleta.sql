##################### ARQUIVO RESPONSÁVEL PELOS SELECTs #####################

### UTILIZE PRIMEIRO O SCRIPT DE CREATE ###
use db_tcc_ecoleta;


-- -----------------------------------------------------
-- ---              ESTABELECIMENTO               ------
-- -----------------------------------------------------
##################### Select para o Perfil do Estabelecimento #####################
-- VIEW PARA O PERFIL ---
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
		on tbl_estado.id = tbl_cidade.id_estado;

-- ====== nome da view ======
select * from vw_perfil_estabelecimento where id_estabelecimento = 1;


##################### Select para a tela home do estabelecimento #####################
-- VIEW PARA O RESUMO DA HOME ---
create view vw_home_estabelecimento as
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
				## Pega o maior ID de cada grupo de resíduo (id_residuo e id_status_residuo) para mostrar o ultimo status
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
		## Soma a quantidade dos resíduos atualmente disponíveis
		select
			coalesce(sum(tbl_residuo.quantidade), 0)
		from tbl_residuo
        inner join (
            ## Pega o último status de cada resíduo
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
		## Conta somente as ofertas que estão atualmente Pendentes
		select
			count(*)
		from tbl_oferta_inicial
		inner join tbl_residuo
			on tbl_residuo.id = tbl_oferta_inicial.id_residuo
		inner join (
        ## Pega o último status de cada oferta
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
        ## Conta as coletas agendadas do estabelecimento
        select
			count(*)
        from tbl_coleta
        inner join (
            ## Pega o último status de cada coleta
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
    
from tbl_estabelecimento;

-- ====== nome da view ======
select * from vw_home_estabelecimento where id_estabelecimento = 1;

### Complemento da View de cima ###
create view vw_home_ofertas_estabelecimento as
select 
	tbl_residuo.id_estabelecimento as id_estabelecimento,
	tbl_empresa_coletora.id as id_empresa_coletora, tbl_empresa_coletora.nome as nome_empresa_coletora,
    tbl_tipo_material.id as id_tipo_material, tbl_tipo_material.material,
    tbl_residuo.id as id_residuo, tbl_residuo.quantidade, tbl_residuo.data_disponivel,
	tbl_oferta_inicial.id as id_oferta_inicial, tbl_oferta_inicial.valor_ofertado,
    tbl_status_oferta.status as status_oferta
    
from tbl_oferta_inicial
	inner join tbl_empresa_coletora
		on tbl_empresa_coletora.id = tbl_oferta_inicial.id_empresa_coletora
	inner join tbl_residuo
		on tbl_residuo.id = tbl_oferta_inicial.id_residuo
	inner join tbl_tipo_material
		on tbl_tipo_material.id = tbl_residuo.id_tipo_material
	inner join tbl_status_oferta_historico
		on tbl_oferta_inicial.id = tbl_status_oferta_historico.id_oferta_inicial
	inner join tbl_status_oferta
		on tbl_status_oferta.id = tbl_status_oferta_historico.id_status_oferta
        
where tbl_status_oferta_historico.id in (
    select
        max(tbl_status_oferta_historico.id)
    from tbl_status_oferta_historico
    group by tbl_status_oferta_historico.id_oferta_inicial
)

and tbl_status_oferta.status = 'Pendente';

-- ====== nome da view ======
select * from vw_home_ofertas_estabelecimento where id_estabelecimento = 1;

-- ====== para o resumo da tela home, utilizar as 2 views ======
select * from vw_home_estabelecimento where id_estabelecimento = 1;
select * from vw_home_ofertas_estabelecimento where id_estabelecimento = 1;


##################### Select para a tela meus resíduos do estabelecimento #####################
-- VIEW PARA OS RESIDUOS ---
create view vw_meus_residuos_estabelecimento as
select 
	tbl_residuo.id as id_residuo, 
    tbl_estabelecimento.id as id_estabelecimento,
    tbl_tipo_material.id as id_tipo_material, tbl_tipo_material.material,
	tbl_residuo.quantidade, tbl_residuo.data_disponivel, tbl_residuo.horario_inicial, tbl_residuo.horario_final, tbl_residuo.observacao,
	tbl_status_residuo.id as id_status_residuo, tbl_status_residuo.status as status_residuo
    
from tbl_residuo
	inner join tbl_tipo_material
		on tbl_tipo_material.id = tbl_residuo.id_tipo_material
	inner join tbl_status_residuo_historico
		on tbl_residuo.id = tbl_status_residuo_historico.id_residuo
	inner join tbl_status_residuo
		on tbl_status_residuo.id = tbl_status_residuo_historico.id_status_residuo
	inner join tbl_estabelecimento
		on tbl_estabelecimento.id = tbl_residuo.id_estabelecimento
        
where tbl_status_residuo_historico.id in (
	select max(tbl_status_residuo_historico.id)
    from tbl_status_residuo_historico
    group by tbl_status_residuo_historico.id_residuo
)
and tbl_status_residuo.status in ('Disponível', 'Agendado');

-- ====== nome da view ======
select * from vw_meus_residuos_estabelecimento where id_estabelecimento = 1;

### Complemento da View de cima ###
create view vw_coleta_residuo_estabelecimento as
select
    tbl_coleta.id as id_coleta,
    tbl_tipo_material.id as id_tipo_material, tbl_tipo_material.material,
    tbl_status_coleta.id as id_status_coleta, tbl_status_coleta.status as status_coleta,
    tbl_empresa_coletora.id as id_empresa_coletora, tbl_empresa_coletora.nome as nome_empresa_coletora,
    tbl_oferta_inicial.nome_ofertante as nome_ofertante,
    tbl_oferta_aceita.id as id_oferta_aceita, tbl_oferta_aceita.nome_aceitante as nome_aceitante,
    tbl_endereco.logradouro, tbl_endereco.numero, tbl_endereco.bairro, tbl_cidade.nome_cidade as cidade,
    tbl_residuo.quantidade, tbl_residuo.data_disponivel, tbl_residuo.horario_inicial, tbl_residuo.horario_final, tbl_residuo.observacao,
    tbl_oferta_inicial.id as id_oferta_inicial, tbl_oferta_inicial.valor_ofertado as valor_acordado,

    tbl_oferta_final.id as id_oferta_final,
    tbl_estabelecimento.id as id_estabelecimento,
    tbl_residuo.id as id_residuo
    
from tbl_coleta
	inner join tbl_oferta_final
		on tbl_oferta_final.id = tbl_coleta.id_oferta_final
	inner join tbl_oferta_inicial
		on tbl_oferta_inicial.id = tbl_oferta_final.id_oferta_inicial
	inner join tbl_oferta_aceita
		on tbl_oferta_aceita.id = tbl_oferta_final.id_oferta_aceita
    inner join tbl_empresa_coletora
		on tbl_empresa_coletora.id = tbl_oferta_inicial.id_empresa_coletora
	inner join tbl_residuo
		on tbl_residuo.id = tbl_oferta_inicial.id_residuo
	inner join tbl_tipo_material
		on tbl_tipo_material.id = tbl_residuo.id_tipo_material
	inner join tbl_estabelecimento
		on tbl_estabelecimento.id = tbl_residuo.id_estabelecimento
	inner join tbl_endereco
		on tbl_endereco.id = tbl_estabelecimento.id_endereco
	inner join tbl_cidade
		on tbl_cidade.id = tbl_endereco.id_cidade
	inner join tbl_status_coleta_historico
		on tbl_status_coleta_historico.id_coleta = tbl_coleta.id
	inner join tbl_status_coleta
		on tbl_status_coleta.id = tbl_status_coleta_historico.id_status_coleta
        
where tbl_status_coleta_historico.id in (
    select max(tbl_status_coleta_historico.id)
    from tbl_status_coleta_historico
    group by tbl_status_coleta_historico.id_coleta
)
and tbl_status_coleta.status in ('Agendada', 'Aguardando Finalização');

-- ====== nome da view ======
select * from vw_coleta_residuo_estabelecimento where id_estabelecimento = 2 and id_residuo = 2;
  
-- ====== para a tela de meus resíduos, utilizar as 2 views ======
select * from vw_meus_residuos_estabelecimento where id_estabelecimento = 1;
select * from vw_coleta_residuo_estabelecimento where id_estabelecimento = 2 and id_residuo = 2;

###########################################################################################
-- -----------------------------------------------------
-- ---              EMPRESA COLETORA              ------
-- -----------------------------------------------------
##################### Select para o Perfil da Empresa Coletora #####################
-- VIEW PARA O PERFIL ---
create view vw_perfil_empresa_coletora as
select
	tbl_empresa_coletora.id as id_empresa_coletora, tbl_empresa_coletora.nome as nome_empresa, tbl_empresa_coletora.cnpj, tbl_empresa_coletora.senha_hash,
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
		on tbl_estado.id = tbl_cidade.id_estado;

-- ====== nome da view ======
select * from vw_perfil_empresa_coletora where id_empresa_coletora = 1;


##################### Select para a tela home da empresa coletora #####################
-- VIEW PARA O RESUMO DA HOME ---
create view vw_home_empresa_coletora as
select
    tbl_empresa_coletora.id as id_empresa_coletora,
    	(
		## Soma a quantidade dos resíduos atualmente disponíveis
		select
			coalesce(sum(tbl_residuo.quantidade), 0)
		from tbl_residuo
        inner join (
            ## Pega o último status de cada resíduo
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

	) as soma_total_quantidade,
    
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
				## Pega o maior ID de cada grupo de resíduo (id_residuo e id_status_residuo) para mostrar o ultimo status
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

    ) as residuos_disponiveis,

    (
		## Conta somente as ofertas desta empresa que estão atualmente Pendentes
		select
			count(*)
		from tbl_oferta_inicial

		inner join (
        ## Pega o último status de cada oferta
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

	where tbl_oferta_inicial.id_empresa_coletora = tbl_empresa_coletora.id
		and tbl_status_oferta.status = 'Pendente'
) as ofertas_enviadas,

    (
        ## Conta as coletas agendadas da empresa coletora
        select
			count(*)
        from tbl_coleta
        inner join (
            ## Pega o último status de cada coleta
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
        and tbl_oferta_inicial.id_empresa_coletora = tbl_empresa_coletora.id
        
    ) as coletas_agendadas,
    
    (
        ## Conta as coletas concluídas da empresa coletora
        select
			count(*)
        from tbl_coleta
        inner join (
            ## Pega o último status de cada coleta
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

        where tbl_status_coleta.status = 'Concluída'
        and tbl_oferta_inicial.id_empresa_coletora = tbl_empresa_coletora.id
            
    ) as coletas_concluidas
    
from tbl_empresa_coletora;

-- ====== nome da view ======
select * from vw_home_empresa_coletora where id_empresa_coletora = 1;

### Complemento da View de cima ###
create view vw_home_ofertas_empresa_coletora as
select
    tbl_empresa_coletora.id as id_empresa_coletora,
    tbl_estabelecimento.id as id_estabelecimento, tbl_estabelecimento.nome as nome_estabelecimento,
    tbl_endereco.logradouro, tbl_endereco.numero, tbl_endereco.bairro,
    tbl_cidade.nome_cidade,
    tbl_tipo_material.id as id_tipo_material, tbl_tipo_material.material,
    tbl_residuo.id as id_residuo, tbl_residuo.quantidade, tbl_residuo.data_disponivel, tbl_residuo.horario_inicial, tbl_residuo.horario_final, tbl_residuo.observacao,
    tbl_oferta_inicial.id as id_oferta_inicial, tbl_oferta_inicial.valor_ofertado,
    tbl_status_oferta.status as status_oferta,
    tbl_oferta_final.id as id_oferta_final,
    tbl_coleta.id as id_coleta,
    tbl_status_coleta.status as status_coleta,
    tbl_oferta_inicial.valor_ofertado as valor_acordado
from tbl_oferta_inicial

inner join tbl_empresa_coletora
    on tbl_empresa_coletora.id = tbl_oferta_inicial.id_empresa_coletora
inner join tbl_residuo
    on tbl_residuo.id = tbl_oferta_inicial.id_residuo
inner join tbl_tipo_material
    on tbl_tipo_material.id = tbl_residuo.id_tipo_material
inner join tbl_estabelecimento
    on tbl_estabelecimento.id = tbl_residuo.id_estabelecimento
inner join tbl_endereco
    on tbl_endereco.id = tbl_estabelecimento.id_endereco
inner join tbl_cidade
    on tbl_cidade.id = tbl_endereco.id_cidade
inner join tbl_status_oferta_historico
    on tbl_status_oferta_historico.id_oferta_inicial = tbl_oferta_inicial.id
inner join tbl_status_oferta
    on tbl_status_oferta.id = tbl_status_oferta_historico.id_status_oferta
left join tbl_oferta_final
    on tbl_oferta_final.id_oferta_inicial = tbl_oferta_inicial.id
left join tbl_coleta
    on tbl_coleta.id_oferta_final = tbl_oferta_final.id

left join (
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
) as ultimo_status_coleta
    on ultimo_status_coleta.id_coleta = tbl_coleta.id
left join tbl_status_coleta
    on tbl_status_coleta.id = ultimo_status_coleta.id_status_coleta

where tbl_status_oferta_historico.id in (
    select max(tbl_status_oferta_historico.id)
    from tbl_status_oferta_historico
    group by tbl_status_oferta_historico.id_oferta_inicial
)
and (
    -- Oferta ainda aguardando decisão do estabelecimento
    tbl_status_oferta.status = 'Pendente'
    or
    -- Oferta aceita, mas somente enquanto a coleta estiver agendada
    (
        tbl_status_oferta.status = 'Aceita'
        and tbl_status_coleta.status = 'Agendada'
    )
);

-- ====== nome da view ======
select * from vw_home_ofertas_empresa_coletora where id_empresa_coletora = 1;

-- ====== para o resumo da tela home, utilizar as 2 views ======
select * from vw_home_empresa_coletora where id_empresa_coletora = 1;
select * from vw_home_ofertas_empresa_coletora where id_empresa_coletora = 1;



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
##################################
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
    
-- Mostra os residuos com o status
select
    tbl_residuo.id,
    tbl_residuo.quantidade,
    tbl_status_residuo.status

from tbl_residuo

inner join (
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
    on tbl_status_residuo.id = ultimo_status.id_status_residuo;
    
-- ve as coletas com o status
select
    tbl_coleta.id as id_coleta,
    tbl_status_coleta.status

from tbl_coleta

inner join (
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
    on tbl_status_coleta.id = ultimo_status.id_status_coleta;
    
-- final da home coletor
select 
	tbl_empresa_coletora.id as id_empresa_coletora,
	tbl_estabelecimento.id as id_estabelecimento, tbl_estabelecimento.nome as nome_estabelecimento,
    tbl_tipo_material.id as id_tipo_material, tbl_tipo_material.material,
    tbl_residuo.id as id_residuo, tbl_residuo.quantidade, tbl_residuo.data_disponivel,
	tbl_oferta_inicial.id as id_oferta_inicial, tbl_oferta_inicial.valor_ofertado,
    tbl_status_oferta.status as status_oferta,
    tbl_oferta_final.id as id_oferta_final
    
from tbl_oferta_inicial
	inner join tbl_empresa_coletora
		on tbl_empresa_coletora.id = tbl_oferta_inicial.id_empresa_coletora
	inner join tbl_residuo
		on tbl_residuo.id = tbl_oferta_inicial.id_residuo
	inner join tbl_tipo_material
		on tbl_tipo_material.id = tbl_residuo.id_tipo_material
	inner join tbl_status_oferta_historico
		on tbl_oferta_inicial.id = tbl_status_oferta_historico.id_oferta_inicial
	inner join tbl_status_oferta
		on tbl_status_oferta.id = tbl_status_oferta_historico.id_status_oferta
	inner join tbl_estabelecimento
		on tbl_estabelecimento.id = tbl_residuo.id_estabelecimento
        
where tbl_status_oferta_historico.id in (
    select
        max(tbl_status_oferta_historico.id)
    from tbl_status_oferta_historico
    group by tbl_status_oferta_historico.id_oferta_inicial
)

and tbl_status_oferta.status in ('Pendente', 'Aceita');

-- para consultar todas as views
SELECT TABLE_NAME 
FROM information_schema.VIEWS 
WHERE TABLE_SCHEMA = 'db_tcc_ecoleta';