USE [ViCo]
GO

/****** Object:  View [Clinicos].[Basica_Febril]    Script Date: 08/23/2018 16:07:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













/*
	Creado por: Fredy Muñoz
	Fecha: 2011-11-16
	
	Esta vista provee información básica para iniciar análisis en los casos de
	enfermedades febriles de ViCo.
	
	[2012-03-28] Marvin Xuya:
	* Se agrego a solicitud de Steve la variable observaciones de resultados de
	  laboratorio.
	
	[2012-04-18] Fredy Muñoz:
	* Se combinaron algunas variables que cambiaron de nombre hasta que se unifiquen los datos.
	  - nombre nuevo (nombre anterior)
	  - hxF_DolorCabeza (sintomasEnfermaFebrilDolorCabeza)
	  - hxF_DolorCabezaActual (sintomasEnfermaFebrilDolorCabezaActual)
	  - hxF_DolorCabezaHaceDias (sintomasEnfermaFebrilDolorCabezaEmpezoHaceDias)
	  - hxF_IrritacionPiel (sintomasEnfermaFebrilIrritacionPiel)
	  - hxF_DolorMusculos (sintomasEnfermaFebrilDolorMusculos)
	  - hxF_DolorMusculosActual (sintomasEnfermaFebrilDolorMusculosActual)
	  - hxF_DolorMusculosHaceDias (sintomasEnfermaFebrilDolorMusculosEmpezoHaceDias)
	  - hxF_DolorArticulaciones (sintomasEnfermaFebrilDolorArticulaciones)

	[2012-10-12] Fredy Muñoz:
	* Agregué la variable [HUSarea]
	[2012-10-15] Fredy Muñoz:
	* Cast de variable [fechaDeNacimiento] a tipo date para que se puedan
	  transferir datos a R.
	[2014-02-21] Marvin Xuya:
	* Agregue muestraSangreEnteraFechaHora.
	[2014-03-18] Marvin Xuya
	* Agregue variables de enfermedades cronicas.
	* Se crea variable calculada para enfermedad cronica.
	[2014-04-08] Marvin Xuya
	* Agregue variable muestraSangreEnteraColecta
	[2015-03-11] Marvin Xuya
	* Agregue variable CHK_IgM
	[2016-04-25] JD	
	* Se agrego la variable ZikaPCR
*/


CREATE VIEW [Clinicos].[Basica_Febril]
AS


