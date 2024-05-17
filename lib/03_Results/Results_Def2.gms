
* Calculate post-processing parameters.
*-----------------------------------------------------------------------------------------------------------------------
Parameters
** MP cost and performance characteristics ---------------------------------------------------
CapCostF(Yr,HMR,MP) "final annualized capital cost by MP[$/kW/yr]"
FOMF(Yr,HMR,MP) "final fixed O&M cost by MP [$/kW/yr]"
VOMF(Yr,HMR,MP) "final annual average variable O&M cost by MP [$/MWh]"
HRF(Yr,HMR,MP) "final heatrate by MP [Btu/kWh]"
FCoF(Yr,HMR,MP) "final annual average fuel cost by MP [$/MWh]"
ERoF(Yr,HMR,MP) "final CO2 emissions rate by MP [tons/MWh]"
*dispatch order for duality testing? Does Dallas need this?
MVCostF(Yr,HMR,MP,Sea,TB) " final marginal variable cost [$/MWh]"

** Capacity ---------------------------------------------------

*by HMR
NPCap_YH(Yr,HMR)           "nameplate capacity by Yr, HMR [GW]"
NPCap_YHF(Yr,HMR,Fuel)     "nameplate capacity by Yr, HMR, Fuel [GW]"
NPCap_YHM(Yr,HMR,MP)       "nameplate capacity by Yr, HMR, MP [GW] = NPCap"
*by all PPARs  (useful PPARs)
NPCap_YP(Yr,PPAR)          "nameplate capacity by Yr, PPAR [GW]"
NPCap_YPF(Yr,PPAR,Fuel)    "nameplate capacity by Yr, PPAR, Fuel [GW]"
NPCap_YPM(Yr,PPAR,MP)      "nameplate capacity by Yr, PPAR, Fuel [GW]"
*by emis policy (covered)
NPCapEP_YP(Yr,PPAR)        "nameplace capacity of plants covered by an emissions policy by Yr, PPAR [GW]"
NPCapEP_YPF(Yr,PPAR,Fuel)  "nameplace capacity of plants covered by an emissions policy by Yr, PPAR, Fuel [GW]"
NPCapEP_YPM(Yr,PPAR,MP)    "nameplace capacity of plants covered by an emissions policy by Yr, PPAR, MP [GW]"
*by PS policy (covered)
NPCapPS_YP(Yr,PPAR)        "nameplace capacity of plants covered by a portfolio standard by Yr, PPAR [GW]"
NPCapPS_YPF(Yr,PPAR,Fuel)  "nameplace capacity of plants covered by a portfolio standard by Yr, PPAR, Fuel [GW]"
NPCapPS_YPM(Yr,PPAR,MP)    "nameplace capacity of plants covered by a portfolio standard by Yr, PPAR, MP [GW]"
*by ITC (covered) (credited)
NPCapITC_YP(Yr,PPAR)       "nameplace capacity of plants covered by an ITC by Yr, PPAR [GW]"
NPCapITC_YPF(Yr,PPAR,Fuel) "nameplace capacity of plants covered by an ITC by Yr, PPAR, Fuel [GW]"
NPCapITC_YPM(Yr,PPAR,MP)   "nameplace capacity of plants covered by an ITC by Yr, PPAR, MP [GW]"
*by PTC (covered)
NPCapPTC_YP(Yr,PPAR)       "nameplace capacity of plants covered by a PTC by Yr, PPAR [GW]"
NPCapPTC_YPF(Yr,PPAR,Fuel) "nameplace capacity of plants covered by a PTC by Yr, PPAR, Fuel [GW]"
NPCapPTC_YPM(Yr,PPAR,MP)   "nameplace capacity of plants covered by a PTC by Yr, PPAR, MP [GW]"
*incremental capacity
NPCap_YfHM(YrFull,HMR,MP)  "incremental nameplate capacity built in each year by YrFull, HMR, MP [GW]"

** Generation ---------------------------------------------------

