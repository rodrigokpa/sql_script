Create table Pessoa(
id int,
nome varchar(50),
sexo char(1)
)

insert into Pessoa
select 1,'Rodrigo','M'


insert into Pessoa
select 2,'Miguel','M'


insert into Pessoa
select 3,'Celia','F'


select * from Pessoa for xml auto
/*
<Pessoa id="1" nome="Rodrigo" sexo="M" />
<Pessoa id="2" nome="Miguel" sexo="M" />
<Pessoa id="3" nome="Celia" sexo="F" />
*/
select * from Pessoa for xml auto, elements
/*
<Pessoa>
  <id>1</id>
  <nome>Rodrigo</nome>
  <sexo>M</sexo>
</Pessoa>
<Pessoa>
  <id>2</id>
  <nome>Miguel</nome>
  <sexo>M</sexo>
</Pessoa>
<Pessoa>
  <id>3</id>
  <nome>Celia</nome>
  <sexo>F</sexo>
</Pessoa>

*/




select * from Pessoa for xml auto, root('pessoa')
/*
<pessoa>
  <Pessoa id="1" nome="Rodrigo" sexo="M" />
  <Pessoa id="2" nome="Miguel" sexo="M" />
  <Pessoa id="3" nome="Celia" sexo="F" />
</pessoa>
*/


select * from Pessoa for xml auto, elements,root('pessoa')
/*
<pessoa>
  <Pessoa>
    <id>1</id>
    <nome>Rodrigo</nome>
    <sexo>M</sexo>
  </Pessoa>
  <Pessoa>
    <id>2</id>
    <nome>Miguel</nome>
    <sexo>M</sexo>
  </Pessoa>
  <Pessoa>
    <id>3</id>
    <nome>Celia</nome>
    <sexo>F</sexo>
  </Pessoa>
</pessoa>
*/



select * from Pessoa for xml auto, elements,root('pessoa')
, XMLSCHEMA('Nogare_70-461')



select * from Pessoa for xml raw

/*
<row id="1" nome="Rodrigo" sexo="M" />
<row id="2" nome="Miguel" sexo="M" />
<row id="3" nome="Celia" sexo="F" />
*/

select * from Pessoa for xml raw, elements
/*
<row>
  <id>1</id>
  <nome>Rodrigo</nome>
  <sexo>M</sexo>
</row>
<row>
  <id>2</id>
  <nome>Miguel</nome>
  <sexo>M</sexo>
</row>
<row>
  <id>3</id>
  <nome>Celia</nome>
  <sexo>F</sexo>
</row>
*/

select * from Pessoa for xml raw, root('pessoa')
/*
<pessoa>
  <row id="1" nome="Rodrigo" sexo="M" />
  <row id="2" nome="Miguel" sexo="M" />
  <row id="3" nome="Celia" sexo="F" />
</pessoa>
*/

select * from Pessoa for xml raw, elements,root('pessoa')
/*
<pessoa>
  <row>
    <id>1</id>
    <nome>Rodrigo</nome>
    <sexo>M</sexo>
  </row>
  <row>
    <id>2</id>
    <nome>Miguel</nome>
    <sexo>M</sexo>
  </row>
  <row>
    <id>3</id>
    <nome>Celia</nome>
    <sexo>F</sexo>
  </row>
</pessoa>
*/

select * from Pessoa for xml PATH('PESSOA')
/*
<PESSOA>
  <id>1</id>
  <nome>Rodrigo</nome>
  <sexo>M</sexo>
</PESSOA>
<PESSOA>
  <id>2</id>
  <nome>Miguel</nome>
  <sexo>M</sexo>
</PESSOA>
<PESSOA>
  <id>3</id>
  <nome>Celia</nome>
  <sexo>F</sexo>
</PESSOA>
*/
select * from Pessoa for xml PATH('')
/*
<id>1</id>
<nome>Rodrigo</nome>
<sexo>M</sexo>
<id>2</id>
<nome>Miguel</nome>
<sexo>M</sexo>
<id>3</id>
<nome>Celia</nome>
<sexo>F</sexo>
*/

select * from Pessoa for xml PATH('PESSOA'), ROOT('RAIZ')
/*
<RAIZ>
  <PESSOA>
    <id>1</id>
    <nome>Rodrigo</nome>
    <sexo>M</sexo>
  </PESSOA>
  <PESSOA>
    <id>2</id>
    <nome>Miguel</nome>
    <sexo>M</sexo>
  </PESSOA>
  <PESSOA>
    <id>3</id>
    <nome>Celia</nome>
    <sexo>F</sexo>
  </PESSOA>
</RAIZ>
*/
select tag = 2, parent = null,id [Categoria!2!id]from Pessoa for xml explicit 

