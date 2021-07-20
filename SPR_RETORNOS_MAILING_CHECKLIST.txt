CREATE PROCEDURE  SPR_RETORNOS_MAILING_CHECKLIST  
AS  
  
--RODRIGO EDUARDO  
-- 13/09/2012  
  
  
----------------------------------------------------------------------------------------------  
--DECLARA VARIAVEIS A SER UTILIZADAS - OBTER O VALOR DOS CAMPOS  
----------------------------------------------------------------------------------------------  
DECLARE   
  @string   varchar(max)  
 ,@MESBASE   varchar(50)  
 ,@CODCAMPANHA  varchar(50)  
 ,@QTD_ENVIADA  varchar(50)  
 ,@OBT_MESBASE  VARCHAR(50)  
 ,@vs_mail_para  VARCHAR(1000)  
 ,@mesref   VARCHAR(15)  
 ,@ASSUNTO   VARCHAR(50)  
  
  
  
----------------------------------------------------------------------------------------------  
--MES BASE  
----------------------------------------------------------------------------------------------  
SET @OBT_MESBASE =  ( SELECT LEFT(convert(varchar,DATEADD(MONTH,-1,getdate()),111),7) )  
  
----------------------------------------------------------------------------------------------  
--MONTA A STRING EM HTML   
----------------------------------------------------------------------------------------------  
SET @string = ''  
SET @string = @string + 'Segue a lista dos mailings: <br><br>'  
----------------------------------------------------------------------------------------------  
--MONTA O CABEÇALHO DAS COLUNAS  
----------------------------------------------------------------------------------------------  
  
SET @string = @string + '<table  border="1" cellpadding="1" cellspacing="1" widht="600px;">'+CHAR(13)  
SET @string = @string + '<tr>'+CHAR(13)  
SET @string = @string + ' <td align="center" valign="middle" >Mes Base</td>'+CHAR(13)  
SET @string = @string + ' <td align="center" valign="middle" >Codigo Mailing</td>'+CHAR(13)  
SET @string = @string + ' <td align="center" valign="middle" >QTDE Enviada</td>'+CHAR(13)  
  
SET @string = @string + '</tr>'+CHAR(13)  
----------------------------------------------------------------------------------------------  
--DECLARA O CURSOR - UTILIZA A CONSULTA QUE QUER ENVIAR  
----------------------------------------------------------------------------------------------  
  
  
DECLARE cr CURSOR FOR  
SELECT  
 MESBASE,  
 CODCAMPANHA,  
 CAST(QTD_ENVIADA as varchar(50)) QTD_ENVIADA  
FROM  
VW_CB_PROSPECT_CAMP_TELEMARKET  
WHERE  
 QTD_RETORNADA = 0  
 AND MESBASE = @OBT_MESBASE  
 
  
OPEN cr   
  
----------------------------------------------------------------------------------------------  
-- INICIA A ATRIBUIÇÃO DAS VARIAVEIS FORA DO LOOP - PRIMEIRA LINHA   
----------------------------------------------------------------------------------------------  
FETCH NEXT FROM cr INTO  
 @MESBASE,  
 @CODCAMPANHA,  
 @QTD_ENVIADA  
  
  
----------------------------------------------------------------------------------------------  
--INICIA LOOP PARA PERCORRER O CURSOR  
----------------------------------------------------------------------------------------------  
  
WHILE (@@FETCH_STATUS = 0)  
BEGIN  
  
 SET @string = @string + '<tr>'  
 SET @string = @string + ' <td align="center" valign="middle" >'+@MESBASE+'</td>'  
 SET @string = @string + ' <td align="center" valign="middle" >'+@CODCAMPANHA+'</td>'  
 SET @string = @string + ' <td align="center" valign="middle" >'+@QTD_ENVIADA+'</td>'  
 SET @string = @string + '</tr>'  
  
----------------------------------------------------------------------------------------------  
--VAI PARA A PROXIMA LINHA DO CURSOR (DENTRO DO LOOP)  
----------------------------------------------------------------------------------------------  
FETCH NEXT FROM cr INTO  
 @MESBASE,  
 @CODCAMPANHA,  
 @QTD_ENVIADA  
  
  
----------------------------------------------------------------------------------------------  
--FIM DO LOOP  
----------------------------------------------------------------------------------------------  
END  
  
----------------------------------------------------------------------------------------------  
--QUANDO SAI DO LOOP FECHA O CURSOR E DESALOCA MEMÓRIA  
----------------------------------------------------------------------------------------------  
CLOSE cr  
DEALLOCATE cr  
  
----------------------------------------------------------------------------------------------  
--FECHA A STRING  
----------------------------------------------------------------------------------------------  
SET @string = @string + '</table>'  
  
SET @string = @string + '<br><p>Atenciosamente;</p><p>Equipe MarketData.</p><font size ="2"> * E-mail automático</font>  '  
  
  
  
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  
  
  
--*****************************************************************************************************  
----------------------------------------------------------------------------------------------  
--LISTA DE EMAIL   
----------------------------------------------------------------------------------------------  
--*****************************************************************************************************  
--  declare @vs_mail_para  VARCHAR(1000)  
--INICIALIZANDO A LISTA DE EMAIL  
 SET @vs_mail_para = ''  
  
--lista geral  
 SELECT   
 @vs_mail_para = @vs_mail_para + EMAIL + ';'  
 FROM   
 uol_assinaturas..AUX_LISTA_ENVIAR_EMAIL_NOVA   
 WHERE fl_ativo = 'S'  
    and TPO_EMAIL ='TO'  
  -- and id = 6  -- TESTES 
	AND NM_GRUPO IN ('UOL','MARKETDATA')  

--e-mail Angelo
select @vs_mail_para = @vs_mail_para +'anrocha@uolinc.com;fribeiro@uolinc.com;'
  
----------------------------------------------------------------------------------------------  
--mes por "extenso"  
----------------------------------------------------------------------------------------------  
  
SET LANGUAGE 'Português'  
  
SET @mesref =(   SELECT DATENAME(MONTH, GETDATE() )   )  
  
SET @ASSUNTO = 'Checklist Retornos Mailing - Devolutivas '+ @mesref  
  
----------------------------------------------------------------------------------------------  
-- ENVIA EMAIL PASSANDO A STRING CRIADA COMO CORPO DO EMAIL  
----------------------------------------------------------------------------------------------  
EXEC msdb.dbo.sp_send_dbmail  
  --@file_attachments = 'F:\MarketData\DOCS\Não Vendas\Documentação Procedure_Não Vendas.doc'--ANEXO  
   @recipients        = @vs_mail_para --decomente para teste  
  ,@body    = @string --'ssss' --corpo  
  ,@body_format  = 'HTML' --TIPO DO E-MAIL  
  ,@subject   = @ASSUNTO --'teste' --ASSUNTO  
  ,@profile_name  = 'smtp.uolcorp.intranet' --NÃO MEXER  
   
  
  
  
  
  
  
  