-- Hospital
--------------------------------------------------------------------------------
SELECT
	Sujeto.SubjectID

	-- ID & elegibility
	-----------------------------------------------
	,CASE WHEN
				(
					Sujeto.pacienteInscritoViCo = 2
					AND (Sujeto.elegibleDiarrea = 1 OR Sujeto.elegibleRespira = 1 OR Sujeto.elegibleFebril = 1)
					AND Sujeto.SASubjectID IS NOT NULL
					AND YEAR(Sujeto.fechaHoraAdmision) >= 2016
					AND Sujeto.pdainsertversion LIKE '12%'
				)
			 THEN 1
			 WHEN (
					Sujeto.SubjectID LIKE '95DD8258-E586-4517-AC78-001507FEABFB' OR 
					Sujeto.SubjectID LIKE '80968BE5-0C58-4D2C-8510-2274A8BCFCC3' OR 
					Sujeto.SubjectID LIKE '006E07F7-6506-416A-9AA4-2C0BB7C5F75A' OR 
					Sujeto.SubjectID LIKE '627590DD-6A39-4282-A8A5-436384C6E8F7' OR 
					Sujeto.SubjectID LIKE '1D112EB1-7D73-40C8-8B90-6579C9D16AAE' OR 
					Sujeto.SubjectID LIKE '15B97789-99A2-4500-AA3D-6964F79E3E49' OR 
					Sujeto.SubjectID LIKE '6AE54446-83C7-436A-A329-BEF044EB9FFD' OR 
					Sujeto.SubjectID LIKE '6897294C-2EA3-47C4-B326-DE9C498F63EC' OR 
					Sujeto.SubjectID LIKE 'D5B96798-A3F9-4A63-8195-EF4F57EF8DAD' OR 
					Sujeto.SubjectID LIKE 'B1060287-7761-4ED0-A754-3346B1E332F1' OR 
					Sujeto.SubjectID LIKE '25A68BCD-58E8-416A-8040-3B2AB0C9D07E' OR 
					Sujeto.SubjectID LIKE 'CEF6B081-223D-4849-914C-4004DED09E79' OR 
					Sujeto.SubjectID LIKE '385A3B4D-8870-4927-B6AD-8851B0D8BF1A' OR 
					Sujeto.SubjectID LIKE '95F14C7E-BB3C-4D86-A6DC-E6EE2D7A579F' OR 
					Sujeto.SubjectID LIKE 'F8D95B40-6BFD-45AF-8681-ECFFE09E330F' OR 
					Sujeto.SubjectID LIKE 'DF72BCAD-440F-4DE1-A3A5-F41D52AA9012'  
			 )THEN 0
			 ELSE Sujeto.pacienteInscritoViCo
	  END pacienteInscritoViCo
	,Sujeto.SASubjectID
	,Sujeto.elegibleDiarrea
	,Sujeto.elegibleRespira
	,Sujeto.elegibleNeuro
	,Sujeto.elegibleFebril
	-----------------------------------------------

	-- Dates
	-----------------------------------------------
	,Sujeto.fechaHoraAdmision
	,Sujeto.epiWeekAdmision
	,Sujeto.epiYearAdmision
	-----------------------------------------------

	-- Consent
	-----------------------------------------------
	,Sujeto.consentimientoVerbal
	,Sujeto.consentimientoEscrito
	,Sujeto.asentimientoEscrito
	-----------------------------------------------

	-- Site location
	-----------------------------------------------
	,SubjectSiteID
	,[Sitios].NombreShortName							AS	[SiteName]
	,Sitios.TipoSitio AS SiteType
	,Sitios.DeptoShortName AS SiteDepartamento
	-----------------------------------------------

	-- Patient Location
	-----------------------------------------------
	,Sujeto.departamento
	,Sujeto.municipio
	,Sujeto.comunidad
	,Sujeto.[lugarPoblado]							AS [censo_codigo]
	,censo.comunidad								AS [censo_comunidad]
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
					AND SubjectSiteID IN (9, 12, 13, 14, 15, 17)
					AND Sujeto.municipio IN (901, 902, 903, 909, 910, 911, 913, 914, 916, 923, 912)
				)
				OR
				(
					Sujeto.departamento = 1
					AND SubjectSiteID = 11
				)
			THEN 1
			ELSE 2
		END

	,NombreDepto.Text as NombreDepartamento
	,NombreMuni.Text as NombreMunicipio
	-----------------------------------------------

	-- Demographic
	-----------------------------------------------
	,Sujeto.sexo
	,Sujeto.edadAnios
	,Sujeto.edadMeses
	,Sujeto.edadDias
	,fechaDeNacimiento = CAST(Sujeto.fechaDeNacimiento AS date)
	,H3F.pacienteGrupoEtnico
	-----------------------------------------------

	-- H1/C1/P1
	-----------------------------------------------
	,Sujeto.salaIngreso
	,Sujeto.presentaIndicacionRespira
	,Sujeto.indicacionRespira
	,H1.indicacionRespira_otra
	,Sujeto.presentaIndicacionDiarrea
	,H1.indicacionDiarrea
	,H1.indicacionDiarrea_otra
	,Sujeto.presentaIndicacionNeuro
	,H1.indicacionNeuro
	,H1.indicacionNeuro_otra
	,Sujeto.presentaIndicacionFebril
	,H1.indicacionFebril
	,H1.indicacionFebril_otra
	,Sujeto.actualAdmitido
	-----------------------------------------------

	-- H2REM/C1C/P1C
	-----------------------------------------------
	,Sujeto.medirTemperaturaCPrimeras24Horas
	,Sujeto.temperaturaPrimeras24Horas
	,Sujeto.sintomasRespiraFiebre
	,Sujeto.sintomasRespiraHipotermia
	,Sujeto.sintomasFiebre
	,Sujeto.sintomasFiebreDias
	,Sujeto.fiebreOHistoriaFiebre
	,Sujeto.tieneResultadoHematologia
	,Sujeto.conteoGlobulosBlancos
	,Sujeto.diferencialAnormal
	,Sujeto.sintomasRespiraCGB
	,Sujeto.resultadoAnormalExamenPulmones
	,H2REM.medidaRespiraPorMinutoPrimeras24Horas
	,Sujeto.respiraPorMinutoPrimaras24Horas
	,Sujeto.sintomasRespiraTaquipnea
	,Sujeto.puncionLumbar
	,Sujeto.LCRconteoGlobulosBlancos
	,H2REM.LCRFecha
	,H2C.ninioVomitaTodo
	,H2C.ninioBeberMamar
	,H2C.ninioTuvoConvulsiones
	,H2C.ninioTieneLetargiaObs
	-----------------------------------------------

	-- H2DRF/C1C/P1C
	-----------------------------------------------
	,Sujeto.diarreaUltimos7Dias
	,H2DRF.sintomasRespiraTamizaje
	,Sujeto.sintomasRespiraTos
	,H2DRF.sintomasRespiraTosDias
	,H2DRF.pertussisVomito
	,H2DRF.pertussisParoxismos
	,H2DRF.pertussisWhoop
	,Sujeto.sintomasRespiraDificultadRespirar
	,H2DRF.sintomasRespiraDificultadDias
	,Sujeto.sintomasRespiraEsputo
	,Sujeto.sintomasRespiraHemoptisis
	,Sujeto.sintomasRespiraDolorGarganta
	,H2DRF.sintomasRespiraGargantaDias
	,Sujeto.sintomasRespiraFaltaAire
	,Sujeto.sintomasRespiraDolorPechoRespirar
	,Sujeto.sintomasRespiraNinioPausaRepedimente
	,Sujeto.sintomasRespiraNinioCostillasHundidas
	,Sujeto.sintomasRespiraNinioAleteoNasal
	,Sujeto.sintomasRespiraNinioRuidosPecho
	,Sujeto.sintomasRespira
	,H2DRF.medirOximetroPulso
	,H2DRF.oximetroPulso
	,Sujeto.enfermedadEmpezoHaceDias
	-----------------------------------------------

	-- H2F/C1F
	-----------------------------------------------
	,H2F.fiebreRazon
	,H2F.fiebreOtraRazon_esp
	,Sujeto.lesionAbiertaInfectada
	,Sujeto.otitisMedia
	-----------------------------------------------

	-- H5/C5/P5
	-----------------------------------------------
	,H5V.muestraHecesHisopoSecoColecta
	,H5V.muestraFroteNP
	,H5V.muestraFroteNPFechaHora
	,H5V.muestraOrinaColecta
	,H5V.muestraOrinaFechaHora
	,H5V.muestraOrinaNumeroML
	
	,H5H.radiografiaPechoColecta
	,H5H.radiografiaPechoNumero
	,H5H.muestraSangreCultivoColecta
	,H5H.muestraSangreCultivoNumeroKit1
	,H5H.muestraSangreCultivoNumeroKit2
	-----------------------------------------------

	-- H3L
	-----------------------------------------------
	,H3L.hxC_Vomitos
	,H3L.hxC_VomitosVeces
	,H3L.hxC_Vomitos8Dias
	,H3L.hxC_VomitosActual
	,H3L.hxC_Escalofrios
	,H3L.hxC_EscalofriosActual
	,H3L.hxC_EscalofriosEmpezoHaceDias
	,H3L.hxC_Calambres
	,H3L.hxC_Nausea
	,H3L.hxC_DolorCabeza
	,H3L.hxC_DolorCabezaActual
	,H3L.hxC_DolorCabezaEmpezoHaceDias
	,H3L.hxC_DolorMusculos
	,H3L.hxC_DolorMusculosActual
	,H3L.hxC_DolorMusculosEmpezoHaceDias
	,H3L.hxC_DebilidadGeneral
	,H3L.hxC_Malestar
	,H3L.hxC_FaltaApetito
	-----------------------------------------------

	-- H3D/C2D/P2D
	-----------------------------------------------
	,H3D.respiraEmpezoHaceDias
	,H3D.sintomasEnfermRespiraEscalofrios
	,H3D.hxR_GoteaNariz
	,H3D.hxR_Estornudos
	,H3D.sintomasEnfermRespiraHervorPecho
	,H3D.sintomasEnfermRespiraDolorCabeza
	,H3D.sintomasEnfermRespiraDolorMuscular
	-----------------------------------------------

	-- H3K/C2K
	-----------------------------------------------
	,H3K.febrilEmpezoHaceDias
	,H3K.sintomasEnfermaFebrilDolorCabeza AS hxF_DolorCabeza
	,H3K.sintomasEnfermaFebrilDolorCabezaActual AS hxF_DolorCabezaActual
	,H3K.sintomasEnfermaFebrilDolorCabezaEmpezoHaceDias AS hxF_DolorCabezaHaceDias
	,H3K.hxF_DolorDetrasOjos
	,H3K.hxF_DolorDetrasOjosActual
	,H3K.hxF_DolorDetrasOjosHaceDias
	,H3K.sintomasEnfermaFebrilDolorMusculos AS hxF_DolorMusculos
	,H3K.sintomasEnfermaFebrilDolorMusculosActual AS hxF_DolorMusculosActual
	,H3K.sintomasEnfermaFebrilDolorMusculosEmpezoHaceDias AS hxF_DolorMusculosHaceDias
	,H3K.hxF_DolorCamotes
	,H3K.hxF_DolorCamotesActual
	,H3K.hxF_DolorCamotesHaceDias
	,ISNULL(H3K.hxF_DolorArticulaciones, H3K.sintomasEnfermaFebrilDolorArticulaciones) AS hxF_DolorArticulaciones
	,H3K.hxF_DolorArticulacionesActual
	,H3K.hxF_DolorArticulacionesHaceDias
	,H3K.hxF_DormidoCuerpo
	,H3K.hxF_DormidoCuerpoActual
	,H3K.hxF_DormidoCuerpoHaceDias
	,H3K.hxF_DificultadCaminar
	,H3K.hxF_DificultadCaminarActual
	,H3K.hxF_DificultadCaminarHaceDias
	,H3K.hxF_OjosRojos
	,H3K.hxF_Rash
	,H3K.sintomasEnfermaFebrilOjosRojosActual
	,H3K.sintomasEnfermaFebrilOjosRojosHaceDias  -- cambio de variable anteriormente "H3K.sintomasEnfermaFebrilOjosRojosEmpezoHaceDias"
	,H3K.hxF_OjosAmarillos
	,H3K.hxF_OjosAmarillosActual
	,H3K.hxF_OjosAmarillosHaceDias
	,H3K.sintomasEnfermaFebrilEscalofrios
	,H3K.sintomasEnfermaFebrilEscalofriosActual
	,H3K.sintomasEnfermaFebrilEscalofriosEmpezoHaceDias
	,H3K.hxF_SudoracionProfusa
	,H3K.hxF_SudoracionProfusaActual
	,H3K.hxF_SudoracionProfusaHaceDias
	,H3K.hxF_OrinaOscura
	,H3K.hxF_OrinaOscuraActual
	,H3K.hxF_OrinaOscuraHaceDias
	,H3K.hxF_RigidezNuca
	,H3K.hxF_RigidezNucaActual
	,H3K.hxF_RigidezNucaHaceDias -- Cambio de variable sintomasEnfermaFebrilRigidezNucaEmpezoHaceDias
	,H3K.hxF_DebilidadFacial
	,H3K.hxF_DebilidadFacialActual
	,H3K.hxF_DebilidadFacialHaceDias
	,H3K.hxF_Costras
	,H3K.hxF_CostrasActual
	,H3K.hxF_CostrasHaceDias
	,ISNULL(H3K.hxF_IrritacionPiel, H3K.sintomasEnfermaFebrilIrritacionPiel) AS hxF_IrritacionPiel
	,H3K.sintomasEnfermaFebrilIrritacionPielActual
	,H3K.sintomasEnfermaFebrilIrritacionPielFoto
	,H3K.sintomasEnfermaFebrilIrritacionPielEmpezoHaceDias
	,H3K.sintomasEnfermaFebrilIrritacionPielDonde
	,H3K.sintomasEnfermaFebrilIrritacionPielDescripcion
	,H3K.hxF_SangradoInusual
	,H3K.hxF_SangradoInusualActual
	,H3K.hxF_SangradoInusualHaceDias
	,H3K.hxF_SangradoInusualDonde
	-----------------------------------------------

	-- H3B/C2B/P2B
	-----------------------------------------------
	,H3B.buscoTratamientoAntes
	,H3B.otroTratamiento1erTipoEstablecimiento
	,H3B.otroTratamiento1erRecibioMedicamento
	,H3B.otroTratamiento1erAntibioticos
	,H3B.buscoTratamientoAntes2doLugar
	,H3B.otroTratamiento2doTipoEstablecimiento
	,H3B.otroTratamiento2doRecibioMedicamento
	,H3B.otroTratamiento2doAntibioticos
	,H3B.buscoTratamientoAntes3erLugar
	,H3B.otroTratamiento3erTipoEstablecimiento
	,H3B.otroTratamiento3erRecibioMedicamento
	,H3B.otroTratamiento3erAntibioticos
	,H3B.tomadoMedicamentoUltimas72hora
	,H3B.medUltimas72HorasAntiB
	,H3B.medUltimas72HorasAntipireticos
	,H3B.medicamentosUltimas72HorasEsteroides
	,H3B.medUltimas72HorasAntivirales
	,H3B.otroTratamiento1erZinc
	,H3B.otroTratamiento1erZincDias
	,H3B.otroTratamiento2doZinc
	,H3B.otroTratamiento2doZincDias
	,H3B.otroTratamiento3erZinc
	,H3B.otroTratamiento3erZincDias
	,H3B.medUltimas72HorasZinc
	-----------------------------------------------

	-- H7/C7/P7
	-----------------------------------------------
	,H7.fechaInforme
	,H7.egresoMuerteFecha
	,H7.egresoTipo
	,H7.egresoCondicion
	,H7.ventilacionMecanicaDias
	,H7.cuidadoIntensivoDias
	,H7.temperaturaPrimeras24HorasAlta
	,H7.egresoDiagnostico1
	,H7.egresoDiagnostico1_esp
	,H7.egresoDiagnostico2
	,H7.egresoDiagnostico2_esp
	,H7.zincTratamiento
	-----------------------------------------------

	-- HCP9
	-----------------------------------------------
	,HCP9.seguimientoFechaReporte
	,HCP9.seguimientoObtuvoInformacion
	,HCP9.seguimientoTipoContacto
	,HCP9.seguimientoPacienteCondicion
	,HCP9.seguimientoPacienteMuerteFecha
	,HCP9.seguimientoMuestraSangreColecta
	,HCP9.seguimientoMuestraSangreML

	,HCP9.seguimientoZinc
	,HCP9.seguimientoZincTabletas
	,HCP9.seguimientoZincTabletasQuedan
	,HCP9.seguimientoZincTabletasTomo
	,HCP9.seguimientoZincTabletasPorDia
	,HCP9.seguimientoZincTabletasDiasTomo
	,HCP9.seguimientoZincTabletasNoRazon
	,HCP9.seguimientoZincTabletasNoRazonEs
	-----------------------------------------------

	-- Laboratory Results
	-----------------------------------------------
	,FebrilResultados.dengue_ELISA_lgM
	,FebrilResultados.dengue_ELISA_lgM_convaleciente
	,FebrilResultados.dengue_ELISA_lgG
	,FebrilResultados.dengue_PCR
	,FebrilResultados.dengue_tipo1
	,FebrilResultados.dengue_tipo2
	,FebrilResultados.dengue_tipo3
	,FebrilResultados.dengue_tipo4
	,FebrilResultados.malaria_gotaGruesa
	,FebrilResultados.malaria_PCR
	,FebrilResultados.rickettsias_ELISA
	,FebrilResultados.rickettsias_IF
	,FebrilResultados.rickettsias_PCR
	,FebrilResultados.rickettsias_PCR_ecto
	,FebrilResultados.rickettsia_IF_Convaleciente
	,FebrilResultados.Lepto_PanBioKit
	,FebrilResultados.Se_HizoPanBioConvalenciente
	,FebrilResultados.PanBioKit_Convaleciente
	,FebrilResultados.lepto_MAT
	,FebrilResultados.Bartonella_IF_Agudo
	,FebrilResultados.Bartonella_IF_convaleciente
	,FebrilResultados.Bartonella_PCR
	,FebrilResultados.Observaciones
	-----------------------------------------------
	,H5V.muestraSangreEnteraFechaHora
	,H5V.muestraSangreEnteraColecta
	
	/*-----------------------------------------------
				ENFERMEDADES CRONICAS
	-----------------------------------------------*/
	,enfermedadesCronicasAsma	
	,enfermedadesCronicasCancer
