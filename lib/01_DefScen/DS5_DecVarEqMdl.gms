
* Define variable, equations, and models for LP and MCP.
*-----------------------------------------------------------------------------------------------------------------------
Positive Variables
        NPCap(Yr,HMR,MP) Nameplate Capacity [GW]
        Gen(Yr,HMR,MP,Sea,TB) Generation [GWh]
        Trans(Yr,HMRe,HMRi,Sea,TB) Interregional Transmission [GWh]
        gamma(Yr,HMR,MP) "dual on capacity retirement and investment (NPCapEq) [$/MW]"
        MCCap(Yr,RsvRg,Sea,TB) "dual on reserve margin (RsvMrgEq) [$/MW]"
        lambda(Yr,HMR,MP,Sea,TB) "dual on MP capacity (GenLeCapEq) [$/MWh]"
        AlwPrc(Yr,PPAR) "allowance price [$/ton]"
        ACAlw(Yr,PPAR,HMR,step) "number of alternative compliance allowances purchased [k tons]"
        AlwPrcCofire(YrFull,PPAR) "allowance price [$/ton]"
        PSReq(Yr,PPAR) "portfolio standarad requirement (fraction of sales) []"
        AlwPrcBank(Yr,PPAR) "Intermediate value for first year allowance price under banking [$/ton]"
        CalEDemCoeff(Yr,HMR,Sea,TB) electricity demand function coefficient (A in Q=Ap^e) [!]
        EConsStorage(Yr,HMR,MP,Sea,TB) Storage Consumption [GWh]
        ACPquantity(Yr,PPAR,HMR) Number of units of alternative compliance payments in portfolio standard program [GWh]
        CCSEmis(Yr,HMRe,HMRi,StepCCS,TypeCCS) "carbon produced in HMRe and stored in HMRi by cost step and storage type [k tons]"
        CCSEmis45q(Yr,HMRe,HMRi,StepCCS,TypeCCS) "carbon produced in HMRe and stored in HMRi by cost step and storage type subject to 45q[k tons]"
        CCSEmisNo45q(Yr,HMRe,HMRi,StepCCS,TypeCCS) "carbon produced in HMRe and stored in HMRi by cost step and storage type not subject to 45q [k tons]"
        GenCCS45q(Yr,HMR,MPCCS,Sea,TB) CCS Generation subject to 45q [GWh]
        GenCCSno45q(Yr,HMR,MPCCS,Sea,TB) CCS Generation not subject to 45q [GWh]
        EmisSect(Yr,HMR,Sector) "Emissions from other economic sectors [k tons]"
        EmisAbatement(Yr,HMR,Sector,stepAbate) "abatement from other economic sectors [k tons]"
        VMT(YrFull,HMR,VehClass,VehType) "VMT for each vehicle type [miles]"
        Veh(Yr,HMR,VehClass,VehType) "Number of vehicles of a certain type in fleet [vehicles]"
        VehSales(Yr,HMR,VehClass,VehType) "Number of vehicles sold [vehicles]"
        Cons(Yr,HMR,Sector) "Annual HMR level consumption by Sector as a variable [GWh]"
        ConsST(Yr,HMR,Sector,Sea,TB) "Annual HMR level consumption by sector, season, and timeblock"
;
Variables
        EPrcRtl(Yr,HMR,Sea) "Retail Electricity Price [$/MWh]"
        ECons(Yr,HMR,Sea,TB) Electricity Consumption [GWh]
        MCGen(Yr,HMR,Sea,TB) "dual on demand (SupDemEq) [$/MWh]"
        MCNoDsp(Yr,HMR,MP,Sea,TB) "dual on non-dispatchablility (NoDspEq) [$/MWh]"
        TotCost_YrHMR(Yr,HMR) "Total Cost by Yr,HMR [k$]"
        TotCostLP LP Total Cost [k$]
        PSPrc(Yr,PPAR) "portfolio standard price [$/MWh]"
        PSPrcBank(Yr,PPAR) "Intermediate value for first year credit price under banking [$/ton]"
        PlnREPrc(Yr,PPAR) "implicit subsidy to required renewable capacity [$/MW]"
        PlnTechPrc(Yr,HMR,Tech) "implicit subsidy to required technology capacity [$/MW]"
        CalEPrcRtl(Yr,HMR,Sea) "electricity price adder for electricity price calibration [$/MWh]"
        CalEPrcRtl2(Yr,HMR,Sea) "electricity price adder for electricity price calibration to the national average [$/MWh]"
        CalEmis(Yr) "VOM adder for national CO2 emissions calibration [$/ton]"
        CalEmisRGGI(Yr) "VOM adder for RGGI CO2 emissions calibration [$/ton]"
        CalGen(Yr,HMR,Fuel) "VOM adder generaion calibration [$/MWh]"
        CalGenPPAR(Yr,PPAR,Fuel) "VOM adder generation calibration [$/MWh]"
        CalGenTot(Yr,HMR) "VOM adder generation calibration [$/MWh]"
