--*********************************************************
-- SpacePrograms
--*********************************************************

------------------------------------------------------------------
-- Stored Function 'fn_PersonalWorkedOnMission' erstellen
-- Searches for all Personal that worked on a selected mission
------------------------------------------------------------------
use SpacePrograms
go

drop function if exists fn_PersonalWorkedOnMission;
go

create function fn_PersonalWorkedOnMission(@MissionId int) returns @WorkedOnMissionTable table(MissionId int, MissionName varchar(50), PersonalName varchar(100), JobDescription varchar(50)) as
begin
	declare @TempTable table(MissionId int, MissionName varchar(50), PersonalName varchar(100), JobDescription varchar(50));
	
	if exists (select 1 from Worked	 where Worked.fk_MissionId = @MissionId)
	begin
		insert into @TempTable
 			select 
 				Mission.MissionId, 
 				Mission.MissionName, 
 				(Personal.PersonalFirstname + ' ' + PersonalLastname ) AS PersonalName, 
 				Job.JobDescription
 			from 
	 			Personal 
 				inner join Worked on Personal.PersonalId = Worked.fk_PersonalId
 				inner join Mission on Worked.fk_MissionId = Mission.MissionId
 				inner join Job on Personal.fk_JobId = Job.JobId
 			where 
				Mission.MissionId = @MissionId;
	end
	insert into @WorkedOnMissionTable select * from @TempTable
	return
end
go

------------------------------------------------------------------
-- 
-- Tests for stored Function 'fn_PersonalWorkedOnMission'
--
------------------------------------------------------------------

-- Should return a set of data with one entry:

select * from [dbo].[fn_PersonalWorkedOnMission] ('2')
go

------------------------------------------------------------------

-- Should return an empty dataset since there isnt' a mission with the Id 72010:

select * from [dbo].[fn_PersonalWorkedOnMission] ('72010')
go
 
------------------------------------------------------------------

-- Should return a set of data with three entries:

select * from [dbo].[fn_PersonalWorkedOnMission] (25)
go

------------------------------------------------------------------