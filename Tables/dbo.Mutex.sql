CREATE TABLE [dbo].[Mutex]
(
[Id] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JSON] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Mutex] ADD CONSTRAINT [PK_Mutex_Id] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
