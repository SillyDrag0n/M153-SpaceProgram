--*********************************************************
-- SpacePrograms
--*********************************************************

-----------------------------------------------------------
-- Stored Procedures erstellen
-----------------------------------------------------------

-- use ComputerShop
-- go
-- 
-- drop function if exists fn_KundenName;
-- go
-- 
-- create function fn_KundenName (@KundeId int) returns varchar(100) as 
-- begin
-- declare @KundenName varchar (100);
-- 	set @KundenName = (select (Kunde.Nachname + ' ' + Kunde.Vorname) AS Kunde 
-- 					   from Kunde 
-- 					   where Kunde.KundeId = @KundeId);
-- 	return @KundenName;
-- end;