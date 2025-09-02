Imports QM.PDA.BO.Context
Imports QM.PDA.BO


Namespace Actions

    Public Class Study

        Public Shared Sub CreateSubject()

            CurrentSubject("elegibleDiarrea") = 2

            CurrentSubject("elegibleRespira") = 2
            CurrentSubject("elegibleRespiraIMCI") = 2
            CurrentSubject("elegibleRespiraViCo") = 2

            CurrentSubject("sospechosoIRAG") = 2
            CurrentSubject("elegibleIRAG") = 2
            CurrentSubject("sospechosoETI_MSP") = 2
            CurrentSubject("elegibleETI_MSP") = 2

            CurrentSubject("elegibleNeuro") = 2
            CurrentSubject("sospechosoNeuro") = 2

            CurrentSubject("elegibleFebril") = 2
            CurrentSubject("sospechosoFebril") = 2


            CurrentSubject("pacienteInscritoViCo") = 2

            Hospital()
            SiteType()
            SiteTypeNumeric()
            SiteDepartamento()
            SiteDepartamentoNumeric()

        End Sub



        Public Shared Sub AnioAdmision()

            ''anioAdmision = El año de calendario de admisión o presentación del paciente
            ''examples:
            '' 2010-11-23 11:21:00 000 ---> 2010
            '' 2007-06-01 09:43:23 000 ---> 2007

            'If _
            '     CurrentSubject("fechaHoraAdmision") Is Nothing _
            'Then
            '    CurrentSubject("anioAdmision") = Nothing

            'Else
            '    CurrentSubject("anioAdmision") = CDate(CurrentSubject("fechaHoraAdmision")).Year
            'End If

        End Sub



        Public Shared Sub AnioMesAdmision()

            ''anioMesAdmision = El año y mes de calendario de admisión o presentación del paciente
            ''examples:
            '' 2010-11-23 11:21:00 000 ---> 201011 
            '' 2007-06-01 09:43:23 000 ---> 200706

            'If _
            '     CurrentSubject("fechaHoraAdmision") Is Nothing _
            'Then
            '    CurrentSubject("anioMesAdmision") = Nothing

            'Else
            '    CurrentSubject("anioMesAdmision") = CDate(CurrentSubject("fechaHoraAdmision")).Year * 100 + CDate(CurrentSubject("fechaHoraAdmision")).Month
            'End If

        End Sub



        Public Shared Sub CasoSeveroRespiratorio()

            ''SevereRespiratoryCase
            ''   = CurrentSubject("elegibleRespira") = 1 AND (CurrentSubject("cuidadoIntensivo") = 1 OR CurrentSubject("ventilacionMecanica") = 1 OR (CurrentSubject("muerteViCo") = 1 AND CurrentSubject("muerteHospital") = 1))


            'If _
            '     CurrentSubject("cuidadoIntensivo") Is Nothing And CurrentSubject("ventilacionMecanica") Is Nothing And CurrentSubject("muerteViCo") Is Nothing And CurrentSubject("muerteHospital") Is Nothing _
            'Then
            '    CurrentSubject("casoSeveroRespiratorio") = Nothing

            'ElseIf CurrentSubject("elegibleRespira") = 1 And (CurrentSubject("cuidadoIntensivo") = 1 Or CurrentSubject("ventilacionMecanica") = 1 Or (CurrentSubject("muerteViCo") = 1 And CurrentSubject("muerteHospital") = 1)) Then
            '    CurrentSubject("casoSeveroRespiratorio") = 1

            'Else
            '    CurrentSubject("casoSeveroRespiratorio") = 2
            'End If

        End Sub



        Public Shared Sub Catchment()

            'If CurrentSubject("departamento") Is Nothing Or CurrentSubject("municipio") Is Nothing Or CurrentSubject("SubjectSiteID") Is Nothing Then
            '    CurrentSubject("catchment") = Nothing
            'End If

            'If _
            ' ( _
            '  CurrentSubject("departamento") = 6 _
            '  And ( _
            '    CurrentSubject("SubjectSiteID") = 1 Or CurrentSubject("SubjectSiteID") = 2 _
            '    Or CurrentSubject("SubjectSiteID") = 3 Or CurrentSubject("SubjectSiteID") = 4 _
            '    Or CurrentSubject("SubjectSiteID") = 5 Or CurrentSubject("SubjectSiteID") = 6 _
            '    Or CurrentSubject("SubjectSiteID") = 7 _
            '   ) _
            '  And ( _
            '    CurrentSubject("municipio") = 601 _
            '    Or CurrentSubject("municipio") = 602 _
            '    Or CurrentSubject("municipio") = 603 _
            '    Or CurrentSubject("municipio") = 604 _
            '    Or CurrentSubject("municipio") = 605 _
            '    Or CurrentSubject("municipio") = 606 _
            '    Or CurrentSubject("municipio") = 607 _
            '    Or CurrentSubject("municipio") = 610 _
            '    Or CurrentSubject("municipio") = 612 _
            '    Or CurrentSubject("municipio") = 613 _
            '    Or CurrentSubject("municipio") = 614 _
            '   ) _
            ' ) _
            ' Or _
            ' ( _
            '  CurrentSubject("departamento") = 9 _
            '  And ( _
            '    CurrentSubject("SubjectSiteID") = 9 Or CurrentSubject("SubjectSiteID") = 12 _
            '    Or CurrentSubject("SubjectSiteID") = 13 Or CurrentSubject("SubjectSiteID") = 14 _
            '    Or CurrentSubject("SubjectSiteID") = 15 _
            '   ) _
            '  And ( _
            '    CurrentSubject("municipio") = 901 _
            '    Or CurrentSubject("municipio") = 902 _
            '    Or CurrentSubject("municipio") = 903 _
            '    Or CurrentSubject("municipio") = 909 _
            '    Or CurrentSubject("municipio") = 910 _
            '    Or CurrentSubject("municipio") = 911 _
            '    Or CurrentSubject("municipio") = 913 _
            '    Or CurrentSubject("municipio") = 914 _
            '    Or CurrentSubject("municipio") = 916 _
            '    Or CurrentSubject("municipio") = 923 _
            '   ) _
            ' ) _
            'Then
            '    CurrentSubject("catchment") = 1
            'Else
            '    CurrentSubject("catchment") = 2
            'End If

        End Sub



        Public Shared Sub CuidadoIntensivo()

            'If _
            '     CurrentSection("cuidadoIntensivoDias") Is Nothing _
            'Then
            '    CurrentSubject("cuidadoIntensivo") = Nothing
            'ElseIf CurrentSection("cuidadoIntensivoDias") = 0 Then
            '    CurrentSubject("cuidadoIntensivo") = 2
            'ElseIf CurrentSection("cuidadoIntensivoDias") > 0 Then
            '    CurrentSubject("cuidadoIntensivo") = 1
            'End If

            'CasoSeveroRespiratorio()

        End Sub



        Public Shared Sub DuracionEstancia()
            '¿Cuál fue la duración de estancia en el hospital en días?

            'If _
            '     CurrentSubject("fechaHoraAdmision") Is Nothing Or CurrentSubject("egresoMuerteFecha") Is Nothing _
            'Then
            '    CurrentSubject("duracionEstancia") = Nothing
            'Else
            '    CurrentSubject("duracionEstancia") = DateDiff(DateInterval.Day, CurrentSection("egresoMuerteFecha"), CurrentSection("fechaHoraAdmision"))
            'End If

        End Sub



        Public Shared Sub EdadTotalAniosDecimal()
            '¿Cuál fue la duración de estancia en el hospital en días?
            '(fechaHoraAdmision - fechaDeNacimiento)
            'examples:

            'If CurrentSubject("fechaHoraAdmision") Is Nothing Or CurrentSubject("fechaDeNacimiento") Is Nothing Then

            '    CurrentSubject("edadTotalAniosDecimal") = Nothing

            'Else
            '    CurrentSubject("edadTotalAniosDecimal") = DateDiff(DateInterval.Day, CurrentSubject("fechaHoraAdmision"), CurrentSubject("fechaDeNacimiento")) / 365.25

            'End If

        End Sub



        Public Shared Sub EdadTotalDias()
            '¿Cuál fue la duración de estancia en el hospital en días?
            '(fechaHoraAdmision - fechaDeNacimiento)
            'examples:

            'If CurrentSubject("fechaHoraAdmision") Is Nothing Or CurrentSubject("fechaDeNacimiento") Is Nothing Then

            '    CurrentSubject("edadTotalDias") = Nothing

            'Else
            '    CurrentSubject("edadTotalDias") = DateDiff(DateInterval.Day, CurrentSubject("fechaHoraAdmision"), CurrentSubject("fechaDeNacimiento"))
            'End If

        End Sub



        Public Shared Sub EdadTotalMesesDecimal()

            '¿Cuál fue la duración de estancia en el hospital en días?
            '(fechaHoraAdmision - fechaDeNacimiento)
            'examples:

            'If CurrentSubject("fechaHoraAdmision") Is Nothing Or CurrentSubject("fechaDeNacimiento") Is Nothing Then

            '    CurrentSubject("edadTotalMesesDecimal") = Nothing

            'Else
            '    CurrentSubject("edadTotalMesesDecimal") = (DateDiff(DateInterval.Day, CurrentSubject("fechaHoraAdmision"), CurrentSubject("fechaDeNacimiento")) / 365.25) * 30.4375

            'End If

        End Sub



        Public Shared Sub ElegibleZinc()

            '¿El paciente está elegible para el estudio de zinc?
            'FREDY GERARDO!


            'If CurrentSection("oximetroPulso") Is Nothing Then
            '    CurrentSubject("elegibleZinc") = Nothing
            'ElseIf CurrentSection("oximetroPulso") < 90 Then
            '    CurrentSubject("elegibleZinc") = 1
            'ElseIf CurrentSection("oximetroPulso") < 90 Then
            '    CurrentSubject("elegibleZinc") = 1
            'End If

        End Sub



        Public Shared Sub EpiWeekAdmision()

            'Semana epidemiologica de admisión o presentación del paciente

            'If CurrentSubject("fechaHoraAdmision") Is Nothing Then
            '    CurrentSubject("epiWeekAdmision") = Nothing
            'Else
            '    CurrentSubject("epiWeekAdmision") = EpiYearWeek.GetEpiWeek(CurrentSubject("fechaHoraAdmision"))
            '    'CurrentSubject("epiYearAdmision") = epi.EpiYearWeek(CurrentSubject("fechaHoraAdmision")).Substring(0, 4)
            'End If

        End Sub



        Public Shared Sub EpiYearAdmision()
            'Año epidemiologica de admisión o presentación del paciente

            'If (CurrentSubject("fechaHoraAdmision") Is Nothing) Then
            '    CurrentSubject("epiYearAdmision") = Nothing

            'Else
            '    CurrentSubject("epiYearAdmision") = EpiYearWeek.GetEpiYear(CurrentSubject("fechaHoraAdmision"))
            'End If

        End Sub



        Public Shared Sub EpiYearWeekAdmision()
            'El año y semana epidemiologica de admisión o presentación del paciente

            'If CurrentSubject("fechaHoraAdmision") Is Nothing Then
            '    CurrentSubject("epiYearWeekAdmision") = Nothing
            'Else
            '    CurrentSubject("epiYearWeekAdmision") = EpiYearWeek.GetEpiYearWeek(CurrentSubject("fechaHoraAdmision"))
            'End If

        End Sub



        Public Shared Sub FechaHoraAdmision()

            'AnioAdmision()
            'AnioMesAdmision()
            ''DuracionEstancia()
            'EdadTotalAniosDecimal()
            'EdadTotalDias()
            'EdadTotalMesesDecimal()
            ''EpiWeekAdmision()
            ''EpiYearAdmision()
            ''EpiYearWeekAdmision()
            'FechaAdmision()
            'MesAdmision()

        End Sub



        Public Shared Sub FechaAdmision()
            'La fecha de admisión o presentación del paciente

            'If CurrentSubject("fechaHoraAdmision") Is Nothing Then
            '    CurrentSubject("fechaAdmision") = Nothing
            'Else
            '    CurrentSubject("fechaAdmision") = CDate(CurrentSubject("fechaHoraAdmision")).Date
            'End If

        End Sub



        Public Shared Sub Hipoxemia()

            ''¿El paciente tiene hipoxemia?

            'If CurrentSection("oximetroPulso") Is Nothing Then
            '    CurrentSubject("hipoxemia") = Nothing
            'ElseIf CurrentSection("oximetroPulso") < 90 Then
            '    CurrentSubject("hipoxemia") = 1
            'ElseIf CurrentSection("oximetroPulso") < 90 Then
            '    CurrentSubject("hipoxemia") = 1
            'End If

        End Sub



        Public Shared Sub Hospital()

            'If CurrentSubject("SubjectSiteID") = 11 Or CurrentSubject("SubjectSiteID") = 9 Or CurrentSubject("SubjectSiteID") = 1 Then
            '    CurrentSubject("hospital") = 1
            'Else
            '    CurrentSubject("hospital") = 2
            'End If

        End Sub



        Public Shared Sub MesAdmision()

            ''anioAdmision = El año de calendario de admisión o presentación del paciente
            ''examples:
            '' 2010-11-23 11:21:00 000 ---> 2010
            '' 2007-06-01 09:43:23 000 ---> 2007

            'If _
            '     CurrentSubject("fechaHoraAdmision") Is Nothing _
            'Then
            '    CurrentSubject("mesAdmision") = Nothing

            'Else
            '    CurrentSubject("mesAdmision") = CDate(CurrentSubject("fechaHoraAdmision")).Month
            'End If

        End Sub



        Public Shared Sub MoribundoSospechoso()

            '' ¿La condición del paciente sopechoso (no inscrito en ViCo) es moribundo (al punto de morirse)?
            '' de H1

            'If CurrentSection("condicionEgreso") = 4 Then
            '    CurrentSubject("moribundoSospechoso") = 1
            'Else
            '    CurrentSubject("moribundoSospechoso") = 2
            'End If

        End Sub



        Public Shared Sub MoribundoSospechosoFecha()
            ' La fecha cuando indicamos que este paciente sopechoso (no inscrito en ViCo) es moribundo 
            ' de H1

            'Dim H1Section As New Section(2)

            'If CurrentSection("condicionEgreso") = 4 Then
            '    CurrentSubject("moribundoSospechosoFecha") = H1Section("PDAInsertDate")
            'Else
            '    CurrentSubject("moribundoSospechosoFecha") = Nothing
            'End If

        End Sub



        Public Shared Sub MoribundoViCo()
            ' ¿La condición del paciente inscrito en ViCo es moribundo (al punto de morirse)?

            'Dim H7PDASection As New Section(8)
            'Dim HCP9Section As New Section(6)

            'If H7PDASection("egresoCondicion") = 4 _
            '        And (HCP9Section("seguimientoPacienteCondicion") Is Nothing Or HCP9Section("seguimientoPacienteCondicion") <> 3) _
            'Then
            '    CurrentSubject("moribundoViCo") = 1

            'Else
            '    CurrentSubject("moribundoViCo") = 2
            'End If

        End Sub



        Public Shared Sub MoribundoViCoFecha()
            'La fecha cuando indicamos que este paciente de ViCo es moribundo:

            'Dim H7PDASection As New Section(8)
            'Dim HCP9Section As New Section(6)

            'If H7PDASection("egresoCondicion") = 4 _
            '        And (HCP9Section("seguimientoPacienteCondicion") Is Nothing Or HCP9Section("seguimientoPacienteCondicion") <> 3) Then

            '    CurrentSubject("moribundoViCoFecha") = H7PDASection("egresoMuerteFecha")

            'Else
            '    CurrentSubject("moribundoViCoFecha") = Nothing
            'End If

        End Sub



        Public Shared Sub MuerteCualPaso()
            '¿En cuál paso del proceso de ViCo este paciente se murió?

            '/*
            '1 = tamizaje/consent 
            '2 = duranteEntrevista (inscrito, but NOT everything IS done HCP11 filled out probably)
            '3 = antes de egreso (H7)
            '4 = seguimiento (hcp9)
            '*/

            'Dim H1Section As New Section(2)

            'Dim H2CVSection As New Section(4)
            'Dim C1CVSection As New Section(202)
            'Dim P1CVSection As New Section(302)

            'Dim H2CESection As New Section(10)
            'Dim C1CESection As New Section(205)
            'Dim P1CESection As New Section(304)


            'Dim H7PDASection As New Section(8)
            'Dim C7Section As New Section(215)
            'Dim P7Section As New Section(312)


            'Dim H9Section As New Section(6)
            'Dim C9Section As New Section(206)
            'Dim P9Section As New Section(306)

            'Dim H11Section As New Section(7)
            'Dim C11Section As New Section(207)
            'Dim P11Section As New Section(307)

            'Dim h1TipoEgreso As Integer
            'Dim ConsentimientoVerbalNoRazonMurio As Integer
            'Dim ConsentimientoEscritoMurio As Integer
            'Dim terminoManeraCorrectaNoRazon As Integer
            'Dim egresoTipo As Integer
            'Dim seguimientoPacienteCondicion As Integer

            'If CurrentSubject.SiteCode = "06-1" Or CurrentSubject.SiteCode = "09-1" Then
            '    h1TipoEgreso = H1Section("h1TipoEgreso")
            '    ConsentimientoVerbalNoRazonMurio = H2CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = H2CESection("ConsentimientoEscritoMurio")
            '    terminoManeraCorrectaNoRazon = H11Section("terminoManeraCorrectaNoRazon")
            '    egresoTipo = H7PDASection("egresoTipo")
            '    seguimientoPacienteCondicion = H9Section("seguimientoPacienteCondicion")

            'ElseIf CurrentSubject.SiteCode = "06-2" _
            '        Or CurrentSubject.SiteCode = "09-2" Or CurrentSubject.SiteCode = "09-3" Or CurrentSubject.SiteCode = "09-4" Then
            '    h1TipoEgreso = Nothing
            '    ConsentimientoVerbalNoRazonMurio = C1CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = C1CESection("ConsentimientoEscritoMurio")
            '    terminoManeraCorrectaNoRazon = C11Section("terminoManeraCorrectaNoRazon")
            '    egresoTipo = C7Section("tipoEgreso")
            '    seguimientoPacienteCondicion = C9Section("seguimientoPacienteCondicion")

            'ElseIf CurrentSubject.SiteCode = "06-3" Or CurrentSubject.SiteCode = "06-4" Or CurrentSubject.SiteCode = "06-5" _
            '        Or CurrentSubject.SiteCode = "06-6" Or CurrentSubject.SiteCode = "06-7" _
            '        Or CurrentSubject.SiteCode = "09-5" Then

            '    h1TipoEgreso = Nothing
            '    ConsentimientoVerbalNoRazonMurio = P1CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = P1CESection("ConsentimientoEscritoMurio")
            '    terminoManeraCorrectaNoRazon = P11Section("terminoManeraCorrectaNoRazon")
            '    egresoTipo = P7Section("tipoEgreso")
            '    seguimientoPacienteCondicion = P9Section("seguimientoPacienteCondicion")

            'End If

            'If h1TipoEgreso = 4 _
            '    Or ConsentimientoVerbalNoRazonMurio = 1 _
            '    Or ConsentimientoEscritoMurio = 1 Then
            '    CurrentSubject("muerteCualPaso") = 1

            'ElseIf terminoManeraCorrectaNoRazon = 3 Then
            '    CurrentSubject("muerteCualPaso") = 2

            'ElseIf egresoTipo = 4 Then
            '    CurrentSubject("muerteCualPaso") = 3

            'ElseIf seguimientoPacienteCondicion = 3 Then
            '    CurrentSubject("muerteCualPaso") = 4

            'Else
            '    CurrentSubject("muerteCualPaso") = Nothing

            'End If

        End Sub



        Public Shared Sub MuerteHospital()
            '¿Este paciente se murió en el hospital?

            '/*1 = enHospital(tamizaje,duranteEntrevista, antes de egresoCondicion H7) */ 
            '/*2 = afueraHospital (seguimiento)*/

            'Dim H1Section As New Section(2)

            'Dim H2CVSection As New Section(4)
            'Dim C1CVSection As New Section(202)
            'Dim P1CVSection As New Section(302)

            'Dim H2CESection As New Section(10)
            'Dim C1CESection As New Section(205)
            'Dim P1CESection As New Section(304)

            'Dim H7PDASection As New Section(8)
            'Dim C7Section As New Section(215)
            'Dim P7Section As New Section(312)

            'Dim H9Section As New Section(6)
            'Dim C9Section As New Section(206)
            'Dim P9Section As New Section(306)

            'Dim h1TipoEgreso As Integer
            'Dim ConsentimientoVerbalNoRazonMurio As Integer
            'Dim ConsentimientoEscritoMurio As Integer
            'Dim egresoTipo As Integer
            'Dim seguimientoPacienteCondicion As Integer

            'If CurrentSubject.SiteCode = "06-1" Or CurrentSubject.SiteCode = "09-1" Then
            '    h1TipoEgreso = H1Section("h1TipoEgreso")
            '    ConsentimientoVerbalNoRazonMurio = H2CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = H2CESection("ConsentimientoEscritoMurio")
            '    egresoTipo = H7PDASection("egresoTipo")
            '    seguimientoPacienteCondicion = H9Section("seguimientoPacienteCondicion")

            'ElseIf CurrentSubject.SiteCode = "06-2" _
            '        Or CurrentSubject.SiteCode = "09-2" Or CurrentSubject.SiteCode = "09-3" Or CurrentSubject.SiteCode = "09-4" Then
            '    h1TipoEgreso = Nothing
            '    ConsentimientoVerbalNoRazonMurio = C1CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = C1CESection("ConsentimientoEscritoMurio")
            '    egresoTipo = C7Section("tipoEgreso")
            '    seguimientoPacienteCondicion = C9Section("seguimientoPacienteCondicion")

            'ElseIf CurrentSubject.SiteCode = "06-3" Or CurrentSubject.SiteCode = "06-4" Or CurrentSubject.SiteCode = "06-5" _
            '        Or CurrentSubject.SiteCode = "06-6" Or CurrentSubject.SiteCode = "06-7" _
            '        Or CurrentSubject.SiteCode = "09-5" Then

            '    h1TipoEgreso = Nothing
            '    ConsentimientoVerbalNoRazonMurio = P1CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = P1CESection("ConsentimientoEscritoMurio")
            '    egresoTipo = P7Section("tipoEgreso")
            '    seguimientoPacienteCondicion = P9Section("seguimientoPacienteCondicion")

            'End If


            'If (h1TipoEgreso = 4 Or ConsentimientoVerbalNoRazonMurio = 1 Or ConsentimientoEscritoMurio = 1 Or egresoTipo = 4) Then
            '    CurrentSubject("muerteHospital") = 1
            'ElseIf seguimientoPacienteCondicion = 3 Then
            '    CurrentSubject("muerteHospital") = 2
            'Else
            '    CurrentSubject("muerteHospital") = Nothing
            'End If

            'CasoSeveroRespiratorio()

        End Sub



        Public Shared Sub MuerteSospechoso()
            ' ¿El paciente sopechoso (no inscrito en ViCo) se murió?

            'Dim H1Section As New Section(2)

            'Dim H2CVSection As New Section(4)
            'Dim C1CVSection As New Section(202)
            'Dim P1CVSection As New Section(302)

            'Dim H2CESection As New Section(10)
            'Dim C1CESection As New Section(205)
            'Dim P1CESection As New Section(304)

            'Dim h1TipoEgreso As Integer
            'Dim ConsentimientoVerbalNoRazonMurio As Integer
            'Dim ConsentimientoEscritoMurio As Integer

            'If CurrentSubject.SiteCode = "06-1" Or CurrentSubject.SiteCode = "09-1" Then
            '    h1TipoEgreso = H1Section("h1TipoEgreso")
            '    ConsentimientoVerbalNoRazonMurio = H2CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = H2CESection("ConsentimientoEscritoMurio")

            'ElseIf CurrentSubject.SiteCode = "06-2" _
            '        Or CurrentSubject.SiteCode = "09-2" Or CurrentSubject.SiteCode = "09-3" Or CurrentSubject.SiteCode = "09-4" Then
            '    h1TipoEgreso = Nothing
            '    ConsentimientoVerbalNoRazonMurio = C1CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = C1CESection("ConsentimientoEscritoMurio")

            'ElseIf CurrentSubject.SiteCode = "06-3" Or CurrentSubject.SiteCode = "06-4" Or CurrentSubject.SiteCode = "06-5" _
            '        Or CurrentSubject.SiteCode = "06-6" Or CurrentSubject.SiteCode = "06-7" _
            '        Or CurrentSubject.SiteCode = "09-5" Then

            '    h1TipoEgreso = Nothing
            '    ConsentimientoVerbalNoRazonMurio = P1CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = P1CESection("ConsentimientoEscritoMurio")

            'End If


            'If h1TipoEgreso = 4 Or ConsentimientoVerbalNoRazonMurio = 1 Or ConsentimientoEscritoMurio = 1 Then
            '    CurrentSubject("muerteSospechoso") = 1
            'Else
            '    CurrentSubject("muerteSospechoso") = 2
            'End If

        End Sub



        Public Shared Sub MuerteSospechosoFecha()
            'La fecha cuando este paciente sopechoso (no inscrito en ViCo) se murió

            'Dim H1Section As New Section(2)

            'Dim H2CVSection As New Section(4)
            'Dim C1CVSection As New Section(202)
            'Dim P1CVSection As New Section(302)

            'Dim H2CESection As New Section(10)
            'Dim C1CESection As New Section(205)
            'Dim P1CESection As New Section(304)

            'Dim h1TipoEgreso As Integer
            'Dim ConsentimientoVerbalNoRazonMurio As Integer
            'Dim ConsentimientoEscritoMurio As Integer

            'If CurrentSubject.SiteCode = "06-1" Or CurrentSubject.SiteCode = "09-1" Then
            '    h1TipoEgreso = H1Section("h1TipoEgreso")
            '    ConsentimientoVerbalNoRazonMurio = H2CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = H2CESection("ConsentimientoEscritoMurio")

            'ElseIf CurrentSubject.SiteCode = "06-2" _
            '        Or CurrentSubject.SiteCode = "09-2" Or CurrentSubject.SiteCode = "09-3" Or CurrentSubject.SiteCode = "09-4" Then
            '    h1TipoEgreso = Nothing
            '    ConsentimientoVerbalNoRazonMurio = C1CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = C1CESection("ConsentimientoEscritoMurio")

            'ElseIf CurrentSubject.SiteCode = "06-3" Or CurrentSubject.SiteCode = "06-4" Or CurrentSubject.SiteCode = "06-5" _
            '        Or CurrentSubject.SiteCode = "06-6" Or CurrentSubject.SiteCode = "06-7" _
            '        Or CurrentSubject.SiteCode = "09-5" Then

            '    h1TipoEgreso = Nothing
            '    ConsentimientoVerbalNoRazonMurio = P1CVSection("ConsentimientoVerbalNoRazonMurio")
            '    ConsentimientoEscritoMurio = P1CESection("ConsentimientoEscritoMurio")

            'End If


            'If h1TipoEgreso = 4 Then
            '    CurrentSubject("muerteSospechoso") = H1Section("h1FechaEgreso")
            'ElseIf ConsentimientoVerbalNoRazonMurio = 1 Or ConsentimientoEscritoMurio = 1 Then
            '    CurrentSubject("muerteSospechoso") = CurrentSubject("PDAInsertDate")
            'Else
            '    CurrentSubject("muerteSospechoso") = Nothing
            'End If

        End Sub



        Public Shared Sub MuerteViCo()
            '¿El paciente de ViCo se murió?

            'Dim H7PDASection As New Section(8)
            'Dim C7Section As New Section(215)
            'Dim P7Section As New Section(312)

            'Dim H9Section As New Section(6)
            'Dim C9Section As New Section(206)
            'Dim P9Section As New Section(306)

            'Dim egresoTipo As Integer
            'Dim seguimientoPacienteCondicion As Integer

            'If CurrentSubject.SiteCode = "06-1" Or CurrentSubject.SiteCode = "09-1" Then
            '    egresoTipo = H7PDASection("egresoTipo")
            '    seguimientoPacienteCondicion = H9Section("seguimientoPacienteCondicion")

            'ElseIf CurrentSubject.SiteCode = "06-2" _
            '        Or CurrentSubject.SiteCode = "09-2" Or CurrentSubject.SiteCode = "09-3" Or CurrentSubject.SiteCode = "09-4" Then
            '    egresoTipo = C7Section("tipoEgreso")
            '    seguimientoPacienteCondicion = C9Section("seguimientoPacienteCondicion")

            'ElseIf CurrentSubject.SiteCode = "06-3" Or CurrentSubject.SiteCode = "06-4" Or CurrentSubject.SiteCode = "06-5" _
            '        Or CurrentSubject.SiteCode = "06-6" Or CurrentSubject.SiteCode = "06-7" _
            '        Or CurrentSubject.SiteCode = "09-5" Then

            '    egresoTipo = P7Section("tipoEgreso")
            '    seguimientoPacienteCondicion = P9Section("seguimientoPacienteCondicion")

            'End If


            'If egresoTipo = 4 Or seguimientoPacienteCondicion = 3 Then
            '    CurrentSubject("muerteViCo") = 1
            'ElseIf egresoTipo <> 4 And seguimientoPacienteCondicion <> 3 Then
            '    CurrentSubject("muerteViCo") = 2
            'Else
            '    CurrentSubject("muerteViCo") = Nothing
            'End If

            'CasoSeveroRespiratorio()

        End Sub



        Public Shared Sub MuerteViCoFecha()
            'La fecha cuando este paciente de ViCo se murió


            'Dim H7PDASection As New Section(8)
            'Dim C7Section As New Section(215)
            'Dim P7Section As New Section(312)

            'Dim H9Section As New Section(6)
            'Dim C9Section As New Section(206)
            'Dim P9Section As New Section(306)

            'Dim egresoTipo As Integer
            'Dim egresoMuerteFecha As Integer
            'Dim seguimientoPacienteCondicion As Integer
            'Dim seguimientoPacienteMuerteFecha As Integer

            'If CurrentSubject.SiteCode = "06-1" Or CurrentSubject.SiteCode = "09-1" Then
            '    egresoTipo = H7PDASection("egresoTipo")
            '    egresoMuerteFecha = H7PDASection("egresoMuerteFecha")
            '    seguimientoPacienteCondicion = H9Section("seguimientoPacienteCondicion")
            '    seguimientoPacienteMuerteFecha = H9Section("seguimientoPacienteMuerteFecha")

            'ElseIf CurrentSubject.SiteCode = "06-2" _
            '        Or CurrentSubject.SiteCode = "09-2" Or CurrentSubject.SiteCode = "09-3" Or CurrentSubject.SiteCode = "09-4" Then
            '    egresoTipo = C7Section("tipoEgreso")
            '    egresoMuerteFecha = CurrentSubject("PDAInsertDate")
            '    seguimientoPacienteCondicion = C9Section("seguimientoPacienteCondicion")
            '    seguimientoPacienteMuerteFecha = C9Section("seguimientoPacienteMuerteFecha")

            'ElseIf CurrentSubject.SiteCode = "06-3" Or CurrentSubject.SiteCode = "06-4" Or CurrentSubject.SiteCode = "06-5" _
            '        Or CurrentSubject.SiteCode = "06-6" Or CurrentSubject.SiteCode = "06-7" _
            '        Or CurrentSubject.SiteCode = "09-5" Then

            '    egresoTipo = P7Section("tipoEgreso")
            '    egresoMuerteFecha = CurrentSubject("PDAInsertDate")
            '    seguimientoPacienteCondicion = P9Section("seguimientoPacienteCondicion")
            '    seguimientoPacienteMuerteFecha = P9Section("seguimientoPacienteMuerteFecha")
            'End If


            'If egresoTipo = 4 Then
            '    CurrentSubject("muerteViCoFecha") = egresoMuerteFecha
            'ElseIf seguimientoPacienteCondicion = 3 Then
            '    CurrentSubject("muerteViCoFecha") = seguimientoPacienteMuerteFecha
            'ElseIf egresoTipo <> 4 And seguimientoPacienteCondicion <> 3 Then

            'Else
            '    CurrentSubject("muerteViCoFecha") = Nothing
            'End If

        End Sub



        Public Shared Sub SeguimientoPacienteCondicion()

            'MoribundoViCo()
            'MoribundoViCoFecha()
            'MuerteCualPaso()
            'MuerteHospital()
            'MuerteViCo()
            'MuerteViCoFecha()

        End Sub



        Public Shared Sub SignosPeligro()
            '¿El paciente tiene signos de peligro?

            'If _
            'CurrentSubject("edadAnios") >= 5 OrElse _
            '    (CurrentSection("ninioBeberMamar") Is Nothing AndAlso _
            '    CurrentSection("ninioTuvoConvulsiones") Is Nothing AndAlso _
            '    CurrentSection("ninioTieneLetargia") Is Nothing AndAlso _
            '    CurrentSection("ninioVomitaTodo") Is Nothing AndAlso _
            '    CurrentSection("ninioTuvoConvulsionesObs") Is Nothing) _
            'Then
            '    CurrentSubject("signosPeligro") = Nothing

            'ElseIf CurrentSubject("edadAnios") < 5 AndAlso _
            '    (CurrentSection("ninioBeberMamar") = 1 OrElse _
            '     CurrentSection("ninioTuvoConvulsiones") = 1 OrElse _
            '     CurrentSection("ninioTieneLetargia") = 1 OrElse _
            '     CurrentSection("ninioVomitaTodo") = 1 OrElse _
            '     CurrentSection("ninioTuvoConvulsionesObs") = 1) _
            'Then
            '    CurrentSubject("signosPeligro") = 1

            'ElseIf CurrentSubject("edadAnios") < 5 AndAlso _
            '     (CurrentSection("ninioBeberMamar") Is Nothing OrElse CurrentSection("ninioBeberMamar") = 2) AndAlso _
            '     (CurrentSection("ninioTuvoConvulsiones") Is Nothing OrElse CurrentSection("ninioTuvoConvulsiones") = 2) AndAlso _
            '     (CurrentSection("ninioTieneLetargia") Is Nothing OrElse CurrentSection("ninioTieneLetargia") = 2) AndAlso _
            '     (CurrentSection("ninioVomitaTodo") Is Nothing OrElse CurrentSection("ninioVomitaTodo") = 2) AndAlso _
            '     (CurrentSection("ninioTuvoConvulsionesObs") Is Nothing OrElse CurrentSection("ninioTuvoConvulsionesObs") = 2) _
            'Then
            '    CurrentSubject("signosPeligro") = 2

            'End If

        End Sub



        Public Shared Sub SiteDepartamento()

            ''SiteDepartamento:
            'If CurrentSubject("SubjectSiteID") = 11 _
            '    Then
            '    CurrentSubject("siteDepartamento") = "GT"
            'ElseIf CurrentSubject("SubjectSiteID") = 1 Or CurrentSubject("SubjectSiteID") = 2 Or CurrentSubject("SubjectSiteID") = 3 _
            '            Or CurrentSubject("SubjectSiteID") = 4 Or CurrentSubject("SubjectSiteID") = 5 _
            '            Or CurrentSubject("SubjectSiteID") = 6 Or CurrentSubject("SubjectSiteID") = 7 _
            '    Then
            '    CurrentSubject("siteDepartamento") = "SR"
            'ElseIf CurrentSubject("SubjectSiteID") = 9 Or CurrentSubject("SubjectSiteID") = 12 _
            '            Or CurrentSubject("SubjectSiteID") = 13 Or CurrentSubject("SubjectSiteID") = 14 Or CurrentSubject("SubjectSiteID") = 15 _
            '    Then
            '    CurrentSubject("siteDepartamento") = "QU"
            'End If

        End Sub



        Public Shared Sub SiteDepartamentoNumeric()

            ''SiteDepartamento:
            'If CurrentSubject("SubjectSiteID") = 11 _
            '    Then
            '    CurrentSubject("siteDepartamentoNumeric") = 1
            'ElseIf CurrentSubject("SubjectSiteID") = 1 Or CurrentSubject("SubjectSiteID") = 2 Or CurrentSubject("SubjectSiteID") = 3 _
            '            Or CurrentSubject("SubjectSiteID") = 4 Or CurrentSubject("SubjectSiteID") = 5 _
            '            Or CurrentSubject("SubjectSiteID") = 6 Or CurrentSubject("SubjectSiteID") = 7 _
            '    Then
            '    CurrentSubject("siteDepartamentoNumeric") = 6
            'ElseIf CurrentSubject("SubjectSiteID") = 9 Or CurrentSubject("SubjectSiteID") = 12 _
            '            Or CurrentSubject("SubjectSiteID") = 13 Or CurrentSubject("SubjectSiteID") = 14 Or CurrentSubject("SubjectSiteID") = 15 _
            '    Then
            '    CurrentSubject("siteDepartamentoNumeric") = 9
            'End If

        End Sub



        Public Shared Sub SiteType()

            ''SiteType:
            'If CurrentSubject("SubjectSiteID") = 11 Or CurrentSubject("SubjectSiteID") = 9 Or CurrentSubject("SubjectSiteID") = 1 _
            '    Then
            '    CurrentSubject("siteType") = "H"
            'ElseIf CurrentSubject("SubjectSiteID") = 2 Or CurrentSubject("SubjectSiteID") = 12 _
            '            Or CurrentSubject("SubjectSiteID") = 13 Or CurrentSubject("SubjectSiteID") = 14 _
            '    Then
            '    CurrentSubject("siteType") = "CS"
            'ElseIf CurrentSubject("SubjectSiteID") = 3 Or CurrentSubject("SubjectSiteID") = 4 Or CurrentSubject("SubjectSiteID") = 5 _
            '            Or CurrentSubject("SubjectSiteID") = 6 Or CurrentSubject("SubjectSiteID") = 7 Or CurrentSubject("SubjectSiteID") = 15 _
            '    Then
            '    CurrentSubject("siteType") = "PS"
            'End If

        End Sub



        Public Shared Sub SiteTypeNumeric()

            ''SiteType:
            'If CurrentSubject("SubjectSiteID") = 11 Or CurrentSubject("SubjectSiteID") = 9 Or CurrentSubject("SubjectSiteID") = 1 _
            '    Then
            '    CurrentSubject("siteTypeNumeric") = 1
            'ElseIf CurrentSubject("SubjectSiteID") = 2 Or CurrentSubject("SubjectSiteID") = 12 _
            '            Or CurrentSubject("SubjectSiteID") = 13 Or CurrentSubject("SubjectSiteID") = 14 _
            '    Then
            '    CurrentSubject("siteTypeNumeric") = 2
            'ElseIf CurrentSubject("SubjectSiteID") = 3 Or CurrentSubject("SubjectSiteID") = 4 Or CurrentSubject("SubjectSiteID") = 5 _
            '            Or CurrentSubject("SubjectSiteID") = 6 Or CurrentSubject("SubjectSiteID") = 7 Or CurrentSubject("SubjectSiteID") = 15 _
            '    Then
            '    CurrentSubject("siteTypeNumeric") = 3
            'End If

        End Sub



        Public Shared Sub TemperaturaPrimeras24HorasCombin()
            'La temperatura documentada más alta en las primeras 24 horas de admision.

            'Dim H7PDASection As New Section(31)

            'If CurrentSubject("temperaturaPrimeras24Horas") Is Nothing And H7PDASection("temperaturaPrimeras24HorasAlta") Is Nothing _
            'Then
            '    CurrentSubject("temperaturaPrimeras24HorasCombin") = Nothing

            'ElseIf CurrentSubject("temperaturaPrimeras24Horas") >= H7PDASection("temperaturaPrimeras24HorasAlta") Then
            '    CurrentSubject("temperaturaPrimeras24HorasCombin") = CurrentSubject("temperaturaPrimeras24Horas")

            'ElseIf H7PDASection("temperaturaPrimeras24HorasAlta") > CurrentSubject("temperaturaPrimeras24Horas") Then
            '    CurrentSubject("temperaturaPrimeras24HorasAlta") = 1

            'End If

        End Sub



        Public Shared Sub VentilacionMecanica()

            'If _
            '     CurrentSection("ventilacionMecanicaDias") Is Nothing _
            'Then
            '    CurrentSubject("ventilacionMecanica") = Nothing
            'ElseIf CurrentSection("ventilacionMecanicaDias") = 0 Then
            '    CurrentSubject("ventilacionMecanica") = 2
            'ElseIf CurrentSection("ventilacionMecanicaDias") > 0 Then
            '    CurrentSubject("ventilacionMecanica") = 1
            'End If

            'CasoSeveroRespiratorio()

        End Sub



        Public Shared Sub pacienteInscritoViCoFecha()

            CurrentSubject("pacienteInscritoViCoFecha") = Today()

        End Sub



        Public Shared Sub sintomasFiebreDias()

            Dim PDAInsertDate As Object = CurrentSection("PDAInsertDate")
            Dim sintomasFiebreFechaInicio As Object = CurrentSection("sintomasFiebreFechaInicio")


            If PDAInsertDate Is Nothing Or sintomasFiebreFechaInicio Is Nothing Then

                CurrentSubject("sintomasFiebreDias") = Nothing

            Else

                ' sintomasFiebreDias = (PDAInsertDate - sintomasFiebreFechaInicio).Days
                CurrentSubject("sintomasFiebreDias") = (CDate(PDAInsertDate).Date - CDate(sintomasFiebreFechaInicio)).Days

            End If

        End Sub


    End Class



    Public Class H1

        Public Shared Sub SalaIngreso()

            If CurrentSubject("salaIngreso") = 6 And CurrentSubject("fechaHoraAdmision") Is Nothing Then
                CurrentSubject("fechaHoraAdmision") = CurrentSection("PDAInsertDate")
            End If

            'Study.FechaHoraAdmision()

        End Sub



        Public Shared Sub ConcatenateNames()

            CurrentSubject("nombreCompleto") = CurrentSubject("nombres") + ";" + CurrentSubject("apellidos")

        End Sub


    End Class



    Public Class H2

        Public Shared Sub EV_sospechosoNeuro()

            If CurrentSubject("departamento") Is Nothing _
                    OrElse (CurrentSubject("temperaturaPrimeras24Horas") Is Nothing AndAlso CurrentSubject("sintomasFiebre") Is Nothing) _
                    OrElse (CurrentSubject("puncionLumbar") Is Nothing) _
             Then
                CurrentSubject("sospechosoNeuro") = 2
                EV_CriteriaNeuro()
                Exit Sub
            End If

            If CurrentSubject("puncionLumbar") = 1 Then
                CurrentSubject("sospechosoNeuro") = 1
            Else
                CurrentSubject("sospechosoNeuro") = 2
            End If

            EV_CriteriaNeuro()

        End Sub



        Public Shared Sub EV_CriteriaNeuro()

            ' [2013-02-09] FM: No se van a enrolar más pacientes para el estudio de enfermedades neurológicas.

            'If CurrentSite.Code = "01-1" OrElse CurrentSubject("departamento") Is Nothing OrElse (CurrentSubject("temperaturaPrimeras24Horas") Is Nothing And CurrentSubject("sintomasFiebre") Is Nothing) Or CurrentSubject("puncionLumbar") Is Nothing Then
            '    If CurrentSubject("elegibleNeuro") <> 2 Then
            '        MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de NEURO!")
            '    End If
            '    CurrentSubject("elegibleNeuro") = 2
            '    Exit Sub
            'End If


            'If CurrentSubject("sospechosoNeuro") = 1 _
            '    AndAlso CurrentSubject("edadAnios") < 5 _
            '    AndAlso (CurrentSubject("temperaturaPrimeras24Horas") >= 38 Or CurrentSubject("sintomasFiebre") = 1) _
            '    AndAlso ( _
            '        CurrentSubject("sintomasNeuroKerning") = 1 _
            '        Or CurrentSubject("sintomasNeuroBrudzinski") = 1 _
            '        Or CurrentSubject("sintomasNeuroCuelloRigido") = 1 _
            '        Or CurrentSubject("sintomasNeuroFontanelaAbombada") = 1 _
            '        Or CurrentSubject("sintomasNeuroLllantoInconsolable") = 1 _
            '        Or CurrentSubject("sintomasNeuroDecaimiento") = 1 _
            '        Or CurrentSubject("sintomasNeuroDisminucionSuccion") = 1 _
            '        Or CurrentSubject("gradoAlteracionConciencia24Horas") = 1 _
            '        Or CurrentSubject("sintomasNeuroDisminucionSuccion") = 1 _
            '        Or (CurrentSubject("convulsionPerdidaConciencia") = 1 And CurrentSubject("convulsionOrigenFebril") = 2) _
            '        Or CurrentSubject("sintomasNeuroPetequias") = 1 _
            '        Or CurrentSubject("sintomasNeuroRashPurpurico") = 1 _
            '        Or CurrentSubject("sintomasNeuroLuceToxico") = 1 _
            '        Or CurrentSubject("otroSignoMeningeo") = 1 _
            '    ) _
            'Then

            '    If CurrentSubject("elegibleNeuro") = 2 Then
            '        MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de NEURO!")
            '    End If
            '    CurrentSubject("elegibleNeuro") = 1

            'Else
            '    If CurrentSubject("elegibleNeuro") = 1 Then
            '        MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de NEURO!")
            '    End If
            '    CurrentSubject("elegibleNeuro") = 2
            'End If

            EV_sospechosoFebril()

        End Sub



        ' FM[2011-02-08]: Aparentemente esta es una versión antigua del criterio para Neuro, debo verificar antes de borrar
        'Public Shared Sub EV_CriteriaNeuro()

        '    If CurrentSubject("departamento") Is Nothing Or (CurrentSubject("temperaturaPrimeras24Horas") Is Nothing And CurrentSubject("sintomasFiebre") Is Nothing) Or CurrentSubject("puncionLumbar") Is Nothing Then
        '        If CurrentSubject("elegibleNeuro") <> 2 Then
        '            MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de NEURO!")
        '        End If
        '        CurrentSubject("elegibleNeuro") = 2
        '        Exit Sub
        '    End If


        '    ' La variable "sintomasNeuroEncefalopatia" no existe en el formulario
        '    If (CurrentSubject("departamento") = 6 Or CurrentSubject("departamento") = 21 Or CurrentSubject("departamento") = 22) _
        '        And (CurrentSubject("temperaturaPrimeras24Horas") >= 38 Or CurrentSubject("sintomasFiebre") = 1) _
        '        And (CurrentSubject("sintomasNeuroIrritacionMeningeal") = 1 Or CurrentSubject("sintomasNeuroEncefalopatia") = 1) _
        '        And CurrentSubject("puncionLumbar") = 1 Then

        '        If CurrentSubject("elegibleNeuro") = 2 Then
        '            MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de NEURO!")
        '        End If
        '        CurrentSubject("elegibleNeuro") = 1
        '    Else
        '        If CurrentSubject("elegibleNeuro") = 1 Then
        '            MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de NEURO!")
        '        End If
        '        CurrentSubject("elegibleNeuro") = 2
        '    End If
        '    EV_CriteriaFebril()

        'End Sub



        Public Shared Sub EV_CriteriaRespira()

            EV_CriteriaRespiraViCo()
            ElegibleRespiraIMCI()
            If CurrentSubject("elegibleRespiraViCo") = 1 OrElse CurrentSubject("elegibleRespiraIMCI") = 1 Then
                CurrentSubject("elegibleRespira") = 1
            Else
                CurrentSubject("elegibleRespira") = 2

            End If

        End Sub



        Public Shared Sub EV_CriteriaRespiraViCo()

            If CurrentSubject("departamento") Is Nothing Or CurrentSubject("sintomasRespira") Is Nothing Then

                If CurrentSubject("elegibleRespiraViCo") <> 2 Then
                    MsgBox("IMPORTANTE:¡¡Con este cambio ahora el paciente NO es elegible para el estudio de RESPIRATORIO!!")
                End If
                CurrentSubject("elegibleRespiraViCo") = 2
                Exit Sub
            End If

            'Version 7.000 returns to geographic limitations...
            If ((CurrentSubject.SiteCode.StartsWith("06") And (CurrentSubject("departamento") = 6 OrElse CurrentSubject("departamento") = 21 OrElse CurrentSubject("departamento") = 22)) _
                Or _
                (CurrentSubject.SiteCode.StartsWith("09") And (CurrentSubject("departamento") = 9 And (CurrentSubject("municipio") = 901 Or CurrentSubject("municipio") = 902 Or CurrentSubject("municipio") = 903 Or CurrentSubject("municipio") = 909 Or CurrentSubject("municipio") = 910 Or CurrentSubject("municipio") = 911 Or CurrentSubject("municipio") = 913 Or CurrentSubject("municipio") = 914 Or CurrentSubject("municipio") = 916 Or CurrentSubject("municipio") = 923))) _
                ) _
                AndAlso (CurrentSubject("sintomasRespira") = 1) _
                    AndAlso (CurrentSubject("sintomasRespiraFiebre") = 1 OrElse CurrentSubject("sintomasRespiraHipotermia") = 1 OrElse CurrentSubject("sintomasFiebre") = 1 _
                        OrElse CurrentSubject("sintomasRespiraCGB") = 1 OrElse CurrentSubject("diferencialAnormal") = 1) Then
                If CurrentSubject("elegibleRespiraViCo") = 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de RESPIRATORIO!")
                End If
                CurrentSubject("elegibleRespiraViCo") = 1
            Else
                If CurrentSubject("elegibleRespiraViCo") = 1 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de RESPIRATORIO!")
                End If
                CurrentSubject("elegibleRespiraViCo") = 2
            End If

            EV_sospechosoFebril()
            EV_CriteriaIRAG()
            Study.CasoSeveroRespiratorio()

        End Sub



        Public Shared Sub ElegibleRespiraIMCI()

            If CurrentSubject("edadAnios") Is Nothing OrElse (CurrentSubject("edadAnios") = 0 AndAlso CurrentSubject("edadMeses") Is Nothing) Is Nothing Then
                CurrentSubject("elegibleRespiraIMCI") = 2
                Exit Sub
            End If


            Dim H2CSection As New Section(6)


            If (CurrentSubject("edadAnios") = 0 AndAlso CurrentSubject("edadMeses") < 2) _
                AndAlso _
                ( _
                    (CurrentSubject("sintomasRespiraTaquipnea") = 1 OrElse CurrentSubject("sintomasRespiraNinioCostillasHundidas") = 1) _
                    OrElse _
                    ( _
                        (CurrentSubject("sintomasRespiraTos") = 1 OrElse CurrentSubject("sintomasRespiraDificultadRespirar") = 1) _
                        AndAlso _
                        ( _
                                   CurrentSubject("sintomasRespiraNinioEstridor") = 1 _
                            OrElse CurrentSubject("hipoxemia") = 1 _
                            OrElse H2CSection("ninioCianosisObs") = 1 _
                            OrElse H2CSection("ninioBeberMamar") = 2 _
                            OrElse H2CSection("ninioVomitaTodo") = 1 _
                            OrElse H2CSection("ninioTuvoConvulsiones") = 1 _
                            OrElse H2CSection("ninioTuvoConvulsionesObs") = 1 _
                            OrElse H2CSection("ninioTieneLetargiaObs") = 1 _
                            OrElse H2CSection("ninioDesmayoObs") = 1 _
                            OrElse H2CSection("ninioCabeceoObs") = 1 _
                            OrElse H2CSection("ninioMovimientoObs") = 2 _
                            OrElse H2CSection("ninioMovimientoObs") = 3 _
                        ) _
                    ) _
                ) _
            Then
                CurrentSubject("elegibleRespiraIMCI") = 1

            ElseIf _
                ( _
                    (CurrentSubject("edadAnios") = 0 AndAlso CurrentSubject("edadMeses") >= 2) _
                    OrElse _
                    (CurrentSubject("edadAnios") > 0 AndAlso CurrentSubject("edadAnios") < 5) _
                ) _
                AndAlso _
                (CurrentSubject("sintomasRespiraTos") = 1 OrElse CurrentSubject("sintomasRespiraDificultadRespirar") = 1) _
                AndAlso _
                ( _
                           CurrentSubject("sintomasRespiraTaquipnea") = 1 _
                    OrElse CurrentSubject("sintomasRespiraNinioCostillasHundidas") = 1 _
                    OrElse CurrentSubject("sintomasRespiraNinioEstridor") = 1 _
                    OrElse CurrentSubject("hipoxemia") = 1 _
                    OrElse H2CSection("ninioCianosisObs") = 1 _
                    OrElse H2CSection("ninioBeberMamar") = 2 _
                    OrElse H2CSection("ninioVomitaTodo") = 1 _
                    OrElse H2CSection("ninioTuvoConvulsiones") = 1 _
                    OrElse H2CSection("ninioTuvoConvulsionesObs") = 1 _
                    OrElse H2CSection("ninioTieneLetargiaObs") = 1 _
                    OrElse H2CSection("ninioDesmayoObs") = 1 _
                    OrElse H2CSection("ninioCabeceoObs") = 1 _
                ) _
            Then
                CurrentSubject("elegibleRespiraIMCI") = 1
            Else
                CurrentSubject("elegibleRespiraIMCI") = 2
            End If

        End Sub



        Public Shared Sub EV_CriteriaIRAG()

            If CurrentSubject("edadAnios") Is Nothing OrElse CurrentSubject("indicacionRespira") Is Nothing Then
                'If CurrentSubject("sospechosoIRAG") <> 2 Then
                '    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de IRAG!")
                'End If
                CurrentSubject("sospechosoIRAG") = 2
                Exit Sub
            End If

            If (CurrentSubject("edadAnios") < 5 And (CurrentSubject("indicacionRespira") = 5 Or CurrentSubject("indicacionRespira") = 26) _
                And CurrentSubject("elegibleRespira") = 1) _
                Or _
                (CurrentSubject("edadAnios") >= 5 _
                    And (CurrentSubject("temperaturaPrimeras24Horas") >= 38) _
                    And (CurrentSubject("sintomasRespiraTos") = 1 Or CurrentSubject("sintomasRespiraDolorGarganta") = 1) _
                    And (CurrentSubject("sintomasRespiraFaltaAire") = 1 Or CurrentSubject("sintomasRespiraDificultadRespirar") = 1) _
                    And CurrentSubject("elegibleRespira") = 1 _
                ) _
            Then
                CurrentSubject("sospechosoIRAG") = 1
            Else
                CurrentSubject("sospechosoIRAG") = 2
            End If

            EV_inscribirIRAG()

        End Sub



        Public Shared Sub EV_inscribirIRAG()

            If CurrentSubject("sospechosoIRAG") Is Nothing Or CurrentSubject("enfermedadEmpezoHaceDias") Is Nothing Then
                If CurrentSubject("elegibleIRAG") <> 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de IRAG!")
                End If
                CurrentSubject("elegibleIRAG") = 2
                Exit Sub
            End If

            If CurrentSubject("sospechosoIRAG") = 1 And CurrentSubject("enfermedadEmpezoHaceDias") <= 3 Then

                CurrentSubject("elegibleIRAG") = 1

            Else

                CurrentSubject("elegibleIRAG") = 2

            End If

        End Sub



        Public Shared Sub EV_CriteriaDiarrea()

            'Action.H2.EV_CriteriaFebril
            If CurrentSubject.SiteCode = "01-1" OrElse (CurrentSubject("departamento") Is Nothing And CurrentSubject("diarreaComenzoHaceDias") Is Nothing And CurrentSubject("diarreaMaximoAsientos1Dia") Is Nothing And CurrentSubject("diarreaOtroEpisodioSemanaAnterior") Is Nothing And CurrentSubject("edadAnios") Is Nothing) Then
                If CurrentSubject("elegibleDiarrea") <> 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de DIARREA!")
                End If
                CurrentSubject("elegibleDiarrea") = 2
                Exit Sub
            End If

            If ( _
                (CurrentSubject.SiteCode.StartsWith("06") And CurrentSubject("departamento") = 6) _
                Or _
                (CurrentSubject.SiteCode.StartsWith("09") And CurrentSubject("departamento") = 9 And (CurrentSubject("municipio") = 901 Or CurrentSubject("municipio") = 902 Or CurrentSubject("municipio") = 903 Or CurrentSubject("municipio") = 909 Or CurrentSubject("municipio") = 910 Or CurrentSubject("municipio") = 911 Or CurrentSubject("municipio") = 913 Or CurrentSubject("municipio") = 914 Or CurrentSubject("municipio") = 916 Or CurrentSubject("municipio") = 923)) _
                ) _
                And CurrentSubject("diarreaComenzoHaceDias") <= 14 And CurrentSubject("diarreaMaximoAsientos1Dia") >= 3 And CurrentSubject("diarreaOtroEpisodioSemanaAnterior") = 2 _
                And CurrentSubject("edadAnios") < 5 _
            Then

                If CurrentSubject("elegibleDiarrea") = 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de DIARREA!")
                End If
                CurrentSubject("elegibleDiarrea") = 1

            Else
                If CurrentSubject("elegibleDiarrea") = 1 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de DIARREA!")
                End If
                CurrentSubject("elegibleDiarrea") = 2
            End If

            EV_sospechosoFebril()

        End Sub



        Public Shared Sub EV_CriteriaFebril()

            If _
                 CurrentSubject.SiteCode = "01-1" OrElse CurrentSubject("departamento") Is Nothing OrElse (CurrentSubject("elegibleDiarrea") = 1 Or CurrentSubject("elegibleRespira") = 1 Or CurrentSubject("elegibleNeuro") = 1) OrElse CurrentSubject("fiebreDiagnostico") Is Nothing Then
                If CurrentSubject("elegibleFebril") <> 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de FEBRIL!")
                End If
                CurrentSubject("elegibleFebril") = 2
                Exit Sub
            End If

            ' GL[2010-11-29]: - this is an old note that I don't understand now:
            ' want to add currentsubject("presentaIdicacionFebril") = 1 + CurrentSubject("sospechosoFebril") = 1
            ' to make people elegibleFebril = 1 regardless of enrollment in other studies.

            If CurrentSubject("sospechosoFebril") = 1 _
                    AndAlso CurrentSubject("elegibleDiarrea") = 2 _
                    AndAlso CurrentSubject("elegibleRespira") = 2 _
                    AndAlso CurrentSubject("elegibleNeuro") = 2 _
                    AndAlso CurrentSubject("fiebreDiagnostico") = 0 _
                Then
                If CurrentSubject("elegibleFebril") = 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de FEBRIL!")
                End If
                CurrentSubject("elegibleFebril") = 1
            Else
                If CurrentSubject("elegibleFebril") = 1 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de FEBRIL!")
                End If
                CurrentSubject("elegibleFebril") = 2
            End If

        End Sub



        Public Shared Sub EV_sospechosoFebril()

            If CurrentSubject("departamento") Is Nothing _
                    OrElse (CurrentSubject("temperaturaPrimeras24Horas") Is Nothing AndAlso CurrentSubject("sintomasFiebre") Is Nothing) _
            Then
                CurrentSubject("sospechosoFebril") = 2
                Exit Sub
            End If


            ' FM[2011-10-25] En ViCo 8.0 solo se enrolarán casos de enfermedades febriles en Santa Rosa (Hospital y Centro)
            'If ( _
            '        (CurrentSubject.SiteCode.StartsWith("06") And (CurrentSubject("departamento") = 6 Or CurrentSubject("departamento") = 21 Or CurrentSubject("departamento") = 22)) _
            '        Or _
            '        (CurrentSubject.SiteCode.StartsWith("09") And (CurrentSubject("departamento") = 9) And (CurrentSubject("municipio") = 901 Or CurrentSubject("municipio") = 902 Or CurrentSubject("municipio") = 903 Or CurrentSubject("municipio") = 909 Or CurrentSubject("municipio") = 910 Or CurrentSubject("municipio") = 911 Or CurrentSubject("municipio") = 913 Or CurrentSubject("municipio") = 914 Or CurrentSubject("municipio") = 916 Or CurrentSubject("municipio") = 923)) _
            '    ) _
            '    AndAlso (CurrentSubject("temperaturaPrimeras24Horas") >= 38.0 Or (CurrentSubject("sintomasFiebre") = 1 And CurrentSubject("sintomasFiebreDias") < 7)) _


            If (CurrentSubject.SiteCode.StartsWith("06") And (CurrentSubject("departamento") = 6 Or CurrentSubject("departamento") = 21 Or CurrentSubject("departamento") = 22)) _
                AndAlso (CurrentSubject("temperaturaPrimeras24Horas") >= 38.0 Or (CurrentSubject("sintomasFiebre") = 1 And CurrentSubject("sintomasFiebreDias") < 7)) _
            Then
                CurrentSubject("sospechosoFebril") = 1
            Else
                CurrentSubject("sospechosoFebril") = 2
            End If

            EV_CriteriaFebril()

        End Sub



        Public Shared Sub EV_SintomasRespira()

            'previous version
            'If (CurrentSubject("sintomasRespiraTos") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraEsputo") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraHemoptisis") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraDolorPechoRespirar") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraDificultadRespirar") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraFaltaAire") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraDolorGarganta") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraTaquipnea") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraNinioCostillasHundidas") = 1 _
            '    OrElse CurrentSubject("resultadoAnormalExamenPulmones") = 1 _
            '    'OrElse CurrentSubject("sintomasRespiraNinioAleteoNasal") = 1 _
            '    'OrElse CurrentSubject("sintomasRespiraNinioRuidosPecho") = 1 _  question to be deleted
            '    'OrElse CurrentSubject("sintomasRespiraNinioPausaRepedimente") = 1 _ question to be deleted
            '    ) _

            If (CurrentSubject("sintomasRespiraTos") = 1 _
                OrElse CurrentSubject("sintomasRespiraEsputo") = 1 _
                OrElse CurrentSubject("sintomasRespiraHemoptisis") = 1 _
                OrElse CurrentSubject("sintomasRespiraDolorPechoRespirar") = 1 _
                OrElse CurrentSubject("sintomasRespiraDificultadRespirar") = 1 _
                OrElse CurrentSubject("sintomasRespiraFaltaAire") = 1 _
                OrElse CurrentSubject("sintomasRespiraDolorGarganta") = 1 _
                OrElse CurrentSubject("sintomasRespiraTaquipnea") = 1 _
                OrElse CurrentSubject("sintomasRespiraNinioCostillasHundidas") = 1 _
                OrElse CurrentSubject("resultadoAnormalExamenPulmones") = 1 _
                ) _
            Then
                CurrentSubject("sintomasRespira") = 1
            Else
                CurrentSubject("sintomasRespira") = 2
            End If

            EV_CriteriaRespira()

        End Sub



        Public Shared Sub EV_IrritacionMeningeal()

            If CurrentSubject("sintomasNeuroKerning") = 1 _
                Or CurrentSubject("sintomasNeuroBrudzinski") = 1 Or _
                CurrentSubject("sintomasNeuroCuelloRigido") = 1 Or _
                CurrentSubject("sintomasNeuroIrritacionMeningeaSospechoso") = 1 Or _
                CurrentSubject("sintomasNeuroFontanelaAbombada") = 1 Or _
                CurrentSubject("sintomasNeuroLllantoInconsolable") = 1 Or _
                CurrentSubject("sintomasNeuroDecaimiento") = 1 Or _
                CurrentSubject("sintomasNeuroDisminucionSuccion") = 1 _
            Then
                CurrentSubject("sintomasNeuroIrritacionMeningeal") = 1
            Else
                CurrentSubject("sintomasNeuroIrritacionMeningeal") = 2
            End If

            EV_CriteriaNeuro()

        End Sub



        Public Shared Sub EV_Encefalopatia()

            If CurrentSubject("gradoAlteracionConciencia24Horas") = 1 _
                    Or CurrentSubject("cambiosPersonalidad24Horas") = 1 _
                    Or CurrentSubject("disminucionRespuestaRuido") = 1 _
                    Or CurrentSubject("disminucionFijacionMirada") = 1 _
                    Or CurrentSubject("dificultadReconocerObjetosPersonas") = 1 _
                    Or CurrentSubject("convulsionPerdidaConciencia") = 1 Then
                CurrentSubject("sintomasNeuroEncefalopatia") = 1
            Else
                CurrentSubject("sintomasNeuroEncefalopatia") = 2
            End If

            EV_CriteriaNeuro()

        End Sub



        Public Shared Sub EV_Departamento()

            'if changed value then need to verify that municipio is still valid!

            EV_CriteriaDiarrea()
            EV_CriteriaRespira()
            EV_sospechosoNeuro()
            EV_sospechosoFebril()

        End Sub



        Public Shared Sub EV_CriteriaCGB()

            If CurrentSubject("conteoGlobulosBlancos") Is Nothing Or CurrentSubject("edadAnios") Is Nothing Then
                CurrentSubject("sintomasRespiraCGB") = 2
                EV_CriteriaRespira()
                Exit Sub
            End If

            If (CurrentSubject("edadAnios") >= 5 And (CurrentSubject("conteoGlobulosBlancos") < 3000 Or CurrentSubject("conteoGlobulosBlancos") > 11000)) _
             Or (CurrentSubject("edadAnios") < 5 And (CurrentSubject("conteoGlobulosBlancos") < 5500 Or CurrentSubject("conteoGlobulosBlancos") > 15000)) Then
                CurrentSubject("sintomasRespiraCGB") = 1
            Else
                CurrentSubject("sintomasRespiraCGB") = 2
            End If

            EV_CriteriaRespira()
            'new
            EV_sospechosoNeuro()

        End Sub



        Public Shared Sub EV_Taquipnea()

            If (CurrentSubject("edadAnios") >= 5 _
                  AndAlso _
                (CurrentSubject("respiraPorMinutoPrimaras24Horas") >= 20 OrElse CurrentSubject("respiraPorMinuto") >= 20) _
               ) _
 _
            OrElse _
               (CurrentSubject("edadAnios") < 5 _
                  AndAlso _
                CurrentSubject("edadAnios") >= 1 _
                  AndAlso _
                (CurrentSubject("respiraPorMinutoPrimaras24Horas") >= 40 OrElse CurrentSubject("respiraPorMinuto") >= 40) _
               ) _
 _
            OrElse _
               (CurrentSubject("edadAnios") = 0 _
                  AndAlso _
                CurrentSubject("edadMeses") IsNot Nothing _
                  AndAlso _
                CurrentSubject("edadMeses") >= 2 _
                  AndAlso _
                CurrentSubject("edadMeses") <= 11 _
                  AndAlso _
                (CurrentSubject("respiraPorMinutoPrimaras24Horas") >= 50 OrElse CurrentSubject("respiraPorMinuto") >= 50) _
               ) _
 _
            OrElse _
               (CurrentSubject("edadAnios") = 0 _
                  AndAlso _
                CurrentSubject("edadMeses") IsNot Nothing _
                  AndAlso _
                CurrentSubject("edadMeses") < 2 _
                  AndAlso _
                (CurrentSubject("respiraPorMinutoPrimaras24Horas") >= 60 OrElse CurrentSubject("respiraPorMinuto") >= 60) _
               ) _
 _
            Then
                CurrentSubject("sintomasRespiraTaquipnea") = 1
            Else
                CurrentSubject("sintomasRespiraTaquipnea") = 2
            End If

            EV_SintomasRespira()

        End Sub



        Public Shared Sub EV_Temperatura()

            If CurrentSubject("temperaturaPrimeras24Horas") >= 38.0 Then
                CurrentSubject("sintomasRespiraFiebre") = 1
                CurrentSubject("sintomasRespiraHipotermia") = 2
            ElseIf (CurrentSubject("temperaturaPrimeras24Horas") IsNot Nothing And CurrentSubject("temperaturaPrimeras24Horas") < 35.5) Then
                CurrentSubject("sintomasRespiraFiebre") = 2
                CurrentSubject("sintomasRespiraHipotermia") = 1
            ElseIf CurrentSubject("temperaturaPrimeras24Horas") < 38.0 And CurrentSubject("temperaturaPrimeras24Horas") >= 35.5 Then
                CurrentSubject("sintomasRespiraFiebre") = 2
                CurrentSubject("sintomasRespiraHipotermia") = 2
            Else
                CurrentSubject("sintomasRespiraFiebre") = Nothing
                CurrentSubject("sintomasRespiraHipotermia") = Nothing
            End If

            EV_FiebreOHistoriaFiebre()
            EV_CriteriaRespira()
            EV_sospechosoNeuro()
            EV_sospechosoFebril()

        End Sub



        Public Shared Sub EV_Fiebre()

            EV_FiebreOHistoriaFiebre()
            EV_sospechosoFebril()
            EV_sospechosoNeuro()

        End Sub



        Public Shared Sub EV_FiebreOHistoriaFiebre()

            If CurrentSubject("sintomasRespiraFiebre") = 1 OrElse _
                (CurrentSubject("sintomasFiebre") = 1 AndAlso CurrentSubject("sintomasFiebreDias") >= 0 AndAlso CurrentSubject("sintomasFiebreDias") < 7) _
            Then
                CurrentSubject("fiebreOHistoriaFiebre") = 1
            Else
                CurrentSubject("fiebreOHistoriaFiebre") = 2
            End If

        End Sub

    End Class




    Public Class H3A

        Public Shared Sub CreateRecord()

            CurrentSection("enfermedadesCronicasAlguna") = 2

        End Sub



        Public Shared Sub EV_EnfermedadesCronicas()

            If CurrentSection("enfermedadesCronicasAsma") = 1 Or CurrentSection("enfermedadesCronicasDiabetes") = 1 Or CurrentSection("enfermedadesCronicasCancer") = 1 Or CurrentSection("enfermedadesCronicasEnfermCorazon") = 1 Or CurrentSection("enfermedadesCronicasEnfermHigado") = 1 Or CurrentSection("enfermedadesCronicasEnfermRinion") = 1 Or CurrentSection("enfermedadesCronicasVIHSIDA") = 1 Or CurrentSection("enfermedadesCronicasOtras") = 1 Or CurrentSection("enfermedadesCronicasHipertension") = 1 Or CurrentSection("enfermedadesCronicasEnfermPulmones") = 1 Then
                CurrentSection("enfermedadesCronicasAlguna") = 1
            Else
                CurrentSection("enfermedadesCronicasAlguna") = 2
            End If

        End Sub

    End Class




    Public Class H3B

        Public Shared Sub CreateRecord()

            CurrentSection("otroTratamientoMencionoHospital") = 2

        End Sub



        Public Shared Sub EV_OtroTratamientoMencionoHospital()

            If CurrentSection("otroTratamiento1erTipoEstablecimiento") = 1 Or CurrentSection("otroTratamiento1erTipoEstablecimiento") = 2 Or CurrentSection("otroTratamiento2doTipoEstablecimiento") = 1 Or CurrentSection("otroTratamiento2doTipoEstablecimiento") = 2 Or CurrentSection("otroTratamiento3erTipoEstablecimiento") = 1 Or CurrentSection("otroTratamiento3erTipoEstablecimiento") = 2 Then
                CurrentSection("otroTratamientoMencionoHospital") = 1
            Else
                CurrentSection("otroTratamientoMencionoHospital") = 2
            End If

        End Sub

    End Class




    Public Class C1

        Public Shared Sub ConcatenateNames()

            CurrentSubject("nombreCompleto") = CurrentSubject("nombres") + ";" + CurrentSubject("apellidos")

        End Sub



        Public Shared Sub EV_CriteriaDiarrea()

            ' GL[2009-06-26]: Wences decided that in Xela CSs that anyone from the three municipios can go to any CS and be accepted...not just the cs in their Municipio
            If CurrentSubject("municipio") Is Nothing And CurrentSubject("diarreaComenzoHaceDias") Is Nothing And CurrentSubject("diarreaMaximoAsientos1Dia") Is Nothing And CurrentSubject("diarreaOtroEpisodioSemanaAnterior") Is Nothing And CurrentSubject("edadAnios") Is Nothing Then
                If CurrentSubject("elegibleDiarrea") <> 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de DIARREA!")
                End If
                CurrentSubject("elegibleDiarrea") = 2
                Exit Sub
            End If


            If ( _
                    (CurrentSubject.SiteCode.StartsWith("06") And CurrentSubject("municipio") = 614) _
                    OrElse _
                    (CurrentSubject.SiteCode.StartsWith("09") And (CurrentSubject("municipio") = 911 Or CurrentSubject("municipio") = 914 Or CurrentSubject("municipio") = 923)) _
                ) _
                AndAlso CurrentSubject("diarreaComenzoHaceDias") <= 14 _
                AndAlso CurrentSubject("diarreaMaximoAsientos1Dia") >= 3 _
                AndAlso CurrentSubject("diarreaOtroEpisodioSemanaAnterior") = 2 _
                AndAlso CurrentSubject("edadAnios") < 5 _
            Then
                If CurrentSubject("elegibleDiarrea") = 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de DIARREA!")
                End If
                CurrentSubject("elegibleDiarrea") = 1

            Else
                If CurrentSubject("elegibleDiarrea") = 1 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de DIARREA!")
                End If
                CurrentSubject("elegibleDiarrea") = 2
            End If

            EV_sospechosoFebril()

        End Sub



        Public Shared Sub EV_CriteriaRespira()

            ' FM[2011-02-10]: Por un cambio en el cuestionario, esta condición se puede dar fácilmente
            'If CurrentSubject("municipio") Is Nothing Or CurrentSubject("temperaturaPrimeras24Horas") Is Nothing Or CurrentSection("sintomasRespiraTos14Dias") Is Nothing Or CurrentSection("sintomasRespiraGarganta14Dias") Is Nothing Then
            '    If CurrentSubject("elegibleRespira") <> 2 Then
            '        MsgBox("IMPORTANTE:¡¡Con este cambio ahora el paciente NO es elegible para el estudio de RESPIRATORIO!!")
            '    End If
            '    CurrentSubject("elegibleRespira") = 2
            '    Exit Sub
            'End If


            ' v7.0.0.0 returns to geographic limitations...
            If (CurrentSubject("municipio") = 614 Or CurrentSubject("municipio") = 911 Or CurrentSubject("municipio") = 914 Or CurrentSubject("municipio") = 923) _
                    AndAlso _
                    CurrentSubject("temperaturaPrimeras24Horas") > 38 _
                    AndAlso (CurrentSection("sintomasRespiraTos14Dias") = 1 OrElse CurrentSection("sintomasRespiraGarganta14Dias") = 1) Then

                If CurrentSubject("elegibleRespira") = 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de RESPIRATORIO!")
                End If
                CurrentSubject("elegibleRespira") = 1
            Else
                If CurrentSubject("elegibleRespira") = 1 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de RESPIRATORIO!")
                End If
                CurrentSubject("elegibleRespira") = 2
            End If

            'IF municipio = 'NUEVA SANTA ROSA' AND temperaturaPrimeras24Horas > 38 AND (sintomasRespiraTos14Dias = 1 OR sintomasRespiraGarganta14Dias = 1)

            EV_sospechosoFebril()
            EV_CriteriaETI_MSP()
            Study.CasoSeveroRespiratorio()

        End Sub



        Public Shared Sub EV_CriteriaETI_MSP()

            If CurrentSubject("elegibleRespira") = 1 Then
                CurrentSubject("sospechosoETI_MSP") = 1
            Else
                CurrentSubject("sospechosoETI_MSP") = 2
            End If

            EV_inscribirETI_MSP()

        End Sub



        Public Shared Sub EV_inscribirETI_MSP()

            If CurrentSubject("sospechosoETI_MSP") = 1 AndAlso CurrentSubject("enfermedadEmpezoHaceDias") IsNot Nothing AndAlso CurrentSubject("enfermedadEmpezoHaceDias") <= 3 Then
                CurrentSubject("elegibleETI_MSP") = 1
            Else
                CurrentSubject("elegibleETI_MSP") = 2
            End If

        End Sub



        Public Shared Sub EV_sospechosoFebril()

            If CurrentSubject("municipio") Is Nothing _
                    OrElse (CurrentSubject("temperaturaPrimeras24Horas") Is Nothing AndAlso CurrentSubject("sintomasFiebre") Is Nothing) _
            Then
                CurrentSubject("sospechosoFebril") = 2
                Exit Sub
            End If

            If ( _
                    (CurrentSubject.SiteCode.StartsWith("06") And (CurrentSubject("municipio") = 614)) _
                ) _
                AndAlso (CurrentSubject("temperaturaPrimeras24Horas") >= 38.0 Or (CurrentSubject("sintomasFiebre") = 1 And CurrentSubject("sintomasFiebreDias") < 7)) _
            Then
                CurrentSubject("sospechosoFebril") = 1
            Else
                CurrentSubject("sospechosoFebril") = 2
            End If

            EV_CriteriaFebril()

        End Sub



        Public Shared Sub EV_CriteriaFebril()

            If CurrentSubject("municipio") Is Nothing OrElse (CurrentSubject("elegibleDiarrea") = 1 Or CurrentSubject("elegibleRespira") = 1 Or CurrentSubject("elegibleNeuro") = 1) OrElse CurrentSubject("fiebreDiagnostico") Is Nothing Then
                If CurrentSubject("elegibleFebril") <> 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de FEBRIL!")
                End If
                CurrentSubject("elegibleFebril") = 2
                Exit Sub
            End If

            If CurrentSubject("sospechosoFebril") = 1 _
                    AndAlso CurrentSubject("elegibleDiarrea") = 2 _
                    AndAlso CurrentSubject("elegibleRespira") = 2 _
                    AndAlso CurrentSubject("elegibleNeuro") = 2 _
                    AndAlso CurrentSubject("fiebreDiagnostico") = 0 _
                Then
                If CurrentSubject("elegibleFebril") = 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de FEBRIL!")
                End If
                CurrentSubject("elegibleFebril") = 1
            Else
                If CurrentSubject("elegibleFebril") = 1 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de FEBRIL!")
                End If
                CurrentSubject("elegibleFebril") = 2
            End If

        End Sub



        ' FM[2011-02-08]: Aparentemente esta es una versión antigua del criterio para Febril, debo verificar antes de borrar
        'Public Shared Sub EV_CriteriaFebril()
        '    ''Original Version from hospital
        '    If CurrentSubject("municipio") Is Nothing Or (CurrentSubject("elegibleDiarrea") = 1 Or CurrentSubject("elegibleRespira") = 1 Or CurrentSubject("elegibleNeuro") = 1) Or (CurrentSubject("temperaturaPrimeras24Horas") Is Nothing And CurrentSubject("sintomasFiebre") Is Nothing) Or CurrentSubject("lesionAbiertaInfectada") Is Nothing Or CurrentSubject("otitisMedia") Is Nothing And CurrentSubject("fiebreOtraRazon") Is Nothing Then
        '        If CurrentSubject("elegibleFebril") <> 2 Then
        '            MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de FEBRIL!")
        '        End If
        '        CurrentSubject("elegibleFebril") = 2
        '        Exit Sub
        '    End If


        '    If (CurrentSubject("municipio") = 614) And (CurrentSubject("elegibleDiarrea") = 2 And CurrentSubject("elegibleRespira") = 2 And CurrentSubject("elegibleNeuro") = 2) And (CurrentSubject("temperaturaPrimeras24Horas") >= 38 Or (CurrentSubject("sintomasFiebre") = 1 And CurrentSubject("sintomasFiebreDias") < 7)) And CurrentSubject("lesionAbiertaInfectada") = 2 And CurrentSubject("otitisMedia") = 2 And CurrentSubject("fiebreOtraRazon") = 2 Then
        '        If CurrentSubject("elegibleFebril") = 2 Then
        '            MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de FEBRIL!")
        '        End If
        '        CurrentSubject("elegibleFebril") = 1
        '    Else
        '        If CurrentSubject("elegibleFebril") = 1 Then
        '            MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de FEBRIL!")
        '        End If
        '        CurrentSubject("elegibleFebril") = 2
        '    End If

        'End Sub



        Public Shared Sub EV_SintomasRespira()

            'PREVIOUS VERSION BEFORE 7.0.0.0
            'If (CurrentSubject("sintomasRespiraTos") = 1 OrElse CurrentSubject("sintomasRespiraEsputo") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraHemoptisis") = 1 OrElse CurrentSubject("sintomasRespiraDolorPechoRespirar") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraDificultadRespirar") = 1 OrElse CurrentSubject("sintomasRespiraFaltaAire") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraDolorGarganta") = 1 OrElse CurrentSubject("resultadoAnormalExamenPulmones") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraTaquipnea") = 1 OrElse CurrentSubject("sintomasRespiraNinioPausaRepedimente") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraNinioCostillasHundidas") = 1 OrElse CurrentSubject("sintomasRespiraNinioAleteoNasal") = 1 _
            '    OrElse CurrentSubject("sintomasRespiraNinioRuidosPecho") = 1 _
            '    ) Then
            '    CurrentSubject("sintomasRespira") = 1
            'Else
            '    CurrentSubject("sintomasRespira") = 2
            'End If

            If (CurrentSubject("sintomasRespiraTos") = 1 OrElse CurrentSubject("sintomasRespiraEsputo") = 1 _
                OrElse CurrentSubject("sintomasRespiraHemoptisis") = 1 OrElse CurrentSubject("sintomasRespiraDolorPechoRespirar") = 1 _
                OrElse CurrentSubject("sintomasRespiraDificultadRespirar") = 1 OrElse CurrentSubject("sintomasRespiraFaltaAire") = 1 _
                OrElse CurrentSubject("sintomasRespiraDolorGarganta") = 1 OrElse CurrentSubject("resultadoAnormalExamenPulmones") = 1 _
                OrElse CurrentSubject("sintomasRespiraTaquipnea") = 1 _
                OrElse CurrentSubject("sintomasRespiraNinioCostillasHundidas") = 1 _
                ) Then
                CurrentSubject("sintomasRespira") = 1
            Else
                CurrentSubject("sintomasRespira") = 2
            End If

            EV_CriteriaRespira()

            'I would like to call this only OnChange of each variable!

        End Sub



        Public Shared Sub EV_IrritacionMeningeal()

            If CurrentSubject("sintomasNeuroKerning") = 1 Or CurrentSubject("sintomasNeuroBrudzinski") = 1 Or CurrentSubject("sintomasNeuroCuelloRigido") = 1 Or CurrentSubject("sintomasNeuroIrritacionMeningeaSospechoso") = 1 Or CurrentSubject("sintomasNeuroFontanelaAbombada") = 1 Or CurrentSubject("sintomasNeuroLllantoInconsolable") = 1 Or CurrentSubject("sintomasNeuroDecaimiento") = 1 Or CurrentSubject("sintomasNeuroDisminucionSuccion") = 1 Then
                CurrentSubject("sintomasNeuroIrritacionMeningeal") = 1
            Else
                CurrentSubject("sintomasNeuroIrritacionMeningeal") = 2
            End If


            'I would like to call this only OnChange of each variable!

        End Sub



        Public Shared Sub EV_Encefalopatia()

            If CurrentSubject("gradoAlteracionConciencia24Horas") = 1 Or CurrentSubject("cambiosPersonalidad24Horas") = 1 Or CurrentSubject("disminucionRespuestaRuido") = 1 Or CurrentSubject("disminucionFijacionMirada") = 1 Or CurrentSubject("dificultadReconocerObjetosPersonas") = 1 Or CurrentSubject("convulsionPerdidaConciencia") = 1 Then
                CurrentSubject("sintomasNeuroEncefalopatia") = 1
            Else
                CurrentSubject("sintomasNeuroEncefalopatia") = 2
            End If


            'I would like to call this only OnChange of each variable!

        End Sub



        Public Shared Sub EV_Municipio()

            'if changed value then need to verify that municipio is still valid!

            EV_CriteriaDiarrea()
            EV_CriteriaRespira()
            EV_CriteriaFebril()
            Study.Catchment()

        End Sub



        Public Shared Sub EV_Departamento()

            'if changed value then need to verify that municipio is still valid!

            EV_CriteriaDiarrea()
            EV_CriteriaRespira()
            EV_CriteriaFebril()
            Study.Catchment()

        End Sub



        Public Shared Sub EV_CriteriaCGB()

            If CurrentSubject("conteoGlobulosBlancos") Is Nothing Or CurrentSubject("edadAnios") Is Nothing Then
                CurrentSubject("sintomasRespiraCGB") = 2
                EV_CriteriaRespira()
                Exit Sub
            End If

            If (CurrentSubject("edadAnios") >= 5 And (CurrentSubject("conteoGlobulosBlancos") < 3000 Or CurrentSubject("conteoGlobulosBlancos") > 11000)) _
             Or (CurrentSubject("edadAnios") < 5 And (CurrentSubject("conteoGlobulosBlancos") < 5500 Or CurrentSubject("conteoGlobulosBlancos") > 15000)) Then
                CurrentSubject("sintomasRespiraCGB") = 1
            Else
                CurrentSubject("sintomasRespiraCGB") = 2
            End If

            EV_CriteriaRespira()

        End Sub



        Public Shared Sub EV_Temperatura()

            If CurrentSubject("temperaturaPrimeras24Horas") >= 38.0 Then
                CurrentSubject("sintomasRespiraFiebre") = 1
                CurrentSubject("sintomasRespiraHipotermia") = 2
            ElseIf (CurrentSubject("temperaturaPrimeras24Horas") IsNot Nothing And CurrentSubject("temperaturaPrimeras24Horas") < 35.5) Then
                CurrentSubject("sintomasRespiraFiebre") = 2
                CurrentSubject("sintomasRespiraHipotermia") = 1
            ElseIf CurrentSubject("temperaturaPrimeras24Horas") < 38.0 And CurrentSubject("temperaturaPrimeras24Horas") >= 35.5 Then
                CurrentSubject("sintomasRespiraFiebre") = 2
                CurrentSubject("sintomasRespiraHipotermia") = 2
            Else
                CurrentSubject("sintomasRespiraFiebre") = Nothing
                CurrentSubject("sintomasRespiraHipotermia") = Nothing
            End If

            EV_FiebreOHistoriaFiebre()
            EV_CriteriaRespira()
            EV_CriteriaFebril()

        End Sub



        Public Shared Sub EV_Fiebre()

            EV_FiebreOHistoriaFiebre()
            EV_CriteriaFebril()

        End Sub



        Public Shared Sub EV_FiebreOHistoriaFiebre()

            If CurrentSubject("sintomasRespiraFiebre") = 1 OrElse _
                (CurrentSubject("sintomasFiebre") = 1 AndAlso CurrentSubject("sintomasFiebreDias") >= 0 AndAlso CurrentSubject("sintomasFiebreDias") < 7) _
            Then
                CurrentSubject("fiebreOHistoriaFiebre") = 1
            Else
                CurrentSubject("fiebreOHistoriaFiebre") = 2
            End If

        End Sub



        Public Shared Sub c_sintomasRespiraTos14Dias()

            If CurrentSection("sintomasRespiraTosDias") <= 14 Then
                CurrentSection("sintomasRespiraTos14Dias") = 1
            Else
                CurrentSection("sintomasRespiraTos14Dias") = 2
            End If

        End Sub



        Public Shared Sub c_sintomasRespiraGarganta14Dias()

            If CurrentSection("sintomasRespiraGargantaDias") <= 14 Then
                CurrentSection("sintomasRespiraGarganta14Dias") = 1
            Else
                CurrentSection("sintomasRespiraGarganta14Dias") = 2
            End If

        End Sub

    End Class




    Public Class C2A

        Public Shared Sub CreateRecord()

            CurrentSection("enfermedadesCronicasAlguna") = 2

        End Sub



        Public Shared Sub EV_EnfermedadesCronicas()

            If CurrentSection("enfermedadesCronicasAsma") = 1 _
                    Or CurrentSection("enfermedadesCronicasDiabetes") = 1 _
                    Or CurrentSection("enfermedadesCronicasCancer") = 1 _
                    Or CurrentSection("enfermedadesCronicasEnfermCorazon") = 1 _
                    Or CurrentSection("enfermedadesCronicasEnfermHigado") = 1 _
                    Or CurrentSection("enfermedadesCronicasEnfermRinion") = 1 _
                    Or CurrentSection("enfermedadesCronicasVIHSIDA") = 1 _
                    Or CurrentSection("enfermedadesCronicasOtras") = 1 _
                    Or CurrentSection("enfermedadesCronicasHipertension") = 1 _
                    Or CurrentSection("enfermedadesCronicasEnfermPulmones") = 1 _
            Then
                CurrentSection("enfermedadesCronicasAlguna") = 1
            Else
                CurrentSection("enfermedadesCronicasAlguna") = 2
            End If

        End Sub

    End Class




    Public Class C2B

        Public Shared Sub CreateRecord()

            CurrentSection("otroTratamientoMencionoHospital") = 2

        End Sub



        Public Shared Sub EV_OtroTratamientoMencionoHospital()

            If CurrentSection("otroTratamiento1erTipoEstablecimiento") = 1 Or CurrentSection("otroTratamiento1erTipoEstablecimiento") = 2 Or CurrentSection("otroTratamiento2doTipoEstablecimiento") = 1 Or CurrentSection("otroTratamiento2doTipoEstablecimiento") = 2 Or CurrentSection("otroTratamiento3erTipoEstablecimiento") = 1 Or CurrentSection("otroTratamiento3erTipoEstablecimiento") = 2 Then
                CurrentSection("otroTratamientoMencionoHospital") = 1
            Else
                CurrentSection("otroTratamientoMencionoHospital") = 2
            End If

        End Sub

    End Class




    Public Class P1

        Public Shared Sub ConcatenateNames()

            CurrentSubject("nombreCompleto") = CurrentSubject("nombres") + ";" + CurrentSubject("apellidos")

        End Sub



        Public Shared Sub EV_CriteriaDiarrea()

            '2009-06-26 - Wences decided that in Xela CSs that anyone from the three municipios can go to any CS and be accepted...not just the cs in their Municipio
            If CurrentSubject("municipio") Is Nothing And CurrentSubject("diarreaComenzoHaceDias") Is Nothing And CurrentSubject("diarreaMaximoAsientos1Dia") Is Nothing And CurrentSubject("diarreaOtroEpisodioSemanaAnterior") Is Nothing And CurrentSubject("edadAnios") Is Nothing Then
                If CurrentSubject("elegibleDiarrea") <> 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de DIARREA!")
                End If
                CurrentSubject("elegibleDiarrea") = 2
                Exit Sub
            End If


            If ( _
                    (CurrentSubject.SiteCode.StartsWith("06") And CurrentSubject("municipio") = 614) _
                    OrElse _
                    (CurrentSubject.SiteCode.StartsWith("09") And (CurrentSubject("municipio") = 911 Or CurrentSubject("municipio") = 914 Or CurrentSubject("municipio") = 923)) _
                ) _
                AndAlso CurrentSubject("diarreaComenzoHaceDias") <= 14 _
                AndAlso CurrentSubject("diarreaMaximoAsientos1Dia") >= 3 _
                AndAlso CurrentSubject("diarreaOtroEpisodioSemanaAnterior") = 2 _
                AndAlso CurrentSubject("edadAnios") < 5 _
            Then
                If CurrentSubject("elegibleDiarrea") = 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de DIARREA!")
                End If
                CurrentSubject("elegibleDiarrea") = 1
                ' EV_CriteriaFebril()
            Else
                If CurrentSubject("elegibleDiarrea") = 1 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de DIARREA!")
                End If
                CurrentSubject("elegibleDiarrea") = 2
            End If

        End Sub



        Public Shared Sub EV_CriteriaRespira()

            ' FM[2011-02-10]: Por un cambio en el cuestionario, esta condición se puede dar fácilmente
            'If CurrentSubject("municipio") Is Nothing Or CurrentSubject("temperaturaPrimeras24Horas") Is Nothing Or CurrentSection("sintomasRespiraTos14Dias") Is Nothing Or CurrentSection("sintomasRespiraGarganta14Dias") Is Nothing Then
            '    If CurrentSubject("elegibleRespira") <> 2 Then
            '        MsgBox("IMPORTANTE:¡¡Con este cambio ahora el paciente NO es elegible para el estudio de RESPIRATORIO!!")
            '    End If
            '    CurrentSubject("elegibleRespira") = 2
            '    Exit Sub
            'End If

            'Version 7.000 returns to geographic limitations...
            If (CurrentSubject("municipio") = 614 Or CurrentSubject("municipio") = 911 Or CurrentSubject("municipio") = 914 Or CurrentSubject("municipio") = 923) _
                    AndAlso CurrentSubject("temperaturaPrimeras24Horas") > 38 _
                    AndAlso (CurrentSection("sintomasRespiraTos14Dias") = 1 OrElse CurrentSection("sintomasRespiraGarganta14Dias") = 1) Then

                If CurrentSubject("elegibleRespira") = 2 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente es ELEGIBLE para el estudio de RESPIRATORIO!")
                End If
                CurrentSubject("elegibleRespira") = 1
            Else
                If CurrentSubject("elegibleRespira") = 1 Then
                    MsgBox("IMPORTANTE:¡Con este cambio ahora el paciente NO es elegible para el estudio de RESPIRATORIO!")
                End If
                CurrentSubject("elegibleRespira") = 2
            End If

            'IF municipio = 'NUEVA SANTA ROSA' AND temperaturaPrimeras24Horas > 38 AND (sintomasRespiraTos14Dias = 1 OR sintomasRespiraGarganta14Dias = 1)

            ' EV_sospechosoFebril()
            ' EV_CriteriaETI_MSP()
            Study.CasoSeveroRespiratorio()

        End Sub



        Public Shared Sub EV_Departamento()

            EV_CriteriaDiarrea()
            EV_CriteriaRespira()

        End Sub



        Public Shared Sub EV_Fiebre()

            EV_FiebreOHistoriaFiebre()
            'EV_CriteriaFebril()

        End Sub



        Public Shared Sub EV_FiebreOHistoriaFiebre()
            If CurrentSubject("sintomasRespiraFiebre") = 1 OrElse _
                (CurrentSubject("sintomasFiebre") = 1 AndAlso CurrentSubject("sintomasFiebreDias") >= 0 AndAlso CurrentSubject("sintomasFiebreDias") < 7) _
            Then
                CurrentSubject("fiebreOHistoriaFiebre") = 1
            Else
                CurrentSubject("fiebreOHistoriaFiebre") = 2
            End If

        End Sub



        Public Shared Sub EV_Municipio()

            'if changed value then need to verify that municipio is still valid!

            EV_CriteriaDiarrea()
            EV_CriteriaRespira()

        End Sub



        Public Shared Sub EV_Temperatura()

            If CurrentSubject("temperaturaPrimeras24Horas") >= 38.0 Then
                CurrentSubject("sintomasRespiraFiebre") = 1
                CurrentSubject("sintomasRespiraHipotermia") = 2
            ElseIf (CurrentSubject("temperaturaPrimeras24Horas") IsNot Nothing And CurrentSubject("temperaturaPrimeras24Horas") < 35.5) Then
                CurrentSubject("sintomasRespiraFiebre") = 2
                CurrentSubject("sintomasRespiraHipotermia") = 1
            ElseIf CurrentSubject("temperaturaPrimeras24Horas") < 38.0 And CurrentSubject("temperaturaPrimeras24Horas") >= 35.5 Then
                CurrentSubject("sintomasRespiraFiebre") = 2
                CurrentSubject("sintomasRespiraHipotermia") = 2
            Else
                CurrentSubject("sintomasRespiraFiebre") = Nothing
                CurrentSubject("sintomasRespiraHipotermia") = Nothing
            End If

            EV_FiebreOHistoriaFiebre()
            EV_CriteriaRespira()
            'EV_CriteriaFebril()

        End Sub



        Public Shared Sub c_sintomasRespiraTos14Dias()

            If CurrentSection("sintomasRespiraTosDias") <= 14 Then
                CurrentSection("sintomasRespiraTos14Dias") = 1
            Else
                CurrentSection("sintomasRespiraTos14Dias") = 2
            End If

        End Sub



        Public Shared Sub c_sintomasRespiraGarganta14Dias()

            If CurrentSection("sintomasRespiraGargantaDias") <= 14 Then
                CurrentSection("sintomasRespiraGarganta14Dias") = 1
            Else
                CurrentSection("sintomasRespiraGarganta14Dias") = 2
            End If

        End Sub

    End Class




    Public Class P2A

        Public Shared Sub CreateRecord()

            CurrentSection("enfermedadesCronicasAlguna") = 2

        End Sub



        Public Shared Sub EV_EnfermedadesCronicas()

            If CurrentSection("enfermedadesCronicasAsma") = 1 _
                    Or CurrentSection("enfermedadesCronicasDiabetes") = 1 _
                    Or CurrentSection("enfermedadesCronicasCancer") = 1 _
                    Or CurrentSection("enfermedadesCronicasEnfermCorazon") = 1 _
                    Or CurrentSection("enfermedadesCronicasEnfermHigado") = 1 _
                    Or CurrentSection("enfermedadesCronicasEnfermRinion") = 1 _
                    Or CurrentSection("enfermedadesCronicasEnfermPulmones") = 1 _
                    Or CurrentSection("enfermedadesCronicasVIHSIDA") = 1 _
                    Or CurrentSection("enfermedadesCronicasOtras") = 1 _
                    Or CurrentSection("enfermedadesCronicasHipertension") = 1 _
                    Then
                CurrentSection("enfermedadesCronicasAlguna") = 1
            Else
                CurrentSection("enfermedadesCronicasAlguna") = 2
            End If

        End Sub

    End Class




    Public Class P2B

        Public Shared Sub CreateRecord()

            CurrentSection("otroTratamientoMencionoHospital") = 2

        End Sub



        Public Shared Sub EV_OtroTratamientoMencionoHospital()

            If CurrentSection("otroTratamiento1erTipoEstablecimiento") = 1 Or CurrentSection("otroTratamiento1erTipoEstablecimiento") = 2 Or CurrentSection("otroTratamiento2doTipoEstablecimiento") = 1 Or CurrentSection("otroTratamiento2doTipoEstablecimiento") = 2 Or CurrentSection("otroTratamiento3erTipoEstablecimiento") = 1 Or CurrentSection("otroTratamiento3erTipoEstablecimiento") = 2 Then
                CurrentSection("otroTratamientoMencionoHospital") = 1
            Else
                CurrentSection("otroTratamientoMencionoHospital") = 2
            End If

        End Sub

    End Class



    Public Class EpiYearWeek

        Private Shared Function GetMMWRStart(ByVal dteDateIn As Date) As Date

            '   GetMMWRStart returns the date of the start of the MMWR year closest to Jan 01
            '   of the year passed in.  It finds 01/01/yyyy first then moves forward or back
            '   the correct number of days to be the start of the MMWR year.  MMWR Week #1 is 
            '   always the first week of the year that has a minimum of 4 days in the new year.
            '   If Jan. first falls on a Thurs, Fri, or Sat, the MMWRStart date returned could be
            '   greater than the date passed in so this must be checked for by the calling Sub.

            '   If Jan. first is a Mon, Tues, or Wed, the MMWRStart goes back to the last
            '   Sunday in Dec of the previous year which is the start of MMWR Week 1 for the
            '   current year.

            '   If the first of January is a Thurs, Fri, or Sat, the MMWRStart goes forward to 
            '   the first Sunday in Jan of the current year which is the start of
            '   MMWR Week 1 for the current year.  For example, if the year passed
            '   in was 01/02/1998, a Friday, the MMWRStart that is returned is 01/04/1998, a Sunday.  
            '   Since 01/04/1998 > 01/02/1998, we must subract a year and pass Jan 1 of the new
            '   year into this function as in GetMMWRStart("01/01/1997").
            '   The MMWRStart date would then be returned as the date of the first
            '   MMWR Week of the previous year.    

            Dim dteYrBegin As Date
            Dim dblDayOfWeek As Integer
            dteYrBegin = CDate("01/01/" & CStr(Year(dteDateIn)))
            dblDayOfWeek = Weekday(dteYrBegin)
            If dblDayOfWeek <= vbWednesday Then
                Return DateAdd("d", -(dblDayOfWeek - 1), dteYrBegin)
            Else
                Return DateAdd("d", ((7 - dblDayOfWeek) + 1), dteYrBegin)
            End If

        End Function



        Public Shared Function GetEpiWeek(ByVal InputDate As Object) As Integer

            Dim strAnswer As String
            Dim dteStart As Date
            Dim lngYear As Long
            Dim strYear As String
            Dim dteQAccept As Date
            Dim intMmwrWk As Long
            Dim dteEndOfQYr As Date
            Dim intEndOfYrDay As Integer

            ' The following lines of code make sure that if a NULL (blank) date is passed into this function
            ' from Epi Info, that we don't cause an error to appear in Epi Info. Instead, we return a null
            ' value and exit the function.
            If InputDate Is Nothing Then
                Return Nothing
            End If

            dteQAccept = CDate(InputDate)

            ' get the year
            lngYear = Year(dteQAccept)

            ' convert the year to a string
            strYear = CStr(lngYear)

            dteEndOfQYr = CDate("12/31/" & strYear)
            intEndOfYrDay = Weekday(dteEndOfQYr)

            If intEndOfYrDay < vbWednesday Then
                If (DateDiff("d", dteQAccept, dteEndOfQYr) < intEndOfYrDay) Then
                    dteQAccept = CDate("01/01/" & CStr(lngYear + 1))
                End If
            End If

            dteStart = GetMMWRStart(dteQAccept)
            If dteStart > dteQAccept Then
                dteStart = GetMMWRStart(CDate("01/01/" & CStr(lngYear - 1)))
            End If
            intMmwrWk = 1 + DateDiff("w", dteStart, dteQAccept)
            strAnswer = CStr(intMmwrWk)
            If Len(strAnswer) < 2 Then strAnswer = "0" & strAnswer

            Return CInt(strAnswer)

        End Function



        Public Shared Function GetEpiYear(ByVal InputDate As Object) As Long

            Dim epiWeek As Integer
            Dim lngYear As Long
            Dim dteQDate As Date

            ' The following lines of code make sure that if a NULL (blank) date is passed into this function
            ' from Epi Info, that we don't cause an error to appear in Epi Info. Instead, we return a null
            ' value and exit the function.
            If InputDate Is Nothing Then
                Return Nothing
            End If

            dteQDate = CDate(InputDate)
            epiWeek = GetEpiWeek(dteQDate)
            lngYear = Year(dteQDate)

            ' the following two IF statements check to see if the year doesn't logically match the week number,
            ' and if so, does the appropriate modifications.
            If CInt(epiWeek) >= 52 And Month(dteQDate) = 1 Then
                lngYear -= 1
            End If

            If CInt(epiWeek) = 1 And Month(dteQDate) = 12 Then
                lngYear += 1
            End If

            ' Return EpiYear.
            Return lngYear

        End Function



        Public Shared Function GetEpiYearWeek(ByVal InputDate As Object) As String

            Dim strAnswer As String
            Dim lngYear As Long
            Dim strYear As String
            Dim dteQDate As Date

            ' The following lines of code make sure that if a NULL (blank) date is passed into this function
            ' from Epi Info, that we don't cause an error to appear in Epi Info. Instead, we return a null
            ' value and exit the function.
            If InputDate Is Nothing Then
                Return Nothing
            End If

            dteQDate = CDate(InputDate)

            strAnswer = CStr(GetEpiWeek(dteQDate))

            lngYear = Year(dteQDate)
            strYear = CStr(lngYear)
            If Len(strAnswer) < 2 Then strAnswer = "0" & strAnswer

            ' the following two IF statements check to see if the year doesn't logically match the week number,
            ' and if so, does the appropriate modifications.
            If CInt(strAnswer) >= 52 And Month(dteQDate) = 1 Then
                strYear = CStr(lngYear - 1)
            End If

            If CInt(strAnswer) = 1 And Month(dteQDate) = 12 Then
                strYear = CStr(lngYear + 1)
            End If

            ' format the answer to match the EpiYearWeek function from the EIEpiWk.DLL file
            strAnswer = strYear & ":" & strAnswer

            Return strAnswer

        End Function

    End Class

End Namespace
