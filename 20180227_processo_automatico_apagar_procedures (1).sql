--**************************************************************
--processo apagar procs
--**************************************************************

---------------------------------------------------------
--01) listagem
---------------------------------------------------------

EXEC MASTER.DBO.SPR_GERA_LISTA_PROC_BKP



ALTER PROCEDURE [dbo].[SPR_GERA_LISTA_PROC_BKP]
AS

IF OBJECT_ID('uol_work..tbl_lista_proc_apagar') IS NOT NULL
    DROP TABLE uol_work..tbl_lista_proc_apagar
    
create table uol_work..tbl_lista_proc_apagar
(
	banco varchar(100),
	nome varchar(500),
	tipo char(1),
	data_atualizacao datetime
)    
    
    
    
 exec sp_MSforeachdb 'use ?    

	insert into uol_work..tbl_lista_proc_apagar 
	SELECT 
		DB_NAME() as BANCO,
		NAME AS NOME,
		TYPE AS TIPO,
		GETDATE() AS DT_ATUALIZACAO
	FROM 
		SYS.OBJECTS
	WHERE
		TYPE =''P''
		AND NAME LIKE ''APAGAR_%'' '
		

---------------------------------------------------------
--02)loop
---------------------------------------------------------


exec master.dbo.SPR_GERA_TABELA_COD_PROC_BKP ?,? -- banco e procedure


ALTER PROCEDURE [dbo].[SPR_GERA_TABELA_COD_PROC_BKP]
(
@objeto VARCHAR(500), @banco VARCHAR(100)
)
AS

declare @sql varchar(max)

set @sql = 

'
use ' +@banco + '
  
 if OBJECT_ID(''uol_work..tbl_txt_objeto'') is not null
	drop table uol_work..tbl_txt_objeto
create table uol_work..tbl_txt_objeto( text varchar(max))


insert uol_work..tbl_txt_objeto
exec sp_helptext ' + @objeto


exec (@sql)


--extrai o codigo via data flow

--dropa a tabela 
"use "  + @[User::banco] + " drop procedure "+   @[User::procedure]		

---------------------------------------------------------
--03)guarda a listagem em um historico
---------------------------------------------------------

INSERT INTO UOL_HISTORICO..tbl_lista_proc_apagar
SELECT
*
FROM
uol_work..tbl_lista_proc_apagar