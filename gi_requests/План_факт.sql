USE BW

SELECT 
	DATEPART(MM, mPlan.Period) as Month
	,DATEPART(YY, mPlan.Period) as Year
	,Rpt.id as Report			 
	,RptLine.id
	,Org.Name
	,RptLine.Code as Code
	,RptLine.GUID as GUID			 
	,RptLine.Parent as ParentGUID
	,RptLine.Name as RptLineName
	,SuM(mPlan.Amount) as PlanAmount
	,SuM(0) as FactAmount
FROM [map_PlanData] mPlan
	left join [map_rpt_ReportLines] RptLine ON mPlan.ReportLine = RptLine.id
	left join [map_rpt_Reports] Rpt ON RptLine.Report = Rpt.GUID
	left join [map_Organizations] Org ON mPlan.Company = Org.id
	where Period between '2021.01.01' and '2021.12.31'
	and Org.IIN = '111240008552'
	and mPlan.Version = 1
	and RptLine.GUID is not NULL
group by
	Rpt.id
	,Org.Name
	,RptLine.Report
	,RptLine.GUID
	,RptLine.Parent
	,RptLine.Code
	,RptLine.id
	,RptLine.Name
	,mPlan.Period

UNION

SELECT 
	DATEPART(MM, TrnOver.TurnoverPeriod) as Month
    ,DATEPART(YY, TrnOver.TurnoverPeriod) as Year
	,Rpt.id as Report
    ,Org.Name			 
	,RptLine.id
	,RptLine.Code as Code
	,RptLine.GUID as GUID			 
	,RptLine.Parent as ParentGUID
	,RptLine.Name as RptLineName
    ,SuM(0) as PlanAmount
	,SuM(CASE WHEN TrnOver.TypeOfTurnovers = 'Кт' then TrnOver.RegulatedAmountNew else -TrnOver.RegulatedAmountNew END) as FactAmount 
FROM [Map_Turnovers] TrnOver
	left join [map_rpt_ReportLineStructures] RptLineStr ON RptLineStr.Account = TrnOver.Account
	left join [map_rpt_ReportLines] RptLine ON RptLineStr.ReportLine = RptLine.GUID
	left join [map_ChartOfAccounts] Sc ON TrnOver.Account = Sc.id
	left join [map_ChartOfAccounts] CorSc ON TrnOver.CorAccount = CorSc.id
	left join [map_rpt_Reports] Rpt ON RptLine.Report = Rpt.GUID
	left join [map_Organizations] Org ON TrnOver.HeadCompany = Org.id
	where TurnoverPeriod between '2021.01.01' and '2021.12.31'
	and TrnOver.Base = 'upp_upnk-pv'
	and Org.IIN = '111240008552'
	and (Rpt.id = 1 or Rpt.id = 2)
	and (CorSc.Code <> '5710' or CorSc.Code is null)
group by
	Rpt.id
	,Org.Name
	,RptLine.Report
	,RptLine.GUID
	,RptLine.Parent
	,RptLine.Code
	,RptLine.id
	,RptLine.Name
	,TrnOver.TurnoverPeriod


 UNION

SELECT 
	DATEPART(MM, TrnOver.TurnoverPeriod) as Month
	,DATEPART(YY, TrnOver.TurnoverPeriod) as Year
	,Rpt.id as Report			 
	,Org.Name
	,RptLine.id
	,RptLine.Code as Code
	,RptLine.GUID as GUID			 
	,RptLine.Parent as ParentGUID
	,RptLine.Name as RptLineName
	,SuM(0) as PlanAmount
	,SuM(CASE WHEN TrnOver.TypeOfTurnovers = 'Кт' then TrnOver.RegulatedAmountNew else -TrnOver.RegulatedAmountNew END) as FactAmount 
FROM [map_Turnovers] TrnOver
	left join [map_CashFlowItems] CashFlow ON TrnOver.CashFlowItem = CashFlow.id 
	left join [map_rpt_ReportLines] RptLine ON RptLine.Code = CashFlow.Code
	left join [map_Organizations] Org ON TrnOver.HeadCompany = Org.id
	left join [map_rpt_Reports] Rpt ON RptLine.Report = Rpt.GUID
	left join [map_ChartOfAccounts] Sc ON Account = Sc.id
where TurnoverPeriod between '2021.01.01' and '2021.12.31'
	and TrnOver.CashFlowItem is not NULL
	and TrnOver.Base = 'upp_upnk-pv'
	and Org.IIN = '111240008552'
	and Rpt.id = 3
	and (Sc.Code = '1010' or Sc.Code = '1030' or Sc.Code = '1040' or Sc.Code = '1050' or Sc.Code = '1060' or Sc.Code = '1070'  or Sc.Code = '1090')
group by
	Rpt.id
	,Org.Name
	,RptLine.Report
	,RptLine.GUID
	,RptLine.Parent
	,RptLine.Code
	,RptLine.id
	,RptLine.Name
	,TrnOver.TurnoverPeriod
