USE [ViCo]
GO

/****** Object:  View [Clinicos].[Basica_Diarrea]    Script Date: 08/23/2018 16:06:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





















/*
	Creada por: Gerardo López
	Fecha: algún día de 2007 o 2008

	Esta vista provee información básica para iniciar análisis en los casos de
	diarrea de ViCo. Se unen datos de Hospital, Centro y Puesto.

	[2011-10-21] Fredy Muñoz:
	* Actualicé algunos comentarios que hacían referencia a Hospital en los
	  bloques de Centro y Puesto. Probablemente se quedaron por copy/paste.
	* Moví el bloque de Hospital al principio para tener un orden más lógico.
	* Hice JOIN con la tabla Control.Sitios para obtener la información de los
	  sitios en lugar de producirlo en el query.

	[2011-11-10] Fredy Muñoz:
	* Agregué columna hxC_Vomitos que es el nuevo nombre de
	  sintomasEnfermDiarreaVomitos pero aun no la reemplacé.

	[2012-03-08] Fredy Muñoz:
	* Agregué columnas: parentescoGradoEscolarCompleto, familiaIngresosMensuales

	[2012-05-22] Fredy Muñoz:
	* Agregué columna: centroRehidratacionTipo que solamente está disponible en
	  Centro.

	[2012-10-12] Fredy Muñoz:
	* Cambié el nombre de la variable [catchment] a [HUSarea]

	[2012-12-10] Fredy Muñoz:
	* Resumí el código para calcular [HUSarea]. Esta forma resulta más fácil de
	  leer.
	* Agregué variable [medUltimas72HorasAntiB].
	
	[2013-04-19] Marvin Xuya
	* Agregue variables 
		[EPEC]
		[ETEC]
		[STEC]
	* Renombré la variable [ecoli] a [EntamoebaColi]
	
	[2014-02-21] Fredy Muñoz
	* Agregué las siguientes variables:
		[casaRefrigeradora]
		[casaComputadora]
		[casaRadio]
		[casaLavadora]
		[casaSecadora]
		[casaTelefono]
		[casaMicroondas]
		[casaCarroCamion]
		
	[2014-04-03] Karin Ceballos
	* Agregue las variables 
	   [ASTROVIRUS]
      ,[SAPOVIRUS]
      ,[CT_ASTROVIRUS]
      ,[CT_SAPOVIRUS]
      
	[2014-05-30]       Karin Ceballos
	Agregue las variables a solicitud de CJarquin
		casaCuantosDormitorios
		casaCuantasPersonasViven
		casaMaterialTecho
		combustibleLenia
		combustibleResiduosCosecha
		combustibleCarbon
		combustibleGas
		combustibleElectricidad
		combustibleOtro

	[2014-08-05] Karin Ceballos
	Agregue Variables a Solicitud de Claudia Jarquin
		Patientegradoescolar
		casaEnergiaElectrica

	[2015-07-20] Brayan Rosales
	* Se unifico la información que estaba en sharepoint (astro,noro,sapo) a la tabla lab.PCR_Diarrea
	  por lo que se cambio en lugar de la vista sp.sindrome_diarreico por una nueva vista lab.sindrome_diarreico con la información que contenia dicha tabla.
	* se unifico la tabla norovirus_resultados con la vista lab.sindrome_diarreico para las variables de norovirus.
		
	[2015-07-22] Juan de Dios García
	 * Se agrego a las 3 secciones del cuestionario los resultados de genotipificación de Rotavirus.  Se creo la tabla ViCo.Lab.RotavirusGenotipificacion
	 * Por el momento no hay un proceso automatico para incorporar estos resultados hay que ingresarlos en esa tabla manualmente bajo demanda.
	 
	[2015-10-09] Juan de Dios García
	* Se decidio poner las nuevas variables para vomitos.  Esto debido a que no se habian incluido en la vista solo estaban las variables de la version anterior a la 7.0.0.0
	  Ahora se incluyeron ambas en la misma variable.  
	  Dependiendo con que versión de cuestionario fue llena esa es la que se muestra.  
	  Para los ultimos casos que fueron en los meses del limite se encontraron 28 casos que tenian llena la varaible para ambas versiones de cuestionario ocea que estaba
	  la respuesta en las variables viejas y en las nuevas.  Pero se hizo un analisis y se detecto mejor congruencia en la version vieja por tal razón esta tiene prioridad 
	  al mostrar.
	    
	  Esto para todas las secciones hospital, centro y puesto.  Variables fueron las siguientes:
	
		hxC_Vomitos
		hxC_VomitosVeces
		hxC_Vomitos8Dias
		hxC_VomitosActual
	[2015-10-16] se agrego la variable medirTemperaturaCPrimeras24Horas se coloco antes de la variable temperaturaPrimeras24Horas ya que cronologicamente en el cuestionario
	asi aparecen.   Se coloco valor NULL para sección de PS, CS porque solo es preguntada en la seccion Hospital
	
	Se agregaron estas dos variables relacionadas con la medición de la temperatura por medio de la enfermera.  Esta solo se hace en hospital para los otros CS, PS valor NULL
	Prefijo: sujetoHosp (para poder extraer sintomasFiebreTemperatura),h2c (para extraer la pregunta sintomasFiebrePudoMedirTemp)
	Fueron:  
	,h2c.sintomasFiebrePudoMedirTemp 
	,sujetoHosp.sintomasFiebreTemperatura
	
	[2015-11-11] Juan de Dios García
	*Se agregan variables de Vesikary relacionadas con Rota.  Se crearon 2 vistas para luego incorporarlas a esta vista objetivo.
	Analysis.PrepareVesikari
	Analysis.VesikariFinal
	Se agregan las variables:
      ,[vesikariParametros]
      ,[mvs]
      ,[casoSeveroMVS]
    [2016-01-13] Juan de Dios
    *Se agrega variable de Cyclospora caturado por la intranet y alimentado por el lab por le momento solo en uvg central.
	
	[2016-02-09]
	*Se corrigio columna de ETEC y EPEC (antes los datos de 2009 a 2011 estaban en la vista lab.Ecoli_Resultados pero esta vista es en base
	 a un analisis que realizo marvin con x perona y se redirecciono a la tabla cruda de datos de guatemala lab.EColi_ETEC_EPEC_Resultados_GUA_2011)
	*Se agrego las columnas de patogenos tanto de etec como epec de guatemala y de cdc.
	*Se omitio la variable STEC porque provenia de un analisis previo con marvin y 'x' persona
	
	[2016-05-02]
	*Se agregan resultados de Rotavirus Genotificación de envio Abril 2016. Nueva tabla de resultados:   RotavirusGenotipificacion_Abril2016
	
	[2016-26-28] Brayan Rosales
	*Se agregaron nuevas variables incluidas en la version del cuestionario de ViCo 12.0.10 a peticion de Claudia Jarquin.
	 las variables fueron las siguientes:
		,tempmax_ingr_reg
		,tempmax_ingr
		,lactanciaMaternaExclusiva
		,pecho
		,pechoMeses
		,pechoExclusiva
		,UsoFuenteAgua
		,TxAgua
		,ComoTrataAguaaguaTrata_cloran
		,ComoTrataAguaaguaTrata_dejanReposar
		,ComoTrataAguaaguaTrata_FiltroTela
		,ComoTrataAguaaguaTrata_hierven
		,ComoTrataAguaaguaTrata_purificaLuzSolar
		,ComoTrataAguaaguaTrata_usoFiltro
		,TipoSanitario
		,TipoSanitario_otro
		,inodoroLetrina_Drenaje
		,servicioLetrinaservicio_basura
		,servicioLetrinaservicio_descubiertoLejos
		,servicioLetrinaservicio_descubiertoPatio
		,servicioLetrinaservicio_drenajeOzanja
		,servicioLetrinaservicio_noResponde
		,servicioLetrinaservicio_noSabe
		,servicioLetrinaservicio_otro
		,servicioLetrinaservicio_seEntierra
		,servicioLetrina_otro
		,inodoroUbicacion
		,inodoroComparte
		,inodoroComparte_cuantos
		,inodoroComparte_cualquiera
		,inodoroLimpia
		,inodoroLimpia_frec
		,desechoHeces
		,desechoHeces_otro
		,muestraHecesColectaTipo
	
	[2017-11-30]Arreglare variables para mapearlas bien en Vico Emergencias
	
*/
CREATE VIEW [Clinicos].[Basica_Diarrea]
AS

