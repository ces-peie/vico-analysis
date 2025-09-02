USE [ViCo]
GO

/****** Object:  View [Clinicos].[Basica_Respira]    Script Date: 08/23/2018 16:03:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/*
	Creada por: Gerardo López
	Fecha: algún día de 2007 o 2008

	Esta vista provee información básica para iniciar análisis en los casos de
	enfermedades respiratorias de ViCo.

	[2011-07-22] Marvin Xuya:
	* Cambio de formato de fechaDeNacimiento de datetime a date 113.
	* Se deja comentado el formato anterior.

	[2011-10-24] Fredy Muñoz:
	* Agregué las siguientes variables que forman parte del criterio de
	  elegibilidad según la versión 7.1 de ViCo:
		elegibleRespiraViCo
		elegibleRespiraIMCI
		hipoxemia
		ninioTuvoConvulsionesObs
		sintomasRespiraTos14Dias
		sintomasRespiraGarganta14Dias

	[2011-10-25] Fredy Muñoz:
	* Habilité las variables sobre oximetría de pulso para Centro y Puesto.
	  Estas estaban devolviendo NULL por diseño. Probablemente no se
	  preguntaban en Centro y Puesto cuando se creó esta vista.

	[2011-10-26] Fredy Muñoz:
	* Agregué variable elegibleRespiraIMCI_Retro
	* Agregué variable oxiAmb
	* Corregí la fuente de la variable ventilacionMecanica, venía de Sujeto
	  pero esta variable nuna ha sido poblada ni utilizada, la correcta debe
	  venir de H2DRF y no existe en Centro ni Puesto.

	[2011-10-28] Fredy Muñoz:
	* Agregué la variable oximetroPulso_Lag para indicar la diferencia en horas
	  entre fechaHoraAdmision y la fecha aproximada en la que se tomó la
	  oximetría.
	  
	[2012-01-31] Karin Ceballos:
	* Agregué los valores de CT desde LIMS para las pruebas de PCR Viral

	[2012-05-03] Karin Ceballos:
	* Modifique los origenes para los resultados de las pruebas, anteriormente
	  se mostraban de los resultados de PCR ahora se mostraran de excel y los
	  valores de CT del PCR debido a que en el comienzo no se realizaban PCRs.

	[2012-05-04] Fredy Muñoz:
	* Agregué la variable oximetroPulsoFechaHoraToma_Esti para indicar la fecha
	  y hora aproximada cuando se midió la oximetría de pulso. Esta fecha y hora
	  es igual a PDAInsertDate del cuestionario donde se registra la lectura:
	  H2DRF, C1, P1.

	[2012-07-10] Karin Ceballos:
	* Agregué las variables
		Binax_RecibioMuestra
		Binax_Resultado
		Binax_HizoPrueba
	  y oculte las variables
		bacterialBinax_Hizo
		bacterialBinax_Sp
	  debido a que se reconstruyeron los resultados, ahora alojados en 
	  Lab.Binax_Orina_Resultados.
	  
	[2013-12-11] Fredy Muñoz:
	* Agregué el valor de CT para FluB (viralPCR_Results.FluB_CT).
	
	  
	[2014-01-13] Karin:
	* Agregué el valor de CT para los Virus Respiratorios Faltantes
	ViralPCR_RSV_CT	, ViralPCR_hMPV_CT	 ViralPCR_RNP_CT	
	
	* Se agrego una h a las variables de parainfluenza y tambien se dejaron todas las variables
	de ct en minusculas.
	
	
	[2014-03-28] Karin:
	agregue a la vista el valor de las variables de vacunas a petición de Jennifer Veranni
	[H3_Informe_del_Caso_A].[vacunaRotavirusRecibido]					as [vacunaRotavirusRecibido]
	[H3_Informe_del_Caso_A].[vacunaNeumococoPrevenar]					as [vacunaNeumococoPrevenar]	
	[H3_Informe_del_Caso_A].[vacunaNeumococoSynflorix]					as [vacunaNeumococoSynflorix]	
	

		2014-04-10  KARIN
	
	agregue
		Sujeto.Registrotemporal como registrotemporal
		H3D.dxNeumonia30DiasAnt=2 -- no tuvo neumonia en los ultimos 30 dias
		h3d.hosp14DiasAnt=2 -- no estuvo hospitalizado en los ultimos 14 dias
sintomasFiebreFechaInicio
muestraLCRColecta
, H7_Egreso_.H7QSangreHemocultivoTomo
,h1FechaEgreso
pacienteInscritoViCoFecha

		20140521 Karin
		Agregue
			h2. SintomasFiebreTemperatura 
			
		, NULL												aS [HemoFechaTomaMuestra]
		, NULL												as [HemoCrecimiento]
[2014-09-18]

AGREGUE  [enfermedadesCronicasOtras]				AS [enfermedadesCronicasOtras]

	[2015-03-09] Se agregaron las siguientes variables de Hemocultivos H5H
		[muestraSangreCultivoColecta]
		[HemoFechaTomaMuestra]
		[MuestraSangreCultivoNumeroKit1]
		[MuestraSangreCultivoRegistro1]
		[MuestraSangreCultivoNumeroKit2]
		[MuestraSangreCultivoRegistro2]
		HemoCrecimiento
		
		[Aero1Resultado]
		[Aero1StreptococcusPneumoniae]
		[Aero1StreptococcusOtro]
		[Aero1Otro]
		[Aero1Contaminado]
		
		[Aero2Resultado]
		[Aero2StreptococcusPneumoniae]
		[Aero2StreptococcusOtro]
		[Aero2Otro]
		[Aero2Contaminado]
		
	Juan de Dios
	[2015-03-12] Se agregaron campos de analisis de radiologos de 3 interpretaciones para los registros que tengan placas
	[2016-04-22] Se detecto que un campo SintomasRespiraTosDias fue cambiada de tabla de laversion 6 a la 7 y no fue actualizada en esta vista
				 se consultara las dos tabla la vieja y la nueva para poder mostrar todos los registros.  CENTRO(C2D anterior,C1C nueva) PUESTO(P2D anterior,P1C nueva)
	[2016-08-25] Se agrego variable para ver si dio consentimiento variable "consentimientoGuardarMuestras"		
	
	Brayan Rosales
	[2016-11-30] Se agregaron las variables de HistoriaApnea, HistoriaCianosis, HistoriaVomitoPostusivo, HistoriaParoxismos, HistoriaWhoop
	             estas variables se incorporaron en la version 12.0.10 de ViCo.
	*/
	
	

CREATE VIEW [Clinicos].[Basica_Respira]
AS


SELECT
		 [Subject].[SubjectID]								AS [SubjectID]
		 ,[Subject].[registrotemporal]						AS [registrotemporal]
		, SUBJECT.pacienteInscritoViCoFecha					AS pacienteInscritoViCoFecha 
/***********************************************************************************************/
/*ID& elegibility*/
		--, pacienteInscritoViCo								AS pacienteInscritoViCo 
		,CASE WHEN
				(
					[Subject].pacienteInscritoViCo = 2
					AND ([Subject].elegibleDiarrea = 1 OR [Subject].elegibleRespira = 1 OR [Subject].elegibleFebril = 1)
					AND [Subject].SASubjectID IS NOT NULL
					AND YEAR([Subject].fechaHoraAdmision) >= 2016
					AND [Subject].pdainsertversion LIKE '12%'
				)
			 THEN 1
			 WHEN 
				(
						[Subject].SubjectID like '95DD8258-E586-4517-AC78-001507FEABFB' OR
						[Subject].SubjectID  like '80968BE5-0C58-4D2C-8510-2274A8BCFCC3' OR
						[Subject].SubjectID  like '006E07F7-6506-416A-9AA4-2C0BB7C5F75A' OR
						[Subject].SubjectID  like '627590DD-6A39-4282-A8A5-436384C6E8F7' OR
						[Subject].SubjectID  like '1D112EB1-7D73-40C8-8B90-6579C9D16AAE' OR
						[Subject].SubjectID  like '15B97789-99A2-4500-AA3D-6964F79E3E49' OR
						[Subject].SubjectID  like '6AE54446-83C7-436A-A329-BEF044EB9FFD' OR
						[Subject].SubjectID  like '6897294C-2EA3-47C4-B326-DE9C498F63EC' OR
						[Subject].SubjectID  like 'D5B96798-A3F9-4A63-8195-EF4F57EF8DAD' OR
						[Subject].SubjectID  like 'B1060287-7761-4ED0-A754-3346B1E332F1' OR
						[Subject].SubjectID  like '25A68BCD-58E8-416A-8040-3B2AB0C9D07E' OR
						[Subject].SubjectID  like 'CEF6B081-223D-4849-914C-4004DED09E79' OR
						[Subject].SubjectID  like '385A3B4D-8870-4927-B6AD-8851B0D8BF1A' OR
						[Subject].SubjectID  like '95F14C7E-BB3C-4D86-A6DC-E6EE2D7A579F' OR
						[Subject].SubjectID  like 'F8D95B40-6BFD-45AF-8681-ECFFE09E330F' OR
						[Subject].SubjectID  like 'DF72BCAD-440F-4DE1-A3A5-F41D52AA9012' OR
						[Subject].SubjectID  like 'F84DF0A8-6656-449B-B0BF-42A4AFE7DAC6' 
				) THEN 0
			 ELSE [Subject].pacienteInscritoViCo
		END pacienteInscritoViCo
		, [Subject].[SASubjectID]							AS [SASubjectID]
		, [Subject].[elegibleDiarrea]						AS [elegibleDiarrea]
		, [Subject].[elegibleRespira]						AS [elegibleRespira]
		, [Subject].[elegibleNeuro]							AS [elegibleNeuro]
		, [Subject].[elegibleFebril]						AS [elegibleFebril]
		, [Subject].[elegibleRespiraViCo]					AS [elegibleRespiraViCo]
		, [Subject].[elegibleRespiraIMCI]					AS [elegibleRespiraIMCI]
		
/***********************************************************************************************/
/*elegibleRespiraIMCI_Retro*/
		, elegibleRespiraIMCI_Retro = 
			CASE
				WHEN (edadAnios = 0 AND edadMeses < 2)
					AND
					(
						sintomasRespiraTaquipnea = 1
						OR
						sintomasRespiraNinioCostillasHundidas = 1
						OR
						(
							(sintomasRespiraTos = 1 OR sintomasRespiraDificultadRespirar = 1)
							AND
							(
								sintomasRespiraNinioEstridor = 1
								OR hipoxemia = 1
								OR ninioCianosisObs = 1
								OR ninioBeberMamar = 2
								OR ninioVomitaTodo = 1
								OR ninioTuvoConvulsiones = 1
								OR ninioTuvoConvulsionesObs = 1
								OR ninioTieneLetargiaObs = 1
								OR ninioDesmayoObs = 1
								OR ninioCabeceoObs = 1
								OR ninioMovimientoObs = 2
								OR ninioMovimientoObs = 3
							)
						)
					)
				THEN 1

				WHEN ((edadAnios = 0 AND edadMeses >= 2) OR (edadAnios > 0 AND edadAnios < 5))
					AND
					(sintomasRespiraTos = 1 OR sintomasRespiraDificultadRespirar = 1)
					AND
					(
						sintomasRespiraTaquipnea = 1
						OR sintomasRespiraNinioCostillasHundidas = 1
						OR sintomasRespiraNinioEstridor = 1
						OR hipoxemia = 1
						OR ninioCianosisObs = 1
						OR ninioBeberMamar = 2
						OR ninioVomitaTodo = 1
						OR ninioTuvoConvulsiones = 1
						OR ninioTuvoConvulsionesObs = 1
						OR ninioTieneLetargiaObs = 1
						OR ninioDesmayoObs = 1
						OR ninioCabeceoObs = 1
					)
				THEN 1
				
				ELSE 2
			END


/***********************************************************************************************/
/*Date*/
		, [Subject].[fechaHoraAdmision] 					AS [fechaHoraAdmision]	
		, [Subject].[epiWeekAdmision] 						AS [epiWeekAdmision]	
		, [Subject].[epiYearAdmision] 						AS [epiYearAdmision]			
/********************************************************************************/
/*Consent*/		
		, [Subject].[consentimientoVerbal] 					AS [consentimientoVerbal]
		, [Subject].[consentimientoEscrito] 				AS [consentimientoEscrito]
		, [Subject].[asentimientoEscrito] 					AS [asentimientoEscrito]
			
/********************************************************************************/
/*Site location*/

		, [Subject].[SubjectSiteID]							AS [SubjectSiteID]	
		, Sitios.[NombreShortName]							AS [SiteName]	
		, SiteType = Sitios.TipoSitio
		, SiteDepartamento = Sitios.DeptoShortName
		, NombreDepto.Text									AS NombreDepartamento
		, NombreMuni.Text									AS NombreMunicipio 
			
/***********************************************************************************************/
/*Patient Location*/
		, [Subject].[departamento]							AS [departamento]
		, [Subject].[municipio]								AS [municipio]
		, [Subject].[comunidad]								AS [comunidad]
		, [Subject].[lugarPoblado]							AS [censo_codigo]
		, censo.comunidad									AS [censo_comunidad]
		, catchment =
			CASE	
				WHEN
						(subject.departamento = 6 
							AND (SubjectSiteID = 1 OR SubjectSiteID = 2 
								OR SubjectSiteID = 3 OR SubjectSiteID = 4 
								OR SubjectSiteID = 5 OR SubjectSiteID = 6 
								OR SubjectSiteID = 7  )
							AND (	   Subject.municipio = 601 
									OR Subject.municipio = 602 
									OR Subject.municipio = 603 
									OR Subject.municipio = 604 
									OR Subject.municipio = 605 
									OR Subject.municipio = 606 
									OR Subject.municipio = 607 
									OR Subject.municipio = 610 
									OR Subject.municipio = 612 
									OR Subject.municipio = 613 
									OR Subject.municipio = 614)
						)	
						OR
						(Subject.departamento = 9 
							AND 
								(SubjectSiteID = 9 OR SubjectSiteID = 12 
								OR SubjectSiteID = 13 OR SubjectSiteID = 14 
								OR SubjectSiteID = 15 OR SubjectSiteID = 17)
							AND (	   Subject.municipio = 901 
									OR Subject.municipio = 902 
									OR Subject.municipio = 903 
									OR Subject.municipio = 909 
									OR Subject.municipio = 910 
									OR Subject.municipio = 911 
									OR Subject.municipio = 913 
									OR Subject.municipio = 914 
									OR Subject.municipio = 916 
									OR Subject.municipio = 923
									OR Subject.municipio = 912
									)
						)		
						OR
						(Subject.departamento = 1 
							AND SubjectSiteID = 11 
						)					
					THEN 1
				ELSE 2
			END
/***********************************************************************************************/
	/*Demographic*/
		, [Subject].[sexo]									AS [sexo]
		, [Subject].[edadAnios]								AS [edadAnios]
		, [Subject].[edadMeses] 							AS [edadMeses]
		, [Subject].[edadDias] 								AS [edadDias]
      --, [Subject].[fechaDeNacimiento] 					AS [fechaDeNacimiento] -- cambio de formato de fecha
		, CONVERT (DATE,[Subject].[fechaDeNacimiento],113) 	AS [fechaDeNacimiento]      
		, [H3_Informe_del_Caso_F].[pacienteGrupoEtnico]		AS [pacienteGrupoEtnico]		
	
/***********************************************************************************************/	
		/*DEATH INFO*/
		, muerteViCo = 
			CASE	
				WHEN	[H7_Egreso_].egresoTipo  = 4 OR seguimientoPacienteCondicion = 3
					THEN 1
				ELSE 2
			END
		, muerteViCoFecha = 
			CASE 
				WHEN [H7_Egreso_].egresoTipo  = 4 
					THEN [H7_Egreso_].egresoMuerteFecha
				WHEN seguimientoPacienteCondicion = 3
					THEN seguimientoPacienteMuerteFecha
				ELSE NULL 
			END				
		, muerteSospechoso = /*H1, h2cv, h2ce*/
			CASE	
				WHEN	h1TipoEgreso = 4  OR [H2_Inscripción_CV].ConsentimientoVerbalNoRazonMurio = 1 OR  ConsentimientoEscritoMurio = 1
					THEN 1
				ELSE 2
			END
		, muerteSospechosoFecha = 
			CASE 
				WHEN h1TipoEgreso = 4
					THEN  h1FechaEgreso
				WHEN ConsentimientoVerbalNoRazonMurio = 1 OR ConsentimientoEscritoMurio = 1
					THEN  [Subject].PDAInsertDate
				ELSE NULL 
			END				
		, muerteHospital = /*enHospital(tamizaje,duranteEntrevista, antes de egresoCondicion H7) = 1*/ /*afueraHospital (seguimiento) = 2*/
			CASE
					WHEN (h1TipoEgreso = 4  OR [H2_Inscripción_CV].ConsentimientoVerbalNoRazonMurio = 1 OR  ConsentimientoEscritoMurio = 1 OR [H7_Egreso_].egresoTipo  = 4 )
						THEN 1
					WHEN seguimientoPacienteCondicion = 3
						THEN 2
					ELSE NULL
			END  					
		, muerteCualPaso	=	
							/*
							1 = tamizaje/consent 
							2 = duranteEntrevista (inscrito, but NOT everything IS done HCP11 filled out probably)
							3 = antes de egreso (H7)
							4 = seguimiento (hcp9)
							*/
			CASE	
				WHEN h1TipoEgreso = 4  OR ConsentimientoVerbalNoRazonMurio = 1 OR  ConsentimientoEscritoMurio = 1 
					THEN 1
				WHEN terminoManeraCorrectaNoRazon = 3
					THEN 2
				WHEN [H7_Egreso_].egresoTipo  = 4
					THEN 3
				WHEN seguimientoPacienteCondicion = 3
					THEN 4
				ELSE NULL 
			END					
		, moribundoViCo /*H7*/ =
			CASE	
				WHEN [H7_Egreso_].egresoCondicion = 4 AND (seguimientoPacienteCondicion IS NULL OR seguimientoPacienteCondicion <> 3)/*(moribundo) but NO seguimientoPacienteCondicion = 3  seguimientoPacienteMuerteFecha OR they are still alive!*/
					THEN 1
				ELSE NULL
			END 				
		, moribundoViCoFecha  /*H7*/=
			CASE	
				WHEN [H7_Egreso_].egresoCondicion = 4 AND (seguimientoPacienteCondicion IS NULL OR seguimientoPacienteCondicion <> 3)/*(moribundo) but NO seguimientoPacienteCondicion = 3  seguimientoPacienteMuerteFecha OR they are still alive!*/
					THEN [H7_Egreso_].egresoMuerteFecha 
				
				ELSE NULL 
			END 					
		, moribundoSospechoso = /*H1*/
			CASE
				WHEN condicionEgreso = 4 
					THEN 1
				ELSE NULL 
			END				
		, moribundoSospechosoFecha = /*H1*/
			CASE
				WHEN  condicionEgreso = 4 
					THEN [Subject].PDAInsertDate
				ELSE NULL 
			END
/********************************************************************************/
/*H1/C1/P1*/		
		, [Subject].[salaIngreso] 							AS [salaIngreso] --- cambio de variable anteriormente de tabla [H1_Sospechosos_]
		, [Subject].[presentaIndicacionRespira] 			AS [presentaIndicacionRespira]
		, [Subject].[indicacionRespira] 					AS [indicacionRespira]
		, [H1_Sospechosos_].[indicacionRespira_otra]		AS [indicacionRespira_otra]
		, [Subject].[presentaIndicacionDiarrea] 			AS [presentaIndicacionDiarrea]
		, [H1_Sospechosos_].[indicacionDiarrea] 			AS [indicacionDiarrea]
		, [H1_Sospechosos_].[indicacionDiarrea_otra]		AS [indicacionDiarrea_otra]
		, [Subject].[presentaIndicacionNeuro] 				AS [presentaIndicacionNeuro]
		, [H1_Sospechosos_].[indicacionNeuro] 				AS [indicacionNeuro]
		, [H1_Sospechosos_].[indicacionNeuro_otra]			AS [indicacionNeuro_otra]
		, [Subject].[presentaIndicacionFebril]				AS [presentaIndicacionFebril]
		, [H1_Sospechosos_].[indicacionFebril]				AS [indicacionFebril]
		, [H1_Sospechosos_].[indicacionFebril_otra]			AS [indicacionFebril_otra]
		, [Subject].[actualAdmitido]						AS [actualAdmitido]
		
/*H2REM/C1C/P1C*/
		, [Subject].[medirTemperaturaCPrimeras24Horas]		AS [medirTemperaturaCPrimeras24Horas]
		, [Subject].[temperaturaPrimeras24Horas]			AS [temperaturaPrimeras24Horas]
		, [Subject].[sintomasRespiraFiebre] 				AS [sintomasRespiraFiebre]
		, [Subject].[sintomasRespiraHipotermia] 			AS [sintomasRespiraHipotermia]
		, [Subject].[sintomasFiebre] 						AS [sintomasFiebre]
		, [Subject].[sintomasFiebreDias] 					AS [sintomasFiebreDias]
		, [Subject].[fiebreOHistoriaFiebre]					AS [fiebreOHistoriaFiebre]
		, [H2_Inscripción_C].sintomasFiebreFechaInicio		AS sintomasFiebreFechaInicio
		, [Subject].sintomasFiebretemperatura				AS sintomasFiebreTemperatura
		, [Subject].[tieneResultadoHematologia]				AS [tieneResultadoHematologia]
		, [Subject].[conteoGlobulosBlancos]					AS [conteoGlobulosBlancos]
		, [Subject].[diferencialAnormal] 					AS [diferencialAnormal]
		, [Subject].[sintomasRespiraCGB] 					AS [sintomasRespiraCGB]
		, [Subject].[resultadoAnormalExamenPulmones]		AS [resultadoAnormalExamenPulmones]
		, [H2_Inscripción_REM].[medidaRespiraPorMinutoPrimeras24Horas] AS [medidaRespiraPorMinutoPrimeras24Horas]
		, [Subject].[respiraPorMinutoPrimaras24Horas]		AS [respiraPorMinutoPrimaras24Horas]
		, [Subject].[sintomasRespiraTaquipnea]				AS [sintomasRespiraTaquipnea]
		, [Subject].[puncionLumbar] 						AS [puncionLumbar]
		, [Subject].[LCRconteoGlobulosBlancos] 				AS [LCRconteoGlobulosBlancos]
		, [H2_Inscripción_REM].[LCRFecha] 					AS [LCRFecha]
		, [H2_Inscripción_C].[ninioVomitaTodo]				AS [ninioVomitaTodo]
		, [H2_Inscripción_C].[ninioBeberMamar]				AS [ninioBeberMamar]
		, [H2_Inscripción_C].[ninioTuvoConvulsiones]		AS [ninioTuvoConvulsiones]
		, [H2_Inscripción_C].[ninioTuvoConvulsionesObs]		AS [ninioTuvoConvulsionesObs]
		, [H2_Inscripción_C].[ninioTieneLetargiaObs]		AS [ninioTieneLetargiaObs]
		, [H2_Inscripción_REM].[historiaApnea]				AS [historiaApnea]
		, [H2_Inscripción_REM].[Historiacianosis]			AS [historiaCianosis]
		, [H2_Inscripción_REM].[historiaVomitoPostusivo]	AS [historiaVomitoPostusivo]
		, [H2_Inscripción_REM].[HistoriaParoxismos]			AS [HistoriaParoxismos]
		, [H2_Inscripción_REM].[HistoriaWhoop]				AS [HistoriaWhoop]
		
