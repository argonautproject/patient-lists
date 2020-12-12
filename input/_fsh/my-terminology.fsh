CodeSystem:  ArgonautGroupCharacteristicCodeSystem
Id:          argo-group-characteristic
Title:       "Argonaut Group Characteristic Code System"
Description: "Initial set of group characteristic concepts for defining and searching for patient lists."
* #location         "Location"         "Members (Patients) whose care is at the location specified by the value which references the Location resource representing the physical structures managed/operated by an organization (e.g., a ward, building, clinic, etc)"
* #team         "CareTeam"         "Members (Patients) who are under the care of the care-team specified by the value which references the CareTeam resource representing the care-team. (e.g., Respiratory Therapy CareTeam, CareTeam blue , etc)"
* #organization         "Organization"         "Members (Patients) whose care is at the organization specified by the value which references the Organization resource representing the organization. (e.g., Burgess Medical Group)"
* #practitioner         "Practitioner"         "Members (Patients) who are under the care of the practitioner specified by the value which references the Practitioner resource representing the practitioner. (e.g., Dr Leung)"


ValueSet:  ArgonautGroupCharacteristicValueSet
Id:          argo-group-characteristic
Title:       "Argonaut Group Characteristic Value Set"
Description: "Initial set of group characteristic concepts for defining and searching for patient lists."
* codes from system ArgonautGroupCharacteristicCodeSystem
