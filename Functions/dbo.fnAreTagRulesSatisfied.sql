SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnAreTagRulesSatisfied]
(
	@tags NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN (
	SELECT * FROM Tenant
	WHERE EXISTS (
		SELECT * FROM
		(
			SELECT COUNT(*) TagSetCount, SUM(HasTag) TagSetsPresent 
			FROM (
				SELECT DISTINCT SUBSTRING(Value, 0, CHARINDEX('/', Value, 0)) AS TagSetId 
				FROM [fnSplitReferenceCollectionAsTable](@tags)
			) TagSets
			LEFT JOIN (
				SELECT DISTINCT TagSetId, 1 AS HasTag 
				FROM (
					SELECT Value as TagId, SUBSTRING(V.Value, 0, CHARINDEX('/', V.Value, 0)) as TagSetId
					FROM [fnSplitReferenceCollectionAsTable](TenantTags) AS V
				) AS F
				WHERE TagId IN (
					SELECT Value 
					FROM [fnSplitReferenceCollectionAsTable](@tags)
				)
				GROUP BY TagSetId
			) T ON T.TagSetId =  TagSets.TagSetId
		) X
		WHERE TagSetCount = TagSetsPresent
	)
)
GO