--	,enfermedadesCronicasDerrame
	,enfermedadesCronicasDiabetes	
	,enfermedadesCronicasEnfermCorazon
	,enfermedadesCronicasEnfermHigado
	,enfermedadesCronicasEnfermPulmones
	,enfermedadesCronicasEnfermRinion
--	,enfermedadesCronicasEsteroides
	,enfermedadesCronicasHipertension
	,enfermedadCronica	= case 
	when 	
	 enfermedadesCronicasAsma = 1 or 
	 enfermedadesCronicasCancer = 1 or 
	 enfermedadesCronicasDiabetes = 1 or 
	 enfermedadesCronicasEnfermCorazon = 1 or 
	 enfermedadesCronicasEnfermHigado = 1 or 
	 enfermedadesCronicasEnfermPulmones = 1 or 
	 enfermedadesCronicasEnfermRinion = 1 or 
	 enfermedadesCronicasHipertension = 1
	 then 1
	 when 
		 enfermedadesCronicasAsma = 2 or 
		 enfermedadesCronicasCancer = 2 or 
		 enfermedadesCronicasDiabetes = 2 or 
		 enfermedadesCronicasEnfermCorazon = 2 or 
		 enfermedadesCronicasEnfermHigado = 2 or 
		 enfermedadesCronicasEnfermPulmones = 2 or 
		 enfermedadesCronicasEnfermRinion = 2 or 
		 enfermedadesCronicasHipertension = 2
	 then 2
	else null
	end
	,FebrilResultados.CHK_IgM
	,FebrilResultados.CHK_PCR
	,FebrilResultados.Zika_PCR
	,H3A.embarazada
	, Sujeto.PDAInsertDate 
