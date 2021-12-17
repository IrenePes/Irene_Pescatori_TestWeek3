create database PizzeriaDaLuigi

create table Pizza (
CodicePizza int not null constraint PK_Pizza primary key identity(1,1),
Nome varchar(30) not null,
Prezzo decimal(4,2) not null check(Prezzo>0)
);

-- Procedure per inserire una nuova pizza
create procedure InserisciPizza
@nome varchar(30),
@prezzo decimal(4,2)
as
insert into Pizza values(@nome, @prezzo)
go

create table Ingrediente (
CodiceIngrediente int not null constraint PK_Ingrediente primary key identity(1,1),
Nome varchar(30) not null,
Costo decimal(4,2) not null check(Costo>0),
ScorteMagazzino int not null check(ScorteMagazzino>=0)
);

-- Procedure per inserire nuovo ingrediente
create procedure InserisciIngrediente
@nome varchar(30),
@costo decimal(4,2),
@scorte int
as
insert into Ingrediente values(@nome, @costo, @scorte)
go

create table PizzaIngrediente (
CodicePizza int not null constraint FK_Pizza foreign key references Pizza(CodicePizza),
CodiceIngrediente int not null constraint FK_Ingrediente foreign key references Ingrediente(CodiceIngrediente),
constraint PK_PizzaIngrediente primary key(CodicePizza, CodiceIngrediente)
);

-- Procedure per assegnare un nuovo ingrediente ad una pizza
create procedure AssegnaIngredienteAPizza
@nomeIngrediente varchar(30),
@nomePizza varchar(30)
as
insert into PizzaIngrediente values((select CodicePizza from Pizza where Nome = @nomePizza),
									(select CodiceIngrediente from Ingrediente where Nome = @nomeIngrediente))
go


-- Popolazione delle tabelle
--execute InserisciPizza 'Margherita', 5
--execute InserisciPizza 'Bufala', 7
--execute InserisciPizza 'Diavola', 6
--execute InserisciPizza 'Quattro stagioni', 6.5
--execute InserisciPizza 'Porcini', 7
--execute InserisciPizza 'Dioniso', 8
--execute InserisciPizza 'Ortolana', 8
--execute InserisciPizza 'Patate e salsiccia', 6
--execute InserisciPizza 'Pomodorini', 6
--execute InserisciPizza 'Quattro formaggi', 7.5
--execute InserisciPizza 'Caprese', 7.5
--execute InserisciPizza 'Zeus', 7.5

select * from Pizza

--execute InserisciIngrediente 'Pomodoro', 0.5, 20
--execute InserisciIngrediente 'Mozzarella', 2, 50
--execute InserisciIngrediente 'Mozzarella di bufala', 3.5, 30
--execute InserisciIngrediente 'Spianata piccante', 2.5, 8
--execute InserisciIngrediente 'Funghi', 3, 10
--execute InserisciIngrediente 'Carciofi', 1.5, 10
--execute InserisciIngrediente 'Cotto', 2, 17
--execute InserisciIngrediente 'Olive', 1, 13
--execute InserisciIngrediente 'Funghi porcini', 4, 8
--execute InserisciIngrediente 'Stracchino', 1.5, 14
--execute InserisciIngrediente 'Speck', 2.5, 9
--execute InserisciIngrediente 'Rucola', 0.5, 18
--execute InserisciIngrediente 'Grana', 2, 22
--execute InserisciIngrediente 'Verdure di stagione', 2, 16
--execute InserisciIngrediente 'Patate', 0.8, 40
--execute InserisciIngrediente 'Salsiccia', 3, 13
--execute InserisciIngrediente 'Pomodorini', 1.2, 19
--execute InserisciIngrediente 'Ricotta', 2.7, 10
--execute InserisciIngrediente 'Provola', 3.8, 8
--execute InserisciIngrediente 'Gorgonzola', 4.2, 8
--execute InserisciIngrediente 'Pomodoro fresco', 0.8, 15
--execute InserisciIngrediente 'Basilico', 0.3, 6
--execute InserisciIngrediente 'Bresaola', 4.2, 12

select * from Ingrediente