-- Hospital
SELECT
	Sujeto.[SubjectID]


	-- ID & elegibility
	-----------------------------------------------
	--,sujeto.pacienteInscritoViCo
	,CASE WHEN
			(
				sujeto.pacienteInscritoViCo = 2
				AND (sujeto.elegibleDiarrea = 1 OR sujeto.elegibleRespira = 1 OR sujeto.elegibleFebril = 1)
				AND sujeto.SASubjectID IS NOT NULL
				AND YEAR(sujeto.fechaHoraAdmision) >= 2016
				AND sujeto.pdainsertversion LIKE '12%'
			)
	 THEN 1
	 WHEN 
				(
						sujeto.SubjectID like '95DD8258-E586-4517-AC78-001507FEABFB' OR
						sujeto.SubjectID  like '80968BE5-0C58-4D2C-8510-2274A8BCFCC3' OR
						sujeto.SubjectID  like '006E07F7-6506-416A-9AA4-2C0BB7C5F75A' OR
						sujeto.SubjectID  like '627590DD-6A39-4282-A8A5-436384C6E8F7' OR
						sujeto.SubjectID  like '1D112EB1-7D73-40C8-8B90-6579C9D16AAE' OR
						sujeto.SubjectID  like '15B97789-99A2-4500-AA3D-6964F79E3E49' OR
						sujeto.SubjectID  like '6AE54446-83C7-436A-A329-BEF044EB9FFD' OR
						sujeto.SubjectID  like '6897294C-2EA3-47C4-B326-DE9C498F63EC' OR
						sujeto.SubjectID  like 'D5B96798-A3F9-4A63-8195-EF4F57EF8DAD' OR
						sujeto.SubjectID  like 'B1060287-7761-4ED0-A754-3346B1E332F1' OR
						sujeto.SubjectID  like '25A68BCD-58E8-416A-8040-3B2AB0C9D07E' OR
						sujeto.SubjectID  like 'CEF6B081-223D-4849-914C-4004DED09E79' OR
						sujeto.SubjectID  like '385A3B4D-8870-4927-B6AD-8851B0D8BF1A' OR
						sujeto.SubjectID  like '95F14C7E-BB3C-4D86-A6DC-E6EE2D7A579F' OR
						sujeto.SubjectID  like 'F8D95B40-6BFD-45AF-8681-ECFFE09E330F' OR
						sujeto.SubjectID  like 'DF72BCAD-440F-4DE1-A3A5-F41D52AA9012' OR
						sujeto.SubjectID  like 'F84DF0A8-6656-449B-B0BF-42A4AFE7DAC6' 
				) THEN 0
	 ELSE sujeto.pacienteInscritoViCo
	END pacienteInscritoViCo
	,Sujeto.SASubjectID

	,sujeto.elegibleDiarrea
	,sujeto.elegibleRespira
	,sujeto.elegibleNeuro
	,sujeto.elegibleFebril
	-----------------------------------------------


	-- Dates
	-----------------------------------------------
	,sujeto.fechaHoraAdmision
	,sujeto.epiWeekAdmision
	,sujeto.epiYearAdmision
	-----------------------------------------------


	-- Consent
	-----------------------------------------------
	,sujeto.consentimientoVerbal
	,sujeto.consentimientoEscrito
	,sujeto.asentimientoEscrito
	-----------------------------------------------


	-- Site location
	-----------------------------------------------
	,sujeto.SubjectSiteID
	,[Sitios].NombreShortName					AS	[SiteName]
	,Sitios.TipoSitio AS SiteType
	,Sitios.DeptoShortName AS SiteDepartamento
	-----------------------------------------------


	-- Patient Location
	-----------------------------------------------
	,Sujeto.departamento
	,Sujeto.municipio
	,sujeto.comunidad
	,sujetoHosp.lugarPoblado							AS [censo_codigo]
	,censo.comunidad									AS [censo_comunidad]
	,HUSarea =
		CASE
			WHEN
				(
					Sujeto.departamento = 6
					AND sujeto.SubjectSiteID IN (1, 2, 3, 4, 5, 6, 7)
					AND Sujeto.municipio IN (601, 602, 603, 604, 605, 606, 607, 610, 612, 613, 614)
				)
				OR
				(
					Sujeto.departamento = 9
					AND sujeto.SubjectSiteID IN (9, 12, 13, 14, 15, 17)
					AND Sujeto.municipio IN (901, 902, 903, 909, 910, 911, 913, 914, 916, 923, 912)
				)
				OR
				(
					Sujeto.departamento = 1
					AND sujeto.SubjectSiteID = 11
				)
			THEN 1
			ELSE 2
		END

	,NombreDepto.Text AS NombreDepartamento
	,NombreMuni.Text AS NombreMunicipio
	-----------------------------------------------


	-- Demographic
	-----------------------------------------------
	,sujeto.sexo
	,sujeto.edadAnios
	,sujeto.edadMeses
	,sujeto.edadDias
	,fechaDeNacimiento=CONVERT (DATE,sujeto.[fechaDeNacimiento],113)
	,Sujeto.pacienteGrupoEtnico
	-----------------------------------------------


	-- Death information
	-----------------------------------------------
	,muerteViCo =
		CASE
			WHEN Sujeto.egresoTipo = 4 OR seguimientoPacienteCondicion = 3 THEN 1
			ELSE 2
		END

	,muerteViCoFecha =
		CASE
			WHEN Sujeto.egresoTipo = 4 THEN ISNULL(Sujeto.egresoMuerteFecha,emergencia.egresoMuerteFecha)
			WHEN seguimientoPacienteCondicion = 3 THEN seguimientoPacienteMuerteFecha
			ELSE NULL
		END

	,muerteSospechoso = -- H1, H2CV, H2CE
		CASE
			WHEN h1TipoEgreso = 4 OR ISNULL(Sujeto.ConsentimientoVerbalNoRazonMurio,emergencia.ConsentimientoVerbalNoRazonMurio) = 1 OR ISNULL(Sujeto.ConsentimientoEscritoMurio,emergencia.ConsentimientoEscritoMurio) = 1 THEN 1
			ELSE 2
		END

	,muerteSospechosoFecha =
		CASE
			WHEN h1TipoEgreso = 4 THEN h1FechaEgreso
			WHEN ISNULL(Sujeto.ConsentimientoVerbalNoRazonMurio,emergencia.ConsentimientoVerbalNoRazonMurio) = 1 OR ISNULL(Sujeto.ConsentimientoEscritoMurio,emergencia.ConsentimientoEscritoMurio) = 1 THEN Sujeto.PDAInsertDate
			ELSE NULL
		END

	,muerteHospital =
		-- 1 = En Hospital (tamizaje, duranteEntrevista, antes de egresoCondicion H7)
		-- 2 = AfueraHospital (seguimiento)
		CASE
			WHEN (h1TipoEgreso = 4 OR ISNULL(Sujeto.ConsentimientoVerbalNoRazonMurio,emergencia.ConsentimientoVerbalNoRazonMurio) = 1 OR ISNULL(Sujeto.ConsentimientoEscritoMurio,emergencia.ConsentimientoEscritoMurio) = 1 OR Sujeto.egresoTipo = 4) THEN 1
			WHEN seguimientoPacienteCondicion = 3 THEN 2
			ELSE NULL
		END

	,muerteCualPaso =
		-- 1 = Tamizaje/Consentimiento
		-- 2 = Durante Entrevista (Inscrito, but NOT everything IS done HCP11 filled out probably)
		-- 3 = Antes de egreso (H7)
		-- 4 = Seguimiento (HCP9)
		CASE	
			WHEN h1TipoEgreso = 4 OR ISNULL(Sujeto.ConsentimientoVerbalNoRazonMurio,emergencia.ConsentimientoVerbalNoRazonMurio) = 1 OR ISNULL(Sujeto.ConsentimientoEscritoMurio,emergencia.ConsentimientoEscritoMurio) = 1 THEN 1
			WHEN terminoManeraCorrectaNoRazon = 3 THEN 2
			WHEN Sujeto.egresoTipo = 4 THEN 3
			WHEN seguimientoPacienteCondicion = 3 THEN 4
			ELSE NULL
		END

	,moribundoViCo = --H7
		CASE
			WHEN ISNULL(Sujeto.egresoCondicion, emergencia.egresoCondicion) = 4 AND (seguimientoPacienteCondicion IS NULL OR seguimientoPacienteCondicion <> 3) THEN 1 -- (moribundo) but NO seguimientoPacienteCondicion = 3  seguimientoPacienteMuerteFecha OR they are still alive!
			ELSE NULL
		END

	,moribundoViCoFecha = --H7
		CASE
			WHEN ISNULL(Sujeto.egresoCondicion, emergencia.egresoCondicion) = 4 AND (seguimientoPacienteCondicion IS NULL OR seguimientoPacienteCondicion <> 3) THEN ISNULL(Sujeto.egresoMuerteFecha,emergencia.egresoMuerteFecha) -- (moribundo) but NO seguimientoPacienteCondicion = 3  seguimientoPacienteMuerteFecha OR they are still alive!
			ELSE NULL
		END

	,moribundoSospechoso = --H1
		CASE
			WHEN condicionEgreso = 4 THEN 1
			ELSE NULL
		END

	,moribundoSospechosoFecha = --H1
		CASE
			WHEN condicionEgreso = 4 THEN Sujeto.PDAInsertDate
			ELSE NULL
		END
	-----------------------------------------------


	-----------------------------------------------
	--,tamizadoEmergencia
	,CASE WHEN Sujeto.fechahoraadmision >= '2017-08-01' AND MONTH(sujeto.fechaHoraAdmision) = 8 AND sujeto.salaIngreso = 6  AND sujeto.elegibleDiarrea = 1 
				AND sujeto.SASubjectID IS NOT NULL
				AND Sujeto.PDAInsertVersion LIKE '12.1.4'
			THEN 1
			ELSE tamizadoEmergencia
	  END tamizadoEmergencia  --[JD][2017-11-23]Esta modificacion es para la versión inicial de vico Emergencia ya que inicio la version 12.1.4 sin la variable tamizadoEmergencia
	,sujeto.actualAdmitido
	,sujeto.presentaIndicacionDiarrea
	,ISNULL(Sujeto.indicacionDiarrea, emergencia.indicacionDiarrea) indicacionDiarrea
	,ISNULL(Sujeto.indicacionDiarrea_otra, emergencia.indicacionDiarrea_otra) indicacionDiarrea_otra
	,Sujeto.medirTemperaturaCPrimeras24Horas
	,sujeto.temperaturaPrimeras24Horas
	,h2c.sintomasFiebrePudoMedirTemp 
	,sujetoHosp.sintomasFiebreTemperatura
	--------------------------------------------
	,ISNULL(h2rem.tempmax_ingr_reg, emergencia.tempmax_ingr_reg) tempmax_ingr_reg
    ,ISNULL(h2rem.tempmax_ingr, emergencia.tempmax_ingr)		 tempmax_ingr
    ---------------------------------------------
	,sujeto.ingresoPlanBPlanC
	,ISNULL(sujeto.gradoDeshidratacionRegistrado, emergencia.gradoDeshidratacionRegistrado) gradoDeshidratacionRegistrado
	,ISNULL(sujeto.gradoDeshidratacion, emergencia.gradoDeshidratacion)						gradoDeshidratacion
	,sujeto.conteoGlobulosBlancos
	,sujeto.diferencialAnormal
	,sujeto.sintomasFiebre
	,sujeto.sintomasFiebreDias
	,sujeto.ninioVomitaTodo
	,sujeto.ninioBeberMamar
	,sujeto.ninioTuvoConvulsiones
	,sujeto.ninioTieneLetargiaObs AS ninioTieneLetargia
	,sujeto.diarreaUltimos7Dias
	,sujeto.diarreaComenzoHaceDias
	,sujeto.diarreaMaximoAsientos1Dia
	,sujeto.diarreaOtroEpisodioSemanaAnterior
	,CASE WHEN ISNULL(Sujeto.muestraHecesColecta, emergencia.muestraHecesColecta) = 2 and lab.pruebaCultivoHizo = 1  
		  THEN 1
		  ELSE ISNULL(Sujeto.muestraHecesColecta, emergencia.muestraHecesColecta)
	 END muestraHecesColecta
	------------------------------------
	,ISNULL(H5V.muestraHecesColectaTipo, emergencia.muestraHecesColectaTipo) muestraHecesColectaTipo
	-------------------------------------
	,ISNULL(Sujeto.MuestraHecesNoRazon, emergencia.MuestraHecesNoRazon) MuestraHecesNoRazon
	,ISNULL(Sujeto.MuestraHecesNoRazonOtra_esp, emergencia.MuestraHecesNoRazonOtra_esp) MuestraHecesNoRazonOtra_esp
	,Sujeto.muestraHecesHisopoSecoNoRazon
	,Sujeto.muestraHecesHisopoSecoNoRazonOtra_esp
	,Sujeto.muestraHecesHisopoSecoFechaHora
	,ISNULL(Sujeto.muestraHecesHisopoCaryBlairColecta, emergencia.muestraHecesHisopoCaryBlairColecta) muestraHecesHisopoCaryBlairColecta
	,ISNULL(Sujeto.muestraHecesHisopoCaryBlairNoRazon, emergencia.muestraHecesHisopoCaryBlairNoRazon) muestraHecesHisopoCaryBlairNoRazon
	,ISNULL(Sujeto.muestraHecesHisopoCaryBlairNoRazonOtra_esp, emergencia.muestraHecesHisopoCaryBlairNoRazonOtra_esp) muestraHecesHisopoCaryBlairNoRazonOtra_esp
	,sujeto.muestraHecesHisopoCaryBlairFechaHora
	,ISNULL(Sujeto.muestraHecesHisopoCaryBlairTipo, emergencia.muestraHecesHisopoCaryBlairTipo) muestraHecesHisopoCaryBlairTipo
	,ISNULL(Sujeto.muestraHecesEnteraColecta, emergencia.muestraHecesEnteraColecta) muestraHecesEnteraColecta
	,ISNULL(Sujeto.muestraHecesEnteraNoRazon, emergencia.muestraHecesEnteraNoRazon) muestraHecesEnteraNoRazon
	,ISNULL(Sujeto.muestraHecesEnteraNoRazonOtra_Esp, emergencia.muestraHecesEnteraNoRazonOtra_Esp) muestraHecesEnteraNoRazonOtra_Esp
	,ISNULL(Sujeto.muestraHecesEnteraFechaHora, emergencia.muestraHecesEnteraFechaHora) muestraHecesEnteraFechaHora
	,ISNULL(Sujeto.muestraHecesEnteraLiquida, emergencia.muestraHecesEnteraLiquida) muestraHecesEnteraLiquida
	,ISNULL(Sujeto.muestraHecesEnteraCubreFondo, emergencia.muestraHecesEnteraCubreFondo) muestraHecesEnteraCubreFondo
	,ISNULL(Sujeto.hxD_diarreaActual, emergencia.hxD_diarreaActual) hxD_diarreaActual
	,ISNULL(Sujeto.hxD_diarreaActualHaceDias, emergencia.hxD_diarreaActualHaceDias) hxD_diarreaActualHaceDias
	,(SELECT hxD_diarreaAguaArroz FROM ViCo.Clinicos.H3C WHERE H3C.SubjectID = Sujeto.SubjectID AND H3C.forDeletion = 0) hxD_diarreaAguaArroz
	,ISNULL(Sujeto.hxD_ConSangre, emergencia.hxD_ConSangre) hxD_ConSangre
	,ISNULL(Sujeto.hxD_ConMoco, emergencia.hxD_ConMoco) hxD_ConMoco
	,CASE WHEN (Sujeto.sintomasEnfermDiarreaVomitos IS NULL) THEN ISNULL(H3L.hxC_Vomitos, emergencia.hxC_Vomitos) ELSE Sujeto.sintomasEnfermDiarreaVomitos END as hxC_Vomitos
	,CASE WHEN (Sujeto.sintomasEnfermDiarreaVomitos IS NULL) THEN ISNULL(H3L.hxC_VomitosVeces, emergencia.hxC_VomitosVeces)	ELSE Sujeto.sintomasEnfermDiarreaVomitosVeces END as hxC_VomitosVeces
	,CASE WHEN (Sujeto.sintomasEnfermDiarreaVomitos IS NULL) THEN ISNULL(H3L.hxC_Vomitos8Dias, emergencia.hxC_Vomitos8Dias)	ELSE Sujeto.sintomasEnfermDiarreaVomitos8Dias END as hxC_Vomitos8Dias
	,CASE WHEN (Sujeto.sintomasEnfermDiarreaVomitos IS NULL) THEN ISNULL(H3L.hxC_VomitosActual, emergencia.hxC_VomitosActual) ELSE Sujeto.sintomasEnfermDiarreaVomitosActual END as hxC_VomitosActual
	-----
	,H3L.hxC_FaltaApetito
	,H3L.hxC_Nausea
	,H3L.hxC_DebilidadGeneral
	,H3F.casaMaterialTecho
	,H3F.casaTelevision
	,H3F.casaCuantasPersonasViven
	,H3F.pacientePecho2Anios
	,H3F.casaCuantosDormitorios
	,H3F.pecho
    ,H3F.pechoMeses
    ,H3F.pechoExclusiva
    ,H3F.UsoFuenteAgua
    ,H3F.TxAgua
    ,H3F.ComoTrataAguaaguaTrata_cloran
    ,H3F.ComoTrataAguaaguaTrata_dejanReposar
    ,H3F.ComoTrataAguaaguaTrata_FiltroTela
    ,H3F.ComoTrataAguaaguaTrata_hierven
    ,H3F.ComoTrataAguaaguaTrata_purificaLuzSolar
    ,H3F.ComoTrataAguaaguaTrata_usoFiltro
    ,H3F.TipoSanitario
    ,H3F.TipoSanitario_otro
    ,H3F.inodoroLetrina_Drenaje
    ,H3F.servicioLetrinaservicio_basura
    ,H3F.servicioLetrinaservicio_descubiertoLejos
    ,H3F.servicioLetrinaservicio_descubiertoPatio
    ,H3F.servicioLetrinaservicio_drenajeOzanja
    ,H3F.servicioLetrinaservicio_noResponde
    ,H3F.servicioLetrinaservicio_noSabe
    ,H3F.servicioLetrinaservicio_otro
    ,H3F.servicioLetrinaservicio_seEntierra
    ,H3F.servicioLetrina_otro
    ,H3F.inodoroUbicacion
    ,H3F.inodoroComparte
    ,H3F.inodoroComparte_cuantos
    ,H3F.inodoroComparte_cualquiera
    ,H3F.inodoroLimpia
    ,H3F.inodoroLimpia_frec
    ,H3F.desechoHeces
    ,H3F.desechoHeces_otro
	-----
	,ISNULL(Sujeto.hxD_calambresDolorAbdominal,emergencia.hxD_calambresDolorAbdominal)		hxD_calambresDolorAbdominal
	,ISNULL(Sujeto.hxD_condicionIntestinal, emergencia.hxD_condicionIntestinal)				hxD_condicionIntestinal
	,ISNULL(Sujeto.hxD_condicionIntestinal_esp, emergencia.hxD_condicionIntestinal_esp)		hxD_condicionIntestinal_esp
	,ISNULL(Sujeto.hxD_bebeConSed, emergencia.hxD_bebeConSed)								hxD_bebeConSed
	,ISNULL(Sujeto.hxD_irritableIncomodoIntranquilo, emergencia.hxD_irritableIncomodoIntranquilo)  hxD_irritableIncomodoIntranquilo
	,NULL AS centroRehidratacionTipo
	,otroTratamiento1erRecibioMedicamento
	,otroTratamiento1erAntibioticos
	,otroTratamiento1erSuerosSalesHidracionCasero
	,otroTratamiento2doRecibioMedicamento
	,otroTratamiento2doAntibioticos
	,otroTratamiento2doSuerosSalesHidracionCasero
	,otroTratamiento3erRecibioMedicamento
	,otroTratamiento3erAntibioticos
	,otroTratamiento3erSuerosSalesHidracionCasero
	,medUltimas72HorasAntiB
	,ISNULL(Sujeto.tomadoSuerosSalesUltimas72hora,emergencia.tomadoSuerosSalesUltimas72hora)	tomadoSuerosSalesUltimas72hora
	,ISNULL(Sujeto.claseSRORecibido, emergencia.claseSRORecibido)								claseSRORecibido
	,Sujeto.enfermedadesCronicasVIHSIDA
	,Sujeto.enfermedadesCronicasOtras
	,Sujeto.enfermedadesCronicasInfoAdicional
	-----------------------------------------------
	,h3a.lactanciaMaternaExclusiva
	
	------------------------------------------
	
	,Sujeto.embarazada
	,Sujeto.embarazadaMeses
	,ISNULL(Sujeto.tieneFichaVacunacion, emergencia.tieneFichaVacunacion)		tieneFichaVacunacion
	,ISNULL(Sujeto.vacunaRotavirusRecibido, emergencia.vacunaRotavirusRecibido) vacunaRotavirusRecibido
	,ISNULL(Sujeto.vacunaRotavirusDosis, emergencia.vacunaRotavirusDosis)		vacunaRotavirusDosis
	,Sujeto.casaNiniosGuareriaInfantil
	,Sujeto.pacientePachaPecho
	,Sujeto.parentescoGradoEscolarCompleto
	,Sujeto.patienteGradoEscolarCompleto
	
	,Sujeto.familiaIngresosMensuales
	,Sujeto.fuentesAguaChorroDentroCasaRedPublica
	,Sujeto.fuentesAguaChorroPublico
	,Sujeto.fuentesAguaChorroPatioCompartidoOtraFuente
	,Sujeto.fuentesAguaLavaderosPublicos
	,Sujeto.fuentesAguaPozoPropio
	,Sujeto.fuentesAguaPozoPublico
	,Sujeto.fuentesAguaCompranAguaEmbotellada
	,Sujeto.fuentesAguaDeCamionCisterna
	,Sujeto.fuentesAguaLluvia
	,Sujeto.fuentesAguaRioLago
	,Sujeto.casaAlmacenanAgua
	,Sujeto.aguaLimpiarTratar
	,Sujeto.aguaLimpiarTratarHierven
	,Sujeto.aguaLimpiarTratarQuimicos
	,Sujeto.aguaLimpiarTratarFiltran
	,Sujeto.aguaLimpiarTratarSodis
	,Sujeto.aguaLimpiarTratarOtro
	,Sujeto.aguaLimpiarTratarOtro_esp
	,Sujeto.casaMaterialPiso
	
	, sujeto.casaEnergiaElectrica
	,Sujeto.casaRefrigeradora
	,Sujeto.casaComputadora
	,Sujeto.casaRadio
	,Sujeto.casaLavadora
	,Sujeto.casaSecadora
	,Sujeto.casaTelefono
	,Sujeto.casaMicroondas
	,Sujeto.casaCarroCamion
	,Sujeto.factoresRiesgoInfoAdicional
	, h3f.combustibleLenia
	, h3f.combustibleResiduosCosecha
	, h3f.combustibleCarbon
	, h3f.combustibleGas
	, h3f.combustibleElectricidad
	, h3f.combustibleOtro
	,ISNULL(Sujeto.diarreaExamenFisicoEnfermeraOjos, emergencia.diarreaExamenFisicoEnfermeraOjos)						diarreaExamenFisicoEnfermeraOjos
	,ISNULL(Sujeto.diarreaExamenFisicoEnfermeraMucosaOral, emergencia.diarreaExamenFisicoEnfermeraMucosaOral)			diarreaExamenFisicoEnfermeraMucosaOral
	,ISNULL(Sujeto.diarreaExamenFisicoEnfermeraRellenoCapillar, emergencia.diarreaExamenFisicoEnfermeraRellenoCapillar)	diarreaExamenFisicoEnfermeraRellenoCapillar
	,ISNULL(Sujeto.diarreaExamenFisicoEnfermeraPellizcoPiel, emergencia.diarreaExamenFisicoEnfermeraPellizcoPiel)		diarreaExamenFisicoEnfermeraPellizcoPiel
	,ISNULL(Sujeto.diarreaExamenFisicoEnfermeraMolleraHundida, emergencia.diarreaExamenFisicoEnfermeraMolleraHundida)	diarreaExamenFisicoEnfermeraMolleraHundida
	,ISNULL(Sujeto.diarreaExamenFisicoEnfermeraEstadoMental, emergencia.diarreaExamenFisicoEnfermeraEstadoMental)		diarreaExamenFisicoEnfermeraEstadoMental
	,pacienteTallaMedida
	,pacienteTallaCM1
	,pacienteTallaCM2
	,pacienteTallaCM3
	,pacientePesoMedida
	,pacientePesoLibras1
	,pacientePesoLibras2
	,pacientePesoLibras3
	,ISNULL(Sujeto.egresoMuerteFecha, emergencia.egresoMuerteFecha) egresoMuerteFecha
	,Sujeto.egresoTipo
	,ISNULL(Sujeto.egresoCondicion, emergencia.egresoCondicion)		egresoCondicion 
	,Sujeto.temperaturaPrimeras24HorasAlta
	,Sujeto.egresoDiagnostico1
	,Sujeto.egresoDiagnostico1_esp
	,Sujeto.egresoDiagnostico2
	,Sujeto.egresoDiagnostico2_esp

	--,H7QRecibioAcyclovir AS RecibioAcyclovir
	--,H7Q0210 AS RecibioAmantadina
	,H7Q0211 AS RecibioAmikacina
	,H7Q0213 AS RecibioAmoxAcidoClavulanico
	,H7Q0212 AS RecibioAmoxicilina
	,H7Q0214 AS RecibioAmpicilina
	,H7Q0215 AS RecibioAmpicilinaSulbactam
	,H7Q0216 AS RecibioAzitromicina
	,H7QRecibioCefadroxil AS RecibioCefadroxil
	,H7Q0219 AS RecibioCefalotina
	,H7QRecibioCefepime AS RecibioCefepime
	,H7Q0217 AS RecibioCefotaxima
	,H7Q0218 AS RecibioCeftriaxone
	,H7Q0220 AS RecibioCefuroxima
	,H7Q0221 AS RecibioCiprofloxacina
	,NULL AS RecibioClaritromicina /*INCLUDE*/
	,H7Q0222 AS RecibioClindamicina
	,H7Q0223 AS RecibioCloranfenicol
	--,H7Q0224 AS RecibioDexametazona
	,H7Q0225 AS RecibioDicloxicina
	,H7Q0226 AS RecibioDoxicilina
	,H7QRecibioEritromicina AS RecibioEritromicina
	,H7Q0227 AS RecibioGentamicina
	--,H7Q0228 AS RecibioHidrocortizonaSuccin
	,H7QRecibioImipenem AS RecibioImipenem
	--,RecibioIsoniacida
	--,RecibioLevofloxacina
	--,H7Q0229 AS RecibioMeropenem
	--,H7Q0230 AS RecibioMetilprednisolona
	,H7Q0231 AS RecibioMetronidazol
	,H7Q0234 AS RecibioOfloxacina
	--,H7Q0235 AS RecibioOseltamivir
	,H7Q0298 AS RecibioOtroAntibiotico
	,H7Q0299 AS RecibioOtroAntibEspecifique
	,H7QRecibioOxacilina AS RecibioOxacilina
	,H7Q0232 AS RecibioPenicilina
	--,H7QRecibioPerfloxacinia AS RecibioPerfloxacinia
	,NULL AS RecibioPirazinamida /*INCLUDE*/
	--,H7Q0233 AS RecibioPrednisona
	,NULL AS RecibioRifampicina /*INCLUDE*/
	,H7Q0236 AS RecibioTrimetroprimSulfame
	,H7Q0237 AS RecibioVancomicina

	--,h7.sueroSalesDurAdmision
	--,h7.liquidosIntravenososDurAdmision
	,seguimientoPacienteCondicion
	-----------------------------------------------


	-- PDA Insert Info
	-----------------------------------------------
	,Sujeto.PDAInsertDate
	,Sujeto.PDAInsertVersion
	-----------------------------------------------


	-- Laboratory Results
	-----------------------------------------------
	,LAB.recepcionMuestraOriginal
	,LAB.recepcionMuestraHisopo
	,LAB.recepcionMuestraPVA
	,LAB.recepcionMuestraFormalina
	,LAB.floranormal
	,LAB.salmonella
	,LAB.salmonellaSp
	,LAB.shigella
	,LAB.shigellaSp
	,LAB.campylobacter
	,CASE LAB.campylobacterSp
		WHEN 'jejuni'  THEN 'jejuni'
		WHEN 'jejunii' THEN 'jejuni'
		WHEN 'coli'	   THEN 'coli'
		WHEN 'Coli'	   THEN 'coli'
		ELSE LAB.campylobacterSp
	 END AS campylobacterSp
	,LAB.otro
	,LAB.pruebaRotavirusHizo
	,LAB.rotavirus
	,LAB.pruebaExamenFrescoHizo
	,LAB.pruebaExamenTricromicoHizo
	,LAB.pruebaExamenIFHizo
	,LAB.ascaris
	,LAB.trichiuris
	,LAB.nana
	,LAB.diminuta
	,LAB.uncinaria
	,LAB.enterobius
	,EntamoebaColi = LAB.ecoli
	,LAB.giardia
	,CASE WHEN(LAB.ID_Paciente IS NULL AND LAB_CYCLO_CRYPTO.SASubjectID IS NULL) THEN NULL
		ELSE 
			CASE WHEN(ISNULL(LAB.crypto,0) = 1 OR ISNULL(LAB_CYCLO_CRYPTO.cryptosporidium,0) = 1) THEN 1 ELSE 0 END 
	 END AS crypto
    ,LAB_CYCLO_CRYPTO.cyclospora
	,LAB.ioda
	,LAB.endolimax
	,LAB.chilo
	,LAB.blasto
	,LAB.NSOP
	,LAB.observaciones
	,LAB.pruebaCultivoHizo
	,LAB.pruebaExamenFrescoSpA
	,LAB.pruebaExamenFrescoSpB
	,LAB.pruebaExamenFrescoSpC
	,LAB.pruebaExamenTricromicoSpA
	,LAB.pruebaExamenTricromicoSpB
	,LAB.pruebaExamenTricromicoSpC
	,LAB.pruebaExamenIFSpA
	,LAB.pruebaExamenIFSpB
	--,LAB.PCREColi
	--,LAB.pruebaPCREColiHizo
	--,LAB.pruebaRotavirusTipificacionHizo
	--,LAB.rotavirusTipificacion
	,CASE WHEN rota.pruebaRotavirusTipificacionHizo IS NOT NULL THEN rota.pruebaRotavirusTipificacionHizo
		  ELSE 
				CASE WHEN rotaAbril2016.pruebaRotavirusTipificacionHizo IS NOT NULL THEN rotaAbril2016.pruebaRotavirusTipificacionHizo
				ELSE NULL END 
	 END AS		pruebaRotavirusTipificacionHizo 
	,CASE WHEN rota.rotavirusTipificacion IS NOT NULL THEN rota.rotavirusTipificacion
		  ELSE
				CASE WHEN rotaAbril2016.Genotype IS NOT NULL THEN rotaAbril2016.Genotype
				ELSE NULL END
	 END AS  rotavirusTipificacion
	,LAB.recepcionMuestraCongeladas
	,LAB.strong
	,LAB.recepcionMuestraNorovirus
	,LAB.Observaciones_UVG
	,LAB.taenia
	-----------------------------------------------


	-- Norovirus
	-----------------------------------------------
	,Norovirus.labNumeroNorovirus
	,Norovirus.fechaExtraccion
	,Norovirus.RTqPCR_RNP
	,CASE WHEN Norovirus.RTqPCR_NV1 IS NULL THEN sd.Norovirus1 ELSE Norovirus.RTqPCR_NV1 END AS RTqPCR_NV1
	,CASE WHEN Norovirus.RTqPCR_NV2 IS NULL THEN sd.Norovirus2 ELSE norovirus.RTqPCR_NV2 END AS RTqPCR_NV2
	,Norovirus.RTqPCR_RNP_CT
	,CASE WHEN Norovirus.RTqPCR_NV1_CT IS NULL THEN sd.ct_Norovirus1 ELSE CAST(Norovirus.RTqPCR_NV1_CT AS nvarchar) END AS RTqPCR_NV1_CT
	,CASE WHEN Norovirus.RTqPCR_NV2_CT IS NULL THEN sd.ct_Norovirus2 ELSE CAST(Norovirus.RTqPCR_NV2_CT AS nvarchar) END AS RTqPCR_NV2_CT
	,Norovirus.observaciones AS ObservacionesNorovirus
	,NAS.norovirusTipificacionHizo
	,NAS.NoV_GI_RegB
	,NAS.NoV_GI_RegC
	,NAS.NoV_GII_RegB
	,NAS.NoV_GII_RegC
	-----------------------------------------------


	-- Sensiblidad Antibiotica
	-----------------------------------------------
	,Sensibilidad.pruebaTrimetoprinSulfaSensibilidad
	,Sensibilidad.pruebaTetraciclinaSensibilidad
	,Sensibilidad.pruebaKanamicinaSensibilidad
	,Sensibilidad.pruebaGentamicinaSensibilidad
	,Sensibilidad.pruebaEstreptomicinaSensibilidad
	,Sensibilidad.pruebaCloranfenicolSensibilidad
	,Sensibilidad.pruebaCiprofloxacinaSensiblidad
	,Sensibilidad.pruebaCeftriaxoneSensibilidad
	,Sensibilidad.pruebaAmpicilinaSensibilidad
	,Sensibilidad.pruebaAmoxicilinaSensibilidad
	,Sensibilidad.pruebaAcNalidixicoSensibilidad
	,Sensibilidad.observaciones AS ObservacionesSensibilidad
	-----------------------------------------------

	-- E.coli EscheridiaColi
	-----------------------------------------------
	--,CASE WHEN EscheridiaColi.EPEC IS NULL THEN ecoli2014.epec ELSE EscheridiaColi.EPEC  END  AS EPEC
	--,CASE WHEN EscheridiaColi.ETEC IS NULL THEN ecoli2014.etec ELSE EscheridiaColi.ETEC END   AS ETEC
	--,EscheridiaColi.STEC
	,
	CASE WHEN (
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.hlyA=1 
							OR ecoli2011.eaeA=1 
							OR ecoli2011.stx2=1 
							OR ecoli2011.stx1=1 
						THEN 1 ELSE 0 END
					ELSE ECOLI2014.epec 
					END --AS EPEC
				)IS NOT NULL 
				OR  
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.LT=1
							OR ecoli2011.ST1a=1
							OR ecoli2011.ST1b=1
						THEN 1 ELSE 0 END
					ELSE ecoli2014.etec
					END --AS ETEC
				)IS NOT NULL
	 )THEN 1
	 ELSE NULL
	 END ecoliHizo
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.hlyA ELSE ecoli2014.epec_EHEC_hlyA_534 END AS hlyA
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.eaeA ELSE ecoli2014.epec_eaeA_384 END AS eaeA
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.stx2 ELSE ecoli2014.epec_stx2_255 END AS stx2
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.stx1 ELSE ecoli2014.epec_stx1_180 END AS sxt1
	,CASE WHEN 
		CASE WHEN ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END IS NULL
		AND 
		--ecoliHizo
		CASE WHEN (
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.hlyA=1 
							OR ecoli2011.eaeA=1 
							OR ecoli2011.stx2=1 
							OR ecoli2011.stx1=1 
						THEN 1 ELSE 0 END
					ELSE ECOLI2014.epec 
					END --AS EPEC
				)IS NOT NULL 
				OR  
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.LT=1
							OR ecoli2011.ST1a=1
							OR ecoli2011.ST1b=1
						THEN 1 ELSE 0 END
					ELSE ecoli2014.etec
					END --AS ETEC
				)IS NOT NULL
	 )THEN 1
	 ELSE NULL
	 END 
	 IS NOT NULL 
		THEN 0 
		ELSE 
		CASE WHEN CASE WHEN ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END LIKE '%negative%' THEN 0
			 WHEN CASE WHEN ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END LIKE '%positive%' THEN 1
			 ELSE CASE WHEN ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END 
		END
	 END
	AS bfpa
	,CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
			CASE WHEN ecoli2011.hlyA=1 
			       OR ecoli2011.eaeA=1 
			       OR ecoli2011.stx2=1 
			       OR ecoli2011.stx1=1 
			THEN 1 ELSE 0 END
		ELSE ECOLI2014.epec 
	  END AS EPEC
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.LT ELSE ecoli2014.etec_LT_696nt END AS LT
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.ST1a ELSE ecoli2014.etec_ST1a_186nt END AS ST1a
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.ST1b ELSE ecoli2014.etec_ST1b_166nt END AS ST1b
	,CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
			CASE WHEN ecoli2011.LT=1
				   OR ecoli2011.ST1a=1
				   OR ecoli2011.ST1b=1
			THEN 1 ELSE 0 END
		ELSE ecoli2014.etec
	 END AS ETEC
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.LT ELSE ecoli_cdc2012.LT END AS CDC_LT
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.ST1a ELSE ecoli_cdc2012.ST1a END AS CDC_ST1a
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.ST1b ELSE ecoli_cdc2012.ST1b END AS CDC_ST1b
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.hlyA ELSE ecoli_cdc2012.hlyA END AS CDC_hlyA
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.eaeA ELSE ecoli_cdc2012.eaeA END AS CDC_eaeA
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.stx2 ELSE ecoli_cdc2012.stx2 END AS CDC_stx2
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.stx1 ELSE ecoli_cdc2012.stx1 END AS CDC_stx1
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END AS CDC_bfpa
	 ----------------------------------------------
	--ASTRO Y SAPO virus 
	,sd.[ASTROVIRUS]
    ,sd.[SAPOVIRUS]
    ,sd.[CT_ASTROVIRUS]
    ,sd.[CT_SAPOVIRUS]
    ,NAS.sapovirusTipificacionHizo
    ,NAS.SapovirusGenotipificacion
	,vesikari.vesikariParametros
	,convert(decimal(4,2),vesikari.mvs) mvs
	,vesikari.casoSeveroMVS
	,vesikari.casoMuySeveroMVS
	,h7pda.cuidadoIntensivoDias
	,sujeto.salaIngreso
	,H3F.contactoAnimalesCasa
