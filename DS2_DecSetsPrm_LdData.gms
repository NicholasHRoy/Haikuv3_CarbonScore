* Declare sets (that are not subsets of sets that will load with data) and parameters.
*-----------------------------------------------------------------------------------------------------------------------

Sets
        YrFull Full Set of Years
        Yr(YrFull) Year
        map_Yr_YrFull(Yr,YrFull) map year to year full
        YrFullHist Full Set of Historical Years /Yr0,Yr-1*Yr-17/
        Year Numerical years /1960*2050/
        HMR Haiku Market Region It would be great to deal with the order of HMR. Why is CT first and the rest alphabetical? ap180405
        MP Model Plant
        MPEx(MP) Existing MPs
        MPNew(MP) New MPs
        MPExNew(MPEx,MPNew) Mapping between Ex and New Model Plants
        Tech Generation Technology /Steam, CC, CT, Hydro, Solar, Onshore, Offshore, CHP, IC, Battery, Pumped, Oth/
        Fuel Fuel Type /Coal, NG, Oil, Nuke, Hydro, Wind, Solar, Bio, Geo, Storage, Oth/
        FuelStorage(Fuel) subset of fuel for storage /Storage/
        Eff Eff MP Characteristics
        MPEff(MP,Eff) Mapping between fossil MPs and efficiencies
        HMRMP(HMR,MP) Sparse HMR x MP
        Month Month /Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec/
        Sea Season /Sum, Win, SF/
        TB Time Block /1, 2, 3, 4, 5, 6, 7, 8/
        Day(TB) Daytime Time Blocks /1, 2, 3, 4/
        Night(TB) Nighttime Time Blocks /5, 6, 7, 8/
        DayPeak(TB) Daytime Non-baseload Time Blocks /2, 3, 4/
        NightPeak(TB) Nighttime Non-baseload Time Blocks /6, 7, 8/
        CC Customer Class /Res, Com, Ind, EVs, Trn, Tot/
        Sector(CC)/Res, Com, Ind, EVs, Trn/
        Other(Sector)/Res, Com, Ind, Trn/
        HMRCC(HMR,CC) Sparse HMR x CC
        EPrcRtlCmp "Retail Electricity Price Components (Transmission, Distribution, Generation)" /Tmn, Dst, Gen/
        Pol Pollutant /CO2, SO2, NOx/
        PPAR "Pollution Policy Aggregation Region"
*        RsvRg regions for reserve margins /CA,FL,NE,NY,TX,PJM,SERC,MISON,MISOS,SPP,RMPA,AZNM,NWPP/
        RsvRg regions for reserve margins
        map_RsvRg(HMR,RsvRg) mapping of HMRs to reserve regions
        CostScen NREL cost projection levels /Conservative, Moderate, Advanced/
        step steps in allowance supply staircase /s1*s6/
        stepAbate steps in abatement supply staircase /s1*s200/
        Scenario /NA, BAU, SP, BAU0, Alt3/
        VehClass Vehicle Class Types /Bus, HDV, LDV, MDV/
        VehType Vehicle Type /CNG, Diesel, Elec, Gas, PHEV, Hydrogen/
        StepCCS /STEP1*STEP19/
        TypeCCS /eor,saline/
        Scen /reference, low, medium, high, technical/
        AEOscen set of AEO scenarios /REF,LP,HP,LR,HR,LO,HO,LM,HM, ref2023, lowogs, highogs, noIRA/
        FuelTechVin /'Ex Coal', 'Retrofit Coal CCS', 'Coal CCS', 'Coal Cofire 20', 'Coal Cofire 60', 'Coal Cofire 100',
                     'Ex NG', 'Rerofit NG CCS', 'New NG CCS', 'New NG CC', 'New NG CT', 'Ex NG CT','Ex NG CC','Ex NG CHP','Ex NG IC',
                     Oil, Nuke, Hydro, 'Pumped Hydro', Bio, Solar, 'Onshore Wind', 'Offshore Wind', Geo, Storage, Other/
;
Alias(  HMR,HMRe,HMRi);
Alias(  Yr,Yrdup);
Alias(  YrFull,YrFulldup);
Alias(  HMR,HMRdup);
Alias(  MP,MPdup);
Alias(  Fuel,Fueldup);
Alias(  Sea,Seadup);
Alias(  TB,TBdup);
Alias(  step,stepdup);
Alias(  sector,sectordup);
Alias(  other,otherdup);
Alias(  StepCCS,StepCCSdup);
Alias(  TypeCCS,TypeCCSdup);
Alias(VehClass,VehClassdup);
Alias(VehType,VehTypedup);

Sets
        HMRei(HMRe,HMRi) HMRe x HMRi
        MCP_VarEq MCP variables and equations /
*VarCore
                NPCap, Gen, Trans
                EPrcRtl, ECons
                gamma, MCGen, MCCap
                lambda, MCNoDsp
                AlwIss, AlwPrc, AlwAlc
                PSPrc, PSReq
                AlwPrcBank
*VarCal
                CalEPrcRtl, CalEPrcRtl2, CalEDemCoeff, CalGen
                CalEmis, CalEmisRGGI
*EqCore
                MCP_NPCap, MCP_Gen, MCP_Trans
                MCP_EPrcRtl, MCP_EDem
                MCP_gamma, MCP_MCGen, MCP_MCCap
                MCP_lambda, MCP_NoDsp
                MCP_AlwSup_AlwIss, MCP_AlwSup_AlwPrc, MCP_AlwAlc
                MCP_PS, MCP_EmisCapPS
                MCP_EmisCapBank
*EqCal
                MCPInt_CalEPrcRtl, MCP_CalEDem, MCP_CalGen
                MCP_CalEmis, MCP_CalEmisRGGI /
        MCP_Var(MCP_VarEq) MCP variables /
                NPCap, Gen, Trans
                EPrcRtl, ECons
                gamma, MCGen, MCCap
                lambda, MCNoDsp
                AlwIss, AlwPrc, AlwAlc
                PSPrc, PSReq
                AlwPrcBank
                CalEPrcRtl, CalEDemCoeff, CalGen,
                CalEmis, CalEmisRGGI /
        MCP_VarCore(MCP_Var) core MCP variables
        MCP_VarCal(MCP_Var) MCP calibration variables /
                CalEPrcRtl, CalEDemCoeff, CalGen
                CalEmis, CalEmisRGGI /
        MCP_Eq(MCP_VarEq) MCP equations /
                MCP_NPCap, MCP_Gen, MCP_Trans
                MCP_EPrcRtl, MCP_EDem
                MCP_gamma, MCP_MCGen, MCP_MCCap
                MCP_lambda, MCP_NoDsp
                MCP_AlwSup_AlwIss, MCP_AlwSup_AlwPrc, MCP_AlwAlc
                MCP_PS, MCP_EmisCapPS
                MCP_EmisCapBank
                MCPInt_CalEPrcRtl, MCP_CalEDem, MCP_CalGen
                MCP_CalEmis, MCP_CalEmisRGGI /
        MCP_EqCore(MCP_Eq) core MCP equations
        MCP_EqCal(MCP_Eq) MCP calibration equations /
                MCPInt_CalEPrcRtl, MCP_CalEDem, MCP_CalGen
                MCP_CalEmis, MCP_CalEmisRGGI /
