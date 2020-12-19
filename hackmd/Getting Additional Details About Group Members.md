---
tags: argo-pl
title: Getting Additional Details About Group Members
---

{%hackmd 6-QbndXFTIaPJVymLK9qdw %}

# Getting Additional Data About Group Members

[TOC]

```sequence
Note left of Client: 3. Fetch Additional Data\nabout each Patient:\nFor each member in Group\nmake a series queries*
Note right of Server: Returns search results
Client->Server:Query 1
Server->Client:
Client->Server:Query 2
Server->Client:
Client->Server:etc
Server->Client:
Note left of Client: Client Application\n processes/displays/etc\n Group Members\nto End User
```

The Group resources provides a Patient resource reference for each patient on the list. However, end users often need additional demographic, encounter or clinical data for each member on the patients list such as displayed in this mock-up of a patient list dashboard:

![](https://i.imgur.com/tblwTQj.png)
> Thank you to Epic for sharing this content © 2020 Epic Systems Corporation


Additional data is typically obtained through series of patient based FHIR RESTful queries to the EHR Server as described below. However, a patient based query isn’t always going to efficiently provide the application or end user with the data they need. Therefore, this project defines two alternative approaches using extensions to get additional data about patient list members:

1. Fetching Additional Data for Encounter and Appointment
2. Fetching Additional Data Using Questionnaire/QuestionnaireResponse


Leverage existing FHIR Models and APIs to provide the additional information in addition to patients that offers consistency, availability and scalability?

## Patient Based FHIR RESTful Queries

The Client App can fetch and process other data using patient base RESTful data query as described in the [US Core Implementation Guide](http://hl7.org/fhir/us/core/). This is the simplest approach and leverages existing FHIR Models and APIs to provide the additional information in a consistent, available and scalable manner.  Provided with the Patient resource ids, the Client can perform:
- A series of individual queries for each patient in the patient list
- One or more queries for several patients using the multiple values for the `patient` search parameter 
- A single [`batch/transaction` interactions](http://hl7.org/fhir/http.html#transaction) 

depending on the EHR Server capabilities.

The Client **SHOULD** be able to claim conformance to US Core as specified in the [US Core CapabilityStatement](http://build.fhir.org/ig/HL7/US-Core/CapabilityStatement-us-core-client.html)

The Server **SHOULD** be able to claim conformance to US Core as specified in the [US Core CapabilityStatement](http://build.fhir.org/ig/HL7/US-Core/CapabilityStatement-us-core-server.html)

--- 
The Client **MAY** support multipleOr values for the `patient` search parameter using the following syntax:

`GET [resoure type]?patient=[id1],[id2],[id3],...{&other parameters}`

The Server **SHOULD** support multipleOr values for the `patient` search parameter.

:::info
Note that this is not a US Core requirement
:::

---

The Client **MAY** support `batch/transaction` interactions using the following syntax:
~~~
POST [base]
(payload)
{
  "resourceType": "Bundle",
  "id": "[id]",
  "type": "[batch|transaction]",
  "entry": [
    {
      "request": {
        "method": "GET",
        "url": "[Patient/id]"
      }
    },
    {
      "request": {
        "method": "GET",
        "url": "[resource_type]?patient=[id]{&[other parameters]}"
      }
    },
    ...
  ]
}
~~~



The Server **SHOULD** support batch/transaction interactions returning the appropriate Bundle that contains the requested resource for each entry in the  batch request, in the same order along with the outcome of processing the entry.

### [Example in Postman](https://documenter.getpostman.com/view/1447203/TVssjURC) :arrow_upper_right:

## Fetching Additional Data for Encounter and Appointment

When the patient membership on a patient list is defined by a *particular* encounter or *particular* appointment, it may be slow or inefficient for the Client to find them using a simple patient based FHIR query. The [Argonaut Patient List (Group) Profile](/LFIGMBDXTR-TpJ2Dt6JOxQ) supports 2 extension on the `Group.member` element for directly accessing an Appointment or Encounter for each patient on the patient list:

- [Argonaut Patient List Member Appointment Extension](/ftDJ06TPRnSTCIr2fBPBpQ)
- [Argonaut Patient List Member Encounter Extension](/pLpthchtTGWjt4hqLwU8Kg)

The Server can elect to supply one or both of these extensions on `Group.member` element for each patient on the patient list.  These extensions provide references to patient [Encounter](http://hl7.org/fhir/encounter.html) or [Appointment](http://hl7.org/fhir/appointment.html) resources that the Client can efficiently fetch by performing a FHIR RESTful GET to the EHR Server.

```sequence
Note left of Client: 2. Fetch Patient List:\nSelect Group resource(s)\nfrom Bundle to get\nfull resource with members\n (patients) enumerated
Client->Server:GET Group/[id]
Note right of Server: Returns full Group\n resource
Server->Client: Group/[id]
Note left of Client: 3. Fetch appointment or\n  encounter data about\neach patient using the\n resource reference ids\n provided by Server
Client->Server:GET Appointment/[id] or\nGET Encounter/[id]
Note right of Server: Returns Appointment/Encounter\n resources
Server->Client:
Note left of Client: Client Application\n processes/displays/etc\n Group Members\nto End User
```

The equivalent search using the search parameter`_id` can also be performed and, as discussed above, multipleOR and batch/transaction interactions can be used as well.

 
The Client **SHOULD** support fetching Appointments and Encounters using the search syntax:
 
`GET [Base]Encounter/[id]` or `Get [Base]Encounter?_id=[id]`

and

`GET [Base]Appointment/[id]` or `Get [Base]Appointment?_id=[id]`
 
The Server **SHALL** return the Appointment and/or Encounter resource or Bundle containing the target resource.

The Client **MAY** support fetching Appointments and Encounters using using the multipleOR and batch/transaction interactions search syntax described in the [Patient Based FHIR RESTful Queries section](#Patient-Based-FHIR-RESTful-Queries) above

The Server **SHOULD** support multipleOr values for the `_id` search parameter and batch/transaction interactions

### [Example in Postman](https://documenter.getpostman.com/view/1447203/TVssjoHj) :arrow_upper_right:

## Fetching Additional Data Using Questionnaire/QuestionnaireResponse

The Server can elect to define a set of data to accompany a patient list and supply this definition as a [Questionnaire](http://hl7.org/fhir/questionnaire.html). The corresponding data for each patient in the patient list is represented using [QuestionnaireResponse](http://hl7.org/fhir/questionnaireresponse.html) *and is prepopulated by the Server*. The [Argonaut Patient List (Group) Profile](/LFIGMBDXTR-TpJ2Dt6JOxQ) supports 2 extension for directly accessing the Group level Questionnaire and the resultant pre-filled QuestionnaireResponse form for each patient on the patient list:

- [Argonaut Patient List Questionnaire Extension](/RgP-iegaTASWxO00CKXeEA)
- [Argonaut Patient List  Member QuestionnaireResponse Extension](/nswM55USQZWXERNSqBxBug)

This allows a wide variety of data to be associated with the patients, including custom data that is not available using a a simple patient based FHIR query.  These extensions provide references to a Questionnaire and QuestionnaireResponse resources that the Client can fetch by performing a FHIR RESTful GET to the EHR Server.

```sequence
Note left of Client: 2. Fetch Patient List:\nSelect Group resource(s)\nfrom Bundle to get\nfull resource with members\n (patients) enumerated
Client->Server:GET Group/[id]
Note right of Server: Returns full Group\n resource
Server->Client: Group/[id]
Note left of Client: 3. Fetch questionnaire using the\n resource reference id\n provided by Server
Client->Server:GET Questionniare/[id]
Note right of Server: Returns Questionnaire\n resource
Server->Client:
Note left of Client: 4. Fetch questionnaireresponse data\n for each member \nin patient list using the\n resource reference id\n provided by Server
Client->Server:GET QuestionniareResponse/[id]
Note right of Server: Returns QuestionnaireResponse\n resource
Server->Client:
Note left of Client: Client Application\n processes/displays/etc\n Group Members\nto End User
```

The equivalent search using the search parameter`_id` can also be performed and, as discussed above, multipleOR and batch/transaction interactions can be used for fetching the QuestionnaireResponse resources as well.

:::info
the [Argonaut Patient List Questionnaire Extension](/RgP-iegaTASWxO00CKXeEA?both) reference a FHIR Questionnaire based on the *SDC Base Questionnaire profile*. What is defined in the Questionnaire and how that data is pre-filled in the QuestionnaireResponse resource are implementation details that are *out of scope* for this implementation guide.  Refer to the [Structured Data Capture (SDC) Implementation Guide](http://build.fhir.org/ig/HL7/sdc/) for guidance around the use of Questionnaire and QuestionnaireResponse including:
- The detail of the *SDC Base Questionnaire profile*
- how to design questionnaires to support pre-population of answers and how to use services that support pre-populating forms. 
:::

 
The Client **SHOULD** support fetching Questionnaire and QuestionnaireResponse using the search syntax:
 
`GET [Base]Questionnaire/[id]` or `Get [Base]Questionnaire?_id=[id]`

and

`GET [Base]QuestionnaireResponse/[id]` or `Get [Base]QuestionnaireResponse?_id=[id]`
 
The Server **SHALL** return the QuestionnaireResponse and/or Questionnaire resource or Bundle containing the target resource.

The Client **MAY** support fetching QuestionnaireResponses using the multipleOR and batch/transaction interactions search syntax described in the [Patient Based FHIR RESTful Queries section](#Patient-Based-FHIR-RESTful-Queries) above

The Server **SHOULD** support multipleOr values for the `_id` search parameter and batch/transaction interactions

### [Example in Postman](/u8iAyzZ0SGahQdbVzYpfoQ) :arrow_upper_right:

{%hackmd 4AMMqV_dQqmCrx1yZibv7Q %}