FROM Clinicos.Todo_Hospital_vw Sujeto 
	LEFT JOIN Control.Sitios ON Sujeto.SubjectSiteID = Sitios.SiteID
	LEFT JOIN LegalValue.LV_DEPARTAMENTO NombreDepto ON Sujeto.departamento = NombreDepto.Value
	LEFT JOIN LegalValue.LV_MUNICIPIO NombreMuni ON Sujeto.municipio = NombreMuni.Value
	LEFT JOIN Lab.DiarreaResultados LAB ON Sujeto.SASubjectID = Lab.ID_Paciente
	LEFT JOIN LabEnvio.RotavirusGenotipificacion rota ON Sujeto.SASubjectID = rota.ID_Paciente -- JD:2015-07-22 resultados de genotipificacino rotavirus
	LEFT JOIN LabEnvio.RotavirusGenotipificacion_Abril2016 rotaAbril2016 ON Sujeto.SASubjectID = rotaAbril2016.SASubjectID --JD:2016/05/02 result Geno Rota
	LEFT JOIN Lab.NorovirusResultados					Norovirus ON Sujeto.SASubjectID = Norovirus.ID_Paciente
	LEFT JOIN Lab.DiarreaResultadosAntibiotiocs			Sensibilidad ON Sujeto.SASubjectID = Sensibilidad.ID_Paciente
	-- FM[2011-11-10]: Temporal mientras corrigo Todo_Hospital
	LEFT JOIN Clinicos.H3L								ON H3L.SubjectID = Sujeto.SubjectID AND H3L.forDeletion = 0
	LEFT JOIN Clinicos.H3F								H3F ON H3F.SubjectID = Sujeto.SubjectID AND H3F.forDeletion = 0
	--LEFT JOIN Lab.EColi_Resultados EscheridiaColi ON EscheridiaColi.SubjectID = Sujeto.SubjectID 
	LEFT JOIN Lab.ResultadosEcoli2014					ecoli2014 ON (Sujeto.SASubjectID = ecoli2014.SASubjectID)
	LEFT JOIN lab.Sindrome_Diarreico					sd ON Sujeto.SASubjectID= sd.sampleName
	--LEFT JOIN sp.Sindrome_Diarreico sd  ON sujeto.SASubjectID COLLATE database_default= sd.SaSubjectID COLLATE database_default  --Se unifico los datos de sharepoint a una nueva tabla lab.PCR_DIARREA y se creo la vista lab.sindrome_diarreico
	LEFT JOIN Clinicos.Sujeto_Hospital					sujetoHosp ON (sujeto.SASubjectID = sujetoHosp.SASubjectID AND sujetoHosp.forDeletion = 0)
	LEFT JOIN Clinicos.H2C								h2c ON (Sujeto.SubjectID = h2c.SubjectID AND h2c.forDeletion = 0)
	LEFT JOIN Analysis.VesikariFinal					vesikari ON (Sujeto.SASubjectID = vesikari.SASubjectID_Vesikari)
	LEFT JOIN [Lab].[Cyclo_Crypto_Resultados]			LAB_CYCLO_CRYPTO ON (LAB_CYCLO_CRYPTO.SASubjectID = Sujeto.SASubjectID) --agregado para resultados de cyclo y crypto
	LEFT JOIN lab.EColi_ETEC_EPEC_Resultados_GUA_2011	ecoli2011 ON ecoli2011.SASubjectID= sujeto.SASubjectID --datos crudos de ecoli realizados en guatemala (hasta 2011)
	LEFT JOIN lab.EColi_ETEC_EPEC_Resultados_CDC_2009	ecoli_cdc2009 ON SUJETO.SaSubjectID= ecoli_cdc2009.SaSubjectID  --datos crudos de confirmaciones cdc 2009
	LEFT JOIN lab.EColi_ETEC_EPEC_Resultados_CDC_2012	ecoli_cdc2012 ON SUJETO.SaSubjectID= ecoli_cdc2012.SaSubjectID  --datos crudos de confirmaciones cdc hasta 2011
	LEFT JOIN Clinicos.H5V								h5v ON (h5v.SubjectID=Sujeto.SubjectID AND h5v.forDeletion=0)
	LEFT JOIN Clinicos.H3A								h3a on (h3a.SubjectID= Sujeto.SubjectID AND h3a.forDeletion=0)
	LEFT JOIN Clinicos.H2REM							h2rem ON (h2rem.SubjectID= sujeto.SubjectID and h2rem.forDeletion=0)
	LEFT JOIN ViCo.LegalValue.centros_poblados			censo ON ([sujetoHosp].lugarPoblado = censo.cod_censo)
	LEFT JOIN ViCo.Analysis.NAS_Envio_CDC_Results		NAS ON (NAS.SASubjectID = Sujeto.SASubjectID)
	LEFT JOIN VICO.Clinicos.H0							emergencia ON (emergencia.SubjectID = Sujeto.SubjectID)
	LEFT JOIN [ViCo].[Clinicos].[H7PDA]					h7pda ON (h7pda.SubjectID = Sujeto.SubjectID)