/*H2DRF/C1C/P1C*/
		, [Subject].[diarreaUltimos7Dias] 					AS [diarreaUltimos7Dias]
		, [H2_Inscripción_DRF].[sintomasRespiraTamizaje]	AS [sintomasRespiraTamizaje]
		, [Subject].[sintomasRespiraTos] 					AS [sintomasRespiraTos]
		, [H2_Inscripción_DRF].[sintomasRespiraTosDias]		AS [sintomasRespiraTosDias]
		, NULL												AS [sintomasRespiraTos14Dias]
		, [H2_Inscripción_DRF].[pertussisVomito] 			AS [pertussisVomito]
		, [H2_Inscripción_DRF].[pertussisParoxismos]		AS [pertussisParoxismos]
		, [H2_Inscripción_DRF].[pertussisWhoop]				AS [pertussisWhoop]
		, [Subject].[sintomasRespiraDificultadRespirar]		AS [sintomasRespiraDificultadRespirar]
		, H2_Inscripción_DRF.sintomasRespiraDificultadDias	AS [sintomasRespiraDificultadDias]
		, [Subject].[sintomasRespiraEsputo] 				AS [sintomasRespiraEsputo]
		, [Subject].[sintomasRespiraHemoptisis]				AS [sintomasRespiraHemoptisis]
		, [Subject].[sintomasRespiraDolorGarganta]			AS [sintomasRespiraDolorGarganta]
		, [H2_Inscripción_DRF].sintomasRespiraGargantaDias	AS [sintomasRespiraGargantaDias]
		, NULL												AS [sintomasRespiraGarganta14Dias]
		, [Subject].[sintomasRespiraFaltaAire] 				AS [sintomasRespiraFaltaAire]
		, [Subject].[sintomasRespiraDolorPechoRespirar]		AS [sintomasRespiraDolorPechoRespirar]
		, [Subject].[sintomasRespiraNinioPausaRepedimente]	AS [sintomasRespiraNinioPausaRepedimente]
		, [Subject].[sintomasRespiraNinioCostillasHundidas]	AS [sintomasRespiraNinioCostillasHundidas]
		, [Subject].[sintomasRespiraNinioAleteoNasal]		AS [sintomasRespiraNinioAleteoNasal]
		, [Subject].[sintomasRespiraNinioRuidosPecho]		AS [sintomasRespiraNinioRuidosPecho]
		, [Subject].[sintomasRespira] 						AS [sintomasRespira]
		
		, [H2_Inscripción_DRF].[medirOximetroPulso]			AS [medirOximetroPulso]
		, [H2_Inscripción_DRF].[oximetroPulso]				AS [oximetroPulso]

		
		/*oximetroPulso_Lag*/
		, oximetroPulso_Lag = DATEDIFF(HOUR, fechaHoraAdmision, [H2_Inscripción_DRF].PDAInsertDate)

		
		/*oxiAmb*/
		, oxiAmb =
			CASE
				WHEN H2_Inscripción_DRF.ventilacionMecanica = 1
				THEN NULL

				WHEN H2_Inscripción_DRF.ventilacionMecanica = 2
					AND oxigenoSuplementario = 1
				THEN oximetroPulsoSinOxi

				ELSE oximetroPulso
			END
		/*oximetroPulsoFechaHoraToma_Esti*/
		, oximetroPulsoFechaHoraToma_Esti = [H2_Inscripción_DRF].PDAInsertDate
		, [Subject].[enfermedadEmpezoHaceDias]				AS [enfermedadEmpezoHaceDias]
		, [Subject].[hipoxemia]								AS [hipoxemia]
		/* H2F/C1F */
		, [H2_Inscripción_F].[fiebreRazon]					AS [fiebreRazon]
		, [H2_Inscripción_F].[fiebreOtraRazon_esp]			AS [fiebreOtraRazon_esp]
		, [Subject].[lesionAbiertaInfectada]				AS [lesionAbiertaInfectada]
		, [Subject].[otitisMedia]							AS [otitisMedia]
		/*H5/C5/P5*/
		, [H5_Muestras_V].[muestraHecesHisopoSecoColecta]	AS [muestraHecesHisopoSecoColecta]
		, [H5_Muestras_V].[muestraFroteNP] 					AS [muestraFroteNP]
		, [H5_Muestras_V].muestraLCRColecta					AS muestraLCRColecta
		, [H5_Muestras_V].[muestraFroteNPFechaHora]			AS [muestraFroteNPFechaHora]
		, [H5_Muestras_V].[muestraOrinaColecta]				AS [muestraOrinaColecta]
		, [H5_Muestras_V].[muestraOrinaFechaHora]			AS [muestraOrinaFechaHora]
		, [H5_Muestras_V].[muestraOrinaNumeroML] 			AS [muestraOrinaNumeroML]
		, [H5_Muestras_H].[radiografiaPechoColecta]			AS [radiografiaPechoColecta]
		, [H5_Muestras_H].[radiografiaPechoNumero]			AS [radiografiaPechoNumero]
		/*Hemocultivos*/	
		,CASE WHEN [H5_Muestras_H].[muestraSangreCultivoColecta] IS NULL 
			  THEN [H7_PDA_].muestraSangreCultivoColecta	ELSE [H5_Muestras_H].[muestraSangreCultivoColecta]	--se movio en la version vico12 hacia otra tabla
		 END AS [muestraSangreCultivoColecta]
		,CASE WHEN [H5_Muestras_H].[HemoFechaTomaMuestra] IS NULL		 
				THEN [H7_PDA_].HemoFechaTomaMuestra			ELSE [H5_Muestras_H].[HemoFechaTomaMuestra]		 --se movio en la version vico12 hacia otra tabla
		 END AS [HemoFechaTomaMuestra]
		 ,CASE WHEN [H5_Muestras_H].[muestraSangreCultivoNumeroKit1] IS NULL 
				THEN [H7_PDA_].muestraSangreCultivoNumeroKit1	ELSE [H5_Muestras_H].[muestraSangreCultivoNumeroKit1]	 --se movio en la version vico12 hacia otra tabla
		 END AS [MuestraSangreCultivoNumeroKit1]
		 ,CASE WHEN [H5_Muestras_H].[muestraSangreCultivoRegistro1]  IS NULL 
				THEN [H7_PDA_].muestraSangreCultivoRegistro1    ELSE [H5_Muestras_H].[muestraSangreCultivoRegistro1] 	 --se movio en la version vico12 hacia otra tabla
		 END AS [MuestraSangreCultivoRegistro1]
		 ,CASE WHEN [H5_Muestras_H].[muestraSangreCultivoNumeroKit2]  IS NULL 
				THEN [H7_PDA_].muestraSangreCultivoNumeroKit2	ELSE [H5_Muestras_H].[muestraSangreCultivoNumeroKit2] 	 --se movio en la version vico12 hacia otra tabla
		 END AS [MuestraSangreCultivoNumeroKit2]
		 ,CASE WHEN [H5_Muestras_H].[muestraSangreCultivoRegistro2]  IS NULL 
				THEN [H7_PDA_].muestraSangreCultivoRegistro2	ELSE [H5_Muestras_H].[muestraSangreCultivoRegistro2] 	 --se movio en la version vico12 hacia otra tabla
		 END AS [MuestraSangreCultivoRegistro2]
		,CASE WHEN [H5_Muestras_H].[HemoHemoCrecimiento]	 IS NULL 
				THEN [H7_PDA_].HemoHemoCrecimiento				ELSE [H5_Muestras_H].[HemoHemoCrecimiento]	 --se movio en la version vico12 hacia otra tabla
		 END AS HemoCrecimiento
		,CASE WHEN [H5_Muestras_H].[Aero1Resultado]		IS NULL 
				THEN [H7_PDA_].Aero1Resultado		ELSE [H5_Muestras_H].[Aero1Resultado]		 --se movio en la version vico12 hacia otra tabla
		 END AS [Aero1Resultado]
		,CASE WHEN [H5_Muestras_H].[Aero1StreptococcusPneumoniae] IS NULL 
				THEN [H7_PDA_].Aero1StreptococcusPneumoniae		ELSE [H5_Muestras_H].[Aero1StreptococcusPneumoniae]		 --se movio en la version vico12 hacia otra tabla
		 END AS [Aero1StreptococcusPneumoniae]
		,CASE WHEN [H5_Muestras_H].[Aero1StreptococcusOtro]	IS NULL 
				THEN [H7_PDA_].Aero1StreptococcusOtro		ELSE [H5_Muestras_H].[Aero1StreptococcusOtro]	 --se movio en la version vico12 hacia otra tabla
		 END AS [Aero1StreptococcusOtro]
		,CASE WHEN [H5_Muestras_H].[Aero1Otro]	IS NULL 
				THEN [H7_PDA_].Aero1Otro		ELSE [H5_Muestras_H].[Aero1Otro]	 --se movio en la version vico12 hacia otra tabla
		 END AS [Aero1Otro]
		,CASE WHEN [H5_Muestras_H].[Aero1Contaminado] IS NULL 
				THEN [H7_PDA_].Aero1Contaminado		ELSE [H5_Muestras_H].[Aero1Contaminado]		 --se movio en la version vico12 hacia otra tabla
		 END AS [Aero1Contaminado]
		
	
		,CASE WHEN [H5_Muestras_H].[Aero2Resultado]		IS NULL 
				THEN [H7_PDA_].Aero2Resultado		ELSE [H5_Muestras_H].[Aero2Resultado]	 --se movio en la version vico12 hacia otra tabla
		 END AS [Aero2Resultado]
		,CASE WHEN [H5_Muestras_H].[Aero2StreptococcusPneumoniae] IS NULL 
				THEN [H7_PDA_].Aero2StreptococcusPneumoniae		ELSE [H5_Muestras_H].[Aero2StreptococcusPneumoniae]	 --se movio en la version vico12 hacia otra tabla
		 END AS [Aero2StreptococcusPneumoniae]
		,CASE WHEN [H5_Muestras_H].[Aero2StreptococcusOtro]	IS NULL 
				THEN [H7_PDA_].Aero2StreptococcusOtro		ELSE [H5_Muestras_H].[Aero2StreptococcusOtro]	 --se movio en la version vico12 hacia otra tabla
		 END AS [Aero2StreptococcusOtro]
		,CASE WHEN [H5_Muestras_H].[Aero2Otro]	IS NULL 
				THEN [H7_PDA_].Aero2Otro		ELSE [H5_Muestras_H].[Aero2Otro]	 --se movio en la version vico12 hacia otra tabla
		 END AS [Aero2Otro]
		,CASE WHEN [H5_Muestras_H].[Aero2Contaminado] IS NULL 
				THEN [H7_PDA_].Aero2Contaminado		ELSE [H5_Muestras_H].[Aero2Contaminado]		 --se movio en la version vico12 hacia otra tabla
		 END AS [Aero2Contaminado]

/*H3D/C2D/P2D*/
		, [H3_Informe_del_Caso_D].[respiraEmpezoHaceDias]					AS [respiraEmpezoHaceDias]
		, [H3_Informe_del_Caso_D].[sintomasEnfermRespiraEscalofrios]		AS [sintomasEnfermRespiraEscalofrios]
		, [H3_Informe_del_Caso_D].[hxR_GoteaNariz]							AS [hxR_GoteaNariz]
		, [H3_Informe_del_Caso_D].[hxR_Estornudos]							AS [hxR_Estornudos]
		, [H3_Informe_del_Caso_D].[sintomasEnfermRespiraHervorPecho]		AS [sintomasEnfermRespiraHervorPecho]
		, [H3_Informe_del_Caso_D].[sintomasEnfermRespiraDolorCabeza]		AS [sintomasEnfermRespiraDolorCabeza]
		, [H3_Informe_del_Caso_D].[sintomasEnfermRespiraDolorMuscular]		AS [sintomasEnfermRespiraDolorMuscular]
		, [H3_Informe_del_Caso_D].dxNeumonia30DiasAnt						AS dxNeumonia30DiasAnt
		, [H3_Informe_del_Caso_D].hosp14DiasAnt								AS hosp14DiasAnt

/*H3B/C2B/P2B*/
		, [H3_Informe_del_Caso_B].[buscoTratamientoAntes]					AS [buscoTratamientoAntes]
		, [H3_Informe_del_Caso_B].[otroTratamiento1erTipoEstablecimiento]	AS [otroTratamiento1erTipoEstablecimiento]
		, [H3_Informe_del_Caso_B].[otroTratamiento1erRecibioMedicamento]	AS [otroTratamiento1erRecibioMedicamento]
		, [H3_Informe_del_Caso_B].[otroTratamiento1erAntibioticos]			AS [otroTratamiento1erAntibioticos]
		, [H3_Informe_del_Caso_B].[buscoTratamientoAntes2doLugar]			AS [buscoTratamientoAntes2doLugar]
		, [H3_Informe_del_Caso_B].[otroTratamiento2doTipoEstablecimiento]	AS [otroTratamiento2doTipoEstablecimiento]
		, [H3_Informe_del_Caso_B].[otroTratamiento2doRecibioMedicamento]	AS [otroTratamiento2doRecibioMedicamento]
		, [H3_Informe_del_Caso_B].[otroTratamiento2doAntibioticos]			AS [otroTratamiento2doAntibioticos]
		, [H3_Informe_del_Caso_B].[buscoTratamientoAntes3erLugar]			AS [buscoTratamientoAntes3erLugar]
		, [H3_Informe_del_Caso_B].[otroTratamiento3erTipoEstablecimiento]	AS [otroTratamiento3erTipoEstablecimiento]
		, [H3_Informe_del_Caso_B].[otroTratamiento3erRecibioMedicamento]	AS [otroTratamiento3erRecibioMedicamento]
		, [H3_Informe_del_Caso_B].[otroTratamiento3erAntibioticos]		    AS [otroTratamiento3erAntibioticos]
		, [H3_Informe_del_Caso_B].[tomadoMedicamentoUltimas72hora]			AS [tomadoMedicamentoUltimas72hora]
		, [H3_Informe_del_Caso_B].[medUltimas72HorasAntiB]					AS [medUltimas72HorasAntiB]
		, [H3_Informe_del_Caso_B].[medUltimas72HorasAntiBCual]			    AS [medUltimas72HorasAntiBCual]
		, [H3_Informe_del_Caso_B].[medUltimas72HorasAntipireticos]			AS [medUltimas72HorasAntipireticos]
		, [H3_Informe_del_Caso_B].[medicamentosUltimas72HorasEsteroides]	AS [medicamentosUltimas72HorasEsteroides]
		, [H3_Informe_del_Caso_B].[medUltimas72HorasAntivirales]			AS [medUltimas72HorasAntivirales]
		, [H3_Informe_del_Caso_B].[otroTratamiento1erZinc]					AS [otroTratamiento1erZinc]
		, [H3_Informe_del_Caso_B].[otroTratamiento1erZincDias]				AS [otroTratamiento1erZincDias]
		, [H3_Informe_del_Caso_B].[otroTratamiento2doZinc]					AS [otroTratamiento2doZinc]
		, [H3_Informe_del_Caso_B].[otroTratamiento2doZincDias]				AS [otroTratamiento2doZincDias]
		, [H3_Informe_del_Caso_B].[otroTratamiento3erZinc]					AS [otroTratamiento3erZinc]
		, [H3_Informe_del_Caso_B].[otroTratamiento3erZincDias]				AS [otroTratamiento3erZincDias]
		, [H3_Informe_del_Caso_B].[medUltimas72HorasZinc]					AS [medUltimas72HorasZinc]

--/*H3A/C2A/P2A*/
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasAlguna]				AS [enfermedadesCronicasAlguna]
		, [H3_Informe_del_Caso_A].enfermedadesCronicasAsma					AS [enfermedadesCronicasAsma]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasDiabetes]			AS [enfermedadesCronicasDiabetes]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasCancer]				AS [enfermedadesCronicasCancer]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasEnfermCorazon]		AS [enfermedadesCronicasEnfermCorazon]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasDerrame]				AS [enfermedadesCronicasDerrame]		
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasEnfermHigado]		AS [enfermedadesCronicasEnfermHigado]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasEnfermRinion]		AS [enfermedadesCronicasEnfermRinion]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasEnfermPulmones]		AS [enfermedadesCronicasEnfermPulmones]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasVIHSIDA]				AS [enfermedadesCronicasVIHSIDA]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasHipertension]		AS [enfermedadesCronicasHipertension]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasOtras]				AS [enfermedadesCronicasOtras]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasNacimientoPrematuro]	AS [enfermedadesCronicasNacimientoPrematuro]
		, [H3_Informe_del_Caso_A].[enfermedadesCronicasInfoAdicional]
		, [H3_Informe_del_Caso_A].[tieneFichaVacunacion]					AS [tieneFichaVacunacion]
		, [H3_Informe_del_Caso_A].[vacunaPentavalenteRecibido]				AS [vacunaPentavalenteRecibido]
		, [H3_Informe_del_Caso_A].[vacunaPentavalenteDosis]					AS [vacunaPentavalenteDosis]
		, [H3_Informe_del_Caso_A].[vacunaTripleSarampionRecibido]			AS [vacunaTripleSarampionRecibido]
		, [H3_Informe_del_Caso_A].[vacunaTripleSarampionDosis]				AS [vacunaTripleSarampionDosis]
		, [H3_Informe_del_Caso_A].[vacunaSarampionPaperasRubella]			AS [vacunaSarampionPaperasRubella]
		, [H3_Informe_del_Caso_A].[vacunaInfluenzaSeisMeses]				AS [vacunaInfluenzaSeisMeses]
		, [H3_Informe_del_Caso_A].[vacunaRotavirusRecibido]					AS [vacunaRotavirusRecibido]
		, [H3_Informe_del_Caso_A].[vacunaRotavirusDosis]	
		, [H3_Informe_del_Caso_A].[vacunaNeumococoPrevenar]					AS [vacunaNeumococoPrevenar]
		, [H3_Informe_del_Caso_A].[vacunaNeumococoSynflorix]				AS [vacunaNeumococoSynflorix]
		, [H3_Informe_del_Caso_A].[vacunaNeumococoDosis]					
		, [H3_Informe_del_Caso_A].[vacunaNeumococoPrimeraDosis]
		, [H3_Informe_del_Caso_A].[vacunaNeumococoUltimaDosis]
		, [H3_Informe_del_Caso_A].[embarazada]								AS [embarazada]
		, [H3_Informe_del_Caso_A].[embarazadaMeses]							AS [embarazadaMeses]

--/*H3F/C2F/P2F*/
		, [H3_Informe_del_Caso_F].[parentescoGradoEscolarCompleto]			AS [parentescoGradoEscolarCompleto]
		, [H3_Informe_del_Caso_F].[patienteGradoEscolarCompleto]			AS [patienteGradoEscolarCompleto]
		, [H3_Informe_del_Caso_F].[pacienteFuma]			AS [pacienteFuma]
		, [H3_Informe_del_Caso_F].[casaAlguienFuma]			AS [casaAlguienFuma]
		, [H3_Informe_del_Caso_F].[casaNiniosGuareriaInfantil]				AS [casaNiniosGuareriaInfantil]		
		, [H3_Informe_del_Caso_F].[pacientePecho2Anios]		AS [pacientePecho2Anios]
		, [H3_Informe_del_Caso_F].[casaCuantosDormitorios]	AS [casaCuantosDormitorios]
		, [H3_Informe_del_Caso_F].[casaCuantasPersonasViven]AS [casaCuantasPersonasViven]
		, [H3_Informe_del_Caso_F].[casaMaterialTecho]		AS [casaMaterialTecho]
		, [H3_Informe_del_Caso_F].[casaMaterialPiso]		AS [casaMaterialPiso]
		, [H3_Informe_del_Caso_F].[casaEnergiaElectrica]	AS [casaEnergiaElectrica]
		, [H3_Informe_del_Caso_F].[casaRefrigeradora]		AS [casaRefrigeradora]
		, [H3_Informe_del_Caso_F].[casaComputadora]			AS [casaComputadora]
		, [H3_Informe_del_Caso_F].[casaRadio]				AS [casaRadio]
		, [H3_Informe_del_Caso_F].[casaLavadora]			AS [casaLavadora]
		, [H3_Informe_del_Caso_F].[casaCarroCamion]			AS [casaCarroCamion]
		, [H3_Informe_del_Caso_F].[casaTelevision]			AS [casaTelevision]
		, [H3_Informe_del_Caso_F].[casaSecadora]			AS [casaSecadora]
		, [H3_Informe_del_Caso_F].[casaTelefono]			AS [casaTelefono]
		, [H3_Informe_del_Caso_F].[casaMicroondas]			AS [casaMicroondas]
		, [H3_Informe_del_Caso_F].familiaIngresosMensuales	AS [familiaIngresosMensuales]
		, [H3_Informe_del_Caso_F].casacuantasbombillas
		, [H3_Informe_del_Caso_F].fuentesAguaChorroDentroCasaRedPublica
		, [H3_Informe_del_Caso_F].fuentesAguaChorroPatioCompartidoOtraFuente
		, [H3_Informe_del_Caso_F].fuentesAguaChorroPublico
		, [H3_Informe_del_Caso_F].fuentesAguaCompranAguaEmbotellada
		, [H3_Informe_del_Caso_F].fuentesAguaDeCamionCisterna
		, [H3_Informe_del_Caso_F].fuentesAguaLavaderosPublicos
		, [H3_Informe_del_Caso_F].fuentesAguaLluvia
		, [H3_Informe_del_Caso_F].fuentesAguaPozoPropio
		, [H3_Informe_del_Caso_F].fuentesAguaPozoPublico
		, [H3_Informe_del_Caso_F].fuentesAguaRioLago