*by HMR
Gen_YH(Yr,HMR)                 "generation by Yr, HMR [TWh]"
Gen_YHF(Yr,HMR,Fuel)           "generation by Yr, HMR, Fuel [TWh]"
Gen_YHM(Yr,HMR,MP)             "generation by Yr, HMR, MP [TWh]"
Gen_YHST(Yr,HMR,Sea,TB)        "generation by Yr, HMR, Sea, TB [TWh]"
Gen_YHFST(Yr,HMR,Fuel,Sea,TB)  "generation by Yr, HMR, Fuel, Sea, TB [TWh]"
Gen_YHMST(Yr,HMR,MP,Sea,TB)    "generation by Yr, HMR, MP, Sea, TB [TWh] = gen.l / 1000"
*by all PPARs  (useful PPARs)
Gen_YP(Yr,PPAR)                "generation by Yr, PPAR [TWh]"
Gen_YPF(Yr,PPAR,Fuel)          "generation by Yr, PPAR, Fuel [TWh]"
Gen_YPM(Yr,PPAR,MP)            "generation by Yr, PPAR, MP [TWh]"
*by emis policy (covered)
GenEP_YP(Yr,PPAR)              "generation by plants covered by an emissions policy by Yr, PPAR [TWh]"
GenEP_YPF(Yr,PPAR,Fuel)        "generation by plants covered by an emissions policy by Yr, PPAR, Fuel [TWh]"
GenEP_YPM(Yr,PPAR,MP)          "generation by plants covered by an emissions policy by Yr, PPAR, MP [TWh]"
*by PS policy (covered)  (receiving credits)
GenPS_YP(Yr,PPAR)              "generation by plants covered by a portfolio standard by Yr, PPAR [TWh]"
GenPS_YPF(Yr,PPAR,Fuel)        "generation by plants covered by a portfolio standard by Yr, PPAR, Fuel [TWh]"
GenPS_YPM(Yr,PPAR,MP)          "generation by plants covered by a portfolio standard by Yr, PPAR, MP [TWh]"
*by ITC (covered)
GenITC_YP(Yr,PPAR)              "generation by plants covered by an ITC by Yr, PPAR [TWh]"
GenITC_YPF(Yr,PPAR,Fuel)        "generation by plants covered by an ITC by Yr, PPAR, Fuel [TWh]"
GenITC_YPM(Yr,PPAR,MP)          "generation by plants covered by an ITC by Yr, PPAR, MP [TWh]"
*by PTC (covered) (receiving credits)
GenPTC_YP(Yr,PPAR)              "generation by plants covered by a PTC by Yr, PPAR [TWh]"
GenPTC_YPF(Yr,PPAR,Fuel)        "generation by plants covered by a PTC by Yr, PPAR, Fuel [TWh]"
GenPTC_YPM(Yr,PPAR,MP)          "generation by plants covered by a PTC by Yr, PPAR, MP [TWh]"
*Utilization
Utilization_YHM(Yr,HMR,MP)              "utilization factor by Yr, HMR, MP []"
Utilization_YHMST(Yr,HMR,MP,Sea,TB)     "utilization factor by Yr, HMR, MP, Sea, TB []"
Utilization_YPF(Yr,PPAR,Fuel)           "utilization factor by Yr, PPAR, Fuel []"
Utilization_YPFST(Yr,PPAR,Fuel,Sea,TB)  "utilization factor by Yr, PPAR, Fuel, Sea, TB []"
* AEO
GenAEO_YH(Yr,HMR)                "generation according to AEO by Yr, HMR [TWh]"
GenAEO_YHF(Yr,HMR,Fuel)          "generation according to AEO by Yr, HMR, Fuel [TWh]"
GenAEO_YP(Yr,PPAR)               "generation according to AEO by Yr, PPAR [TWh]"
GenAEO_YPF(Yr,HMR,PPAR)          "generation according to AEO by Yr, PPAR, Fuel [TWh]"

*endogenous / exogenous -- are they complements?  Try same indexing
GenExo_YH(Yr,HMR)        regional annual exogenous generation [TWh]
GenEndo_YHF(Yr,HMR,Fuel) regional annual endogenous generation by fuel type [TWh]
*dispatchable /nondispatchable
GenDisp_YHF(Yr,HMR,Fuel)         regional annual dipatchable generation [TWh]
GenNonDisp_YHF(Yr,HMR,Fuel) regional non-dispatchable generation [TWh]

** Emissions ---------------------------------------------------

