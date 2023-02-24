# Chunk Translation
During documentation it is important to translate your text over to many languages however manually populating many files is alot of work. Chunks allow specification of text for translation. However not all text can be translated so having default fall back text solves this issue.

You can use modified md comments to specify large parts of text for translation. The ` symbol at the end of the first "< ! - -"(No spaces) specifies the start of a chunk. The word inside the comment must correspond to a key within localization csv.
If no match is found then the text inside the chunk is rendered. Then any text inside will be replaced if a replacement is found within provided localization csv. Lastly the chunk must be closed by repeating the start comment except adding "/" at the end of the key name.
<!--` valid-key -->
Anything here will be replaced with content from localization csv.
<!--` valid-key/ -->

<!--` invalid-key -->
Anything here will remain as this text
<!--` invalid-key/ -->

Any text outside chunks will also remain unchanged

# RVML
Manually creating large quantities of custom tables or lists is time consuming RVML hopes to resolve this issue by allowing creation of lists, tables and anything else with md allowed stylyzing from sql database through the usage of sql similar language.

Any rvml code must be inside an rvml chunk. A similar approach thats used in RMD is used here for code chunk creation. Code chunks must have a start and an end of "```{rvml}```"

## variable creation
Copying over templates and text is time consuming so variable creation hopes to allow reuse of templates and other strings.

Inside of rvml chunk you are able to create variables to use in later quaries. Variables by themselves generate no output but are used as placeholders for actual quary calls. Variables must be declared on one line if you wish to have line breaks the <"br">(without "") must be used.
Variables are able to contain: plain text, localization text following the chunk approach mentioned above, and quary output template.

## Plain text

Below are examples of plain text variable

var iHaveNoLineBreak = I am now random text to be used later
var iHaveLineBreak = I am on a <br> new line

Variables can also contain md related formatting
var iHaveFormatting = I am **bold**

## Chunk variables

Bellow is an example of chunk translation used within a variable

var iAmTranslated = <!--` validKey2 --> I will be replaced by text from localization csv <!--` validKey2 -->

## Quary output Template

Any variable can also contain other variables within as well as any combination of plain text chunks and quarry

var iAmEverything = This stays <!--` validKey2 --> this is replaced <!--` validKey2/ --> and this comes from previously declared variable iAmTranslated

Variables within variables are instantly substituted so be careful how they are named

A quarry variable is used to communicate with the attached database and pull values from them bellow is an example

var iTalkToSQL = {After me will be a bolded value from sql **{{validSQLtableColumnName}}** and after this a non bolded column {{validColumn}} now a chunk<!--` validKey2 --> this is replaced <!--` validKey2/ --> and end it with a previously declared variable iAmEverything}

Quarry variables must be surrounded by a set of {} brackets this signals database connection. Next for any value you wish to pull from the database a double set of {{}} is used. This allows for blending of database values and other strings

## Main Quary

Once again a database connection must be opened through the usage of {}. Inside the first thing that must be done is specification of table/tables that the data will be coming from this is done through the usage of FROM:(or IN:) this is then followed by table names. If one table is used nothing special is needed however for more then 1 table the usage of [] is needed to signify array of tables. Also the sql * method can be used to pull from all tables although that is not adviced. 

### multiple tables special case

When data is being pulled from multiple tables for the purpose of filtering or just additional information it is important to specify the primary loop table. This is the table that will be looped over for the creation of lists.
This table is specified through the use of "main:" followed by name of table.

This will make the table be treated as the main table and will use foreign keys to match with other tables for the purpose of template population.

## Order

Sometimes it is important to sort the output tables to create desired flow of information.

Order allows you to select which column to use for this and the ordering will be alphabetical and can be specified in ascending or descending order.

To specify order use the "order:" keyword proceded by the column you wish to order. This column can come from any table specified using the above table selection.

A potential use case can be moving all tables containing categories to the top and continues at the bottom.

## Format

Format is used to specify the desired output template. This is done through variables or code following the quary output format explained above.

### Format Logic

Different templates are needed to display different types of data as in the case of the above categoric data example. This is done through basic if statement comperitors and column names. In the example bellow we will assign variable template for "categoricals" when categorical datatype is found and use "simple" template for everything else.
{IN:*, format((dataType == categorical) = categoricals, else = simple)}

Sometimes it is desired to filter on multiple conditions this is done through the use of "||" for "or" logical and "&&" is used for "and" logical.

{IN:*, format((dataType == categorical && exampleColumn <45) = categoricals, else = simple)}

{IN:*, format((dataType == categorical || exampleColumn <45) = categoricals, else = simple)}

# Notes for sql data

When using multiple tables all columns except keys must have unique names.

There must also exist a table containing information on the keys used across tables and how the linking is done.