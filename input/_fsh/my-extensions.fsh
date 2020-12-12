Alias: $USPatient = http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
Alias: $USEncounter = http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter
Alias: $SDCBaseQ = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire
Alias: $SDCBaseQR = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaireresponse

Extension:   PatientListQuestionnaire
Id:          patientlist-questionnaire
Title:       "Argonaut Patient List Questionnaire"
Description: "An EHR **MAY** defines additional data for the members in a Patient List using a FHIR [Questionnaire](http://hl7.org/fhir/questionnaire.html)  based on the [SDC Base Questionnaire](https://build.fhir.org/ig/HL7/sdc/StructureDefinition-sdc-questionnaire.html) profile.  This extension references the Questionnaire resource so the client app can retrieve it. The *Argonaut Patient List Member QuestionnaireResponse Extension* provides a corresponding link to the completed answers to the Questionnaire for a `Group.member`.  Note that typically the EHR and not the patient supplies the responses to the Questionnaire."
* ^context.type = #element
* ^context.expression = "Group"
* valueReference only Reference($SDCBaseQ)
* valueReference 1..1

Extension:   PatientListQuestionnaireResponse
Id:          patientlist-questionnaireresponse
Title:       "Argonaut Patient List Member QuestionnaireResponse"
Description: "An EHR **MAY** defines additional data for the members in a Patient List using a FHIR [Questionnaire](http://hl7.org/fhir/questionnaire.html)  based on the [SDC Base Questionnaire](https://build.fhir.org/ig/HL7/sdc/StructureDefinition-sdc-questionnaire.html) profile.  This extension references the [QuestionnaireResponse](http://hl7.org/fhir/questionnaireresponse.html) resource that represents the completed answers to the Questionnaire for a `Group.member`. The client app can use the reference to retrieve the data.  Note that typically the EHR and not the patient supplies the responses to the Questionnaire. The *Argonaut Patient List Questionnaire Extension* provides a corresponding link to the Questionnaire"
* ^context.type = #element
* ^context.expression = "Group.member"
* valueReference only Reference($SDCBaseQR)
* valueReference 1..1

Extension:   PatientListEncounter
Id:          patientlist-encounter
Title:       "Argonaut Patient List Member Encounter"
Description: "Some patient lists are defined by a specific encounter such as an admission list or a discharge list. For these types of patient lists, an EHR **MAY** supply a reference to a specific [Encounter](http://hl7.org/fhir/encounter.html) that is the *reason* the target patient is a member of this patient list.  This extension references the relevant Encounter resource for a `Group.member` so the client app can retrieve it.  The Encounter resource is based on the [US Core Encounter](http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter) profile."
* ^context.type = #element
* ^context.expression = "Group.member"
* valueReference only Reference($USEncounter)
* valueReference 1..1

Extension:   PatientListAppointment
Id:          patientlist-appointment
Title:       "Argonaut Patient List Member Appointment"
Description: "A reference to the Appointment that is the *reason* the target patient is a member of this Group."
* ^context.type = #element
* ^context.expression = "Group.member"
* valueReference only Reference(Appointment)
* valueReference 1..1