*by HMR
Emis_YH(Yr,HMR,Pol)                   "emissions by Yr, HMR [CO2: M tons; SO2,NOx: k tons]"
Emis_YHF(Yr,HMR,Fuel,Pol)             "emissions by Yr, HMR, Fuel [CO2: M tons; SO2,NOx: k tons]"
Emis_YHM(Yr,HMR,MP,Pol)               "emissions by Yr, HMR, MP [CO2: M tons; SO2,NOx: k tons]"
*Emis_YHST(Yr,HMR,Sea,TB,Pol)          "emissions by Yr, HMR, Sea, TB [CO2: M tons; SO2,NOx: k tons]"
*Emis_YHFST(Yr,HMR,Fuel,Sea,TB,Pol)    "emissions by Yr, HMR, Fuel, Sea, TB [CO2: M tons; SO2,NOx: k tons]"
Emis_YHMST(Yr,HMR,MP,Sea,TB,Pol)      "emissions by Yr, HMR, MP, Sea, TB [CO2: M tons; SO2,NOx: k tons]"
*by all PPARs  (useful PPARs)
Emis_YP(Yr,PPAR,Pol)                  "emissions by Yr, PPAR [CO2: M tons; SO2,NOx: k tons]"
Emis_YPF(Yr,PPAR,Fuel,Pol)            "emissions by Yr, PPAR, Fuel [CO2: M tons; SO2,NOx: k tons]"
Emis_YPM(Yr,PPAR,MP,Pol)              "emissions by Yr, PPAR, MP [CO2: M tons; SO2,NOx: k tons]"
*by emis policy (covered)
EmisEP_YP(Yr,PPAR,Pol)                "emissions by plants covered by an emissions policy by Yr, PPAR [CO2: M tons; SO2,NOx: k tons]"
EmisEP_YPF(Yr,PPAR,Fuel,Pol)          "emissions by plants covered by an emissions policy by Yr, PPAR, Fuel [CO2: M tons; SO2,NOx: k tons]"
EmisEP_YPM(Yr,PPAR,MP,Pol)            "emissions by plants covered by an emissions policy by Yr, PPAR, MP [CO2: M tons; SO2,NOx: k tons]"
*by PS policy (covered)  (receiving credits)
EmisPS_YP(Yr,PPAR,Pol)                "emissions by plants covered by a portfolio standard by Yr, PPAR [CO2: M tons; SO2,NOx: k tons]"
EmisPS_YPF(Yr,PPAR,Fuel,Pol)          "emissions by plants covered by a portfolio standard by Yr, PPAR, Fuel [CO2: M tons; SO2,NOx: k tons]"
EmisPS_YPM(Yr,PPAR,MP,Pol)            "emissions by plants covered by a portfolio standard by Yr, PPAR, MP [CO2: M tons; SO2,NOx: k tons]"
*by ITC (covered)
EmisITC_YP(Yr,PPAR,Pol)               "emissions by plants covered by an ITC by Yr, PPAR [CO2: M tons; SO2,NOx: k tons]"
EmisITC_YPF(Yr,PPAR,Fuel,Pol)         "emissions by plants covered by an ITC by Yr, PPAR, Fuel [CO2: M tons; SO2,NOx: k tons]"
EmisITC_YPM(Yr,PPAR,MP,Pol)           "emissions by plants covered by an ITC by Yr, PPAR, MP [CO2: M tons; SO2,NOx: k tons]"
*by PTC (covered) (receiving credits)
EmisPTC_YP(Yr,PPAR,Pol)               "emissions by plants covered by an PTC by Yr, PPAR [CO2: M tons; SO2,NOx: k tons]"
EmisPTC_YPF(Yr,PPAR,Fuel,Pol)         "emissions by plants covered by an PTC by Yr, PPAR, Fuel [CO2: M tons; SO2,NOx: k tons]"
EmisPTC_YPM(Yr,PPAR,MP,Pol)           "emissions by plants covered by an PTC by Yr, PPAR, MP [CO2: M tons; SO2,NOx: k tons]"
*AEO emissions
EmisAEO_YH(Yr,HMR,Pol)                "AEO emissions by Yr, HMR [CO2: M tons; SO2,NOx: k tons]"
EmisAEO_YP(Yr,PPAR,Pol)               "AEO emissions by Yr, PPAR [CO2: M tons; SO2,NOx: k tons]"
EmisAEO_YHF(Yr,HMR,Fuel,Pol)          "AEO emissions by Yr, HMR, Fuel [CO2: M tons; SO2,NOx: k tons]"
EmisAEO_YPF(Yr,PPAR,Fuel,Pol)         "AEO emissions by Yr, PPAR, Fuel [CO2: M tons; SO2,NOx: k tons]"
*average emissions rate (Haiku)
ERoAvg_YHF(Yr,HMR,Fuel,Pol)           "Average emission rate per unit output by Yr, HMR, Fuel [tons/MWh]"
ERoAvg_YPF(Yr,PPAR,Fuel,Pol)          "Average emission rate per unit output by Yr, PPAR, Fuel [tons/MWh]"
ERoAvg_YHST(Yr,HMR,Sea,TB,Pol)        "Average emission rate per unit output by Yr, HMR, Fuel, Sea, TB [tons/MWh]"
ERoAvg_YPST(Yr,PPAR,Sea,TB,Pol)       "Average emission rate per unit output by Yr, PPAR, Fuel, Sea, TB [tons/MWh]"
*        ERo(Yr,HMR,MP,Pol) "emissions rates per unit output [tons/MWh]"
*        PolScl(Pol) "k tons -> CO2: M tons; SO2,NOx: k tons]" /CO2 1E-3, SO2 1, NOx 1/
*        PolSclER(Pol) "tons -> CO2: tons; SO2,NOx: lbs]" /CO2 1, SO2 2E3, NOx 2E3/
*average emissions rate (AEO)
ERoAvgAEO_YHF(Yr,HMR,Fuel,Pol)     "AEO Average emission rate per unit output by Yr, HMR, Fuel [tons/MWh]"
ERoAvgAEO_YPF(Yr,PPAR,Fuel,Pol)    "AEO Average emission rate per unit output by Yr, PPAR, Fuel [tons/MWh]"

