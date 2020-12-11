Description:Hey Guys,

Thanks for making some time for us. I’m impressed that we’ve already got a first draft / straw-man spec<https://hackmd.io/@jmandel/argo-lists-proposal> for communicating lists of Patients (via the Group resource). Nice work!

At Epic, we’re actively figuring out how to improve the interoperability of patient lists, and associated patient metrics for the purpose of remote patient monitoring. Current state for this type of functionality is lots and lots of HL7v2 interfaces. The need for remote monitoring (such as COVID patient monitoring) can relatively quickly emerge and fall away. A  heavy v2 approach limits the speed at which these integrations can be setup. To address this, we’re planning on creating simple web services to communicate a patient list and associated metrics which would then be merged together by the organization/application providing the monitoring. Of course, we’d prefer to follow a standard to accomplish this.

Indraroop is the developer at Epic designing this integration.

Agenda:

-          Indraroop: Explanation of need

-          Isaac: Possible technical approach

o   supportingInfo-type BackboneElement of References, with heavy use of Reference.display

-          Josh/Eric: Feedback

-          Next steps.

Looking forward to chatting with you!

additional data in addition to the patient resource. - e.g. using the reference display element.

What about the rest of the columns beside patient name , id ?...

use case to be able to sort through a list of patient to stratify them to be able to display the right metadata (data points) information about those patient.  name, age, sex, when last viewed, todo, orders, some score, etc.

Can we leverage existing FHIR Models to provide the additional information in addition to patients that offers consistency, availability and scalability.

Is this a must have or optional scope?

options:

1. Leave to to the client to fetch and display data using RESTful data query on USCore
  - Get+List+Questionnaire - 1:1  QA:Member
    - how this transaction works retrieve as a Bundle.
  - GraphQL

1. Creation of list types and define the other columns using a form definition (AKA FHIR Questionnaire):
  - discovery of form definition bound to certain types of lists
  - retrieval of List along with the associated member metadata as associated QuestionnaireResponse for each member.

framework + a couple of examples


- pre-coordinated info sent with lists shown in Example
  - operations standard canned approached

how is this better than just returning a csv?


How to provide the additional information in addition to patients
