
* Calculate post-processing parameters.
*-----------------------------------------------------------------------------------------------------------------------
Parameters
** MP cost and performance characteristics ---------------------------------------------------
        CapCostF(Yr,HMR,MP) "final annualized capital cost by MP[$/kW/yr]"
        CapCostITC(Yr,HMR,MP) "final annualized capital cost by MP[$/kW/yr] including ITC adjustment"
        FOMF(Yr,HMR,MP) "final fixed O&M cost by MP [$/kW/yr]"
        VOMF(Yr,HMR,MP) "final annual average variable O&M cost by MP [$/MWh]"
        HRF(Yr,HMR,MP) "final heatrate by MP [Btu/kWh]"
        FCoF(Yr,HMR,MP) "final annual average fuel cost by MP [$/MWh]"
        ERoF(Yr,HMR,MP) "final CO2 emissions rate by MP [tons/MWh]"
        MVCostF(Yr,HMR,MP,Sea,TB) " final marginal variable cost [$/MWh]"
** Capacity ---------------------------------------------------
        NPCapNat(Yr,MP) national nameplate capacity by MP [GW]
        NPCapTot(Yr,HMR) regional total nameplate capacity [GW]
        NPCapNatTot(Yr) national total nameplate capacity by [GW]
        NPCapFuel(Yr,HMR,Fuel) regional nameplate capacity by fuel type [GW]
        NPCapFuelNat(Yr,Fuel) national nameplate capacity by fuel type [GW]
        NPCapYPFM(Yr,PPAR,Fuel,MP)
        NPCapYHFM(Yr,HMR,Fuel,MP)
        NPCapFuelYP_EmisPol(Yr,Fuel,PPAR) nameplate capacity by fuel type by emissions policy PPAR (all generators) [GW]
        NPCapFuelYPCvr_EmisPol(Yr,Fuel,PPAR) nameplate capacity by fuel type by emissions policy PPAR (covered generators) [GW]
        NPCapFuelYP_PS(Yr,Fuel,PPAR) nameplate capacity by fuel type by portfolio standard PPAR (all generators) [GW]
        NPCapFuelYPCvr_PS(Yr,Fuel,PPAR) nameplate capacity by fuel type by portfolio standard PPAR (covered generators) [GW]
** Generation ---------------------------------------------------
*no consideration of policies
        GenAnn(Yr,HMR,MP) regional annual generation by MP [TWh]
        GenAnnNat(Yr,MP) national generation by MP [TWh]
        GenTot(Yr,HMR) regional annual total generation [TWh]
        GenNat(Yr) national annual generation [TWh]
        GenFuel(Yr,HMR,Fuel) regional annual generation by fuel type [TWh]
        GenFuelNat(Yr,Fuel) national annual generation by fuel type
*by policy/fuel type
        GenYPFM(Yr,PPAR,Fuel,MP)"TWh"
        GenYHFM(Yr,HMR,Fuel,MP) "TWh"
        GenYHFS(Yr,HMR,Fuel,Sea) "TWh"
        CF_YHFM(Yr,HMR,Fuel,MP) "%"
        GenFuelYP_EmisPol(Yr,Fuel,PPAR) generation by fuel type by emissions policy PPAR (all generators) [TWh]
        GenFuelYPCvr_EmisPol(Yr,Fuel,PPAR) generation by fuel type by emissions policy PPAR (covered generators) [TWh]
        GenFuelYP_PS(Yr,Fuel,PPAR) generation by fuel type by portfolio standard PPAR (all generators) [TWh]
        GenFuelYPCvr_PS(Yr,Fuel,PPAR) generation by fuel type by portfolio standard PPAR (covered generators) [TWh]
        GenFuelYPCred_PS(Yr,Fuel,PPAR) portfolio standard credits earned by fuel type PPAR [TWh]
        GenYPFMCred_PS(Yr,PPAR,Fuel,MP) "portfolio standard credits earned by year, ppar, fuel and MP [TWh]"
*by Sea and TB
        GenYHFST(Yr,HMR,Fuel,Sea,TB)  generation by fuel type by HMR and by Sea and TB [TWh]
        GenYPFST(Yr,PPAR,Fuel,Sea,TB) generation by fuel type by emissions policy PPAR (all generators) and by Sea and TB [TWh]
        UtilizationFactor(Yr,HMR,MP,Sea,TB) "utilization of MP by Sea TB [%]"