*EmisCap outputs are already defined

** Electricity Consumption & Prices ---------------------------------------------------

ECons_YH(Yr,HMR)             "electricity consumption by Yr, HMR [TWh]"
ECons_YHST(Yr,HMR,Sea,TB)    "electricity consumption by Yr, HMR, Sea, TB [TWh]"
ECons_YP(Yr,PPAR)            "electricity consumption by Yr, PPAR, Sea, TB [TWh]"
ECons_YPST(Yr,PPAR,Sea,TB)   "electricity consumption by Yr, PPAR, Sea, TB [TWh]"

EconsEV_YH(Yr,HMR)           "EV electricity consumption by Yr, HMR [TWh]"
EconsEV_YHST(Yr,HMR,Sea,TB)  "EV electricity consumption by Yr, HMR, Sea, TB [TWh]"
EconsEV_YP(Yr,PPAR)          "EV electricity consumption by Yr, PPAR [TWh]"
EconsEV_YPST(Yr,PPAR,Sea,TB) "EV electricity consumption by Yr, PPAR, Sea, TB [TWh]"

EConsStorage_YH(Yr,HMR)             "Storage electricity consumption by Yr, HMR [TWh]"
EConsStorage_YHST(Yr,HMR,Sea,TB)    "Storage electricity consumption by Yr, HMR, Sea, TB [TWh]"
EConsStorage_YP(Yr,PPAR)            "Storage electricity consumption by Yr, PPAR [TWh]"
EConsStorage_YPST(Yr,PPAR,Sea,TB)   "Storage electricity consumption by Yr, PPAR, Sea, TB [TWh]"

EConsBattery_YH(Yr,HMR)             "Battery electricity consumption by Yr, HMR [TWh]"
EConsBattery_YHST(Yr,HMR,Sea,TB)    "Battery electricity consumption by Yr, HMR, Sea,TB [TWh]"
EConsBattery_YP(Yr,PPAR)            "Battery electricity consumption by Yr, PPAR [TWh]"
EConsBattery_YPST(Yr,PPAR,Sea,TB)   "Battery electricity consumption by Yr, PPAR, Sea, TB [TWh]"

