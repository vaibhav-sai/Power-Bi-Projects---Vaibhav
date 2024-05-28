-- Demographic Insights

-- 1) Who prefers energy drink more?  (male/female/non-binary?) 

select gender as Gender,count(respondent_id) as Count_Of_Preference
from dim_repondents
group by gender
order by Count_Of_Preference desc;

-- 2) Which age group prefers energy drinks more?
select Age as Age_Group , count(respondent_id) as Count_Of_Preference
from dim_repondents
group by Age
order by Count_Of_Preference desc;

-- Consumer Preferences

-- 1) What are the preferred ingredients of energy drinks among respondents? 

select [Ingredients_expected] as preferred_ingredients,count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Ingredients_expected]
order by Count_of_Preference desc;

-- 2) What packaging preferences do respondents have for energy drinks?
select [Packaging_preference] as preferred_packaging,count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Packaging_preference]
order by Count_of_Preference desc;

-- Competition Analysis

--1) Who are the current market leaders?
select [Current_brands] as preferred_brands,count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Current_brands]
order by Count_of_Preference desc;

-- 2) What are the primary reasons consumers prefer those brands over ours?
select [Current_brands],[Reasons_for_choosing_brands], count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Current_brands],[Reasons_for_choosing_brands]
order by [Current_brands],Count_of_Preference desc;

-- or 
select [Reasons_for_choosing_brands], count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Reasons_for_choosing_brands]
order by Count_of_Preference desc;

-- Marketing Channels and Brand Awareness

-- 1) Which marketing channel can be used to reach more customers? 
select [Marketing_channels],count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Marketing_channels]
order by Count_of_Preference desc;

-- Brand Penetration
-- 1) What do people think about our brand? (overall rating)
select [Heard_before],count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Heard_before]
order by Count_of_Preference desc;

select [Tried_before],count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Tried_before]
order by Count_of_Preference desc;

select [Taste_experience],count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Taste_experience]
order by Count_of_Preference desc;

-- 2) Which cities do we need to focus more on? 

select c.city as city_name,c.tier,count(r.[Respondent_ID]) as count_of_responses,
ROUND((COUNT(r.Respondent_ID)*1.0/10000*100), 2) AS Percentage_of_Response 
from [dbo].[dim_cities] as c
join [dbo].[dim_repondents] as r
on c.city_id = r.city_id
group by c.city,c.tier;

-- Purchase Behavior

-- 1) Where do respondents prefer to purchase energy drinks? 
select [Purchase_location],count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Purchase_location]
order by Count_of_Preference desc;

-- 2) What are the typical consumption situations for energy drinks among respondents? 
select [Typical_consumption_situations],count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Typical_consumption_situations]
order by Count_of_Preference desc;

-- 3) What factors influence respondents' purchase decisions, such as price range and limited edition packaging? 
select [Limited_edition_packaging],count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Limited_edition_packaging]
order by Count_of_Preference desc;

select [Price_range],count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
group by [Price_range]
order by Count_of_Preference desc;

-- Product Development 

-- 1) Which area of business should we focus more on our product development? (Branding/taste/availability) 

select [Reasons_for_choosing_brands],count([Respondent_ID]) as Count_of_Preference
from [dbo].[fact_survey_responses]
where Current_brands='CodeX' 
group by [Reasons_for_choosing_brands]
order by Count_of_Preference desc;