*by policy
        GenYP_EmisPol(Yr,PPAR) generation by emissions policy PPAR (all generators) [TWh]
        GenYPCvr_EmisPol(Yr,PPAR) generation by emissions policy PPAR (covered generators) [TWh]
        GenYP_PS(Yr,PPAR) generation by portfolio standard PPAR (all generators) [TWh]
        GenYPCvr_PS(Yr,PPAR) generation by portfolio standard PPAR (covered generators) [TWh]
        GenYPCred_PS(Yr,PPAR) portfolio standard credits earned by PPAR [TWh]
*funny stuff, like AEO
        GenAEOFuelYH(Yr,HMR,Fuel) regional annual AEO generation by fuel type [TWh]
        GenExoYH(Yr,HMR) regional annual exogenous generation [TWh]
        GenEndoFuelYH(Yr,HMR,Fuel) regional annual endogenous generation by fuel type [TWh]
** Emissions ---------------------------------------------------
*no consideration of policies
        EmisAnn(Yr,HMR,MP,Pol) "regional annual emissions by MP [CO2: M tons; SO2,NOx: k tons]"
        EmisAnnNat(Yr,MP,Pol) "national annual emissions by MP [CO2: M tons; SO2,NOx: k tons]"
        EmisTot(Yr,HMR,Pol) "regional annual emissions [CO2: M tons; SO2,NOx: k tons]"
        EmisNat(Yr,Pol) "national annual emissions [CO2: M tons; SO2,NOx: k tons]"
        EmisFuel(Yr,HMR,Fuel,Pol) "regional annual emissions by fuel [CO2: M tons; SO2,NOx: k tons]"
        EmisFuelNat(Yr,Fuel,Pol) "national annual emissions by fuel [CO2: M tons; SO2,NOx: k tons]"
        EmisCO2Nat(Yr) "national annual C02 emissions [M tons]"
        EmisCO2FuelNat(Yr,Fuel) "national annual CO2 emissions by fuel [M tons]"
*by policy/fuel type
        EmisYPFM(Yr,PPAR,Fuel,MP,Pol) "emissions by year, ppar, fuel, mp [CO2: M tons; SO2,NOx: k tons]"
        EmisYPFMCvr_EmisPol(Yr,PPAR,Fuel,MP,Pol) "covered emissions by year, ppar, fuel, mp [CO2: M tons; SO2,NOx: k tons]"
        EmisFuelYP_EmisPol(Yr,Fuel,PPAR,Pol)  "annual emissions by fuel by emissions policy PPAR (all generators) [CO2: M tons; SO2,NOx: k tons]"
        EmisFuelYPCvr_EmisPol(Yr,Fuel,PPAR,Pol) "annual emissions by fuel by emissions policy PPAR (covered generators) [CO2: M tons; SO2,NOx: k tons]"
        EmisFuelYP_PS(Yr,Fuel,PPAR,Pol) "annual emissions by fuel by portfolio standard PPAR (all generators) [CO2: M tons; SO2,NOx: k tons]"
        EmisFuelYPCvr_PS(Yr,Fuel,PPAR,Pol) "annual emissions by fuel by portfolio standard PPAR (covered generators) [CO2: M tons; SO2,NOx: k tons]"
*by policy
        EmisYP_EmisPol(Yr,PPAR,Pol) "annual emissions by emissions policy PPAR (all generators) [CO2: M tons; SO2,NOx: k tons]"
        EmisYPCvr_EmisPol(Yr,PPAR,Pol) "annual emissions by emissions policy PPAR (covered generators) [CO2: M tons; SO2,NOx: k tons]"
        EmisYP_PS(Yr,PPAR,Pol) "annual emissions by portfolio standard PPAR (all generators) [CO2: M tons; SO2,NOx: k tons]"
        EmisYPCvr_PS(Yr,PPAR,Pol) "annual emissions by portfolio standard PPAR (covered generators) [CO2: M tons; SO2,NOx: k tons]"
*funny stuff, like AEO
        EmisAEOYP(Yr,Pol) "national annual AEO emissions by pollutant [CO2: M tons; SO2,NOx: k tons]"
        ERFuelPol(Yr,Fuel,Pol) "emissions rates by fuel/pol [CO2: tons/MWh; SO2,NOx: lbs/MWh]"
        EmisYPCvr(Yr,PPAR,Pol) "emissions by PPAR if all PPARs had the same covered generators as an emissions cap [CO2: M tons; SO2,NOx: k tons]"
