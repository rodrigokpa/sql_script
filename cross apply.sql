--�- Cria a tabela de clientes
CREATE TABLE Clientes (
    IDCliente INT, NomeCliente VARCHAR(50))

--�- Popula a tabela de Clientes
INSERT INTO Clientes VALUES (1, 'Bianca')
INSERT INTO Clientes VALUES (2, 'Herbert')
INSERT INTO Clientes VALUES (3, 'Paloma')
INSERT INTO Clientes VALUES (4, 'Marcos')
INSERT INTO Clientes VALUES (5, 'Jonas')
INSERT INTO Clientes VALUES (6, 'Tatiana')

--�- Cria a tabela de saldos
CREATE TABLE Lancamentos (
    IDCliente INT, Data SMALLDATETIME,
    Valor SMALLMONEY, Tipo CHAR(1))

--� Popula a tabela de Saldos
INSERT INTO Lancamentos VALUES (1, '20090109',15.00,'C')
INSERT INTO Lancamentos VALUES (1, '20090110',25.00,'C')
INSERT INTO Lancamentos VALUES (1, '20090111',10.00,'D')
INSERT INTO Lancamentos VALUES (2, '20090110',15.00,'D')
INSERT INTO Lancamentos VALUES (2, '20090111',26.00,'D')
INSERT INTO Lancamentos VALUES (3, '20090111',19.00,'C')
INSERT INTO Lancamentos VALUES (4, '20090108',42.00,'D')
INSERT INTO Lancamentos VALUES (4, '20090109',33.00,'C')
INSERT INTO Lancamentos VALUES (4, '20090110',18.00,'C')
INSERT INTO Lancamentos VALUES (4, '20090111',11.00,'D')
INSERT INTO Lancamentos VALUES (5, '20090109',23.00,'C')
INSERT INTO Lancamentos VALUES (5, '20090110',55.00,'C') 


---------------------------------------------------------------------
O objetivo normalmente � muito simples. Para o script em quest�o � necess�rio obter o �ltimo lan�amento para cada cliente. 
O �ltimo lan�amento � identificado tendo-se por base a data mais recente. J� vi alguns exemplos incorretos, mas que esbo�am uma primeira tentativa:
/*

O primeiro SELECT est� errado porque ele apenas retornar� todos os lan�amentos que ocorreram na �ltima data 
e isso n�o necessariamente significa retornar o �ltimo lan�amento para cada cliente, visto que podem 
haver clientes que tiveram lan�amentos na �ltima data (que � o caso do cliente 5).
*/

SELECT * FROM Lancamentos
WHERE Data = (SELECT MAX(Data) FROM Lancamentos)

/*
O segundo SELECT est� incorreto, porque a id�ia � demonstrar o �ltimo lan�amento por cliente. 
Da forma como a cl�usula GROUP BY est� formulada, ser� retornado o �ltimo lan�amento pode cliente, 
por valor e por tipo. Como n�o h� combina��es cliente, valor e tipo repetidas, 
na pr�tica essa cl�usula n�o ter� nenhum efeito e os 12 lan�amentos ser�o retornados.
*/

SELECT IDCliente, MAX(Data) As UltimaData, Valor, Tipo
FROM Lancamentos
GROUP BY IDCliente, Valor, Tipo
/*

O terceiro SELECT at� faz algum sentido, mas a cl�usula GROUP BY exige que todos os campos que 
n�o estejam em uma fun��o de agrega��o ou n�o sejam uma constante sejam contemplados. 
Assim, como Valor e Tipo n�o s�o utilizados por nenhuma fun��o de agrega��o e nem representam constantes, 
essa instru��o ir� provocar um erro de sintaxe.

*/

SELECT IDCliente, MAX(Data) As UltimaData, Valor, Tipo
FROM Lancamentos
GROUP BY IDCliente
/*

O �ltimo SELECT � uma tentativa de eliminar as restri��es do terceiro SELECT, 
mas tamb�m n�o retorna os resultados corretamente. O MAX ir� retornar o maior valor para uma determinada 
coluna e n�o necessariamente a maior data est� associada ao maior valor. 
Considerando que existem apenas dois tipos de lan�amento (C para cr�dito e D para d�bito), 
os clientes que possu�rem d�bito ter�o o MAX(Tipo) igual a D e n�o necessariamente o �ltimo lan�amento � um d�bito. 
*/
SELECT IDCliente, MAX(Data) As UltimaData, MAX(Valor) As UltimoValor,
MAX(Tipo) As UltimoTipo FROM Lancamentos
GROUP BY IDCliente

-----------------------------------------------------------------------------------
/*
A utiliza��o do MAX certamente faz parte da resposta, mas ela sozinha n�o � suficiente. 
O detalhe para encontrar o caminho da resposta est� em perceber que o MAX � �til para 
encontrar a �ltima data e com ele podemos encontrar a �ltima data para cada cliente 
representando quando ocorreu seu �ltimo lan�amento.
*/


SELECT IDCliente, MAX(Data) As UltimaData
FROM Lancamentos GROUP BY IDCliente 

/*
Uma vez que tenhamos o ID do cliente e a data do �ltimo lan�amento (UltimaData), 
basta realizar um JOIN entre esse resultado e a tabela de lan�amentos. 
Combinando esse resultado com a tabela de lan�amentos atrav�s das colunas 
IDCliente e UltimaData com IDCliente e Data poderemos obter todos os detalhes do �ltimo lan�amento.
*/

--� Utiliza��o de Subqueries (Derived Table)
SELECT L1.* FROM Lancamentos As L1
INNER JOIN (
    SELECT IDCliente, MAX(Data) As UltimaData
    FROM Lancamentos GROUP BY IDCliente) As L2
        ON L1.IDCliente = L2.IDCliente AND L1.Data = L2.UltimaData
ORDER BY L1.IDCliente 

