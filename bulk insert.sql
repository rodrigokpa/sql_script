create table orcamento(
produto int null,
valor float null
)

delete from orcamento

declare @counta int
declare @valor float
set @counta = 1
set @valor = 5.2
while @counta <20 
begin
insert into orcamento(produto,valor)values(@counta,@valor);
set @counta = @counta+1
set @valor = @valor+2.2
end



USE [testdb]
GO
/****** Object:  Table [dbo].[orcamento]    Script Date: 07/08/2011 23:59:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orcamento2](
	[produto] [int] NULL,
	[valor] [decimal](15,5) NULL
) ON [PRIMARY]


bulk insert [dbo].[orcamento2] 
from 'D:\orcamento1.txt'
with(
		codepage = 'raw',
		 DATAFILETYPE = 'widechar',
		FIELDTERMINATOR = ',',
		 FIRSTROW = 2
		
						)

update dbo.orcamento
set
	valor = replace(valor,',','.')