/*H3H/C2H/P2H*/
		, [H3_Informe_del_Caso_H].[respiraExamenFisicoMedicoFecha]			AS [respiraExamenFisicoMedicoFecha]
		, [H3_Informe_del_Caso_H].[respiraExamenFisicoMedicoSibilancias]	AS [respiraExamenFisicoMedicoSibilancias]
		, [H3_Informe_del_Caso_H].[respiraExamenFisicoMedicoEstertoresGruesos] AS [respiraExamenFisicoMedicoEstertoresGruesos]
		, [H3_Informe_del_Caso_H].respiraExamenFisicoMedicoEstertoresFinos	AS [respiraExamenFisicoMedicoEstertoresFinos]
		, [H3_Informe_del_Caso_H].[respiraExamenFisicoMedicoRoncus]			AS [respiraExamenFisicoMedicoRoncus]
		, [H3_Informe_del_Caso_H].[respiraExamenFisicoMedicoAdenopatia]		AS [respiraExamenFisicoMedicoAdenopatia]
		, [H3_Informe_del_Caso_H].[respiraExamenFisicoMedicoTirajePecho]	AS [respiraExamenFisicoMedicoTirajePecho]
		, [H3_Informe_del_Caso_H].[respiraExamenFisicoMedicoEstridor]		AS [respiraExamenFisicoMedicoEstridor]
		, [H3_Informe_del_Caso_H].[respiraExamenFisicoMedicoRespiraRuidoso] AS [respiraExamenFisicoMedicoRespiraRuidoso]
		, [H3_Informe_del_Caso_H].[respiraExamenFisicoMedicoMolleraHinchada]AS [respiraExamenFisicoMedicoMolleraHinchada]
		, [H3_Informe_del_Caso_H].[respiraExamenFisicoMedicoAleteoNasal]	AS [respiraExamenFisicoMedicoAleteoNasal]
		, [H3_Informe_del_Caso_H].respiraExamenFisicoMedicoMusculosRespirar AS [respiraExamenFisicoMedicoMusculosRespirar]
		, [H3_Informe_del_Caso_H].respiraExamenFisicoMedicoPuntuaciónDownes	AS [respiraExamenFisicoMedicoPuntuacionDownes]
		
/*H3J/C2J/P2J*/
		, [H3_Informe_del_Caso_J].[pacienteTallaCM1]		AS [pacienteTallaCM1]
		, [H3_Informe_del_Caso_J].[pacienteTallaCM2]		AS [pacienteTallaCM2]
		, [H3_Informe_del_Caso_J].[pacienteTallaCM3]		AS [pacienteTallaCM3]
		, [H3_Informe_del_Caso_J].[pacientePesoLibras1]		AS [pacientePesoLibras1]
		, [H3_Informe_del_Caso_J].[pacientePesoLibras2]		AS [pacientePesoLibras2]
		, [H3_Informe_del_Caso_J].[pacientePesoLibras3]		AS [pacientePesoLibras3]

/*HR6*/
		, [HR6_Radiografia_].[radiografiaPechoPlacaEncontro]AS [radiografiaPechoPlacaEncontro]
		, [HR6_Radiografia_].[radiografiaPechoPlacaFecha]	AS [radiografiaPechoPlacaFecha]
		, [HR6_Radiografia_].[radiografiaPechoResultadoNeumonia]			AS [radiografiaPechoResultadoNeumonia]
		, [HR6_Radiografia_].[radiografiaPechoResultadoNeumoniaPatron]		AS [radiografiaPechoResultadoNeumoniaPatron]
		, [HR6_Radiografia_].[radiografiaPechoResultadoEfusionPleural]		AS [radiografiaPechoResultadoEfusionPleural]
		, [HR6_Radiografia_].[radiografiaPechoResultadoHyperareacion]		AS [radiografiaPechoResultadoHyperareacion]
		, [HR6_Radiografia_].[radiografiaPechoResultadoAtelectasis]			AS [radiografiaPechoResultadoAtelectasis]
		, [HR6_Radiografia_].[radiografiaPechoResultadoCavidadAbsceso]		AS [radiografiaPechoResultadoCavidadAbsceso]
		, [HR6_Radiografia_].[radiografiaPechoResultadoComentario]			AS [radiografiaPechoResultadoComentario]
		, [HR6_Radiografia_].[radiografiaPechoResultadoComentario_esp]		AS [radiografiaPechoResultadoComentario_esp]
		, [HR6_Radiografia_].[radiografiaPechoFotoDigitalTomo]				AS [radiografiaPechoFotoDigitalTomo]
		, [HR6_Radiografia_].[radiografiaPechoFotoDigitalNumero]			AS [radiografiaPechoFotoDigitalNumero]

/*H7/C7/P7*/
		, [H7_Egreso_].[fechaInforme]						AS [fechaInforme]
		, [H7_Egreso_].[egresoMuerteFecha]					AS [egresoMuerteFecha]
		, [H7_Egreso_].[egresoTipo]							AS [egresoTipo]
		, [H7_Egreso_].[egresoCondicion]					AS [egresoCondicion]
		, [H7_Egreso_].[ventilacionMecanicaDias]			AS [ventilacionMecanicaDias]
		, [H7_Egreso_].[cuidadoIntensivoDias]				AS [cuidadoIntensivoDias]
		, [H7_Egreso_].[temperaturaPrimeras24HorasAlta]		AS [temperaturaPrimeras24HorasAlta]
		, [H7_Egreso_].[egresoDiagnostico1]					AS [egresoDiagnostico1]
		, [H7_Egreso_].[egresoDiagnostico1_esp]				AS [egresoDiagnostico1_esp]
		, [H7_Egreso_].[egresoDiagnostico2]					AS [egresoDiagnostico2]
		, [H7_Egreso_].[egresoDiagnostico2_esp]				AS [egresoDiagnostico2_esp]
		, [H7_Egreso_].[zincTratamiento]					AS [zincTratamiento]
		
--		--, H7QRecibioAcyclovir
--		--, H7Q0210
--		--, H7Q0211
--		--, H7Q0212
--		--, H7Q0213
--		--, H7Q0214
--		--, H7Q0215
--		--, H7Q0216
--		--, H7Q0217
--		--, H7Q0218
--		--, H7QRecibioCefadroxil
--		--, H7Q0219
--		--, H7QRecibioCefepime
--		--, H7Q0220
--		--, H7Q0221
--		--, H7Q0222
--		--, H7Q0223
--		--, H7Q0225
--		--, H7Q0226
--		--, H7QRecibioEritromicina
--		--, H7Q0227
--		--, H7QRecibioImipenem
--		--, H7Q0229
--		--, H7Q0231
--		--, H7Q0232
--		--, H7Q0233
--		--, H7Q0234
--		--, H7Q0235
--		--, H7QRecibioOxacilina
--		--, H7QRecibioPerfloxacinia
--		--, H7Q0236
--		--, H7Q0237
		
/* HCP9 */
		, [HCP9_Seguimiento_].[seguimientoFechaReporte]						AS [seguimientoFechaReporte]
		, [HCP9_Seguimiento_].[seguimientoObtuvoInformacion]				AS [seguimientoObtuvoInformacion]
		, [HCP9_Seguimiento_].[seguimientoTipoContacto]						AS [seguimientoTipoContacto]
		, [HCP9_Seguimiento_].[seguimientoPacienteCondicion]				AS [seguimientoPacienteCondicion]
		, [HCP9_Seguimiento_].[seguimientoPacienteMuerteFecha]				AS [seguimientoPacienteMuerteFecha]
		, [HCP9_Seguimiento_].[seguimientoMuestraSangreColecta]				AS [seguimientoMuestraSangreColecta]
		, [HCP9_Seguimiento_].[seguimientoMuestraSangreML]					AS [seguimientoMuestraSangreML]

	/*HCP 9 - ZINC*/
		, [HCP9_Seguimiento_].[seguimientoZinc]								AS [seguimientoZinc]		
		, [HCP9_Seguimiento_].[seguimientoZincTabletas]						AS [seguimientoZincTabletas]			
		, [HCP9_Seguimiento_].[seguimientoZincTabletasQuedan]				AS [seguimientoZincTabletasQuedan]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasTomo]					AS [seguimientoZincTabletasTomo]		
		, [HCP9_Seguimiento_].[seguimientoZincTabletasPorDia]				AS [seguimientoZincTabletasPorDia]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasDiasTomo]				AS [seguimientoZincTabletasDiasTomo]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasNoRazon]				AS [seguimientoZincTabletasNoRazon]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasNoRazonEs]			AS [seguimientoZincTabletasNoRazonEs]
		
/*LABS*/
		, LabRespira.[viralPCR_Hizo]
		, LabRespira.[viralPCR_RSV]
		, viralPCR_Results.RSV_CT			AS viralPCR_RSV_CT	
		, LabRespira.[viralPCR_hMPV]
		, viralPCR_Results.MPV_CT			AS viralPCR_hMPV_CT	
------------------------------------------------------------------------------------------------------
		--, LabRespira.[viralPCR_hPIV1]
		--, LabRespira.[viralPCR_hPIV2]
		--, LabRespira.[viralPCR_hPIV3]
		--, LabRespira.[viralPCR_AD]
		--, LabRespira.[viralPCR_FluA]
		, LabRespira.[viralPCR_AD]			AS viralPCR_AD	
		, viralPCR_Results.[AD_CT]			AS viralPCR_AD_CT	
		, viralPCR_FluA						AS viralPCR_FluA	
		, viralPCR_Results.[FluA_CT]		AS viralPCR_FluA_CT	
		, viralPCR_Results.[H1_Result]		AS viralPCR_FluAH1	
		, viralPCR_Results.[H1_CT]			AS viralPCR_FluAH1_CT	
		, viralPCR_Results.[H3_Result]		AS viralPCR_FluAH3	
		, viralPCR_Results.[H3_CT]			AS viralPCR_FluAH3_CT	
		, viralPCR_Results.[H5a_Result] 	AS viralPCR_FluAH5a	
		, viralPCR_Results.[H5a_CT] 		AS viralPCR_FluAH5a_CT	
		, viralPCR_Results.[H5b_Result] 	AS viralPCR_FluAH5b	
		, viralPCR_Results.[H5b_CT] 		AS viralPCR_FluAH5b_CT	
		, viralPCR_Results.[SwA_Result]		AS viralPCR_FluASwA	
		, viralPCR_Results.[SwA_CT]			AS viralPCR_FluASwA_CT	
		, viralPCR_Results.[SwH1_Result] 	AS viralPCR_FluASwH1	
		, viralPCR_Results.[SwH1_CT] 		AS viralPCR_FluASwH1_CT	
		, viralPCR_Results.[pdmH1_Result]	AS viralPCR_pdmH1	
		, viralPCR_Results.[pdmH1_CT]		AS viralPCR_pdmH1_CT	
		, viralPCR_Results.[pdmInfA_Result]	AS viralPCR_pdmInFA	
		, viralPCR_Results.[pdmInfA_CT]		AS viralPCR_pdmInFA_CT	
		, viralPCR_hPIV1					AS viralPCR_hPIV1	
		, viralPCR_Results.[PIV1_CT]		AS viralPCR_hPIV1_CT	
		, viralPCR_hPIV2					AS viralPCR_hPIV2	
		, viralPCR_Results.[PIV2_CT]		AS viralPCR_hPIV2_CT	
		, viralPCR_hPIV3					AS viralPCR_hPIV3
		, viralPCR_Results.[PIV3_CT]		AS viralPCR_hPIV3_CT	
-------------------------------------------------------------------------------------------------------
		, LabRespira.[viralPCR_FluB]
		, viralPCR_Results.[FluB_CT]		AS ViralPCR_FluB_CT	
		, LabRespira.[viralPCR_RNP]
		, viralPCR_Results.[RNP_CT]			AS ViralPCR_RNP_CT	
		, LabRespira.[bacterialPCR_Hizo]
		, LabRespira.[bacterialPCR_CP]
		, LabRespira.[bacterialPCR_LP]
		, LabRespira.[bacterialPCR_LL]
		, LabRespira.[bacterialPCR_MP]
		, LabRespira.[bacterialPCR_Lsp]
		, LabRespira.[bacterialPCR_SP]
		, LabRespira.[bacterialBinax_Lsp]
		, Binax.Recibio_Muestra_LAB			AS Binax_RecibioMuestra
		, Binax.Resultado					AS Binax_Resultado
		, Binax.Se_Hizo_Binax				AS Binax_HizoPrueba
		--, LabRespira.[bacterialBinax_Hizo]
		--, LabRespira.[bacterialBinax_Sp]
		--, LabRespira.[ViralCT1]
		--, LabRespira.[ViralCT11]
		--, LabRespira.[ViralCT111]
		--, LabRespira.[ViralCT2]
		--, LabRespira.[ViralCT22]
		--, LabRespira.[ViralCT222]
		--, LabRespira.[ViralCT3]
		--, LabRespira.[ViralCT33]
		--, LabRespira.[ViralCT333]
		, LabRespira.[ResultadosLN]
		, LabRespira.[observaciones]						AS observaciones_LabRespira
		, LabRespira.[evaluado]
		,pertussis_sosp = 
			CASE
			-- criterios hospital
			WHEN Sitios.TipoSitio = 'H'  --siteType
			and (
				-- sospechaclinica
				--indicacionRespira (10->Cianosis, 31->Tos Ferina)
				--egresoDiagnostico 1 y 2 (8->Cianosis, 38->Tos en exceso, 39-> Tos Ferina)
				(indicacionRespira IN (31) or [H7_Egreso_].egresoDiagnostico1 IN (39) or [H7_Egreso_].egresoDiagnostico2 IN (39)) or 
				-- criterio menores de un año
				(edadAnios < 1 and (
					historiaApnea = 1 or
					--refiereApnea = 1 or -- no hay pregunta
					Historiacianosis = 1 or
					-- refiereCianosis = 1 or -- no hay pregunta
					ninioCianosisObs = 1 or
					historiaVomitoPostusivo = 1 or 
					pertussisVomito = 1 or
					HistoriaParoxismos = 1 or 
					pertussisParoxismos = 1 or
					HistoriaWhoop = 1 or 
					pertussisWhoop = 1
				)) or
				-- criterios 1-11 años
				(sintomasRespiraTosDias >= 7 and edadAnios between 1 and 11 and
					(
						pertussisParoxismos=1 or pertussisVomito=1 or pertussisWhoop=1 --or sintomasRespiraTos14Dias = 1
					)
				) or
				-- criterios 11 o más años
				(sintomasRespiraTosDias >= 14 and edadAnios > 11)) 
			THEN 1
			ELSE 0
		END
		/*- Variables de Pertussis corridos en laboratorio*/
		, bordetella.SeHizoPCR_Pertussis
		, bordetella.[FechaPCRBordetella] 
		, bordetella.Bordetella_spp_PCR
		, bordetella.B_Pertussis_PCR
		, bordetella.B_Parapertussis_PCR
		, bordetella.[ct_IS481]
		, bordetella.[ct_PTXS1]
		/*------------------------------------------------*/
		
		,[H1_Sospechosos_].condicionEgreso
		,[H2_Inscripción_C].ninioCianosisObs
		,[H2_Inscripción_C].ninioCabeceoObs
		,[H2_Inscripción_C].ninioDesmayoObs
		,[H2_Inscripción_C].ninioMovimientoObs
		,[Subject].elegibleIRAG
		,[Subject].fechaTerminacionProyecto
		,[H7_Egreso_].gotaGruesa
		,[H3_Informe_del_Caso_D].hxR_Quejido
		,[Subject].medidaRespiraPorMinuto
		,[H2_Inscripción_DRF].medirOximetroPulsoSinOxi
		,[H5_Muestras_V].muestraFroteOPColecta
		, H5_Muestras_V.muestraFroteOPFechaHora
		,[H2_Inscripción_DRF].oxigenoSuplementario
		,[H2_Inscripción_DRF].oxigenoSuplementarioCuanto
		,[H2_Inscripción_DRF].oximetroPulsoNoRazon
		,[H2_Inscripción_DRF].oximetroPulsoNoRazon_esp
		,[H2_Inscripción_DRF].oximetroPulsoSinOxiNoRazon		
		,[H2_Inscripción_DRF].oximetroPulsoSinOxiNoRazon_esp
		,[H7_PDA_].presionPrimeras24HorasDiastolica
		,[H7_PDA_].presionPrimeras24HorasSistolic		
		,[H7_PDA_].pulso
		,[H3_Informe_del_Caso_H].respiraExamenFisicoMedicoCompleto
		,[HCP9_Seguimiento_].seguimientoAdmitidoHospital
		,[HCP9_Seguimiento_].seguimientoObtuvoInformacionNoRazon
		,[HCP9_Seguimiento_].seguimientoPacienteCondicionManera	
		,[Subject].sintomasRespiraNinioEstridor
		,[H2_Inscripción_DRF].ventilacionMecanica
		,[H2_Inscripción_DRF].ventilacionMecanicaCuanto
		,[Subject].respiraPorMinuto
		,HCP11.terminoManeraCorrectaNoRazon
		,[H2_Inscripción_DRF].OximetroPulsoSinOxi
		, H7_Egreso_.H7QSangreHemocultivoTomo				AS H7QSangreHemocultivoTomo
		,h1FechaEgreso		
/***********************************************************************************************/
/*PDAInsertInfo */

		, [Subject].PDAInsertDate							AS PDAInsertDate
		, CASE [Subject].PDAInsertVersion						
				WHEN '12.0.09' THEN '12.0.10'
				ELSE [Subject].PDAInsertVersion
		  END												AS PDAInsertVersion
		, [Subject].PDAInsertUser							AS PDAInsertUser
		  
/***********************************************************************************************/

/*Datos de hemocultivos resultados*/			
		
		,Rhv2.[Crecimiento]									AS HemoLabCrecimiento
		,Rhv2.[Contaminante]								AS HemoLabContaminante
		,Rhv2.[PatogenoRespiratorio]						AS HemoLabPatogenoRespiratorio
		,Rhv2.[Strept_pneumoniae]							AS HemoLabStrept_pneumoniae
		,Rhv2.[Strept_sp]									AS HemoLabStrept_sp
		,Rhv2.[Staphy_aureus]								AS HemoLabStaphy_aureus
		,Rhv2.[Pseudomonas_aeruginosa]						AS HemoLabPseudomonas_aeruginosa