;
MCP_VarCore(MCP_Var)= not MCP_VarCal(MCP_Var);
MCP_EqCore(MCP_Eq)= not MCP_EqCal(MCP_Eq);

Scalars
        assert Error Detection
        betaRt Discount Rate [] /0.06/
        betaRtRE Discount Rate for Annualized Capital Cost of RE if loan program activated /0.01/
        InvPlnHrzn investment planning horizon [yrs] /20/
        EDemElast Elasticity of Electricity Demand Functions [] /-0.2/
        HrsAnn Hours per year [hrs]
        DataYr year of initial data
        SimYrLast last simulation year
        EECostYr1 "cost of first-year energy efficiency consumption reductions [$/MWh]" /180/
        EEDecay "duration of energy efficiency invesment decay [yrs]" /10/
        EEDecayPct "Percent of energy efficiency decay" /.11/
        TCWindow "time window that a plant is eligble to receive tax credits" /10/
        TCWindow45Q "time window that a plant is eligble to receive 45Q tax credits" /12/
        TCHaircut "share of tax credit value received when tax credits aren't direct pay" /0.87/
        CoalHRScalar /1.10/
        NGHRScalar /1.08/
        MtSt /1.103/
        ZEVRatio /3/

;

Parameters
*inputs
        RsvMrg(Yr,RsvRg) reserve margin []
        SimYr(Yr) simulation years []
        SimYrFull(YrFull) simulation years for all years
        SimYrFullHist(YrFullHist) simulation years for all historical years
        SimYear(Year) simulation years for all years in the year set
        SimYrWgtKnl(YrFull,Yr) weight on each Yr by YrFull for linear interpolation []
        SimYrWgt(Yr) weight on SimYrs for linear interpolation and discounting []
        Inflation(Year) inflation index []
        Hrs(Sea,TB) "Hours per Sea/TB [hrs]"
        s(step)   order of steps in allowance supply curve
        NPCap0(HMR,MP) Initial Nameplate Capacity [GW]
        NPCapPenalty(HMR,MP) Capacity Penalty for CCS plants []
        NPCapMax(Yr,HMR,MP) Maximum Capacity determined by baseline run [GW]
        NPCapFuelMax(Yr,Fuel) Maximum Capacity by fuel determined by baseline run [GW]
        NewNPCapFuelMax(YrFull,Fuel) Maximum new capacity investments by fuel
        CalNPCap(Yr,HMR,MP) Nameplate Capacity in calibration run [GW]
        WinCap0(HMR,MP) Win Initial Nameplate Capacity [GW]
        SumCap0(HMR,MP) Sum Initial Nameplate Capacity [GW]
        OpNPCapRat(HMR,MP,Sea) "Ratio of operational to nameplate capacity []"
        NetGen0(HMR,MP) "Data Year Electricity Generation [GWh] for non-dispatchables"
        NetGenSea(HMR,MP,Sea) "Exogenous Seasonal Electricity Generation [GWh]"
        PNG0(HMR,MP,Month) "Percent of NetGen0 in each month [%]"
        HR0(HMR,MP) "Initial Heat Rate [Btu/kWh]"
        HR(Yr,HMR,MP) "Heat Rate [Btu/kWh]"
        HRPenalty(HMR,MP) "Heat Rate Penalty for CCS retrofits []"
        EFORd0(HMR,MP) Availability Factor []
        WSOF0(HMR,MP) Availability Factor []
        ERinCO20(HMR,MP) "initial CO2 emissions rate per unit input [lb/MMBtu]"
        ERinSO20(HMR,MP) "initial SO2 emissions rate per unit input [lb/MMBtu]"
        ERinNOx0(HMR,MP) "initial NOx emissions rate per unit input ki9 [lb/MMBtu]"
        ERinCO2(YrFull,HMR,MP) "CO2 emissions rate per unit input [lb/MMBtu] with variation across years"
        ERinSO2(YrFull,HMR,MP) "SO2 emissions rate per unit input [lb/MMBtu] with variation across years"
        ERinNOx(YrFull,HMR,MP) "NOx emissions rate per unit input ki9 [lb/MMBtu] with variation across years"
        ERo(Yr,HMR,MP,Pol) "emissions rates per unit output [tons/MWh]"
        ERoCCS(Yr,HMR,MP) "emissions captured at a CCS plant per unit of net electricity output [tons/MWh]"
        PolScl(Pol) "k tons -> CO2: M tons; SO2,NOx: k tons]" /CO2 1E-3, SO2 1, NOx 1/
        PolSclER(Pol) "tons -> CO2: tons; SO2,NOx: lbs]" /CO2 1, SO2 2E3, NOx 2E3/
        CapCost0AEO(YrFull,HMR, MP) Regional capital costs from reference AEO scenario
        CapCost0NatAEO(YrFull,MP) National capital costs from reference AEO scenario
        CapCostNREL(YrFull,MP,CostScen) "Capital Costs from NREL ATB [$/kW]"
        CapCostHMScl(HMR,MP) Scale factor that when multiplied by CapCost0 will regionalize capital costs by HMR MP
        CapCostNRELScl(YrFull,MP) Scale factor that when multiplied by CapCost0 will change it to NREL costs
        CapCostAnnScl(YrFull,MP) Scale factor that when multiplied by CapCost0 will generate the price path for Capital Costs according to AEO
        CapCostScl(YrFull,HMR,MP) Final Scaling factor for CapCost0
        CapCostOvernight(YrFull,HMR,MP) "Overnight Capital Costs after scaling [$/kW]"
        AF(Yr,HMR,MP,Sea,TB) Availability Factor []
        CFSea(Yr,HMR,MP,Sea) Capacity Factor by Season []
        CF(Yr,HMR,MP,Sea,TB) Capacity Factor by Season and Timeblock []
        SolarAF(HMR,Sea,TB) Solar Capacity Factor []
        WindAF(HMR,Tech,Sea,TB) New Wind Capacity Factor []
        WindMaxCap(HMR,Tech) New Wind Maximum Capacity [GW]
        ACFGen(Yr,HMR,MP,Sea,TB) "capacity factor for non-dispatchables, availibility factor otherwise []"
        ACFRsv(Yr,HMR,MP,Sea,TB) "capacity factor for non-reservers, availibility factor otherwise []"
        CalACFGen(Yr,HMR,MP,Sea,TB) "calibrator capacity factor for non-dispatchables, availibility factor otherwise []"
        CalACFRsv(Yr,HMR,MP,Sea,TB) "calibrator capacity factor for non-reservers, availibility factor otherwise []"
        CalRsvMrg(Yr,RsvRg) "calibrator reserve margin []"
        FC0(HMR,MP) "Fuel Cost from SNL [$/MWh]"
        FCo(Yr,HMR,MP,Sea) "Fuel Cost per unit output [$/MWh]"
        FuelConsRef(Yr,HMR,Fuel) "Reference annual fuel consumption [TBtu]"
        FCiRef(Yr,HMR,Fuel) "Reference annual average fuel cost per unit input [2016 $/MMBtu]"
        VOM0(HMR,MP) "Initial Variable O&M Cost [$/MWh]"
        VOM(YrFull,HMR,MP) "Variable O&M Cost [$/MWh]"
        FOM0(HMR,MP) "Initial Fixed O&M Cost [$/kW/yr]"
        FOM(YrFull,HMR,MP) "Fixed O&M Cost [$/kW/yr]"
        CapCost0(HMR,MP) "Overnight Capital Cost [$/kW]"
        CapCost(YrFull,HMR,MP) "Annualized Capital Cost [$/kW/yr]"
        CofirePct(HMR,MP) "Percent cofiring permitted at coal plants [%]"
        LookBack "Number of years of lookback for cofiring compliance [years]"
        VAStorageMax(Sea) "Maximum seasonal generation from VA bath county pumped hydro facility [GWh]"
        TransCap0(HMRe,HMRi) Initial Transmission Capability [GW]
        TransCapMax0(HMRe,HMRi) Initial maximum transmission capability [GW]
        TransCap(Yr,HMRe,HMRi,Sea) Interregional Transmission Capability [GW]
        TransFx(Yr,HMRe,HMRi,Sea,TB) Interregional Transmission Quantity when fixed [GWh]
        CalTrans(Yr,HMRe,HMRi,Sea,TB) Interrregional transmission from calibrator [GWh]
        NetImp(Yr,HMR,Sea,TB) Net international imports (Canada & Mexico) [GWh]
        CHPExo(Yr,HMR,Sea,TB) non-utility CHP [GWh]
        RGGICap(Yr) RGGI cap [M tons]
        RPS0(YrFull,HMR) RPS levels per state [%]
        ACPprice(Yr,PPAR,HMR) "Alternative Compliance Payment price for RPS [$/MWh]"
        NPCapTarget(YrFull,HMR,Tech) Policy-derived capacity targets by state [GW]
        NPCapTargetAEO(YrFull,HMR,Tech) Policy-derived capacity targets by state [GW]
        StorageDuration(HMR,MP) "Duration of energy storage [hrs]"
        StorageEff(HMR,MP) "Efficiency for strage MPs"
        CCSCost(HMRe,HMRi,StepCCS,TypeCCS) "CCS transportation and storage cost [$/ton]"
        CCSStorMax(HMR,StepCCS,TypeCCS)   "CCS maximum storage capacity at each cost point [ton]"
        CCSCapMax(Yr,MP) "national maximum CCS capacity [GW]"
        RetrofitYr(MP)   "Year by which a plant must either retire or be replaced by a retrofit plant [year]"
        EConsRefMC(Yr,Month,HMR,CC) Reference monthly electricity consumption by CC [GWh]
        ERevRefMC(Yr,Month,HMR,CC) Reference monthly electricity revenues by CC [M$]
        EConsTBpctSea(Yr,HMR,Sea,TB) Fraction of seasonal electricity consumption in each TB [%]
        EConsTBpctAnn(Yr,HMR,Sea,TB) Fraction of Annual electricity consumption in each TB [%]
        EConsEVTBpctSea(Yr,HMR,Sea,TB) Fraction of seasonal electricity consumption by EVs in each TB [%]
        EConsEVTBpctAnn(Yr,HMR,Sea,TB) Fraction of Annual electricity consumption by EVs in each Sea TB [%]
        EConsOtherTBpctSea(Yr,HMR,Sea,TB) Fraction of seasonal electricity consumption by all but EVs in each TB [%]
        EConsOtherTBpctAnn(Yr,HMR,Sea,TB) Fraction of seasonal electricity consumption by all but EVs in each TB [%]
        EPrcRtlCmpRef(Yr,HMR,EPrcRtlCmp) "Reference annual average retail electricity price components [$/MWh]"
        Cons0(Yr,HMR,Sector)   "Annual consumption by sector [GWh]"
        SeaPctAnn(Yr,HMR,Sea,Sector)  "Seasonal consumption as a % of annual consumption by sector [%]"
        TBpctSea(Yr,HMR,Sea,TB,Sector) "TB consumption as a % of seasonal consumption by sector [%]"
        EConsRef(Yr,HMR,Sea,TB) Reference electricity consumption [GWh]
        ERevRef(Yr,HMR,Sea,TB) Reference electricity revenues [M$]
        EPrcRef(Yr,HMR,Sea,TB) "Reference electricity prices [$/MWh]"
        EDemSlp(Yr,HMR,Sea,TB) "Slope of Electricity Demand Functions [Wh^2/$]"
        EConsShkAdd(Yr,HMR,Sea,TB) electricity consumption shock [GWh]