WHERE Sujeto.forDeletion = 0



UNION ALL



-- Centro de Salud
SELECT
	Sujeto.[SubjectID]


	-- ID & elegibility
	-----------------------------------------------
	--,pacienteInscritoViCo
	,CASE WHEN
			(
				sujeto.pacienteInscritoViCo = 2
				AND (sujeto.elegibleDiarrea = 1 OR sujeto.elegibleRespira = 1 OR sujeto.elegibleFebril = 1)
				AND sujeto.SASubjectID IS NOT NULL
				AND YEAR(sujeto.fechaHoraAdmision) >= 2016
				AND sujeto.pdainsertversion LIKE '12%'
			)
	 THEN 1
	  WHEN 
				(
						sujeto.SubjectID like '95DD8258-E586-4517-AC78-001507FEABFB' OR
						sujeto.SubjectID  like '80968BE5-0C58-4D2C-8510-2274A8BCFCC3' OR
						sujeto.SubjectID  like '006E07F7-6506-416A-9AA4-2C0BB7C5F75A' OR
						sujeto.SubjectID  like '627590DD-6A39-4282-A8A5-436384C6E8F7' OR
						sujeto.SubjectID  like '1D112EB1-7D73-40C8-8B90-6579C9D16AAE' OR
						sujeto.SubjectID  like '15B97789-99A2-4500-AA3D-6964F79E3E49' OR
						sujeto.SubjectID  like '6AE54446-83C7-436A-A329-BEF044EB9FFD' OR
						sujeto.SubjectID  like '6897294C-2EA3-47C4-B326-DE9C498F63EC' OR
						sujeto.SubjectID  like 'D5B96798-A3F9-4A63-8195-EF4F57EF8DAD' OR
						sujeto.SubjectID  like 'B1060287-7761-4ED0-A754-3346B1E332F1' OR
						sujeto.SubjectID  like '25A68BCD-58E8-416A-8040-3B2AB0C9D07E' OR
						sujeto.SubjectID  like 'CEF6B081-223D-4849-914C-4004DED09E79' OR
						sujeto.SubjectID  like '385A3B4D-8870-4927-B6AD-8851B0D8BF1A' OR
						sujeto.SubjectID  like '95F14C7E-BB3C-4D86-A6DC-E6EE2D7A579F' OR
						sujeto.SubjectID  like 'F8D95B40-6BFD-45AF-8681-ECFFE09E330F' OR
						sujeto.SubjectID  like 'DF72BCAD-440F-4DE1-A3A5-F41D52AA9012' OR
						sujeto.SubjectID  like 'F84DF0A8-6656-449B-B0BF-42A4AFE7DAC6' 
				) THEN 0
	 ELSE sujeto.pacienteInscritoViCo
	END pacienteInscritoViCo
	,Sujeto.SASubjectID

	,elegibleDiarrea
	,elegibleRespira
	,elegibleNeuro
	,elegibleFebril
	-----------------------------------------------


	-- Dates
	-----------------------------------------------
	,fechaHoraAdmision
	,epiWeekAdmision
	,epiYearAdmision
	-----------------------------------------------


	-- Consent
	-----------------------------------------------
	,consentimientoVerbal
	,consentimientoEscrito
	,asentimientoEscrito
	-----------------------------------------------


	-- Site location
	-----------------------------------------------
	,SubjectSiteID
	,[Sitios].NombreShortName					AS	[SiteName]
	,Sitios.TipoSitio AS SiteType
	,Sitios.DeptoShortName AS SiteDepartamento
	-----------------------------------------------


	-- Patient Location
	-----------------------------------------------
	,Sujeto.departamento
	,Sujeto.municipio
	, CASE [Sujeto].PDAInsertVersion 
			WHEN '12.1.1'	THEN  NULL 
							ELSE [Sujeto].[comunidad]								
		  END												AS [comunidad]
		, CASE [Sujeto].PDAInsertVersion 
			WHEN '12.1.1'	THEN [Sujeto].[comunidad]		
							ELSE NULL 
		  END												AS [censo_codigo]
		, CASE [Sujeto].PDAInsertVersion 
			WHEN '12.1.1'	THEN (SELECT comunidad FROM ViCo.LegalValue.centros_poblados WHERE CONVERT(INT,ISNULL([Sujeto].[comunidad],0)) = cod_censo)		
							ELSE NULL 
		  END												AS [censo_comunidad]
	,HUSarea =
		CASE
			WHEN
				(
					Sujeto.departamento = 6
					AND SubjectSiteID IN (1, 2, 3, 4, 5, 6, 7)
					AND Sujeto.municipio IN (601, 602, 603, 604, 605, 606, 607, 610, 612, 613, 614)
				)
				OR
				(
					Sujeto.departamento = 9
					AND SubjectSiteID IN (9, 12, 13, 14, 15)
					AND Sujeto.municipio IN (901, 902, 903, 909, 910, 911, 913, 914, 916, 923)
				)
				OR
				(
					Sujeto.departamento = 1
					AND SubjectSiteID = 11
				)
			THEN 1
			ELSE 2
		END

	,NombreDepto.Text AS NombreDepartamento
	,NombreMuni.Text AS NombreMunicipio
	-----------------------------------------------


	-- Demographic
	-----------------------------------------------
	,sexo
	,edadAnios
	,edadMeses
	,edadDias
	,fechaDeNacimiento=CONVERT (DATE,[fechaDeNacimiento],113)
	,Sujeto.pacienteGrupoEtnico
	-----------------------------------------------


	-- Death information
	-----------------------------------------------
	,muerteViCo =
		CASE
			WHEN egresoTipo  = 4 OR seguimientoPacienteCondicion = 3 THEN 1
			ELSE 2
		END

	,muerteViCoFecha = 
		CASE
			WHEN egresoTipo = 4 THEN Sujeto.PDAInsertDate
			WHEN seguimientoPacienteCondicion = 3 THEN seguimientoPacienteMuerteFecha
			ELSE NULL
		END

	,muerteSospechoso = --C0, C1CV, C1CE
		CASE
			WHEN ConsentimientoVerbalNoRazonMurio = 1 OR ConsentimientoEscritoMurio = 1 THEN 1
			ELSE 2
		END

	,muerteSospechosoFecha =
		CASE
			WHEN ConsentimientoVerbalNoRazonMurio = 1 OR ConsentimientoEscritoMurio = 1 THEN Sujeto.PDAInsertDate
			ELSE NULL
		END

	,NULL AS muerteHospital

	,muerteCualPaso =
		-- 1 = Tamizaje/Consentimiento
		-- 2 = Durante Entrevista (Inscrito, but NOT everything IS done HCP11 filled out probably)
		-- 3 = Antes de egreso (C7)
		-- 4 = Seguimiento (HCP9)
		CASE	
			WHEN ConsentimientoVerbalNoRazonMurio = 1 OR ConsentimientoEscritoMurio = 1 THEN 1
			WHEN terminoManeraCorrectaNoRazon = 3 THEN 2
			WHEN egresoTipo = 4 THEN 3
			WHEN seguimientoPacienteCondicion = 3THEN 4
			ELSE NULL
		END

	,NULL AS moribundoViCo --C7?
	,NULL AS moribundoViCoFecha --C7?
	,NULL AS moribundoSospechoso
	,NULL AS moribundoSospechosoFecha
	-----------------------------------------------


	-----------------------------------------------
	,NULL tamizadoEmergencia
	,NULL actualAdmitido
	,presentaIndicacionDiarrea
	,indicacionDiarrea
	,indicacionDiarrea_otra
	, NULL medirTemperaturaCPrimeras24Horas
	,temperaturaPrimeras24Horas
	,NULL sintomasFiebrePudoMedirTemp 
	,NULL sintomasFiebreTemperatura
	-------------------------------------------
	,NULL--h2rem.tempmax_ingr_reg
    ,NULL--h2rem.tempmax_ingr
    ---------------------------------------------
	,NULL AS ingresoPlanBPlanC
	,NULL AS gradoDeshidratacionRegistrado
	,NULL AS gradoDeshidratacion
	,NULL AS conteoGlobulosBlancos
	,NULL AS diferencialAnormal
	,sintomasFiebre
	,sintomasFiebreDias
	,ninioVomitaTodo
	,ninioBeberMamar
	,ninioTuvoConvulsiones
	,ninioTieneLetargia
	,diarreaUltimos7Dias
	,diarreaComenzoHaceDias
	,diarreaMaximoAsientos1Dia
	,diarreaOtroEpisodioSemanaAnterior
	--,sujeto.muestraHecesColecta
	,CASE WHEN sujeto.muestraHecesColecta = 2 and lab.pruebaCultivoHizo = 1  
		  THEN 1
		  ELSE sujeto.muestraHecesColecta
	 END muestraHecesColecta
	------------------------------------
	,C5V.muestraHecesColectaTipo
	-------------------------------------
	,sujeto.MuestraHecesNoRazon
	,sujeto.MuestraHecesNoRazonOtra_esp
	,sujeto.muestraHecesHisopoSecoNoRazon
	,sujeto.muestraHecesHisopoSecoNoRazonOtra_esp
	,sujeto.muestraHecesHisopoSecoFechaHora
	,sujeto.muestraHecesHisopoCaryBlairColecta
	,sujeto.muestraHecesHisopoCaryBlairNoRazon
	,sujeto.muestraHecesHisopoCaryBlairNoRazonOtra_esp
	,sujeto.muestraHecesHisopoCaryBlairFechaHora
	,sujeto.muestraHecesHisopoCaryBlairTipo
	,sujeto.muestraHecesEnteraColecta
	,sujeto.muestraHecesEnteraNoRazon
	,sujeto.muestraHecesEnteraNoRazonOtra_Esp
	,sujeto.muestraHecesEnteraFechaHora
	,sujeto.muestraHecesEnteraLiquida
	,sujeto.muestraHecesEnteraCubreFondo
	,hxD_diarreaActual
	,hxD_diarreaActualHaceDias
	,(SELECT hxD_diarreaAguaArroz FROM ViCo.Clinicos.C2C WHERE C2C.SubjectID = Sujeto.SubjectID AND C2C.forDeletion = 0) hxD_diarreaAguaArroz
	,hxD_ConSangre
	,hxD_ConMoco
	,CASE WHEN (Sujeto.sintomasEnfermDiarreaVomitos IS NULL) THEN C2L.hxC_Vomitos		ELSE Sujeto.sintomasEnfermDiarreaVomitos END as hxC_Vomitos
	,CASE WHEN (Sujeto.sintomasEnfermDiarreaVomitos IS NULL) THEN C2L.hxC_VomitosVeces	ELSE Sujeto.sintomasEnfermDiarreaVomitosVeces END as hxC_VomitosVeces
	,CASE WHEN (Sujeto.sintomasEnfermDiarreaVomitos IS NULL) THEN C2L.hxC_Vomitos8Dias	ELSE Sujeto.sintomasEnfermDiarreaVomitos8Dias END as hxC_Vomitos8Dias
	,CASE WHEN (Sujeto.sintomasEnfermDiarreaVomitos IS NULL) THEN C2L.hxC_VomitosActual ELSE Sujeto.sintomasEnfermDiarreaVomitosActual END as hxC_VomitosActual
	-----
	,C2L.hxC_FaltaApetito
	,C2L.hxC_Nausea
	,C2L.hxC_DebilidadGeneral
	,C2F.casaMaterialTecho
	,C2F.casaTelevision
	,C2F.casaCuantasPersonasViven
	,C2F.pacientePecho2Anios
	,C2F.casaCuantosDormitorios
	,C2F.pecho
    ,C2F.pechoMeses
    ,C2F.pechoExclusiva
    ,C2F.UsoFuenteAgua
    ,C2F.TxAgua
    ,C2F.ComoTrataAguaaguaTrata_cloran
    ,C2F.ComoTrataAguaaguaTrata_dejanReposar
    ,C2F.ComoTrataAguaaguaTrata_FiltroTela
    ,C2F.ComoTrataAguaaguaTrata_hierven
    ,C2F.ComoTrataAguaaguaTrata_purificaLuzSolar
    ,C2F.ComoTrataAguaaguaTrata_usoFiltro
    ,C2F.TipoSanitario
    ,C2F.TipoSanitario_otro
    ,C2F.inodoroLetrina_Drenaje
    ,C2F.servicioLetrinaservicio_basura
    ,C2F.servicioLetrinaservicio_descubiertoLejos
    ,C2F.servicioLetrinaservicio_descubiertoPatio
    ,C2F.servicioLetrinaservicio_drenajeOzanja
    ,C2F.servicioLetrinaservicio_noResponde
    ,C2F.servicioLetrinaservicio_noSabe
    ,C2F.servicioLetrinaservicio_otro
    ,C2F.servicioLetrinaservicio_seEntierra
    ,C2F.servicioLetrina_otro
    ,C2F.inodoroUbicacion
    ,C2F.inodoroComparte
    ,C2F.inodoroComparte_cuantos
    ,C2F.inodoroComparte_cualquiera
    ,C2F.inodoroLimpia
    ,C2F.inodoroLimpia_frec
    ,C2F.desechoHeces
    ,C2F.desechoHeces_otro
	-----
	,hxD_calambresDolorAbdominal
	,hxD_condicionIntestinal
	,hxD_condicionIntestinal_esp
	,hxD_bebeConSed
	,hxD_irritableIncomodoIntranquilo
	,centroRehidratacionTipo
	,otroTratamiento1erRecibioMedicamento
	,otroTratamiento1erAntibioticos
	,otroTratamiento1erSuerosSalesHidracionCasero
	,otroTratamiento2doRecibioMedicamento
	,otroTratamiento2doAntibioticos
	,otroTratamiento2doSuerosSalesHidracionCasero
	,NULL AS otroTratamiento3erRecibioMedicamento
	,NULL AS otroTratamiento3erAntibioticos
	,NULL AS otroTratamiento3erSuerosSalesHidracionCasero
	,medUltimas72HorasAntiB
	,tomadoSuerosSalesUltimas72hora
	,claseSRORecibido
	,sujeto.enfermedadesCronicasVIHSIDA
	,sujeto.enfermedadesCronicasOtras
	,sujeto.enfermedadesCronicasInfoAdicional
	----------------------------------------
	,C2A.lactanciaMaternaExclusiva
	------------------------------------
	,sujeto.embarazada
	,sujeto.embarazadaMeses
	,sujeto.tieneFichaVacunacion
	,sujeto.vacunaRotavirusRecibido
	,sujeto.vacunaRotavirusDosis
	,Sujeto.casaNiniosGuareriaInfantil
	,Sujeto.pacientePachaPecho
	,Sujeto.parentescoGradoEscolarCompleto
	,Sujeto.patienteGradoEscolarCompleto
	,Sujeto.familiaIngresosMensuales
	,Sujeto.fuentesAguaChorroDentroCasaRedPublica
	,Sujeto.fuentesAguaChorroPublico
	,Sujeto.fuentesAguaChorroPatioCompartidoOtraFuente
	,Sujeto.fuentesAguaLavaderosPublicos
	,Sujeto.fuentesAguaPozoPropio
	,Sujeto.fuentesAguaPozoPublico
	,Sujeto.fuentesAguaCompranAguaEmbotellada
	,Sujeto.fuentesAguaDeCamionCisterna
	,Sujeto.fuentesAguaLluvia
	,Sujeto.fuentesAguaRioLago
	,Sujeto.casaAlmacenanAgua
	,Sujeto.aguaLimpiarTratar
	,Sujeto.aguaLimpiarTratarHierven
	,Sujeto.aguaLimpiarTratarQuimicos
	,Sujeto.aguaLimpiarTratarFiltran
	,Sujeto.aguaLimpiarTratarSodis
	,Sujeto.aguaLimpiarTratarOtro
	,Sujeto.aguaLimpiarTratarOtro_esp
	,Sujeto.casaMaterialPiso
	, sujeto.casaEnergiaElectrica
	,Sujeto.casaRefrigeradora
	,Sujeto.casaComputadora
	,Sujeto.casaRadio
	,Sujeto.casaLavadora
	,Sujeto.casaSecadora
	,Sujeto.casaTelefono
	,Sujeto.casaMicroondas
	,Sujeto.casaCarroCamion
	,Sujeto.factoresRiesgoInfoAdicional
	, C2F.combustibleLenia
	, C2F.combustibleResiduosCosecha
	, C2F.combustibleCarbon
	, C2F.combustibleGas
	, C2F.combustibleElectricidad
	, C2F.combustibleOtro
	
	,diarreaExamenFisicoEnfermeraOjos
	,diarreaExamenFisicoEnfermeraMucosaOral
	,diarreaExamenFisicoEnfermeraRellenoCapillar
	,diarreaExamenFisicoEnfermeraPellizcoPiel
	,diarreaExamenFisicoEnfermeraMolleraHundida
	,diarreaExamenFisicoEnfermeraEstadoMental
	,pacienteTallaMedida
	,pacienteTallaCM1
	,pacienteTallaCM2
	,pacienteTallaCM3
	,pacientePesoMedida
	,pacientePesoLibras1
	,pacientePesoLibras2
	,pacientePesoLibras3
	,Sujeto.PDAInsertDate AS egresoMuerteFecha

	,egresoTipo
	,NULL AS egresoCondicion

	,temperaturaPrimeras24Horas AS temperaturaPrimeras24HorasAlta
	,egresoDiagnostico1
	,egresoDiagnostico1_esp
	,egresoDiagnostico2
	,egresoDiagnostico2_esp

	--,NULL AS RecibioAcyclovir
	--,CentroMedicamentoAmantadina AS RecibioAmantadina
	,CentroMedicamentoAmikacina AS RecibioAmikacina
	,CentroMedicamentoAmoxicilinaAcidoClavulanico AS RecibioAmoxAcidoClavulanico
	,CentroMedicamentoAmoxicilina AS RecibioAmoxicilina
	,CentroMedicamentoAmpicilina AS RecibioAmpicilina
	,CentroMedicamentoAmpicilinaSulbactam AS RecibioAmpicilinaSulbactam
	,CentroMedicamentoAzitromicina AS RecibioAzitromicina
	,NULL  AS RecibioCefadroxil
	,CentroMedicamentoCefalotina AS RecibioCefalotina
	,NULL AS RecibioCefepime
	,CentroMedicamentoCefotaxima AS RecibioCefotaxima
	,CentroMedicamentoCefotriaxone AS RecibioCeftriaxone
	,CentroMedicamentoCefotriaxone AS RecibioCefuroxima
	,CentroMedicamentoCiprofloxacina AS RecibioCiprofloxacina
	,CentroMedicamentoClaritromicina AS RecibioClaritromicina /*INCLUDE*/
	,CentroMedicamentoClindamicina AS RecibioClindamicina
	,CentroMedicamentoCloranfenicol AS RecibioCloranfenicol
	--,CentroMedicamentoDexametazona AS RecibioDexametazona
	,CentroMedicamentoDicloxicina AS RecibioDicloxicina
	,CentroMedicamentoDoxicilina AS RecibioDoxicilina
	,CentroMedicamentoEritromicina AS RecibioEritromicina
	,CentroMedicamentoGentamicina AS RecibioGentamicina
	--,CentroMedicamentoHidrocortizonaSuccinatio AS RecibioHidrocortizonaSuccin
	,NULL AS RecibioImipenem
	--,CentroMedicamentoIsoniacida
	--,CentroMedicamentoLevofloxacina
	--,CentroMedicamentoMeropenem AS RecibioMeropenem
	--,CentroMedicamentoMetilprednisolona AS RecibioMetilprednisolona
	,CentroMedicamentoMetronidazol AS RecibioMetronidazol
	,CentroMedicamentoOfloxacina AS RecibioOfloxacina
	--,CentroMedicamentoOseltamivir AS RecibioOseltamivir
	,CentroMedicamentoOtro AS RecibioOtroAntibiotico
	,CentroRecibidoOtro_esp AS RecibioOtroAntibEspecifique
	,NULL AS RecibioOxacilina
	,CentroMedicamentoPenicilina AS RecibioPenicilina
	--,NULL AS RecibioPerfloxacinia
	,CentroMedicamentoPirazinamida AS RecibioPirazinamida /*INCLUDE*/
	--,CentroMedicamentoPrednisona AS RecibioPrednisona
	,CentroMedicamentoRifampicina AS RecibioRifampicina /*INCLUDE*/
	,CentroMedicamentoTMPSMZ AS RecibioTrimetroprimSulfame
	,CentroMedicamentoVancomicina AS RecibioVancomicina

	--,h7.sueroSalesDurAdmision
	--,h7.liquidosIntravenososDurAdmision
	,seguimientoPacienteCondicion
	-----------------------------------------------


	-- PDA Insert Info
	-----------------------------------------------
	,Sujeto.PDAInsertDate
	,Sujeto.PDAInsertVersion
	-----------------------------------------------


	-- Laboratory Results
	-----------------------------------------------
	,LAB.recepcionMuestraOriginal
	,LAB.recepcionMuestraHisopo
	,LAB.recepcionMuestraPVA
	,LAB.recepcionMuestraFormalina
	,LAB.floranormal
	,LAB.salmonella
	,LAB.salmonellaSp
	,LAB.shigella
	,LAB.shigellaSp
	,LAB.campylobacter
	,CASE LAB.campylobacterSp
		WHEN 'jejuni'  THEN 'jejuni'
		WHEN 'jejunii' THEN 'jejuni'
		WHEN 'coli'	   THEN 'coli'
		WHEN 'Coli'	   THEN 'coli'
		ELSE LAB.campylobacterSp
	 END AS campylobacterSp
	,LAB.otro
	,LAB.pruebaRotavirusHizo
	,LAB.rotavirus
	,LAB.pruebaExamenFrescoHizo
	,LAB.pruebaExamenTricromicoHizo
	,LAB.pruebaExamenIFHizo
	,LAB.ascaris
	,LAB.trichiuris
	,LAB.nana
	,LAB.diminuta
	,LAB.uncinaria
	,LAB.enterobius
	,EntamoebaColi = LAB.ecoli
	,LAB.giardia
	,CASE WHEN(LAB.ID_Paciente IS NULL AND LAB_CYCLO_CRYPTO.SASubjectID IS NULL) THEN NULL
		ELSE 
			CASE WHEN(ISNULL(LAB.crypto,0) = 1 OR ISNULL(LAB_CYCLO_CRYPTO.cryptosporidium,0) = 1) THEN 1 ELSE 0 END 
	 END AS crypto
	,LAB_CYCLO_CRYPTO.cyclospora
	,LAB.ioda
	,LAB.endolimax
	,LAB.chilo
	,LAB.blasto
	,LAB.NSOP
	,LAB.observaciones
	,LAB.pruebaCultivoHizo
	,LAB.pruebaExamenFrescoSpA
	,LAB.pruebaExamenFrescoSpB
	,LAB.pruebaExamenFrescoSpC
	,LAB.pruebaExamenTricromicoSpA
	,LAB.pruebaExamenTricromicoSpB
	,LAB.pruebaExamenTricromicoSpC
	,LAB.pruebaExamenIFSpA
	,LAB.pruebaExamenIFSpB
	--,LAB.PCREColi
	--,LAB.pruebaPCREColiHizo
	--,LAB.pruebaRotavirusTipificacionHizo
	--,LAB.rotavirusTipificacion
	,CASE WHEN rota.pruebaRotavirusTipificacionHizo IS NOT NULL THEN rota.pruebaRotavirusTipificacionHizo
		  ELSE 
				CASE WHEN rotaAbril2016.pruebaRotavirusTipificacionHizo IS NOT NULL THEN rotaAbril2016.pruebaRotavirusTipificacionHizo
				ELSE NULL END 
	 END AS		pruebaRotavirusTipificacionHizo 
	,CASE WHEN rota.rotavirusTipificacion IS NOT NULL THEN rota.rotavirusTipificacion
		  ELSE
				CASE WHEN rotaAbril2016.Genotype IS NOT NULL THEN rotaAbril2016.Genotype
				ELSE NULL END
	 END AS  rotavirusTipificacion
	,LAB.recepcionMuestraCongeladas
	,LAB.strong
	,LAB.recepcionMuestraNorovirus
	,LAB.Observaciones_UVG
	,LAB.taenia
	-----------------------------------------------


	-- Norovirus
	-----------------------------------------------
	,Norovirus.labNumeroNorovirus
	,Norovirus.fechaExtraccion
	,Norovirus.RTqPCR_RNP
	,CASE WHEN Norovirus.RTqPCR_NV1 IS NULL THEN sd.Norovirus1 ELSE Norovirus.RTqPCR_NV1 END AS RTqPCR_NV1
	,CASE WHEN Norovirus.RTqPCR_NV2 IS NULL THEN sd.Norovirus2 ELSE norovirus.RTqPCR_NV2 END AS RTqPCR_NV2
	,Norovirus.RTqPCR_RNP_CT
	,CASE WHEN Norovirus.RTqPCR_NV1_CT IS NULL THEN sd.ct_Norovirus1 ELSE CAST(Norovirus.RTqPCR_NV1_CT AS nvarchar) END AS RTqPCR_NV1_CT
	,CASE WHEN Norovirus.RTqPCR_NV2_CT IS NULL THEN sd.ct_Norovirus2 ELSE CAST(Norovirus.RTqPCR_NV2_CT AS nvarchar) END AS RTqPCR_NV2_CT
	,Norovirus.observaciones AS ObservacionesNorovirus
	,NAS.norovirusTipificacionHizo
	,NAS.NoV_GI_RegB
	,NAS.NoV_GI_RegC
	,NAS.NoV_GII_RegB
	,NAS.NoV_GII_RegC
	-----------------------------------------------


	-- Sensiblidad Antibiotica
	-----------------------------------------------
	,Sensibilidad.pruebaTrimetoprinSulfaSensibilidad
	,Sensibilidad.pruebaTetraciclinaSensibilidad
	,Sensibilidad.pruebaKanamicinaSensibilidad
	,Sensibilidad.pruebaGentamicinaSensibilidad
	,Sensibilidad.pruebaEstreptomicinaSensibilidad
	,Sensibilidad.pruebaCloranfenicolSensibilidad
	,Sensibilidad.pruebaCiprofloxacinaSensiblidad
	,Sensibilidad.pruebaCeftriaxoneSensibilidad
	,Sensibilidad.pruebaAmpicilinaSensibilidad
	,Sensibilidad.pruebaAmoxicilinaSensibilidad
	,Sensibilidad.pruebaAcNalidixicoSensibilidad
	,Sensibilidad.observaciones AS ObservacionesSensibilidad
	-----------------------------------------------
	-- E.coli EscheridiaColi
	-----------------------------------------------
	--,CASE WHEN EscheridiaColi.EPEC IS NULL THEN ecoli2014.epec ELSE EscheridiaColi.EPEC  END  AS EPEC
	--,CASE WHEN EscheridiaColi.ETEC IS NULL THEN ecoli2014.etec ELSE EscheridiaColi.ETEC END   AS ETEC
	--,EscheridiaColi.STEC
	,	CASE WHEN (
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.hlyA=1 
							OR ecoli2011.eaeA=1 
							OR ecoli2011.stx2=1 
							OR ecoli2011.stx1=1 
						THEN 1 ELSE 0 END
					ELSE ECOLI2014.epec 
					END --AS EPEC
				)IS NOT NULL 
				OR  
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.LT=1
							OR ecoli2011.ST1a=1
							OR ecoli2011.ST1b=1
						THEN 1 ELSE 0 END
					ELSE ecoli2014.etec
					END --AS ETEC
				)IS NOT NULL
	 )THEN 1
	 ELSE NULL
	 END ecoliHizo
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.hlyA ELSE ecoli2014.epec_EHEC_hlyA_534 END AS hlyA
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.eaeA ELSE ecoli2014.epec_eaeA_384 END AS eaeA
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.stx2 ELSE ecoli2014.epec_stx2_255 END AS stx2
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.stx1 ELSE ecoli2014.epec_stx1_180 END AS sxt1
	,CASE WHEN 
	case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END 
	IS NULL
	AND 
	--ecoliHizo
	CASE WHEN (
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.hlyA=1 
							OR ecoli2011.eaeA=1 
							OR ecoli2011.stx2=1 
							OR ecoli2011.stx1=1 
						THEN 1 ELSE 0 END
					ELSE ECOLI2014.epec 
					END --AS EPEC
				)IS NOT NULL 
				OR  
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.LT=1
							OR ecoli2011.ST1a=1
							OR ecoli2011.ST1b=1
						THEN 1 ELSE 0 END
					ELSE ecoli2014.etec
					END --AS ETEC
				)IS NOT NULL
	 )THEN 1
	 ELSE NULL
	 END 
	 IS NOT NULL
	 THEN 0
	 ELSE 
	 CASE WHEN CASE WHEN ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END LIKE '%negative%' THEN 0
			 WHEN CASE WHEN ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END LIKE '%positive%' THEN 1
			 ELSE CASE WHEN ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END 
	 END
	END 
	AS bfpa
	,CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
			CASE WHEN ecoli2011.hlyA=1 
			       OR ecoli2011.eaeA=1 
			       OR ecoli2011.stx2=1 
			       OR ecoli2011.stx1=1 
			THEN 1 ELSE 0 END
		ELSE ECOLI2014.epec 
	  END AS EPEC
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.LT ELSE ecoli2014.etec_LT_696nt END AS LT
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.ST1a ELSE ecoli2014.etec_ST1a_186nt END AS ST1a
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.ST1b ELSE ecoli2014.etec_ST1b_166nt END AS ST1b
	,CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
			CASE WHEN ecoli2011.LT=1
				   OR ecoli2011.ST1a=1
				   OR ecoli2011.ST1b=1
			THEN 1 ELSE 0 END
		ELSE ecoli2014.etec
	 END AS ETEC
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.LT ELSE ecoli_cdc2012.LT END AS CDC_LT
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.ST1a ELSE ecoli_cdc2012.ST1a END AS CDC_ST1a
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.ST1b ELSE ecoli_cdc2012.ST1b END AS CDC_ST1b
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.hlyA ELSE ecoli_cdc2012.hlyA END AS CDC_hlyA
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.eaeA ELSE ecoli_cdc2012.eaeA END AS CDC_eaeA
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.stx2 ELSE ecoli_cdc2012.stx2 END AS CDC_stx2
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.stx1 ELSE ecoli_cdc2012.stx1 END AS CDC_stx1
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END AS CDC_bfpa
	-----------------------------------------------
