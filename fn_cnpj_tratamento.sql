
create function [dbo].[fn_cnpj_tratamento] (
@cnpj varchar(20)
)

/****************************************************************
Fun��o de tratamento CNPJ
retira tra�os, ascentos e pontua��o

****************************************************************/

returns varchar(14)
as
begin
declare @cnpj_tratado varchar(14)

set @cnpj_tratado =
right(replicate('0',14)+ rtrim(ltrim(replace(replace(replace(replace(replace(replace(@cnpj,',',''),'.',''),'-',''),'/',''),'\',''),' ',''))),14)
return @cnpj_tratado
end
GO


