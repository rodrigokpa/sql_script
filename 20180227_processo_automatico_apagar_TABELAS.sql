/********************************************************
	PROCESSO PARA GUARDAR O CODIGO DE TABELAS
********************************************************/


----------------------------------------------------------------------
--01) LISTAGEM
----------------------------------------------------------------------

exec master.dbo.SPR_GERA_LISTA_TABELA_BKP

ALTER procedure [dbo].[SPR_GERA_LISTA_TABELA_BKP]
as
/*

-- rodrigo - 19/10/2017
-- gera lista das tabelas com prefixo apagar em todos os bancos

*/




--lista as tabelas a serem apagadas

if OBJECT_ID('uol_work..tbl_lista_tbl_apagar') is not null
	drop table uol_work..tbl_lista_tbl_apagar

create table uol_work..tbl_lista_tbl_apagar
(
	tabela varchar(250),
	tipo char(1),
	dt_atualizacao datetime,
	banco varchar(150)

)

execute master.sys.sp_MSforeachdb ' use [?]
insert into uol_work..tbl_lista_tbl_apagar
SELECT 
	NAME AS NOME,
	TYPE AS TIPO,
	GETDATE() AS DT_ATUALIZACAO,
	DB_NAME() as BANCO
FROM 
	SYS.OBJECTS
WHERE
	TYPE IN (''U'')
	AND NAME LIKE''APAGAR_%'' '
	


select 
	tabela as tabela ,banco as banco
from 	
	uol_work..tbl_lista_tbl_apagar	
	
	
--diretorio_destino: \\a1-stivis1\Assinantes\Historico\Bancos
--banco: ?
--pasta_final: TABELAS - CREATE	

----------------------------------------------------------------------
-- 02) LOOP
----------------------------------------------------------------------


if OBJECT_ID('UOL_WORK..TBL_SQL_EXTRACAO') is not null
	drop table UOL_WORK..TBL_SQL_EXTRACAO

CREATE TABLE UOL_WORK..TBL_SQL_EXTRACAO
(
SQL_TXT VARCHAR(MAX)
)


INSERT INTO UOL_WORK..TBL_SQL_EXTRACAO exec .dbo.SPR_DBM_MONTA_CREATE_TABLE 


ALTER PROCEDURE [dbo].[SPR_DBM_MONTA_CREATE_TABLE] 
(
	 @TABELA VARCHAR(150)
)

/*
	RODRIGO EDUARDO - 09/04/2013

*/
AS

IF OBJECT_ID(@TABELA) IS NOT NULL
	BEGIN
		DECLARE @CAMPO VARCHAR(MAX)
		DECLARE @SQL VARCHAR(MAX)

		SET @CAMPO = ''

		SELECT
		--@CAMPO = +@CAMPO +CHAR(9)+ C.NAME +' '+ T.NAME + CASE WHEN T.NAME IN ('VARCHAR','NVARCHAR','CHAR','NCHAR') THEN '('+CAST(C.MAX_LENGTH AS VARCHAR)+')' ELSE '' END +','+ CHAR(10) 
		@CAMPO = 
		+@CAMPO +CHAR(9)+ C.NAME +' '+ T.NAME + 
		                                      CASE 
												WHEN T.NAME IN ('VARCHAR','CHAR') THEN '('+CAST(C.MAX_LENGTH AS VARCHAR)+')' 
												WHEN T.NAME IN ('NVARCHAR','NCHAR') THEN '('+CAST((C.MAX_LENGTH/2) AS VARCHAR)+')'
												WHEN T.NAME IN ('numeric') then '('+CAST(C.precision AS VARCHAR)+ ',' + CAST(C.scale AS VARCHAR)+')'													
												ELSE '' 
											   END +','+ CHAR(10) 		
		FROM
		SYS.COLUMNS C
		INNER JOIN SYS.TYPES T
		ON C.USER_TYPE_ID = T.USER_TYPE_ID
		WHERE
			C.OBJECT_ID = OBJECT_ID(@TABELA)
			
			
		

		SELECT @CAMPO = LEFT (@CAMPO,(LEN(@CAMPO) - 2))


		SELECT @SQL = 'CREATE TABLE '
		SELECT @SQL = @SQL + @TABELA 
		SELECT @SQL = @SQL + CHAR(9)+'( '+CHAR(10)
		SELECT @SQL = @SQL + @CAMPO
		SELECT @SQL = @SQL + CHAR(10)+CHAR(9) + ')'

		--PRINT @SQL
		
		SELECT @SQL AS TXT_SQL

	END
ELSE
	BEGIN
		PRINT ('TABELA NÃO EXISTE NO BANCO '+DB_NAME())
	END 

--EXEMPLO DE CHAMADA
--EXEC SPR_DBM_MONTA_CREATE_TABLE 'DBM_CAMPANHAS_PROSPECTS'


--EXTRAIR VIA DATAFLOW OU PROC


--DROPAR A TABELA
"use "  + @[User::banco] + " drop table "+   @[User::tabela]

----------------------------------------------------------------------
--03)GUARDAR LOG NO HISTORICO
----------------------------------------------------------------------

insert into uol_historico..tbl_lista_tbl_apagar
select
*
from
uol_work..tbl_lista_tbl_apagar


if OBJECT_ID('uol_work..tbl_lista_tbl_apagar') is not null
	drop table uol_work..tbl_lista_tbl_apagar