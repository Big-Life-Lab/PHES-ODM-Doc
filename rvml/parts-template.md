
<!--` parts1 -->
# Parts

Parts are the smallest way of describing anything in the ODM. Think of the example of parts of a car. If you own a car, your garage can access a parts list that contains every part of your car -- right down to every nut and bolt. The same is true for the ODM.

The ODM has a part ID (partID) and part description (partDescription) for every measure, method and attribute. There are also partIDs for measure categories, units, aggreations, and other parts. Below is the part list.

<!--` parts1/ -->

```{rvml}```
var versionText = <!--` versionText -->Version first released: <!--` versionText/ -->
var updateText = <!--` updateText -->Version last updated: <!--` updateText/ -->

var tableRow = {<a name="{{partID}}">**{{partLabel}}**</a> partID:({{partID}})<br />{{partDesc}},<br /> partInstr_%, {{partInstr_%}}," <br /> partType_%,{{partType_%}}, "<br />status_%, {{status_%}}, versionText ,{{firstReleased}} updateText, {{lastUpdated}},"<br /> dataType_%, {{dataType_%}}}

var test_list = {<a href="#{{partID}}">**{{partLabel}}**</a> <br />}


{{filter:*, order:label = ASC ,format(tableRow)}}

```{rvml}```