;
Equations
        Obj LP total cost [k$]
        ObjInt(Yr,HMR) intermediate equation: regional annual total cost [k$]
        NPCapEq(Yr,HMR,MP) "existing model plants cannot grow, new model plants cannot shrink [GW]"
        SupDemEq(Yr,HMR,Sea,TB) generation + net imports = demand [GWh]
        ConsEq(Yr,HMR,Sector) "Defining annual consumption by sector and HMR"
        ConsSTEq(Yr,HMR,Sector,Sea,TB) "season timeblock consumption is the same as consumtpion variable expanded by season and timeblock"
        RsvMrgEq(Yr,RsvRg,Sea,TB) reserve margin [GW]
        GenLeCapEq(Yr,HMR,MP,Sea,TB) MP generation <= MP gapacity [GWh]
        NoDspEq(Yr,HMR,MP,Sea,TB) non-dispatchable new MPs generate at a fixed capacity factor [GWh]
        NoDspEq2(Yr,HMR,MP,Sea,TB) exceptions to above equation [GWh]
*Storage
        StorageBalanceEq(Yr,HMR,MP,Sea) Storage Consumption and Generation must match (with efficiency) [GWh]
        StorageConsEq(Yr,HMR,MP,Sea,TB) Storage can consume no faster than their power rating [GWh]
        VAStorageEq(Yr,Sea) Constrain generation from VA pumped Hydro Facility [GWh]
        StorageCycleEq(Yr,Sea,HMR,MP) Constrain storage cycling to once per day [GWh]
*Cofire
        FossilRetrofitEq(Yr,HMR,Fuel,Tech,Eff) capacity of original plant and retrofit plant must sum to no more than the capacity of original plant [GW]
        CofireRateEq(Yr,HMR,Eff,Sea,TB) coal and coal-NG cofiring plant capacity constrained together [GW]
        CofireRateAnnEq(Yr,HMR,Eff) coal and coal-NG cofiring plant capacity constrained together [GW]
        CofireEmisCapEq(YrFull,PPAR) Covered emissions must be annually less than the cap. [k tons]
        RequireRetrofitEq(Yr,HMR,MP) Force retirement of plants that must either retrofit or retire [GW]
        CSAPRRetirementEq(Yr,HMR) Force coal plants to retire in line with CSAPR Good Neighbor [GW]
*CCS
        CCSTrans45qEq(Yr,HMR)   Carbon produced by CCS plants subject to 45q must be transported and stored [k tons]
        CCSTransNo45qEq(Yr,HMR) Carbon produced by CCS plants not subject to 45q must be transported and stored [k tons]
        CCSEmisEq(Yr,HMR,HMRi,StepCCS,TypeCCS) sum of carbon stored from plants subject to 45q and not subject to 45q [k tons]
        CCSStorEq(Yr,HMR,StepCCS,TypeCCS) no more CO2 can be stored in a given reservoir than the annual limit [k tons]
        CCSGenEq(Yr,HMR,MP,Sea,TB) Total CCS generation is the sum of CCS generation subject to 45q and not subjct to it [GWh]
        CCSGen45qEq(Yr,HMR,MP,Sea,TB) Generation at plants subject to 45q must be less than the capacity of CCS plants built in the last 12 years [GWh]
        CCSGenNo45qEq(Yr,HMR,MP,Sea,TB) Generation at plants not subject to 45q must be less than the capacity of CCS plants built more than 12 years ago [GWh]
        CCSCap(Yr,MP) "limit to national CCS growth [GW]"
*Timeblock Specific
        PeakDayEq(Yr,HMR,MP,Sea) Super peak generation equals peak generation for all but peaker plants [GWh]
        PeakNightEq(Yr,HMR,MP,Sea) Super peak generation equals peak generation for all but peaker plants [GWh]
        PeakDayEq2(Yr,HMR,MP,Sea,DayPeak) Super peak generation equals peak generation for all but peaker plants [GWh]
        PeakNightEq2(Yr,HMR,MP,Sea,NightPeak) Super peak generation equals peak generation for all but peaker plants [GWh]
        BaseLoadEq(Yr,HMR,MP,Sea,TB) Base load plants stay on in all time blocks (exempt non-disp and peakers) [GWh]
