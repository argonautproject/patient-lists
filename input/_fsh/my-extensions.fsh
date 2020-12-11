Alias: $USPatient = http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
Alias: $USEncounter = http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter
Alias: $SDCBaseQ = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire
Alias: $SDCBaseQR = http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaireresponse

Extension:   PatientListQuestionnaire
Id:          patientlist-questionnaire
Title:       "Argonaut Patient List Questionnaire"
Description: "A reference to a form definition based on [SDC Base Questionnaire](https://build.fhir.org/ig/HL7/sdc/StructureDefinition-sdc-questionnaire.html) that can be used to define additional data for the Group members. The [Argonaut Patient List Member QuestionnaireResponse](StructureDefinition-patientlist-questionnaireresponse.html) extension provides a link to the pre-filled answers for a Group member."
* ^context.type = #element
* ^context.expression = "Group"
* value[x] only Reference
* valueReference only Reference($SDCBaseQ)

Extension:   PatientListQuestionnaireResponse
Id:          patientlist-questionnaireresponse
Title:       "Argonaut Patient List Member QuestionnaireResponse"
Description: "A reference to a QuestionnaireResponse of pre-populated form that provides additional data about the target patient. The form is defined by the [Argonaut Patient List Questionnaire](StructureDefinition-patientlist-questionnaire.html) that is bound to the Group using the Argonaut Patient List Questionnaire extension. This extension **SHALL NOT** be used if the Argonaut Patient List Questionnaire extension is not present on the Group resource"
* ^context.type = #element
* ^context.expression = "Group.member"
* value[x] only Reference
* valueReference only Reference($SDCBaseQR)

Extension:   PatientListEncounter
Id:          patientlist-encounter
Title:       "Argonaut Patient List Member Encounter"
Description: "A reference to the Encounter that is the *reason* the target patient is a member of this Group."
* ^context.type = #element
* ^context.expression = "Group.member"
* value[x] only Reference
* valueReference only Reference($USEncounter)

Extension:   PatientListAppointment
Id:          patientlist-appointment
Title:       "Argonaut Patient List Member Appointment"
Description: "A reference to the Appointment that is the *reason* the target patient is a member of this Group."
* ^context.type = #element
* ^context.expression = "Group.member"
* value[x] only Reference
* valueReference only Reference(Appointment)
