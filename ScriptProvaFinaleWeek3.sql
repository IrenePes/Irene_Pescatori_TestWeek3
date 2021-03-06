USE [master]
GO
/****** Object:  Database [PizzeriaDaLuigi]    Script Date: 12/17/2021 3:25:00 PM ******/
CREATE DATABASE [PizzeriaDaLuigi]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PizzeriaDaLuigi', FILENAME = N'C:\Users\irene.pescatori\PizzeriaDaLuigi.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PizzeriaDaLuigi_log', FILENAME = N'C:\Users\irene.pescatori\PizzeriaDaLuigi_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [PizzeriaDaLuigi] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PizzeriaDaLuigi].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ARITHABORT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET  MULTI_USER 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PizzeriaDaLuigi] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [PizzeriaDaLuigi] SET QUERY_STORE = OFF
GO
USE [PizzeriaDaLuigi]
GO
/****** Object:  UserDefinedFunction [dbo].[NumeroIngredientiPerPizza]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NumeroIngredientiPerPizza](@nomePizza varchar(40))
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
GO
/****** Object:  UserDefinedFunction [dbo].[NumeroPizzeConIngrediente]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NumeroPizzeConIngrediente](@nomeIngrediente varchar(40))
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
GO
/****** Object:  UserDefinedFunction [dbo].[NumeroPizzeSenzaIngrediente]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NumeroPizzeSenzaIngrediente](@codiceIngrediente int)
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
GO
/****** Object:  Table [dbo].[Pizza]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pizza](
	[CodicePizza] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](30) NOT NULL,
	[Prezzo] [decimal](4, 2) NOT NULL,
 CONSTRAINT [PK_Pizza] PRIMARY KEY CLUSTERED 
(
	[CodicePizza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPrezzi]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPrezzi]()
returns table
as
return
select distinct Nome, Prezzo
from Pizza
GO
/****** Object:  Table [dbo].[Ingrediente]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingrediente](
	[CodiceIngrediente] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](30) NOT NULL,
	[Costo] [decimal](4, 2) NOT NULL,
	[ScorteMagazzino] [int] NOT NULL,
 CONSTRAINT [PK_Ingrediente] PRIMARY KEY CLUSTERED 
(
	[CodiceIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PizzaIngrediente]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PizzaIngrediente](
	[CodicePizza] [int] NOT NULL,
	[CodiceIngrediente] [int] NOT NULL,
 CONSTRAINT [PK_PizzaIngrediente] PRIMARY KEY CLUSTERED 
(
	[CodicePizza] ASC,
	[CodiceIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeConIngrediente]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeConIngrediente](@nomeIngrediente varchar(40))
returns table
as
return 
select p.Nome, p.Prezzo
from Pizza p join PizzaIngrediente ppi on p.CodicePizza = ppi.CodicePizza
where ppi.CodiceIngrediente = (select CodiceIngrediente
							   from Ingrediente
							   where Nome = @nomeIngrediente)
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeSenzaIngrediente]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeSenzaIngrediente](@nomeIngrediente varchar(40))
returns table
as
return
select distinct p.Nome, p.Prezzo
from Pizza p join PizzaIngrediente ppi on p.CodicePizza = ppi.CodicePizza
where p.CodicePizza not in (select ppi.CodicePizza
							from Ingrediente i join PizzaIngrediente ppi on i.CodiceIngrediente = ppi.CodiceIngrediente
							where i.Nome = @nomeIngrediente)
GO
/****** Object:  View [dbo].[RiepilogoBase]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[RiepilogoBase] as
select p.Nome as [Nome pizza], p.Prezzo, i.Nome as [Nome ingrediente]
from Pizza p join PizzaIngrediente ppi on p.CodicePizza = ppi.CodicePizza
			 join Ingrediente i on i.CodiceIngrediente = ppi.CodiceIngrediente
GO
SET IDENTITY_INSERT [dbo].[Ingrediente] ON 

INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (1, N'Pomodoro', CAST(0.50 AS Decimal(4, 2)), 20)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (2, N'Mozzarella', CAST(2.00 AS Decimal(4, 2)), 50)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (3, N'Mozzarella di bufala', CAST(3.50 AS Decimal(4, 2)), 30)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (4, N'Spianata piccante', CAST(2.50 AS Decimal(4, 2)), 8)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (5, N'Funghi', CAST(3.00 AS Decimal(4, 2)), 10)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (6, N'Carciofi', CAST(1.50 AS Decimal(4, 2)), 10)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (7, N'Cotto', CAST(2.00 AS Decimal(4, 2)), 17)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (8, N'Olive', CAST(1.00 AS Decimal(4, 2)), 13)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (9, N'Funghi porcini', CAST(4.00 AS Decimal(4, 2)), 8)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (10, N'Stracchino', CAST(1.50 AS Decimal(4, 2)), 14)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (11, N'Speck', CAST(2.50 AS Decimal(4, 2)), 9)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (12, N'Rucola', CAST(0.50 AS Decimal(4, 2)), 18)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (13, N'Grana', CAST(2.00 AS Decimal(4, 2)), 22)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (14, N'Verdure di stagione', CAST(2.00 AS Decimal(4, 2)), 16)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (15, N'Patate', CAST(0.80 AS Decimal(4, 2)), 40)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (16, N'Salsiccia', CAST(3.00 AS Decimal(4, 2)), 13)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (17, N'Pomodorini', CAST(1.20 AS Decimal(4, 2)), 19)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (18, N'Ricotta', CAST(2.70 AS Decimal(4, 2)), 10)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (19, N'Provola', CAST(3.80 AS Decimal(4, 2)), 8)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (20, N'Gorgonzola', CAST(4.20 AS Decimal(4, 2)), 8)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (21, N'Pomodoro fresco', CAST(0.80 AS Decimal(4, 2)), 15)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (22, N'Basilico', CAST(0.30 AS Decimal(4, 2)), 6)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (23, N'Bresaola', CAST(4.20 AS Decimal(4, 2)), 12)
SET IDENTITY_INSERT [dbo].[Ingrediente] OFF
GO
SET IDENTITY_INSERT [dbo].[Pizza] ON 

INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (1, N'Margherita', CAST(5.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (2, N'Bufala', CAST(7.70 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (3, N'Diavola', CAST(6.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (4, N'Quattro stagioni', CAST(7.15 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (5, N'Porcini', CAST(7.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (6, N'Dioniso', CAST(8.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (7, N'Ortolana', CAST(8.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (8, N'Patate e salsiccia', CAST(8.50 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (9, N'Pomodorini', CAST(6.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (10, N'Quattro formaggi', CAST(7.50 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (11, N'Caprese', CAST(7.50 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (12, N'Zeus', CAST(7.50 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (13, N'Pizza prova', CAST(16.50 AS Decimal(4, 2)))
SET IDENTITY_INSERT [dbo].[Pizza] OFF
GO
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (1, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (1, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (2, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (2, 3)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (3, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (3, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (3, 4)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 5)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 6)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 7)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 8)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (5, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (5, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (5, 9)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 10)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 11)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 12)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 13)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (7, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (7, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (7, 14)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (8, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (8, 15)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (8, 16)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (9, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (9, 17)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (9, 18)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 13)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 19)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 20)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (11, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (11, 21)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (11, 22)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (12, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (12, 12)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (12, 23)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (13, 7)
GO
ALTER TABLE [dbo].[PizzaIngrediente]  WITH CHECK ADD  CONSTRAINT [FK_Ingrediente] FOREIGN KEY([CodiceIngrediente])
REFERENCES [dbo].[Ingrediente] ([CodiceIngrediente])
GO
ALTER TABLE [dbo].[PizzaIngrediente] CHECK CONSTRAINT [FK_Ingrediente]
GO
ALTER TABLE [dbo].[PizzaIngrediente]  WITH CHECK ADD  CONSTRAINT [FK_Pizza] FOREIGN KEY([CodicePizza])
REFERENCES [dbo].[Pizza] ([CodicePizza])
GO
ALTER TABLE [dbo].[PizzaIngrediente] CHECK CONSTRAINT [FK_Pizza]
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD CHECK  (([Costo]>(0)))
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD CHECK  (([ScorteMagazzino]>=(0)))
GO
ALTER TABLE [dbo].[Pizza]  WITH CHECK ADD CHECK  (([Prezzo]>(0)))
GO
/****** Object:  StoredProcedure [dbo].[AggiornaPrezzoPizza]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AggiornaPrezzoPizza]
@nomePizza varchar(30),
@nuovoPrezzo decimal(4,2)
as
update Pizza set Prezzo = @nuovoPrezzo where Nome = @nomePizza
GO
/****** Object:  StoredProcedure [dbo].[AssegnaIngredienteAPizza]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AssegnaIngredienteAPizza]
@nomeIngrediente varchar(30),
@nomePizza varchar(30)
as
insert into PizzaIngrediente values((select CodicePizza from Pizza where Nome = @nomePizza),
									(select CodiceIngrediente from Ingrediente where Nome = @nomeIngrediente))
GO
/****** Object:  StoredProcedure [dbo].[EliminaIngredienteDaUnaPizza]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[EliminaIngredienteDaUnaPizza]
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
GO
/****** Object:  StoredProcedure [dbo].[IncrementaPrezzoPizzeConIngrediente]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[IncrementaPrezzoPizzeConIngrediente]
@nomeIngrediente varchar(30)
as

declare @CODICEINGREDIENTE int

select @CODICEINGREDIENTE = CodiceIngrediente
from Ingrediente
where Nome = @nomeIngrediente

update Pizza set Prezzo = Prezzo + Prezzo * 0.1 where CodicePizza in (select CodicePizza
																	  from PizzaIngrediente
																	  where CodiceIngrediente = @CODICEINGREDIENTE)
GO
/****** Object:  StoredProcedure [dbo].[InserisciIngrediente]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciIngrediente]
@nome varchar(30),
@costo decimal(4,2),
@scorte int
as
insert into Ingrediente values(@nome, @costo, @scorte)
GO
/****** Object:  StoredProcedure [dbo].[InserisciPizza]    Script Date: 12/17/2021 3:25:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciPizza]
@nome varchar(30),
@prezzo decimal(4,2)
as
insert into Pizza values(@nome, @prezzo)
GO
USE [master]
GO
ALTER DATABASE [PizzeriaDaLuigi] SET  READ_WRITE 
GO
