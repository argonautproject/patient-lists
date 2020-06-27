# Patient Lists API

![](https://i.imgur.com/YhRyK05.png)


[TOC]


## Background

User-facing apps often need to know things like:

- "who are the patients I'm seeing today,"
- "who are the patients I'm responsible for in the hospital right now," 
- "who are the patients in this ward." 

This is core functionality supported by existing EHR systems. In FHIR, various methods have been used such as the standard search API or assembling the List or Group resource. However, no standard or guidance for creation of and manipulation of patient lists currently exists.

*Note: When we say "EHR" in this document, we don't mean to limit ourselves to electronic health record systems; the same technology can be used in HIEs, care coordination platforms, popoulation health systems, etc. Please read "EHR" here as a short-hand notation for something like "interoperable healthcare platform".*

## Goals
    
* Support interoperable and standard exchange of existing EHR supported "user-facing lists".
  - user-facing lists include both "system-maintained" and "user-maintained"(which are entirely ad-hoc - the user explicitly selects and manages members) lists
* Define a general framework using the FHIR API for exposing existing EHR user-facing patient lists so that EHR systems can expose any list they choose to define.

* API would allows user-facing apps to:
    1. Discovery of user-facing lists
        -  Search on existing list using very limited set of parameters such as "location characterstics" (for system-maintained lists) or Practitioner (for user-maintained list)
        - [? identify a "default list"]
    1. Fetching the List allowing app to enumerate members of a user-facing list 
    1. Provide a framework to convey details about the members of a list

:::info
Out of scope:
- write (create/manage) a patient list by explicit membership**
- Identify a "default list" - e.g., What list *should* start with
    -  e.g., display on user start?
:::



<!--
* Define a few common *system-maintained* list types for key use cases:

    1. All Patients by Provider
    1. Patient Rounds List by Provider
    1. Today Patients by Provider - based on timeframe ( today, tomorrow, etc)
    1. All Patients by Location
    1. All Patients by Service
    1. All Patients by Location and Status (e.g. , In hospital, discharged)
    1. [?Recently accessed]
    
   * "All patients being seen today by <<Practitioner X>>"
   * "All patients currently in <<Location Y>>"
* [?optional] create and manage a by explicit membership    
-->



## API Design Sketch


### Sequence Diagrams

Overview of Basic Transactions

Option 1:  The client can fetch and display other details about the members on the patient list using RESTful data query on USCore  ( what about GRAPHQL? )

```sequence
Note left of Client: Discovery:\n Fetch Summary of\n Patients Lists
Client->EHR FHIR Server:GET Group?...
Note right of EHR FHIR Server: Based on User\n return Bundle of \nUser Facing Lists
EHR FHIR Server->Client: Bundle
Note left of Client: End User\nselects Patient List\n they want 
Client->EHR FHIR Server:GET Group/[id]
Note right of EHR FHIR Server: Returns full Group\n resource
EHR FHIR Server->Client: Group
Note left of Client: Client Application\n MAY fetch more data for \neach member using a \nseries of FHIR API\n queries
Note right of EHR FHIR Server: Returns search results
Client->EHR FHIR Server:Query 1
EHR FHIR Server->Client:
Client->EHR FHIR Server:Query 2
EHR FHIR Server->Client:
Client->EHR FHIR Server:etc
EHR FHIR Server->Client:
Note left of Client: Client Application\n processes/displays/etc\n Group Members\nto End User
```

Option 2:  The client can fetch and display other details about the members on the patient list using *TBD* framework defined below

```sequence
Note left of Client: Discovery:\n Fetch Summary of\n Patients Lists
Client->EHR FHIR Server:GET Group?...
Note right of EHR FHIR Server: Based on User\n return Bundle of \nUser Facing Lists
EHR FHIR Server->Client: Bundle
Note left of Client: End User\nselects Patient List\n they want 
Client->EHR FHIR Server:GET Group/[id]
Note right of EHR FHIR Server: Returns full Group\n resource
EHR FHIR Server->Client: Group
Note left of Client: Client Application MAY\n fetches more data for \neach member using a \nTBD transaction
Note right of EHR FHIR Server: Returns requested data
Client->EHR FHIR Server: requests additional data for patients
EHR FHIR Server->Client:
Note left of Client: Client Application\n processes/displays/etc\n Group Members\nto End User
```

### Argonaut Patient List (Group) Profile

Rendered output [ArgonautPatientListProfile](https://healthedata1.github.io/Sushi-Sandbox/StructureDefinition-argo-patientlist.html#root)


<iframe src="https://healthedata1.github.io/Sushi-Sandbox/StructureDefinition-argo-patientlist.html#root" width="100%" height="1250">
</iframe>


or this [rendering](https://simplifier.net/snippet/ehaas/1) from Simplifier


<iframe src="https://fhir.simplifier.net/SimplifierSandbox/StructureDefinition/argo-patientlist2" width="100%" height="100%">
</iframe>

#### Questions and issue:

1. See comments in for each element by clicking on them.
1. Binding and Valueset for Characteristics:
    - Starter set:
        1.`location` see definition by clicking on the Binding 
        2. `today`. `tomorrow` ??? coded vs using Group.characteristic.period or both options 
        3. 'rounds' -whatever that means ???
1. Must  `Group.member` be a literal reference (e.g. "Patient/123" ) or can it be a logical reference (e.g a MRN ) as well ?


### Discovery of user-facing lists

```sequence
Note left of Client: Discovery:\n Fetch Summary of\n Patients Lists
Client->EHR FHIR Server:GET Group?...
Note right of EHR FHIR Server: Based on User\n return Bundle of \nUser Facing Lists
EHR FHIR Server->Client: Bundle
```


To get all user-facing lists based on user scopes, it's just FHIR Query on the [Group](http://build.fhir.org/group.html) profile using the required parameter `_summary`. What is returned is *Bundle* of Group resources.

:::info

**Sidebar Group vs List Resource**: 
There is some overlapping functionality between List and Group in FHIR. The methodological difference is that:
 - Group is an actor - a collection that can be a subject of an observation, a recipient of data, etc.  It is primarily defined by criteria...
 - List on the other hand, is NOT an actor.  It is an organizer for presentation purposes only.  It is always enumerated and has no defined criteria.
 
Whether this difference merits 2 distinct resources remains an open question.  The key practical advantages of Group is:
1.  Support of the element and searchparameters for both the `type` - "person" in our case - and `managingEntity` for user and system maintained lists. In other words, it allow querying for a patient list based on multiple existing elements and search parameters without having to create extensions and custom search parameters in order to return a targeted list of lists.
1.  Ability to display the members for presrentation when fetching an individual list.

>Note that Group has no analogous search parameter to [_list](http://build.fhir.org/search.html#list).
:::

1. **SHALL** support fetching all user-facing lists

    `GET Group?_summary=true&type=person`
    
    :::info
    Note that authorization side deals with user scopes
    :::

    **Example**

      *Assuming Client for Dr Smith, get all user-facing lists for Dr Smith* 

    **Request**:

        `GET Group?_summary=true&type=person`

    **Response Body: A Bundle of Groups ( i.e., group a,b,c )**

        (example here)

2. **SHOULD** support fetching all “system-maintained”  and  “user-maintained” lists with managingEntity`  search parameter

   `GET Group?_summary=true&type=person&managingEntity=Organization/organization-123`
   
   `GET Group?_summary=true&type=person&managingEntity=Practitioner/practioner-123`


    :::warning
    There is no Group element that defines how a member got the list which would differentiate between  user-maintained/system-maintained lists.  However, the Provenance resource could be used to provide this data. 
    :::
  


    **Example**
       *Assuming Client for Dr Smith, get all system-mantained patient lists for Dr Smith*
       
    **Request**:       
    
     `GET Group?_summary=true&type=person&managingEntity=Organization/organization-example-2`
    
    **Response Body: A Bundle of “system-maintained” lists**:

    ~~~json
    {
      "resourceType": "Bundle",
      "id": "1bd2b9a1-0feb-405c-bfb1-b4ea83f1d136",
      "type": "searchset",
      "total": 6,
      "entry": [
        {
          "fullUrl": "http://hapi.fhir.org/baseR4/Group/group-active-today-20200505060432348158",
          "resource": {
            "resourceType": "Group",
            "id": "group-active-today-20200505060432348158",
            "identifier": [
              {
                "system": "http://example.org",
                "value": "group-active-today-20200505060432348158"
              }
            ],
            "active": true,
            "type": "person",
            "actual": true,
        "name": "active-today",
        "managingEntity": {
          "reference": "Organization/example-organization-2",
          "display": "US Core Example Organization 2"
        }
      },
      "search": {
        "mode": "match"
      }
    },
    ...
    ]}
    ~~~


3. **MAY** Search on existing list using very limited set of parameter

    Searching for lists: functional requirements
     * We definitely want a way to search for all lists that a user is allowed to see
     * We definitely want a way to search for user-managed lists that are managed by a specific practitioner
     * System-managed lists and user-managed lists SHALL have a name/title
     * System-managed lists **SHOULD** support characteristics:
        - **SHOULD** have characteristics for location-based lists and maybe a couple of other categories we define; and they
        - **MAY** have characteristics for other categories
         - Servers **SHOULD** support *search* based on characteristics (things like `GET Group?characteristic-value=`)

    :::warning
    This does not enable apps to filter a list client-side to show only certain members, since all the members will meet the group characteristic.
    :::
    
    TODO:  decide on starter and add syntax and example
### Fetching the List

```sequence
Note left of Client: End User\nselects Patient List\n they want 
Client->EHR FHIR Server:GET Group/[id]
Note right of EHR FHIR Server: Returns full Group\n resource
EHR FHIR Server->Client: Group
```

The Group/List resource are enumerated ('actual' = true) lists. It would be basic FHIR RESTful GET operation **SHALL** be used to fetch the List and all the members references in it.
 
    GET Group/[id]
   
:::warning
Issue: Paging when the lists are big

See [this chat](https://chat.fhir.org/#narrow/stream/179166-implementers/topic/Operations.20to.20manage.20big.20List.20and.20Group.20resources) about managing big Group resources
:::

**Example**:

    GET Group/all-patients-example
    
**Example Response body**:

~~~    
    {
    "resourceType": "Group",
    "id": all-patients-example
    "active": true,
    "type": "person",
    "actual": true,
    "name": "all_patients",
    "managingEntity": {
        "reference": "Organization/example",
        "display": "example managingEntity"
    },   
    "member": [
        {
            "entity": {
                "identifier": {
                    "system": "http://example.org",
                    "value": "123"
                },
                "display": "Name = Amy Brown (MRN = 123)"
            },
            "inactive": false
        },
        {
            "entity": {
                "identifier": {
                    "system": "http://example.org",
                    "value": "234"
                },
                "display": "Name = Bert Black (MRN = 234)"
            },
            "inactive": false
        },
        ...
    ]
}
}
~~~

### Provide a framework to convey details about the members of a list

```sequence
Note left of Client: Client Application\n MAY fetch more data about \n members
Client->EHR FHIR Server:
EHR FHIR Server->Client:
Note left of Client: Client Application\n processes/displays/etc\n Group Members\nto End User
```

What about the rest of the columns beside patient name and id ?...

End users often sort through a list of patient to stratify them on some information about those patient.  name, age, sex, when last viewed, todo, orders, some score, etc.

Leverage existing FHIR Models and APIs to provide the additional information in addition to patients that offers consistency, availability and scalability?


Options:

1. The client can fetch and other display data using RESTful data query on USCore

```sequence
Note left of Client: Client Application\n MAY fetch more data for \neach member using a \nseries of FHIR API\n queries
Note right of EHR FHIR Server: Returns search results
Client->EHR FHIR Server:Query 1
EHR FHIR Server->Client:
Client->EHR FHIR Server:Query 2
EHR FHIR Server->Client:
Client->EHR FHIR Server:etc
EHR FHIR Server->Client:
Note left of Client: Client Application\n processes/displays/etc\n Group Members\nto End User
```
  - Get Patient List then for each member Get X resources
 

:::warning
 - This approach may be prohibitively expensive for client
 - is GraphQL an option?
:::


2. Source System can define the other display data using an existing [FHIR Questionnaire](http://build.fhir.org/questionnaire.html):

```sequence

Note left of Client: Client Application MAY\n fetches more data for \neach member using a \ntransaction defined here
Note right of EHR FHIR Server: Returns requested data
Client->EHR FHIR Server: requests additional data for patients
EHR FHIR Server->Client:
Note left of Client: Client Application\n processes/displays/etc\n Group Members\nto End User
```
  - discovery of a form definition that is bound to certain types of lists and interoperably defines each column.
  - retrieval of List along with the associated member metadata (structured or unstructured) as associated QuestionnaireResponse for each member.

3. A hybrid approach where both system and client supplied display data.

Options depend on use cases:
    - In some contexts the display data is static and known by the list source.
    - In other use cases the list source doesn't know the context of usage (e.g., an ER status board) then it is up to the client to fetch the additional data.
    
:::info
**Ideas for conveying Questionnaires with extensions**

An extension on Group that references Questionniare
then you can issue queries for the column data,
(maybe with a custom operation) i.e.

* let client issue batch queries for the columns associated row data which would be returned as FHIR QA 

* ...or a single transaction to get a Bundle with Group and QA entries or (contained QAs),  one for each member. and references via an extension on  each Group.member.

* ...or a single transaction to get a Group with extensions on each member supplying both a reference to a resource and the raw column data. 

:::

**Example** Patients with column data
      
 **Request**:
`GET http://hapi.fhir.org/baseR4/Group/1171742`

**Response body**:

:::success
#### Extensions for "column" data
We can convey these additional per-member data using wwo extensions on Group:

1) http://registry.fhir.org/argonaut/patientlistsquestionnairev1 at `Group.extension` defines a "template" of the additional columns of data in a patient list. 
2) http://registry.fhir.org/argonaut/patientlistsquestionnaireresponsev1 at `Group.member.entity.extension` contains the actual row-level data with one QuestionnaireResponse for each patient in the list.

:::

~~~js
{
  "resourceType": "Group",
  "extension": [
    {
      "url": "http://registry.fhir.org/argonaut/patientlistsquestionnairev1",
      "valueReference": "http://hapi.fhir.org/baseR4/Questionnaire/1169270"
    }
  ],
  "identifier": [
    {
      "system": "http://example.org",
      "value": "dba0a9f9-82cb-4d42-ad92-3250756a9420"
    }
  ],
  "active": true,
  "type": "person",
  "actual": true,
  "name": "ICU List",
  "managingEntity": {
    "reference": "Organization/example-organization-2",
    "display": "Dairyland Hospital"
  },
  "member": [
    {
      "entity": {
        "identifier": {
          "system": "http://example.org",
          "value": "456"
        },
        "display": "Name = Daniel Crimson (MRN = 456)",
        "extension": [
          {
            "url": "http://registry.fhir.org/argonaut/patientlistsquestionnaireresponsev1",
            "valueReference": "http://hapi.fhir.org/baseR4/QuestionnaireResponse/1169472"
          }
        ]
      },
      "inactive": false
    },
    {
      "entity": {
        "identifier": {
          "system": "http://example.org",
          "value": "567"
        },
        "display": "Name = Peter Silie (MRN = 567)",
        "extension": [
          {
            "url": "http://registry.fhir.org/argonaut/patientlistsquestionnaireresponsev1",
            "valueReference": "http://hapi.fhir.org/baseR4/QuestionnaireResponse/1171740"
          }
        ]
      },
      "inactive": false
    },
    {
      "entity": {
        "identifier": {
          "system": "http://example.org",
          "value": "901"
        },
        "display": "Name = Caleb Cushing (MRN = 901)"
      },
      "inactive": false,
      "extension": [
        {
          "url": "http://registry.fhir.org/argonaut/patientlistsquestionnaireresponsev1",
          "valueReference": "http://hapi.fhir.org/baseR4/QuestionnaireResponse/1171741"
        }
      ]
    }
  ]
}
~~~

Check column definitions by retrieving Questionnaire. 
`GET http://hapi.fhir.org/baseR4/Questionnaire/1169270`

Pulls columnar data for each patient in Group.
`GET http://hapi.fhir.org/baseR4/QuestionnaireResponse?_id=1169472,1171740,1171741`

Optionally, query other USCDI data for more information about each patient. 
`GET http://hapi.fhir.org/baseR4/Observation?subject=Patient/456`
<!--
:::info
### Creating, Managing, and Enumerating _User-maintained Lists is OUT OF SCOPE

It would be FHIR CRUD operations on a simple Group profile for specifying entries in a User-managed list.

    GET Group?managingEntity=[Practitioner or PractitionerRole or CareTeam]
    [? optional] POST Group
    [? optional] PUT Group/[id]
    [? optional] DELETE Group/[id]
    
:::warning
Would these writes be supported by the source systems? feedback not ready to support

:::
-->


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
earc