** Electricity Consumption & Prices ---------------------------------------------------
        EConsAnn(Yr,HMR) "regional annual electricity consumption [TWh]"
        EConsNat(Yr) national annual electricity consumption [TWh]
        EConsPPAR(Yr,PPAR) annual electricity consumption in PPAR states [TWh]
        EConsYHST(Yr,HMR,Sea,TB) electricity consumption by HMR Sea TB [TWh]
        EConsYPST(Yr,PPAR,Sea,TB) electricity consumption by PPAR Sea TB [TWh]
        EConsEVYHST(Yr,HMR,Sea,TB) electricity consumption by HMR Sea TB [TWh]
        EConsEVYPST(Yr,PPAR,Sea,TB) electricity consumption by PPAR Sea TB [TWh]
        EPrcRtlAnn(Yr,HMR) "regional annual average retail electricity price [$/MWh]"
        EPrcRtlNat(Yr) "national annual average retail electricity price [$/MWh]"
        EPrcRtlPPAR(Yr,PPAR) "annual average retail electricity price across RGGI states [$/MWh]"
        EPrcRtlRGGI11(Yr) "annual average retail electricity price across RGGI states [$/MWh]"
** Trade ---------------------------------------------------
        TDLossAnn(Yr,HMR) "Losses from T&D System by HMR [TWh]"
        TDLossAnnPPAR(Yr,PPAR) "Losses from T&D System by PPAR [TWh]"
        NetImportsYP(Yr,PPAR) Net Imports [TWh] "Net imports by PPAR (taking into account losses) [TWh]"
        NetImportsYPS(Yr,HMR,Sea) "Net imports [TWh] by season"
        EffTransCapacity(Yr,HMRe,HMRi,Sea,TB) "Transmission translated from GWh to GW"
        TransCapacityUtil(Yr,HMRe,HMRi) "% of transmission capacity used"
** Policy ---------------------------------------------------
        PSReqQty(Yr,PPAR) "Portfolio standard requirement [TWh]"
        Allowances(Yr,PPAR,step) "Number of Allowances purchased [thousand tons]"
** Policy Revenues and Costs---------------------------------
*        ITCExpendYfP(YrFull,PPAR)"Government Expenditure on Investment Tax Credit in PPAR [million $]"
*        PTCExpendYfP(YrFull,PPAR) "Government Expenditure on Production Tax Credit in PPAR [million $]"
*        CEPPExpendYfP(YrFull,PPAR) "Government Expenditure on Clean Electricity Performance Program in PPAR [million $]"
*        CPriceRev(Yr,PPAR) "Carbon Price Revenues [million $/year]"
        ITCCapCost(YrFull,HMR,MP) "The Capital Cost reduction of Investment Tax Credits [$/kW/yr]"
        PTCNuke(Yr,HMR,MP) "The theoretical PTC for running all nuclear plants at baseline [$/MWh]"
        CESTotVal(Yr,PPAR) "Clean Energy Standard [million $/year]"
        CESBankTot(PPAR) "Clean Energy Standard w/ bank Qualifying Generation [GWh (probably)]"
        CESConsReqTot(PPAR) "Clean Energy Standard w/ bank Consumption Requirement   [GWh (probably)]"
        CESBank(Yr,PPAR) "Amount of Clean Energy Generation Exceeding Requirement [TWh]"
        NationalCE(Yr) "% of Clean Energy Generation in a given year (even with CES off) [manually set qualifying generation]"
**Levelized Costs--------------------------------------------
        LCOE_Ex(Yr,PPAR,Fuel,MP)  "LCOE of existing MPs [$/MWh]"
        LCOE_New(Yr,PPAR,Fuel,MP) "LCOE of new MPs [$/MWh]"
        LFOM(Yr,PPAR,Fuel,MP)     "Levelized fixed operations and maintenance costs [$/MWh]"
        LCapCo(Yr,PPAR,Fuel,MP)   "Levelized capital costs [$/MWh]"
        LVOM(Yr,PPAR,Fuel,MP)     "Levelized variable operations and maintenance costs [$/MWh]"
        LFCo(Yr,PPAR,Fuel,MP)     "Levelized fuel costs [$/MWh]"
        LPolCo(Yr,PPAR,Fuel,MP)   "Levelized policy costs [$/MWh]"
        LFixCo(Yr,PPAR,Fuel,MP)   "Levelized fixed costs [$/MWh]"
        LVarCo(Yr,PPAR,Fuel,MP)   "Levelized variable costs [$/MWh]"