FROM Clinicos.Sujeto_Hospital Sujeto
	LEFT JOIN Control.Sitios ON Sujeto.SubjectSiteID = Sitios.SiteID
	LEFT JOIN LegalValue.LV_DEPARTAMENTO NombreDepto ON Sujeto.departamento = NombreDepto.Value
	LEFT JOIN LegalValue.LV_MUNICIPIO NombreMuni ON Sujeto.municipio = NombreMuni.Value
	LEFT JOIN ViCo.LegalValue.centros_poblados censo ON (Sujeto.lugarPoblado = censo.cod_censo)
	LEFT JOIN Clinicos.H1 ON H1.SubjectID = Sujeto.SubjectID AND H1.forDeletion = 0
	LEFT JOIN Clinicos.H2REM ON H2REM.SubjectID = Sujeto.SubjectID AND H2REM.forDeletion = 0
	LEFT JOIN Clinicos.H2C ON H2C.SubjectID = Sujeto.SubjectID AND H2C.forDeletion = 0
	LEFT JOIN Clinicos.H2DRF ON H2DRF.SubjectID = Sujeto.SubjectID AND H2DRF.forDeletion = 0
	LEFT JOIN Clinicos.H2F ON H2F.SubjectID = Sujeto.SubjectID AND H2F.forDeletion = 0
	LEFT JOIN Clinicos.H5V ON H5V.SubjectID = Sujeto.SubjectID AND H5V.forDeletion = 0
	LEFT JOIN Clinicos.H5H ON H5H.SubjectID = Sujeto.SubjectID AND H5H.forDeletion = 0
	LEFT JOIN Clinicos.H3L ON H3L.SubjectID = Sujeto.SubjectID AND H3L.forDeletion = 0
	LEFT JOIN Clinicos.H3D ON H3D.SubjectID = Sujeto.SubjectID AND H3D.forDeletion = 0
	LEFT JOIN Clinicos.H3K ON H3K.SubjectID = Sujeto.SubjectID AND H3K.forDeletion = 0
	LEFT JOIN Clinicos.H3B ON H3B.SubjectID = Sujeto.SubjectID AND H3B.forDeletion = 0
	LEFT JOIN Clinicos.H3F ON H3F.SubjectID = Sujeto.SubjectID AND H3F.forDeletion = 0
	LEFT JOIN Clinicos.H7 ON H7.SubjectID = Sujeto.SubjectID AND H7.forDeletion = 0
	LEFT JOIN Clinicos.HCP9 ON HCP9.SubjectID = Sujeto.SubjectID AND HCP9.forDeletion = 0
	LEFT JOIN Clinicos.H3A ON H3A.SubjectID  = Sujeto.SubjectID AND H3A.forDeletion = 0
	LEFT JOIN Lab.FebrilResultados ON FebrilResultados.ID_Paciente = Sujeto.SASubjectID AND FebrilResultados.forDeletion = 0