--execute AssegnaIngredienteAPizza 'Mozzarella', 'Margherita'
--execute AssegnaIngredienteAPizza 'Pomodoro', 'Margherita'
--execute AssegnaIngredienteAPizza 'Pomodoro', 'Bufala'
--execute AssegnaIngredienteAPizza 'Mozzarella di bufala', 'Bufala'
--execute AssegnaIngredienteAPizza 'Pomodoro', 'Diavola'
--execute AssegnaIngredienteAPizza 'Mozzarella', 'Diavola'
--execute AssegnaIngredienteAPizza 'Spianata piccante', 'Diavola'
--execute AssegnaIngredienteAPizza 'Pomodoro', 'Quattro stagioni'
--execute AssegnaIngredienteAPizza 'Mozzarella', 'Quattro stagioni'
--execute AssegnaIngredienteAPizza 'Funghi', 'Quattro stagioni'
--execute AssegnaIngredienteAPizza 'Carciofi', 'Quattro stagioni'
--execute AssegnaIngredienteAPizza 'Cotto', 'Quattro stagioni'
--execute AssegnaIngredienteAPizza 'Olive', 'Quattro stagioni'
--execute AssegnaIngredienteAPizza 'Pomodoro', 'Porcini'
--execute AssegnaIngredienteAPizza 'Mozzarella', 'Porcini'
--execute AssegnaIngredienteAPizza 'Funghi porcini', 'Porcini'
--execute AssegnaIngredienteAPizza 'Pomodoro', 'Dioniso'
--execute AssegnaIngredienteAPizza 'Mozzarella', 'Dioniso'
--execute AssegnaIngredienteAPizza 'Stracchino', 'Dioniso'
--execute AssegnaIngredienteAPizza 'Speck', 'Dioniso'
--execute AssegnaIngredienteAPizza 'Rucola', 'Dioniso'
--execute AssegnaIngredienteAPizza 'Grana', 'Dioniso'
--execute AssegnaIngredienteAPizza 'Pomodoro', 'Ortolana'
--execute AssegnaIngredienteAPizza 'Mozzarella', 'Ortolana'
--execute AssegnaIngredienteAPizza 'Verdure di stagione', 'Ortolana'
--execute AssegnaIngredienteAPizza 'Mozzarella', 'Patate e salsiccia'
--execute AssegnaIngredienteAPizza 'Patate', 'Patate e salsiccia'
--execute AssegnaIngredienteAPizza 'Salsiccia', 'Patate e salsiccia'
--execute AssegnaIngredienteAPizza 'Mozzarella', 'Pomodorini'
--execute AssegnaIngredienteAPizza 'Pomodorini', 'Pomodorini'
--execute AssegnaIngredienteAPizza 'Ricotta', 'Pomodorini'
--execute AssegnaIngredienteAPizza 'Mozzarella', 'Quattro formaggi'
--execute AssegnaIngredienteAPizza 'Provola', 'Quattro formaggi'
--execute AssegnaIngredienteAPizza 'Gorgonzola', 'Quattro formaggi'
--execute AssegnaIngredienteAPizza 'Grana', 'Quattro formaggi'
--execute AssegnaIngredienteAPizza 'Mozzarella', 'Caprese'
--execute AssegnaIngredienteAPizza 'Pomodoro fresco', 'Caprese'
--execute AssegnaIngredienteAPizza 'Basilico', 'Caprese'
--execute AssegnaIngredienteAPizza 'Mozzarella', 'Zeus'
--execute AssegnaIngredienteAPizza 'Bresaola', 'Zeus'
--execute AssegnaIngredienteAPizza 'Rucola', 'Zeus'

select * from PizzaIngrediente

-- QUERY
--1. Estrarre tutte le pizze con prezzo superiore a 6 euro.
select Nome, Prezzo
from Pizza
where Prezzo > 6
--2. Estrarre la pizza/le pizze più costosa/e.
select distinct Nome
from Pizza
where Prezzo = (select max(Prezzo)
				from Pizza)
--3. Estrarre le pizze «bianche»
select distinct p.Nome
from Pizza p join PizzaIngrediente ppi on p.CodicePizza = ppi.CodicePizza
where p.CodicePizza not in (select ppi.CodicePizza
							from Ingrediente i join PizzaIngrediente ppi on i.CodiceIngrediente = ppi.CodiceIngrediente
							where i.Nome = 'Pomodoro')

--4. Estrarre le pizze che contengono funghi (di qualsiasi tipo)
select p.Nome
from Pizza p join PizzaIngrediente ppi on p.CodicePizza = ppi.CodicePizza
where ppi.CodiceIngrediente in (select CodiceIngrediente
							   from Ingrediente
							   where Nome like 'Funghi%')

--PROCEDURE
-- Procedure per aggiornare il prezzo di una pizza
create procedure AggiornaPrezzoPizza
@nomePizza varchar(30),
@nuovoPrezzo decimal(4,2)
as
update Pizza set Prezzo = @nuovoPrezzo where Nome = @nomePizza
go

execute AggiornaPrezzoPizza 'Patate e salsiccia', 8.5

-- Procedure per eliminare un ingrediente da una pizza
create procedure EliminaIngredienteDaUnaPizza
@nomePizza varchar(30),
@nomeIngrediente varchar(40)
as

declare @CODICEPIZZA int
declare @CODICEINGREDIENTE int

select @CODICEPIZZA = CodicePizza
from Pizza
where Nome = @nomePizza

select @CODICEINGREDIENTE = CodiceIngrediente
from Ingrediente
where Nome = @nomeIngrediente

delete from PizzaIngrediente where (CodicePizza = @CODICEPIZZA and CodiceIngrediente = @CODICEINGREDIENTE)
go

--execute InserisciPizza 'Pizza prova', 15
--execute AssegnaIngredienteAPizza 'Gorgonzola', 'Pizza prova'
--execute AssegnaIngredienteAPizza 'Cotto', 'Pizza prova'