** Resource Costs -------------------------------------------------------------------------------
        FCoExpend(Yr,PPAR,MP)   "Total Fuel Cost Expenditures by PPAR, MP [million $]"
        VOMExpend(Yr,PPAR,MP)   "Total Variable Operations and Maintenance Expenditures by PPAR, MP [million $]"
        CCSExpend(Yr,PPAR,MP)   "Total CCS transport and storage costs by PPAR, MP [million $]"
        FOMExpend(Yr,PPAR,MP)   "Total Fixed Operations and Maintenance Expenditures by PPAR, MP [million $]"
        CapCoExpend(Yr,PPAR,MP) "Total Capital Expenditures by PPAR, MP [million $]"
        RCost_FCo(Yr,PPAR)     "Resource Costs from Fuel Costs by PPAR [million $]"
        RCost_VOM(Yr,PPAR)     "Resource Costs from Variable Operations and Maintenance by PPAR [million $]"
        RCost_CCS(Yr,PPAR)     "Resource Costs from CCS transport and storage costs by PPAR [million $]"
        RCost_FOM(Yr,PPAR)     "Resource Costs from Fixed Operations and Maintenance by PPAR [million $]"
        RCost_CapCost(Yr,PPAR) "Resource Costs from Capital Costs by PPAR [million $]"
        RCost_Imp(Yr,PPAR)     "Resource Costs from Imports by PPAR [million $]"
        RCost_Exp(Yr,PPAR)     "Resource Costs from Exports by PPAR [million $] (negative cost = savings)"
** Fuel consumption and expenditures ---------------------------------------------------
        FuelExp(Yr,HMR,MP) "fuel expenditure [k$]"
        FuelCons(Yr,HMR,MP) "fuel consumption [MMBtu]"
        FCiNat(Yr,Fuel) "national annual average delivered fuel cost [$/MMBtu]"
** CCS specific outputs ----------------------------------------------------------
        Expend45Q_YHML(Yr,HMR,MP,TypeCCS)      "Federal expenditures on 45Q per HMR,MP, and eor/saline [million $/year]"
        Expend45Q_YHL(Yr,HMR,TypeCCS)          "Federal expenditures on 45Q per HMR and eor/saline [million $/year]"
        Expend45Q_YH(Yr,HMR)                   "Federal expenditures on 45Q per HMR [million $/year]"
        Expend45Q_YL(Yr,TypeCCS)               "Federal expenditures on 45Q per eor/saline [million $/year]"
        Expend45Q_Y(Yr)                        "Federal expenditures on 45Q [million $/year]"
        EmisCaptured_YHM(Yr,HMR,MP)               "Emissions captured at CCS plants by HMR, MP [M tons]"
        EmisCaptured_YH(Yr,HMR)                   "Emissions captured at CCS plants by HMR [M tons]"
        EmisStored_YHL(Yr,HMR,StepCCS,TypeCCS)    "Emissions stored per HMR, reservoir, saline/eor [M tons]"
        EmisStored_YH(Yr,HMR)                     "Emissions stored in a given HMR [M tons]"
        EmisTrans_YHH(Yr,HMRe,HMRi)               "Emissions transferred from HMRe to HMRi [M tons]"
** Calibration ---------------------------------------------------
        CalRGGIHaiku(Yr,HMRRGGICal,Fuel) annual generation by fuel type in RGGI regions [TWh]
        CalRGGIAEO(Yr,HMRRGGICal,Fuel) annual AEO generation by fuel type in RGGI regions [TWh]
        CalEmisRGGIHaiku(Yr) annual emissions in RGGI regions [M tons]
        CalEmisRGGIAEO(Yr)  annual AEO emissions in RGGI regions [M tons]

** Check Against AEO  (mostly for calibration) ---------------------------------------------------------
        Chk_Gen(Yr,HMR,Fuel)  Difference between AEO generation and Haiku Generation by Yr HMR and Fuel
        Chk_Emis(Yr)          Difference between AEO emissions and haiku emissions by Yr
        Chk_Emis_RGGI(Yr)     Difference between AEO emissions in RGGI and haiku emissions in RGGI by Yr
;
