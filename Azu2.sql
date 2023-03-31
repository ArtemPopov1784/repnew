set ansi_nulls on
go
set ansi_padding on
go
set quoted_identifier on
go

drop database [AzuDB]
go

create database [AzuDB]
go

use [AzuDB]
go

create table [dbo].[User]
(
	[Id_User] [int] not null identity(1,1),
	[PhoneNumber] [varchar] (11) not null,
	[Login] [varchar] (64) not null,
	[Password] [varchar] (64) not null,
	[Role_Name] [varchar] (20) null default('Пользователь'),
	[Balance] [decimal] (32, 2) null default(0.00),
	constraint [PK_User] primary key clustered ([Id_User] ASC) on [PRIMARY],
	constraint [UQ_NumberPhone] unique ([PhoneNumber]),
	constraint [UQ_Login] unique ([Login]),
	constraint [CH_Balance] check ([Balance] >= 0)
)
go
insert into [dbo].[User] ([PhoneNumber], [Login], [Password], [Role_Name], [Balance]) 
values 
('88005553535', 'Admin', 'AdminPass', 'Администратор', 99999.00),
('88005553534', 'User', 'UserPass', 'Пользователь', 2000.00)
go

create table [dbo].[Order]
(
	[ID_Order] [int] not null identity(1,1),
	[DateTime_Order] [datetime] null default(SYSDATETIME()),
	[Price] [decimal] (10,2) not null,
	[FoodCount] [int] not null,
	[User_ID] [int] not null,
	constraint [PK_Order] primary key clustered ([ID_Order] ASC) on [PRIMARY],
	constraint [FK_User] foreign key ([User_ID]) references [dbo].[User]([Id_User])
)
go

create table [dbo].[Ingredients]
(
	[ID_Ingridients] [int] not null identity(1,1),
	[TypeIngredient] [varchar] (50) not null,
	[NameIngredient] [varchar] (50) not null,
	[PriceIngredient] [decimal] (10,2) null default(0.0),
	[CountIngredients] [int] null default(0),
	constraint [PK_Ingredients] primary key clustered ([ID_Ingridients] ASC) on [PRIMARY],
	constraint [CH_Price] check ([PriceIngredient] >= 0)
)
go

create table [dbo].[Azu]
(
	[ID_Ingridients] [int] not null identity(1,1),
	[Price] [decimal] (10,2) not null,
	[Order_ID] [int] not null,
	constraint [PK_Azu] primary key clustered ([ID_Ingridients] ASC) on [PRIMARY],
	constraint [FK_Order] foreign key ([Order_ID]) references [dbo].[Order]([ID_Order])
)
go

insert into [dbo].[Ingredients] ([TypeIngredient], [NameIngredient], [PriceIngredient], [CountIngredients])
values
	('Мясо', 'Гавядина', 1, 99),
	('Мясо', 'Свинина', 10, 10),
	('Мясо', 'Курица', 10, 10),
	('Овощи', 'Солёные огурцы', 14, 5),
	('Овощи', 'Картофель', 1, 99),
	('Овощи', 'Репчатый лук', 1, 99),
	('Приправы', 'Томатная паста', 1, 99),
	('Приправы', 'Горчица', 10, 10),
	('Приправы', 'Майонез', 10, 10),
	('Готовые блюда', 'Мясной бульон', 1, 99),
	('Готовые блюда', 'Овощной бульон', 10, 10),
	('Готовые блюда', 'Вода', 10, 10)
go 

create or alter function [dbo].[ID_OrderCreation]()
returns [int]
with execute as caller
as
	begin 
		declare @StringCount [int] = (select count(*) from [dbo].[Order])
		declare @value [int] 
		if @StringCount = 0 
			begin
				set @value = -1
			end
		else
			begin
				set @value = (select max([ID_Order]) from [dbo].[Order])
			end
		return @value
	end
go

