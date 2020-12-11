/*
Alias: $USPatient = http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
Alias: $USPractitioner = http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner
Alias: $USOrganization = http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization

Profile:     ArgonautPatientListProfile
Parent:      Group
Id:          argo-patientlist
Title:       "Argonaut Patient List (Group) Profile"
Description: "Profile on the R4 Group resource to for [Argonaut Patient List Project](https://confluence.hl7.org/display/AP/Argonaut+Project+Home).  Note that the [Group](http://hl7.org/fhir/group.html) resource is used for this patient **list** use case even though there is also a FHIR List resource"
* extension contains PatientListQuestionnaire named q-ref 1..1
* extension[PatientListQuestionnaire] SU MS
* identifier  ^comment = "do we need to include or be silent? I think should be silent"
* active  ^comment = "do we need to include or be silent? I think should be silent"
* type = #person
* type  MS
* actual = true
* actual ^requirements = "Argo Patient Lists always list members"
* actual MS
* code        ^comment = "although generally omitted for persons I think should be silent"
* quantity MS
* quantity   ^comment = "do we need to include or be silent? I think should be silent at least until we find a need for its inclusion"
* managingEntity only Reference($USPractitioner or $USOrganization)
* managingEntity MS
* managingEntity ^requirements = "Used for searching for user or system-maintained lists"
* characteristic  ^requirements = "Used for searching for by group parameter such as location"
* characteristic MS
* characteristic.code  from ArgonautGroupCharacteristicValueSet (extensible)
* characteristic.code MS
* characteristic.value[x] ^comment = "Must Support at least ValueReference"
* characteristic.value[x] MS
* characteristic.exclude ^comment = "this is required in the base"
* characteristic.exclude MS
* characteristic.period ^comment = "this is how would support parameter for  'today' or 'tomorrow'"
* characteristic.period MS
* member MS
* member ^comment = "enumerated list of members"
* member.entity only Reference($USPatient or ArgonautPatientListProfile)
 * member.entity ^comment = "Group with different characteristics can be combined to create a union of characteristic, for example a group of patients at location = Location1 or Location2 or a group of patients at location = Location1 or Practitioner = Practitioner2"
* member.entity MS
* member.entity.extension contains PatientListQuestionnaireResponse named qr-ref 1..1
* member.entity.extension[PatientListQuestionnaireResponse] MS
* member.period ^comment = "do we need to include or be silent? I think should be silent"
* member.inactive ^comment = "do we need to include or be silent? I think should be silent"
*/
/*
CodeSystem:  ArgonautGroupCharacteristicCodeSystem
Id:          argo-group-characteristic
Title:       "Argonaut Group Characteristic Code System"
Description: "Used to define group characteristic and limited to 'location'or 'team' or 'organization' or 'practitioner'"
* #location         "Location"         "Members (Patients) whose care is at the location specified by the value which references the Location resource representing the physical structures managed/operated by an organization (e.g., a ward, building, clinic, etc)"
* #team         "CareTeam"         "Members (Patients) who are under the care of the care-team specified by the value which references the CareTeam resource representing the care-team. (e.g., Respiratory Therapy CareTeam, CareTeam blue , etc)"
* #organization         "Organization"         "Members (Patients) whose care is at the organization specified by the value which references the Organization resource representing the organization. (e.g., Burgess Medical Group)"
* #practitioner         "Practitioner"         "Members (Patients) who are under the care of the practitioner specified by the value which references the Practitioner resource representing the practitioner. (e.g., Dr Leung)"


ValueSet:  ArgonautGroupCharacteristicValueSet
Id:          argo-group-characteristic
Title:       "Argonaut Group Characteristic Value Set"
Description: "Used to define group characteristic and limited to 'location'or...."
* codes from system ArgonautGroupCharacteristicCodeSystem
*/
