---
tags: argo-pl
title: Introduction
fhir: http://hl7.org/fhir/
---


{%hackmd 6-QbndXFTIaPJVymLK9qdw %}

![](https://i.imgur.com/7xVivVi.png)

# Introduction

[TOC]

## Background

User-facing apps often need to know things like:

- "who are the patients I'm seeing today,"
- "who are the patients I'm responsible for in the hospital right now," 
- "who are the patients in this ward." 

This is core functionality supported by existing EHR systems. However, no standard or guidance for creation of and manipulation of patient lists currently exists. In the FHIR specification, several potential options exist to represent patients and to fetch them including a using a [FHIR RESTful search](http://hl7.org/fhir/search.html) directly on the Patient resource, or assembling and fetching a list of Patient from either the [List](http://hl7.org/fhir/list.html) or [Group](http://hl7.org/fhir/group.html) resource. After reviewing each of these options, this project has determines the best approach is to use the **Group** resource for discovery and fetching of User-facing lists.

The major benefits of using Group include:

- Ability to enumerate Patients by reference using their logical FHIR (resource) ids
- Ability to enumerate and be able to search by membership *characteristics* such as location or provider
- Ability to be able to supply and to search by list ownership

In addition to a Patient resource id, end users often need addtional demographic, encounter or clinical data for each member on the patients list.  This additional data is typically obtained through series of patient based FHIR RESTful queries on the server as described in the [US Core Implementation guide](http://hl7.org/fhir/us/core/).  However, a patient based query isn’t always going to efficiently provide the application or end user with the data they need.  Therefore, this project defined alternative approaches to getting additional patient list data such as:
- the specific encounter or appointment that defines membership on the patient list
- real-time calculated scores
- dynamic graphs. 

:::info
When we say "EHR" in this document, we don't mean to limit ourselves to electronic health record systems; the same technology can be used in HIEs, care coordination platforms, popoulation health systems, etc. Please read "EHR" here as a short-hand notation for something like "interoperable healthcare platform"
:::

## Goals
    
* Support interoperable and standard exchange of existing EHR supported "user-facing lists" which include:
    1.  "system-maintained" lists (e.g., Calender for the day showing patients)
    1.  "user-maintained" lists which are entirely ad-hoc and created maintained by the user. (e.g., Patients Dr Lee wants to follow up on)
* Define a general framework using the FHIR API and Group resource for exposing existing EHR user-facing patient lists so that EHR systems can expose any list they choose to define. This API would allows user-facing apps to:
    1. Discover user-facing lists represented by the Group Resource
        -  Query the Group resource by membership characteristics using a limited set of parameters such as `location` or `practitioner`.
        -  Query the Group resource by the maintainer of the list.
    1. Fetch the Group
    2. Enumerate Group members
    3. Provide a framework to convey other details about the members of a list

:::info
Out of scope:
- Write (create/manage) a patient list
- Define patient list membership or identify "default list"
:::

<!--
## Definition of Success

By the end of 2020, Argonaut publishes an Patient LIst guide that enables an authorized SMART on FHIR client application to access patient lists for the defined use cases

- IG implemented in an open-source sandbox + sample data + demo app
- IG prototyped by at least two server vendors, tested in September connectathon
- IG prototyped by at least two client vendors, tested in September connectathon
- IG incorporates feedback from September connectathon
- IG considered "implementable" by participating EHR vendors
- At least two server vendors propose timeline to beta deployment (i.e., at real sites)
- At least two client vendors propose timeline to beta deployment (i.e., at real sites)
- Hand off to ? (FHIR-I/US Core/Other HL7 entity for Publishing)
    - [HL7 PSS]() created and presented to the HL7 FHIR-I/PA WG for sponsorship
    -->

{%hackmd 4AMMqV_dQqmCrx1yZibv7Q %}