WHERE Sujeto.forDeletion = 0
--------------------------------------------------------------------------------



UNION ALL



-- Centro de Salud
--------------------------------------------------------------------------------
SELECT
	Sujeto.SubjectID

	-- ID & elegibility
	-----------------------------------------------
		,CASE WHEN
				(
					Sujeto.pacienteInscritoViCo = 2
					AND (Sujeto.elegibleDiarrea = 1 OR Sujeto.elegibleRespira = 1 OR Sujeto.elegibleFebril = 1)
					AND Sujeto.SASubjectID IS NOT NULL
					AND YEAR(Sujeto.fechaHoraAdmision) >= 2016
					AND Sujeto.pdainsertversion LIKE '12%'
				)
			 THEN 1
			  WHEN (
					Sujeto.SubjectID LIKE '95DD8258-E586-4517-AC78-001507FEABFB' OR 
					Sujeto.SubjectID LIKE '80968BE5-0C58-4D2C-8510-2274A8BCFCC3' OR 
					Sujeto.SubjectID LIKE '006E07F7-6506-416A-9AA4-2C0BB7C5F75A' OR 
					Sujeto.SubjectID LIKE '627590DD-6A39-4282-A8A5-436384C6E8F7' OR 
					Sujeto.SubjectID LIKE '1D112EB1-7D73-40C8-8B90-6579C9D16AAE' OR 
					Sujeto.SubjectID LIKE '15B97789-99A2-4500-AA3D-6964F79E3E49' OR 
					Sujeto.SubjectID LIKE '6AE54446-83C7-436A-A329-BEF044EB9FFD' OR 
					Sujeto.SubjectID LIKE '6897294C-2EA3-47C4-B326-DE9C498F63EC' OR 
					Sujeto.SubjectID LIKE 'D5B96798-A3F9-4A63-8195-EF4F57EF8DAD' OR 
					Sujeto.SubjectID LIKE 'B1060287-7761-4ED0-A754-3346B1E332F1' OR 
					Sujeto.SubjectID LIKE '25A68BCD-58E8-416A-8040-3B2AB0C9D07E' OR 
					Sujeto.SubjectID LIKE 'CEF6B081-223D-4849-914C-4004DED09E79' OR 
					Sujeto.SubjectID LIKE '385A3B4D-8870-4927-B6AD-8851B0D8BF1A' OR 
					Sujeto.SubjectID LIKE '95F14C7E-BB3C-4D86-A6DC-E6EE2D7A579F' OR 
					Sujeto.SubjectID LIKE 'F8D95B40-6BFD-45AF-8681-ECFFE09E330F' OR 
					Sujeto.SubjectID LIKE 'DF72BCAD-440F-4DE1-A3A5-F41D52AA9012'  
			 )THEN 0
			 ELSE Sujeto.pacienteInscritoViCo
	  END pacienteInscritoViCo
	,Sujeto.SASubjectID

	,Sujeto.elegibleDiarrea
	,Sujeto.elegibleRespira
	,Sujeto.elegibleNeuro
	,Sujeto.elegibleFebril
	-----------------------------------------------

	-- Dates
	-----------------------------------------------
	,Sujeto.fechaHoraAdmision
	,Sujeto.epiWeekAdmision
	,Sujeto.epiYearAdmision
	-----------------------------------------------

	-- Consent
	-----------------------------------------------
	,Sujeto.consentimientoVerbal
	,Sujeto.consentimientoEscrito
	,Sujeto.asentimientoEscrito
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
	,Sujeto.comunidad
	, NULL							AS [censo_codigo]
	, NULL							AS [censo_comunidad]
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

	,NombreDepto.Text as NombreDepartamento
	,NombreMuni.Text as NombreMunicipio
	-----------------------------------------------

	-- Demographic
	-----------------------------------------------
	,Sujeto.sexo
	,Sujeto.edadAnios
	,Sujeto.edadMeses
	,Sujeto.edadDias
	,fechaDeNacimiento = CAST(Sujeto.fechaDeNacimiento AS date)
	,C2F.pacienteGrupoEtnico
	-----------------------------------------------

	-- H1/C1/P1
	-----------------------------------------------
	,NULL AS salaIngreso

	,Sujeto.presentaIndicacionRespira
	,Sujeto.indicacionRespira
	,NULL AS indicacionRespira_otra
	,Sujeto.presentaIndicacionDiarrea
	,NULL AS indicacionDiarrea
	,NULL AS indicacionDiarrea_otra
	,NULL AS presentaIndicacionNeuro
	,NULL AS indicacionNeuro
	,NULL AS indicacionNeuro_otra
	,NULL AS presentaIndicacionFebril
	,NULL AS indicacionFebril
	,NULL AS indicacionFebril_otra
	,NULL AS actualAdmitido
	-----------------------------------------------

	-- H2REM/C1C/P1C
	-----------------------------------------------
	,NULL AS medirTemperaturaCPrimeras24Horas
	,Sujeto.temperaturaPrimeras24Horas
	,Sujeto.sintomasRespiraFiebre
	,Sujeto.sintomasRespiraHipotermia
	,Sujeto.sintomasFiebre
	,Sujeto.sintomasFiebreDias
	,Sujeto.fiebreOHistoriaFiebre
	,NULL AS tieneResultadoHematologia
	,NULL	 conteoGlobulosBlancos
	,NULL AS diferencialAnormal
	,NULL AS sintomasRespiraCGB
	,NULL AS resultadoAnormalExamenPulmones
	,NULL AS medidaRespiraPorMinutoPrimeras24Horas
	,NULL AS respiraPorMinutoPrimaras24Horas
	,Sujeto.sintomasRespiraTaquipnea
	,NULL AS puncionLumbar
	,NULL AS LCRconteoGlobulosBlancos
	,NULL AS LCRFecha
	,C1C.ninioVomitaTodo
	,C1C.ninioBeberMamar
	,C1C.ninioTuvoConvulsiones
	,C1C.ninioTieneLetargiaObs
	-----------------------------------------------

	-- H2DRF/C1C/P1C
	-----------------------------------------------
	,Sujeto.diarreaUltimos7Dias
	,NULL AS sintomasRespiraTamizaje
	,Sujeto.sintomasRespiraTos
	,C1C.sintomasRespiraTosDias
	,C1C.pertussisVomito
	,C1C.pertussisParoxismos
	,C1C.pertussisWhoop
	,Sujeto.sintomasRespiraDificultadRespirar
	,C1C.sintomasRespiraDificultadDias
	,Sujeto.sintomasRespiraEsputo
	,Sujeto.sintomasRespiraHemoptisis
	,Sujeto.sintomasRespiraDolorGarganta
	,C1C.sintomasRespiraGargantaDias
	,Sujeto.sintomasRespiraFaltaAire
	,Sujeto.sintomasRespiraDolorPechoRespirar
	,Sujeto.sintomasRespiraNinioPausaRepedimente
	,Sujeto.sintomasRespiraNinioCostillasHundidas
	,Sujeto.sintomasRespiraNinioAleteoNasal
	,Sujeto.sintomasRespiraNinioRuidosPecho
	,Sujeto.sintomasRespira
	,C1C.medirOximetroPulso
	,C1C.oximetroPulso
	,Sujeto.enfermedadEmpezoHaceDias
	-----------------------------------------------

	-- H2F/C1F
	-----------------------------------------------
	,C1F.fiebreRazon
	,C1F.fiebreOtraRazon_esp
	,Sujeto.lesionAbiertaInfectada
	,Sujeto.otitisMedia
	-----------------------------------------------

	-- H5/C5/P5
	-----------------------------------------------
	,C5V.muestraHecesHisopoSecoColecta
	,C5V.muestraFroteNP
	,C5V.muestraFroteNPFechaHora
	,NULL AS muestraOrinaColecta
	,NULL AS muestraOrinaFechaHora
	,NULL AS muestraOrinaNumeroML
	
	,NULL AS radiografiaPechoColecta
	,NULL AS radiografiaPechoNumero
	,NULL AS muestraSangreCultivoColecta
	,NULL AS muestraSangreCultivoNumeroKit1
	,NULL AS muestraSangreCultivoNumeroKit2
	-----------------------------------------------

	-- H3L/C2L
	-----------------------------------------------
	,C2L.hxC_Vomitos
	,C2L.hxC_VomitosVeces
	,C2L.hxC_Vomitos8Dias
	,C2L.hxC_VomitosActual
	,C2L.hxC_Escalofrios
	,C2L.hxC_EscalofriosActual
	,C2L.hxC_EscalofriosEmpezoHaceDias
	,C2L.hxC_Calambres
	,C2L.hxC_Nausea
	,C2L.hxC_DolorCabeza
	,C2L.hxC_DolorCabezaActual
	,C2L.hxC_DolorCabezaEmpezoHaceDias
	,C2L.hxC_DolorMusculos
	,C2L.hxC_DolorMusculosActual
	,C2L.hxC_DolorMusculosEmpezoHaceDias
	,C2L.hxC_DebilidadGeneral
	,C2L.hxC_Malestar
	,C2L.hxC_FaltaApetito
	-----------------------------------------------

	-- H3D/C2D/P2D
	-----------------------------------------------
	,C2D.respiraEmpezoHaceDias
	,C2D.sintomasEnfermRespiraEscalofrios
	,C2D.hxR_GoteaNariz
	,C2D.hxR_Estornudos
	,C2D.sintomasEnfermRespiraHervorPecho
	,C2D.sintomasEnfermRespiraDolorCabeza
	,C2D.sintomasEnfermRespiraDolorMuscular
	-----------------------------------------------

	-- H3K/C2K
	-----------------------------------------------
	,C2K.febrilEmpezoHaceDias
	,C2K.hxF_DolorCabeza
	,C2K.hxF_DolorCabezaActual
	,C2K.hxF_DolorCabezaHaceDias
	,C2K.hxF_DolorDetrasOjos
	,C2K.hxF_DolorDetrasOjosActual
	,C2K.hxF_DolorDetrasOjosHaceDias
	,C2K.hxF_DolorMusculos
	,C2K.hxF_DolorMusculosActual
	,C2K.hxF_DolorMusculosHaceDias
	,C2K.hxF_DolorCamotes
	,C2K.hxF_DolorCamotesActual
	,C2K.hxF_DolorCamotesHaceDias
	,C2K.hxF_DolorArticulaciones
	,C2K.hxF_DolorArticulacionesActual
	,C2K.hxF_DolorArticulacionesHaceDias
	,C2K.hxF_DormidoCuerpo
	,C2K.hxF_DormidoCuerpoActual
	,C2K.hxF_DormidoCuerpoHaceDias
	,C2K.hxF_DificultadCaminar
	,C2K.hxF_DificultadCaminarActual
	,C2K.hxF_DificultadCaminarHaceDias
	,C2K.hxF_OjosRojos
	,C2K.hxF_Rash
	,C2K.hxF_OjosRojosActual AS sintomasEnfermaFebrilOjosRojosActual
	,C2K.hxF_OjosRojosHaceDias AS sintomasEnfermaFebrilOjosRojosHaceDias  -- cambio de variable anteriormente "C2K.sintomasEnfermaFebrilOjosRojosEmpezoHaceDias"
	,C2K.hxF_OjosAmarillos
	,C2K.hxF_OjosAmarillosActual
	,C2K.hxF_OjosAmarillosHaceDias
	,C2K.sintomasEnfermaFebrilEscalofrios
	,C2K.sintomasEnfermaFebrilEscalofriosActual
	,C2K.sintomasEnfermaFebrilEscalofriosEmpezoHaceDias
	,C2K.hxF_SudoracionProfusa
	,C2K.hxF_SudoracionProfusaActual
	,C2K.hxF_SudoracionProfusaHaceDias
	,C2K.hxF_OrinaOscura
	,C2K.hxF_OrinaOscuraActual
	,C2K.hxF_OrinaOscuraHaceDias
	,C2K.hxF_RigidezNuca
	,C2K.hxF_RigidezNucaActual
	,C2K.hxF_RigidezNucaEmpezoHaceDias AS hxF_RigidezNucaHaceDias -- Cambio de variable sintomasEnfermaFebrilRigidezNucaEmpezoHaceDias
	,C2K.hxF_DebilidadFacial
	,C2K.hxF_DebilidadFacialActual
	,C2K.hxF_DebilidadFacialHaceDias
	,C2K.hxF_Costras
	,C2K.hxF_CostrasActual
	,C2K.hxF_CostrasHaceDias
	,ISNULL(C2K.hxF_IrritacionPiel, C2K.sintomasEnfermaFebrilIrritacionPiel) AS hxF_IrritacionPiel
	,C2K.sintomasEnfermaFebrilIrritacionPielActual
	,C2K.sintomasEnfermaFebrilIrritacionPielFoto
	,C2K.sintomasEnfermaFebrilIrritacionPielEmpezoHaceDias
	,C2K.sintomasEnfermaFebrilIrritacionPielDonde
	,C2K.sintomasEnfermaFebrilIrritacionPielDescripcion
	,C2K.hxF_SangradoInusual
	,C2K.hxF_SangradoInusualActual
	,C2K.hxF_SangradoInusualHaceDias
	,C2K.hxF_SangradoInusualDonde
	-----------------------------------------------

	-- H3B/C2B/P2B
	-----------------------------------------------
	,C2B.buscoTratamientoAntes
	,C2B.otroTratamiento1erTipoEstablecimiento
	,C2B.otroTratamiento1erRecibioMedicamento
	,C2B.otroTratamiento1erAntibioticos
	,C2B.buscoTratamientoAntes2doLugar
	,C2B.otroTratamiento2doTipoEstablecimiento
	,C2B.otroTratamiento2doRecibioMedicamento
	,C2B.otroTratamiento2doAntibioticos
	,NULL AS buscoTratamientoAntes3erLugar
	,NULL AS otroTratamiento3erTipoEstablecimiento
	,NULL AS otroTratamiento3erRecibioMedicamento
	,NULL AS otroTratamiento3erAntibioticos
	,C2B.tomadoMedicamentoUltimas72hora
	,C2B.medUltimas72HorasAntiB
	,C2B.medUltimas72HorasAntipireticos
	,C2B.medicamentosUltimas72HorasEsteroides
	,C2B.medUltimas72HorasAntivirales
	,C2B.otroTratamiento1erZinc
	,C2B.otroTratamiento1erZincDias
	,C2B.otroTratamiento2doZinc
	,C2B.otroTratamiento2doZincDias
	,NULL AS otroTratamiento3erZinc
	,NULL AS otroTratamiento3erZincDias
	,C2B.medUltimas72HorasZinc
	-----------------------------------------------

	-- H7/C7/P7
	-----------------------------------------------
	,C7.PDAInsertDate AS fechaInforme
	,NULL AS egresoMuerteFecha
	,NULL AS egresoTipo
	,NULL AS egresoCondicion
	,NULL AS ventilacionMecanicaDias
	,NULL AS cuidadoIntensivoDias
	,NULL AS temperaturaPrimeras24HorasAlta
	,C7.egresoDiagnostico1
	,C7.egresoDiagnostico1_esp
	,C7.egresoDiagnostico2
	,C7.egresoDiagnostico2_esp
	,C7.zincTratamiento
	-----------------------------------------------

	-- HCP9
	-----------------------------------------------
	,HCP9.seguimientoFechaReporte
	,HCP9.seguimientoObtuvoInformacion
	,HCP9.seguimientoTipoContacto
	,HCP9.seguimientoPacienteCondicion
	,HCP9.seguimientoPacienteMuerteFecha
	,HCP9.seguimientoMuestraSangreColecta
	,HCP9.seguimientoMuestraSangreML
	,HCP9.seguimientoZinc
	,HCP9.seguimientoZincTabletas
	,HCP9.seguimientoZincTabletasQuedan
	,HCP9.seguimientoZincTabletasTomo
	,HCP9.seguimientoZincTabletasPorDia
	,HCP9.seguimientoZincTabletasDiasTomo
	,HCP9.seguimientoZincTabletasNoRazon
	,HCP9.seguimientoZincTabletasNoRazonEs
	-----------------------------------------------

	-- Laboratory Results
	-----------------------------------------------
	,FebrilResultados.dengue_ELISA_lgM
	,FebrilResultados.dengue_ELISA_lgM_convaleciente
	,FebrilResultados.dengue_ELISA_lgG
	,FebrilResultados.dengue_PCR
	,FebrilResultados.dengue_tipo1
	,FebrilResultados.dengue_tipo2
	,FebrilResultados.dengue_tipo3
	,FebrilResultados.dengue_tipo4
	,FebrilResultados.malaria_gotaGruesa
	,FebrilResultados.malaria_PCR
	,FebrilResultados.rickettsias_ELISA
	,FebrilResultados.rickettsias_IF
	,FebrilResultados.rickettsias_PCR
	,FebrilResultados.rickettsias_PCR_ecto
	,FebrilResultados.rickettsia_IF_Convaleciente
	,FebrilResultados.Lepto_PanBioKit
	,FebrilResultados.Se_HizoPanBioConvalenciente
	,FebrilResultados.PanBioKit_Convaleciente
	,FebrilResultados.lepto_MAT
	,FebrilResultados.Bartonella_IF_Agudo
	,FebrilResultados.Bartonella_IF_convaleciente
	,FebrilResultados.Bartonella_PCR
	,FebrilResultados.Observaciones
	-----------------------------------------------
	,C5V.muestraSangreEnteraFechaHora
	,C5V.muestraSangreEnteraColecta
	/*-----------------------------------------------
				ENFERMEDADES CRONICAS
	-----------------------------------------------*/
	,enfermedadesCronicasAsma	
	,enfermedadesCronicasCancer
