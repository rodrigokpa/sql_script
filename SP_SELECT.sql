CREATE PROCEDURE SP_SELECT 

(

@strTable varchar(8000) 

)

AS   

EXECUTE ('SELECT TOP 100 * FROM '+ @strTable )
