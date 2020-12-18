---
tags: argo-pl
title: Interaction Summary
---

{%hackmd 6-QbndXFTIaPJVymLK9qdw %}

# Interaction Summary

[TOC]

The Patient list API uses the FHIR [Group](http://hl7.org/fhir/group.html) resource as the content model for representing the patients as `Group.members`.  It consist of three main steps as illustrated in the figure below.

![Overview of the Patient List API](https://i.imgur.com/kGiy0HA.png)

The interaction diagram below shows these steps as a series of transactions between the the Client Application ("Client") and EHR FHIR Server ("Server").

## The Group Resource

Although it may seem counter-intiutive to use the Group resource instead of the List resource for patient lists, the Group resource is better suited to meeting the use case for discovery and membership on the list.  The Group resource content model is shown below:

![The Group Resource](https://i.imgur.com/crQawgK.png)

The `member` element reference the Patient resource which represent each patient on the list. The `managingEntity` element allow search by patient list owner. The `characteristic` element allows search by the patient list member's common attributes such as location or practitioner.  The [Argonaut Patient List Characteristic Codes](/lNNapOQPQeOoiRNEb0cjSQ) is an initial set of group characteristic concepts for defining and searching for patient lists.  Further guidance and details on discovery can be found in the [Discovery of User-Facing Lists](/2Rs6Y0hQSMGdt3kImASuZg) section.

:::info
**Sidebar Group vs List Resource**: 
There is some overlapping functionality between List and Group in FHIR. The methodological difference is that:
 - Group is an actor - a collection that can be a subject of an observation, a recipient of data, etc.  It is primarily defined by criteria...
 - List on the other hand, is NOT an actor.  It is an organizer for presentation purposes only.  It is always enumerated and has no defined criteria.
 
Whether this difference merits 2 distinct resources remains an open question.  The key practical advantages of Group is:
1.  Support of the element and searchparameters for both the `type` - "person" in our case - and `managingEntity` for user and system maintained lists. In other words, it allow querying for a patient list based on multiple existing elements and search parameters without having to create extensions and custom search parameters in order to return a targeted list of lists.
1.  Ability to display the members for presrentation when fetching an individual list.

>Note that Group has no analogous search parameter to [`_list`](http://build.fhir.org/search.html#list), however this can be replicated using the [`_include`](http://build.fhir.org/search.html#include) parameter as detailed in the *Fetching User-Facing List* section [here](/tBVF57gERz-REm3_QkWtCg##Using-Includes)
:::

### Patient List Group Profile

The [Argonaut Patient List (Group) Profile](/LFIGMBDXTR-TpJ2Dt6JOxQ) has been defined for this implementation guide.  This profile sets minimum expectations for the Group resource to record, search, and fetch user-facing patient lists. It identifies the [mandatory](http://build.fhir.org/ig/HL7/US-Core/conformance-expectations.html#mandatory-elements) and [must support](http://build.fhir.org/ig/HL7/US-Core/conformance-expectations.html#must-support-elements) core elements, extensions, vocabularies and value sets which SHALL be present in the AllergyIntolerance resource when using this profile.




## Base Workflow

The following interaction diagram illustrates the basic workflow using only the FHIR RESTful search api:

```sequence
Note left of Client: 1. Discovery:\n Search for user-facing\npatient lists by querying\nthe Server Group endpoint
Client->Server:GET Group?_summary=true\n&type=person&...
Note right of Server: Return Bundle of\n summary Group resources\n(user-facing lists)\n
Server->Client: Bundle
Note left of Client: 2. Fetch Patient List:\nSelect Group resource(s)\nfrom Bundle to get\nfull resource with members\n (patients) enumerated
Client->Server:GET Group/[id]
Note right of Server: Returns full Group\n resource
Server->Client: Group/[id]
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

\* These queries may be simple patient-based FHIR queries, or based on custom patient-list extension values that have been defined in this guide.  Further guidance on these custom extensions can be found in the [Getting Additional Details About Group Members](/ux8TD8LUTpifVq4g0N7LnA) section.

{%hackmd 4AMMqV_dQqmCrx1yZibv7Q %}