--	,enfermedadesCronicasDerrame
	,enfermedadesCronicasDiabetes	
	,enfermedadesCronicasEnfermCorazon
	,enfermedadesCronicasEnfermHigado
	,enfermedadesCronicasEnfermPulmones
	,enfermedadesCronicasEnfermRinion
--	,enfermedadesCronicasEsteroides
	,enfermedadesCronicasHipertension
	,enfermedadCronica	= case 
	 when 	
		 enfermedadesCronicasAsma = 1 or 
		 enfermedadesCronicasCancer = 1 or 
		 enfermedadesCronicasDiabetes = 1 or 
		 enfermedadesCronicasEnfermCorazon = 1 or 
		 enfermedadesCronicasEnfermHigado = 1 or 
		 enfermedadesCronicasEnfermPulmones = 1 or 
		 enfermedadesCronicasEnfermRinion = 1 or 
		 enfermedadesCronicasHipertension = 1
	 then 1
	 when 
		 enfermedadesCronicasAsma = 2 or 
		 enfermedadesCronicasCancer = 2 or 
		 enfermedadesCronicasDiabetes = 2 or 
		 enfermedadesCronicasEnfermCorazon = 2 or 
		 enfermedadesCronicasEnfermHigado = 2 or 
		 enfermedadesCronicasEnfermPulmones = 2 or 
		 enfermedadesCronicasEnfermRinion = 2 or 
		 enfermedadesCronicasHipertension = 2
	 then 2
	 else null
	end	
	,FebrilResultados.CHK_IgM
	,FebrilResultados.CHK_PCR
	,FebrilResultados.Zika_PCR
	,C2A.embarazada
	,Sujeto.PDAInsertDate