*-------CA emissions parameters
        EmisSector0(Yr,HMR,Sector) "emissions from sectors other than electricity [k tons]"
        AbatementPrice(Yr,HMR,Sector,stepAbate) "price of abatement [$ / k ton]"
        AbatementStepMax(Yr,HMR,Sector,stepAbate) "maximum emissions abated at each price step [ktons]"
        AbatementElasticity(Yr,HMR,Sector) "% decrease in emissions per $1 increase in carbon price"
        CrossElasticity(Yr,HMR,Sector) "% change in electricity consumption per % $1 increase in carbon price"
        ConsPerEmisAbate(Yr,HMR,Sector) "Cons increase [GWh] per unit emissions abatement [k tons]"
        LDVEmisTest(YrFull,Scenario)
        TransEmisTest(YrFull,Scenario)
        Veh0(YrFull,VehClass,VehType,Scenario)
        VehSales0(YrFull,VehClass,VehType,Scenario)
        VehRtr0(YrFull,VehClass,VehType,Scenario)
        MPV0(YrFull,VehClass,VehType,Scenario)  "Amount a given vehicle type is driven [miles/vehicle]"
        MPV(Yr,HMR,VehClass,VehType) "Amount a given vehicle type is driven after adjusting efficiency rates for real world values [miles/vehicle]"
        MPGe(YrFull,VehClass,VehType,Scenario) "Average miles per gallon of fleet"
        VehEnergy0(YrFull,VehClass,VehType,Scenario) "[gallons : gassoline and diesle; GWh : electricity; cubic meters : CNG]"
        PlnVehRtr(Yr,HMR,VehClass,VehType)
        VMT0(YrFull,VehClass,Scenario)
        CO2perMi(YrFull,VehClass,VehType,Scenario)
        Classwgt(YrFull,VehClass,VehType)
        SalesPct(Yr,VehClass,VehType)
        VMTwgt(YrFull,VehClass,VehType,Scenario)
        EVMTwgt(YrFull,VehClass,Scenario)
        ICEVMTwgt(YrFull,VehClass,Scenario)
        GWhperMi(YrFull,VehClass,VehType,Scenario)
        BattEffReScl(YrFull,VehClass,VehType,Scenario)
        Cons0Trans(YrFull,Scenario)
        testVMTdemand(Yr)
