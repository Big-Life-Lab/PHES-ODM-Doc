\<!\--#

Rusty, I am thinking of combing together sets, lists, and categories into one list. They are all similar. This may pose a small challenge to you since these 'lists' are identified using different approaches - and then we'd knit together by alphabetical order.

The following identifies lists.

1\) in the `sets` table, filter setID = listSet. There should be 10 parts: measure, method, domain, group, class, nomenclature, aggscale, status, partType, unit.

Each partID in the listSet becomes a heading for a list.

2\) The elements of the list are identified from the `parts` table filter partType = each of the 10 parts of the listSet. For example, filter on partType = measure. That will generate a list of measures that comprise the list or categories for the heading "measure".

3\) combine the 10 headers of the listSet with the other with the other sets. Sort by alphabetical order. Display.

\--\>

Questions for the implementation

1\) There are more then 10 parts is this intented or a typo? Bellow are the parts found in rc.3.7 with setID of listSet.
dataType
aggScale
aggSet
aggregation
attribute
class
compartment
domain
group
measure
method
missingness
missingnessSet
nomenclature
quality
qualitySet
specSet
specimen
table
unitSet
unit


2\) Is there any further filtering you want done? In the past we have discussed filterring for only inputs is this no longer the case?

3\) You wish sets and lists to be sorted alphabetically together or should that be done after. Keeping sets first and sorted then lists sorted.