---
tags: argo-pl
title: Fetching User-Facing List
---

{%hackmd 6-QbndXFTIaPJVymLK9qdw %}

# Fetching User-Facing List

[TOC]

```sequence
Note left of Client: 2. Fetch Patient List:\nSelect Group resource(s)\nfrom Bundle to get\nfull resource with members\n (patients) enumerated
Client->Server:GET Group/[id]
Note right of Server: Returns full Group\n resource
Server->Client: Group/[id]
```

Following [Discovery of User-Facing Lists](/2Rs6Y0hQSMGdt3kImASuZg), a Client App can retreive a patient list by performing a FHIR RESTful `GET` to the EHR Server using  a Group resource id obtained in the Discovery step. The server returns a Group resource which contains resources references to each patient in the patient list (formally `Group.member.entity)`
The equivalent search using the search parameter`_id` can also be performed which will return a Bundle with the requested Group resource.

:::info
The [Argonaut Patient List (Group) Profile](/LFIGMBDXTR-TpJ2Dt6JOxQ) restricts the patient references to FHIR resource ids. Providing only a business or other identifier as a logical reference to the entity of the target resource is not supported.
:::

The Client **SHALL** use the following syntax:
 
    GET [Base]Group/[id]
    
    or 
    
    Get [Base]Group?_id=[id]
    
The Server **SHALL** return the Group resource or Bundle containing the Group resource representing the patient list.
       
:::warning

When the Patient list is too large be able to return a whole resource:
- The Server **SHOULD NOT** return first-page results as described [here](http://hl7.org/fhir/search.html#count)
- The Server **SHOULD** return an [OperationOutcome](http://hl7.org/fhir/operationoutcome.html) indicating that the client needs to call the [`$getpage`](/u8iAyzZ0SGahQdbVzYpfoQ) operation to return a Group with just the specified subset of its members (offset 0 based, default to 0).  This operation uses the following Syntax:

    `GET [Base]Group/[id]/$getPage?offset=X&count=Y`
    
(A [Change Request](https://jira.hl7.org/browse/FHIR-21650)  has been approved to add a `$getpage` operation to a future version of the FHIR specification)
:::

### [Example in Postman](https://documenter.getpostman.com/view/1447203/TVssjTjT#d9ca0bd9-b98a-4e0a-a056-5800f83119ac) :arrow_upper_right:

<!--
**Request**:

    GET Group/argo-pl-group-all-1000
    
**Response Body:**

{%gist Healthedata1/0f5ab044bd5e36ba0bfeb6a6aa745ba1 %}
-->

## Using Includes
The [`_include`](http://build.fhir.org/search.html#include) parameter can be used when fetching a Group resource to include all the Patient resources in addition to the Group when fetching the patient list.  This is a convienent way to gather the demographic data such as name, age, DOB, and gender about each patient in a single transaction and is functionally equivalent to the [`_list`](http://build.fhir.org/search.html#list) parameter defined for the List resource.

The Client **SHALL** use the following syntax:

`GET [base]/Group/[id]?_include=Group:member`

The Server **SHOULD** support the `_include` parameter and return a complete Bundle of Patient entries for each Group.member in addition to the Group resource.

### [Example in Postman](https://documenter.getpostman.com/view/1447203/TVssjTjT#47d11cce-ab4b-4d4b-a17d-af75778b3cb7) :arrow_upper_right:

<!--
**Request**:

    http://hapi.fhir.org/baseR4/Group?_id=argo-pl-group-all-1000&_include=Group%3Amember
    
**Response Body:**

{%gist Healthedata1/b8cd4c1926fce561b3e3b35dab74a623 %}
-->

{%hackmd 4AMMqV_dQqmCrx1yZibv7Q %}