*Emissions Cap Allowance Constraints
        EmisCapEq(Yr,PPAR,step) Covered emissions must be annually less than the cap. [k tons]
        EmisCapEqBank(Yr,PPAR) Banking Constraint [k tons]
        EmisCapEqBankStep(Yr,PPAR,step) Banking Constraint with steps [k tons]
        EmisCapEqStep(Yr,PPAR,step) Limit to allowance tranches when banking [k tons]
        EmisCapEqBankCeiling(Yr,PPAR) Limit to allwances purchased at a price ceiling when banking [k tons]
*Transportation Equations
        VehStockEq(Yr,VehClass,VehType) Equation to track vehicle stock in california [vehicles]
        VehStockCompEq(Yr,VehClass,VehType)
        VehSalesCompEq(Yr,VehClass,VehType)
        VehClassMTEq(Yr,VehClass)   Equation for Vehicle Class Miles Traveled in california  [miles]
        VMTEq(Yr,VehClass,VehType) Equation for Vehicle Miles Travelled by Vehicle Type in california [miles]
        TransEmisEq(YrFull,HMR,Sector) Equation that calculates emissions related to internal combustion engines
*Other Sector Emissions Equations
        EmisSectEq(Yr,HMR,Sector) emissions from sectors other than electricity [k tons]
        EmisAbatementEq(Yr,HMR,Sector,stepAbate) emissions abatement at each cost step cannot exceed the maximum for each step [k tons]
*Portfolio Standards
        PlnTechInv(Yr,HMR,Tech) Planned investment by technology [GW]
        PlnREInv(Yr,PPAR) Planned total renewable investment [GW]
        VAMinCoal(Yr,MP) Minimum Coal Generation [GWh]
        VAMinCoalCap(Yr,MP) Minimum Coal Generation [GW]
        PSEQ(Yr,PPAR) Pollution standard equation guarantees that a certain percentage of consumption is met by demand from resources required by the standard [GWh probably]
        PSEQBank(Yr,PPAR) Pollution standard equation guarantees that a certain percentage of consumption is met by demand from resources required by the standard [GWh probably]
*Capacity, Generation, and Transmission Fixing
        CapHMRGrowthEq2(Yr,HMR) "state level capacity maximum"
        CapHMRGrowthEq(Yr,HMR,Fuel) Prevents historical maximums of capacity from being exceeded
        CapNatGrowthEq(Yr,Fuel) Prevents new capacity growth from doubling from a previous year
        FxCapEq(Yr,HMR,MP) Fixes Capacity for plants based on previous run [GW?]
        FxGenEq(Yr,HMR,MP,Sea,TB) Fix Generation [GWh]
        FxTransEq(Yr,HMRe,HMRi,Sea,TB) Fix Transmission [GWh]
        FxFuelEq(Yr,Fuel)  Fixes Capacity by fuel [GW?]
        FxGenNukeEq(Yr) Annual Nuclear generation Constraint Used to Calculate Annual PTC
*Calibration
        CalGenEq(Yr,HMR,Fuel) regional annual generation by fuel type must equal AEO [GWh]
        CalGenEq2(Yr,HMR,Fuel) regional annual generation by fuel type must equal AEO [GWh]
        CalGenPPAREq(Yr,PPAR,Fuel) regional annual generation by fuel type must equal AEO [GWh]
        CalGenTotEq(Yr,HMR) state-level annual generation must equal AEO [GWh]
        CalGenTotEq2(Yr,HMR) state-level annual generation must equal AEO [GWh]
        CalEDemEq(Yr,HMR,Sea,TB) electricity consumption must equal AEO [GWh]
        CalEmisEq(Yr) national annual CO2 emissions must equal AEO [k tons]
        CalEmisRGGIEq(Yr) RGGI annual CO2 emissions must equal AEO [k tons]
;

Parameters
        MCP_RHS(MCP_Eq,Yr) RHS values of MCP equations
        MCP_RHS_CalGen(Yr,Fuel) RHS values for MCP_CanGen equation
        MCP_RHS_CalGen2(Yr,Fuel) RHS values for MCP_CanGen equation
