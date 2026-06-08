USE [COLEGIO]
GO
/****** Object:  Table [dbo].[Alumno]    Script Date: 09/05/2026 12:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Alumno](
	[IdAlumno] [int] IDENTITY(1,1) NOT NULL,
	[Nombres] [varchar](50) NULL,
	[Apellidos] [varchar](50) NULL,
	[IdSeccion] [int] NULL,
	[Pension] [decimal](18, 4) NULL,
	[Fecha] [datetime] NULL,
 CONSTRAINT [PK_Alumno] PRIMARY KEY CLUSTERED 
(
	[IdAlumno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Alumno] ON 
GO
INSERT [dbo].[Alumno] ([IdAlumno], [Nombres], [Apellidos], [IdSeccion], [Pension], [Fecha]) VALUES (1, N'Carlos', N'Alcantara', 1, CAST(50.0000 AS Decimal(18, 4)), CAST(N'1980-01-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Alumno] ([IdAlumno], [Nombres], [Apellidos], [IdSeccion], [Pension], [Fecha]) VALUES (2, N'Juan', N'Aramburu', 2, CAST(60.0000 AS Decimal(18, 4)), CAST(N'2001-01-15T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Alumno] ([IdAlumno], [Nombres], [Apellidos], [IdSeccion], [Pension], [Fecha]) VALUES (4, N'dds', N'ds', 2, CAST(444.0000 AS Decimal(18, 4)), CAST(N'2025-06-28T01:31:55.347' AS DateTime))
GO
INSERT [dbo].[Alumno] ([IdAlumno], [Nombres], [Apellidos], [IdSeccion], [Pension], [Fecha]) VALUES (5, N'sdsd', N'fdfd', 1, CAST(555.0000 AS Decimal(18, 4)), CAST(N'2025-07-04T16:02:45.290' AS DateTime))
GO
INSERT [dbo].[Alumno] ([IdAlumno], [Nombres], [Apellidos], [IdSeccion], [Pension], [Fecha]) VALUES (6, N'sdsd', N'fdfd', 1, CAST(555.0000 AS Decimal(18, 4)), CAST(N'2026-05-04T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Alumno] OFF
GO
/****** Object:  StoredProcedure [dbo].[USP_AGREGAR_ALUMNO]    Script Date: 09/05/2026 12:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[USP_AGREGAR_ALUMNO]
    @Nombres VARCHAR(100),
    @Apellidos VARCHAR(100),
    @IdSeccion INT,
    @Pension DECIMAL(10,2),
    @Fecha DATETIME,
    @RutaImagen VARCHAR(1000)
AS
BEGIN

        INSERT INTO [dbo].[Alumno] 
        (
            [Nombres],
            [Apellidos],
            [IdSeccion],
            [Pension],
            [Fecha],
            [RutaImagen]
        )
        VALUES 
        (
            @Nombres,
            @Apellidos,
            @IdSeccion,
            @Pension,
            @Fecha,
            @RutaImagen
        );
        
        -- Retornar el ID del alumno recién insertado
        SELECT SCOPE_IDENTITY() AS IdAlumno;
        

END
GO

/****** Object:  StoredProcedure [dbo].[USP_BUSCAR_ALUMNO]    Script Date: 09/05/2026 12:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[USP_BUSCAR_ALUMNO]
    -- Parámetros opcionales: NULL significa "no filtrar por este campo"
    @Nombres    VARCHAR(100) = NULL,
    @Apellidos  VARCHAR(100) = NULL,
    @IdSeccion  INT          = NULL,
    @Pension    DECIMAL(10,2)= NULL,
    @FechaDesde DATETIME     = NULL,
    @FechaHasta DATETIME     = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [IdAlumno],
        [Nombres],
        [Apellidos],
        [IdSeccion],
        [Pension],
        [Fecha],
        [RutaImagen]

    FROM [dbo].[Alumno]
    WHERE
        -- Si @Nombres es NULL, no filtra. Si tiene valor, busca coincidencia parcial
        (@Nombres   IS NULL OR [Nombres]   LIKE '%' + @Nombres   + '%') AND
        (@Apellidos IS NULL OR [Apellidos] LIKE '%' + @Apellidos + '%') AND

        -- Si @IdSeccion es NULL, no filtra. Si tiene valor, busca exacto
        (@IdSeccion IS NULL OR [IdSeccion] = @IdSeccion)  AND

        -- Si @Pension es NULL, no filtra. Si tiene valor, busca >= (como tu LINQ)
        (@Pension  IS NULL OR [Pension] >= @Pension) AND

        -- Si ambas fechas son NULL, no filtra rango.
        -- Si solo una viene, filtra por esa dirección
        (@FechaDesde IS NULL OR CAST([Fecha] AS DATE) >= CAST(@FechaDesde AS DATE)) AND
        (@FechaHasta IS NULL OR CAST([Fecha] AS DATE) <= CAST(@FechaHasta AS DATE))

    ORDER BY [IdAlumno];
END



/****** Object:  StoredProcedure [dbo].[USP_CONSULTAR_ALUMNO_POR_ID]    Script Date: 09/05/2026 12:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CONSULTAR_ALUMNO_POR_ID]
    @IdAlumno INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT [IdAlumno],
           [Nombres],
           [Apellidos],
           [IdSeccion],
           [Pension],
           [Fecha]
    FROM [dbo].[Alumno]
    WHERE [IdAlumno] = @IdAlumno;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ELIMINAR_ALUMNO]    Script Date: 09/05/2026 12:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ELIMINAR_ALUMNO]
    @IdAlumno INT
AS
BEGIN

        DELETE FROM [dbo].[Alumno]
        WHERE [IdAlumno] = @IdAlumno;
        
        -- Retornar el número de filas afectadas
        SELECT @@ROWCOUNT AS FilasAfectadas;
        

END
GO
/****** Object:  StoredProcedure [dbo].[USP_MODIFICAR_ALUMNO]    Script Date: 09/05/2026 12:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- PROCEDIMIENTO PARA MODIFICAR ALUMNO EXISTENTE
-- =============================================
ALTER PROCEDURE [dbo].[USP_MODIFICAR_ALUMNO]
    @IdAlumno INT,
    @Nombres VARCHAR(100),
    @Apellidos VARCHAR(100),
    @IdSeccion INT,
    @Pension DECIMAL(10,2),
    @Fecha DATETIME,
    @RutaImagen VARCHAR(1000)
AS
BEGIN

        UPDATE [dbo].[Alumno]
        SET [Nombres] = @Nombres,
            [Apellidos] = @Apellidos,
            [IdSeccion] = @IdSeccion,
            [Pension] = @Pension,
            [Fecha] = @Fecha,
            [RutaImagen] = @RutaImagen

        WHERE [IdAlumno] = @IdAlumno;
        
        -- Retornar el número de filas afectadas
        SELECT @@ROWCOUNT AS FilasAfectadas;

END

select * from alumno