EConsPumped_YH(Yr,HMR)              "Pumped Hydro electricity consumption by Yr, HMR [TWh]"
EConsPumped_YHST(Yr,HMR,Sea,TB)     "Pumped Hydro electricity consumption by Yr, HMR, Sea, TB [TWh]"
EConsPumped_YP(Yr,PPAR)             "Pumped Hydro electricity consumption by Yr, PPAR [TWh]"
EConsPumped_YPST(Yr,PPAR,Sea,TB)    "Pumped Hydro electricity consumption by Yr, PPAR, Sea, TB [TWh]"

*retail prices.  Should I index over YrFull?
*EPrcRtl.l(Yr,HMR,Sea)    "retail price by Yr, HMR, Sea [$/MWh]"
EPrcRtl_YPS(Yr,PPAR,Sea) "regional average retail price by Yr, PPAR, Sea [$/MWh]"
EPrcRtl_YH(Yr,HMR)       "annual average retail price by Yr, PPAR, Sea [$/MWh]"
EPrcRtl_YP(Yr,PPAR)      "regional annual average retail price by Yr, PPAR, Sea [$/MWh]"

*when we switch to sectoral output
*ECons(CC)
*EConsStorage
*EConsBattery
*EConsPumped

*by HMR
*YH
*YHC
*YHST
*YHCST

*by all PPARs  (useful PPARs)
*YP
*YPC
*YPST
*YPCST

** Trade ---------------------------------------------------
        TDLossAnn(Yr,HMR) "Losses from T&D System by HMR [TWh]"
        TDLossAnnPPAR(Yr,PPAR) "Losses from T&D System by PPAR [TWh]"
        NetImportsYP(Yr,PPAR) Net Imports [TWh] "Net imports by PPAR (taking into account losses) [TWh]"
        NetImportsYPS(Yr,HMR,Sea) "Net imports [TWh] by season"
        NetImportsYHST

*NetImports
*YP
*YPS
*YPST

*YH
*YHS
*YHST


*calculate Net imports with alternative method

** Policy ---------------------------------------------------
        PSReqQty(Yr,PPAR) "Portfolio standard requirement [TWh]"
        Allowances(Yr,PPAR,step) "Number of Allowances purchased [thousand tons]"
*bank size (EmisYfPCover - EmisCapNom)
*how many clean credits did we create / buy (including ACPs)
** Policy Revenues and Costs---------------------------------
*        ITCExpendYfP(YrFull,PPAR)"Government Expenditure on Investment Tax Credit in PPAR [million $]"
*        PTCExpendYfP(YrFull,PPAR) "Government Expenditure on Production Tax Credit in PPAR [million $]"
*        CEPPExpendYfP(YrFull,PPAR) "Government Expenditure on Clean Electricity Performance Program in PPAR [million $]"
*        CPriceRev(Yr,PPAR) "Carbon Price Revenues [million $/year]"
        ITCCapCost(YrFull,HMR,MP) "The Capital Cost reduction of Investment Tax Credits [$/kW/yr]"
        CESTotVal(Yr,PPAR) "Clean Energy Standard [million $/year]"
*//remove
        CESBankTot(PPAR) "Clean Energy Standard w/ bank Qualifying Generation [GWh (probably)]"
        CESConsReqTot(PPAR) "Clean Energy Standard w/ bank Consumption Requirement   [GWh (probably)]"
*//remove
        CESBank(Yr,PPAR) "Amount of Clean Energy Generation Exceeding Requirement [TWh]"
        NationalCE(Yr) "% of Clean Energy Generation in a given year (even with CES off) [manually set qualifying generation]"

** Policy Quantities
*PSReqQty
*PSQty achieved
*Bank of PS credits created
*bank of emissions allowances created (EmisYPCover - EmisCapNom)

*YPM
*YP
** Policy Revenues + Costs
*government outlays / revenue collected
*PTCoutlays = each year for ten years after the build of incremental capacity  (positive spending)
*ITCoutlays = in first year of incremental capacity build (positive spending)
*AlwRevenue = AlwPrc*Emis   (positive revenue = negative spending)

*YPM
*YHM
*YP
*YH
*policy costs / subsidies from the point of view of consumer (generator?)
*PTCSubsidy = each year for ten years after the build of incremental capacity including haircut (positive subsidy = negative cost)
*ITCSubsidy = each year for 20 years after the build of incremental capacity including haircut (positive subsidy = negative cost)
*AlwCost = AlwPrc * Emis (positive cost)