;
*Default is zero in general.
MCP_RHS(MCP_Eq,Yr)=0;
*For some unknown reason, this tiny bit of slack made an infeasible LP feasible in fall 2019.
MCP_RHS('MCP_MCCap',Yr)=-1E-12;
*Default for the CalGen constraint is a huge nagative to make it non-binding unless adjusted further.
MCP_RHS('MCP_CalGen',Yr)=-1E12;
MCP_RHS_CalGen(Yr,Fuel)=-1E12;
*For a tax type constraint: AEO-Haiku>=0 (works with 8F)
MCP_RHS_CalGen(Yr,Fuel)$(SimYr(Yr)=2015)=-9{fail: -8};
MCP_RHS_CalGen(Yr,Fuel)$(SimYr(Yr)=2016)=-18{fail: -17};
MCP_RHS_CalGen(Yr,Fuel)$(SimYr(Yr)>=2020)=-1;
MCP_RHS_CalGen(Yr,'Solar')$(SimYr(Yr)=2020)=-84{fail: -83};
MCP_RHS_CalGen(Yr,'Solar')$(SimYr(Yr)>=2022)=-15{fail: -14};
MCP_RHS('MCP_CalEmisRGGI',Yr)$(SimYr(Yr)=2015)=10E3{fail: 9E3};

MCP_RHS_CalGen2(Yr,Fuel)=MCP_RHS_CalGen(Yr,Fuel);