--ASTRO Y SAPO virus 
	,sd.[ASTROVIRUS]
    ,sd.[SAPOVIRUS]
    ,sd.[CT_ASTROVIRUS]
    ,sd.[CT_SAPOVIRUS]
    ,NAS.sapovirusTipificacionHizo
    ,NAS.SapovirusGenotipificacion
    ,NULL vesikariParametros
	,NULL mvs
	,NULL casoSeveroMVS   
	,NULL casoMuySeveroMVS
    ,NULL cuidadoIntensivoDias
    ,NULL salaIngreso
    ,C2F.contactoAnimalesCasa
FROM Clinicos.Todo_Centro_vw Sujeto
	LEFT JOIN Control.Sitios ON Sujeto.SubjectSiteID = Sitios.SiteID
	LEFT JOIN LegalValue.LV_DEPARTAMENTO NombreDepto ON Sujeto.departamento = NombreDepto.Value
	LEFT JOIN LegalValue.LV_MUNICIPIO NombreMuni ON Sujeto.municipio = NombreMuni.Value
	LEFT JOIN Lab.DiarreaResultados LAB ON Sujeto.SASubjectID = Lab.ID_Paciente
	LEFT JOIN Lab.NorovirusResultados Norovirus ON Sujeto.SASubjectID = Norovirus.ID_Paciente
	LEFT JOIN Lab.DiarreaResultadosAntibiotiocs Sensibilidad ON Sujeto.SASubjectID = Sensibilidad.ID_Paciente
	-- FM[2011-11-10]: Temporal mientras corrigo Todo_Centro
	LEFT JOIN Clinicos.C2L ON C2L.SubjectID = Sujeto.SubjectID AND C2L.forDeletion = 0
	LEFT JOIN Clinicos.C2F ON C2F.SubjectID = Sujeto.SubjectID AND C2F.forDeletion = 0
	--LEFT JOIN Lab.EColi_Resultados EscheridiaColi ON EscheridiaColi.SubjectID = Sujeto.SubjectID 
	--LEFT JOIN sp.Sindrome_Diarreico sd  ON sujeto.SASubjectID COLLATE database_default= sd.SaSubjectID COLLATE database_default --Se unifico los datos de sharepoint a una nueva tabla lab.PCR_DIARREA y se creo la vista lab.sindrome_diarreico
	LEFT JOIN Lab.ResultadosEcoli2014 ecoli2014 ON (Sujeto.SASubjectID = ecoli2014.SASubjectID)
	LEFT JOIN lab.Sindrome_Diarreico sd ON Sujeto.SASubjectID= sd.sampleName
	LEFT JOIN LabEnvio.RotavirusGenotipificacion rota ON (Sujeto.SASubjectID = rota.ID_Paciente)
	LEFT JOIN LabEnvio.RotavirusGenotipificacion_Abril2016 rotaAbril2016 ON Sujeto.SASubjectID = rotaAbril2016.SASubjectID --JD:2016/05/02 result Geno Rota
	LEFT JOIN [Lab].[Cyclo_Crypto_Resultados] LAB_CYCLO_CRYPTO ON (LAB_CYCLO_CRYPTO.SASubjectID = Sujeto.SASubjectID) --agregado para resultados de cyclo y crypto
	LEFT JOIN lab.EColi_ETEC_EPEC_Resultados_GUA_2011 ecoli2011 ON ecoli2011.SASubjectID= sujeto.SASubjectID --datos crudos de ecoli realizados en guatemala (hasta 2011)
	LEFT JOIN lab.EColi_ETEC_EPEC_Resultados_CDC_2009 ecoli_cdc2009 ON SUJETO.SaSubjectID= ecoli_cdc2009.SaSubjectID  --datos crudos de confirmaciones cdc 2009
	LEFT JOIN lab.EColi_ETEC_EPEC_Resultados_CDC_2012 ecoli_cdc2012 ON SUJETO.SaSubjectID= ecoli_cdc2012.SaSubjectID  --datos crudos de confirmaciones cdc hasta 2011
	LEFT JOIN Clinicos.C2A ON Sujeto.SubjectID= C2A.SubjectID
	LEFT JOIN Clinicos.C5V ON Sujeto.SubjectID= C5V.SubjectID
	LEFT JOIN ViCo.Analysis.NAS_Envio_CDC_Results NAS ON (NAS.SASubjectID = Sujeto.SASubjectID)
	WHERE Sujeto.forDeletion = 0



