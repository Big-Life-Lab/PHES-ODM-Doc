Aggregations


**[partLabel where partType == "aggregation"]** ([partID where partType == "aggregation"]): [partDesc where partType == "aggregation"]. [partInstr where partType == "aggregation"; if = NA print = F]
*"Part Type:"* [partType]
*"Aggregation Scale:"* [aggScaleID]
*"Aggregation Sets"* [in sets.csv list([setID]) where "partID" = partID]