/*Datos de rayosX interpretado por 3 radiologos.  join xray.etapa3 Codigo de john resultados*/			
	  --,xr3.[ViCoID]
      ,xr3.[agrcncl_cd]
      ,xr3.[agrcncl_dl]
      ,xr3.[agrcncl5_cd]
      ,xr3.[agrcncl5_dl]
      ,xr3.[agrcncl_brd_cd]
      ,xr3.[agrcncl_brd_dl]
      ,xr3.[agrepp_cd]
      ,xr3.[agrepp_dl]
      ,xr3.[agrepp_brd_cd]
      ,xr3.[agrepp_brd_dl]
      ,xr3.[agrqual_cd]
      ,xr3.[agrqual_dl]
      ,xr3.[cncl5]
      ,xr3.[epp]
      ,xr3.[cncl_brd]
      ,xr3.[epp_brd]
      ,xr3.[hilar_any]
      ,xr3.[plfl_any]
      ,xr3.[hyper_any]
      /*JD[2015-05-11] DEFINICION DE elegibleRespira para la definicion 11.0.0.0 y la 9.1.0.0  --------------------------*/
      , CASE WHEN (
		  (
		  ---------------------DEFINICION DE elegibleRespiraViCoV9_1
		  CASE WHEN ([subject].departamento IS NULL OR sintomasRespira IS NULL)
		  THEN 2 
		  ELSE 
				CASE WHEN (((SUBSTRING([subject].SASubjectID,1,2)='06' 
								AND ([subject].departamento=6 OR [subject].departamento=21 OR [subject].departamento=22))
							OR (SUBSTRING([subject].SASubjectID,1,2)='09' 
								AND ([subject].departamento=9 OR
									 [subject].municipio=901 OR
									 [subject].municipio=902 OR
									 [subject].municipio=903 OR
									 [subject].municipio=910 OR
									 [subject].municipio=911 OR
									 [subject].municipio=913 OR
									 [subject].municipio=914 OR
									 [subject].municipio=916 OR
									 [subject].municipio=923
								)
							)
							)
							AND (
									sintomasRespiraTos=1
								 OR sintomasRespiraEsputo=1
								 OR sintomasRespiraHemoptisis=1
								 OR sintomasRespiraDolorPechoRespirar=1
								 OR sintomasRespiraDificultadRespirar=1
								 OR sintomasRespiraFaltaAire=1
								 OR sintomasRespiraDolorGarganta=1
								 OR sintomasRespiraTaquipnea=1
								 OR sintomasRespiraNinioCostillasHundidas=1
								 OR resultadoAnormalExamenPulmones=1
								)
							AND (
									sintomasRespiraFiebre=1
								 OR sintomasRespiraHipotermia=1
								 --OR sintomasFiebre=1
								 OR sintomasRespiraCGB=1
								 OR diferencialAnormal=1
								)
						)
					THEN 1 ELSE 2
			END
		END) = 1 	--AS elegibleRespiraViCoV9_1
		OR
		(
				--------------------DEFINICION DE elegibleRespiraIMCIV11
				CASE WHEN (
					edadAnios IS NULL OR (edadAnios=0 AND edadMeses IS NULL)
					) 
					THEN 2 
					ELSE 
					CASE WHEN ((edadAnios=0 AND edadMeses<2) 
							AND (
									(
										sintomasRespiraTaquipnea=1
										OR sintomasRespiraNinioCostillasHundidas=1
									)
									OR (
										(
											sintomasrespiraTos=1 OR sintomasRespiraDificultadRespirar=1
										)
											AND (
													sintomasRespiraNinioEstridor=1
													OR hipoxemia=1
													OR ninioCianosisObs=1
													OR ninioBeberMamar=2
													OR ninioVomitaTodo=1
													OR ninioTuvoConvulsiones=1
													OR ninioTuvoConvulsionesObs=1
													OR ninioTieneLetargiaObs=1
													OR ninioDesmayoObs=1
													OR ninioCabeceoObs=1
													OR ninioMovimientoObs=2
													OR ninioMovimientoObs=3
													
											)
									)
									)
									
								)
					THEN 1
					ELSE
					CASE WHEN (((edadAnios=0 AND edadMeses>=2) OR (edadAnios>0 AND edadAnios<5)) 
								AND (sintomasRespiraTos=1 OR sintomasRespiraDificultadRespirar=1)
								AND (
										   sintomasRespiraTaquipnea=1
										OR sintomasRespiraNinioCostillasHundidas=1
										OR sintomasRespiraNinioEstridor=1
										OR hipoxemia=1
										OR ninioCianosisObs=1
										OR ninioBeberMamar=2
										OR ninioVomitaTodo=1
										OR ninioTuvoConvulsiones=1
										OR ninioTuvoConvulsionesObs=1
										OR ninioTieneLetargiaObs=1
										OR ninioDesmayoObs=1
										OR ninioCabeceoObs=1
								)
								)
								THEN 1
								ELSE 2
								END
								
						END
					END --AS elegibleRespiraIMCIV11
				
		) = 1
	)
	THEN 1 	ELSE 2 	END 	as elegibleRespiraV9_1
	, CASE WHEN (
		(		---definicion de elegibleRespiraViCo11
				CASE WHEN ([Subject].departamento IS NULL OR sintomasRespira IS NULL)
						THEN 2 
					ELSE 
						CASE WHEN (((SUBSTRING([Subject].SASubjectID,1,2)='06' 
										AND ([Subject].departamento=6 OR [Subject].departamento=21 OR [Subject].departamento=22))
									OR (SUBSTRING([Subject].SASubjectID,1,2)='09' 
										AND ([Subject].departamento=9 OR
											 [Subject].municipio=901 OR
											 [Subject].municipio=902 OR
											 [Subject].municipio=903 OR
											 [Subject].municipio=910 OR
											 [Subject].municipio=911 OR
											 [Subject].municipio=913 OR
											 [Subject].municipio=914 OR
											 [Subject].municipio=916 OR
											 [Subject].municipio=923
										)
									)
									)
									AND (
											sintomasRespiraTos=1
										 OR sintomasRespiraEsputo=1
										 OR sintomasRespiraHemoptisis=1
										 OR sintomasRespiraDolorPechoRespirar=1
										 OR sintomasRespiraDificultadRespirar=1
										 OR sintomasRespiraFaltaAire=1
										 OR sintomasRespiraDolorGarganta=1
										 OR sintomasRespiraTaquipnea=1
										 OR sintomasRespiraNinioCostillasHundidas=1
										 OR resultadoAnormalExamenPulmones=1
										)
									AND (
											sintomasRespiraFiebre=1
										 OR sintomasRespiraHipotermia=1
										 OR sintomasFiebre=1
										 OR sintomasRespiraCGB=1
										 OR diferencialAnormal=1
										)
								)
							THEN 1 ELSE 2
					END
					END	--AS elegibleRespiraViCoV11
		) = 1
		OR
		(
					CASE WHEN (
							edadAnios IS NULL OR (edadAnios=0 AND edadMeses IS NULL)
							) 
							THEN 2 
							ELSE 
							CASE WHEN ((edadAnios=0 AND edadMeses<2) 
									AND (
											(
												sintomasRespiraTaquipnea=1
												OR sintomasRespiraNinioCostillasHundidas=1
											)
											OR (
												(
													sintomasrespiraTos=1 OR sintomasRespiraDificultadRespirar=1
												)
													AND (
															sintomasRespiraNinioEstridor=1
															OR hipoxemia=1
															OR ninioCianosisObs=1
															OR ninioBeberMamar=2
															OR ninioVomitaTodo=1
															OR ninioTuvoConvulsiones=1
															OR ninioTuvoConvulsionesObs=1
															OR ninioTieneLetargiaObs=1
															OR ninioDesmayoObs=1
															OR ninioCabeceoObs=1
															OR ninioMovimientoObs=2
															OR ninioMovimientoObs=3
															
													)
											)
											)
											
										)
							THEN 1
							ELSE
							CASE WHEN (((edadAnios=0 AND edadMeses>=2) OR (edadAnios>0 AND edadAnios<5)) 
										AND (sintomasRespiraTos=1 OR sintomasRespiraDificultadRespirar=1)
										AND (
												   sintomasRespiraTaquipnea=1
												OR sintomasRespiraNinioCostillasHundidas=1
												OR sintomasRespiraNinioEstridor=1
												OR hipoxemia=1
												OR ninioCianosisObs=1
												OR ninioBeberMamar=2
												OR ninioVomitaTodo=1
												OR ninioTuvoConvulsiones=1
												OR ninioTuvoConvulsionesObs=1
												OR ninioTieneLetargiaObs=1
												OR ninioDesmayoObs=1
												OR ninioCabeceoObs=1
										)
										)
										THEN 1
										ELSE 2
										END
								END
							END --AS elegibleRespiraIMCIV11
		) = 1
	)THEN 1 ELSE 2 END AS elegibleRespiraV11
	--, [Subject].PDAInsertUser
	, [H2_Inscripción_REM].tempmax_ingr
	, [H2_Inscripción_REM].tempmax_ingr_reg
	, [Subject].consentimientoGuardarMuestras
	, [viralPCR_Results].LabID
	, [Subject].PDAInsertPDAName
	, H3_Informe_del_Caso_F.combustibleLenia
	, H3_Informe_del_Caso_F.combustibleResiduosCosecha
	, H3_Informe_del_Caso_F.combustibleCarbon
	, H3_Informe_del_Caso_F.combustibleGas
	, H3_Informe_del_Caso_F.combustibleElectricidad
	, H3_Informe_del_Caso_F.combustibleOtro
	, H3_Informe_del_Caso_D.murmullo
	, H3L.hxC_Escalofrios
	FROM  [Clinicos].[Sujeto_Hospital] [Subject]
		LEFT JOIN [Clinicos].[H1] [H1_Sospechosos_]
			ON [Subject].subjectid = [H1_Sospechosos_].subjectid
		LEFT JOIN [Clinicos].[H2REM] [H2_Inscripción_REM]
			ON [Subject].subjectid = [H2_Inscripción_REM].subjectid
		LEFT JOIN [Clinicos].[H2C] [H2_Inscripción_C]
			ON [Subject].subjectid = [H2_Inscripción_C].subjectid
		LEFT JOIN [Clinicos].[H2CV] [H2_Inscripción_CV]
			ON [Subject].subjectid = [H2_Inscripción_CV].subjectid
		LEFT JOIN [Clinicos].[H2DRF] [H2_Inscripción_DRF]
			ON [Subject].subjectid = [H2_Inscripción_DRF].subjectid
		LEFT JOIN [Clinicos].[H2F] [H2_Inscripción_F]
			ON [Subject].subjectid = [H2_Inscripción_F].subjectid
		LEFT JOIN [Clinicos].H2CE H2CE
			ON [Subject].subjectID = H2CE.SubjectID
		LEFT JOIN [Clinicos].[H5V] [H5_Muestras_V]
			ON [Subject].subjectid = [H5_Muestras_V].subjectid
		LEFT JOIN [Clinicos].[H5H] [H5_Muestras_H]
			ON [Subject].subjectid = [H5_Muestras_H].subjectid
		LEFT JOIN [Clinicos].[H3D] [H3_Informe_del_Caso_D]
			ON [Subject].subjectid = [H3_Informe_del_Caso_D].subjectid
		LEFT JOIN [Clinicos].[H3B] [H3_Informe_del_Caso_B]
			ON [Subject].subjectid = [H3_Informe_del_Caso_B].subjectid
		LEFT JOIN [Clinicos].[H3A] [H3_Informe_del_Caso_A]
			ON [Subject].subjectid = [H3_Informe_del_Caso_A].subjectid
		LEFT JOIN [Clinicos].[H3F] [H3_Informe_del_Caso_F]
			ON [Subject].subjectid = [H3_Informe_del_Caso_F].subjectid
		LEFT JOIN [Clinicos].[H3H] [H3_Informe_del_Caso_H]
			ON [Subject].subjectid = [H3_Informe_del_Caso_H].subjectid
		LEFT JOIN [Clinicos].[H3J] [H3_Informe_del_Caso_J]
			ON [Subject].subjectid = [H3_Informe_del_Caso_J].subjectid
		LEFT JOIN [Clinicos].[H3L] [H3L]
			ON [Subject].subjectid = [H3L].subjectid
		LEFT JOIN [Clinicos].[HR6] [HR6_Radiografia_]
			ON [Subject].subjectid = [HR6_Radiografia_].subjectid
		LEFT JOIN [Clinicos].[H7] [H7_Egreso_]
			ON [Subject].subjectid = [H7_Egreso_].subjectid
		LEFT JOIN [Clinicos].[H7P] [H7_Pleural]
			ON [Subject].subjectid = [H7_Pleural].subjectid
		LEFT JOIN [Clinicos].[H7PDA] [H7_PDA_]
			ON [Subject].subjectid = [H7_PDA_].subjectid			
		LEFT JOIN [Clinicos].[HCP9] [HCP9_Seguimiento_]
			ON [Subject].subjectid = [HCP9_Seguimiento_].subjectid
		LEFT JOIN Clinicos.HCP11 HCP11
			ON [Subject].SubjectID = HCP11.SubjectID
		LEFT JOIN Lab.RespiratorioResultados LabRespira
			ON [Subject].SASubjectID = LabRespira.ID_Paciente
		LEFT JOIN [Lab].[VicoSubjectResults] viralPCR_Results
			ON [Subject].SASubjectID = viralPCR_Results.ID_Paciente
		LEFT JOIN [LegalValue].LV_DEPARTAMENTO  NombreDepto
			ON	departamento= NombreDepto.Value
		LEFT JOIN [LegalValue].LV_MUNICIPIO  NombreMuni
			ON	municipio= NombreMuni.Value
		LEFT JOIN ViCo.LegalValue.centros_poblados censo 
			ON ([Subject].lugarPoblado = censo.cod_censo)
		LEFT JOIN [Control].Sitios  Sitios
		ON	Subject.SubjectSiteID= Sitios.SiteID
		LEFT JOIN  Lab.Binax_Orina_Resultados Binax
		ON [Subject].SASubjectID = Binax.SaSubjectid
		LEFT JOIN Hemocultivos.Lab.ResultadosHemocultivosV2 Rhv2
		on Rhv2.subjectID= [Subject].SubjectID
		LEFT JOIN XRay.etapa3 xr3 on convert(nvarchar(50), xr3.ViCoID) = [Subject].SASubjectID
		LEFT JOIN Lab.BordetellaResultados_Unificado bordetella ON bordetella.SASubjectID= [Subject].SASubjectID
		WHERE [Subject].forDeletion = 0
			AND subject.PDAInsertVersion <> '1.0.0'
			AND Sitios.[NombreShortName] NOT LIKE 'HSJDD'
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																																																							Fin Hospital
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

UNION


SELECT
	  [Subject].[SubjectID]									AS [SubjectID]
	 ,''													AS [registrotemporal]
	 , SUBJECT.pacienteInscritoViCoFecha					AS pacienteInscritoViCoFecha
/***********************************************************************************************/
/*ID& elegibility*/
		--, pacienteInscritoViCo								AS pacienteInscritoViCo 
		,CASE WHEN
			(
				[Subject].pacienteInscritoViCo = 2
				AND ([Subject].elegibleDiarrea = 1 OR [Subject].elegibleRespira = 1 OR [Subject].elegibleFebril = 1)
				AND [Subject].SASubjectID IS NOT NULL
				AND YEAR([Subject].fechaHoraAdmision) >= 2016
				AND [Subject].pdainsertversion LIKE '12%'
			)
			 THEN 1
			 WHEN 
				(
						[Subject].SubjectID like '95DD8258-E586-4517-AC78-001507FEABFB' OR
						[Subject].SubjectID  like '80968BE5-0C58-4D2C-8510-2274A8BCFCC3' OR
						[Subject].SubjectID  like '006E07F7-6506-416A-9AA4-2C0BB7C5F75A' OR
						[Subject].SubjectID  like '627590DD-6A39-4282-A8A5-436384C6E8F7' OR
						[Subject].SubjectID  like '1D112EB1-7D73-40C8-8B90-6579C9D16AAE' OR
						[Subject].SubjectID  like '15B97789-99A2-4500-AA3D-6964F79E3E49' OR
						[Subject].SubjectID  like '6AE54446-83C7-436A-A329-BEF044EB9FFD' OR
						[Subject].SubjectID  like '6897294C-2EA3-47C4-B326-DE9C498F63EC' OR
						[Subject].SubjectID  like 'D5B96798-A3F9-4A63-8195-EF4F57EF8DAD' OR
						[Subject].SubjectID  like 'B1060287-7761-4ED0-A754-3346B1E332F1' OR
						[Subject].SubjectID  like '25A68BCD-58E8-416A-8040-3B2AB0C9D07E' OR
						[Subject].SubjectID  like 'CEF6B081-223D-4849-914C-4004DED09E79' OR
						[Subject].SubjectID  like '385A3B4D-8870-4927-B6AD-8851B0D8BF1A' OR
						[Subject].SubjectID  like '95F14C7E-BB3C-4D86-A6DC-E6EE2D7A579F' OR
						[Subject].SubjectID  like 'F8D95B40-6BFD-45AF-8681-ECFFE09E330F' OR
						[Subject].SubjectID  like 'DF72BCAD-440F-4DE1-A3A5-F41D52AA9012' OR
						[Subject].SubjectID  like 'F84DF0A8-6656-449B-B0BF-42A4AFE7DAC6' 
				) THEN 0
			 ELSE [Subject].pacienteInscritoViCo
		END pacienteInscritoViCo
		, [Subject].[SASubjectID]							AS [SASubjectID]
		, [Subject].[elegibleDiarrea]						AS [elegibleDiarrea]
		, [Subject].[elegibleRespira]						AS [elegibleRespira]
		, [Subject].[elegibleNeuro]							AS [elegibleNeuro]
		, [Subject].[elegibleFebril]						AS [elegibleFebril]
		, [Subject].[elegibleRespiraViCo]					AS [elegibleRespiraViCo]
		, [Subject].[elegibleRespiraIMCI]					AS [elegibleRespiraIMCI]
/***********************************************************************************************/
/*elegibleRespiraIMCI_Retro*/

		, elegibleRespiraIMCI_Retro = 
			CASE
				WHEN (edadAnios = 0 AND edadMeses < 2)
					AND
					(
						--sintomasRespiraTaquipnea = 1 --No existe esta variable en Centro, habilitarla cuando exista
						--Or
						sintomasRespiraNinioCostillasHundidas = 1
						OR
						(
							(sintomasRespiraTos = 1 OR sintomasRespiraDificultadRespirar = 1)
							AND
							(
								--sintomasRespiraNinioEstridor = 1 --No existe esta variable en Centro, habilitarla cuando exista
								hipoxemia = 1
								--Or ninioCianosisObs = 1--No existe esta variable en Centro, habilitarla cuando exista
								OR ninioBeberMamar = 2
								OR ninioVomitaTodo = 1
								OR ninioTuvoConvulsiones = 1
								--Or ninioTuvoConvulsionesObs = 1 --No existe esta variable en Centro, habilitarla cuando exista
								--Or ninioTieneLetargiaObs = 1 --No existe esta variable en Centro, habilitarla cuando exista
								--Or ninioDesmayoObs = 1 --No existe esta variable en Centro, habilitarla cuando exista
								--Or ninioCabeceoObs = 1 --No existe esta variable en Centro, habilitarla cuando exista
								--Or ninioMovimientoObs = 2 --No existe esta variable en Centro, habilitarla cuando exista
								--Or ninioMovimientoObs = 3 --No existe esta variable en Centro, habilitarla cuando exista
							)
						)
					)
				THEN 1

				WHEN ((edadAnios = 0 AND edadMeses >= 2) OR (edadAnios > 0 AND edadAnios < 5))
					AND
					(sintomasRespiraTos = 1 OR sintomasRespiraDificultadRespirar = 1)
					AND
					(
						--sintomasRespiraTaquipnea = 1 --No existe esta variable en Centro, habilitarla cuando exista
						sintomasRespiraNinioCostillasHundidas = 1
						--Or sintomasRespiraNinioEstridor = 1 --No existe esta variable en Centro, habilitarla cuando exista
						OR hipoxemia = 1
						--Or ninioCianosisObs = 1 --No existe esta variable en Centro, habilitarla cuando exista
						OR ninioBeberMamar = 2
						OR ninioVomitaTodo = 1
						OR ninioTuvoConvulsiones = 1
						--Or ninioTuvoConvulsionesObs = 1 --No existe esta variable en Centro, habilitarla cuando exista
						--Or ninioTieneLetargiaObs = 1 --No existe esta variable en Centro, habilitarla cuando exista
						--Or ninioDesmayoObs = 1 --No existe esta variable en Centro, habilitarla cuando exista
						--Or ninioCabeceoObs = 1 --No existe esta variable en Centro, habilitarla cuando exista
					)
				THEN 1
				
				ELSE 2
			END

/***********************************************************************************************/
/*Date*/
		, [Subject].[fechaHoraAdmision] 					AS [fechaHoraAdmision]	
		, [Subject].[epiWeekAdmision] 						AS [epiWeekAdmision]	
		, [Subject].[epiYearAdmision] 						AS [epiYearAdmision]		
/********************************************************************************/
/*Consent*/		
		, [Subject].[consentimientoVerbal] 					AS [consentimientoVerbal]
		, [Subject].[consentimientoEscrito] 				AS [consentimientoEscrito]
		, [Subject].[asentimientoEscrito] 					AS [asentimientoEscrito]
/********************************************************************************/
/*Site location*/

		, [Subject].[SubjectSiteID]							AS [SubjectSiteID]	
		, Sitios.[NombreShortName]							AS [SiteName]		
		, SiteType = Sitios.TipoSitio
		, SiteDepartamento = Sitios.DeptoShortName
		, NombreDepto.Text									AS NombreDepartamento
		, NombreMuni.Text									AS NombreMunicipio 

			
/***********************************************************************************************/
/*Patient Location*/
		, [Subject].[departamento]							AS [departamento]
		, [Subject].[municipio]								AS [municipio]
		, CASE [Subject].PDAInsertVersion 
			WHEN '12.1.1'	THEN  NULL 
							ELSE [Subject].[comunidad]								
		  END												AS [comunidad]
		, CASE [Subject].PDAInsertVersion 
			WHEN '12.1.1'	THEN [Subject].[comunidad]		
							ELSE NULL 
		  END												AS [censo_codigo]
		, CASE [Subject].PDAInsertVersion 
			WHEN '12.1.1'	THEN (SELECT comunidad FROM ViCo.LegalValue.centros_poblados WHERE CONVERT(INT,ISNULL([Subject].[comunidad],0)) = cod_censo)		
							ELSE NULL 
		  END												AS [censo_comunidad]
		, catchment =
			CASE	
				WHEN
						( [Subject].departamento = 6 
							AND (SubjectSiteID = 1 OR SubjectSiteID = 2 
								OR SubjectSiteID = 3 OR SubjectSiteID = 4 
								OR SubjectSiteID = 5 OR SubjectSiteID = 6 
								OR SubjectSiteID = 7  )
							AND (	    [Subject].municipio = 601 
									OR  [Subject].municipio = 602 
									OR  [Subject].municipio = 603 
									OR  [Subject].municipio = 604 
									OR  [Subject].municipio = 605 
									OR  [Subject].municipio = 606 
									OR  [Subject].municipio = 607 
									OR  [Subject].municipio = 610 
									OR  [Subject].municipio = 612 
									OR [Subject]. municipio = 613 
									OR  [Subject].municipio = 614)
						)	
						OR
						( [Subject].departamento = 9 
							AND 
								(SubjectSiteID = 9 OR SubjectSiteID = 12 
								OR SubjectSiteID = 13 OR SubjectSiteID = 14 
								OR SubjectSiteID = 15 )
							AND (	    [Subject].municipio = 901 
									OR  [Subject].municipio = 902 
									OR  [Subject].municipio = 903 
									OR  [Subject].municipio = 909 
									OR  [Subject].municipio = 910 
									OR  [Subject].municipio = 911 
									OR  [Subject].municipio = 913 
									OR  [Subject].municipio = 914 
									OR  [Subject].municipio = 916 
									OR  [Subject].municipio = 923)
						)		
						OR
						( [Subject].departamento = 1 
							AND SubjectSiteID = 11 
						)					
					THEN 1
				ELSE 2
			END
/***********************************************************************************************/
	/*Demographic*/
		, [Subject].[sexo]									AS [sexo]
		, [Subject].[edadAnios]								AS [edadAnios]
		, [Subject].[edadMeses] 							AS [edadMeses]
		, [Subject].[edadDias] 								AS [edadDias]
	  --, [Subject].[fechaDeNacimiento]						AS [fechaDeNacimiento] -- cambio de formato de fecha
		, CONVERT (DATE,[Subject].[fechaDeNacimiento],113) 	AS [fechaDeNacimiento]		
		, [C2_Informe_del_Caso_F].[pacienteGrupoEtnico]		AS [pacienteGrupoEtnico]		

/***********************************************************************************************/	
		/*DEATH INFO*/
		,muerteViCo = 
			CASE	
				WHEN	egresoTipo  = 4 OR seguimientoPacienteCondicion = 3
					THEN 1
				ELSE 2
			END
		,muerteViCoFecha = 
			CASE 
				WHEN egresoTipo  = 4 
					THEN [Subject].PDAInsertDate
				WHEN seguimientoPacienteCondicion = 3
					THEN seguimientoPacienteMuerteFecha
				ELSE NULL 
				END
		,muerteSospechoso = /*C0, h2cv, h2ce*/
			CASE	
				WHEN	ConsentimientoVerbalNoRazonMurio = 1 OR  ConsentimientoEscritoMurio = 1
					THEN 1
				ELSE 2
			END
		,muerteSospechosoFecha = 
			CASE 
				WHEN ConsentimientoVerbalNoRazonMurio = 1 OR ConsentimientoEscritoMurio = 1
					THEN  [Subject].PDAInsertDate
				ELSE NULL 
				END
		,NULL												AS muerteHospital				
		,muerteCualPaso = 
						/*
						1 = tamizaje/consent 
						2 = duranteEntrevista (inscrito, but NOT everything IS done HCP11 filled out probably)
						3 = antes de egreso (H7)
						4 = seguimiento (hcp9)
						*/
			CASE	
				WHEN ConsentimientoVerbalNoRazonMurio = 1 OR  ConsentimientoEscritoMurio = 1 
					THEN 1
				WHEN terminoManeraCorrectaNoRazon = 3
					THEN 2
				WHEN egresoTipo  = 4
					THEN 3
				WHEN seguimientoPacienteCondicion = 3
					THEN 4
				ELSE NULL 
			END					
		,NULL												AS moribundoViCo		/*C7?*/ 				
		,NULL												AS moribundoViCoFecha	/*C7?*/
		,NULL 												AS moribundoSospechoso	/**/
		,NULL 												AS moribundoSospechosoFecha  /**/
