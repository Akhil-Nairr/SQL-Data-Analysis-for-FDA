use Drugs_FDA;
          #Task 1: Identifying Approval Trends
#Determine the number of drugs approved each year and provide insights into the yearly trends.

SELECT 
    YEAR(ActionDate) AS ApprovalYear, 
    COUNT(*) AS TotalApprovals
FROM 
    RegActionDate
GROUP BY 
    ApprovalYear
ORDER BY 
    ApprovalYear;
    
#2-Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively.
#For The Highest Approvals
SELECT 
    YEAR(STR_TO_DATE(ActionDate, '%Y-%m-%d')) AS ApprovalYear, 
    COUNT(*) AS TotalApprovals
FROM 
    RegActionDate
GROUP BY 
    ApprovalYear
ORDER BY 
    TotalApprovals DESC
LIMIT 3;

#For The Lowest Approvals

SELECT 
    YEAR(STR_TO_DATE(ActionDate, '%Y-%m-%d')) AS ApprovalYear, 
    COUNT(*) AS TotalApprovals
FROM 
    RegActionDate
GROUP BY 
    ApprovalYear
ORDER BY 
    TotalApprovals ASC
LIMIT 3;

#3. Explore approval trends over the years based on sponsors.

SELECT 
    YEAR(r.ActionDate) AS ApprovalYear, 
    a.SponsorApplicant AS SponsorName, 
    COUNT(*) AS NumberOfApprovals
FROM 
    RegActionDate r
JOIN 
    Application a ON r.ApplNo = a.ApplNo -- Assuming ApplNo is the common key
GROUP BY 
    ApprovalYear, SponsorName
ORDER BY 
    ApprovalYear, NumberOfApprovals DESC;
    
    
# 4. Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.

   SELECT 
    YEAR(r.ActionDate) AS ApprovalYear, 
    a.SponsorApplicant AS SponsorName, 
    COUNT(*) AS NumberOfApprovals
FROM 
    RegActionDate r
JOIN 
    Application a ON r.ApplNo = a.ApplNo
WHERE 
    YEAR(r.ActionDate) BETWEEN 1939 AND 1960
GROUP BY 
    ApprovalYear, SponsorName
ORDER BY 
    ApprovalYear, NumberOfApprovals DESC;
 
           #Task 2: Segmentation Analysis Based on Drug MarketingStatus
#1. Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.

SELECT 
    ProductMktStatus, 
    COUNT(*) AS NumberOfProducts
FROM 
    Product
GROUP BY 
    ProductMktStatus
ORDER BY 
    NumberOfProducts DESC;
    
#2. Calculate the total number of applications for each MarketingStatus year-wise after the year2010.

SELECT 
    YEAR(r.ActionDate) AS Year, 
    p.ProductMktStatus, 
    COUNT(*) AS TotalApplications
FROM 
    Product p
JOIN 
    RegActionDate r ON p.ApplNo = r.ApplNo 
WHERE 
    YEAR(r.ActionDate) > 2010
GROUP BY 
    Year, p.ProductMktStatus
ORDER BY 
    Year ASC, TotalApplications DESC;
    
   #3 Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.

#Top MarketingStatus overall
SELECT 
    ProductMktStatus, 
    COUNT(*) AS TotalApplications
FROM 
    Product
GROUP BY 
    ProductMktStatus
ORDER BY 
    TotalApplications DESC
LIMIT 1;

#Trend for the top marketing status
SELECT 
    YEAR(r.ActionDate) AS Year, 
    COUNT(*) AS TotalApplications
FROM 
    Product p
JOIN 
    RegActionDate r ON p.ApplNo = r.ApplNo
WHERE 
    p.ProductMktStatus = 1 
    AND YEAR(r.ActionDate) > 2010
GROUP BY 
    Year
ORDER BY 
    Year ASC;
    
                #Task 3: Analyzing Products 
#1. Categorize Products by dosage form and analyze their distribution.

SELECT 
    Dosage, 
    Form, 
    COUNT(*) AS NumberOfProducts
FROM 
    Product
GROUP BY 
    Dosage, Form
ORDER BY 
    NumberOfProducts DESC, Form ASC, Dosage ASC;
    
#2. Calculate the total number of approvals for each dosage form and identify the most successful forms.

SELECT 
    Dosage, 
    Form, 
    COUNT(*) AS TotalApprovals
FROM 
    Product
GROUP BY 
    Dosage, Form
ORDER BY 
    TotalApprovals DESC, Form ASC, Dosage ASC;
#Most Succesfull Form
SELECT 
    Form, 
    COUNT(*) AS TotalApprovals
FROM 
    Product
GROUP BY 
    Form
ORDER BY 
    TotalApprovals DESC
LIMIT 1;

#3. Investigate yearly trends related to successful forms.

SELECT 
  YEAR(r.ActionDate) AS Year, 
  p.Form,
  COUNT(*) AS NumberOfProducts
FROM 
  Product AS p
JOIN 
  RegActionDate AS r ON p.ApplNo = r.ApplNo
WHERE 
  p.ProductMktStatus = 1 
GROUP BY 
  YEAR(r.ActionDate), 
  p.Form
ORDER BY 
  Year, 
  p.Form;
  
         #Task 4: Exploring Therapeutic Classes and Approval Trends
#1. Analyze drug approvals based on therapeutic evaluation code (TE_Code).


SELECT 
  p.TECode,
  YEAR(r.ActionDate) AS ApprovalYear,
  COUNT(*) AS NumberOfApprovals
FROM 
  Product AS p
JOIN 
  RegActionDate AS r ON p.ApplNo = r.ApplNo
WHERE 
  p.ProductMktStatus = 1 
GROUP BY 
  p.TECode, 
  YEAR(r.ActionDate)
ORDER BY 
  p.TECode, 
  ApprovalYear;
  
  #2. Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.

SELECT 
  ApprovalYear,
  TECode,
  NumberOfApprovals
FROM (
  SELECT 
    YEAR(r.ActionDate) AS ApprovalYear,
    p.TECode,
    COUNT(*) AS NumberOfApprovals,
    RANK() OVER (PARTITION BY YEAR(r.ActionDate) ORDER BY COUNT(*) DESC) AS TECodeRank
  FROM 
    Product AS p
  JOIN 
    RegActionDate AS r ON p.ApplNo = r.ApplNo
  WHERE 
    p.ProductMktStatus = 1 
  GROUP BY 
    p.TECode, 
    YEAR(r.ActionDate)
) AS YearlyRank
WHERE 
  TECodeRank = 1
ORDER BY 
  ApprovalYear;

