--*********************************************************
-- SpacePrograms
--*********************************************************

-----------------------------------------------------------
-- Datenbank erstellen
-----------------------------------------------------------
use master
go
drop database if exists SpacePrograms; 
go
create database SpacePrograms;
go
use SpacePrograms;
go

-----------------------------------------------------------
-- Tabllen erstellen
-----------------------------------------------------------
create table Program (
  ProgramId int identity(1,1),
  ProgramName varchar(50),
  ProgramStartDate date,
  ProgramEndDate date NULL,
  ProgramBudget decimal(16,2),
  ProgramNoOfFlights int,
  primary key (ProgramId),
);
go

create table Mission (
  MissionId int identity(1,1),
  MissionName varchar(50),
  MissionSucceeded bit NULL, 
  primary key (MissionId),
  fk_ProgramId int,
  fk_DestinationId int,
  fk_LaunchSiteId int,
);
go

create table Destination (
  DestinationId int identity(1,1),
  DestinationDescription varchar(50),
  primary key (DestinationId),
);
go

create table LaunchSite (
  LaunchSiteId int identity(1,1),
  LaunchSiteDescription varchar(50),
  primary key (LaunchSiteId),
);
go

create table Contributed (
  ContributedId int identity(1,1),
  primary key (ContributedId),
  fk_MissionId int,
  fk_OrganisationId int,
);
go

create table Organisation (
  OrganisationId int identity(1,1),
  OrganisationName varchar(60),
  OrganisationFoundationDate date,
  primary key (OrganisationId),
);
go

create table Worked (
  WorkedId int identity(1,1),
  primary key (WorkedId),
  fk_PersonalId int,
  fk_MissionId int,
);
go

create table Personal (
  PersonalId int identity(1,1),
  PersonalFirstname varchar(30),
  PersonalLastname varchar(30),
  primary key (PersonalId),
  fk_JobId int,
  fk_OrganisationId int,
);
go

create table Job (
  JobId int identity(1,1),
  JobDescription varchar(30),
  primary key (JobId),
);
go

-----------------------------------------------------------
-- Beziehungen erstellen
-----------------------------------------------------------

-- Add constraint to only allow a positive value to be added to the Program.ProgramNoOfFlights column
alter table Program with nocheck add constraint
  CheckIfProgramNoOfFlightsisPositive check (([ProgramNoOfFlights] >= 0))
go

alter table Mission 
  add constraint fk_DestinationIdForMission foreign key (fk_DestinationId) REFERENCES Destination (DestinationId),
      constraint fk_LaunchSiteForMission foreign key (fk_LaunchSiteId) REFERENCES LaunchSite (LaunchSiteId),
      constraint fk_ProgramIdForMission foreign key (fk_ProgramId) REFERENCES Program (ProgramId);
go
	  
alter table Contributed 
  add constraint fk_OrganisationIdForContributed foreign key (fk_OrganisationId) REFERENCES Organisation (OrganisationId),
      constraint fk_MissionIdForContributed foreign key (fk_MissionId) REFERENCES Mission (MissionId);
go
	  
alter table Worked 
  add constraint fk_PersonalIdForWorked foreign key (fk_PersonalId) REFERENCES Personal (PersonalId),
      constraint fk_MissionIdForWorked foreign key (fk_MissionId) REFERENCES Mission (MissionId);
go

alter table Personal 
  add constraint fk_JobIdForPersonal foreign key (fk_JobId) REFERENCES Job (JobId),
      constraint fk_OrganisationForPersonal foreign key (fk_OrganisationId) REFERENCES Organisation (OrganisationId);
go