/********************************************************************************/
/*H1/C1/P1*/		
		, NULL  											AS [salaIngreso]
		, [Subject].[presentaIndicacionRespira]				AS [presentaIndicacionRespira]
		, NULL							 					AS [indicacionRespira]
		, NULL  											AS [indicacionRespira_otra]
		, NULL							 					AS [presentaIndicacionDiarrea]
		, NULL							 					AS [indicacionDiarrea]
		, NULL							 					AS [indicacionDiarrea_otra]
		, NULL							 					AS [presentaIndicacionNeuro]
		, NULL							 					AS [indicacionNeuro]
		, NULL							 					AS [indicacionNeuro_otra]
		, NULL							 					AS [presentaIndicacionFebril]
		, NULL							 					AS [indicacionFebril]
		, NULL							 					AS [indicacionFebril_otra]
		, NULL							 					AS [actualAdmitido]
		
/*H2REM/C1C/P1C*/

		, NULL												AS [medirTemperaturaCPrimeras24Horas]
		, [Subject].[temperaturaPrimeras24Horas]			AS [temperaturaPrimeras24Horas]
		, [Subject].[sintomasRespiraFiebre]					AS [sintomasRespiraFiebre]
		, [Subject].[sintomasRespiraHipotermia]				AS [sintomasRespiraHipotermia]
		, [Subject].[sintomasFiebre]						AS [sintomasFiebre]
		, [Subject].[sintomasFiebreDias]					AS [sintomasFiebreDias]
		, [Subject].[fiebreOHistoriaFiebre]					AS [fiebreOHistoriaFiebre]
		, NULL												AS sintomasFiebreFechaInicio
		, NULL												AS sintomasFiebreTemperatura
		, NULL												AS [tieneResultadoHematologia]
		, NULL												AS [conteoGlobulosBlancos]
		, NULL												AS [diferencialAnormal]
		, NULL												AS [sintomasRespiraCGB]
		, NULL												AS [resultadoAnormalExamenPulmones]
		, NULL												AS [medidaRespiraPorMinutoPrimeras24Horas]
		, NULL												AS [respiraPorMinutoPrimaras24Horas]
		, NULL												AS [sintomasRespiraTaquipnea]
		, NULL												AS [puncionLumbar]
		, NULL												AS [LCRconteoGlobulosBlancos]
		, NULL												AS [LCRFecha]
		, [C1_Inscripción_C].[ninioVomitaTodo]				AS [ninioVomitaTodo]
		, [C1_Inscripción_C].[ninioBeberMamar]				AS [ninioBeberMamar]
		, [C1_Inscripción_C].[ninioTuvoConvulsiones]		AS [ninioTuvoConvulsiones]
		, NULL												AS [ninioTuvoConvulsionesObs]
		, [C1_Inscripción_C].[ninioTieneLetargia]			AS [ninioTieneLetargia]
		, NULL												AS [historiaApnea]
		, NULL												AS [historiaCianosis]
		, NULL												AS [historiaVomitoPostusivo]
		, NULL												AS [HistoriaParoxismos]
		, NULL												AS [HistoriaWhoop]
/*H2DRF/C1C/P1C*/		
		, [Subject].[diarreaUltimos7Dias]					AS [diarreaUltimos7Dias]
		, [C1_Inscripción_C].sintomasRespiraTamizajeCentro	AS [sintomasRespiraTamizaje]
		, [Subject].[sintomasRespiraTos]					AS [sintomasRespiraTos]
		, CASE WHEN [C2_Informe_del_Caso_D].[sintomasRespiraTosDias] IS NULL THEN [C1_Inscripción_C].[sintomasRespiraTosDias]
																			 ELSE [C2_Informe_del_Caso_D].[sintomasRespiraTosDias]
		  END AS [sintomasRespiraTosDias]
		, [C1_Inscripción_C].[sintomasRespiraTos14Dias]		AS [sintomasRespiraTos14Dias]
		, [C1_Inscripción_C].[pertussisVomito]				AS [pertussisVomito]
		, [C1_Inscripción_C].[pertussisParoxismos]			AS [pertussisParoxismos]
		, [C1_Inscripción_C].[pertussisWhoop]				AS [pertussisWhoop]
		, [Subject].[sintomasRespiraDificultadRespirar]		AS [sintomasRespiraDificultadRespirar]
		, [C2_Informe_del_Caso_D].[sintomasRespiraDificultadDias]			AS [sintomasRespiraDificultadDias]
		, [Subject].[sintomasRespiraEsputo]					AS [sintomasRespiraEsputo]
		, [Subject].[sintomasRespiraHemoptisis]				AS [sintomasRespiraHemoptisis]
		, [Subject].[sintomasRespiraDolorGarganta]			AS [sintomasRespiraDolorGarganta]
		, [C2_Informe_del_Caso_D].[sintomasRespiraGargantaDias]				AS [sintomasRespiraGargantaDias]
		, [C1_Inscripción_C].[sintomasRespiraGarganta14Dias]				AS [sintomasRespiraGarganta14Dias]
		, [Subject].[sintomasRespiraFaltaAire]				AS [sintomasRespiraFaltaAire]
		, [Subject].[sintomasRespiraDolorPechoRespirar]		AS [sintomasRespiraDolorPechoRespirar]
		, [Subject].[sintomasRespiraNinioPausaRepedimente]	AS [sintomasRespiraNinioPausaRepedimente]
		, [Subject].[sintomasRespiraNinioCostillasHundidas] AS [sintomasRespiraNinioCostillasHundidas]
		, [Subject].[sintomasRespiraNinioAleteoNasal]		AS [sintomasRespiraNinioAleteoNasal]
		, [Subject].[sintomasRespiraNinioRuidosPecho]		AS [sintomasRespiraNinioRuidosPecho]
		, [Subject].[sintomasRespira]						AS [sintomasRespira]
		
		, [C1_Inscripción_C].[medirOximetroPulso]			AS [medirOximetroPulso]
		, [C1_Inscripción_C].[oximetroPulso]				AS [oximetroPulso]
		, 0													AS oximetroPulso_Lag
		, oximetroPulso										AS oxiAmb
		
		/*oximetroPulsoFechaHoraToma_Esti*/
		, oximetroPulsoFechaHoraToma_Esti = [C1_Inscripción_C].PDAInsertDate

		, [Subject].[enfermedadEmpezoHaceDias]				AS [enfermedadEmpezoHaceDias]
		, [Subject].[hipoxemia]								AS [hipoxemia]
		
/* H2F/C1F */		
		, [C1_Inscripción_F].[fiebreRazon]					AS [fiebreRazon]
		, [C1_Inscripción_F].[fiebreOtraRazon_esp]			AS [fiebreOtraRazon_esp]
		, [Subject].[lesionAbiertaInfectada]				AS [lesionAbiertaInfectada]
		, [Subject].[otitisMedia]							AS [otitisMedia]
		
/*H5/C5/P5*/		
		, [C5_Muestras_V].[muestraHecesHisopoSecoColecta]	AS [muestraHecesHisopoSecoColecta]
		, [C5_Muestras_V].[muestraFroteNP]					AS [muestraFroteNP]
		, NULL												AS [muestraLCRColecta]
		, [C5_Muestras_V].[muestraFroteNPFechaHora]			AS [muestraFroteNPFechaHora]
		, NULL												AS [muestraOrinaColecta]
		, NULL 												AS [muestraOrinaFechaHora]
		, NULL 												AS [muestraOrinaNumeroML]
		, NULL 												AS [radiografiaPechoColecta]
		, NULL 												AS [radiografiaPechoNumero]
		
			/*Hemocultivos*/	
		,NULL												AS [muestraSangreCultivoColecta]
		,NULL												AS [HemoFechaTomaMuestra]
		,NULL												AS [MuestraSangreCultivoNumeroKit1]
		,NULL											    AS [MuestraSangreCultivoRegistro1]
		,NULL												AS [MuestraSangreCultivoNumeroKit2]
		,NULL												AS [MuestraSangreCultivoRegistro2]
		,NULL												AS HemoCrecimiento
		
		,NULL												AS [Aero1Resultado]
		,NULL												AS [Aero1StreptococcusPneumoniae]
		,NULL												AS [Aero1StreptococcusOtro]
		,NULL												AS [Aero1Otro]
		,NULL												AS [Aero1Contaminado]
		
		,NULL												AS [Aero2Resultado]
		,NULL												AS [Aero2StreptococcusPneumoniae]
		,NULL												AS [Aero2StreptococcusOtro]
		,NULL												AS [Aero2Otro]
		,NULL												AS [Aero2Contaminado]
		
/*H3D/C2D/P2D*/
		, [C2_Informe_del_Caso_D].[respiraEmpezoHaceDias]					AS [respiraEmpezoHaceDias]
		, [C2_Informe_del_Caso_D].[sintomasEnfermRespiraEscalofrios]		AS [sintomasEnfermRespiraEscalofrios]
		, [C2_Informe_del_Caso_D].[hxR_GoteaNariz]							AS [hxR_GoteaNariz]
		, [C2_Informe_del_Caso_D].[hxR_Estornudos]							AS [hxR_Estornudos]
		, [C2_Informe_del_Caso_D].[sintomasEnfermRespiraHervorPecho]		AS [sintomasEnfermRespiraHervorPecho]
		, [C2_Informe_del_Caso_D].[sintomasEnfermRespiraDolorCabeza]		AS [sintomasEnfermRespiraDolorCabeza]
		, [C2_Informe_del_Caso_D].[sintomasEnfermRespiraDolorMuscular]		AS [sintomasEnfermRespiraDolorMuscular]
		, 2 AS dxNeumonia30DiasAnt
		, 2 AS hosp14DiasAnt

/*H3B/C2B/P2B*/
		, [C2_Informe_del_Caso_B].[buscoTratamientoAntes]					AS [buscoTratamientoAntes]
		, [C2_Informe_del_Caso_B].[otroTratamiento1erTipoEstablecimiento]	AS [otroTratamiento1erTipoEstablecimiento]
		, [C2_Informe_del_Caso_B].[otroTratamiento1erRecibioMedicamento]	AS [otroTratamiento1erRecibioMedicamento]
		, [C2_Informe_del_Caso_B].[otroTratamiento1erAntibioticos]			AS [otroTratamiento1erAntibioticos]
		, [C2_Informe_del_Caso_B].[buscoTratamientoAntes2doLugar]			AS [buscoTratamientoAntes2doLugar]
		, [C2_Informe_del_Caso_B].[otroTratamiento2doTipoEstablecimiento]	AS [otroTratamiento2doTipoEstablecimiento]
		, [C2_Informe_del_Caso_B].[otroTratamiento2doRecibioMedicamento]	AS [otroTratamiento2doRecibioMedicamento]
		, [C2_Informe_del_Caso_B].[otroTratamiento2doAntibioticos]			AS [otroTratamiento2doAntibioticos]
		, NULL																AS [buscoTratamientoAntes3erLugar]
		, NULL																AS [otroTratamiento3erTipoEstablecimiento]
		, NULL																AS [otroTratamiento3erRecibioMedicamento]
		, NULL																AS [otroTratamiento3erAntibioticos]
		, [C2_Informe_del_Caso_B].[tomadoMedicamentoUltimas72hora]			AS [tomadoMedicamentoUltimas72hora]
		, [C2_Informe_del_Caso_B].[medUltimas72HorasAntiB]					AS [medUltimas72HorasAntiB]
		, NULL			    AS [medUltimas72HorasAntiBCual]
		, [C2_Informe_del_Caso_B].[medUltimas72HorasAntipireticos]			AS [medUltimas72HorasAntipireticos]
		, [C2_Informe_del_Caso_B].[medicamentosUltimas72HorasEsteroides]	AS [medicamentosUltimas72HorasEsteroides]
		, [C2_Informe_del_Caso_B].[medUltimas72HorasAntivirales]			AS [medUltimas72HorasAntivirales]
		, [C2_Informe_del_Caso_B].[otroTratamiento1erZinc]					AS [otroTratamiento1erZinc]
		, [C2_Informe_del_Caso_B].[otroTratamiento1erZincDias]				AS [otroTratamiento1erZincDias]
		, [C2_Informe_del_Caso_B].[otroTratamiento2doZinc]					AS [otroTratamiento2doZinc]
		, [C2_Informe_del_Caso_B].[otroTratamiento2doZincDias]				AS [otroTratamiento2doZincDias]
		, NULL																AS [otroTratamiento3erZinc]
		, NULL																AS [otroTratamiento3erZincDias]
		, [C2_Informe_del_Caso_B].[medUltimas72HorasZinc]					AS [medUltimas72HorasZinc]
		
/*H3A/C2A/P2A*/
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasAlguna]				AS [enfermedadesCronicasAlguna]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasAsma]				AS [enfermedadesCronicasAsma]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasDiabetes]			AS [enfermedadesCronicasDiabetes]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasCancer]				AS [enfermedadesCronicasCancer]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasEnfermCorazon]		AS [enfermedadesCronicasEnfermCorazon]
		, NULL																AS [enfermedadesCronicasDerrame]		
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasEnfermHigado]		AS [enfermedadesCronicasEnfermHigado]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasEnfermRinion]		AS [enfermedadesCronicasEnfermRinion]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasEnfermPulmones]		AS [enfermedadesCronicasEnfermPulmones]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasVIHSIDA]				AS [enfermedadesCronicasVIHSIDA]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasHipertension]		AS [enfermedadesCronicasHipertension]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasOtras]				AS [enfermedadesCronicasOtras]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasNacimientoPrematuro] AS [enfermedadesCronicasNacimientoPrematuro]
		, [C2_Informe_del_Caso_A].[enfermedadesCronicasInfoAdicional] 
		, [C2_Informe_del_Caso_A].[tieneFichaVacunacion]					AS [tieneFichaVacunacion]
		, [C2_Informe_del_Caso_A].[vacunaPentavalenteRecibido]				AS [vacunaPentavalenteRecibido]
		, [C2_Informe_del_Caso_A].[vacunaPentavalenteDosis]					AS [vacunaPentavalenteDosis]
		, [C2_Informe_del_Caso_A].[vacunaTripleSarampionRecibido]			AS [vacunaTripleSarampionRecibido]
		, [C2_Informe_del_Caso_A].[vacunaTripleSarampionDosis]				AS [vacunaTripleSarampionDosis]
		, [C2_Informe_del_Caso_A].[vacunaSarampionPaperasRubella]			AS [vacunaSarampionPaperasRubella]
		, [C2_Informe_del_Caso_A].[vacunaInfluenzaSeisMeses]				AS [vacunaInfluenzaSeisMeses]
		, [c2_Informe_del_Caso_A].[vacunaRotavirusRecibido]					AS [vacunaRotavirusRecibido]
		, [c2_Informe_del_Caso_A].[vacunaRotavirusDosis]
		, NULL																AS [vacunaNeumococoPrevenar]
		, NULL																AS [vacunaNeumococoSynflorix]
		, NULL																AS [vacunaNeumococoDosis]					
		, NULL																AS [vacunaNeumococoPrimeraDosis]
		, NULL																AS [vacunaNeumococoUltimaDosis]
		, [C2_Informe_del_Caso_A].[embarazada]								AS [embarazada]
		, [C2_Informe_del_Caso_A].[embarazadaMeses]							AS [embarazadaMeses]
	
/*H3F/C2F/P2F*/	
		, [C2_Informe_del_Caso_F].[parentescoGradoEscolarCompleto]			AS [parentescoGradoEscolarCompleto]
		, [C2_Informe_del_Caso_F].[patienteGradoEscolarCompleto]			AS [patienteGradoEscolarCompleto]
		, [C2_Informe_del_Caso_F].[pacienteFuma]							AS [pacienteFuma]
		, [C2_Informe_del_Caso_F].[casaAlguienFuma]							AS [casaAlguienFuma]
		, [C2_Informe_del_Caso_F].[casaNiniosGuareriaInfantil]				AS [casaNiniosGuareriaInfantil]	
		, [C2_Informe_del_Caso_F].[pacientePecho2Anios]						AS [pacientePecho2Anios]
		, [C2_Informe_del_Caso_F].[casaCuantosDormitorios]					AS [casaCuantosDormitorios]
		, [C2_Informe_del_Caso_F].casaCuantasPersonasViven					AS [casaCuantasPersonasViven]
		, [C2_Informe_del_Caso_F].[casaMaterialTecho]						AS [casaMaterialTecho]
		, [C2_Informe_del_Caso_F].[casaMaterialPiso]						AS [casaMaterialPiso]
		, [C2_Informe_del_Caso_F].[casaEnergiaElectrica]					AS [casaEnergiaElectrica]
		, [C2_Informe_del_Caso_F].[casaRefrigeradora]						AS [casaRefrigeradora]
		, [C2_Informe_del_Caso_F].[casaComputadora]							AS [casaComputadora]
		, [C2_Informe_del_Caso_F].[casaRadio]								AS [casaRadio]
		, [C2_Informe_del_Caso_F].[casaLavadora]							AS [casaLavadora]
		, [C2_Informe_del_Caso_F].[casaCarroCamion]							AS [casaCarroCamion]
		, [C2_Informe_del_Caso_F].[casaTelevision]							AS [casaTelevision]
		, [C2_Informe_del_Caso_F].[casaSecadora]							AS [casaSecadora]
		, [C2_Informe_del_Caso_F].[casaTelefono]							AS [casaTelefono]
		, [C2_Informe_del_Caso_F].[casaMicroondas]							AS [casaMicroondas]
		, [C2_Informe_del_Caso_F].familiaIngresosMensuales					AS [familiaIngresosMensuales]
		, [C2_Informe_del_Caso_F].casacuantasbombillas
		, [C2_Informe_del_Caso_F].fuentesAguaChorroDentroCasaRedPublica
		, [C2_Informe_del_Caso_F].fuentesAguaChorroPatioCompartidoOtraFuente
		, [C2_Informe_del_Caso_F].fuentesAguaChorroPublico
		, [C2_Informe_del_Caso_F].fuentesAguaCompranAguaEmbotellada
		, [C2_Informe_del_Caso_F].fuentesAguaDeCamionCisterna
		, [C2_Informe_del_Caso_F].fuentesAguaLavaderosPublicos
		, [C2_Informe_del_Caso_F].fuentesAguaLluvia
		, [C2_Informe_del_Caso_F].fuentesAguaPozoPropio
		, [C2_Informe_del_Caso_F].fuentesAguaPozoPublico
		, [C2_Informe_del_Caso_F].fuentesAguaRioLago
		
		
/*H3H/C2H/P2H*/
		, NULL												AS [respiraExamenFisicoMedicoFecha]
		, NULL												AS [respiraExamenFisicoMedicoSibilancias]
		, NULL 												AS [respiraExamenFisicoMedicoEstertoresGruesos]
		, NULL 												AS [respiraExamenFisicoMedicoEstertoresFinos]
		, NULL 												AS [respiraExamenFisicoMedicoRoncus]
		, NULL 												AS [respiraExamenFisicoMedicoAdenopatia]
		, NULL 												AS [respiraExamenFisicoMedicoTirajePecho]
		, NULL 												AS [respiraExamenFisicoMedicoEstridor]
		, NULL 												AS [respiraExamenFisicoMedicoRespiraRuidoso]
		, NULL 												AS [respiraExamenFisicoMedicoMolleraHinchada]
		, NULL 												AS [respiraExamenFisicoMedicoAleteoNasal]
		, NULL 												AS [respiraExamenFisicoMedicoMusculosRespirar]
		, NULL 												AS [respiraExamenFisicoMedicoPuntuacionDownes]
			
/*H3J/C2J/P2J*/
		, [C2_Informe_del_Caso_J].[pacienteTallaCM1]		AS [pacienteTallaCM1]
		, [C2_Informe_del_Caso_J].[pacienteTallaCM2]		AS [pacienteTallaCM2]
		, [C2_Informe_del_Caso_J].[pacienteTallaCM2]		AS [pacienteTallaCM3]
		, [C2_Informe_del_Caso_J].[pacientePesoLibras1]		AS [pacientePesoLibras1]
		, [C2_Informe_del_Caso_J].[pacientePesoLibras2]		AS [pacientePesoLibras2]
		, [C2_Informe_del_Caso_J].[pacientePesoLibras2]		AS [pacientePesoLibras3]
		
/*HR6*/
		, NULL												AS [radiografiaPechoPlacaEncontro]
		, NULL												AS [radiografiaPechoPlacaFecha]
		, NULL												AS [radiografiaPechoResultadoNeumonia]
		, NULL												AS [radiografiaPechoResultadoNeumoniaPatron]
		, NULL												AS [radiografiaPechoResultadoEfusionPleural]
		, NULL												AS [radiografiaPechoResultadoHyperareacion]
		, NULL												AS [radiografiaPechoResultadoAtelectasis]
		, NULL												AS [radiografiaPechoResultadoCavidadAbsceso]
		, NULL												AS [radiografiaPechoResultadoComentario]
		, NULL												AS [radiografiaPechoResultadoComentario_esp]
		, NULL												AS [radiografiaPechoFotoDigitalTomo]
		, NULL												AS [radiografiaPechoFotoDigitalNumero]

--/*H7/C7/P7*/
		, [C7_Egreso_].[PDAInsertDate]						AS [fechaInforme]
		, [C7_Egreso_].[PDAInsertDate]						AS [egresoMuerteFecha]
		, [C7_Egreso_].egresoTipo							AS [egresoTipo]
		, NULL												AS [egresoCondicion]
		, NULL												AS [ventilacionMecanicaDias]
		, NULL												AS [cuidadoIntensivoDias]
		, NULL												AS [temperaturaPrimeras24HorasAlta]
		, [C7_Egreso_].[egresoDiagnostico1]					AS [egresoDiagnostico1]
		, [C7_Egreso_].[egresoDiagnostico1_esp]				AS [egresoDiagnostico1_esp]
		, [C7_Egreso_].[egresoDiagnostico2]					AS [egresoDiagnostico2]
		, [C7_Egreso_].[egresoDiagnostico2_esp]				AS [egresoDiagnostico2_esp]		
		, [C7_Egreso_].[zincTratamiento]					AS [zincTratamiento]
		
--		----, H7QRecibioAcyclovir
--		----, H7Q0210
--		----, H7Q0211
--		----, H7Q0212
--		----, H7Q0213
--		----, H7Q0214
--		----, H7Q0215
--		----, H7Q0216
--		----, H7Q0217
--		----, H7Q0218
--		----, H7QRecibioCefadroxil
--		----, H7Q0219
--		----, H7QRecibioCefepime
--		----, H7Q0220
--		----, H7Q0221
--		----, H7Q0222
--		----, H7Q0223
--		----, H7Q0225
--		----, H7Q0226
--		----, H7QRecibioEritromicina
--		----, H7Q0227
--		----, H7QRecibioImipenem
--		----, H7Q0229
--		----, H7Q0231
--		----, H7Q0232
--		----, H7Q0233
--		----, H7Q0234
--		----, H7Q0235
--		----, H7QRecibioOxacilina
--		----, H7QRecibioPerfloxacinia
--		----, H7Q0236
--		----, H7Q0237
			