UNION ALL



-- Puesto de Salud
SELECT
	Sujeto.[SubjectID]


	-- ID & elegibility
	-----------------------------------------------
	--,pacienteInscritoViCo
	,CASE WHEN
			(
				sujeto.pacienteInscritoViCo = 2
				AND (sujeto.elegibleDiarrea = 1 OR sujeto.elegibleRespira = 1 OR sujeto.elegibleFebril = 1)
				AND sujeto.SASubjectID IS NOT NULL
				AND YEAR(sujeto.fechaHoraAdmision) >= 2016
				AND sujeto.pdainsertversion LIKE '12%'
			)
			THEN 1
			WHEN 
				(
						sujeto.SubjectID like '95DD8258-E586-4517-AC78-001507FEABFB' OR
						sujeto.SubjectID  like '80968BE5-0C58-4D2C-8510-2274A8BCFCC3' OR
						sujeto.SubjectID  like '006E07F7-6506-416A-9AA4-2C0BB7C5F75A' OR
						sujeto.SubjectID  like '627590DD-6A39-4282-A8A5-436384C6E8F7' OR
						sujeto.SubjectID  like '1D112EB1-7D73-40C8-8B90-6579C9D16AAE' OR
						sujeto.SubjectID  like '15B97789-99A2-4500-AA3D-6964F79E3E49' OR
						sujeto.SubjectID  like '6AE54446-83C7-436A-A329-BEF044EB9FFD' OR
						sujeto.SubjectID  like '6897294C-2EA3-47C4-B326-DE9C498F63EC' OR
						sujeto.SubjectID  like 'D5B96798-A3F9-4A63-8195-EF4F57EF8DAD' OR
						sujeto.SubjectID  like 'B1060287-7761-4ED0-A754-3346B1E332F1' OR
						sujeto.SubjectID  like '25A68BCD-58E8-416A-8040-3B2AB0C9D07E' OR
						sujeto.SubjectID  like 'CEF6B081-223D-4849-914C-4004DED09E79' OR
						sujeto.SubjectID  like '385A3B4D-8870-4927-B6AD-8851B0D8BF1A' OR
						sujeto.SubjectID  like '95F14C7E-BB3C-4D86-A6DC-E6EE2D7A579F' OR
						sujeto.SubjectID  like 'F8D95B40-6BFD-45AF-8681-ECFFE09E330F' OR
						sujeto.SubjectID  like 'DF72BCAD-440F-4DE1-A3A5-F41D52AA9012' OR
						sujeto.SubjectID  like 'F84DF0A8-6656-449B-B0BF-42A4AFE7DAC6' 
				) THEN 0
			ELSE pacienteInscritoViCo
	END pacienteInscritoViCo
	,Sujeto.SASubjectID

	,elegibleDiarrea
	,elegibleRespira
	,elegibleNeuro
	,elegibleFebril
	-----------------------------------------------


	-- Dates
	-----------------------------------------------
	,fechaHoraAdmision
	,epiWeekAdmision
	,epiYearAdmision
	-----------------------------------------------


	-- Consent
	-----------------------------------------------
	,consentimientoVerbal
	,consentimientoEscrito
	,asentimientoEscrito
	-----------------------------------------------


	-- Site location
	-----------------------------------------------
	,SubjectSiteID
	,[Sitios].NombreShortName								AS	[SiteName]
	,Sitios.TipoSitio AS SiteType
	,Sitios.DeptoShortName AS SiteDepartamento
	-----------------------------------------------


	-- Patient Location
	-----------------------------------------------
	,Sujeto.departamento
	,Sujeto.municipio
	,Sujeto.comunidad
	, NULL					AS [censo_codigo]
	, NULL					AS [censo_comunidad]
	,HUSarea =
		CASE
			WHEN
				(
					Sujeto.departamento = 6
					AND SubjectSiteID IN (1, 2, 3, 4, 5, 6, 7)
					AND Sujeto.municipio IN (601, 602, 603, 604, 605, 606, 607, 610, 612, 613, 614)
				)
				OR
				(
					Sujeto.departamento = 9
					AND SubjectSiteID IN (9, 12, 13, 14, 15)
					AND Sujeto.municipio IN (901, 902, 903, 909, 910, 911, 913, 914, 916, 923)
				)
				OR
				(
					Sujeto.departamento = 1
					AND SubjectSiteID = 11
				)
			THEN 1
			ELSE 2
		END

	,NombreDepto.Text AS NombreDepartamento
	,NombreMuni.Text AS NombreMunicipio
	-----------------------------------------------


	-- Demographic
	-----------------------------------------------
	,sexo
	,edadAnios
	,edadMeses
	,edadDias
	,fechaDeNacimiento=CONVERT (DATE,[fechaDeNacimiento],113)
	,Sujeto.pacienteGrupoEtnico
	-----------------------------------------------


	-- Death information
	-----------------------------------------------
	,muerteViCo =
		CASE
			WHEN egresoTipo  = 4 OR seguimientoPacienteCondicion = 3 THEN 1
			ELSE 2
		END

	,muerteViCoFecha = 
		CASE
			WHEN egresoTipo = 4 THEN Sujeto.PDAInsertDate
			WHEN seguimientoPacienteCondicion = 3 THEN seguimientoPacienteMuerteFecha
			ELSE NULL
		END

	,muerteSospechoso = -- P0, P1CV, P1CE
		CASE
			WHEN ConsentimientoVerbalNoRazonMurio = 1 OR ConsentimientoEscritoMurio = 1 THEN 1
			ELSE 2
		END

	,muerteSospechosoFecha =
		CASE
			WHEN ConsentimientoVerbalNoRazonMurio = 1 OR ConsentimientoEscritoMurio = 1 THEN Sujeto.PDAInsertDate
			ELSE NULL
		END

	,NULL AS muerteHospital

	,muerteCualPaso =
		-- 1 = Tamizaje/Consentimiento
		-- 2 = Durante Entrevista (Inscrito, but NOT everything IS done HCP11 filled out probably)
		-- 3 = Antes de egreso (P7)
		-- 4 = Seguimiento (HCP9)
		CASE	
			WHEN ConsentimientoVerbalNoRazonMurio = 1 OR ConsentimientoEscritoMurio = 1 THEN 1
			WHEN terminoManeraCorrectaNoRazon = 3 THEN 2
			WHEN egresoTipo = 4 THEN 3
			WHEN seguimientoPacienteCondicion = 3THEN 4
			ELSE NULL
		END

	,NULL AS moribundoViCo --P7?
	,NULL AS moribundoViCoFecha --P7?
	,NULL AS moribundoSospechoso
	,NULL AS moribundoSospechosoFecha
	-----------------------------------------------


	-----------------------------------------------
	,NULL tamizadoEmergencia
	,NULL actualAdmitido
	,presentaIndicacionDiarrea
	,indicacionDiarrea
	,indicacionDiarrea_otra
	,NULL medirTemperaturaCPrimeras24Horas 
	,temperaturaPrimeras24Horas
	,NULL sintomasFiebrePudoMedirTemp 
	,NULL sintomasFiebreTemperatura
	-------------------------------------------
	,NULL--h2rem.tempmax_ingr_reg
    ,NULL--h2rem.tempmax_ingr
    ---------------------------------------------
	,NULL AS ingresoPlanBPlanC
	,NULL AS gradoDeshidratacionRegistrado
	,NULL AS gradoDeshidratacion
	,NULL AS conteoGlobulosBlancos
	,NULL AS diferencialAnormal
	,sintomasFiebre
	,sintomasFiebreDias
	,ninioVomitaTodo
	,ninioBeberMamar
	,ninioTuvoConvulsiones
	,ninioTieneLetargia
	,diarreaUltimos7Dias
	,diarreaComenzoHaceDias
	,diarreaMaximoAsientos1Dia
	,diarreaOtroEpisodioSemanaAnterior
	--,muestraHecesColecta
	,CASE WHEN muestraHecesColecta = 2 and lab.pruebaCultivoHizo = 1  
		  THEN 1
		  ELSE muestraHecesColecta
	 END muestraHecesColecta
	------------------------------------
	,NULL--H5V.muestraHecesColectaTipo
	-------------------------------------
	,MuestraHecesNoRazon
	,MuestraHecesNoRazonOtra_esp
	,muestraHecesHisopoSecoNoRazon
	,muestraHecesHisopoSecoNoRazonOtra_esp
	,muestraHecesHisopoSecoFechaHora
	,muestraHecesHisopoCaryBlairColecta
	,muestraHecesHisopoCaryBlairNoRazon
	,muestraHecesHisopoCaryBlairNoRazonOtra_esp
	,muestraHecesHisopoCaryBlairFechaHora
	,muestraHecesHisopoCaryBlairTipo
	,muestraHecesEnteraColecta
	,muestraHecesEnteraNoRazon
	,muestraHecesEnteraNoRazonOtra_Esp
	,muestraHecesEnteraFechaHora
	,muestraHecesEnteraLiquida
	,muestraHecesEnteraCubreFondo
	,hxD_diarreaActual
	,hxD_diarreaActualHaceDias
	,(SELECT hxD_diarreaAguaArroz FROM ViCo.Clinicos.P2C WHERE P2C.SubjectID = Sujeto.SubjectID AND P2C.forDeletion = 0) hxD_diarreaAguaArroz
	,hxD_ConSangre
	,hxD_ConMoco
	,CASE WHEN (sintomasEnfermDiarreaVomitos IS NULL) THEN P2L.hxC_Vomitos		ELSE sintomasEnfermDiarreaVomitos END as hxC_Vomitos
	,CASE WHEN (sintomasEnfermDiarreaVomitos IS NULL) THEN P2L.hxC_VomitosVeces ELSE sintomasEnfermDiarreaVomitosVeces END as hxC_VomitosVeces
	,CASE WHEN (sintomasEnfermDiarreaVomitos IS NULL) THEN P2L.hxC_Vomitos8Dias ELSE sintomasEnfermDiarreaVomitos8Dias END as hxC_Vomitos8Dias
	,CASE WHEN (sintomasEnfermDiarreaVomitos IS NULL) THEN P2L.hxC_VomitosActual ELSE sintomasEnfermDiarreaVomitosActual END as hxC_VomitosActual
	-----
	,P2L.hxC_FaltaApetito
	,P2L.hxC_Nausea
	,P2L.hxC_DebilidadGeneral
	,P2F.casaMaterialTecho
	,P2F.casaTelevision
	,P2F.casaCuantasPersonasViven
	,P2F.pacientePecho2Anios
	,P2F.casaCuantosDormitorios
	,NULL--H3F.pecho
    ,NULL--H3F.pechoMeses
    ,NULL--H3F.pechoExclusiva
    ,NULL--H3F.UsoFuenteAgua
    ,NULL--H3F.TxAgua
    ,NULL--H3F.ComoTrataAguaaguaTrata_cloran
    ,NULL--H3F.ComoTrataAguaaguaTrata_dejanReposar
    ,NULL--H3F.ComoTrataAguaaguaTrata_FiltroTela
    ,NULL--H3F.ComoTrataAguaaguaTrata_hierven
    ,NULL--H3F.ComoTrataAguaaguaTrata_purificaLuzSolar
    ,NULL--H3F.ComoTrataAguaaguaTrata_usoFiltro
    ,NULL--H3F.TipoSanitario
    ,NULL--H3F.TipoSanitario_otro
    ,NULL--H3F.inodoroLetrina_Drenaje
    ,NULL--H3F.servicioLetrinaservicio_basura
    ,NULL--H3F.servicioLetrinaservicio_descubiertoLejos
    ,NULL--H3F.servicioLetrinaservicio_descubiertoPatio
    ,NULL--H3F.servicioLetrinaservicio_drenajeOzanja
    ,NULL--H3F.servicioLetrinaservicio_noResponde
    ,NULL--H3F.servicioLetrinaservicio_noSabe
    ,NULL--H3F.servicioLetrinaservicio_otro
    ,NULL--H3F.servicioLetrinaservicio_seEntierra
    ,NULL--H3F.servicioLetrina_otro
    ,NULL--H3F.inodoroUbicacion
    ,NULL--H3F.inodoroComparte
    ,NULL--H3F.inodoroComparte_cuantos
    ,NULL--H3F.inodoroComparte_cualquiera
    ,NULL--H3F.inodoroLimpia
    ,NULL--H3F.inodoroLimpia_frec
    ,NULL--H3F.desechoHeces
    ,NULL--H3F.desechoHeces_otro
	-----
	,hxD_calambresDolorAbdominal
	,hxD_condicionIntestinal
	,hxD_condicionIntestinal_esp
	,hxD_bebeConSed
	,hxD_irritableIncomodoIntranquilo
	,NULL AS centroRehidratacionTipo
	,otroTratamiento1erRecibioMedicamento
	,otroTratamiento1erAntibioticos
	,otroTratamiento1erSuerosSalesHidracionCasero
	,otroTratamiento2doRecibioMedicamento
	,otroTratamiento2doAntibioticos
	,otroTratamiento2doSuerosSalesHidracionCasero
	,NULL AS otroTratamiento3erRecibioMedicamento
	,NULL AS otroTratamiento3erAntibioticos
	,NULL AS otroTratamiento3erSuerosSalesHidracionCasero
	,medUltimas72HorasAntiB
	,tomadoSuerosSalesUltimas72hora
	,claseSRORecibido
	,enfermedadesCronicasVIHSIDA
	,enfermedadesCronicasOtras
	,enfermedadesCronicasInfoAdicional
	--------------------------------------------
	,NULL--lactanciaMaternaExclusiva
	--------------------------------------------
	,embarazada
	,embarazadaMeses
	,tieneFichaVacunacion
	,vacunaRotavirusRecibido
	,vacunaRotavirusDosis
	,Sujeto.casaNiniosGuareriaInfantil
	,Sujeto.pacientePachaPecho
	,Sujeto.parentescoGradoEscolarCompleto
	,Sujeto.patienteGradoEscolarCompleto
	,Sujeto.familiaIngresosMensuales
	,Sujeto.fuentesAguaChorroDentroCasaRedPublica
	,Sujeto.fuentesAguaChorroPublico
	,Sujeto.fuentesAguaChorroPatioCompartidoOtraFuente
	,Sujeto.fuentesAguaLavaderosPublicos
	,Sujeto.fuentesAguaPozoPropio
	,Sujeto.fuentesAguaPozoPublico
	,Sujeto.fuentesAguaCompranAguaEmbotellada
	,Sujeto.fuentesAguaDeCamionCisterna
	,Sujeto.fuentesAguaLluvia
	,Sujeto.fuentesAguaRioLago
	,Sujeto.casaAlmacenanAgua
	,Sujeto.aguaLimpiarTratar
	,Sujeto.aguaLimpiarTratarHierven
	,Sujeto.aguaLimpiarTratarQuimicos
	,Sujeto.aguaLimpiarTratarFiltran
	,Sujeto.aguaLimpiarTratarSodis
	,Sujeto.aguaLimpiarTratarOtro
	,Sujeto.aguaLimpiarTratarOtro_esp
	,Sujeto.casaMaterialPiso
	, sujeto.casaEnergiaElectrica
	,Sujeto.casaRefrigeradora
	,Sujeto.casaComputadora
	,Sujeto.casaRadio
	,Sujeto.casaLavadora
	,Sujeto.casaSecadora
	,Sujeto.casaTelefono
	,Sujeto.casaMicroondas
	,Sujeto.casaCarroCamion
	,Sujeto.factoresRiesgoInfoAdicional
	, P2F.combustibleLenia
	, P2F.combustibleResiduosCosecha
	, P2F.combustibleCarbon
	, P2F.combustibleGas
	, P2F.combustibleElectricidad
	, P2F.combustibleOtro
	
	
	
	
	,diarreaExamenFisicoEnfermeraOjos
	,diarreaExamenFisicoEnfermeraMucosaOral
	,diarreaExamenFisicoEnfermeraRellenoCapillar
	,diarreaExamenFisicoEnfermeraPellizcoPiel
	,diarreaExamenFisicoEnfermeraMolleraHundida
	,diarreaExamenFisicoEnfermeraEstadoMental
	,pacienteTallaMedida
	,pacienteTallaCM1
	,pacienteTallaCM2
	,pacienteTallaCM3
	,pacientePesoMedida
	,pacientePesoLibras1
	,pacientePesoLibras2
	,pacientePesoLibras3
	,Sujeto.PDAInsertDate AS egresoMuerteFecha

	,egresoTipo
	,NULL AS egresoCondicion

	,temperaturaPrimeras24Horas AS temperaturaPrimeras24HorasAlta
	,egresoDiagnostico1
	,egresoDiagnostico1_esp
	,egresoDiagnostico2
	,egresoDiagnostico2_esp

	--,NULL AS RecibioAcyclovir
	--,CentroMedicamentoAmantadina AS RecibioAmantadina
	,CentroMedicamentoAmikacina AS RecibioAmikacina
	,CentroMedicamentoAmoxicilinaAcidoClavulanico AS RecibioAmoxAcidoClavulanico
	,CentroMedicamentoAmoxicilina AS RecibioAmoxicilina
	,CentroMedicamentoAmpicilina AS RecibioAmpicilina
	,CentroMedicamentoAmpicilinaSulbactam AS RecibioAmpicilinaSulbactam
	,CentroMedicamentoAzitromicina AS RecibioAzitromicina
	,NULL  AS RecibioCefadroxil
	,CentroMedicamentoCefalotina AS RecibioCefalotina
	,NULL AS RecibioCefepime
	,CentroMedicamentoCefotaxima AS RecibioCefotaxima
	,CentroMedicamentoCefotriaxone AS RecibioCeftriaxone
	,CentroMedicamentoCefotriaxone AS RecibioCefuroxima
	,CentroMedicamentoCiprofloxacina AS RecibioCiprofloxacina
	,CentroMedicamentoClaritromicina AS RecibioClaritromicina /*INCLUDE*/
	,CentroMedicamentoClindamicina AS RecibioClindamicina
	,CentroMedicamentoCloranfenicol AS RecibioCloranfenicol
	--,CentroMedicamentoDexametazona AS RecibioDexametazona
	,CentroMedicamentoDicloxicina AS RecibioDicloxicina
	,CentroMedicamentoDoxicilina AS RecibioDoxicilina
	,CentroMedicamentoEritromicina AS RecibioEritromicina
	,CentroMedicamentoGentamicina AS RecibioGentamicina
	--,CentroMedicamentoHidrocortizonaSuccinatio AS RecibioHidrocortizonaSuccin
	,NULL AS RecibioImipenem
	--,CentroMedicamentoIsoniacida
	--,CentroMedicamentoLevofloxacina
	--,CentroMedicamentoMeropenem AS RecibioMeropenem
	--,CentroMedicamentoMetilprednisolona AS RecibioMetilprednisolona
	,CentroMedicamentoMetronidazol AS RecibioMetronidazol
	,CentroMedicamentoOfloxacina AS RecibioOfloxacina
	--,CentroMedicamentoOseltamivir AS RecibioOseltamivir
	,CentroMedicamentoOtro AS RecibioOtroAntibiotico
	,CentroRecibidoOtro_esp AS RecibioOtroAntibEspecifique
	,NULL AS RecibioOxacilina
	,CentroMedicamentoPenicilina AS RecibioPenicilina
	--,NULL AS RecibioPerfloxacinia
	,CentroMedicamentoPirazinamida AS RecibioPirazinamida /*INCLUDE*/
	--,CentroMedicamentoPrednisona AS RecibioPrednisona
	,CentroMedicamentoRifampicina AS RecibioRifampicina /*INCLUDE*/
	,CentroMedicamentoTMPSMZ AS RecibioTrimetroprimSulfame
	,CentroMedicamentoVancomicina AS RecibioVancomicina

	--,h7.sueroSalesDurAdmision
	--,h7.liquidosIntravenososDurAdmision
	,seguimientoPacienteCondicion
	-----------------------------------------------


	-- PDA Insert Info
	-----------------------------------------------
	,Sujeto.PDAInsertDate
	,Sujeto.PDAInsertVersion
	-----------------------------------------------


	-- Laboratory Results
	-----------------------------------------------
	,LAB.recepcionMuestraOriginal
	,LAB.recepcionMuestraHisopo
	,LAB.recepcionMuestraPVA
	,LAB.recepcionMuestraFormalina
	,LAB.floranormal
	,LAB.salmonella
	,LAB.salmonellaSp
	,LAB.shigella
	,LAB.shigellaSp
	,LAB.campylobacter
    ,CASE LAB.campylobacterSp
		WHEN 'jejuni'  THEN 'jejuni'
		WHEN 'jejunii' THEN 'jejuni'
		WHEN 'coli'	   THEN 'coli'
		WHEN 'Coli'	   THEN 'coli'
		ELSE LAB.campylobacterSp
	 END AS campylobacterSp
	,LAB.otro
	,LAB.pruebaRotavirusHizo
	,LAB.rotavirus
	,LAB.pruebaExamenFrescoHizo
	,LAB.pruebaExamenTricromicoHizo
	,LAB.pruebaExamenIFHizo
	,LAB.ascaris
	,LAB.trichiuris
	,LAB.nana
	,LAB.diminuta
	,LAB.uncinaria
	,LAB.enterobius
	,EntamoebaColi = LAB.ecoli
	,LAB.giardia
	,CASE WHEN(LAB.ID_Paciente IS NULL AND LAB_CYCLO_CRYPTO.SASubjectID IS NULL) THEN NULL
		ELSE 
			CASE WHEN(ISNULL(LAB.crypto,0) = 1 OR ISNULL(LAB_CYCLO_CRYPTO.cryptosporidium,0) = 1) THEN 1 ELSE 0 END 
	 END AS crypto
	,LAB_CYCLO_CRYPTO.cyclospora
	,LAB.ioda
	,LAB.endolimax
	,LAB.chilo
	,LAB.blasto
	,LAB.NSOP
	,LAB.observaciones
	,LAB.pruebaCultivoHizo
	,LAB.pruebaExamenFrescoSpA
	,LAB.pruebaExamenFrescoSpB
	,LAB.pruebaExamenFrescoSpC
	,LAB.pruebaExamenTricromicoSpA
	,LAB.pruebaExamenTricromicoSpB
	,LAB.pruebaExamenTricromicoSpC
	,LAB.pruebaExamenIFSpA
	,LAB.pruebaExamenIFSpB
	--,LAB.PCREColi
	--,LAB.pruebaPCREColiHizo
	--,LAB.pruebaRotavirusTipificacionHizo
	--,LAB.rotavirusTipificacion
	,CASE WHEN rota.pruebaRotavirusTipificacionHizo IS NOT NULL THEN rota.pruebaRotavirusTipificacionHizo
		  ELSE 
				CASE WHEN rotaAbril2016.pruebaRotavirusTipificacionHizo IS NOT NULL THEN rotaAbril2016.pruebaRotavirusTipificacionHizo
				ELSE NULL END 
	 END AS		pruebaRotavirusTipificacionHizo 
	,CASE WHEN rota.rotavirusTipificacion IS NOT NULL THEN rota.rotavirusTipificacion
		  ELSE
				CASE WHEN rotaAbril2016.Genotype IS NOT NULL THEN rotaAbril2016.Genotype
				ELSE NULL END
	 END AS  rotavirusTipificacion
	,LAB.recepcionMuestraCongeladas
	,LAB.strong
	,LAB.recepcionMuestraNorovirus
	,LAB.Observaciones_UVG
	,LAB.taenia
	-----------------------------------------------


	-- Norovirus
	-----------------------------------------------
	,Norovirus.labNumeroNorovirus
	,Norovirus.fechaExtraccion
	,Norovirus.RTqPCR_RNP
	,CASE WHEN Norovirus.RTqPCR_NV1 IS NULL THEN sd.Norovirus1 ELSE Norovirus.RTqPCR_NV1 END AS RTqPCR_NV1
	,CASE WHEN Norovirus.RTqPCR_NV2 IS NULL THEN sd.Norovirus2 ELSE norovirus.RTqPCR_NV2 END AS RTqPCR_NV2
	,Norovirus.RTqPCR_RNP_CT
	,CASE WHEN Norovirus.RTqPCR_NV1_CT IS NULL THEN sd.ct_Norovirus1 ELSE CAST(Norovirus.RTqPCR_NV1_CT AS nvarchar) END AS RTqPCR_NV1_CT
	,CASE WHEN Norovirus.RTqPCR_NV2_CT IS NULL THEN sd.ct_Norovirus2 ELSE CAST(Norovirus.RTqPCR_NV2_CT AS nvarchar) END AS RTqPCR_NV2_CT
	,Norovirus.observaciones AS ObservacionesNorovirus
	,NAS.norovirusTipificacionHizo
	,NAS.NoV_GI_RegB
	,NAS.NoV_GI_RegC
	,NAS.NoV_GII_RegB
	,NAS.NoV_GII_RegC
	-----------------------------------------------

	-- Sensiblidad Antibiotica
	-----------------------------------------------
	,Sensibilidad.pruebaTrimetoprinSulfaSensibilidad
	,Sensibilidad.pruebaTetraciclinaSensibilidad
	,Sensibilidad.pruebaKanamicinaSensibilidad
	,Sensibilidad.pruebaGentamicinaSensibilidad
	,Sensibilidad.pruebaEstreptomicinaSensibilidad
	,Sensibilidad.pruebaCloranfenicolSensibilidad
	,Sensibilidad.pruebaCiprofloxacinaSensiblidad
	,Sensibilidad.pruebaCeftriaxoneSensibilidad
	,Sensibilidad.pruebaAmpicilinaSensibilidad
	,Sensibilidad.pruebaAmoxicilinaSensibilidad
	,Sensibilidad.pruebaAcNalidixicoSensibilidad
	,Sensibilidad.observaciones AS ObservacionesSensibilidad
	-----------------------------------------------
	-- E.coli EscheridiaColi
	-----------------------------------------------
	--,CASE WHEN EscheridiaColi.EPEC IS NULL THEN ecoli2014.epec ELSE EscheridiaColi.EPEC  END  AS EPEC
	--,CASE WHEN EscheridiaColi.ETEC IS NULL THEN ecoli2014.etec ELSE EscheridiaColi.ETEC END   AS ETEC
	--,EscheridiaColi.STEC
	,	CASE WHEN (
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.hlyA=1 
							OR ecoli2011.eaeA=1 
							OR ecoli2011.stx2=1 
							OR ecoli2011.stx1=1 
						THEN 1 ELSE 0 END
					ELSE ECOLI2014.epec 
					END --AS EPEC
				)IS NOT NULL 
				OR  
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.LT=1
							OR ecoli2011.ST1a=1
							OR ecoli2011.ST1b=1
						THEN 1 ELSE 0 END
					ELSE ecoli2014.etec
					END --AS ETEC
				)IS NOT NULL
	 )THEN 1
	 ELSE NULL
	 END ecoliHizo
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.hlyA ELSE ecoli2014.epec_EHEC_hlyA_534 END AS hlyA
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.eaeA ELSE ecoli2014.epec_eaeA_384 END AS eaeA
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.stx2 ELSE ecoli2014.epec_stx2_255 END AS stx2
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.stx1 ELSE ecoli2014.epec_stx1_180 END AS sxt1
	,CASE WHEN 
	case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END 
	IS NULL
	AND
	--ecoliHizo
	CASE WHEN (
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.hlyA=1 
							OR ecoli2011.eaeA=1 
							OR ecoli2011.stx2=1 
							OR ecoli2011.stx1=1 
						THEN 1 ELSE 0 END
					ELSE ECOLI2014.epec 
					END --AS EPEC
				)IS NOT NULL 
				OR  
				(CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
						CASE WHEN ecoli2011.LT=1
							OR ecoli2011.ST1a=1
							OR ecoli2011.ST1b=1
						THEN 1 ELSE 0 END
					ELSE ecoli2014.etec
					END --AS ETEC
				)IS NOT NULL
	 )THEN 1
	 ELSE NULL
	 END
	 IS NOT NULL
	 THEN 0
	 ELSE 
			 CASE WHEN CASE WHEN ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END LIKE '%negative%' THEN 0
			 WHEN CASE WHEN ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END LIKE '%positive%' THEN 1
			 ELSE CASE WHEN ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END 
	 END
	END 
	AS bfpa
	,CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
			CASE WHEN ecoli2011.hlyA=1 
			       OR ecoli2011.eaeA=1 
			       OR ecoli2011.stx2=1 
			       OR ecoli2011.stx1=1 
			THEN 1 ELSE 0 END
		ELSE ECOLI2014.epec 
	  END AS EPEC
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.LT ELSE ecoli2014.etec_LT_696nt END AS LT
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.ST1a ELSE ecoli2014.etec_ST1a_186nt END AS ST1a
	,CASE WHEN ECOLI2011.SASubjectID IS NOT NULL THEN ecoli2011.ST1b ELSE ecoli2014.etec_ST1b_166nt END AS ST1b
	,CASE WHEN ecoli2011.SASubjectID IS NOT NULL THEN
			CASE WHEN ecoli2011.LT=1
				   OR ecoli2011.ST1a=1
				   OR ecoli2011.ST1b=1
			THEN 1 ELSE 0 END
		ELSE ecoli2014.etec
	 END AS ETEC
		,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.LT ELSE ecoli_cdc2012.LT END AS CDC_LT
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.ST1a ELSE ecoli_cdc2012.ST1a END AS CDC_ST1a
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.ST1b ELSE ecoli_cdc2012.ST1b END AS CDC_ST1b
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.hlyA ELSE ecoli_cdc2012.hlyA END AS CDC_hlyA
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.eaeA ELSE ecoli_cdc2012.eaeA END AS CDC_eaeA
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.stx2 ELSE ecoli_cdc2012.stx2 END AS CDC_stx2
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.stx1 ELSE ecoli_cdc2012.stx1 END AS CDC_stx1
	,case when ecoli_cdc2009.SaSubjectID IS NOT NULL THEN ecoli_cdc2009.bfpa ELSE ecoli_cdc2012.bfpa END AS CDC_bfpa
	-----------------------------------------------
	--ASTRO Y SAPO virus 
	,sd.[ASTROVIRUS]
    ,sd.[SAPOVIRUS]
    ,sd.[CT_ASTROVIRUS]
    ,sd.[CT_SAPOVIRUS]
    ,NAS.sapovirusTipificacionHizo
    ,NAS.SapovirusGenotipificacion
	,NULL vesikariParametros
	,NULL mvs
	,NULL casoSeveroMVS  
	,NULL casoMuySeveroMVS
	,NULL cuidadoIntensivoDias
	,NULL salaIngreso
	,NULL contactoAnimalesCasa 
