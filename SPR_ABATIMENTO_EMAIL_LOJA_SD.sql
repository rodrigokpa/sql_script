
CREATE PROCEDURE [dbo].[SPR_ABATIMENTO_EMAIL_LOJA_SD]          
          
--=======================================================================          
/*          
 AUTOR: THULIO RAMALHO SANTOS          
 DATA: 08/05/2015          
          
 DESCRIÇÃO:          
 ESTA PROCEDURE É RESPONSAVEL POR MANDAR EMAIL QUANDO HOUVER UMA LOJA NÃO CADASTRADA NO RELATÓRIO          
          
*/          
--=======================================================================          
          
          
@EMAIL_TESTE AS VARCHAR(255) = NULL          
          
AS          
          
SET NOCOUNT ON           
          
EXECUTE UOL_WORK.DBO.DROPOBJETO '##TMP_ABATIMENTO_EMAIL_LOJA_SD'          
  /*  
SELECT DISTINCT A.LOJA_SD     
INTO ##TMP_ABATIMENTO_EMAIL_LOJA_SD          
FROM UOL_ASSINATURAS.DBO.TMP_ABATIMENTO_INICIAL A    
 LEFT JOIN UOL_ASSINATURAS..AUX_ABATIMENTO_CANAIS B    
  ON A.LOJA_SD = B.LOJA_SD     
WHERE B.LOJA_SD IS NULL       
    */  
  --=================  
    
SELECT DISTINCT A.CANAL_VENDA, A.LOJA_SD,A.COD_LOJA    
INTO ##TMP_ABATIMENTO_EMAIL_LOJA_SD          
FROM UOL_ASSINATURAS.DBO.TMP_ABATIMENTO_INICIAL A    
 LEFT JOIN UOL_ASSINATURAS..AUX_ABATIMENTO_CANAIS B    
  ON A.COD_LOJA = B.COD_LOJA_SD  
WHERE B.NOME_LOJA_SD IS NULL  
 AND A.LOJA_SD <> 'NÃO ATRIBUÍDO'    
    
  --=================  
      
          
IF (SELECT COUNT(*) FROM ##TMP_ABATIMENTO_EMAIL_LOJA_SD) = 0          
BEGIN           
          
 SELECT 0 AS ERRO_LOJA_SD          
           
END          
ELSE           
BEGIN          
           
 DECLARE @SQL NVARCHAR(MAX);                
   DECLARE @Body NVARCHAR(800);                
   DECLARE @Body_HTML NVARCHAR(MAX);                
   DECLARE @TABLE TABLE (COLUNA XML);                  
   DECLARE @RESULT VARCHAR(4000), @COLUNAS_HTML NVARCHAR(2000), @CAMPO VARCHAR(100);                
   DECLARE @ARQUIVO_ENTRADA VARCHAR(100)          
   DECLARE @Destinatario NVARCHAR(MAX);          
             
   SET @Destinatario = 'trsantos@marketdata.com.br;rpsouza@marketdata.com.br';              
          
 SET @Body =           
  '<P>Prezados,</P>          
  <P>As seguintes LOJAS estão sem DE/PARA para classificação no relatório.</P>          
  <P>Por favor providenciar esta classificação.</P>';            
   
       
 SET @SQL ='SELECT TD = LOJA_SD, '' ''            
     FROM (SELECT LOJA_SD            
       FROM ##TMP_ABATIMENTO_EMAIL_LOJA_SD) TB                
     FOR XML PATH(''TR''), TYPE'  ;          
          
             
   INSERT INTO @TABLE EXEC(@SQL)          
   SELECT @RESULT = CAST(COLUNA AS NVARCHAR(MAX)) FROM @TABLE          
             
   SET @COLUNAS_HTML = '<TH>LOJA_SD</TH>'           
             
   SET @Body_HTML = '<HTML><HEAD>                
  <STYLE TYPE="text/css">                
  <!--                
  TD{font-family: Verdana; font-size: 10pt;}                
  TH{font-family: Verdana; font-size: 10pt;}                
  TR{font-family: Verdana; font-size: 10pt;}                
  P{font-family: Verdana; font-size: 10pt;}                
  --->                
  </STYLE>                
  </HEAD><BODY>                
  ' + @Body + '                
  <table border="1" cellpadding="1" cellspacing="1">                
  <tr style="background: blue;color: white;">' + @COLUNAS_HTML + '</tr>'                 
  + @RESULT + '                 
  </table>                
  <br>E-mail automático.<br><p>Atenciosamente,<br>Equipe l-mkt-im-dbm</p>              
  </BODY></HTML>'                   
             
 DECLARE  @vs_mail_para VARCHAR(1000)             
 SET @vs_mail_para = @Destinatario          
             
   EXECUTE msdb.dbo.sp_send_dbmail              
    @recipients  = @vs_mail_para              
    ,@body = @Body_HTML              
    ,@body_format = 'HTML'              
    ,@subject  = 'Ação recorrente semanal: Alerta Relatório Abatimento - NOVA LOJA_SD'              
    ,@profile_name = 'smtp.uolcorp.intranet'              
                 
 SELECT 1 AS ERRO_LOJA_SD          
            
              
END 
GO