FROM Clinicos.Sujeto_Centro Sujeto
	LEFT JOIN Control.Sitios ON Sujeto.SubjectSiteID = Sitios.SiteID
	LEFT JOIN LegalValue.LV_DEPARTAMENTO NombreDepto ON Sujeto.departamento = NombreDepto.Value
	LEFT JOIN LegalValue.LV_MUNICIPIO NombreMuni ON Sujeto.municipio = NombreMuni.Value
	LEFT JOIN Clinicos.C1C ON C1C.SubjectID = Sujeto.SubjectID AND C1C.forDeletion = 0
	LEFT JOIN Clinicos.C1F ON C1F.SubjectID = Sujeto.SubjectID AND C1F.forDeletion = 0
	LEFT JOIN Clinicos.C5V ON C5V.SubjectID = Sujeto.SubjectID AND C5V.forDeletion = 0
	LEFT JOIN Clinicos.C2L ON C2L.SubjectID = Sujeto.SubjectID AND C2L.forDeletion = 0
	LEFT JOIN Clinicos.C2D ON C2D.SubjectID = Sujeto.SubjectID AND C2D.forDeletion = 0
	LEFT JOIN Clinicos.C2K ON C2K.SubjectID = Sujeto.SubjectID AND C2K.forDeletion = 0
	LEFT JOIN Clinicos.C2B ON C2B.SubjectID = Sujeto.SubjectID AND C2B.forDeletion = 0
	LEFT JOIN Clinicos.C2F ON C2F.SubjectID = Sujeto.SubjectID AND C2F.forDeletion = 0
	LEFT JOIN Clinicos.C7 ON C7.SubjectID = Sujeto.SubjectID AND C7.forDeletion = 0
	LEFT JOIN Clinicos.HCP9 ON HCP9.SubjectID = Sujeto.SubjectID AND HCP9.forDeletion = 0
	LEFT JOIN Clinicos.C2A ON C2A.SubjectID = Sujeto.SubjectID AND C2A.forDeletion = 0

	LEFT JOIN Lab.FebrilResultados ON FebrilResultados.ID_Paciente = Sujeto.SASubjectID AND FebrilResultados.forDeletion = 0


WHERE Sujeto.forDeletion = 0
--------------------------------------------------------------------------------














GO


