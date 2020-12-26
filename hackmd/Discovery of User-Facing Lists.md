---
tags: argo-pl
title: Discovery of User-Facing Lists
---

{%hackmd 6-QbndXFTIaPJVymLK9qdw %}

#  Discovery of user-facing lists

[TOC]

```sequence
Note left of Client: 1. Discovery:\n Search for user-facing\npatient lists by querying\nthe Server Group endpoint
Client->Server:GET Group?_summary=true\n&type=person&...
Note right of Server: Return Bundle of\n summary Group resources\n(user-facing lists)\n
Server->Client: Bundle
```
A Client App can discover what patient lists it can access by querying an EHR Server using a [FHIR RESTful query](http://build.fhir.org/search.html) on the Server's [Group](http://build.fhir.org/group.html) resource endpoint. Clients **SHALL** use and Servers **SHALL** support using  the following *required* search parameters and parameter values for discovery of user-facing lists: 
- `_summary`="true"
- `type`="person".

These parameters limit the size of the returned values by omitting the potentially large array of patient references (formally `Group.member`) and explicitly limit the scope to patient lists.  The Server returns a [Bundle](http://build.fhir.org/bundle.html) of Group resources representing the user-facing lists.  Several examples of using this search syntax are provided below.

:::warning
For this specification the `_summary` elements include `Group.characteristic` *in addition to* all the standard Group summary elements.  For more information on the `_summary` parameter and the expected behavior see this [guidance](http://build.fhir.org/search.html#summary) in base specification. Servers SHOULD mark the resources with the tag SUBSETTED to ensure that the incomplete resource is not accidentally used to overwrite a complete resource.

(A [change request](https://jira.hl7.org/browse/FHIR-28208) has been approved to add isSummary flag to `Group.characteristic` to a future version of the FHIR specification)
:::


:::warning
See the [Smart App Launch Implementation Guide (FHIR IG)](http://hl7.org/fhir/smart-app-launch/history.html) specification for accessing FHIR resources by requesting access tokens from OAuth 2.0 compliant authorization servers and using OAuth scopes to communicate (and negotiate) access requirements.
:::

## Get All User Facing Lists

A Client App can discover *all* patient lists it can access by querying an EHR Server using a FHIR RESTful query on the Server's Group endpoint with the required parameters.

The Client **SHALL** use the following syntax:

`GET [Base]Group?_summary=true&type=person`

The Server **SHALL** return a search Bundle of the available Group resource in summary form representing all the available patient lists for that Client.
     
### [Example in Postman](https://documenter.getpostman.com/view/1447203/TVssj8hw#baa2835e-f3cb-4111-aab2-c705dc8d2109) :arrow_upper_right:

<!--
*Get all user-facing lists* 

**Request**:

    `GET [Base]Group?_summary=true&type=person`

**Response Body:**

{%gist Healthedata1/ef52afd5da1fe62a7be2c5379ead7284 %}
-->

## Get All User Facing Lists Managed by an Organization or Practitioner

The Group resource's `managingEntity` element defines the patient list owner. A Client App can discover all available patient lists that are managed by a particular organization or practitioner using a FHIR RESTful query on the Server's Group endpoint using the required parameters and the `managing-entity` search parameter.

:::info
the `managing-entity` [SearchParameter definition](/u8iAyzZ0SGahQdbVzYpfoQ) is extended from the base specification to allow for "OR" search parameter using multiple values separated by a comma.
(Formally it defines the element `multipleOr` = "true" with a Server conformance expectation = **MAY**.)
:::

The Client **SHALL** use the following syntax:

   `GET Group?_summary=true&type=person&managingEntity=Organization/[id]`
   or
   `GET Group?_summary=true&type=person&managingEntity=Practitioner/[id]`

The Server **SHOULD** support the managingEntity search parameter and return a search Bundle of the available Group resource in summary form representing all the available patient lists filtered by a particular managing organization or practitioner.

### [Example in Postman](https://documenter.getpostman.com/view/1447203/TVssj8hw#e19526e5-c013-4843-9238-57adcd59be79) :arrow_upper_right:

<!--
*Get all system-maintained patient lists managed by CAMBRIDGE HEALTH ALLIANCE*
       
**Request**: 
    
`GET Group?_summary=true&type=person&managingEntity=Organization%2Fe002090d-4e92-300e-b41e-7d1f21dee4c6'
    
**Response Body:**

{%gist Healthedata1/8a75d72a326e8db464028e609d1ee043 %}

-->
## Get All User Facing Lists Based on a Member Characteristic

The Group resource's `characterstic` element defines the patient list member's shared attributes such as location or practitioner. A Client App can discover all available patient lists that have a particular characteristic using a FHIR RESTful query on the Server's Group endpoint using the required parameters and the *combination* of:
1. the standard`characteristic` search parameter using an initial set of values defined by the [Argonaut Patient List Characteristic Codes](/lNNapOQPQeOoiRNEb0cjSQ):
    
    {%hackmd MX4laxCtQ3SOYVI2aOTcIw %}
    
2. the custom`value-reference` search parameters.

    :::info
    [`value-reference`](/f-1jjPG7T-Wsz4-k0XqJHg) is a custom SearchParameter defining search of the Group resource by a Group.characteristic.valueReference element value. It permits "OR" searches using multiple values separated by a comma, and "And" search searches using multiple search parameters separated by an "&".
    (Formally it defines the elements `multipleOr` = "true" and `multipleAnd` = "true" with a Server conformance expectation = **SHOULD**.)
    :::

The following table summarizes the combinations of search parameters to search by patient list characteristic:

|characteristic|code|value-reference|reference|
|:---:|:---:|:---:|:---:|
|characteristic|location|value-reference|Location/\[location\_id\]|
|characteristic|practitioner|value-reference|Practitioner/\[practitioner\_id\]|
|characteristic|organization|value-reference|Organization/\[organization\_id\]|
|characteristic|careteam|value-reference|CareTeam/\[careteam\_id\]

The Client **SHALL** use the following syntax:

   `GET Group?_summary=true&type=person&characteristic=[code]&value-reference=[reference]`


The Server **SHOULD** support search by patient list characteristic and return a search Bundle of the available Group resource in summary form representing all the available patient lists filtered by a patient list characteristic.

:::warning
These parameters do not enable a Client to filter a list client-side to show only certain members, since all the members in the patient-list are defined to meet the group characteristic.
:::
       
### [Example in Postman](https://documenter.getpostman.com/view/1447203/TVssj8hw#0b40d8fd-c1b8-4a81-accd-b051fdee3eab) :arrow_upper_right:

<!--
*Get all patient lists for location BETH ISRAEL DEACONESS HOSPITAL - PLYMOUTH*

`http://hapi.fhir.org/baseR4/Group?_summary=true&_count=50&type=person&characteristic=location&value-reference=Location/33b34318-015b-450a-ab5f-4e8b66b2654b`

**Response Body:**

{%gist Healthedata1/f82fbd16a1ec81e3ace172b97c985c8d %}
-->

{%hackmd 4AMMqV_dQqmCrx1yZibv7Q %}