execute EliminaIngredienteDaUnaPizza 'Pizza prova', 'Gorgonzola'

--Procedure che incrementa del 10% il prezzo di tutte le pizze contenti un determinato ingrediente
create procedure IncrementaPrezzoPizzeConIngrediente
@nomeIngrediente varchar(30)
as

declare @CODICEINGREDIENTE int

select @CODICEINGREDIENTE = CodiceIngrediente
from Ingrediente
where Nome = @nomeIngrediente

update Pizza set Prezzo = Prezzo + Prezzo * 0.1 where CodicePizza in (select CodicePizza
																	  from PizzaIngrediente
																	  where CodiceIngrediente = @CODICEINGREDIENTE)
go

execute IncrementaPrezzoPizzeConIngrediente 'Mozzarella di bufala'
execute IncrementaPrezzoPizzeConIngrediente 'Cotto'

--FUNCTION
-- Funzione per tabella listino prezzi (nome pizza, prezzo pizza)
create function ListinoPrezzi()
returns table
as
return
select distinct Nome, Prezzo
from Pizza
go

select * from dbo.ListinoPrezzi()

-- Funzione per tabella listino pizze (nome, prezzo) contenenti un ingrediente
create function ListinoPizzeConIngrediente(@nomeIngrediente varchar(40))
returns table
as
return 
select p.Nome, p.Prezzo
from Pizza p join PizzaIngrediente ppi on p.CodicePizza = ppi.CodicePizza
where ppi.CodiceIngrediente = (select CodiceIngrediente
							   from Ingrediente
							   where Nome = @nomeIngrediente)
go

select * from dbo.ListinoPizzeConIngrediente('Rucola')

-- Funzione per tabella listino pizze (nome, prezzo) che non contengono un determinato ingrediente
create function ListinoPizzeSenzaIngrediente(@nomeIngrediente varchar(40))
returns table
as
return
select distinct p.Nome, p.Prezzo
from Pizza p join PizzaIngrediente ppi on p.CodicePizza = ppi.CodicePizza
where p.CodicePizza not in (select ppi.CodicePizza
							from Ingrediente i join PizzaIngrediente ppi on i.CodiceIngrediente = ppi.CodiceIngrediente
							where i.Nome = @nomeIngrediente)
go

select * from dbo.ListinoPizzeSenzaIngrediente('Pomodoro')

-- Funzione per calcolo numero pizze che contengono un ingrediente
create function NumeroPizzeConIngrediente(@nomeIngrediente varchar(40))
returns int
as 
begin

declare @CODICEINGREDIENTE int

select @CODICEINGREDIENTE = CodiceIngrediente
from Ingrediente
where Nome = @nomeIngrediente

declare @NUMEROPIZZE int

select @NUMEROPIZZE = count(p.Nome)
from Pizza p join PizzaIngrediente ppi on p.CodicePizza = ppi.CodicePizza
where ppi.CodiceIngrediente = @CODICEINGREDIENTE

return @NUMEROPIZZE
end


select dbo.NumeroPizzeConIngrediente('Grana')

-- Funzione per calcolo numero pizze che non contengono un ingrediente
create function NumeroPizzeSenzaIngrediente(@codiceIngrediente int)
returns int
as
begin

declare @NUMEROPIZZE int

select @NUMEROPIZZE = count(Nome)
from Pizza
where Nome not in (select p.Nome
				   from Pizza p join PizzaIngrediente ppi on p.CodicePizza = ppi.CodicePizza
				   where ppi.CodiceIngrediente = @codiceIngrediente)
return @NUMEROPIZZE
end

select dbo.NumeroPizzeSenzaIngrediente(12)

-- Funzione per calcolo numero ingredienti contenuti in una pizza
create function NumeroIngredientiPerPizza(@nomePizza varchar(40))
returns int
as
begin

declare @CODICEPIZZA int

select @CODICEPIZZA = CodicePizza
from Pizza
where Nome = @nomePizza

declare @NUMEROINGREDIENTI int

select @NUMEROINGREDIENTI = count(CodiceIngrediente)
from PizzaIngrediente
where CodicePizza = @CODICEPIZZA

return @NUMEROINGREDIENTI
end

select dbo.NumeroIngredientiPerPizza('Diavola')

-- VIEW
create view RiepilogoBase as
select p.Nome as [Nome pizza], p.Prezzo, i.Nome as [Nome ingrediente]
from Pizza p join PizzaIngrediente ppi on p.CodicePizza = ppi.CodicePizza
			 join Ingrediente i on i.CodiceIngrediente = ppi.CodiceIngrediente

select * from RiepilogoBase


-- creo lista ingredienti, voglio associarla al nome e al prezzo ...
select STRING_AGG(i.Nome, ', ')
from Ingrediente i join PizzaIngrediente ppi on i.CodiceIngrediente = ppi.CodiceIngrediente
group by ppi.CodicePizza