*YPM
*YHM
*YP
*YH
*credit value
* PSValue = PSPrc * CreditPct * Qualifying generation

*bank value
* Emis: excess allowances accumulated in a bank * AlwPrc in current year
* AlwPrc in the year banked * credits banked
* PS: excess clean credits accumulated in a bank * PSPrc in current year
* credit price in year banked * credits banked in that year



** Levelized Costs--------------------------------------------
        LCOE_Ex(Yr,PPAR,Fuel,MP)  "LCOE of existing MPs [$/MWh]"
        LCOE_New(Yr,PPAR,Fuel,MP) "LCOE of new MPs [$/MWh]"
        LFOM(Yr,PPAR,Fuel,MP)     "Levelized fixed operations and maintenance costs [$/MWh]"
        LCapCo(Yr,PPAR,Fuel,MP)   "Levelized capital costs [$/MWh]"
        LVOM(Yr,PPAR,Fuel,MP)     "Levelized variable operations and maintenance costs [$/MWh]"
        LFCo(Yr,PPAR,Fuel,MP)     "Levelized fuel costs [$/MWh]"
        LPolCo(Yr,PPAR,Fuel,MP)   "Levelized policy costs [$/MWh]"
        LFixCo(Yr,PPAR,Fuel,MP)   "Levelized fixed costs [$/MWh]"
        LVarCo(Yr,PPAR,Fuel,MP)   "Levelized variable costs [$/MWh]"
*YHM (for cuture construction)
*YPF (summary)
** Resource Costs -------------------------------------------------------------------------------
*index over HMR
        FCoExpend(Yr,PPAR,MP)   "Total Fuel Cost Expenditures by PPAR, MP [million $]"
        VOMExpend(Yr,PPAR,MP)   "Total Variable Operations and Maintenance Expenditures by PPAR, MP [million $]"
        FOMExpend(Yr,PPAR,MP)   "Total Fixed Operations and Maintenance Expenditures by PPAR, MP [million $]"
        CapCoExpend(Yr,PPAR,MP) "Total Capital Expenditures by PPAR, MP [million $]"
*no underscore
*RCostFCo_YHM(Yr,HMR,MP)
*RCostFCo_YH(Yr,HMR,MP)
        RCost_FCo(Yr,PPAR)     "Resource Costs from Fuel Costs by PPAR [million $]"
        RCost_VOM(Yr,PPAR)     "Resource Costs from Variable Operations and Maintenance by PPAR [million $]"
        RCost_FOM(Yr,PPAR)     "Resource Costs from Fixed Operations and Maintenance by PPAR [million $]"
        RCost_CapCost(Yr,PPAR) "Resource Costs from Capital Costs by PPAR [million $]"
        RCost_Imp(Yr,PPAR)     "Resource Costs from Imports by PPAR [million $]"
        RCost_Exp(Yr,PPAR)     "Resource Costs from Exports by PPAR [million $] (negative cost = savings)"
** Fuel consumption and expenditures ---------------------------------------------------
        FuelExp(Yr,HMR,MP) "fuel expenditure [k$]"
        FuelCons(Yr,HMR,MP) "fuel consumption [MMBtu]"
        FCiNat(Yr,Fuel) "national annual average delivered fuel cost [$/MMBtu]"

*figure out dimensions
*YHFM
*YHF
*YPFM
*YPF
** Calibration ---------------------------------------------------
        CalRGGIHaiku(Yr,HMRRGGICal,Fuel) annual generation by fuel type in RGGI regions [TWh]
        CalRGGIAEO(Yr,HMRRGGICal,Fuel) annual AEO generation by fuel type in RGGI regions [TWh]
        CalEmisRGGIHaiku(Yr) annual emissions in RGGI regions [M tons]
        CalEmisRGGIAEO(Yr)  annual AEO emissions in RGGI regions [M tons]

** Check Against AEO  (mostly for calibration) ---------------------------------------------------------
*convert to percents?
        Chk_Gen(Yr,HMR,Fuel)  Difference between AEO generation and Haiku Generation by Yr HMR and Fuel
        Chk_Emis(Yr)          Difference between AEO emissions and haiku emissions by Yr
        Chk_Emis_RGGI(Yr)     Difference between AEO emissions in RGGI and haiku emissions in RGGI by Yr
;
