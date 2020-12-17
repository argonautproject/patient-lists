---
tags: argo-pl
title: Conformance Expectations
---
{%hackmd 6-QbndXFTIaPJVymLK9qdw %}

# Conformance Expectations

This section outlines important definitions, interpretations, and requirements common to all Patient list actors used in this guide:

- The conformance verbs - **SHALL**, **SHOULD**, **MAY** - used in this guide are defined in [FHIR Conformance Rules](http://hl7.org/fhir/R4/conformance-rules.html).
- The [Capability Statements](/u8iAyzZ0SGahQdbVzYpfoQ) page outlines conformance requirements and expectations for the Patient List EHR Servers and Client applications, identifying the specific profiles and RESTful transactions that need to be supported. 

    :::info
    The individual Patient List profiles identify the structural constraints, terminology bindings and invariants. Similarly, the individual Patient List SearchParameters specify how they are understood by the server. However, implementers must refer to the CapabilityStatement for details on the RESTful transactions, specific profiles and the search parameters applicable to each of the Patient List actors.
    :::
- The[ US Core Conformance Expectations](http://build.fhir.org/ig/HL7/US-Core/conformance-expectations.html) page defines the rules for interpreting profile elements and subelements labeled [*Must Support*](http://hl7.org/fhir/R4/profiling.html#mustsupport) for patient list Clients and Servers.





{%hackmd 4AMMqV_dQqmCrx1yZibv7Q %}