/* HCP9 */
		, [HCP9_Seguimiento_].[seguimientoFechaReporte]						AS [seguimientoFechaReporte]
		, [HCP9_Seguimiento_].[seguimientoObtuvoInformacion]				AS [seguimientoObtuvoInformacion]
		, [HCP9_Seguimiento_].[seguimientoTipoContacto] 					AS [seguimientoTipoContacto]
		, [HCP9_Seguimiento_].[seguimientoPacienteCondicion] 				AS [seguimientoPacienteCondicion]
		, [HCP9_Seguimiento_].[seguimientoPacienteMuerteFecha] 				AS [seguimientoPacienteMuerteFecha]
		, [HCP9_Seguimiento_].[seguimientoMuestraSangreColecta] 			AS [seguimientoMuestraSangreColecta]
		, [HCP9_Seguimiento_].[seguimientoMuestraSangreML] 					AS [seguimientoMuestraSangreML]
	
	/*HCP 9 - ZINC*/
		, [HCP9_Seguimiento_].[seguimientoZinc]								AS [seguimientoZinc]		
		, [HCP9_Seguimiento_].[seguimientoZincTabletas]						AS [seguimientoZincTabletas]			
		, [HCP9_Seguimiento_].[seguimientoZincTabletasQuedan]				AS [seguimientoZincTabletasQuedan]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasTomo]					AS [seguimientoZincTabletasTomo]		
		, [HCP9_Seguimiento_].[seguimientoZincTabletasPorDia]				AS [seguimientoZincTabletasPorDia]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasDiasTomo]				AS [seguimientoZincTabletasDiasTomo]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasNoRazon]				AS [seguimientoZincTabletasNoRazon]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasNoRazonEs]			AS [seguimientoZincTabletasNoRazonEs]
		
/*LABS*/
		, LabRespira.[viralPCR_Hizo]
		, LabRespira.[viralPCR_RSV]
		, viralPCR_Results.RSV_CT			AS viralPCR_RSV_CT	
		, LabRespira.[viralPCR_hMPV]
		, viralPCR_Results.MPV_CT			AS viralPCR_hMPV_CT	
		------------------------------------------------------------------------------------------------------

		--, LabRespira.[viralPCR_hPIV1]
		--, LabRespira.[viralPCR_hPIV2]
		--, LabRespira.[viralPCR_hPIV3]
		--, LabRespira.[viralPCR_AD]
		--, LabRespira.[viralPCR_FluA]
	, LabRespira.[viralPCR_AD]				AS viralPCR_AD	
		, viralPCR_Results.[AD_CT]			AS viralPCR_AD_CT	
		, viralPCR_FluA						AS viralPCR_FluA	
		, viralPCR_Results.[FluA_CT]		AS viralPCR_FluA_CT	
		, viralPCR_Results.[H1_Result]		AS viralPCR_FluAH1	
		, viralPCR_Results.[H1_CT]			AS viralPCR_FluAH1_CT	
		, viralPCR_Results.[H3_Result]		AS viralPCR_FluAH3	
		, viralPCR_Results.[H3_CT]			AS viralPCR_FluAH3_CT	
		, viralPCR_Results.[H5a_Result] 	AS viralPCR_FluAH5a	
		, viralPCR_Results.[H5a_CT] 		AS viralPCR_FluAH5a_CT	
		, viralPCR_Results.[H5b_Result] 	AS viralPCR_FluAH5b	
		, viralPCR_Results.[H5b_CT] 		AS viralPCR_FluAH5b_CT	
		, viralPCR_Results.[SwA_Result]		AS viralPCR_FluASwA	
		, viralPCR_Results.[SwA_CT]			AS viralPCR_FluASwA_CT	
		, viralPCR_Results.[SwH1_Result] 	AS viralPCR_FluASwH1	
		, viralPCR_Results.[SwH1_CT] 		AS viralPCR_FluASwH1_CT	
		, viralPCR_Results.[pdmH1_Result]	AS viralPCR_pdmH1	
		, viralPCR_Results.[pdmH1_CT]		AS viralPCR_pdmH1_CT	
		, viralPCR_Results.[pdmInfA_Result]	AS viralPCR_pdmInFA	
		, viralPCR_Results.[pdmInfA_CT]		AS viralPCR_pdmInFA_CT	
		, viralPCR_hPIV1					AS viralPCR_hPIV1	
		, viralPCR_Results.[PIV1_CT]		AS viralPCR_hPIV1_CT	
		, viralPCR_hPIV2					AS viralPCR_hPIV2	
		, viralPCR_Results.[PIV2_CT]		AS viralPCR_hPIV2_CT	
		, viralPCR_hPIV3					AS viralPCR_hPIV3
		, viralPCR_Results.[PIV3_CT]		AS viralPCR_hPIV3_CT	
		
-------------------------------------------------------------------------------------------------------
		, LabRespira.[viralPCR_FluB]
		, viralPCR_Results.[FluB_CT]		AS ViralPCR_FluB_CT	
		, LabRespira.[viralPCR_RNP]
		, viralPCR_Results.[RNP_CT]			AS ViralPCR_RNP_CT	
		, LabRespira.[bacterialPCR_Hizo]
		, LabRespira.[bacterialPCR_CP]
		, LabRespira.[bacterialPCR_LP]
		, LabRespira.[bacterialPCR_LL]
		, LabRespira.[bacterialPCR_MP]
		, LabRespira.[bacterialPCR_Lsp]
		, LabRespira.[bacterialPCR_SP]
		--, LabRespira.[bacterialBinax_Hizo]
		, LabRespira.[bacterialBinax_Lsp]
		--, LabRespira.[bacterialBinax_Sp]
		, Binax.Recibio_Muestra_LAB AS Binax_RecibioMuestra
		, Binax.Resultado AS Binax_Resultado
		, Binax.Se_Hizo_Binax AS Binax_HizoPrueba
		
		
		----, LabRespira.[ViralCT1]
		--, LabRespira.[ViralCT11]
		--, LabRespira.[ViralCT111]
		--, LabRespira.[ViralCT2]
		--, LabRespira.[ViralCT22]
		--, LabRespira.[ViralCT222]
		--, LabRespira.[ViralCT3]
		--, LabRespira.[ViralCT33]
		--, LabRespira.[ViralCT333]
		, LabRespira.[ResultadosLN]
		, LabRespira.[observaciones] 						AS observaciones_LabRespira
		, LabRespira.[evaluado]
		
		,pertussis_sosp = 
			CASE
			WHEN Sitios.TipoSitio IN ('CS', 'PS') -- siteType
			and (
				-- criterios 0 a 11 años
				(
					[C1_Inscripción_C].sintomasRespiraTosDias >= 7 and (edadAnios >= 0 and edadAnios <= 11) and ((pertussisParoxismos=1 or pertussisVomito=1 or pertussisWhoop=1 or [C1_Inscripción_C].sintomasRespiraTos14Dias = 1))
				) or
				-- criterios 11 o más años
				([C1_Inscripción_C].sintomasRespiraTosDias > 14  and edadAnios > 11)
				) THEN 1
			ELSE 0
		END
				/*- Variables de Pertussis corridos en laboratorio*/
		, NULL		SeHizoPCR_Pertussis
		, NULL		FechaPCRBordetella
		, NULL		Bordetella_spp_PCR
		, NULL		B_Pertussis_PCR
		, NULL		B_Parapertussis_PCR
		, NULL		ct_IS481
		, NULL		ct_PTXS1

		/*------------------------------------------------*/
		
		,NULL AS condicionEgreso
		,NULL AS ninioCianosisObs
		,NULL AS ninioCabeceoObs
		,NULL AS ninioDesmayoObs
		,NULL AS ninioMovimientoObs
		,[Subject].elegibleIRAG
		,[Subject].fechaTerminacionProyecto	
		,NULL AS gotaGruesa
		,[C2_Informe_del_Caso_D].hxR_Quejido
		,NULL AS medidaRespiraPorMinuto
		,NULL AS medirOximetroPulsoSinOxi
		,NULL AS muestraFroteOPColecta
		,NULL AS muestraFroteOPFechaHora
		,NULL AS oxigenoSuplementario
		,NULL AS oxigenoSuplementarioCuanto	
		,[C1_Inscripción_C].oximetroPulsoNoRazon
		,[C1_Inscripción_C].oximetroPulsoNoRazon_esp
		,NULL AS oximetroPulsoSinOxiNoRazon
		,NULL AS oximetroPulsoSinOxiNoRazon_esp
		,NULL AS presionPrimeras24HorasDiastolica
		,NULL AS presionPrimeras24HorasSistolic	
		,NULL AS pulso
		,NULL AS respiraExamenFisicoMedicoCompleto
		,NULL AS seguimientoAdmitidoHospital
		,NULL AS seguimientoObtuvoInformacionNoRazon	
		,NULL AS seguimientoPacienteCondicionManera		
		,NULL AS sintomasRespiraNinioEstridor
		,NULL AS ventilacionMecanica		
		,NULL AS ventilacionMecanicaCuanto
		,[Subject].respiraPorMinuto AS respiraPorMinuto
		,HCP11.terminoManeraCorrectaNoRazon
		,NULL AS OximetroPulsoSinOxi
, NULL AS H7QSangreHemocultivoTomo
, NULL AS h1FechaEgreso
/***********************************************************************************************/
/*PDAInsertInfo */
		, [Subject].PDAInsertDate							AS PDAInsertDate
		, [Subject].PDAInsertVersion						AS PDAInsertVersion
		, [Subject].PDAInsertUser							AS PDAInsertUser
/***********************************************************************************************/
			--VARIABLES DE HEMOCULTIVOS LAB
		,NULL												AS HemoLabCrecimiento
		,NULL												AS HemoLabContaminante
		,NULL												AS HemoLabPatogenoRespiratorio
		,NULL												AS HemoLabStrept_pneumoniae
		,NULL												AS HemoLabStrept_sp
		,NULL												AS HemoLabStaphy_aureus
		,NULL												AS HemoLabPseudomonas_aeruginosa
		/*******************************VARIABLES RAYOSX***************************************/
		,NULL AS [agrcncl_cd]
		,NULL AS [agrcncl_dl]
		,NULL AS [agrcncl5_cd]
		,NULL AS [agrcncl5_dl]
		,NULL AS [agrcncl_brd_cd]
		,NULL AS [agrcncl_brd_dl]
		,NULL AS [agrepp_cd]
		,NULL AS [agrepp_dl]
		,NULL AS [agrepp_brd_cd]
		,NULL AS [agrepp_brd_dl]
		,NULL AS [agrqual_cd]
		,NULL AS [agrqual_dl]
		,NULL AS [cncl5]
		,NULL AS [epp]
		,NULL AS [cncl_brd]
		,NULL AS [epp_brd]
		,NULL AS [hilar_any]
		,NULL AS [plfl_any]
		,NULL AS [hyper_any]
		 /*JD[2015-05-11] DEFINICION DE elegibleRespira para la definicion 11.0.0.0 y la 9.1.0.0  --------------------------*/
		,CASE WHEN (
						(
							[Subject].municipio=614
						 OR [Subject].municipio=911
						 OR [Subject].municipio= 914
						 OR	[Subject].municipio= 923
						)
						AND (
								temperaturaPrimeras24Horas>38
							)
						AND (
								sintomasRespiraTos14Dias=1
							 OR sintomasRespiraGarganta14Dias=1
							)
					  )
					  THEN 1
					  ELSE 2
				END AS elegibleRespiraV9_1
	  ,CASE WHEN (
				(
					[Subject].municipio=614
				 OR [Subject].municipio=911
				 OR [Subject].municipio= 914
				 OR	[Subject].municipio= 923
				)
				AND (
						temperaturaPrimeras24Horas>38
				    )
				AND (
						sintomasRespiraTos14Dias=1
					 OR sintomasRespiraGarganta14Dias=1
					)
			  )
			  THEN 1
			  ELSE 2
		END AS elegibleRespiraV11
		--, [Subject].PDAInsertUser
		, NULL	tempmax_ingr
	    , NULL	tempmax_ingr_reg
	    , [Subject].consentimientoGuardarMuestras
	    , [viralPCR_Results].LabID
	    , [Subject].PDAInsertPDAName
	    , [C2_Informe_del_Caso_F].combustibleLenia
		, [C2_Informe_del_Caso_F].combustibleResiduosCosecha
		, [C2_Informe_del_Caso_F].combustibleCarbon
		, [C2_Informe_del_Caso_F].combustibleGas
		, [C2_Informe_del_Caso_F].combustibleElectricidad
		, [C2_Informe_del_Caso_F].combustibleOtro
		, NULL murmullo
		, [C2L].hxC_Escalofrios
		FROM  [Clinicos].[Sujeto_Centro] [Subject]
		--LEFT JOIN [Clinicos].[H1] [H1_Sospechosos_]
		--	ON [Subject].subjectid = [H1_Sospechosos_].subjectid
		--LEFT JOIN [Clinicos].[H2REM] [H2_Inscripción_REM]
		--	ON [Subject].subjectid = [H2_Inscripción_REM].subjectid
		LEFT OUTER JOIN Clinicos.C1CV C1CV
			ON [Subject].SubjectID = C1CV.SubjectID
		LEFT JOIN [Clinicos].[C1C] [C1_Inscripción_C]
			ON [Subject].subjectid = [C1_Inscripción_C].subjectid
		--LEFT JOIN [Clinicos].[H2DRF] [H2_Inscripción_DRF]
		--	ON [Subject].subjectid = [H2_Inscripción_DRF].subjectid
		LEFT JOIN [Clinicos].[C1F] [C1_Inscripción_F]
			ON [Subject].subjectid = [C1_Inscripción_F].subjectid
			LEFT OUTER JOIN Clinicos.C1CE C1CE
				ON [Subject].SubjectID = C1CE.SubjectID
		LEFT JOIN [Clinicos].[C5V] [C5_Muestras_V]
			ON [Subject].subjectid = [C5_Muestras_V].subjectid
		--LEFT JOIN [Clinicos].[H5H] [H5_Muestras_H]
		--	ON [Subject].subjectid = [H5_Muestras_H].subjectid
		LEFT JOIN [Clinicos].[c2D] [C2_Informe_del_Caso_D]
			ON [Subject].subjectid = [C2_Informe_del_Caso_D].subjectid
		LEFT JOIN [Clinicos].[C2B] [C2_Informe_del_Caso_B]
			ON [Subject].subjectid = [C2_Informe_del_Caso_B].subjectid
		LEFT JOIN [Clinicos].[C2A] [C2_Informe_del_Caso_A]
			ON [Subject].subjectid = [C2_Informe_del_Caso_A].subjectid
		LEFT JOIN [Clinicos].[C2F] [C2_Informe_del_Caso_F]
			ON [Subject].subjectid = [C2_Informe_del_Caso_F].subjectid
		LEFT JOIN [Clinicos].[C2L] [C2L]
			ON [Subject].subjectid = [C2L].subjectid
		--LEFT JOIN [Clinicos].[C2H] [H3_Informe_del_Caso_H]
		--	ON [Subject].subjectid = [H3_Informe_del_Caso_H].subjectid
		LEFT JOIN [Clinicos].[C2J] [C2_Informe_del_Caso_J]
			ON [Subject].subjectid = [C2_Informe_del_Caso_J].subjectid
		--LEFT JOIN [Clinicos].[HR6] [HR6_Radiografia_]
		--	ON [Subject].subjectid = [HR6_Radiografia_].subjectid
		LEFT JOIN [Clinicos].[C7] [C7_Egreso_]
			ON [Subject].subjectid = [C7_Egreso_].subjectid
		LEFT JOIN [Clinicos].[HCP9] [HCP9_Seguimiento_]
			ON [Subject].subjectid = [HCP9_Seguimiento_].subjectid
		LEFT OUTER JOIN Clinicos.HCP11 HCP11
			ON [Subject].SubjectID = HCP11.SubjectID
		LEFT OUTER JOIN Lab.RespiratorioResultados LabRespira
				ON [Subject].SASubjectID = LabRespira.ID_Paciente
		LEFT OUTER JOIN [Lab].[VicoSubjectResults] viralPCR_Results
				ON SASubjectID = viralPCR_Results.ID_Paciente
						LEFT JOIN			[LegalValue].LV_DEPARTAMENTO  NombreDepto
				ON	departamento= NombreDepto.Value
		LEFT JOIN			[LegalValue].LV_MUNICIPIO  NombreMuni
				ON	municipio= NombreMuni.Value
					LEFT JOIN Control.Sitios  Sitios
		ON	Subject.SubjectSiteID= Sitios.SiteID
		LEFT JOIN  Lab.Binax_Orina_Resultados Binax
		ON [Subject].SASubjectID = Binax.SaSubjectid
		WHERE [Subject].forDeletion = 0
			AND subject.PDAInsertVersion <> '1.0.0'

		
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																																																							Fin Centro
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

UNION
SELECT
		 [Subject].[SubjectID]								AS [SubjectID]
		, ''							AS [registrotemporal]
		, Subject.pacienteInscritoViCoFecha AS pacienteInscritoViCoFecha
/***********************************************************************************************/
/*ID& elegibility*/
		--, pacienteInscritoViCo								AS pacienteInscritoViCo 
		,CASE WHEN
				(
					[Subject].pacienteInscritoViCo = 2
					AND ([Subject].elegibleDiarrea = 1 OR [Subject].elegibleRespira = 1 OR [Subject].elegibleFebril = 1)
					AND [Subject].SASubjectID IS NOT NULL
					AND YEAR([Subject].fechaHoraAdmision) >= 2016
					AND [Subject].pdainsertversion LIKE '12%'
				)
				THEN 1
				WHEN 
				(
						[Subject].SubjectID like '95DD8258-E586-4517-AC78-001507FEABFB' OR
						[Subject].SubjectID  like '80968BE5-0C58-4D2C-8510-2274A8BCFCC3' OR
						[Subject].SubjectID  like '006E07F7-6506-416A-9AA4-2C0BB7C5F75A' OR
						[Subject].SubjectID  like '627590DD-6A39-4282-A8A5-436384C6E8F7' OR
						[Subject].SubjectID  like '1D112EB1-7D73-40C8-8B90-6579C9D16AAE' OR
						[Subject].SubjectID  like '15B97789-99A2-4500-AA3D-6964F79E3E49' OR
						[Subject].SubjectID  like '6AE54446-83C7-436A-A329-BEF044EB9FFD' OR
						[Subject].SubjectID  like '6897294C-2EA3-47C4-B326-DE9C498F63EC' OR
						[Subject].SubjectID  like 'D5B96798-A3F9-4A63-8195-EF4F57EF8DAD' OR
						[Subject].SubjectID  like 'B1060287-7761-4ED0-A754-3346B1E332F1' OR
						[Subject].SubjectID  like '25A68BCD-58E8-416A-8040-3B2AB0C9D07E' OR
						[Subject].SubjectID  like 'CEF6B081-223D-4849-914C-4004DED09E79' OR
						[Subject].SubjectID  like '385A3B4D-8870-4927-B6AD-8851B0D8BF1A' OR
						[Subject].SubjectID  like '95F14C7E-BB3C-4D86-A6DC-E6EE2D7A579F' OR
						[Subject].SubjectID  like 'F8D95B40-6BFD-45AF-8681-ECFFE09E330F' OR
						[Subject].SubjectID  like 'DF72BCAD-440F-4DE1-A3A5-F41D52AA9012' OR
						[Subject].SubjectID  like 'F84DF0A8-6656-449B-B0BF-42A4AFE7DAC6' 
				) THEN 0
				ELSE [Subject].pacienteInscritoViCo
		 END pacienteInscritoViCo
		, [Subject].[SASubjectID]							AS [SASubjectID]
		, [Subject].[elegibleDiarrea]						AS [elegibleDiarrea]
		, [Subject].[elegibleRespira]						AS [elegibleRespira]
		, [Subject].[elegibleNeuro]							AS [elegibleNeuro]
		, [Subject].[elegibleFebril]						AS [elegibleFebril]
		, [Subject].[elegibleRespiraViCo]					AS [elegibleRespiraViCo]
		, [Subject].[elegibleRespiraIMCI]					AS [elegibleRespiraIMCI]
/***********************************************************************************************/
/*elegibleRespiraIMCI_Retro*/

		, elegibleRespiraIMCI_Retro = 
			CASE
				WHEN (edadAnios = 0 AND edadMeses < 2)
					AND
					(
						--sintomasRespiraTaquipnea = 1 --No existe esta variable en Puesto, habilitarla cuando exista
						--Or
						sintomasRespiraNinioCostillasHundidas = 1
						OR
						(
							(sintomasRespiraTos = 1 OR sintomasRespiraDificultadRespirar = 1)
							AND
							(
								--sintomasRespiraNinioEstridor = 1 --No existe esta variable en Puesto, habilitarla cuando exista
								hipoxemia = 1
								--Or ninioCianosisObs = 1--No existe esta variable en Puesto, habilitarla cuando exista
								OR ninioBeberMamar = 2
								OR ninioVomitaTodo = 1
								OR ninioTuvoConvulsiones = 1
								--Or ninioTuvoConvulsionesObs = 1 --No existe esta variable en Puesto, habilitarla cuando exista
								--Or ninioTieneLetargiaObs = 1 --No existe esta variable en Puesto, habilitarla cuando exista
								--Or ninioDesmayoObs = 1 --No existe esta variable en Puesto, habilitarla cuando exista
								--Or ninioCabeceoObs = 1 --No existe esta variable en Puesto, habilitarla cuando exista
								--Or ninioMovimientoObs = 2 --No existe esta variable en Puesto, habilitarla cuando exista
								--Or ninioMovimientoObs = 3 --No existe esta variable en Puesto, habilitarla cuando exista
							)
						)
					)
				THEN 1

				WHEN ((edadAnios = 0 AND edadMeses >= 2) OR (edadAnios > 0 AND edadAnios < 5))
					AND
					(sintomasRespiraTos = 1 OR sintomasRespiraDificultadRespirar = 1)
					AND
					(
						--sintomasRespiraTaquipnea = 1 --No existe esta variable en Puesto, habilitarla cuando exista
						sintomasRespiraNinioCostillasHundidas = 1
						--Or sintomasRespiraNinioEstridor = 1 --No existe esta variable en Puesto, habilitarla cuando exista
						OR hipoxemia = 1
						--Or ninioCianosisObs = 1 --No existe esta variable en Puesto, habilitarla cuando exista
						OR ninioBeberMamar = 2
						OR ninioVomitaTodo = 1
						OR ninioTuvoConvulsiones = 1
						--Or ninioTuvoConvulsionesObs = 1 --No existe esta variable en Puesto, habilitarla cuando exista
						--Or ninioTieneLetargiaObs = 1 --No existe esta variable en Puesto, habilitarla cuando exista
						--Or ninioDesmayoObs = 1 --No existe esta variable en Puesto, habilitarla cuando exista
						--Or ninioCabeceoObs = 1 --No existe esta variable en Puesto, habilitarla cuando exista
					)
				THEN 1
				
				ELSE 2
			END