*For a subsidy type constraint: Haiku-AEO>=0 (worked with 3F-8F before inclusion on Minessota.
*MCP_RHS('MCP_CalGen',Yr)=-10;
*MCP_RHS('MCP_CalGen',Yr)$(ord(Yr)>2)=-9E-1{fail:-8E-1};
*MCP_RHS('MCP_CalEmis',Yr)=0;
*MCP_RHS('MCP_CalEmisRGGI',Yr)=0;
*MCP_RHS('MCP_CalEmisRGGI','Yr0')=-5E3{fail:-4E3};
*display MCP_RHS;

$ifthen.capmax not %UI_FxCap% == 0

*Nick, move this to DS7 at somepoint and reinstate the temporary cap variables
*Read in reference capacity
        put dummy;
        put_utility 'gdxin' / '%UI_RootDir%\..\%UI_vRS2%\Output\%UI_RefScen2%\%UI_vRS2%_%UI_RefScen2%';
        execute_load NPCap.l;
        putclose;

        NPCapMax(Yr,HMR,MP)   = NPCap.l(Yr,HMR,MP);
        NPCapFuelMax(Yr,Fuel) = sum(HMR,sum(MP,NPCap.L(Yr,HMR,MP)*MPFuel(MP,Fuel)));
        NPCap.l(Yr,HMR,MP)    = 0;

$endif.capmax


$include LPEq
Model HaikuLP /
        Obj
        ObjInt
        NPCapEq
        SupDemEq
        ConsEq
        ConsSTEq
        RsvMrgEq
        GenLeCapEq
        NoDspEq
        NoDspEq2
        StorageBalanceEq
        StorageConsEq
        VAStorageEq
        StorageCycleEq
        FossilRetrofitEq
$ifthen %UI_CofireRate% == Yes
        CofireRateEq
$endif

$ifthen %UI_CofireRateAnn% == Yes
        CofireRateAnnEq
$endif
        CofireEmisCapEq
        RequireRetrofitEq
        CSAPRRetirementEq
        PlnTechInv
        PlnREInv
        CCSTrans45qEq
        CCSTransNo45qEq
        CCSEmisEq
        CCSStorEq
        CCSGenEq
        CCSGen45qEq
        CCSGenNo45qEq
$ifthen.EPRICCSMax %UI_EPRIScen% == High

$else.EPRICCSMax
         CCSCap
$endif.EPRICCSMax

*        PeakDayEq
*        PeakNightEq
*        PeakDayEq2
*        PeakNightEq2
        BaseLoadEq
        EmisCapEq
*        EmisCapEqBank
        EmisCapEqBankStep
        EmisCapEqStep
*        EmisCapEqBankCeiling
        EmisSectEq
        EmisAbatementEq
        PSEQ
        PSEQBank

$ifthen.growth %UI_growth% == New
        CapHMRGrowthEq2
$elseif.growth %UI_growth% == Old

$ifthen.EPRIConst %UI_EPRIScen% == High
$else.EPRIConst
        CapHMRGrowthEq
$endif.EPRIConst
$endif.growth
*        CapNatGrowthEq
        FxCapEq
        FxGenEq
        FxGenNukeEq
        FxTransEq


$ifthen.vacoal %UI_VACoal% == Yes
        VAMinCoal
        VAMinCoalCap
$endif.vacoal
$ifthen.NukeFix %UI_FxNuke% == Yes
        FxGenNukeEq
$elseif.NukeFix %UI_FxNuke% == Ann
        FxGenNukeAnnEq
$endif.NukeFix
$ifthen.LDV %UI_CALDV% == Yes
        VehStockEq
*        VehStockCompEq
        VehSalesCompEq
        VehClassMTEq
        VMTEq
$endif.LDV
$ifthen.cal %UI_Cal%==Yes
        CalGenEq
        CalGenEq2
        CalGenPPAREq
        CalGenTotEq
        CalGenTotEq2
        CalEmisEq
        CalEmisRGGIEq
$endif.cal
/;
HaikuLP.TolInfRep=1E-3;
HaikuLP.OptFile=1;
HaikuLP.ScaleOpt=0;
HaikuLP.HoldFixed=1;

Equations
        MCP_NPCap(Yr,HMR,MP) "derivative of LP Lagrangian wrt NPCap [$/MW/yr]"
        MCP_Gen(Yr,HMR,MP,Sea,TB) "derivative of LP Lagrangian wrt Gen [$/MWh]"
        MCP_Trans(Yr,HMRe,HMRi,Sea,TB) "derivative of LP Lagrangian wrt Trans [$/MWh]"
        MCP_EPrcRtl(Yr,HMR,Sea) "retail electricity pricing function [k$]"
        MCP_EDem(Yr,HMR,Sea,TB) electricity demand function [GWh]
        MCP_gamma(Yr,HMR,MP) "existing model plants cannot grow, new model plants cannot shrink [GW]"
        MCP_MCGen(Yr,HMR,Sea,TB) generation + net imports = demand [GWh]
        MCP_MCCap(Yr,RsvRg,Sea,TB) reserve margin [GW]
        MCP_lambda(Yr,HMR,MP,Sea,TB) MP generation <= MP capacity [GWh]
        MCP_NoDsp(Yr,HMR,MP,Sea,TB) non-dispatchable new MPs generate at a fixed capacity factor [GWh]
        MCP_AlwSup_AlwPrc(Yr,PPAR) emissions must not exceed total allowances issued [k tons]
        MCP_PS(Yr,PPAR) portfolio standards are satisfies by a fraction of sales covered by RECs [GWh]
        MCP_EmisCapPS(Yr,PPAR) emissions must not exceed an exogneous level [k tons]
        MCP_EmisCapBank(Yr,PPAR) cumulative covered RGGI emissions must not exceed the cumulative cap [k tons]
        MCPInt_CalEPrcRtl(Yr,HMR,Sea) "seasonal electricity prices must equal AEO [$/MWh]"
        MCP_CalEDem(Yr,HMR,Sea,TB) electricity consumption must equal AEO [GWh]
        MCP_CalGen(Yr,HMR,Fuel) regional annual generation by fuel type must equal AEO [GWh]
        MCP_CalEmis(Yr) national annual CO2 emissions must equal AEO [k tons]
        MCP_CalEmisRGGI(Yr) RGGI annual CO2 emissions must equal AEO [k tons];
*$include MCPEq
Model HaikuMCP /
        MCP_NPCap.NPCap
        MCP_Gen.Gen
        MCP_Trans.Trans
        MCP_EPrcRtl.EPrcRtl
        MCP_EDem.ECons
        MCP_gamma.gamma
        MCP_MCGen.MCGen
        MCP_MCCap.MCCap
        MCP_lambda.lambda
        MCP_NoDsp.MCNoDsp
        MCP_AlwSup_AlwPrc.AlwPrc
        MCP_PS.PSPrc
        MCP_EmisCapPS.PSReq
        MCP_EmisCapBank.AlwPrcBank
        MCPInt_CalEPrcRtl.CalEPrcRtl
        MCP_CalEDem.CalEDemCoeff
        MCP_CalGen.CalGen
        MCP_CalEmis.CalEmis
        MCP_CalEmisRGGI.CalEmisRGGI
/;
HaikuMCP.SysOut=1;
HaikuMCP.OptFile=1;
HaikuMCP.TolInfRep=1E-6;
HaikuMCP.HoldFixed=1;