*------Transportation Sector Paramaters
        NRELCons(Scen,YrFull,HMR,CC) "electricity consumption from NREL electrification futures study [GWh]"
        beta(YrFull) Discount Factor []
        VOMCoeff(Yr,HMR,MP) "Variable O&M Cost Coefficient [$/MWh]"
        VOMSlpDen VOM Slope Denominator [GWh]
        VOMSlp "Slope of Variable O&M Cost [$/MWh^2]"
        FOMCoeff(Yr,HMR,MP) "Fixed O&M Cost Coefficient [$/kW/yr]"
        FOMSlpDen FOM Slope Denominator [GWh]
        FOMSlp "Slope of Fixed O&M Cost [$/kW^2/yr]"
        TransCost(HMRe,HMRi) "Interregional Transmission Cost [$/MWh]"
        TransCostCoeff(HMRe,HMRi) "Transmission Cost Coefficient [$/MWh]"
        TransCostSlpDen Transmission Cost Slope Denominator [GWh]
        TransCostSlp "Slope of Transmission Cost [$/MWh^2]"
        CapCostCoeff(Yr,HMR,MP) "Capital Cost Coefficient [$/kW/yr]"
        CapCostSlp(MP) "Slope of Capital Cost [$/kW/yr /GW]"
        LeadTime(HMR,MPNew) Years Required for Construction [yr]
        CnstLagPast(Yr,Fuel) Years in which the construction lag is past []
        CnstLagCCS(MP) lag for building CCS plants [# of years]
        PlnInvRtr(YrFull,HMR,MP) Annual Planned Investment and Retirement in Nameplate Capacity [GW]
        PlnInvRtrNC(YrFull,MP) planned investment and retirement (NPCap) in NC from NC enviro agency [GW]
        CumPlnInvRtr(Yr,HMR,MP) Cumulative Planned Investment and Retirement in Nameplate Capacity [GW]
        TDLoss(Yr,Sea) Local Transimission and Distribution loss []
        GenAEO(Yr,Month,HMR,Fuel) AEO Monthly Electricity Generation by Fuel Type by HMR [GWh]
        GenAEOSea(Yr,HMR,Sea) AEO Seasonal Total Electricity Generation by HMR [GWh]
        GenAEOYr(Yr,HMR) "AEO Electricity Generation by HMR [GWh]"
        GenAEOSeaFuel(Yr,HMR,Sea,Fuel) "AEO Seasonal Electricity Generation by HMR/Fuel [GWh]"
        GenFx(Yr,HMR,MP,Sea,TB) "Reference Generation that gen will be fixed to if UI_FxGen turned on [GWh]"
        GenNukeFx(Yr,HMR,MP,Sea,TB) "Reference Generation that nuclear gen will be fixed to if UI_FxNukeGen turned on [GWh]"
        EmisAEO(Yr,HMR,Fuel,Pol) "AEO Emissions by HMR, Fuel, and Pollutant [CO2: M tons; SO2,NOx: k tons; Hg: tons]"
        AEOEPrcNat(Yr) "AEO Average National Electricity Retail Price [$/MWh]"
        ERFuelPolAEO(Yr,HMR,Fuel,Pol) "regional AEO emissions rates by fuel/pol [CO2: tons/MWh; SO2,NOx: lbs/MWh]"
        ExpERo(Yr,HMR) "Emissions rate of exporting state based on historical data [tons CO2/MWh]"
        NetFrgnImpCHP(Yr,HMR,Sea,TB) Net Foreign Imports [GWh]
        PriceImports(PPAR) "should imports be included in the emissions cap [1,0]"
        EmisCap(YrFull,PPAR,step) Emissions cap [M tons]
        ACAlwPrc(YrFull,PPAR,step) "Price of alternative compliance allowances [$/ton]"
        EmisCapNom(YrFull,PPAR) Nominal Emissions cap (without the ECR removed or CCR added) [M tons]
        EmisCapAlloc(YrFull,PPAR,HMR) Cap allowances allocated to HMR's within a cap region [M tons]
        EmisCapAllocStep(YrFull,PPAR,HMR,Step) Allowances allocated to HMRs withina capped region by price step
        ExchangeRate(Yr,PPAR,HMR) Exchange rate for HMRs within a capped region []
        EnhancedComp(Yr,PPAR,HMR) Enhanced compliance rate for HMRs within a capped region that must turn in additional allowances to meet their obligation[]
        EmisBankStartYr(PPAR) Start year of emissions banking constraint
        Bank0(PPAR) Initial size of allowance bank [M tons]
        EmisCapPS(YrFull,PPAR) Emissions Cap for PS Emissions Targeting [M tons]
        PSCredit(YrFull,PPAR,HMR,MP) "portfolio standard credit portion [%]"
        PSPrcRef(Yr,PPAR) "portfolio standard prices, for reference in another scenario [$/MWh]"
        AlwPrcRef(Yr,PPAR) "reference allowance price [$/ton]"
        EESvSeaTb(Yr,HMR,Sea,Tb) "EE savings Sea/TB multiplier []"
        EEExpExo(YrFull,HMR) exogenous expenditures on EE [k$]
        EEPDMult(YrFull,YrFulldup) persistance and decay multiplier for EE savings []
        PTCHaircut(YrFull,PPAR) "haircut applied to PTCoptions are 1 no haircut and TCHaircut when it's not direct pay []"
        PTCredit(YrFull,PPAR,HMR,MP) "production tax credit portion [%]"
        PTCPrc(Yr,PPAR) "production tax credit amount [$/MWh]"
        ITCHaircut(YrFull,PPAR) "haircut applied to ITC: options are 1 no haircut and TCHaircut when it's not direct pay []"
        ITCredit(YrFull,PPAR,HMR,MP) "investment tax credit portion [%]"
        ITCPct(Yr,PPAR) "investment tax credit (capital cost portion after ITC applied) [%]"
        CCS45QVal(YrFull,TypeCCS)   "level of 45Q tax credit [$]"
        CEPPVal(Yr,PPAR) "payment value for the clean energy payment plan (CEPP) [$/MWh]"
*       CalMCNoDsp(Yr,HMR,MPNew,Sea,TB) "marginal cost of the no dispatch equation in calibration [$/MWh]"
*        VarCOSConsumer(Yr,HMR,Sea)  "Variable cost to consumer in COS region [$/MWh]"
*        FixCOSConsumer(Yr,HMR,Sea)  "Fixed cost to consumer in COS region [$/MWh]"
*        NonCOSConsumer(Yr,HMR,Sea)  "Non COS region costs ($/MWh)"
*        VarPolCostConsumer(Yr,HMR,Sea) "Variable policy costs for consumer ($/MWh)"
*        FixPolCostConsumer(Yr,HMR,Sea) "Fixed policy costs for consumer ($/MWh)"
*        PSCostsConsumer(Yr,HMR,Sea) "Portfolio Standard effects on costs for consumers ($/MWh)"
*        CalCostConsumer(Yr,HMR,Sea) "Calibrator effects on costs for consumers ($/MWh)"
*        TransCostConsumer(Yr,HMR,Sea) "Transmissions costs for consumers ($/MWh)"

*cofiring
        CofireReq    "mandated cofiring level [%]"
        HRNonCofire(Yr,HMR,Eff)    "Heat Rate of coal plants capable of cofiring, prior to cofiring [Btu/kWh]"
        HRCofire(Yr,HMR,Eff)    "Heat Rate at mandated cofiring level [Btu/kWh]"
        ERinCO20Cofire(Yr,HMR,Eff) "initial CO2 emissions rate per unit input at mandated cofiring level [lb/MMBtu]"
        ERoCofire(Yr,HMR,Eff)   "emissions rates per unit output at mandated cofiring level [tons/MWh]"
*VA Renewables targets
        TechTgt(Yr,HMR,Tech) "Capacity targets per state by technology type [GW]"
        RETgt(Yr,PPAR) "Target investment of Solar and Onshore Wind in VA according to VCEA [GW]"
*Historical Data
        NPCapFuelHist(YrFullHist,HMR,Fuel)     "state-level historical capacity by fuel type [GW]"
        GenFuelHist(YrFullHist,HMR,Fuel)       "state-level historical generation by fuel type [GWh]"
        EConsExoHist(YrFullHist,HMR)           "state-level historical consumption [GWh]"
        EmisFuelHist(YrFullHist,HMR,Fuel,Pol)  "state-level historical emissions by fuel type [CO2: M tons; SO2,NOx: k tons]"
        NPCapHist(YrFullHist,HMR)              "state-level historical capacity [GW]"
        GenHist(YrFullHist,HMR)                "state-level historical generation [GWh]"
        EmisHist(YrFullHist,HMR,Pol)           "state-level historical emissions [CO2: M tons; SO2,NOx: k tons]"
*EPA Good Neighbor emissions rate changes and coal retirements
        NPCapRetired(YrFull,HMR)     "coal capacity retired annually under EPA's good neighbor IPM modeling [GW]"
        HRpct(YrFull,HMR)            "HR change for coal plants under EPA's good neighbor IPM modeling -- new as percent of old []"
        ERinSO2pct(YrFull,HMR)       "SO2 change for coal plants under EPA's good neighbor IPM modeling -- new as percent of old []"
        ERinNOxpct(YrFull,HMR)       "NOx change for coal plants under EPA's good neighbor IPM modeling -- new as percent of old []"
        ERinCO2pct(YrFull,HMR)       "CO2 change for coal plants under EPA's good neighbor IPM modeling -- new as percent of old []"
        VOMpct(YrFull,HMR)           "VOM change for coal plants under EPA's good neighbor IPM modeling -- new as percent of old []"
        FOMpct(YrFull,HMR)           "FOM change for coal plants under EPA's good neighbor IPM modeling -- new as percent of old []"
*outputs
        TotCostMCP_MP(Yr,HMR,MP) annual total cost by MP in MCP solution [k$]
        TotCostMCP_YrHMR(Yr,HMR) regional annual total cost in MCP solution [k$]
        TotCostMCP national PDV cumulative total cost in MCP solution [k$]
*scratch
        scratch scalar scratch variable
        scratchb scalar scratch variable
        s1(*) 1-d scratch variable
        s1b(*) 1-d scratch variable
        s1c(*) 1-d scratch variable
        s2(*,*) 2-d scratch variable
        s2b(*,*) 2-d scratch variable
        s2c(*,*) 2-d scratch variable
        s3(*,*,*) 3-d scratch variable
        s3b(*,*,*) 3-d scratch variable
        s3c(*,*,*) 3-d scratch variable
        s3d(*,*,*) 3-d scratch variable
        s4(*,*,*,*) 4-d scratch variable
        s4b(*,*,*,*) 4-d scratch variable
        s4c(*,*,*,*) 4-d scratch variable
        s5(*,*,*,*,*) 5-d scratch variable
        s5b(*,*,*,*,*) 5-d scratch variable
        s6(*,*,*,*,*,*) 6-d scratch variable
        s6b(*,*,*,*,*,*) 6-d scratch variable
;
ListVar(DecParamYrFull,noEq,none,'','Full','',none)
Parameters
        CalNPCapFull(YrFull,HMR,MP)
        CalTransFull(YrFull,HMRe,HMRi,Sea,TB)
        TransCapFull(YrFull,HMRe,HMRi,Sea)
        CalACFGenFull(YrFull,HMR,MP,Sea,TB)
        CalACFRsvFull(YrFull,HMR,MP,Sea,TB)
        CalRsvMrgFull(YrFull,RsvRg)
;
ListVarEq(DecParamYrFull,'','SclFull','')

* Load data into sets and parameters.
*-----------------------------------------------------------------------------------------------------------------------
*Inflation
$gdxin %UI_RootDir%\..\Shared\Inputs\Inflation%UI_vInputs%
$load Inflation
$gdxin

*MP parameters
$gdxin %UI_RootDir%\..\Shared\Inputs\MPInput%UI_vInputs%_%UI_Yrs%
$load YrFull Yr DataYr HMR MP MPEx MPNew MPExNew Eff MPEff NPCap0 WinCap0 SumCap0 NetGen0 PNG0 HR0 FC0 VOM0 FOM0 CapCost0 EFORd0 WSOF0
$load ERinCO20 ERinSO20 ERinNOx0 LeadTime CofirePct PlnInvRtr NPCapPenalty HRPenalty
$gdxin

*AEO CapCosts -- note that we're importing for YrFull from the YrFull inputs sheet because we want to defile CapCostAEO over all years
$gdxin %UI_RootDir%\..\Shared\Inputs\AEO_CapCostYrStInput%UI_vInputs%
$load CapCost0AEO CapCost0NatAEO
$gdxin

*NREL CapCosts -- note that we're importing for YrFull from the YrFull inputs sheet because we want to defile CapCostNREl over all years
*$gdxin %UI_RootDir%\..\Shared\Inputs\NREL_CapCostInput%UI_vInputs%
$gdxin %UI_RootDir%\..\Shared\Inputs\NREL_CapCostInput220812
$load CapCostNREL
$gdxin

*electricity demand
$gdxin %UI_RootDir%\..\Shared\Inputs\EDemInput%UI_vInputs%_%UI_Yrs%
$load EConsRefMC ERevRefMC EConsTBpctSea EConsTBpctAnn EConsEVTBpctSea EConsEVTBpctAnn EConsOtherTBpctSea EConsOtherTBpctAnn EPrcRtlCmpRef Hrs AEOEPrcNat
$gdxin

*AEO generation
$gdxin %UI_RootDir%\..\Shared\Inputs\GenYrStInput%UI_vInputs%_%UI_Yrs%
$load GenAEO

*fuel supply
$gdxin %UI_RootDir%\..\Shared\Inputs\FuelSupInput%UI_vInputs%_%UI_Yrs%
$load FuelConsRef FCiRef
$gdxin

*AEO emissions
$gdxin %UI_RootDir%\..\Shared\Inputs\EmisYrStPolInput%UI_vInputs%_%UI_Yrs%
$load EmisAEO
$gdxin

*transmission capability
$gdxin %UI_RootDir%\..\Shared\Inputs\TransInput%UI_vInputs%_%UI_Yrs%
$load TransCap0 NetImp CHPExo TransCapMax0
$gdxin

*policy variables
$gdxin %UI_RootDir%\..\Shared\Inputs\PolVarInput%UI_vInputs%_%UI_Yrs%
$load RGGICap PlnInvRtrNC RsvRg map_RsvRg
$gdxin

*Solar AFs
$gdxin %UI_RootDir%\..\Shared\Inputs\SolarAFInput%UI_vInputs%_%UI_Yrs%
$load SolarAF
$gdxin

*Wind AFs and Capacity for New Builds
$gdxin %UI_RootDir%\..\Shared\Inputs\WindAFInput%UI_vInputs%_%UI_Yrs%
$load WindAF, WindMaxCap
$gdxin

*RPS requirement
$gdxin %UI_RootDir%\..\Shared\Inputs\RPSPolInput%UI_vInputs%
$load RPS0
$gdxin

*RE capacity requirement
$gdxin %UI_RootDir%\..\Shared\Inputs\RECapReqInput%UI_vInputs%
$load NPCapTarget
$gdxin

*RE capacity requirement from AEO 2021
$gdxin %UI_RootDir%\..\Shared\Inputs\RECapReqAEOInput%UI_vInputs%
$load NPCapTargetAEO
$gdxin

*Historical Data
$gdxin %UI_RootDir%\..\Shared\Inputs\UShistdataInput%UI_vInputs%
$load  NPCapFuelHist, GenFuelHist, EConsExoHist, EmisFuelHist
$gdxin

*CCS Data
$gdxin %UI_RootDir%\..\Shared\Inputs\CCSTrnStr%UI_vInputs%
$load         CCSCost,CCSStorMax
$gdxin

*NREL electrification futures demand
$gdxin %UI_RootDir%\..\Shared\Inputs\NRELCons%UI_vInputs%
$load         NRELCons
$gdxin

*-------------EPA Good Neighbor emissions rate changes and coal retirements
$gdxin %UI_RootDir%\..\Shared\Inputs\CSAPR%UI_vInputs%
$load         NPCapRetired, HRpct, ERinSO2pct, ERinNOxpct, ERinCO2pct, VOMpct, FOMpct
$gdxin

* Declare sets that depend upon the data.
*-----------------------------------------------------------------------------------------------------------------------
Sets
$onText
        map_RsvRg(HMR,RsvRg) mapping of HMRs to reserve regions
         /CA.CA
          FL.FL
          (CT,MA,ME,NH,RI,VT).NE
          NY.NY
          TX.TX
          (DC,DE,KY,MD,NJ,OH,PA,VA,WV).PJM
          (AL,GA,NC,SC,TN).SERC
          (IA,IL,IN,MI,MN,ND,SD,WI).MISON
          (AR,LA,MO,MS).MISOS
          (KS,NE,OK).SPP
          (CO,WY).RMPA
          (AZ,NM).AZNM
          (ID,MT,NV,OR,UT,WA).NWPP/
$offText
        PPAR Pollution Policy Aggregation Region /
                Nat, RGGI9, RGGI10, RGGI11, RGGI12, RGGI12Lead, RGGI12Stnd, RGGI13, RGGI19,
                AL, AZ, AR, CA, CO, CT, DE, FL, GA, ID, IL, IN, IA, KS, KY, LA, ME, MD, MA, MI,
                MN, MS, MO, MT, NE, NV, NH, NJ, NM, NY, NC, ND, OH, OK, OR, PA, RI, SC, SD, TN,
                TX, UT, VT, VA, WA, WV, WI, WY, DC,
                RGGINC, RGGIPA, RGGIMN, RGGIWI, RGGIIL, RGGIMI, RGGICO, RGGINM, RGGINV, RGGIWA,
                NMCO, ILMN, PANC, RGGINMCO, RGGIILMN, RGGIPANC,
                MN_WI_IL_MI, MNWIILMI, RGGIMNWIILMI,
                NC_Coal, NC_NG, PA_Coal, PA_NG,
                TCI, NonTCI, PJM, NYRPS, NERPS, NENYRPS, PJMRPS, NWRPS, CARPS, NWCARPS, AZNMRPS, TXRPS, RMRPS, MWRPS, SERPS, NatWPS, NatSPS,
                CO_PSCo, CORPS,
                NECES,PJMCES,SPPCES,TXCES,NYCES,CACES,MISOCES,SECES,WECCCES, COSRegions, NonCOSRegions
                MENH,
                ESC, WSC, MTN, PAC, NEG, SAL, WNC, ENC, MAL,
                EI, WECC, ERCOT, WECCnoCA
 /

        PPAR_RefEmis(PPAR) /RGGI9, RGGI10, RGGI11, RGGI12, RGGI13/
*                          /RGGI12,PSCo/
        PPAR_NatRPS(PPAR) /NatWPS, NatSPS/
        PPAR_Nat(PPAR) /Nat/
        PPAR_CES(PPAR) /NECES,PJMCES,SPPCES,TXCES,NYCES,CACES,MISOCES,SECES,WECCCES/
*These sets should be rnamed PPAR_* instead of HMR_*.
        HMR_RGGI9(HMR)          /MD,DE,NY,CT,RI,MA,VT,NH,ME/
        HMR_RGGI10(HMR)         /MD,DE,NY,CT,RI,MA,VT,NH,ME,NJ/
        HMR_RGGI11(HMR)         /MD,DE,NY,CT,RI,MA,VT,NH,ME,NJ,VA/
        HMR_RGGI12(HMR)         /MD,DE,NY,CT,RI,MA,VT,NH,ME,NJ,VA,PA/
        HMR_RGGI13(HMR)         /MD,DE,NY,CT,RI,MA,VT,NH,ME,NJ,VA,PA,NC/
        HMR_RGGI12Lead(HMR)       /NY,MA,VT,CT,RI,MD,NJ,DE/
        HMR_RGGI12Stnd(HMR)        /VA,PA,NH,ME/
*test
        HMR_MENH(HMR)           /ME, NH/
*individual states as PPARs
        HMR_AL(HMR)             /AL/
        HMR_AZ(HMR)             /AZ/
        HMR_AR(HMR)             /AR/
        HMR_CA(HMR)             /CA/
        HMR_CO(HMR)             /CO/
        HMR_CT(HMR)             /CT/
        HMR_DE(HMR)             /DE/
        HMR_FL(HMR)             /FL/
        HMR_GA(HMR)             /GA/
        HMR_ID(HMR)             /ID/
        HMR_IL(HMR)             /IL/
        HMR_IN(HMR)             /IN/
        HMR_IA(HMR)             /IA/
        HMR_KS(HMR)             /KS/
        HMR_KY(HMR)             /KY/
        HMR_LA(HMR)             /LA/
        HMR_ME(HMR)             /ME/
        HMR_MD(HMR)             /MD/
        HMR_MA(HMR)             /MA/
        HMR_MI(HMR)             /MI/
        HMR_MN(HMR)             /MN/
        HMR_MS(HMR)             /MS/
        HMR_MO(HMR)             /MO/
        HMR_MT(HMR)             /MT/
        HMR_NE(HMR)             /NE/
        HMR_NV(HMR)             /NV/
        HMR_NH(HMR)             /NH/
        HMR_NJ(HMR)             /NJ/
        HMR_NM(HMR)             /NM/
        HMR_NY(HMR)             /NY/
        HMR_NC(HMR)             /NC/
        HMR_ND(HMR)             /ND/
        HMR_OH(HMR)             /OH/
        HMR_OK(HMR)             /OK/
        HMR_OR(HMR)             /OR/
        HMR_PA(HMR)             /PA/
        HMR_RI(HMR)             /RI/
        HMR_SC(HMR)             /SC/
        HMR_SD(HMR)             /SD/
        HMR_TN(HMR)             /TN/
        HMR_TX(HMR)             /TX/
        HMR_UT(HMR)             /UT/
        HMR_VT(HMR)             /VT/
        HMR_VA(HMR)             /VA/
        HMR_WA(HMR)             /WA/
        HMR_WV(HMR)             /WV/
        HMR_WI(HMR)             /WI/
        HMR_WY(HMR)             /WY/
        HMR_DC(HMR)             /DC/
*groups of states might join RGGI
        HMR_NMCO(HMR)           /NM,CO/
        HMR_ILMN(HMR)           /IL,MN/
        HMR_PANC(HMR)           /PA,NC/
        HMR_MNWIILMI(HMR)       /MN, WI, IL, MI/
*TCI states
        HMR_TCI(HMR)           /MD,DE,NY,CT,RI,MA,VT,NH,ME,NJ,VA,PA,DC/
*PJM states -- note that these may not be the same as the states in the PJM RPS
        HMR_PJM(HMR)           /DE, IL, IN, KY, MD, MI, NJ, NC, OH, PA, TN, VA, WV, DC/
*RPS states
        HMR_PJMRPS(HMR)            /PA,NJ,MD,DC,OH,DE,VA,WV/
        HMR_PJMRPS_Sales(HMR)      /PA,NJ,MD,DC,OH,DE/
        HMR_PJMNoPARPS(HMR)        /   NJ,MD,DC,OH,DE,VA,WV/
        HMR_PJMNoPARPS_Sales(HMR)  /   NJ,MD,DC,OH,DE/
        HMR_PJMRGGIRPS(HMR)        /PA,NJ,MD,DC,   DE,VA   /
        HMR_PJMnotRGGIRPS(HMR)     /            OH,      WV/
        HMR_NYRPS(HMR)             /NY/
        HMR_NERPS(HMR)             /ME,NH,VT,MA,RI,CT/
        HMR_NENYRPS(HMR)           /ME,NH,VT,MA,RI,CT,NY/
        HMR_NWRPS(HMR)             /WA,OR,NV,MT/
        HMR_NWCARPS(HMR)           /WA,OR,NV,MT,CA/
        HMR_CARPS(HMR)             /CA/
        HMR_AZNMRPS(HMR)           /AZ,NM/
        HMR_TXRPS(HMR)             /TX/
        HMR_RMRPS(HMR)             /CO/
        HMR_MWRPS(HMR)             /MN,IA,MO,WI,IL,MI/
        HMR_SERPS(HMR)             /NC/
*Colorado Cap
        HMR_PSCo(HMR)              /CO/
*All but MA
        HMR_NotMA(HMR)
*All but PA
        HMR_NatNoPA(HMR)
*CES regions
         HMR_PJMCES(HMR)         /OH, WV, VA, KY, MD, DE, PA, DC, NJ/
         HMR_SECES(HMR)          /TN, NC, SC, GA, AL, MS, FL/
         HMR_MISOCES(HMR)        /MN, WI, IA, IL, IN, MI, MO, AR, LA/
         HMR_SPPCES(HMR)         /OK, KS, NE, SD, ND/
         HMR_WECCCES(HMR)        /WA,OR,NV,AZ,UT,ID,MT,WY,CO,NM/
         HMR_NECES(HMR)          /ME, MA, NH, VT, CT, RI/
         HMR_TXCES(HMR)          /TX/
         HMR_CACES(HMR)          /CA/
         HMR_NYCES(HMR)          /NY/

*Census Regions
         HMR_ESC(HMR)            /AL, KY, MS, TN/
         HMR_WSC(HMR)            /AR, LA, OK, TX/
         HMR_MTN(HMR)            /AZ, CO, ID, MT, NM, NV, UT, WY/
         HMR_PAC(HMR)            /CA, OR, WA/
         HMR_NEG(HMR)            /CT, MA, ME, NH, RI, VT/
         HMR_SAL(HMR)            /DC, DE, FL, GA, MD, NC, SC, VA, WV/
         HMR_WNC(HMR)            /IA, KS, MN, MO, ND, NE, SD/
         HMR_ENC(HMR)            /IL, IN, MI, OH, WI/
         HMR_MAL(HMR)            /NJ, NY, PA/
*interconnects
         HMR_EI(HMR)             /ME,VT,NH,MA,RI,CT,NY,NJ,DE,MD,DC,VA,NC,SC,GA,FL,AL,MS,LA,AR,TN,KY,WV,PA,OH,IN,IL,MI,WI,MN,IA,ND,SD,NE,KS,MO,OK/
         HMR_WECC(HMR)           /WA,OR,CA,ID,NV,AZ,MT,WY,UT,CO,NM/
         HMR_ERCOT(HMR)          /TX/
         HMR_WECCnoCA(HMR)       /WA,OR,ID,NV,AZ,MT,WY,UT,CO,NM/
*landlocked states (or states with no Offshore Wind
         HMR_landlocked(HMR)     /AZ, AR, CO, DC, IA, ID, KS, KY, MO, MT, NE, NV, NM, ND, OK, PA, SD, TN, UT, VT, WV, WY/

*emissions policies coverage
        EmisPolMP(MP) MPs covered by emissions policies (this will need a PPAR dimension someday)
        map_EmisPol_YPH(Yr,PPAR,HMR) map HMR to PPAR for emissions policies
        map_EmisPol_YPHM(Yr,PPAR,HMR,MP) full map of emissions policies
*Reference Emissions
        map_RefEmisAnn_YP(Yr,PPAR) PPARs where a previous scenario is referenced for Emissions Caps
        map_RefEmisAnn_YPH(Yr,PPAR,HMR) PPARs where a previous scenario is referenced for Emissions Caps
*PS inclusion
        PSMP(MP) MPs included in PS (this will need a PPAR dimension someday)
        map_PS_YPH(Yr,PPAR,HMR) map HMR to PPAR for PS inclusion
        map_RPSReg0_YPH(Yr,PPAR,HMR) map HMR to PPAR for aggregate regional RPSs made from state RPSs we read from data
        map_RPS0_YPH(Yr,PPAR,HMR) map HMR to PPAR for PS inclusion for RPS's that we read from data
        map_PS_Sales_YPH(Yr,PPAR,HMR) map HMR to PPAR for PS inclusion for areas that can purchase PS credits (not including those that can sell)
        map_PS_YPHM(Yr,PPAR,HMR,MP) full map of PS inclusion
*PTC inclusion
        PTCMP(MP) MPs included in PTC (this will need a PPAR dimension someday) (will also need to become inclusive for solar someday)
        map_PTC_YPH(Yr,PPAR,HMR) map HMR to PPAR for PTC inclusion
        map_PTC_YPHM(Yr,PPAR,HMR,MP) full map of PTC inclusion
*ITC inclusion
        ITCMP(MP) MPs included in ITC (this will need a PPAR dimension someday)
        map_ITC_YPH(Yr,PPAR,HMR) map HMR to PPAR for ITC inclusion
        map_ITC_YPHM(Yr,PPAR,HMR,MP) full map of ITC inclusion
*RE targets
        REtgtMP(MP) MPs included as renewables in renewable targets
        map_REtgt_YPH(Yr,PPAR,HMR) map HMR to PPAR for renewable targets
        map_REtgt_YPHM(Yr,PPAR,HMR,MP) full map of renewable target inclusion
*Tech targets
        TechtgtMP(MP,Tech) Technologies included in technology build targets
        map_Techtgt_YPH(Yr,PPAR,HMR) map HMR to PPAR for technology build targets
        map_Techtgt_YPHT(Yr,PPAR,HMR,MP,Tech) full map of technology build target inclusion
*EE inclusion
        map_EE_YPH(Yr,PPAR,HMR) map HMR to PPAR for Energy Efficiency policies
*cofiring emissions policies coverage
        CofirePolMP(MP) MPs included in Cofire cap policies
        map_CofirePol_YPH(Yr,PPAR,HMR) map HMR to PPAR for cofiring emissions policies
        map_CofirePol_YPHM(Yr,PPAR,HMR,MP) full map of cofiring emissions policies
*Fixed Transmission mapping
        map_FxTrans_YPH(Yr,PPAR,HMR) Mapping of PPAR's and HMR's for fixed transmission
*results map
        map_all_YPH(Yr,PPAR,HMR) map HMR to PPAR for results reporting
*utility
        map_tmp_YPH(Yr,PPAR,HMR) map for carrying other maps around
*Fuel Subsets for Calibration
       Fuel_Coal(Fuel)  /Coal/
       Fuel_Oth(Fuel) /Oth/
*CalGen
       map_CalGen_YPH(Yr,PPAR,HMR) map for calgen by PPAR
;

*All but MA
        HMR_NotMA(HMR)=yes;
        HMR_NotMA('MA')=no;
*All but PA
        HMR_NatNoPA(HMR) = Yes$(not HMR_PA(HMR));