/***********************************************************************************************/
/*Date*/
		, [Subject].[fechaHoraAdmision] 					AS [fechaHoraAdmision]	
		, [Subject].[epiWeekAdmision] 						AS [epiWeekAdmision]	
		, [Subject].[epiYearAdmision] 						AS [epiYearAdmision]		
/********************************************************************************/
/*Consent*/		
		, [Subject].[consentimientoVerbal] 					AS [consentimientoVerbal]
		, [Subject].[consentimientoEscrito] 				AS [consentimientoEscrito]
		, [Subject].[asentimientoEscrito] 					AS [asentimientoEscrito]
/********************************************************************************/
/*Site location*/

		, [Subject].[SubjectSiteID]							AS [SubjectSiteID]		
		, Sitios.[NombreShortName]							AS [SiteName]	
		, SiteType =			Sitios.TipoSitio
		, SiteDepartamento =	Sitios.DeptoShortName
		, NombreDepto.Text		AS NombreDepartamento
		, NombreMuni.Text		AS NombreMunicipio 

/***********************************************************************************************/
/*Patient Location*/
		, [Subject].[departamento]							AS [departamento]
		, [Subject].[municipio]								AS [municipio]
		, [Subject].[comunidad]								AS [comunidad]
		, NULL												AS [censo_codigo]
		, NULL												AS [censo_comunidad]
		, catchment =
			CASE	
				WHEN
						([Subject].departamento = 6 
							AND (SubjectSiteID = 1 OR SubjectSiteID = 2 
								OR SubjectSiteID = 3 OR SubjectSiteID = 4 
								OR SubjectSiteID = 5 OR SubjectSiteID = 6 
								OR SubjectSiteID = 7  )
							AND	(	   [Subject].municipio = 601 
									OR [Subject].municipio = 602 
									OR [Subject].municipio = 603 
									OR [Subject].municipio = 604 
									OR [Subject].municipio = 605 
									OR [Subject].municipio = 606 
									OR [Subject].municipio = 607 
									OR [Subject].municipio = 610 
									OR [Subject].municipio = 612 
									OR [Subject].municipio = 613 
									OR [Subject].municipio = 614)
						)	
						OR
						([Subject].departamento = 9 
							AND 
								(SubjectSiteID = 9 OR SubjectSiteID = 12 
								OR SubjectSiteID = 13 OR SubjectSiteID = 14 
								OR SubjectSiteID = 15 )
							AND (	  [Subject]. municipio = 901 
									OR [Subject].municipio = 902 
									OR [Subject].municipio = 903 
									OR [Subject].municipio = 909 
									OR [Subject].municipio = 910 
									OR [Subject].municipio = 911 
									OR [Subject].municipio = 913 
									OR [Subject].municipio = 914 
									OR [Subject].municipio = 916 
									OR [Subject].municipio = 923)
						)		
						OR
						([Subject].departamento = 1 
							AND SubjectSiteID = 11 
						)					
					THEN 1
				ELSE 2
			END
/***********************************************************************************************/
	/*Demographic*/
		, [Subject].[sexo]									AS [sexo]
		, [Subject].[edadAnios]								AS [edadAnios]
		, [Subject].[edadMeses] 							AS [edadMeses]
		, [Subject].[edadDias] 								AS [edadDias]
	  --, [Subject].[fechaDeNacimiento]						AS [fechaDeNacimiento] -- cambio de formato de fecha
		, CONVERT (DATE,[Subject].[fechaDeNacimiento],113) 	AS [fechaDeNacimiento]	  
		, [p2_Informe_del_Caso_F].[pacienteGrupoEtnico]		AS [pacienteGrupoEtnico]		

/***********************************************************************************************/	
		/*DEATH INFO*/
		,muerteViCo = 
			CASE	
				WHEN	egresoTipo  = 4 OR seguimientoPacienteCondicion = 3
					THEN 1
				ELSE 2
			END
		,muerteViCoFecha = 
			CASE 
				WHEN egresoTipo  = 4 
					THEN [Subject].PDAInsertDate
				WHEN seguimientoPacienteCondicion = 3
					THEN seguimientoPacienteMuerteFecha
				ELSE NULL 
				END
		,muerteSospechoso = /*C0, h2cv, h2ce*/
			CASE	
				WHEN	ConsentimientoVerbalNoRazonMurio = 1 OR  ConsentimientoEscritoMurio = 1
					THEN 1
				ELSE 2
			END
		,muerteSospechosoFecha = 
			CASE 
				WHEN ConsentimientoVerbalNoRazonMurio = 1 OR ConsentimientoEscritoMurio = 1
					THEN  [Subject].PDAInsertDate
				ELSE NULL 
				END
		,NULL												AS muerteHospital				
		,muerteCualPaso = 
						/*
						1 = tamizaje/consent 
						2 = duranteEntrevista (inscrito, but NOT everything IS done HCP11 filled out probably)
						3 = antes de egreso (H7)
						4 = seguimiento (hcp9)
						*/
			CASE	
				WHEN ConsentimientoVerbalNoRazonMurio = 1 OR  ConsentimientoEscritoMurio = 1 
					THEN 1
				WHEN terminoManeraCorrectaNoRazon = 3
					THEN 2
				WHEN egresoTipo  = 4
					THEN 3
				WHEN seguimientoPacienteCondicion = 3
					THEN 4
				ELSE NULL 
			END					
		,NULL												AS moribundoViCo /*C7?*/ 				
		,NULL												AS moribundoViCoFecha  /*C7?*/
		,NULL												AS moribundoSospechoso /**/
		,NULL												AS moribundoSospechosoFecha  /**/
		
/********************************************************************************/
/*H1/C1/P1*/		
		
		, NULL  											AS [salaIngreso]
		
		, NULL												AS [presentaIndicacionRespira]
		, NULL							 					AS [indicacionRespira]
		, NULL  											AS [indicacionRespira_otra]
			
		
		, NULL							 					AS [presentaIndicacionDiarrea]
		, NULL							 					AS [indicacionDiarrea]
		, NULL							 					AS [indicacionDiarrea_otra]
		
		, NULL							 					AS [presentaIndicacionNeuro]
		, NULL							 					AS [indicacionNeuro]
		, NULL							 					AS [indicacionNeuro_otra]
		
		, NULL							 					AS [presentaIndicacionFebril]
		, NULL							 					AS [indicacionFebril]
		, NULL							 					AS [indicacionFebril_otra]
		
		, NULL							 					AS [actualAdmitido]
		
		
/*H2REM/C1C/P1C*/

		, NULL												AS [medirTemperaturaCPrimeras24Horas]
		, [Subject].[temperaturaPrimeras24Horas]			AS [temperaturaPrimeras24Horas]
		, [Subject].[sintomasRespiraFiebre]					AS [sintomasRespiraFiebre]
		, [Subject].[sintomasRespiraHipotermia]				AS [sintomasRespiraHipotermia]
		, [Subject].[sintomasFiebre]						AS [sintomasFiebre]
		, [Subject].[sintomasFiebreDias]					AS [sintomasFiebreDias]
		, [Subject].[fiebreOHistoriaFiebre]					AS [fiebreOHistoriaFiebre]
		,NULL 		AS sintomasFiebreFechaInicio
		, NULL 		AS sintomasFiebreTemperatura
		, NULL												AS [tieneResultadoHematologia]
		, NULL												AS [conteoGlobulosBlancos]
		, NULL												AS [diferencialAnormal]
		, NULL												AS [sintomasRespiraCGB]
		
		, NULL												AS [resultadoAnormalExamenPulmones]
		
		, NULL												AS [medidaRespiraPorMinutoPrimeras24Horas]
		, NULL												AS [respiraPorMinutoPrimaras24Horas]
		, NULL												AS [sintomasRespiraTaquipnea]
		
		, NULL												AS [puncionLumbar]
		, NULL												AS [LCRconteoGlobulosBlancos]
		, NULL												AS [LCRFecha]
						
		, [P1_Inscripción_C].[ninioVomitaTodo]				AS [ninioVomitaTodo]
		, [P1_Inscripción_C].[ninioBeberMamar]				AS [ninioBeberMamar]
		, [P1_Inscripción_C].[ninioTuvoConvulsiones]		AS [ninioTuvoConvulsiones]
		, NULL												AS [ninioTuvoConvulsionesObs]
		, [P1_Inscripción_C].[ninioTieneLetargia]			AS [ninioTieneLetargia]
		, NULL												AS [historiaApnea]
		, NULL												AS [historiaCianosis]
		, NULL												AS [historiaVomitoPostusivo]
		, NULL												AS [HistoriaParoxismos]
		, NULL												AS [HistoriaWhoop]
/*H2DRF/C1C/P1C*/		
	
		, [Subject].[diarreaUltimos7Dias]					AS [diarreaUltimos7Dias]
		, [P1_Inscripción_C].sintomasRespiraTamizajeCentro	AS [sintomasRespiraTamizaje]
		, [Subject].[sintomasRespiraTos]					AS [sintomasRespiraTos]
		, CASE WHEN [P2_Informe_del_Caso_D].[sintomasRespiraTosDias] IS NULL THEN [P1_Inscripción_C].[sintomasRespiraTosDias]
																			 ELSE [P2_Informe_del_Caso_D].[sintomasRespiraTosDias]
		  END AS [sintomasRespiraTosDias]
		, [P1_Inscripción_C].[sintomasRespiraTos14Dias]		AS [sintomasRespiraTos14Dias]
		, [P1_Inscripción_C].[pertussisVomito]				AS [pertussisVomito]
		, [P1_Inscripción_C].[pertussisParoxismos]			AS [pertussisParoxismos]
		, [P1_Inscripción_C].[pertussisWhoop]				AS [pertussisWhoop]
		, [Subject].[sintomasRespiraDificultadRespirar]		AS [sintomasRespiraDificultadRespirar]
		, [P2_Informe_del_Caso_D].[sintomasRespiraDificultadDias]			AS [sintomasRespiraDificultadDias]
		, [Subject].[sintomasRespiraEsputo]					AS [sintomasRespiraEsputo]
		, [Subject].[sintomasRespiraHemoptisis]				AS [sintomasRespiraHemoptisis]
		, [Subject].[sintomasRespiraDolorGarganta]			AS [sintomasRespiraDolorGarganta]
		, [P2_Informe_del_Caso_D].[sintomasRespiraGargantaDias]				AS [sintomasRespiraGargantaDias]
		, [P1_Inscripción_C].[sintomasRespiraGarganta14Dias]				AS [sintomasRespiraGarganta14Dias]
		, [Subject].[sintomasRespiraFaltaAire]				AS [sintomasRespiraFaltaAire]
		, [Subject].[sintomasRespiraDolorPechoRespirar]		AS [sintomasRespiraDolorPechoRespirar]
		, [Subject].[sintomasRespiraNinioPausaRepedimente]	AS [sintomasRespiraNinioPausaRepedimente]
		, [Subject].[sintomasRespiraNinioCostillasHundidas] AS [sintomasRespiraNinioCostillasHundidas]
		, [Subject].[sintomasRespiraNinioAleteoNasal]		AS [sintomasRespiraNinioAleteoNasal]
		, [Subject].[sintomasRespiraNinioRuidosPecho]		AS [sintomasRespiraNinioRuidosPecho]
		, [Subject].[sintomasRespira]						AS [sintomasRespira]

		, [P1_Inscripción_C].[medirOximetroPulso]			AS [medirOximetroPulso]
		, [P1_Inscripción_C].[oximetroPulso]				AS [oximetroPulso]
		, 0													AS oximetroPulso_Lag
		, oximetroPulso										AS oxiAmb
		
		/*oximetroPulsoFechaHoraToma_Esti*/
		, oximetroPulsoFechaHoraToma_Esti = [P1_Inscripción_C].PDAInsertDate
		
		, NULL												AS [enfermedadEmpezoHaceDias]
		, [Subject].[hipoxemia]								AS [hipoxemia]
			
/* H2F/C1F */		
		,  NULL												AS [fiebreRazon]
		,  NULL												AS [fiebreOtraRazon_esp]
		,  NULL												AS [lesionAbiertaInfectada]
		,  NULL												AS [otitisMedia]
		
	
/*H5/C5/P5*/		
		, [P5_Muestras_V].[muestraHecesHisopoSecoColecta]	AS [muestraHecesHisopoSecoColecta]
		, [P5_Muestras_V].[muestraFroteNP]					AS [muestraFroteNP]
		, NULL AS muestraLCRColecta
		, [P5_Muestras_V].[muestraFroteNPFechaHora]			AS [muestraFroteNPFechaHora]
		, NULL												AS [muestraOrinaColecta]
		, NULL 												AS [muestraOrinaFechaHora]
		, NULL 												AS [muestraOrinaNumeroML]
		, NULL 												AS [radiografiaPechoColecta]
		, NULL 												AS [radiografiaPechoNumero]

					/*Hemocultivos*/	
		,NULL												AS [muestraSangreCultivoColecta]
		,NULL												AS [HemoFechaTomaMuestra]
		,NULL												AS [MuestraSangreCultivoNumeroKit1]
		,NULL											    AS [MuestraSangreCultivoRegistro1]
		,NULL												AS [MuestraSangreCultivoNumeroKit2]
		,NULL												AS [MuestraSangreCultivoRegistro2]
		,NULL												AS HemoCrecimiento
		
		,NULL												AS [Aero1Resultado]
		,NULL												AS [Aero1StreptococcusPneumoniae]
		,NULL												AS [Aero1StreptococcusOtro]
		,NULL												AS [Aero1Otro]
		,NULL												AS [Aero1Contaminado]
		
		,NULL												AS [Aero2Resultado]
		,NULL												AS [Aero2StreptococcusPneumoniae]
		,NULL												AS [Aero2StreptococcusOtro]
		,NULL												AS [Aero2Otro]
		,NULL												AS [Aero2Contaminado]
	
/*H3D/C2D/P2D*/
		, [P2_Informe_del_Caso_D].[respiraEmpezoHaceDias]	AS [respiraEmpezoHaceDias]
		, [P2_Informe_del_Caso_D].[sintomasEnfermRespiraEscalofrios]		AS [sintomasEnfermRespiraEscalofrios]
		, [P2_Informe_del_Caso_D].[hxR_GoteaNariz]			AS [hxR_GoteaNariz]
		, [P2_Informe_del_Caso_D].[hxR_Estornudos]			AS [hxR_Estornudos]
		, [P2_Informe_del_Caso_D].[sintomasEnfermRespiraHervorPecho]		AS [sintomasEnfermRespiraHervorPecho]
		, [P2_Informe_del_Caso_D].[sintomasEnfermRespiraDolorCabeza]		AS [sintomasEnfermRespiraDolorCabeza]
		, [P2_Informe_del_Caso_D].[sintomasEnfermRespiraDolorMuscular]		AS [sintomasEnfermRespiraDolorMuscular]
		, 2 AS dxNeumonia30DiasAnt
		, 2 AS hosp14DiasAnt

	
/*H3B/C2B/P2B*/
		, [P2_Informe_del_Caso_B].[buscoTratamientoAntes]	AS [buscoTratamientoAntes]
		, [P2_Informe_del_Caso_B].[otroTratamiento1erTipoEstablecimiento]	AS [otroTratamiento1erTipoEstablecimiento]
		, [P2_Informe_del_Caso_B].[otroTratamiento1erRecibioMedicamento]	AS [otroTratamiento1erRecibioMedicamento]
		, [P2_Informe_del_Caso_B].[otroTratamiento1erAntibioticos]			AS [otroTratamiento1erAntibioticos]
		, [P2_Informe_del_Caso_B].[buscoTratamientoAntes2doLugar]			AS [buscoTratamientoAntes2doLugar]
		, [P2_Informe_del_Caso_B].[otroTratamiento2doTipoEstablecimiento]	AS [otroTratamiento2doTipoEstablecimiento]
		, [P2_Informe_del_Caso_B].[otroTratamiento2doRecibioMedicamento]	AS [otroTratamiento2doRecibioMedicamento]
		, [P2_Informe_del_Caso_B].[otroTratamiento2doAntibioticos]			AS [otroTratamiento2doAntibioticos]
		, NULL												AS [buscoTratamientoAntes3erLugar]
		, NULL												AS [otroTratamiento3erTipoEstablecimiento]
		, NULL												AS [otroTratamiento3erRecibioMedicamento]
		, NULL												AS [otroTratamiento3erAntibioticos]
		, [P2_Informe_del_Caso_B].[tomadoMedicamentoUltimas72hora]			AS [tomadoMedicamentoUltimas72hora]
		, [P2_Informe_del_Caso_B].[medUltimas72HorasAntiB]	AS [medUltimas72HorasAntiB]
		, NULL	AS [medUltimas72HorasAntiBCual]
		, [P2_Informe_del_Caso_B].[medUltimas72HorasAntipireticos]	AS [medUltimas72HorasAntipireticos]
		, [P2_Informe_del_Caso_B].[medicamentosUltimas72HorasEsteroides]	AS [medicamentosUltimas72HorasEsteroides]
		, [P2_Informe_del_Caso_B].[medUltimas72HorasAntivirales]	AS [medUltimas72HorasAntivirales]
		, [P2_Informe_del_Caso_B].[otroTratamiento1erZinc]					AS [otroTratamiento1erZinc]
		, [P2_Informe_del_Caso_B].[otroTratamiento1erZincDias]				AS [otroTratamiento1erZincDias]
		, [P2_Informe_del_Caso_B].[otroTratamiento2doZinc]					AS [otroTratamiento2doZinc]
		, [P2_Informe_del_Caso_B].[otroTratamiento2doZincDias]				AS [otroTratamiento2doZincDias]
		, NULL																AS [otroTratamiento3erZinc]
		, NULL																AS [otroTratamiento3erZincDias]
		, [P2_Informe_del_Caso_B].[medUltimas72HorasZinc]			AS [medUltimas72HorasZinc]
			
/*H3A/C2A/P2A*/
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasAlguna]				AS [enfermedadesCronicasAlguna]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasAsma]				AS [enfermedadesCronicasAsma]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasDiabetes]			AS [enfermedadesCronicasDiabetes]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasCancer]				AS [enfermedadesCronicasCancer]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasEnfermCorazon]		AS [enfermedadesCronicasEnfermCorazon]
		, NULL																AS [enfermedadesCronicasDerrame]		
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasEnfermHigado]		AS [enfermedadesCronicasEnfermHigado]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasEnfermRinion]		AS [enfermedadesCronicasEnfermRinion]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasEnfermPulmones]		AS [enfermedadesCronicasEnfermPulmones]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasVIHSIDA]				AS [enfermedadesCronicasVIHSIDA]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasHipertension]		AS [enfermedadesCronicasHipertension]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasOtras]				AS [enfermedadesCronicasOtras]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasNacimientoPrematuro] AS [enfermedadesCronicasNacimientoPrematuro]
		, [P2_Informe_del_Caso_A].[enfermedadesCronicasInfoAdicional] 
		, [P2_Informe_del_Caso_A].[tieneFichaVacunacion]					AS [tieneFichaVacunacion]
		, [P2_Informe_del_Caso_A].[vacunaPentavalenteRecibido]				AS [vacunaPentavalenteRecibido]
		, [P2_Informe_del_Caso_A].[vacunaPentavalenteDosis]	AS [vacunaPentavalenteDosis]
		, [P2_Informe_del_Caso_A].[vacunaTripleSarampionRecibido]			AS [vacunaTripleSarampionRecibido]
		, [P2_Informe_del_Caso_A].[vacunaTripleSarampionDosis]				AS [vacunaTripleSarampionDosis]
		, [P2_Informe_del_Caso_A].[vacunaSarampionPaperasRubella]			AS [vacunaSarampionPaperasRubella]
		, [P2_Informe_del_Caso_A].[vacunaInfluenzaSeisMeses]				AS [vacunaInfluenzaSeisMeses]
		, [P2_Informe_del_Caso_A].[vacunaRotavirusRecibido]					AS [vacunaRotavirusRecibido]
		, [P2_Informe_del_Caso_A].[vacunaRotavirusDosis]
		, NULL																AS [vacunaNeumococoPrevenar]
		, NULL																AS [vacunaNeumococoSynflorix]
		, NULL																AS [vacunaNeumococoDosis]
		, NULL																AS [vacunaNeumococo]
		, NULL																AS [vacunaNeumococoDosis]
		, [P2_Informe_del_Caso_A].[embarazada]				AS [embarazada]
		, [P2_Informe_del_Caso_A].[embarazadaMeses]			AS [embarazadaMeses]	
		
			
			
/*H3F/C2F/P2F*/	
		, [P2_Informe_del_Caso_F].[parentescoGradoEscolarCompleto]			AS [parentescoGradoEscolarCompleto]
		, [P2_Informe_del_Caso_F].[patienteGradoEscolarCompleto]			AS [patienteGradoEscolarCompleto]
		, [P2_Informe_del_Caso_F].[pacienteFuma]			AS [pacienteFuma]
		, [P2_Informe_del_Caso_F].[casaAlguienFuma]			AS [casaAlguienFuma]
		, [P2_Informe_del_Caso_F].[casaNiniosGuareriaInfantil]				AS [casaNiniosGuareriaInfantil]	
		, [P2_Informe_del_Caso_F].[pacientePecho2Anios]		AS [pacientePecho2Anios]
		, [P2_Informe_del_Caso_F].[casaCuantosDormitorios]	AS [casaCuantosDormitorios]
		, [P2_Informe_del_Caso_F].casaCuantasPersonasViven	AS [casaCuantasPersonasViven]
		, [P2_Informe_del_Caso_F].[casaMaterialTecho]		AS [casaMaterialTecho]
		, [P2_Informe_del_Caso_F].[casaMaterialPiso]		AS [casaMaterialPiso]
		, [P2_Informe_del_Caso_F].[casaEnergiaElectrica]	AS [casaEnergiaElectrica]
		, [P2_Informe_del_Caso_F].[casaRefrigeradora]		AS [casaRefrigeradora]
		, [P2_Informe_del_Caso_F].[casaComputadora]			AS [casaComputadora]
		, [P2_Informe_del_Caso_F].[casaRadio]				AS [casaRadio]
		, [P2_Informe_del_Caso_F].[casaLavadora]			AS [casaLavadora]
		, [P2_Informe_del_Caso_F].[casaCarroCamion]			AS [casaCarroCamion]
		, [P2_Informe_del_Caso_F].[casaTelevision]			AS [casaTelevision]
		, [P2_Informe_del_Caso_F].[casaSecadora]			AS [casaSecadora]
		, [P2_Informe_del_Caso_F].[casaTelefono]			AS [casaTelefono]
		, [P2_Informe_del_Caso_F].[casaMicroondas]			AS [casaMicroondas]
		, [P2_Informe_del_Caso_F].familiaIngresosMensuales	AS [familiaIngresosMensuales]
		, [P2_Informe_del_Caso_F].casacuantasbombillas
		, [P2_Informe_del_Caso_F].fuentesAguaChorroDentroCasaRedPublica
		, [P2_Informe_del_Caso_F].fuentesAguaChorroPatioCompartidoOtraFuente
		, [P2_Informe_del_Caso_F].fuentesAguaChorroPublico
		, [P2_Informe_del_Caso_F].fuentesAguaCompranAguaEmbotellada
		, [P2_Informe_del_Caso_F].fuentesAguaDeCamionCisterna
		, [P2_Informe_del_Caso_F].fuentesAguaLavaderosPublicos
		, [P2_Informe_del_Caso_F].fuentesAguaLluvia
		, [P2_Informe_del_Caso_F].fuentesAguaPozoPropio
		, [P2_Informe_del_Caso_F].fuentesAguaPozoPublico
		, [P2_Informe_del_Caso_F].fuentesAguaRioLago
				
