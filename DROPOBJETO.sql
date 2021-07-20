

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE DROPOBJETO  

@OBJETO varchar(100),   

@TIPO varchar(2) = 'U',   

@ESPACO VARCHAR(100) = ''  

AS

BEGIN  

DECLARE 

 @TASK			VARCHAR(300)

,@QUERY			VARCHAR(300)

,@ERRO			INT  

,@TEMPORARIA	VARCHAR(100)  



SET @TASK = ''  



SET @TEMPORARIA = ''  

  

IF @TIPO <> 'U' AND @TIPO <> 'P' AND @TIPO <> 'V' AND @TIPO <> 'FN' AND @TIPO <> 'TR' AND @TIPO <> 'IF' AND @TIPO <> 'TF'  

BEGIN  

	PRINT 'ERROR: OBJETO NAO SUPORTADO'  

END  

ELSE  

BEGIN  

	IF (LEFT(@OBJETO,2) = '##'  OR LEFT(@OBJETO,1) = '#' )

	BEGIN  

		SET @TEMPORARIA = 'TEMPDB..'+ @OBJETO  



		IF OBJECT_ID(@TEMPORARIA) IS NOT NULL  

		BEGIN  

			SET @TASK = @TASK + 'DROP TABLE ' + @OBJETO  

			EXEC(@TASK)  

		END  

	END  

	ELSE  

	BEGIN  

		IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE [ID] = OBJECT_ID(@OBJETO) AND type = (@TIPO))  

		BEGIN  

			SELECT @TASK = @TASK + CASE  WHEN @TIPO = 'U' THEN 'DROP TABLE '  

				   WHEN @TIPO = 'P' THEN 'DROP PROCEDURE '  

				   WHEN @TIPO = 'V' THEN 'DROP VIEW '  

				   WHEN @TIPO = 'FN' or @TIPO = '' or @TIPO = 'IF' or @TIPO = 'TF' THEN 'DROP FUNCTION '  

				   WHEN @TIPO = 'TR' THEN 'DROP TRIGGER ' END  



			SELECT @TASK = @TASK + @OBJETO  

			EXEC(@TASK)  



			SET @ERRO = @@ERROR  



			IF (@ERRO <> 0)  

			BEGIN  

				IF (@ERRO <> 547)  

				BEGIN  

					SET @QUERY = @ESPACO + 'Viola‡ao de CONSTRAINT'  

					PRINT @QUERY  

				END  

				ELSE  

				BEGIN  

					SET @QUERY = @ESPACO + 'Ocorreu o Erro ' + CAST(@ERRO AS VARCHAR(10))  

					PRINT @QUERY  

				END  

			END  

			ELSE  

			BEGIN  

				SET @QUERY = @ESPACO + @OBJETO + ' exclu¡do com sucesso'  

				PRINT @QUERY  

			END  

		END  

		ELSE  

		BEGIN  

			SET @QUERY = @ESPACO + 'ERROR: Objeto Nao Existe'  

		PRINT(@QUERY)  

		END  

	END

END



END



