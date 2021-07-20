--–- Cria a tabela de clientes
CREATE TABLE Clientes (
    IDCliente INT, NomeCliente VARCHAR(50))

--–- Popula a tabela de Clientes
INSERT INTO Clientes VALUES (1, 'Bianca')
INSERT INTO Clientes VALUES (2, 'Herbert')
INSERT INTO Clientes VALUES (3, 'Paloma')
INSERT INTO Clientes VALUES (4, 'Marcos')
INSERT INTO Clientes VALUES (5, 'Jonas')
INSERT INTO Clientes VALUES (6, 'Tatiana')

--–- Cria a tabela de saldos
CREATE TABLE Lancamentos (
    IDCliente INT, Data SMALLDATETIME,
    Valor SMALLMONEY, Tipo CHAR(1))

--– Popula a tabela de Saldos
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
O objetivo normalmente é muito simples. Para o script em questão é necessário obter o último lançamento para cada cliente. 
O último lançamento é identificado tendo-se por base a data mais recente. Já vi alguns exemplos incorretos, mas que esboçam uma primeira tentativa:
/*

O primeiro SELECT está errado porque ele apenas retornará todos os lançamentos que ocorreram na última data 
e isso não necessariamente significa retornar o último lançamento para cada cliente, visto que podem 
haver clientes que tiveram lançamentos na última data (que é o caso do cliente 5).
*/

SELECT * FROM Lancamentos
WHERE Data = (SELECT MAX(Data) FROM Lancamentos)

/*
O segundo SELECT está incorreto, porque a idéia é demonstrar o último lançamento por cliente. 
Da forma como a cláusula GROUP BY está formulada, será retornado o último lançamento pode cliente, 
por valor e por tipo. Como não há combinações cliente, valor e tipo repetidas, 
na prática essa cláusula não terá nenhum efeito e os 12 lançamentos serão retornados.
*/

SELECT IDCliente, MAX(Data) As UltimaData, Valor, Tipo
FROM Lancamentos
GROUP BY IDCliente, Valor, Tipo
/*

O terceiro SELECT até faz algum sentido, mas a cláusula GROUP BY exige que todos os campos que 
não estejam em uma função de agregação ou não sejam uma constante sejam contemplados. 
Assim, como Valor e Tipo não são utilizados por nenhuma função de agregação e nem representam constantes, 
essa instrução irá provocar um erro de sintaxe.

*/

SELECT IDCliente, MAX(Data) As UltimaData, Valor, Tipo
FROM Lancamentos
GROUP BY IDCliente
/*

O último SELECT é uma tentativa de eliminar as restrições do terceiro SELECT, 
mas também não retorna os resultados corretamente. O MAX irá retornar o maior valor para uma determinada 
coluna e não necessariamente a maior data está associada ao maior valor. 
Considerando que existem apenas dois tipos de lançamento (C para crédito e D para débito), 
os clientes que possuírem débito terão o MAX(Tipo) igual a D e não necessariamente o último lançamento é um débito. 
*/
SELECT IDCliente, MAX(Data) As UltimaData, MAX(Valor) As UltimoValor,
MAX(Tipo) As UltimoTipo FROM Lancamentos
GROUP BY IDCliente

-----------------------------------------------------------------------------------
/*
A utilização do MAX certamente faz parte da resposta, mas ela sozinha não é suficiente. 
O detalhe para encontrar o caminho da resposta está em perceber que o MAX é útil para 
encontrar a última data e com ele podemos encontrar a última data para cada cliente 
representando quando ocorreu seu último lançamento.
*/


SELECT IDCliente, MAX(Data) As UltimaData
FROM Lancamentos GROUP BY IDCliente 

/*
Uma vez que tenhamos o ID do cliente e a data do último lançamento (UltimaData), 
basta realizar um JOIN entre esse resultado e a tabela de lançamentos. 
Combinando esse resultado com a tabela de lançamentos através das colunas 
IDCliente e UltimaData com IDCliente e Data poderemos obter todos os detalhes do último lançamento.
*/

--– Utilização de Subqueries (Derived Table)
SELECT L1.* FROM Lancamentos As L1
INNER JOIN (
    SELECT IDCliente, MAX(Data) As UltimaData
    FROM Lancamentos GROUP BY IDCliente) As L2
        ON L1.IDCliente = L2.IDCliente AND L1.Data = L2.UltimaData
ORDER BY L1.IDCliente 