/*H3H/C2H/P2H*/
		, NULL												AS [respiraExamenFisicoMedicoFecha]
		, NULL												AS [respiraExamenFisicoMedicoSibilancias]
		, NULL 												AS [respiraExamenFisicoMedicoEstertoresGruesos]
		, NULL 												AS [respiraExamenFisicoMedicoEstertoresFinos]
		, NULL 												AS [respiraExamenFisicoMedicoRoncus]
		, NULL 												AS [respiraExamenFisicoMedicoAdenopatia]
		, NULL 												AS [respiraExamenFisicoMedicoTirajePecho]
		, NULL 												AS [respiraExamenFisicoMedicoEstridor]
		, NULL 												AS [respiraExamenFisicoMedicoRespiraRuidoso]
		, NULL 												AS [respiraExamenFisicoMedicoMolleraHinchada]
		, NULL 												AS [respiraExamenFisicoMedicoAleteoNasal]
		, NULL 												AS [respiraExamenFisicoMedicoMusculosRespirar]
		, NULL 												AS [respiraExamenFisicoMedicoPuntuacionDownes]
			
					
/*H3J/C2J/P2J*/
		, [P2_Informe_del_Caso_J].[pacienteTallaCM1]		AS [pacienteTallaCM1]
		, [P2_Informe_del_Caso_J].[pacienteTallaCM2]		AS [pacienteTallaCM2]
		, [P2_Informe_del_Caso_J].[pacienteTallaCM2]		AS [pacienteTallaCM3]
		, [P2_Informe_del_Caso_J].[pacientePesoLibras1]		AS [pacientePesoLibras1]
		, [P2_Informe_del_Caso_J].[pacientePesoLibras2]		AS [pacientePesoLibras2]
		, [P2_Informe_del_Caso_J].[pacientePesoLibras2]		AS [pacientePesoLibras3]
					
/*HR6*/
		, NULL												AS [radiografiaPechoPlacaEncontro]
		, NULL												AS [radiografiaPechoPlacaFecha]
		, NULL												AS [radiografiaPechoResultadoNeumonia]
		, NULL												AS [radiografiaPechoResultadoNeumoniaPatron]
		, NULL												AS [radiografiaPechoResultadoEfusionPleural]
		, NULL												AS [radiografiaPechoResultadoHyperareacion]
		, NULL												AS [radiografiaPechoResultadoAtelectasis]
		, NULL												AS [radiografiaPechoResultadoCavidadAbsceso]
		, NULL												AS [radiografiaPechoResultadoComentario]
		, NULL												AS [radiografiaPechoResultadoComentario_esp]
		, NULL												AS [radiografiaPechoFotoDigitalTomo]
		, NULL												AS [radiografiaPechoFotoDigitalNumero]

--/*H7/C7/P7*/
		, [P7_Egreso_].[PDAInsertDate]						AS [fechaInforme]
		, [P7_Egreso_].[PDAInsertDate]						AS [egresoMuerteFecha]
		, [P7_Egreso_].egresoTipo							AS [egresoTipo]
		, NULL												AS [egresoCondicion]
		, NULL												AS [ventilacionMecanicaDias]
		, NULL												AS [cuidadoIntensivoDias]
		, NULL												AS [temperaturaPrimeras24HorasAlta]
		, [P7_Egreso_].[egresoDiagnostico1]					AS [egresoDiagnostico1]
		, [P7_Egreso_].[egresoDiagnostico2_esp]			AS [egresoDiagnostico1_esp]
		, [P7_Egreso_].[egresoDiagnostico2]					AS [egresoDiagnostico2]
		, [P7_Egreso_].[egresoDiagnostico2_esp]			AS [egresoDiagnostico2_esp]
		, [P7_Egreso_].[zincTratamiento]					AS [zincTratamiento]
		----, H7QRecibioAcyclovir
		----, H7Q0210
		----, H7Q0211
		----, H7Q0212
		----, H7Q0213
		----, H7Q0214
		----, H7Q0215
		----, H7Q0216
		----, H7Q0217
		----, H7Q0218
		----, H7QRecibioCefadroxil
		----, H7Q0219
		----, H7QRecibioCefepime
		----, H7Q0220
		----, H7Q0221
		----, H7Q0222
		----, H7Q0223
		----, H7Q0225
		----, H7Q0226
		----, H7QRecibioEritromicina
		----, H7Q0227
		----, H7QRecibioImipenem
		----, H7Q0229
		----, H7Q0231
		----, H7Q0232
		----, H7Q0233
		----, H7Q0234
		----, H7Q0235
		----, H7QRecibioOxacilina
		----, H7QRecibioPerfloxacinia
		----, H7Q0236
		----, H7Q0237
		
				
/* HCP9 */
		, [HCP9_Seguimiento_].[seguimientoFechaReporte]						AS [seguimientoFechaReporte]
		, [HCP9_Seguimiento_].[seguimientoObtuvoInformacion]				AS [seguimientoObtuvoInformacion]
		, [HCP9_Seguimiento_].[seguimientoTipoContacto] 					AS [seguimientoTipoContacto]
		, [HCP9_Seguimiento_].[seguimientoPacienteCondicion] 				AS [seguimientoPacienteCondicion]
		, [HCP9_Seguimiento_].[seguimientoPacienteMuerteFecha] 				AS [seguimientoPacienteMuerteFecha]
		, [HCP9_Seguimiento_].[seguimientoMuestraSangreColecta] 			AS [seguimientoMuestraSangreColecta]
		, [HCP9_Seguimiento_].[seguimientoMuestraSangreML] 					AS [seguimientoMuestraSangreML]
	
	/*HCP 9 - ZINC*/
		, [HCP9_Seguimiento_].[seguimientoZinc]								AS [seguimientoZinc]		
		, [HCP9_Seguimiento_].[seguimientoZincTabletas]						AS [seguimientoZincTabletas]			
		, [HCP9_Seguimiento_].[seguimientoZincTabletasQuedan]				AS [seguimientoZincTabletasQuedan]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasTomo]					AS [seguimientoZincTabletasTomo]		
		, [HCP9_Seguimiento_].[seguimientoZincTabletasPorDia]				AS [seguimientoZincTabletasPorDia]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasDiasTomo]				AS [seguimientoZincTabletasDiasTomo]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasNoRazon]				AS [seguimientoZincTabletasNoRazon]	
		, [HCP9_Seguimiento_].[seguimientoZincTabletasNoRazonEs]			AS [seguimientoZincTabletasNoRazonEs]
		
	
		
/*LABS*/
		, LabRespira.[viralPCR_Hizo]
		, LabRespira.[viralPCR_RSV]
		, viralPCR_Results.RSV_CT AS viralPCR_RSV_CT	
		, LabRespira.[viralPCR_hMPV]
		, viralPCR_Results.MPV_CT    AS viralPCR_hMPV_CT	
	------------------------------------------------------------------------------------------------------

		--, LabRespira.[viralPCR_hPIV1]
		--, LabRespira.[viralPCR_hPIV2]
		--, LabRespira.[viralPCR_hPIV3]
		--, LabRespira.[viralPCR_AD]
		--, LabRespira.[viralPCR_FluA]
		, LabRespira.[viralPCR_AD]		AS viralPCR_AD	
		, viralPCR_Results.[AD_CT]		AS ViralPCR_AD_CT	
		, viralPCR_FluA			AS viralPCR_FluA	
		, viralPCR_Results.[FluA_CT]		AS viralPCR_FluA_CT	
		, viralPCR_Results.[H1_Result]		AS viralPCR_FluAH1	
		, viralPCR_Results.[H1_CT]		AS viralPCR_FluAH1_CT	
		, viralPCR_Results.[H3_Result]		AS viralPCR_FluAH3	
		, viralPCR_Results.[H3_CT]		AS viralPCR_FluAH3_CT	
		, viralPCR_Results.[H5a_Result] 		AS viralPCR_FluAH5a	
		, viralPCR_Results.[H5a_CT] 		AS viralPCR_FluAH5a_CT	
		, viralPCR_Results.[H5b_Result] 		AS viralPCR_FluAH5b	
		, viralPCR_Results.[H5b_CT] 		AS viralPCR_FluAH5b_CT	
		, viralPCR_Results.[SwA_Result]		AS viralPCR_FluASwA	
		, viralPCR_Results.[SwA_CT]		AS viralPCR_FluASwA_CT	
		, viralPCR_Results.[SwH1_Result] 		AS viralPCR_FluASwH1	
		, viralPCR_Results.[SwH1_CT] 		AS viralPCR_FluASwH1_CT	
		, viralPCR_Results.[pdmH1_Result]		AS viralPCR_pdmH1	
		, viralPCR_Results.[pdmH1_CT]		 AS viralPCR_pdmH1_CT	
		, viralPCR_Results.[pdmInfA_Result]		AS viralPCR_pdmInFA	
		, viralPCR_Results.[pdmInfA_CT]		 AS viralPCR_pdmInFA_CT	
		, viralPCR_hPIV1					AS viralPCR_hPIV1	
		, viralPCR_Results.[PIV1_CT]		AS viralPCR_hPIV1_CT	
		, viralPCR_hPIV2					AS viralPCR_hPIV2	
		, viralPCR_Results.[PIV2_CT]		AS viralPCR_hPIV2_CT	
		, viralPCR_hPIV3					AS viralPCR_hPIV3
		, viralPCR_Results.[PIV3_CT]		AS viralPCR_hPIV3_CT	

		
		
		
		
		
		
-------------------------------------------------------------------------------------------------------
			
		, LabRespira.[viralPCR_FluB]
		, viralPCR_Results.[FluB_CT]		AS ViralPCR_FluB_CT	
		, LabRespira.[viralPCR_RNP]
		, viralPCR_Results.[RNP_CT]		AS ViralPCR_RNP_CT	
		, LabRespira.[bacterialPCR_Hizo]
		, LabRespira.[bacterialPCR_CP]
		, LabRespira.[bacterialPCR_LP]
		, LabRespira.[bacterialPCR_LL]
		, LabRespira.[bacterialPCR_MP]
		, LabRespira.[bacterialPCR_Lsp]
		, LabRespira.[bacterialPCR_SP]
		--, LabRespira.[bacterialBinax_Hizo]
		, LabRespira.[bacterialBinax_Lsp]
		--, LabRespira.[bacterialBinax_Sp]
		, Binax.Recibio_Muestra_LAB AS Binax_RecibioMuestra
		, Binax.Resultado AS Binax_Resultado
		, Binax.Se_Hizo_Binax AS Binax_HizoPrueba
		--, LabRespira.[ViralCT1]
		--, LabRespira.[ViralCT11]
		--, LabRespira.[ViralCT111]
		--, LabRespira.[ViralCT2]
		--, LabRespira.[ViralCT22]
		--, LabRespira.[ViralCT222]
		--, LabRespira.[ViralCT3]
		--, LabRespira.[ViralCT33]
		--, LabRespira.[ViralCT333]
		, LabRespira.[ResultadosLN]
		, LabRespira.[observaciones] 						AS observaciones_LabRespira
		, LabRespira.[evaluado]
		
		,pertussis_sosp = 
			CASE
			WHEN Sitios.TipoSitio IN ('CS', 'PS') --SiteType 
			and (
				-- criterios 0 a 11 años
				(
					[P1_Inscripción_C].sintomasRespiraTosDias >= 7 and edadAnios between 0 and 11 and ((pertussisParoxismos=1 or pertussisVomito=1 or pertussisWhoop=1 or sintomasRespiraTos14Dias = 1))
				) or
				-- criterios 11 o más años
				([P1_Inscripción_C].sintomasRespiraTosDias > 14  and edadAnios > 11)
				) THEN 1
			ELSE 0
		END
		/*- Variables de Pertussis corridos en laboratorio*/
		, NULL		SeHizoPCR_Pertussis
		, NULL		FechaPCRBordetella
		, NULL		Bordetella_spp_PCR
		, NULL		B_Pertussis_PCR
		, NULL		B_Parapertussis_PCR
		, NULL		ct_IS481
		, NULL		ct_PTXS1
		/*------------------------------------------------*/

		,NULL AS condicionEgreso
		,NULL AS ninioCianosisObs
		,NULL AS ninioCabeceoObs
		,NULL AS ninioDesmayoObs
		,NULL AS ninioMovimientoObs
		,[Subject].elegibleIRAG
		,[Subject].fechaTerminacionProyecto
		,NULL AS gotaGruesa
		,[P2_Informe_del_Caso_D].hxR_Quejido
		,[Subject].respiraPorMinuto AS medidaRespiraPorMinuto		
		,NULL AS medirOximetroPulsoSinOxi
		,NULL AS muestraFroteOPColecta
		,NULL AS muestraFroteOPFechaHora
		,NULL AS oxigenoSuplementario
		,NULL AS oxigenoSuplementarioCuanto		
		,[P1_Inscripción_C].oximetroPulsoNoRazon
		,[P1_Inscripción_C].oximetroPulsoNoRazon_esp	
		,NULL AS oximetroPulsoSinOxiNoRazon
		,NULL AS oximetroPulsoSinOxiNoRazon_esp		
		,NULL AS presionPrimeras24HorasDiastolica
		,NULL AS presionPrimeras24HorasSistolic	
		,NULL AS pulso
		,NULL AS respiraExamenFisicoMedicoCompleto		
		,NULL AS seguimientoAdmitidoHospital
		,NULL AS seguimientoObtuvoInformacionNoRazon		
		,NULL AS seguimientoPacienteCondicionManera		
		,NULL AS sintomasRespiraNinioEstridor
		,NULL AS ventilacionMecanica		
		,NULL AS ventilacionMecanicaCuanto		
		,NULL AS respiraPorMinuto
		,HCP11.terminoManeraCorrectaNoRazon	
		,NULL AS OximetroPulsoSinOxi
, NULL AS H7QSangreHemocultivoTomo
, NULL AS h1FechaEgreso
/***********************************************************************************************/
/*PDAInsertInfo */
		, [Subject].PDAInsertDate							AS PDAInsertDate
		, [Subject].PDAInsertVersion						AS PDAInsertVersion
		, [Subject].PDAInsertUser							AS PDAInsertUser
/***********************************************************************************************/
		--VARIABLES DE HEMOCULTIVOS LAB
		,NULL												AS HemoLabCrecimiento
		,NULL												AS HemoLabContaminante
		,NULL												AS HemoLabPatogenoRespiratorio
		,NULL												AS HemoLabStrept_pneumoniae
		,NULL												AS HemoLabStrept_sp
		,NULL												AS HemoLabStaphy_aureus
		,NULL												AS HemoLabPseudomonas_aeruginosa	

/*******************************VARIABLES RAYOSX***************************************/
		,NULL AS [agrcncl_cd]
		,NULL AS [agrcncl_dl]
		,NULL AS [agrcncl5_cd]
		,NULL AS [agrcncl5_dl]
		,NULL AS [agrcncl_brd_cd]
		,NULL AS [agrcncl_brd_dl]
		,NULL AS [agrepp_cd]
		,NULL AS [agrepp_dl]
		,NULL AS [agrepp_brd_cd]
		,NULL AS [agrepp_brd_dl]
		,NULL AS [agrqual_cd]
		,NULL AS [agrqual_dl]
		,NULL AS [cncl5]
		,NULL AS [epp]
		,NULL AS [cncl_brd]
		,NULL AS [epp_brd]
		,NULL AS [hilar_any]
		,NULL AS [plfl_any]
		,NULL AS [hyper_any]
		/*JD[2015-05-11] DEFINICION DE elegibleRespira para la definicion 11.0.0.0 y la 9.1.0.0  --------------------------*/
		,CASE WHEN (
						(
							[Subject].municipio=614
						 OR [Subject].municipio=911
						 OR [Subject].municipio= 914
						 OR	[Subject].municipio= 923
						)
						AND (
								temperaturaPrimeras24Horas>38
							)
						AND (
								sintomasRespiraTos14Dias=1
							 OR sintomasRespiraGarganta14Dias=1
							)
					  )
					  THEN 1
					  ELSE 2
				END AS elegibleRespiraV9_1
	   ,CASE WHEN (
				(
					[Subject].municipio=614
				 OR [Subject].municipio=911
				 OR [Subject].municipio= 914
				 OR	[Subject].municipio= 923
				)
				AND (
						temperaturaPrimeras24Horas>38
				    )
				AND (
						sintomasRespiraTos14Dias=1
					 OR sintomasRespiraGarganta14Dias=1
					)
			  )
			  THEN 1
			  ELSE 2
		END AS elegibleRespiraV11
		--, [Subject].PDAInsertUser			
		, NULL	tempmax_ingr
		, NULL	tempmax_ingr_reg
		, [Subject].consentimientoGuardarMuestras
		, [viralPCR_Results].LabID
		, [Subject].PDAInsertPDAName
		, [P2_Informe_del_Caso_F].combustibleLenia
		, [P2_Informe_del_Caso_F].combustibleResiduosCosecha
		, [P2_Informe_del_Caso_F].combustibleCarbon
		, [P2_Informe_del_Caso_F].combustibleGas
		, [P2_Informe_del_Caso_F].combustibleElectricidad
		, [P2_Informe_del_Caso_F].combustibleOtro
		, NULL   murmullo
		, [P2L].hxC_Escalofrios
	FROM  [Clinicos].[Sujeto_Puesto] [Subject]
		--LEFT JOIN [Clinicos].[H1] [H1_Sospechosos_]
		--	ON [Subject].subjectid = [H1_Sospechosos_].subjectid
		--LEFT JOIN [Clinicos].[H2REM] [H2_Inscripción_REM]
		--	ON [Subject].subjectid = [H2_Inscripción_REM].subjectid
		LEFT OUTER JOIN Clinicos.P1CV P1CV
			ON [Subject].SubjectID = P1CV.SubjectID
		LEFT JOIN [Clinicos].[P1C] [P1_Inscripción_C]
			ON [Subject].subjectid = [P1_Inscripción_C].subjectid
		--LEFT JOIN [Clinicos].[H2DRF] [H2_Inscripción_DRF]
		--	ON [Subject].subjectid = [H2_Inscripción_DRF].subjectid
		--LEFT JOIN [Clinicos].[P1F] [C1_Inscripción_F]
		--	ON [Subject].subjectid = [C1_Inscripción_F].subjectid
		LEFT OUTER JOIN Clinicos.P1CE P1CE
			ON [Subject].SubjectID = P1CE.SubjectID
		LEFT JOIN [Clinicos].[P5V] [P5_Muestras_V]
			ON [Subject].subjectid = [P5_Muestras_V].subjectid
		--LEFT JOIN [Clinicos].[H5H] [H5_Muestras_H]
		--	ON [Subject].subjectid = [H5_Muestras_H].subjectid
		LEFT JOIN [Clinicos].[P2D] [P2_Informe_del_Caso_D]
			ON [Subject].subjectid = [P2_Informe_del_Caso_D].subjectid
		LEFT JOIN [Clinicos].[P2B] [P2_Informe_del_Caso_B]
			ON [Subject].subjectid = [P2_Informe_del_Caso_B].subjectid
		LEFT JOIN [Clinicos].[P2A] [P2_Informe_del_Caso_A]
			ON [Subject].subjectid = [P2_Informe_del_Caso_A].subjectid
		LEFT JOIN [Clinicos].[P2F] [P2_Informe_del_Caso_F]
			ON [Subject].subjectid = [P2_Informe_del_Caso_F].subjectid
		--LEFT JOIN [Clinicos].[C2H] [H3_Informe_del_Caso_H]
		--	ON [Subject].subjectid = [H3_Informe_del_Caso_H].subjectid
		LEFT JOIN [Clinicos].[P2J] [P2_Informe_del_Caso_J]
			ON [Subject].subjectid = [P2_Informe_del_Caso_J].subjectid
		LEFT JOIN [Clinicos].[P2L] [P2L]
			ON [Subject].subjectid = [P2L].subjectid
		--LEFT JOIN [Clinicos].[HR6] [HR6_Radiografia_]
		--	ON [Subject].subjectid = [HR6_Radiografia_].subjectid
		LEFT JOIN [Clinicos].[P7] [P7_Egreso_]
			ON [Subject].subjectid = [P7_Egreso_].subjectid
		LEFT JOIN [Clinicos].[HCP9] [HCP9_Seguimiento_]
			ON [Subject].subjectid = [HCP9_Seguimiento_].subjectid
		LEFT OUTER JOIN Clinicos.HCP11 HCP11
			ON [Subject].SubjectID = HCP11.SubjectID
		LEFT OUTER JOIN Lab.RespiratorioResultados LabRespira
				ON [Subject].SASubjectID = LabRespira.ID_Paciente
		LEFT OUTER JOIN [Lab].[VicoSubjectResults] viralPCR_Results
				ON SASubjectID = viralPCR_Results.ID_Paciente
		LEFT JOIN			[LegalValue].LV_DEPARTAMENTO  NombreDepto
				ON	departamento= NombreDepto.Value
		LEFT JOIN			[LegalValue].LV_MUNICIPIO  NombreMuni
				ON	municipio= NombreMuni.Value
			LEFT JOIN Control.Sitios  Sitios
		ON	Subject.SubjectSiteID= Sitios.SiteID		
		
		LEFT JOIN  Lab.Binax_Orina_Resultados Binax
		ON [Subject].SASubjectID = Binax.SaSubjectid
		
		
		WHERE [Subject].forDeletion = 0
--			AND subject.PDAInsertVersion <> '1.0.0'













































GO