FROM Clinicos.Todo_Puesto_vw Sujeto
	LEFT JOIN [Control].Sitios ON Sujeto.SubjectSiteID = Sitios.SiteID
	LEFT JOIN LegalValue.LV_DEPARTAMENTO NombreDepto ON Sujeto.departamento = NombreDepto.Value
	LEFT JOIN LegalValue.LV_MUNICIPIO NombreMuni ON Sujeto.municipio = NombreMuni.Value
	LEFT JOIN Lab.DiarreaResultados LAB ON Sujeto.SASubjectID = Lab.ID_Paciente
	LEFT JOIN Lab.NorovirusResultados Norovirus ON Sujeto.SASubjectID = Norovirus.ID_Paciente
	LEFT JOIN Lab.DiarreaResultadosAntibiotiocs Sensibilidad ON Sujeto.SASubjectID = Sensibilidad.ID_Paciente
	-- FM[2011-11-10]: Temporal mientras corrigo Todo_Puesto
	LEFT JOIN Clinicos.P2L ON P2L.SubjectID = Sujeto.SubjectID AND P2L.forDeletion = 0
	LEFT JOIN Clinicos.P2f P2F ON P2F.SubjectID = Sujeto.SubjectID AND P2F.forDeletion = 0
	--LEFT JOIN Lab.EColi_Resultados EscheridiaColi ON EscheridiaColi.SubjectID = Sujeto.SubjectID
	--LEFT JOIN sp.Sindrome_Diarreico sd  ON sujeto.SASubjectID COLLATE database_default= sd.SaSubjectID COLLATE database_default--Se unifico los datos de sharepoint a una nueva tabla lab.PCR_DIARREA y se creo la vista lab.sindrome_diarreico
	LEFT JOIN Lab.ResultadosEcoli2014 ecoli2014 ON (Sujeto.SASubjectID = ecoli2014.SASubjectID)
	LEFT JOIN lab.Sindrome_Diarreico sd ON Sujeto.SASubjectID= sd.sampleName
	LEFT JOIN LabEnvio.RotavirusGenotipificacion rota ON (Sujeto.SASubjectID = rota.ID_Paciente)
	LEFT JOIN LabEnvio.RotavirusGenotipificacion_Abril2016 rotaAbril2016 ON Sujeto.SASubjectID = rotaAbril2016.SASubjectID --JD:2016/05/02 result Geno Rota
	LEFT JOIN [Lab].[Cyclo_Crypto_Resultados] LAB_CYCLO_CRYPTO ON (LAB_CYCLO_CRYPTO.SASubjectID = Sujeto.SASubjectID) --agregado para resultados de cyclo y crypto
	LEFT JOIN lab.EColi_ETEC_EPEC_Resultados_GUA_2011 ecoli2011 ON ecoli2011.SASubjectID= sujeto.SASubjectID --datos crudos de ecoli realizados en guatemala (hasta 2011)
	LEFT JOIN lab.EColi_ETEC_EPEC_Resultados_CDC_2009 ecoli_cdc2009 ON SUJETO.SASubjectID= ecoli_cdc2009.SASubjectID  --datos crudos de confirmaciones cdc 2009
	LEFT JOIN lab.EColi_ETEC_EPEC_Resultados_CDC_2012 ecoli_cdc2012 ON SUJETO.SASubjectID= ecoli_cdc2012.SASubjectID  --datos crudos de confirmaciones cdc hasta 2011
	LEFT JOIN ViCo.Analysis.NAS_Envio_CDC_Results NAS ON (NAS.SASubjectID = Sujeto.SASubjectID)
WHERE Sujeto.forDeletion = 0




























GO


