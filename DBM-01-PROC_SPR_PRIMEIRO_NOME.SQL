SP_HELPTEXT SPR_DBM_PRIMEIRO_NOME

  
  
CREATE PROCEDURE SPR_DBM_PRIMEIRO_NOME  
--PARAMETROS  
(  
 @NOME_TABELA VARCHAR(250),  
 @NOME_CAMPO VARCHAR(250)  
)  
  
/***************************************************************************************  
 PROCEDURE CRIA E MARCA O CAMPO PRIMEIRO NOME.  
 VERIFICA NA NOME COMPOSTOS SE O NOME EXISTE, SE SIM MARCA O NOME COMPOSTO,  
 SE N�O, UTILIZA APENAS O PRIMEIRO NOME DO CAMPO PAASSADO COMO PARAMETRO.  
  
 ---------------------------------------------------------------------------  
 DATA CRIA��O: 23/12/2011   ANALISTAS: RODRIGO EDUARDO E  FABIO BATTESTIN  
 ---------------------------------------------------------------------------  
  
 PARAMETROS: DOIS - O NOME DA TABELA UTILIZADA E O CAMPO ONDE ESTA O NOME.  
 ORDEM : 1� TABELA (varchar), 2�CAMPO COM O NOME (varchar)  
  
 SA�DA: CRIA O CAMPO X_DBM_PRIM_NOME ONDE TEMOS O PRIMEIRO NOME A SER UTILIZADO NO MAILING  
   ESSE CAMPO TEM A SA�DA VARCHAR EM CAIXA ALTA (UPPER CASE)  
   
***************************************************************************************/  
  
AS  
BEGIN  
  SET NOCOUNT ON  
  -- VARIAVEL:RECEBERA A STRING SQL (COMANDO)  
  BEGIN  
   DECLARE @STR_SQL VARCHAR(MAX)  
  END  
  
  --VERIFICA SE O CAMPO JA EXISTE NA TABELA SE SIM EXCLUI  
  --CRIANDO A STRING   
  -- OBS: CHAR(39) = ' - ASPAS SIMPLES - STRING SQL  
  BEGIN  
   SET @STR_SQL = 'IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '+CHAR(39)+ @NOME_TABELA + CHAR(39)+ ' AND COLUMN_NAME ='+ CHAR(39)+ 'X_DBM_PRIM_NOME'+ CHAR(39) +')'  
   SET @STR_SQL = @STR_SQL+ ' ALTER TABLE '+@NOME_TABELA+' DROP COLUMN X_DBM_PRIM_NOME'  
  END  
  
  -- EXECUTA O COMANDO  
  BEGIN  
   EXEC (@STR_SQL)  
  END  
    
  -- CRIAMOS O CAMPO X_DBM_PRIM_NOME QUE RECEBER� O RESULTADO DA PROCEDURE  
  BEGIN  
   SET @STR_SQL = '  ALTER TABLE '+@NOME_TABELA+ ' ADD X_DBM_PRIM_NOME VARCHAR (250)  '  
  END  
  
  --EXECUTA A CRIA��O DO CAMPO (ALTER TABLE...)  
  BEGIN  
   EXEC (@STR_SQL)  
  END  
  
  
  -- UPDATE DO CAMPO - LEFT JOIN COM A TABELA NOME COMPOSTOS  
   -- CASO O NOME SEJA O MESMO DA TABELA NOME COMPOSTOS ENT�O MARCAMOS O NOME DA NOMECOMPOSTOS  
   -- CASO CONTRARIO UTILIZAMOS APENAS O PRIMEIRO NOME DO CAMPO DE ORIGEM  
  
  BEGIN  
   SET @STR_SQL = '  UPDATE CD SET  X_DBM_PRIM_NOME = UPPER(CASE  WHEN E.NOME IS NULL AND PATINDEX('+CHAR(39)+'% %'+CHAR(39)+',CD.'+@NOME_CAMPO+') > 0 THEN LEFT (CD.'+@NOME_CAMPO+',PATINDEX('+CHAR(39)+'% %'+CHAR(39)+',CD.'+@NOME_CAMPO+')-1) '         
   SET @STR_SQL = @STR_SQL+' WHEN E.NOME IS NULL AND PATINDEX('+CHAR(39)+'% %'+CHAR(39)+',CD.'+@NOME_CAMPO+') = 0 THEN CD.'+@NOME_CAMPO+' ELSE E.NOME END)'   
   SET @STR_SQL = @STR_SQL+' FROM '+@NOME_TABELA+ ' CD LEFT JOIN NOMESCOMPOSTO E ON LEFT(UPPER(CD.'+@NOME_CAMPO+'),LEN(E.NOME)) = E.NOME '     
   SET @STR_SQL = @STR_SQL+' AND ( SUBSTRING(CD.'+@NOME_CAMPO+',LEN(E.NOME)+1,1) = '+CHAR(39)+' '+CHAR(39)+ ' OR LEN(CD.'+@NOME_CAMPO+') = LEN(E.NOME) ) '  
  END  
  
  
  -- EXECUTA A ATUALIZA��O DO CAMPO  
  BEGIN  
   EXEC (@STR_SQL)  
  END  
    
  SET NOCOUNT OFF  
  
END  
  
  
--SPR_DBM_PRIMEIRO_NOME 'XXX_TESTE_NOME','NOME'  