create or alter procedure [dbo].[ID_Update_Count_Ingr](@1st [int], @2nd [int], @3rd [int], @4th [int], @5th [int], @6th [int], @7th [int])
as
	declare @count_1st [int] = (select [CountIngredients] from [dbo].[Ingredients] where [ID_Ingridients] = @1st)
	declare @count_2nd [int] = (select [CountIngredients] from [dbo].[Ingredients] where [ID_Ingridients] = @2nd)
	declare @count_3rd [int] = (select [CountIngredients] from [dbo].[Ingredients] where [ID_Ingridients] = @3rd)
	declare @count_4th [int] = (select [CountIngredients] from [dbo].[Ingredients] where [ID_Ingridients] = @4th)
	declare @count_5th [int] = (select [CountIngredients] from [dbo].[Ingredients] where [ID_Ingridients] = @5th)
	declare @count_6th [int] = (select [CountIngredients] from [dbo].[Ingredients] where [ID_Ingridients] = @6th)
	declare @count_7th [int] = (select [CountIngredients] from [dbo].[Ingredients] where [ID_Ingridients] = @7th)
	update [dbo].[Ingredients] set [CountIngredients] = @count_1st - 1 where [ID_Ingridients] = @1st
	update [dbo].[Ingredients] set [CountIngredients] = @count_2nd - 1 where [ID_Ingridients] = @2nd
	update [dbo].[Ingredients] set [CountIngredients] = @count_3rd - 1 where [ID_Ingridients] = @3rd
	update [dbo].[Ingredients] set [CountIngredients] = @count_4th - 1 where [ID_Ingridients] = @4th
	update [dbo].[Ingredients] set [CountIngredients] = @count_5th - 1 where [ID_Ingridients] = @5th
	update [dbo].[Ingredients] set [CountIngredients] = @count_6th - 1 where [ID_Ingridients] = @6th
	update [dbo].[Ingredients] set [CountIngredients] = @count_7th - 1 where [ID_Ingridients] = @7th
go

create or alter function [dbo].[Sum_Order] (@1st [int], @2nd [int], @3rd [int], @4th [int], @5th [int], @6th [int], @7th [int])
returns [decimal] (15, 2)
with execute as caller
as
	begin 
		declare @Price [decimal] = 
		(select [PriceIngredient] from [dbo].[Ingredients] where [ID_Ingridients] = @1st) + 
		(select [PriceIngredient] from [dbo].[Ingredients] where [ID_Ingridients] = @2nd) + 
		(select [PriceIngredient] from [dbo].[Ingredients] where [ID_Ingridients] = @3rd) + 
		(select [PriceIngredient] from [dbo].[Ingredients] where [ID_Ingridients] = @4th) +
		(select [PriceIngredient] from [dbo].[Ingredients] where [ID_Ingridients] = @5th) +
		(select [PriceIngredient] from [dbo].[Ingredients] where [ID_Ingridients] = @6th) +
		(select [PriceIngredient] from [dbo].[Ingredients] where [ID_Ingridients] = @7th)
		return @Price
	end
go

create or alter procedure [dbo].[TakeMoney](@Sum [decimal] (15, 2), @Id_User [int])
as
	declare @Wallet [decimal] (15, 2) = (select [Balance] from [dbo].[User] where [Id_User] = @Id_User)
	update [dbo].[User] set [Balance] = (@Wallet - @Sum) where [Id_User] = @Id_User
go

select top 1 [Price] from [dbo].[Order] where [User_ID] = 2
go

select case 
when sum([Price]) >= 100 and sum([Price]) < 200 then 1
when sum([Price]) >= 200 and sum([Price]) < 300  then 2
when sum([Price]) >= 300 and sum([Price]) < 400 then 3
else 0
end from [dbo].[Order] where [User_ID] = 2
go
 
create or alter procedure [dbo].[AddIngredient] (@Id_Ingredient [int], @CountProducts [int])
as
	declare @Count_Ingredients [int] = (select [CountIngredients] from [dbo].[Ingredients] where [ID_Ingridients] = @Id_Ingredient)
	update [dbo].[Ingredients] set [CountIngredients] = @Count_Ingredients + @CountProducts where [ID_Ingridients] = @Id_Ingredient
go