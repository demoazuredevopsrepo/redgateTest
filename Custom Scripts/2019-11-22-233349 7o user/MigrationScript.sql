/*
This migration script replaces uncommitted changes made to these objects:
Account
ActionTemplateVersion
ActionTemplate
ApiKey
Artifact
Certificate
Channel
CommunityActionTemplate
Configuration
DashboardConfiguration
DeploymentEnvironment
DeploymentHistory
DeploymentProcess
DeploymentRelatedMachine
Deployment
EventRelatedDocument
Event
ExtensionConfiguration
Feed
Interruption
Invitation
KeyAllocation
LibraryVariableSet
Lifecycle
MachinePolicy
Machine
Mutex
NuGetPackage
OctopusServerInstallationHistory
OctopusServerNode
ProjectGroup
ProjectTrigger
Project
Proxy
RelatedDocument
Release
SchemaVersions
Script0129RepairLegacyLibraryVariableSet
ServerTask
Subscription
TagSet
Team
TenantVariable
Tenant
UserRole
User
VariableSet
WorkerPool
WorkerTaskLease
Worker
EventSourceDeployments
GetNextKeyBlock
LatestSuccessfulDeploymentsToMachine
UpdateDeploymentHistory
Dashboard
IdsInUse
LatestSuccessfulDeployments
MultiTenancyDashboard
Release_LatestByProjectChannel
Release_WithDeploymentProcess
TenantProject
fnAreTagRulesSatisfied
fnSplitReferenceCollectionAsTable

Use this script to make necessary schema and data changes for these objects only. Schema changes to any other objects won't be deployed.

Schema changes and migration scripts are deployed in the order they're committed.

Migration scripts must not reference static data. When you deploy migration scripts alongside static data 
changes, the migration scripts will run first. This can cause the deployment to fail. 
Read more at https://documentation.red-gate.com/display/SOC7/Static+data+and+migrations.
*/

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating [dbo].[Deployment]'
GO
CREATE TABLE [dbo].[Deployment]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetimeoffset] NOT NULL,
[EnvironmentId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReleaseId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectGroupId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaskId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeployedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeployedToMachineIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChannelId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Deployment_Id] on [dbo].[Deployment]'
GO
ALTER TABLE [dbo].[Deployment] ADD CONSTRAINT [PK_Deployment_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Deployment_ChannelId] on [dbo].[Deployment]'
GO
CREATE NONCLUSTERED INDEX [IX_Deployment_ChannelId] ON [dbo].[Deployment] ([ChannelId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Deployment_Project] on [dbo].[Deployment]'
GO
CREATE NONCLUSTERED INDEX [IX_Deployment_Project] ON [dbo].[Deployment] ([ProjectId]) INCLUDE ([ChannelId], [Created], [EnvironmentId], [ReleaseId], [TaskId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Deployment_Index] on [dbo].[Deployment]'
GO
CREATE NONCLUSTERED INDEX [IX_Deployment_Index] ON [dbo].[Deployment] ([ReleaseId], [TaskId], [EnvironmentId]) INCLUDE ([Created], [Id], [Name], [ProjectGroupId], [ProjectId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Deployment_UpdateDeploymentHistory] on [dbo].[Deployment]'
GO
CREATE NONCLUSTERED INDEX [IX_Deployment_UpdateDeploymentHistory] ON [dbo].[Deployment] ([TaskId]) INCLUDE ([ChannelId], [Created], [DeployedBy], [EnvironmentId], [Name], [ProjectId], [ReleaseId], [TenantId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Deployment_TenantId] on [dbo].[Deployment]'
GO
CREATE NONCLUSTERED INDEX [IX_Deployment_TenantId] ON [dbo].[Deployment] ([TenantId]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[DeploymentRelatedMachine]'
GO
CREATE TABLE [dbo].[DeploymentRelatedMachine]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[DeploymentId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MachineId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_DeploymentRelatedMachine] on [dbo].[DeploymentRelatedMachine]'
GO
ALTER TABLE [dbo].[DeploymentRelatedMachine] ADD CONSTRAINT [PK_DeploymentRelatedMachine] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_DeploymentRelatedMachine_Deployment] on [dbo].[DeploymentRelatedMachine]'
GO
CREATE NONCLUSTERED INDEX [IX_DeploymentRelatedMachine_Deployment] ON [dbo].[DeploymentRelatedMachine] ([DeploymentId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_DeploymentRelatedMachine_Machine] on [dbo].[DeploymentRelatedMachine]'
GO
CREATE NONCLUSTERED INDEX [IX_DeploymentRelatedMachine_Machine] ON [dbo].[DeploymentRelatedMachine] ([MachineId]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Event]'
GO
CREATE TABLE [dbo].[Event]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RelatedDocumentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EnvironmentId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Username] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Occurred] [datetimeoffset] NOT NULL,
[Message] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AutoId] [bigint] NOT NULL IDENTITY(1, 1),
[DataVersion] [timestamp] NOT NULL,
[UserAgent] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Event_Id] on [dbo].[Event]'
GO
ALTER TABLE [dbo].[Event] ADD CONSTRAINT [PK_Event_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Event_AutoId] on [dbo].[Event]'
GO
CREATE NONCLUSTERED INDEX [IX_Event_AutoId] ON [dbo].[Event] ([AutoId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Event_Category_AutoId] on [dbo].[Event]'
GO
CREATE NONCLUSTERED INDEX [IX_Event_Category_AutoId] ON [dbo].[Event] ([Category], [AutoId]) INCLUDE ([Id], [Occurred], [RelatedDocumentIds]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Event_DataVersion] on [dbo].[Event]'
GO
CREATE NONCLUSTERED INDEX [IX_Event_DataVersion] ON [dbo].[Event] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Event_Occurred] on [dbo].[Event]'
GO
CREATE NONCLUSTERED INDEX [IX_Event_Occurred] ON [dbo].[Event] ([Occurred]) INCLUDE ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Event_CommonSearch] on [dbo].[Event]'
GO
CREATE NONCLUSTERED INDEX [IX_Event_CommonSearch] ON [dbo].[Event] ([ProjectId], [EnvironmentId], [Category], [UserId], [Occurred], [TenantId]) INCLUDE ([Id], [RelatedDocumentIds]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Event_UserAgent] on [dbo].[Event]'
GO
CREATE NONCLUSTERED INDEX [IX_Event_UserAgent] ON [dbo].[Event] ([UserAgent]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[EventRelatedDocument]'
GO
CREATE TABLE [dbo].[EventRelatedDocument]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RelatedDocumentId] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_EventRelatedDocument] on [dbo].[EventRelatedDocument]'
GO
ALTER TABLE [dbo].[EventRelatedDocument] ADD CONSTRAINT [PK_EventRelatedDocument] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_EventRelatedDocument_EventId] on [dbo].[EventRelatedDocument]'
GO
CREATE NONCLUSTERED INDEX [IX_EventRelatedDocument_EventId] ON [dbo].[EventRelatedDocument] ([EventId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_EventRelatedDocument_RelatedDocumentId] on [dbo].[EventRelatedDocument]'
GO
CREATE NONCLUSTERED INDEX [IX_EventRelatedDocument_RelatedDocumentId] ON [dbo].[EventRelatedDocument] ([RelatedDocumentId]) INCLUDE ([EventId]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[WorkerPool]'
GO
CREATE TABLE [dbo].[WorkerPool]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SortOrder] [int] NOT NULL,
[IsDefault] [bit] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_WorkerPool_Id] on [dbo].[WorkerPool]'
GO
ALTER TABLE [dbo].[WorkerPool] ADD CONSTRAINT [PK_WorkerPool_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_WorkerPool_DataVersion] on [dbo].[WorkerPool]'
GO
CREATE NONCLUSTERED INDEX [IX_WorkerPool_DataVersion] ON [dbo].[WorkerPool] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[WorkerPool]'
GO
ALTER TABLE [dbo].[WorkerPool] ADD CONSTRAINT [UQ_WorkerPoolNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[VariableSet]'
GO
CREATE TABLE [dbo].[VariableSet]
(
[Id] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OwnerId] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [int] NOT NULL,
[IsFrozen] [bit] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RelatedDocumentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_VariableSet_Id] on [dbo].[VariableSet]'
GO
ALTER TABLE [dbo].[VariableSet] ADD CONSTRAINT [PK_VariableSet_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[UserRole]'
GO
CREATE TABLE [dbo].[UserRole]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_UserRole_Id] on [dbo].[UserRole]'
GO
ALTER TABLE [dbo].[UserRole] ADD CONSTRAINT [PK_UserRole_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[UserRole]'
GO
ALTER TABLE [dbo].[UserRole] ADD CONSTRAINT [UQ_UserRoleNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[User]'
GO
CREATE TABLE [dbo].[User]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Username] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[IsService] [bit] NOT NULL,
[IdentificationToken] [uniqueidentifier] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmailAddress] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalId] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalIdentifiers] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_User_Id] on [dbo].[User]'
GO
ALTER TABLE [dbo].[User] ADD CONSTRAINT [PK_User_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_User_DisplayName] on [dbo].[User]'
GO
CREATE NONCLUSTERED INDEX [IX_User_DisplayName] ON [dbo].[User] ([DisplayName]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_User_EmailAddress] on [dbo].[User]'
GO
CREATE NONCLUSTERED INDEX [IX_User_EmailAddress] ON [dbo].[User] ([EmailAddress]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_User_ExternalId] on [dbo].[User]'
GO
CREATE NONCLUSTERED INDEX [IX_User_ExternalId] ON [dbo].[User] ([ExternalId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_User_IdentificationToken] on [dbo].[User]'
GO
CREATE NONCLUSTERED INDEX [IX_User_IdentificationToken] ON [dbo].[User] ([IdentificationToken]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[User]'
GO
ALTER TABLE [dbo].[User] ADD CONSTRAINT [UQ_UserUsernameUnique] UNIQUE NONCLUSTERED  ([Username]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Tenant]'
GO
CREATE TABLE [dbo].[Tenant]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantTags] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Tenant_Id] on [dbo].[Tenant]'
GO
ALTER TABLE [dbo].[Tenant] ADD CONSTRAINT [PK_Tenant_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Tenant_DataVersion] on [dbo].[Tenant]'
GO
CREATE NONCLUSTERED INDEX [IX_Tenant_DataVersion] ON [dbo].[Tenant] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Tenant]'
GO
ALTER TABLE [dbo].[Tenant] ADD CONSTRAINT [UQ_TenantName] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Team]'
GO
CREATE TABLE [dbo].[Team]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MemberUserIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EnvironmentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantTags] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectGroupIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Team_Id] on [dbo].[Team]'
GO
ALTER TABLE [dbo].[Team] ADD CONSTRAINT [PK_Team_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Team]'
GO
ALTER TABLE [dbo].[Team] ADD CONSTRAINT [UQ_TeamNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[TagSet]'
GO
CREATE TABLE [dbo].[TagSet]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SortOrder] [int] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_TagSet_Id] on [dbo].[TagSet]'
GO
ALTER TABLE [dbo].[TagSet] ADD CONSTRAINT [PK_TagSet_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_TagSet_DataVersion] on [dbo].[TagSet]'
GO
CREATE NONCLUSTERED INDEX [IX_TagSet_DataVersion] ON [dbo].[TagSet] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[TagSet]'
GO
ALTER TABLE [dbo].[TagSet] ADD CONSTRAINT [UQ_TagSetName] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Subscription]'
GO
CREATE TABLE [dbo].[Subscription]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDisabled] [bit] NOT NULL CONSTRAINT [DF__Subscript__IsDis__503BEA1C] DEFAULT ((0)),
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Subscription_Id] on [dbo].[Subscription]'
GO
ALTER TABLE [dbo].[Subscription] ADD CONSTRAINT [PK_Subscription_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Subscription]'
GO
ALTER TABLE [dbo].[Subscription] ADD CONSTRAINT [UQ_SubscriptionNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Release]'
GO
CREATE TABLE [dbo].[Release]
(
[Id] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Assembled] [datetimeoffset] NOT NULL,
[ProjectId] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectVariableSetSnapshotId] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectDeploymentProcessSnapshotId] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChannelId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Release_Id] on [dbo].[Release]'
GO
ALTER TABLE [dbo].[Release] ADD CONSTRAINT [PK_Release_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Release_Assembled] on [dbo].[Release]'
GO
CREATE NONCLUSTERED INDEX [IX_Release_Assembled] ON [dbo].[Release] ([Assembled] DESC) INCLUDE ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Release_DataVersion] on [dbo].[Release]'
GO
CREATE NONCLUSTERED INDEX [IX_Release_DataVersion] ON [dbo].[Release] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Release_ProjectDeploymentProcessSnapshotId] on [dbo].[Release]'
GO
CREATE NONCLUSTERED INDEX [IX_Release_ProjectDeploymentProcessSnapshotId] ON [dbo].[Release] ([ProjectDeploymentProcessSnapshotId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Release_ProjectId_ChannelId_Assembled] on [dbo].[Release]'
GO
CREATE NONCLUSTERED INDEX [IX_Release_ProjectId_ChannelId_Assembled] ON [dbo].[Release] ([ProjectId], [ChannelId], [Assembled] DESC) INCLUDE ([Id], [JSON], [ProjectDeploymentProcessSnapshotId], [ProjectVariableSetSnapshotId], [Version]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Release_ProjectId_Version_Assembled] on [dbo].[Release]'
GO
CREATE NONCLUSTERED INDEX [IX_Release_ProjectId_Version_Assembled] ON [dbo].[Release] ([ProjectId], [Version], [Assembled] DESC) INCLUDE ([ChannelId], [Id], [JSON], [ProjectDeploymentProcessSnapshotId], [ProjectVariableSetSnapshotId]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Release]'
GO
ALTER TABLE [dbo].[Release] ADD CONSTRAINT [UQ_ReleaseVersionUnique] UNIQUE NONCLUSTERED  ([Version], [ProjectId]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Proxy]'
GO
CREATE TABLE [dbo].[Proxy]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Proxy_Id] on [dbo].[Proxy]'
GO
ALTER TABLE [dbo].[Proxy] ADD CONSTRAINT [PK_Proxy_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Proxy]'
GO
ALTER TABLE [dbo].[Proxy] ADD CONSTRAINT [UQ_ProxyNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[ProjectTrigger]'
GO
CREATE TABLE [dbo].[ProjectTrigger]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TriggerType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDisabled] [bit] NOT NULL CONSTRAINT [DF__ProjectTr__IsDis__681373AD] DEFAULT ((0))
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_ProjectTrigger_Id] on [dbo].[ProjectTrigger]'
GO
ALTER TABLE [dbo].[ProjectTrigger] ADD CONSTRAINT [PK_ProjectTrigger_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_ProjectTrigger_Project] on [dbo].[ProjectTrigger]'
GO
CREATE NONCLUSTERED INDEX [IX_ProjectTrigger_Project] ON [dbo].[ProjectTrigger] ([ProjectId]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[ProjectTrigger]'
GO
ALTER TABLE [dbo].[ProjectTrigger] ADD CONSTRAINT [UQ_ProjectTriggerNameUnique] UNIQUE NONCLUSTERED  ([ProjectId], [Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[ProjectGroup]'
GO
CREATE TABLE [dbo].[ProjectGroup]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_ProjectGroup_Id] on [dbo].[ProjectGroup]'
GO
ALTER TABLE [dbo].[ProjectGroup] ADD CONSTRAINT [PK_ProjectGroup_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_ProjectGroup_DataVersion] on [dbo].[ProjectGroup]'
GO
CREATE NONCLUSTERED INDEX [IX_ProjectGroup_DataVersion] ON [dbo].[ProjectGroup] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[ProjectGroup]'
GO
ALTER TABLE [dbo].[ProjectGroup] ADD CONSTRAINT [UQ_ProjectGroupNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Project]'
GO
CREATE TABLE [dbo].[Project]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Slug] [nvarchar] (210) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDisabled] [bit] NOT NULL,
[VariableSetId] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeploymentProcessId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectGroupId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LifecycleId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AutoCreateRelease] [bit] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IncludedLibraryVariableSetIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiscreteChannelRelease] [bit] NOT NULL CONSTRAINT [DF__Project__Discret__5CA1C101] DEFAULT ((0)),
[DataVersion] [timestamp] NOT NULL,
[ClonedFromProjectId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Project_Id] on [dbo].[Project]'
GO
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [PK_Project_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Project_ClonedFromProjectId] on [dbo].[Project]'
GO
CREATE NONCLUSTERED INDEX [IX_Project_ClonedFromProjectId] ON [dbo].[Project] ([ClonedFromProjectId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Project_DataVersion] on [dbo].[Project]'
GO
CREATE NONCLUSTERED INDEX [IX_Project_DataVersion] ON [dbo].[Project] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Project_DiscreteChannelRelease] on [dbo].[Project]'
GO
CREATE NONCLUSTERED INDEX [IX_Project_DiscreteChannelRelease] ON [dbo].[Project] ([Id]) INCLUDE ([DiscreteChannelRelease]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Project]'
GO
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [UQ_ProjectNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Project]'
GO
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [UQ_ProjectSlugUnique] UNIQUE NONCLUSTERED  ([Slug]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[OctopusServerNode]'
GO
CREATE TABLE [dbo].[OctopusServerNode]
(
[Id] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastSeen] [datetimeoffset] NOT NULL,
[Rank] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MaxConcurrentTasks] [int] NOT NULL CONSTRAINT [DF_OctopusServerNode_MaxConTasks] DEFAULT ((5)),
[IsInMaintenanceMode] [bit] NOT NULL CONSTRAINT [DF_OctopusServerNode_IsMaintMode] DEFAULT ((0))
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_OctopusServerNode_Id] on [dbo].[OctopusServerNode]'
GO
ALTER TABLE [dbo].[OctopusServerNode] ADD CONSTRAINT [PK_OctopusServerNode_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[NuGetPackage]'
GO
CREATE TABLE [dbo].[NuGetPackage]
(
[Id] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PackageId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [nvarchar] (349) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VersionMajor] [int] NOT NULL,
[VersionMinor] [int] NOT NULL,
[VersionBuild] [int] NOT NULL,
[VersionRevision] [int] NOT NULL,
[VersionSpecial] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_NuGetPackage_Id] on [dbo].[NuGetPackage]'
GO
ALTER TABLE [dbo].[NuGetPackage] ADD CONSTRAINT [PK_NuGetPackage_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[MachinePolicy]'
GO
CREATE TABLE [dbo].[MachinePolicy]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF__MachinePo__IsDef__339FAB6E] DEFAULT ((0)),
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_MachinePolicy_Id] on [dbo].[MachinePolicy]'
GO
ALTER TABLE [dbo].[MachinePolicy] ADD CONSTRAINT [PK_MachinePolicy_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[MachinePolicy]'
GO
ALTER TABLE [dbo].[MachinePolicy] ADD CONSTRAINT [UQ_MachinePolicy] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Machine]'
GO
CREATE TABLE [dbo].[Machine]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDisabled] [bit] NOT NULL,
[Roles] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EnvironmentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MachinePolicyId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantTags] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Thumbprint] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fingerprint] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommunicationStyle] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Machine_Id] on [dbo].[Machine]'
GO
ALTER TABLE [dbo].[Machine] ADD CONSTRAINT [PK_Machine_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Machine_DataVersion] on [dbo].[Machine]'
GO
CREATE NONCLUSTERED INDEX [IX_Machine_DataVersion] ON [dbo].[Machine] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Machine_MachinePolicy] on [dbo].[Machine]'
GO
CREATE NONCLUSTERED INDEX [IX_Machine_MachinePolicy] ON [dbo].[Machine] ([MachinePolicyId]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Machine]'
GO
ALTER TABLE [dbo].[Machine] ADD CONSTRAINT [UQ_MachineNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Lifecycle]'
GO
CREATE TABLE [dbo].[Lifecycle]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Lifecycle_Id] on [dbo].[Lifecycle]'
GO
ALTER TABLE [dbo].[Lifecycle] ADD CONSTRAINT [PK_Lifecycle_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Lifecycle_DataVersion] on [dbo].[Lifecycle]'
GO
CREATE NONCLUSTERED INDEX [IX_Lifecycle_DataVersion] ON [dbo].[Lifecycle] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Lifecycle]'
GO
ALTER TABLE [dbo].[Lifecycle] ADD CONSTRAINT [UQ_LifecycleNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[LibraryVariableSet]'
GO
CREATE TABLE [dbo].[LibraryVariableSet]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VariableSetId] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContentType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_LibraryVariableSet_Id] on [dbo].[LibraryVariableSet]'
GO
ALTER TABLE [dbo].[LibraryVariableSet] ADD CONSTRAINT [PK_LibraryVariableSet_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[LibraryVariableSet]'
GO
ALTER TABLE [dbo].[LibraryVariableSet] ADD CONSTRAINT [UQ_LibraryVariableSetNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Invitation]'
GO
CREATE TABLE [dbo].[Invitation]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvitationCode] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Invitation_Id] on [dbo].[Invitation]'
GO
ALTER TABLE [dbo].[Invitation] ADD CONSTRAINT [PK_Invitation_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Interruption]'
GO
CREATE TABLE [dbo].[Interruption]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetimeoffset] NOT NULL,
[Title] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RelatedDocumentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ResponsibleTeamIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EnvironmentId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaskId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Interruption_Id] on [dbo].[Interruption]'
GO
ALTER TABLE [dbo].[Interruption] ADD CONSTRAINT [PK_Interruption_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Interruption_DataVersion] on [dbo].[Interruption]'
GO
CREATE NONCLUSTERED INDEX [IX_Interruption_DataVersion] ON [dbo].[Interruption] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Interruption_TenantId] on [dbo].[Interruption]'
GO
CREATE NONCLUSTERED INDEX [IX_Interruption_TenantId] ON [dbo].[Interruption] ([TenantId]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Feed]'
GO
CREATE TABLE [dbo].[Feed]
(
[Id] [nvarchar] (210) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FeedUri] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FeedType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Feed_Id] on [dbo].[Feed]'
GO
ALTER TABLE [dbo].[Feed] ADD CONSTRAINT [PK_Feed_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Feed_DataVersion] on [dbo].[Feed]'
GO
CREATE NONCLUSTERED INDEX [IX_Feed_DataVersion] ON [dbo].[Feed] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Feed]'
GO
ALTER TABLE [dbo].[Feed] ADD CONSTRAINT [UQ_FeedNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[DeploymentProcess]'
GO
CREATE TABLE [dbo].[DeploymentProcess]
(
[Id] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OwnerId] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsFrozen] [bit] NOT NULL,
[Version] [int] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RelatedDocumentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_DeploymentProcess_Id] on [dbo].[DeploymentProcess]'
GO
ALTER TABLE [dbo].[DeploymentProcess] ADD CONSTRAINT [PK_DeploymentProcess_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[DeploymentEnvironment]'
GO
CREATE TABLE [dbo].[DeploymentEnvironment]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SortOrder] [int] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_DeploymentEnvironment_Id] on [dbo].[DeploymentEnvironment]'
GO
ALTER TABLE [dbo].[DeploymentEnvironment] ADD CONSTRAINT [PK_DeploymentEnvironment_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_DeploymentEnvironment_DataVersion] on [dbo].[DeploymentEnvironment]'
GO
CREATE NONCLUSTERED INDEX [IX_DeploymentEnvironment_DataVersion] ON [dbo].[DeploymentEnvironment] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[DeploymentEnvironment]'
GO
ALTER TABLE [dbo].[DeploymentEnvironment] ADD CONSTRAINT [UQ_DeploymentEnvironmentNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[DashboardConfiguration]'
GO
CREATE TABLE [dbo].[DashboardConfiguration]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IncludedEnvironmentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IncludedProjectIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IncludedTenantTags] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IncludedTenantIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_DashboardConfiguration_Id] on [dbo].[DashboardConfiguration]'
GO
ALTER TABLE [dbo].[DashboardConfiguration] ADD CONSTRAINT [PK_DashboardConfiguration_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Configuration]'
GO
CREATE TABLE [dbo].[Configuration]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Configuration_Id] on [dbo].[Configuration]'
GO
ALTER TABLE [dbo].[Configuration] ADD CONSTRAINT [PK_Configuration_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[CommunityActionTemplate]'
GO
CREATE TABLE [dbo].[CommunityActionTemplate]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExternalId] [uniqueidentifier] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_CommunityActionTemplate_Id] on [dbo].[CommunityActionTemplate]'
GO
ALTER TABLE [dbo].[CommunityActionTemplate] ADD CONSTRAINT [PK_CommunityActionTemplate_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[CommunityActionTemplate]'
GO
ALTER TABLE [dbo].[CommunityActionTemplate] ADD CONSTRAINT [UQ_CommunityActionTemplateExternalId] UNIQUE NONCLUSTERED  ([ExternalId]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[CommunityActionTemplate]'
GO
ALTER TABLE [dbo].[CommunityActionTemplate] ADD CONSTRAINT [UQ_CommunityActionTemplateName] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Channel]'
GO
CREATE TABLE [dbo].[Channel]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LifecycleId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantTags] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Channel_Id] on [dbo].[Channel]'
GO
ALTER TABLE [dbo].[Channel] ADD CONSTRAINT [PK_Channel_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Channel_DataVersion] on [dbo].[Channel]'
GO
CREATE NONCLUSTERED INDEX [IX_Channel_DataVersion] ON [dbo].[Channel] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Channel]'
GO
ALTER TABLE [dbo].[Channel] ADD CONSTRAINT [UQ_ChannelUniqueNamePerProject] UNIQUE NONCLUSTERED  ([Name], [ProjectId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Channel_ProjectId] on [dbo].[Channel]'
GO
CREATE NONCLUSTERED INDEX [IX_Channel_ProjectId] ON [dbo].[Channel] ([ProjectId]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Certificate]'
GO
CREATE TABLE [dbo].[Certificate]
(
[Id] [varchar] (210) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Thumbprint] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NotAfter] [datetimeoffset] (0) NOT NULL,
[Subject] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EnvironmentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantTags] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Archived] [datetimeoffset] (0) NULL,
[Created] [datetimeoffset] (0) NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Certificate_Id] on [dbo].[Certificate]'
GO
ALTER TABLE [dbo].[Certificate] ADD CONSTRAINT [PK_Certificate_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Certificate_Created] on [dbo].[Certificate]'
GO
CREATE NONCLUSTERED INDEX [IX_Certificate_Created] ON [dbo].[Certificate] ([Created]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Certificate_DataVersion] on [dbo].[Certificate]'
GO
CREATE NONCLUSTERED INDEX [IX_Certificate_DataVersion] ON [dbo].[Certificate] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Certificate_NotAfter] on [dbo].[Certificate]'
GO
CREATE NONCLUSTERED INDEX [IX_Certificate_NotAfter] ON [dbo].[Certificate] ([NotAfter]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Certificate_Thumbprint] on [dbo].[Certificate]'
GO
CREATE NONCLUSTERED INDEX [IX_Certificate_Thumbprint] ON [dbo].[Certificate] ([Thumbprint]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[ApiKey]'
GO
CREATE TABLE [dbo].[ApiKey]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApiKeyHashed] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetimeoffset] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_ApiKey_Id] on [dbo].[ApiKey]'
GO
ALTER TABLE [dbo].[ApiKey] ADD CONSTRAINT [PK_ApiKey_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[ApiKey]'
GO
ALTER TABLE [dbo].[ApiKey] ADD CONSTRAINT [UQ_ApiKeyUnique] UNIQUE NONCLUSTERED  ([ApiKeyHashed]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[ActionTemplateVersion]'
GO
CREATE TABLE [dbo].[ActionTemplateVersion]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [int] NOT NULL,
[LatestActionTemplateId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActionType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_ActionTemplateVersion_Id] on [dbo].[ActionTemplateVersion]'
GO
ALTER TABLE [dbo].[ActionTemplateVersion] ADD CONSTRAINT [PK_ActionTemplateVersion_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_ActionTemplateVersion_LatestActionTemplateId] on [dbo].[ActionTemplateVersion]'
GO
CREATE NONCLUSTERED INDEX [IX_ActionTemplateVersion_LatestActionTemplateId] ON [dbo].[ActionTemplateVersion] ([LatestActionTemplateId]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[ActionTemplateVersion]'
GO
ALTER TABLE [dbo].[ActionTemplateVersion] ADD CONSTRAINT [UQ_ActionTemplateVersionUniqueNameVersion] UNIQUE NONCLUSTERED  ([Name], [Version]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[ActionTemplate]'
GO
CREATE TABLE [dbo].[ActionTemplate]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [int] NOT NULL,
[ActionType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CommunityActionTemplateId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_ActionTemplate_Id] on [dbo].[ActionTemplate]'
GO
ALTER TABLE [dbo].[ActionTemplate] ADD CONSTRAINT [PK_ActionTemplate_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[ActionTemplate]'
GO
ALTER TABLE [dbo].[ActionTemplate] ADD CONSTRAINT [UQ_ActionTemplateUniqueName] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Account]'
GO
CREATE TABLE [dbo].[Account]
(
[Id] [nvarchar] (210) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EnvironmentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantTags] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Account_Id] on [dbo].[Account]'
GO
ALTER TABLE [dbo].[Account] ADD CONSTRAINT [PK_Account_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Account]'
GO
ALTER TABLE [dbo].[Account] ADD CONSTRAINT [UQ_AccountUniqueName] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[IdsInUse]'
GO
------------------------------------------------
-- Finally, update the IdsInUse table
------------------------------------------------


CREATE VIEW [dbo].[IdsInUse] AS
  SELECT [Id], 'Account' AS [Type] , [Name] FROM dbo.[Account] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'ActionTemplate' AS [Type] , [Name] FROM dbo.[ActionTemplate] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'ActionTemplateVersion' AS [Type] , [Name] FROM dbo.ActionTemplateVersion WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'ApiKey' AS [Type] , [ApiKeyHashed] as [Name] FROM dbo.[ApiKey] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Certificate' AS [Type] , [Name] FROM dbo.[Certificate] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Channel' AS [Type] , [Name] FROM dbo.[Channel] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'CommunityActionTemplate' AS [Type] , [Name] FROM dbo.CommunityActionTemplate WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'ActivityLogStorageConfiguration, ArtifactStorageConfiguration, BuiltInRepositoryConfiguration, FeaturesConfiguration, License, MaintenanceConfiguration, ScheduleConfiguration, ServerConfiguration, SmtpConfiguration, UpgradeAvailability, UpgradeConfiguration' AS [Type] , '' AS [Name] FROM dbo.[Configuration] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'DashboardConfiguration' AS [Type] , '' AS [Name] FROM dbo.[DashboardConfiguration] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'DeploymentEnvironment' AS [Type] , [Name] FROM dbo.[DeploymentEnvironment] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'DeploymentProcess' AS [Type] , '' AS [Name] FROM dbo.[DeploymentProcess] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Feed' AS [Type] , [Name] FROM dbo.[Feed] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Interruption' AS [Type] , '' AS [Name] FROM dbo.[Interruption] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Invitation' AS [Type] , '' AS [Name] FROM dbo.[Invitation] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'LibraryVariableSet' AS [Type] , [Name] FROM dbo.[LibraryVariableSet] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Lifecycle' AS [Type] , [Name] FROM dbo.[Lifecycle] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Machine' AS [Type] , [Name] FROM dbo.[Machine] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'MachinePolicy' AS [Type] , [Name] FROM dbo.[MachinePolicy] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'IndexedPackage' AS [Type] , '' AS [Name] FROM dbo.[NuGetPackage] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'OctopusServerNode' AS [Type] , [Name] FROM dbo.[OctopusServerNode] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Project' AS [Type] , [Name] FROM dbo.[Project] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'ProjectGroup' AS [Type] , [Name] FROM dbo.[ProjectGroup] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'ProjectTrigger' AS [Type] , [Name] FROM dbo.[ProjectTrigger] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Proxy' AS [Type] , [Name] FROM dbo.[Proxy] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Release' AS [Type] , '' AS [Name] FROM dbo.[Release] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Subscription' AS [Type] , [Name] FROM dbo.[Subscription] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'TagSet' AS [Type] , [Name] FROM dbo.[TagSet] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Team' AS [Type] , [Name] FROM dbo.[Team] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'Tenant' AS [Type] , [Name] FROM dbo.[Tenant] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'User' AS [Type] , [Username] as [Name] FROM dbo.[User] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'UserRole' AS [Type] , [Name] FROM dbo.[UserRole] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'VariableSet' AS [Type] , '' AS [Name] FROM dbo.[VariableSet] WITH (NOLOCK)
  UNION ALL
  SELECT [Id], 'WorkerPool' AS [Type] , '' AS [Name] FROM dbo.[WorkerPool] WITH (NOLOCK)
GO
PRINT N'Creating [dbo].[ServerTask]'
GO
CREATE TABLE [dbo].[ServerTask]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QueueTime] [datetimeoffset] NOT NULL,
[StartTime] [datetimeoffset] NULL,
[CompletedTime] [datetimeoffset] NULL,
[ErrorMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConcurrencyTag] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HasPendingInterruptions] [bit] NOT NULL,
[HasWarningsOrErrors] [bit] NOT NULL,
[ServerNodeId] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EnvironmentId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DurationSeconds] [int] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_ServerTask_Id] on [dbo].[ServerTask]'
GO
ALTER TABLE [dbo].[ServerTask] ADD CONSTRAINT [PK_ServerTask_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_ServerTask_ProjectDataVersion] on [dbo].[ServerTask]'
GO
CREATE NONCLUSTERED INDEX [IX_ServerTask_ProjectDataVersion] ON [dbo].[ServerTask] ([DataVersion], [ProjectId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_ServerTask_TaskQueue_QueueTimeState] on [dbo].[ServerTask]'
GO
CREATE NONCLUSTERED INDEX [IX_ServerTask_TaskQueue_QueueTimeState] ON [dbo].[ServerTask] ([QueueTime] DESC, [Id] DESC, [State] DESC) INCLUDE ([CompletedTime], [StartTime]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_ServerTask_TaskQueue_PopTask] on [dbo].[ServerTask]'
GO
CREATE NONCLUSTERED INDEX [IX_ServerTask_TaskQueue_PopTask] ON [dbo].[ServerTask] ([QueueTime], [State], [ConcurrencyTag], [HasPendingInterruptions], [ServerNodeId]) INCLUDE ([CompletedTime], [Description], [DurationSeconds], [EnvironmentId], [ErrorMessage], [HasWarningsOrErrors], [JSON], [Name], [ProjectId], [StartTime], [TenantId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_ServerTask_TaskQueue_GetActiveConcurrencyTags] on [dbo].[ServerTask]'
GO
CREATE NONCLUSTERED INDEX [IX_ServerTask_TaskQueue_GetActiveConcurrencyTags] ON [dbo].[ServerTask] ([State], [ConcurrencyTag]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_ServerTask_Common] on [dbo].[ServerTask]'
GO
CREATE NONCLUSTERED INDEX [IX_ServerTask_Common] ON [dbo].[ServerTask] ([State], [Name], [ProjectId], [EnvironmentId], [TenantId], [ServerNodeId], [Id]) INCLUDE ([CompletedTime], [ConcurrencyTag], [Description], [DurationSeconds], [HasPendingInterruptions], [HasWarningsOrErrors], [QueueTime], [StartTime]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Dashboard]'
GO
CREATE VIEW [dbo].[Dashboard] AS
	SELECT 
		d.Id as Id,
		d.Created as Created,
		d.ProjectId as ProjectId,
		d.EnvironmentId as EnvironmentId,
		d.ReleaseId as ReleaseId,
		d.TaskId as TaskId,
		d.ChannelId as ChannelId,
		CurrentOrPrevious,
		t.[State] as [State],
		t.HasPendingInterruptions as HasPendingInterruptions,
		t.HasWarningsOrErrors as HasWarningsOrErrors,
		t.ErrorMessage as ErrorMessage,
		t.QueueTime as QueueTime,
		t.StartTime as StartTime,
		t.CompletedTime as CompletedTime,
		r.[Version] as [Version]
	FROM (
		SELECT 
			'C' AS CurrentOrPrevious,
			d.Id as Id,
			d.Created as Created,
			d.ProjectId as ProjectId,
			d.EnvironmentId as EnvironmentId,
			d.ReleaseId as ReleaseId,
			d.TaskId as TaskId,
			d.ChannelId as ChannelId,		
			ROW_NUMBER() OVER (PARTITION BY d.EnvironmentId, d.ProjectId ORDER BY Created DESC) as [Rank]
		FROM [Deployment] d
		INNER JOIN
		[ServerTask] t ON t.Id = d .TaskId
		WHERE NOT ((t.State = 'Canceled' OR t.State = 'Cancelling') AND t.StartTime IS NULL)
		UNION
		SELECT 
			'P' AS CurrentOrPrevious, 
			d.Id as Id,
			d.Created as Created,
			d.ProjectId as ProjectId,
			d.EnvironmentId as EnvironmentId,
			d.ReleaseId as ReleaseId,
			d.TaskId as TaskId,
			d.ChannelId as ChannelId,
			ROW_NUMBER() OVER (PARTITION BY d.EnvironmentId, d.ProjectId ORDER BY Created DESC) as [Rank]
		FROM [Deployment] d
		INNER JOIN [ServerTask] t on t.Id = d.TaskId
		LEFT HASH JOIN (
				SELECT Id 
				FROM (
					SELECT 
						d.Id as Id, 
						ROW_NUMBER() OVER (PARTITION BY d.EnvironmentId, d.ProjectId ORDER BY Created DESC) as [Rank] 
					FROM [Deployment] d
					INNER JOIN					[ServerTask] t ON t.Id = d .TaskId
					WHERE NOT ((t.State = 'Canceled' OR t.State = 'Cancelling') AND t.StartTime IS NULL)
				) LatestDeployment 
				WHERE [Rank]=1
		) l ON d.Id = l.Id
		WHERE 
			t.State = 'Success' AND 
			l.Id is null
	 ) d 
	 INNER JOIN [ServerTask] t on t.Id = d.TaskId
	 INNER JOIN [Release] r on r.Id = d.ReleaseId
	 WHERE ([Rank]=1 AND CurrentOrPrevious='P') OR ([Rank]=1 AND CurrentOrPrevious='C')
GO
PRINT N'Creating [dbo].[KeyAllocation]'
GO
CREATE TABLE [dbo].[KeyAllocation]
(
[CollectionName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Allocated] [int] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_KeyAllocation_CollectionName] on [dbo].[KeyAllocation]'
GO
ALTER TABLE [dbo].[KeyAllocation] ADD CONSTRAINT [PK_KeyAllocation_CollectionName] PRIMARY KEY CLUSTERED  ([CollectionName]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[GetNextKeyBlock]'
GO
-- Alter Procedure GetNextBlock to not return multiple result sets when the first block is requested
CREATE PROCEDURE [dbo].[GetNextKeyBlock] 
(
	@collectionName nvarchar(50),
	@blockSize int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @result int
	
	UPDATE KeyAllocation
		SET @result = Allocated = (Allocated + @blockSize)
		WHERE CollectionName = @collectionName
	
	if (@@ROWCOUNT = 0)
	begin
		INSERT INTO KeyAllocation (CollectionName, Allocated) values (@collectionName, @blockSize)
		SET @result = @blockSize
	end

	SELECT @result
END
GO
PRINT N'Creating [dbo].[Release_WithDeploymentProcess]'
GO
CREATE VIEW [dbo].[Release_WithDeploymentProcess]
AS
SELECT [Release].[Id] as Release_Id
      ,[Release].[Version] as Release_Version
      ,[Release].[Assembled] as Release_Assembled
      ,[Release].[ProjectId] as Release_ProjectId
      ,[Release].[ChannelId] as Release_ChannelId
      ,[Release].[ProjectVariableSetSnapshotId] as Release_ProjectVariableSetSnapshotId
      ,[Release].[ProjectDeploymentProcessSnapshotId] as Release_ProjectDeploymentProcessSnapshotId
      ,[Release].[JSON] as Release_JSON
      ,DP.[Id] as DeploymentProcess_Id
      ,DP.[OwnerId] as DeploymentProcess_OwnerId
      ,DP.[IsFrozen] as DeploymentProcess_IsFrozen
      ,DP.[Version] as DeploymentProcess_Version
      ,DP.[JSON] as DeploymentProcess_JSON
	  ,DP.[RelatedDocumentIds] AS DeploymentProcess_RelatedDocumentIds
	  ,Project.Name AS Project_Name
  FROM [dbo].[Release] as Release
  INNER JOIN [dbo].[DeploymentProcess] as DP on DP.[Id] = [Release].[ProjectDeploymentProcessSnapshotId]
  INNER JOIN [dbo].[Project] as Project on Project.[Id] = [Release].[ProjectId]
GO
PRINT N'Creating [dbo].[DeploymentHistory]'
GO
CREATE TABLE [dbo].[DeploymentHistory]
(
[DeploymentId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeploymentName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectSlug] [nvarchar] (210) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EnvironmentId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EnvironmentName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReleaseId] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReleaseVersion] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaskId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaskState] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetimeoffset] NOT NULL,
[QueueTime] [datetimeoffset] NOT NULL,
[StartTime] [datetimeoffset] NULL,
[CompletedTime] [datetimeoffset] NULL,
[DurationSeconds] [int] NULL,
[DeployedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChannelId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChannelName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_DeploymentHistory_DeploymentId] on [dbo].[DeploymentHistory]'
GO
ALTER TABLE [dbo].[DeploymentHistory] ADD CONSTRAINT [PK_DeploymentHistory_DeploymentId] PRIMARY KEY CLUSTERED  ([DeploymentId]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_DeploymentHistory_Created] on [dbo].[DeploymentHistory]'
GO
CREATE NONCLUSTERED INDEX [IX_DeploymentHistory_Created] ON [dbo].[DeploymentHistory] ([Created]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[UpdateDeploymentHistory]'
GO
CREATE procedure [dbo].[UpdateDeploymentHistory] (
	@quick bit = 1
)
as 
begin
	declare @lastCreated datetimeoffset
	
	select @lastCreated = MAX(Created) from DeploymentHistory
	
	if (@quick = 0)
	begin
		set @lastCreated = NULL
	end

	merge DeploymentHistory as target
	using (select 
		d.Id as DeploymentId,
		d.Name as DeploymentName, 
		p.Id as ProjectId, 
		p.Name as ProjectName, 
		p.Slug as ProjectSlug,
		c.Id as ChannelId,
		c.Name as ChannelName,
		tenant.Id as TenantId,
		tenant.Name as TenantName,
		env.Id as EnvironmentId, 
		env.Name as EnvironmentName, 
		r.Id as ReleaseId, 
		r.Version as ReleaseVersion,
		t.Id as TaskId, 
		t.State as TaskState,
		d.Created as Created,
		t.QueueTime as QueueTime,
		t.StartTime as StartTime,
		t.CompletedTime as CompletedTime,
		(case t.CompletedTime 
			when null then null 
			else (DATEDIFF(SECOND, QueueTime, CompletedTime)) 
		end) as DurationSeconds,
		d.DeployedBy as DeployedBy
		from Deployment d
		inner join Release r on (r.Id = d.ReleaseId)
		inner join ServerTask t on (t.Id = d.TaskId)
		inner join Project p on (p.Id = d.ProjectId)
		inner join DeploymentEnvironment env on (env.Id = d.EnvironmentId)
		inner join Channel c on (c.Id = r.ChannelId)
		left join tenant on (d.tenantId = tenant.Id)
		where t.State not in ('Queued', 'Cancelling', 'Canceling', 'Executing')
			and (@lastCreated is null or 
				-- Call the last task ever created 'T'. 
				-- Tasks that finished after T (including T or any other task that started after) should be included.
				-- Tasks that finished before T should have already been caught the last time we updated the history, 
				-- because they must have completed before T-1.
				(d.Created >= @lastCreated or 
				 t.CompletedTime >= @lastCreated)
			)
		) as source(DeploymentId, DeploymentName, ProjectId, ProjectName, ProjectSlug, ChannelId, ChannelName, TenantId, TenantName, EnvironmentId, EnvironmentName, ReleaseId, ReleaseVersion, TaskId, TaskState, Created, QueueTime, StartTime, CompletedTime, DurationSeconds, DeployedBy)
	on (target.DeploymentId = source.DeploymentId)
	when matched then UPDATE SET 
			ProjectId = source.ProjectId,
			ProjectName = source.ProjectName,
			ProjectSlug = source.ProjectSlug,
			ChannelId = source.ChannelId,
			ChannelName = source.ChannelName,
			TenantId = source.TenantId,
			TenantName = source.TenantName,
			EnvironmentId = source.EnvironmentId,
			EnvironmentName = source.EnvironmentName,
			ReleaseVersion = source.ReleaseVersion,
			TaskState = source.TaskState,
			Created = source.Created,
			QueueTime = source.QueueTime,
			StartTime = source.StartTime,
			CompletedTime = source.CompletedTime,
			DurationSeconds = source.DurationSeconds,
			DeployedBy = source.DeployedBy
	when not matched then 
		INSERT (DeploymentId, DeploymentName, ProjectId, ProjectName, ProjectSlug, ChannelId, ChannelName, TenantId, TenantName, EnvironmentId, EnvironmentName, ReleaseId, ReleaseVersion, TaskId, TaskState, Created, QueueTime, StartTime, CompletedTime, DurationSeconds, DeployedBy) 
		VALUES (source.DeploymentId, source.DeploymentName, source.ProjectId, source.ProjectName, source.ProjectSlug,  source.ChannelId, source.ChannelName, source.TenantId, source.TenantName, source.EnvironmentId, source.EnvironmentName, source.ReleaseId, source.ReleaseVersion, source.TaskId, source.TaskState, source.Created, source.QueueTime, source.StartTime, source.CompletedTime, source.DurationSeconds, source.DeployedBy)
	;

	if (@quick = 0)
	begin
		-- Fix up projects, environments and releases that may have been renamed
		update DeploymentHistory set 
			DeploymentHistory.EnvironmentName = env.Name 
			from DeploymentHistory 
			inner join DeploymentEnvironment env on env.Id = DeploymentHistory.EnvironmentId
		update DeploymentHistory set 
			DeploymentHistory.ProjectName = proj.Name, 
			DeploymentHistory.ProjectSlug = proj.Slug 
			from DeploymentHistory 
			inner join Project proj on proj.Id = DeploymentHistory.ProjectId
		update DeploymentHistory set 
			DeploymentHistory.ReleaseVersion = rel.Version
			from DeploymentHistory 
			inner join Release rel on rel.Id = DeploymentHistory.ReleaseId
		update DeploymentHistory set 
			DeploymentHistory.TenantName = rel.Name
			from DeploymentHistory 
			inner join Tenant rel on rel.Id = DeploymentHistory.TenantId
		update DeploymentHistory set 
			DeploymentHistory.ChannelName = rel.Name
			from DeploymentHistory 
			inner join Channel rel on rel.Id = DeploymentHistory.ChannelId
	end
end
GO
PRINT N'Creating [dbo].[Release_LatestByProjectChannel]'
GO
CREATE VIEW [dbo].[Release_LatestByProjectChannel]
AS
SELECT * FROM (
	SELECT *, ROW_NUMBER() OVER (PARTITION BY ProjectId, ChannelId ORDER BY Assembled desc) as RowNum from Release) rs
	WHERE RowNum = 1
GO
PRINT N'Creating [dbo].[TenantProject]'
GO
------------------------------------------------
-- Add TenantProject view
------------------------------------------------

CREATE VIEW [dbo].[TenantProject]
AS
SELECT Tenant.Id As TenantId, Project.Id AS ProjectId
FROM Project
INNER JOIN Tenant On Tenant.ProjectIds LIKE '%|'+ Project.Id +'|%'
GO
PRINT N'Creating [dbo].[EventSourceDeployments]'
GO
CREATE PROCEDURE [dbo].[EventSourceDeployments]
(
    @startId bigint,
    @endId bigint
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
		StartEvent.[AutoId] AS StartAutoId,
		StartEvent.[Occurred] AS StartTime,
		EndEvent.EndAutoId,
		EndEvent.EndTime,
		EndEvent.Deployment_Id,
		EndEvent.Deployment_Name,
		EndEvent.Deployment_Created,
		EndEvent.Deployment_EnvironmentId,
		EndEvent.Deployment_ProjectId,
		EndEvent.Deployment_ReleaseId,
		EndEvent.Deployment_ProjectGroupId,
		EndEvent.Deployment_TaskId,
		EndEvent.Deployment_JSON,
		EndEvent.Deployment_DeployedBy,
		EndEvent.Deployment_TenantId,
		EndEvent.Deployment_DeployedToMachineIds,
		EndEvent.Deployment_ChannelId
		FROM (
		SELECT EndEvent.[AutoId] AS EndAutoId
			,EndEvent.[Occurred] AS EndTime
			,Deployment.[Id] AS Deployment_Id
			,Deployment.[Name] AS Deployment_Name
			,Deployment.[Created] AS Deployment_Created
			,Deployment.[EnvironmentId] AS Deployment_EnvironmentId
			,Deployment.[ProjectId] AS Deployment_ProjectId
			,Deployment.[ReleaseId] AS Deployment_ReleaseId
			,Deployment.[ProjectGroupId] AS Deployment_ProjectGroupId
			,Deployment.[TaskId] AS Deployment_TaskId
			,Deployment.[JSON] AS Deployment_JSON
			,Deployment.[DeployedBy] AS Deployment_DeployedBy
			,Deployment.[TenantId] AS Deployment_TenantId
			,Deployment.[DeployedToMachineIds] AS Deployment_DeployedToMachineIds
			,Deployment.[ChannelId] AS Deployment_ChannelId
			,EndEvent.RelatedDocumentIds
		FROM [Event] AS EndEvent
		INNER JOIN EventRelatedDocument
		ON EndEvent.Id = EventRelatedDocument.EventId
		INNER JOIN Deployment
		ON Deployment.Id = EventRelatedDocument.RelatedDocumentId
		WHERE EndEvent.Category IN ('DeploymentSucceeded', 'DeploymentFailed')
		AND EndEvent.AutoId > @startId
		AND EndEvent.AutoId <= @endId
	) EndEvent
	CROSS APPLY
	(
		-- Find the equivalent StartEvent (DeploymentQueued) for our EndEvent (DeploymentSucceeded)
		SELECT TOP 1 *
		FROM [Event]
		WHERE Category = 'DeploymentQueued'
		AND [Event].RelatedDocumentIds = EndEvent.RelatedDocumentIds
		AND [Event].AutoId < EndEvent.EndAutoId
		AND [Event].ProjectId = EndEvent.Deployment_ProjectId
		ORDER BY [Event].AutoId DESC
	) StartEvent
END
GO
PRINT N'Creating [dbo].[fnSplitReferenceCollectionAsTable]'
GO
-- Thanks to: http://stackoverflow.com/questions/5487961/splitting-of-comma-separated-values
CREATE FUNCTION [dbo].[fnSplitReferenceCollectionAsTable] 
(
    @inputString nvarchar(MAX)
)
RETURNS 
@Result TABLE 
(
    Value nvarchar(200)
)
AS
BEGIN
    DECLARE @chIndex int
    DECLARE @item nvarchar(200)

    WHILE CHARINDEX('|', @inputString, 0) <> 0
    BEGIN
        -- Get the index of the first delimiter.
        SET @chIndex = CHARINDEX('|', @inputString, 0)

        -- Get all of the characters prior to the delimiter and insert the string into the table.
        SELECT @item = SUBSTRING(@inputString, 1, @chIndex - 1)

        IF LEN(@item) > 0
        BEGIN
            INSERT INTO @Result(Value)
            VALUES (@item)
        END

        -- Get the remainder of the string.
        SELECT @inputString = SUBSTRING(@inputString, @chIndex + 1, LEN(@inputString))
    END

    -- If there are still characters remaining in the string, insert them into the table.
    IF LEN(@inputString) > 0
    BEGIN
        INSERT INTO @Result(Value)
        VALUES (@inputString)
    END

    RETURN 
END
GO
PRINT N'Creating [dbo].[fnAreTagRulesSatisfied]'
GO
CREATE FUNCTION [dbo].[fnAreTagRulesSatisfied]
(
	@tags NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN (
	SELECT * FROM Tenant
	WHERE EXISTS (
		SELECT * FROM
		(
			SELECT COUNT(*) TagSetCount, SUM(HasTag) TagSetsPresent 
			FROM (
				SELECT DISTINCT SUBSTRING(Value, 0, CHARINDEX('/', Value, 0)) AS TagSetId 
				FROM [fnSplitReferenceCollectionAsTable](@tags)
			) TagSets
			LEFT JOIN (
				SELECT DISTINCT TagSetId, 1 AS HasTag 
				FROM (
					SELECT Value as TagId, SUBSTRING(V.Value, 0, CHARINDEX('/', V.Value, 0)) as TagSetId
					FROM [fnSplitReferenceCollectionAsTable](TenantTags) AS V
				) AS F
				WHERE TagId IN (
					SELECT Value 
					FROM [fnSplitReferenceCollectionAsTable](@tags)
				)
				GROUP BY TagSetId
			) T ON T.TagSetId =  TagSets.TagSetId
		) X
		WHERE TagSetCount = TagSetsPresent
	)
)
GO
PRINT N'Creating [dbo].[MultiTenancyDashboard]'
GO
CREATE VIEW [dbo].[MultiTenancyDashboard] AS
	SELECT 
		d.Id as Id,
		d.Created as Created,
		d.ProjectId as ProjectId,
		d.EnvironmentId as EnvironmentId,
		d.ReleaseId as ReleaseId,
		d.TenantId as TenantId,
		d.TaskId as TaskId,
		d.ChannelId as ChannelId,
		CurrentOrPrevious,
		t.[State] as [State],
		t.HasPendingInterruptions as HasPendingInterruptions,
		t.HasWarningsOrErrors as HasWarningsOrErrors,
		t.ErrorMessage as ErrorMessage,
		t.QueueTime as QueueTime,
		t.StartTime as StartTime,
		t.CompletedTime as CompletedTime,
		r.[Version] as [Version]
	FROM (
		SELECT 
			'C' AS CurrentOrPrevious,
			d.Id as Id,
			d.Created as Created,
			d.ProjectId as ProjectId,
			d.EnvironmentId as EnvironmentId,
			d.ReleaseId as ReleaseId,
			d.TenantId as TenantId,
			d.TaskId as TaskId,		
			d.ChannelId as ChannelId,
			ROW_NUMBER() OVER (PARTITION BY d.EnvironmentId, d.ProjectId, d.TenantId ORDER BY Created DESC) as [Rank]
		FROM [Deployment] d
		INNER JOIN
		[ServerTask] t ON t.Id = d .TaskId
		WHERE NOT ((t.State = 'Canceled' OR t.State = 'Cancelling') AND t.StartTime IS NULL)
		UNION
		SELECT 
			'P' AS CurrentOrPrevious, 
			d.Id as Id,
			d.Created as Created,
			d.ProjectId as ProjectId,
			d.EnvironmentId as EnvironmentId,
			d.ReleaseId as ReleaseId,
			d.TenantId as TenantId,
			d.TaskId as TaskId,
			d.ChannelId as ChannelId,
			ROW_NUMBER() OVER (PARTITION BY d.EnvironmentId, d.ProjectId, d.TenantId ORDER BY Created DESC) as [Rank]
		FROM [Deployment] d
		INNER JOIN [ServerTask] t on t.Id = d.TaskId
		WHERE 
			t.State = 'Success' AND 
			d.Id NOT IN (
				SELECT Id 
				FROM (
					SELECT 
						d.Id as Id, 
						ROW_NUMBER() OVER (PARTITION BY d.EnvironmentId, d.ProjectId, d.TenantId ORDER BY Created DESC) as [Rank] 
					FROM [Deployment] d
					INNER JOIN
					[ServerTask] t ON t.Id = d .TaskId
					WHERE NOT ((t.State = 'Canceled' OR t.State = 'Cancelling') AND t.StartTime IS NULL)
				) LatestDeployment 
				WHERE [Rank]=1)
	 ) d 
	 INNER JOIN [ServerTask] t on t.Id = d.TaskId
	 INNER JOIN [Release] r on r.Id = d.ReleaseId
	 WHERE ([Rank]=1 AND CurrentOrPrevious='P') OR ([Rank]=1 AND CurrentOrPrevious='C')
GO
PRINT N'Creating [dbo].[LatestSuccessfulDeployments]'
GO
CREATE VIEW [dbo].[LatestSuccessfulDeployments]
AS
SELECT * FROM (
	SELECT [Deployment].*, ROW_NUMBER() OVER (PARTITION BY [Deployment].EnvironmentId, [Deployment].ProjectId, [Deployment].TenantId ORDER BY [Event].[Occurred] DESC) AS [Rank]
	FROM [Deployment]
	INNER JOIN [EventRelatedDocument]
	ON [Deployment].Id = [EventRelatedDocument].RelatedDocumentId
	INNER JOIN [Event]
	ON [EventRelatedDocument].EventId = [Event].Id
	WHERE [Event].Category = 'DeploymentSucceeded'
) d
WHERE [Rank] = 1
GO
PRINT N'Creating [dbo].[LatestSuccessfulDeploymentsToMachine]'
GO
CREATE PROCEDURE [dbo].[LatestSuccessfulDeploymentsToMachine]
(
	@machineId NVARCHAR(MAX)
)
AS
BEGIN (
	SELECT * FROM (
		SELECT [Deployment].*, ROW_NUMBER() OVER (PARTITION BY [Deployment].EnvironmentId, [Deployment].ProjectId, [Deployment].TenantId ORDER BY [Event].[Occurred] DESC) AS [Rank]
		FROM [Deployment]
		INNER JOIN [DeploymentRelatedMachine]
		ON [Deployment].Id = [DeploymentRelatedMachine].DeploymentId
		INNER JOIN [EventRelatedDocument]
		ON [EventRelatedDocument].RelatedDocumentId = [Deployment].Id
		INNER JOIN [Event]
		ON [Event].Id = [EventRelatedDocument].EventId
		WHERE [DeploymentRelatedMachine].MachineId = @machineId
		AND [Event].Category = 'DeploymentSucceeded'
	) d
	WHERE [Rank] = 1
)
END
GO
PRINT N'Creating [dbo].[Artifact]'
GO
CREATE TABLE [dbo].[Artifact]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Filename] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RelatedDocumentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetimeoffset] NOT NULL,
[ProjectId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EnvironmentId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Artifact_Id] on [dbo].[Artifact]'
GO
ALTER TABLE [dbo].[Artifact] ADD CONSTRAINT [PK_Artifact_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Artifact_DataVersion] on [dbo].[Artifact]'
GO
CREATE NONCLUSTERED INDEX [IX_Artifact_DataVersion] ON [dbo].[Artifact] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Artifact_TenantId] on [dbo].[Artifact]'
GO
CREATE NONCLUSTERED INDEX [IX_Artifact_TenantId] ON [dbo].[Artifact] ([TenantId]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[ExtensionConfiguration]'
GO
CREATE TABLE [dbo].[ExtensionConfiguration]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtensionAuthor] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_ExtensionConfiguration_Id] on [dbo].[ExtensionConfiguration]'
GO
ALTER TABLE [dbo].[ExtensionConfiguration] ADD CONSTRAINT [PK_ExtensionConfiguration_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Mutex]'
GO
CREATE TABLE [dbo].[Mutex]
(
[Id] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Mutex_Id] on [dbo].[Mutex]'
GO
ALTER TABLE [dbo].[Mutex] ADD CONSTRAINT [PK_Mutex_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[OctopusServerInstallationHistory]'
GO
CREATE TABLE [dbo].[OctopusServerInstallationHistory]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Node] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Installed] [datetimeoffset] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[RelatedDocument]'
GO
CREATE TABLE [dbo].[RelatedDocument]
(
[Id] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Table] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RelatedDocumentId] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RelatedDocumentTable] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating index [IX_RelatedDocument_Id] on [dbo].[RelatedDocument]'
GO
CREATE CLUSTERED INDEX [IX_RelatedDocument_Id] ON [dbo].[RelatedDocument] ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_RelatedDocument_RelatedDocumentId] on [dbo].[RelatedDocument]'
GO
CREATE NONCLUSTERED INDEX [IX_RelatedDocument_RelatedDocumentId] ON [dbo].[RelatedDocument] ([RelatedDocumentId]) INCLUDE ([Id], [Table]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[SchemaVersions]'
GO
CREATE TABLE [dbo].[SchemaVersions]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ScriptName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Applied] [datetime] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_SchemaVersions_Id] on [dbo].[SchemaVersions]'
GO
ALTER TABLE [dbo].[SchemaVersions] ADD CONSTRAINT [PK_SchemaVersions_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Script0129RepairLegacyLibraryVariableSet]'
GO
CREATE TABLE [dbo].[Script0129RepairLegacyLibraryVariableSet]
(
[Id] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OwnerId] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [int] NOT NULL,
[IsFrozen] [bit] NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RelatedDocumentIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[TenantVariable]'
GO
CREATE TABLE [dbo].[TenantVariable]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EnvironmentId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VariableTemplateId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RelatedDocumentId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_TenantVariable_Id] on [dbo].[TenantVariable]'
GO
ALTER TABLE [dbo].[TenantVariable] ADD CONSTRAINT [PK_TenantVariable_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_TenantVariable_TenantId] on [dbo].[TenantVariable]'
GO
CREATE NONCLUSTERED INDEX [IX_TenantVariable_TenantId] ON [dbo].[TenantVariable] ([TenantId]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[TenantVariable]'
GO
ALTER TABLE [dbo].[TenantVariable] ADD CONSTRAINT [UQ_TenantVariable] UNIQUE NONCLUSTERED  ([TenantId], [OwnerId], [EnvironmentId], [VariableTemplateId]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[WorkerTaskLease]'
GO
CREATE TABLE [dbo].[WorkerTaskLease]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WorkerId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaskId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Exclusive] [bit] NOT NULL CONSTRAINT [DF__WorkerTas__Exclu__719CDDE7] DEFAULT ((0)),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_WorkerTaskLease_Id] on [dbo].[WorkerTaskLease]'
GO
ALTER TABLE [dbo].[WorkerTaskLease] ADD CONSTRAINT [PK_WorkerTaskLease_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating [dbo].[Worker]'
GO
CREATE TABLE [dbo].[Worker]
(
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDisabled] [bit] NOT NULL,
[WorkerPoolIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MachinePolicyId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Thumbprint] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fingerprint] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommunicationStyle] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataVersion] [timestamp] NOT NULL
) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Worker_MachinePolicy] on [dbo].[Worker]'
GO
CREATE CLUSTERED INDEX [IX_Worker_MachinePolicy] ON [dbo].[Worker] ([MachinePolicyId]) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Worker_Id] on [dbo].[Worker]'
GO
ALTER TABLE [dbo].[Worker] ADD CONSTRAINT [PK_Worker_Id] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Worker_DataVersion] on [dbo].[Worker]'
GO
CREATE NONCLUSTERED INDEX [IX_Worker_DataVersion] ON [dbo].[Worker] ([DataVersion]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [dbo].[Worker]'
GO
ALTER TABLE [dbo].[Worker] ADD CONSTRAINT [UQ_WorkerNameUnique] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
PRINT N'Adding foreign keys to [dbo].[DeploymentRelatedMachine]'
GO
ALTER TABLE [dbo].[DeploymentRelatedMachine] ADD CONSTRAINT [FK_DeploymentRelatedMachine_DeploymentId] FOREIGN KEY ([DeploymentId]) REFERENCES [dbo].[Deployment] ([Id]) ON DELETE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[EventRelatedDocument]'
GO
ALTER TABLE [dbo].[EventRelatedDocument] ADD CONSTRAINT [FK_EventRelatedDocument_EventId] FOREIGN KEY ([EventId]) REFERENCES [dbo].[Event] ([Id]) ON DELETE CASCADE
GO