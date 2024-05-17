$onText

*create set for Marc's model
*-----------------------------------------------------------------------------------------------------------------------
$Title Results
$OffUpper
$OnSymList
$eolcom !!
$inlinecom { }


$include Init

* User inputs
$set UI_Func         Res !! [DM,SI,Slv,Res] run which function?
$set UI_SetPol       No !! [Yes,No] Run EmisPol_Opts?
$set UI_RptAllPPAR   Yes !! [Yes,No] Activate all PPARs for reporting? Yes only for running Results.gms.
$set UI_ResVers      200312

* Name of output folder
$set UI_Res TCIresults_%UI_ResVers%_v1
$call mkdir %UI_RootDir%\E3Res\E3Res_%UI_Res%\;

* Initialize sets, parameters by running DecScen
$if not set UI_Scen $set UI_Scen  8F_BLRPS_200307bl_v7
$if not set UI_CTax $set UI_CTax  17

$include DefScen
* Initialize parameters added in Results by running Results_Def, which is a
* copy of parameter definition section of Results
$include Results_Def

put_utility 'gdxin' / '%UI_RootDir%\..\Shared\Solutions\%UI_InitVar%';
execute_load NPCap, Gen, Trans, EPrcRtl, ECons,
             gamma, MCGen, MCCap, lambda, MCNoDsp,
             AlwIss, AlwPrc, AlwAlc, PSPrc, PSReq, AlwPrcBank,SupDemEq.M
*, ObjInt
;

put_utility 'gdxin' / '%UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen%';
execute_load
             CapCostF, FOMF, VOMF, HRF, FCoF, ERoF,
             EPrcRtlAnn,EPrcRtlPPAR,EConsPPAR,
             NetImportsYP, TDLossAnnPPAR, Trans,
             NPCapYPFM, NPCapFuel,
             Gen, GenYPFM, GenYHFST, GenYPFST, GenAnn,GenFuel
             EmisYPFM, EmisFuelYPCvr_EmisPol, EmisYPCvr_EmisPol, EmisCapNom,
             AlwIss, AlwIssPrc, AlwPrc, PSPrc, PSReq,
             PSReqQty, PS_RefER, GenYPFMCred_PS,
             AlwAlc,AlwIssPPAR,
*             AlwAlcPctPH,
             map_EmisPol_YPH,
             EConsEVTBpctSea, EConsEVExoAnn,
             EConsYHST, EConsYPST, EConsEVYHST, EConsEVYPST, Obj, ObjInt, TotCost_YrHMR, TotCostLP,
             CalGen, CalGenTot, EmisAEO, GenAEOFuelYH,SupDemEq.M,TDLossAnn,RsvMrgEq.M

;

*---------------------------------------------------------------------------------------------------------------
$offText
set
f
/Coal, NGOil, Nuke, Hydro, Wind, Solar, Other/
map_f(f,fuel)
/Coal.Coal
 NGOil.NG
 NGOil.Oil
 Nuke.Nuke
 Hydro.Hydro
 Wind.Wind
 Solar.Solar
 Other.Bio
 Other.Geo
 Other.Oth/
map_FMP(f,MP)
;


map_FMP(f,MP)= sum(Fuel,map_f(f,Fuel)*MPFuel(MP,Fuel));

display
f
map_f
MPFuel
map_FMP
;



Parameter
EnRevMST(Yr,HMR,MP,Sea,TB)
EnRevM(Yr,HMR,MP)
EnRev2(Yr,HMR,f)
EnRev(Yr,HMR,f)    "Energy Revenue from Wholesale market [$]"

CapPrcH(Yr,HMR,Sea,TB)
CapRevMST(Yr,HMR,MP,Sea,TB)
CapRevM(Yr,HMR,MP)
CapRevF(Yr,HMR,f) "Capacity Revenue from Capacity market [$]"

RECPrcPM(Yr,HMR,PPAR,MP)
RECPrcM(Yr,HMR,MP)
RECRevM(Yr,HMR,MP)
RECRev2(Yr,HMR,f)
RECRev(Yr,HMR,f)   "Revenue to wind and solar from RPS credits [$]"

GenM(Yr,HMR,MP)
GenF2(Yr,HMR,f)
GenF(Yr,HMR,f)     "Generation by fuel type [MWh]"

CapM(Yr,HMR,MP)
CapF2(Yr,HMR,f)
CapF(Yr,HMR,f)     "Capacity by fuel type [MW]"

CostM(Yr,HMR,MP)
CostMTot(Yr,HMR,MP)
CostFTot(Yr,HMR,f)
CostF2(Yr,HMR,f)
CostF(Yr,HMR,f)    "Average fuel cost by fuel type [$/MWh]"

CostFOMTotM(Yr,HMR,MP)
CostFOMTotF(Yr,HMR,f)
CostFOM2(Yr,HMR,f)
CostFOM(Yr,HMR,f) "Average fixed O&M costs by fuel type [$/MW/yr]"

CostAlwMP(Yr,PPAR,HMR,MP)
CostAlwM(Yr,HMR,MP)
CostAlwTotM(Yr,HMR,MP)
CostAlwTotF(Yr,HMR,f)
CostAlw2(Yr,HMR,f)
CostAlw(Yr,HMR,f)  "Average variable cost by fuel type of purchasing emissions allowances [$/MWh]"

CostVOMTotM(Yr,HMR,MP)
CostVOMTotF(Yr,HMR,f)
CostVOM2(Yr,HMR,f)
CostVOM(Yr,HMR,f)  "Average variable O&M costs by fuel type [$/MWh]"

EmisM(Yr,HMR,MP)
EmisF(Yr,HMR,f)  "Emissions by fuel type [short tons]"

AEOPrc(Yr,HMR)   "AEO 2019 Retail Electricity Price [$/MWh] "
AEOCons(Yr,HMR)  "AEO 2019 Consumption [MWh]"
AEORev(Yr,HMR)   "AEO 2019 Retail Revenue [$]"
TDLossH(Yr,HMR)   "TD Losses [MWh]"

USImports(Yr)    "US Imports [MWh]"
IntImp(Yr,HMR)    "International Imports [MWh]"
IntImpRevST(Yr,HMR,Sea,TB)  "International Import Revenue/Cost [$]"
IntImpRev(Yr,HMR)  "International Imports Revenue/Cost [$]"

TransH(Yr,HMRe,HMRi)   "Transmission from HMRe to HMRi [MWh]"
TransHH(Yr,HMRe,HMRi)  "Net Transmission from HMRe to HMRi [MWh]"
TransHi(Yr,HMRi)       "Net Imports by HMR [MWh]"
TransHe(Yr,HMRe)       "Net Exports by HMR = (-1)*(Net Imports by HMR) [MWh]"

TransRevST(Yr,HMRe,HMRi,Sea,TB)  "Revenue from Interstate trade by Year, State, State, Sea, TB [$]"
TransRevHH(Yr,HMRe,HMRi)         "Revenue from Interstate trade by Year, State, State [$]"
TransRevNet(Yr,HMRe,HMRi)        "Net Revenue from Interstate trade by Year, State, State [$]"
TransRevNetI(Yr,HMRi)            "Net Revenue paid by the importing state by Year and Importing State [$]"
TransRevNetE(Yr,HMRe)            "Net Revenue paid to the exporting state by Year and Exporting State [$]"



NetImportsH(Yr,HMR)
NetImportsH2(Yr,HMR)

;


**Energy Revenue by Yr State Fuel
*GWh * k$/GWh * $1000/k$= $
EnRevMST(Yr,HMR,MP,Sea,TB) = Gen.l(Yr,HMR,MP,Sea,TB)*SupDemEq.M(Yr,HMR,Sea,TB)*1000;
EnRevM(Yr,HMR,MP) = sum((Sea,TB),EnRevMST(Yr,HMR,MP,Sea,TB));
EnRev(Yr,HMR,f) = sum(MP,map_FMP(f,MP)*EnRevM(Yr,HMR,MP));

*Capacity Revenue by Yr state and Fuel
CapPrcH(Yr,HMR,Sea,TB) = sum(RsvRg,RsvMrgEq.M(Yr,RsvRg,Sea,TB)*map_RsvRg(HMR,RsvRg));
* ($/MW)*GW*Frac*frac*1000MW/GW = $
CapRevMST(Yr,HMR,MP,Sea,TB) = CapPrcH(Yr,HMR,Sea,TB)* OpNPCapRat(HMR,MP,Sea)*NPCap.l(Yr,HMR,MP)*ACFRsv(Yr,HMR,MP,Sea,TB)*1000;
CapRevM(Yr,HMR,MP) = sum((Sea,TB),CapRevMST(Yr,HMR,MP,Sea,TB));
CapRevF(Yr,HMR,f) = sum(MP,map_FMP(f,MP)*CapRevM(Yr,HMR,MP));

Display
RsvMrgEq.M
map_RsvRg
CapPrcH
;

*$stop
**REC Revenue by Yr State Fuel
*$/MWh
RecPrcPM(Yr,HMR,PPAR,MP)=PSPrc.L(Yr,PPAR)*map_PS_YPHM(Yr,PPAR,HMR,MP);
RecPrcM(Yr,HMR,MP) = sum(PPAR,PSPrc.L(Yr,PPAR)*map_PS_YPHM(Yr,PPAR,HMR,MP));
*GWh *(1000 MWh/GWh) * $/MWh = $
RecRevM(Yr,HMR,MP) = sum((Sea,TB),Gen.l(Yr,HMR,MP,Sea,TB))*1000 * RecPrcM(Yr,HMR,MP);
RECRev(Yr,HMR,f) = sum(MP,map_FMP(f,MP)*RecRevM(Yr,HMR,MP));


**Generation by Yr State Fuel
*GWh * 1000 = MWh
GenM(Yr,HMR,MP) = sum((Sea,TB),Gen.l(Yr,HMR,MP,Sea,TB))*1000;
GenF(Yr,HMR,f) = sum(MP,map_FMP(f,MP)*GenM(Yr,HMR,MP));

*Capacity by Yr State Fuel
*GW * 1000 = MW
CapM(Yr,HMR,MP) = NPCap.l(Yr,HMR,MP)*1000;
CapF(Yr,HMR,f) = sum(MP,CapM(Yr,HMR,MP)*map_FMP(f,MP));

*Fuel Cost by Yr State Fuel
*$/MWh
CostM(Yr,HMR,MP)=FCoF(Yr,HMR,MP);
CostMTot(Yr,HMR,MP)=CostM(Yr,HMR,MP)*GenM(Yr,HMR,MP);
CostFTot(Yr,HMR,f)=sum(MP,map_FMP(f,MP)*CostMTot(Yr,HMR,MP));
CostF(Yr,HMR,f)$(GenF(Yr,HMR,f)<>0)= CostFTot(Yr,HMR,f) / GenF(Yr,HMR,f);

*Fixed O&M Costs by Yr State Fuel
*$/kW/yr * 1000kW/MW = $/MW/yr
CostFOMTotM(Yr,HMR,MP) = FOMF(Yr,HMR,MP)*CapM(Yr,HMR,MP)*1000;
CostFOMTotF(Yr,HMR,f) =sum(MP,map_FMP(f,MP)*CostFOMTotM(Yr,HMR,MP));
CostFOM(Yr,HMR,f)$(CapF(Yr,HMR,f)<>0) = CostFOMTotF(Yr,HMR,f)/CapF(Yr,HMR,f);

*Allowance Cost by Yr State Fuel
*$/ton * ton/MWh = $/MWh, $/ton * ton/MWh * MWh = $
CostAlwMP(Yr,PPAR,HMR,MP) = AlwPrc.L(Yr,PPAR)*map_EmisPol_YPHM(Yr,PPAR,HMR,MP);
CostAlwM(Yr,HMR,MP) = sum(PPAR,AlwPrc.L(Yr,PPAR)*map_EmisPol_YPHM(Yr,PPAR,HMR,MP));
CostAlwTotM(Yr,HMR,MP) = CostAlwM(Yr,HMR,MP)*GenM(Yr,HMR,MP)*ERo(Yr,HMR,MP,'CO2');
CostAlwTotF(Yr,HMR,f) = sum(MP,map_FMP(f,MP)*CostAlwTotM(Yr,HMR,MP));
CostAlw(Yr,HMR,f)$(GenF(Yr,HMR,f)<>0) = CostAlwTotF(Yr,HMR,f)/GenF(Yr,HMR,f);

*Variable O&M Costs by Yr State Fuel
*$/MWh
CostVOMTotM(Yr,HMR,MP)=VOMF(Yr,HMR,MP)*GenM(Yr,HMR,MP);
CostVOMTotF(Yr,HMR,f)=sum(MP,map_FMP(f,MP)*CostVOMTotM(Yr,HMR,MP));
CostVOM(Yr,HMR,f)$(GenF(Yr,HMR,f)<>0) = CostVOMTotF(Yr,HMR,f)/GenF(Yr,HMR,f);

*Emissions by Yr, State, Fuel
*MWh * tons/MWh = tons
EmisM(Yr,HMR,MP) = GenM(Yr,HMR,MP)*ERo(Yr,HMR,MP,'CO2');
EmisF(Yr,HMR,f) = sum(MP,map_FMP(f,MP)*EmisM(Yr,HMR,MP));

*Retail Price, Revenue, and Consumption from AEO
*M$ * 1000000$/M$ = $, GWh*1000 MWh/GWh = MWh
AEOPrc(Yr,HMR) = sum(Month,ERevRefMC(Yr,Month,HMR,'Tot')*1000000) / sum(Month,EConsRefMC(Yr,Month,HMR,'Tot')*1000);
*GWh*1000 = MWh
AEOCons(Yr,HMR) = sum((Sea,TB),EConsExo(Yr,HMR,Sea,TB))*1000;
AEORev(Yr,HMR) = AEOCons(Yr,HMR) * AEOPrc(Yr,HMR);

*Annual Transmission Losses by Yr and State
* TWh*1000000 = MWh
TDLossH(Yr,HMR) = TDLossAnn(Yr,HMR) * 1000000;

*Net US Imports, TWh*1000000 = MWh
USImports(Yr) = NetImportsYP(Yr,'Nat') * 1000000;

*Imports by state as consistent with consumption, generation and losses
NetImportsH(Yr,HMR) = AEOCons(Yr,HMR) + TDLossH(Yr,HMR) - sum(f,GenF(Yr,HMR,f));

*International Imports by by Yr, Stat
*GWh*1000 = MWh
IntImp(Yr,HMR)  =  sum((Sea,TB),NetImp(Yr,HMR,Sea,TB))*1000;

*Money spent by states on International Imports by Yr State Fuel.  Assumed to by the wholesale price in the importing state times quantity
IntImpRevST(Yr,HMR,Sea,TB) = NetImp(Yr,HMR,Sea,TB) * SupDemEq.M(Yr,HMR,Sea,TB)*1000;
IntImpRev(Yr,HMR) = sum((Sea,TB),IntImpRevST(Yr,HMR,Sea,TB));

*Total Transmission
*GWh to MWh
TransH(Yr,HMRe,HMRi) = sum((Sea,TB),Trans.l(Yr,HMRe,HMRi,Sea,TB))*1000;
*Net Transmissions
TransHH(Yr,HMRe,HMRi) = TransH(Yr,HMRe,HMRi)-TransH(Yr,HMRi,HMRe);
*Net imports
TransHi(Yr,HMRi) = sum(HMRe,TransHH(Yr,HMRe,HMRi));
*Net exports
TransHe(Yr,HMRe) = sum(HMRi,TransHH(Yr,HMRe,HMRi));

*Import/Export Revenues by Yr HMR, assumed to be the
TransRevST(Yr,HMRe,HMRi,Sea,TB) = Trans.l(Yr,HMRe,HMRi,Sea,TB)*SupDemEq.M(Yr,HMRe,Sea,TB)*1000;
TransRevHH(Yr,HMRe,HMRi) = sum((Sea,TB),TransRevST(Yr,HMRe,HMRi,Sea,TB));
TransRevNet(Yr,HMRe,HMRi) = TransRevHH(Yr,HMRe,HMRi) - TransRevHH(Yr,HMRi,HMRe);
TransRevNetI(Yr,HMRi)=sum(HMRe,TransRevNet(Yr,HMRe,HMRi));
TransRevNetE(Yr,HMRe)=sum(HMRi,TransRevNet(Yr,HMRe,HMRi));


Display
EnRevMST
EnRevM
EnRev

CapPrcH
CapRevMST
CapRevM
CapRevF

RECPrcPM
RECPrcM
RECRevM
RECRev

GenM
GenF

CapM
CapF

CostM
CostMTot
CostFTot
CostF

CostFOMTotM
CostFOMTotF
CostFOM

CostAlwMP
CostAlwM
CostAlwTotM
CostAlwTotF
CostAlw

CostVOMTotM
CostVOMTotF
CostVOM

EmisM
EmisF

AEOPrc
AEOCons
AEORev
TDLossH

USImports
IntImp
IntImpRevST
IntImpRev

TransH
TransHH
TransHi
TransHe

TransRevST
TransRevHH
TransRevNet
TransRevNetI
TransRevNetE

NetImportsH
;



*Create gdx, convert to xlsx. For some unknown reason, the freezeheader and sorttoc settings are not working.
*-----------------------------------------------------------------------------------------------------------------------
put dummy;
put_utility 'gdxout' / '%UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen%_E3';
execute_unload

EnRev, CapRevF, RECRev, GenF, CapF, CostF, CostFOM, CostAlw, CostVOM, EmisF, AEOPrc, AEOCons, AEORev, TDLossH, TransHi, TransRevNetI, IntImp, IntImpRev

;
putclose;

$onecho > gdx2xls.ini
[settings]
sorttoc=false
freezeheader=1
valueformat=#,###.###
$offecho
execute 'gdx2xls %UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen%_E3 @gdx2xls.ini';

$ontext
$onecho > gdx2access.ini
[settings]
$offecho
*execute 'gdx2access %UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen%_E3.gdx @gdx2access.ini';
$offtext

*GenFuel (Gen by Fuel by HMR by year in GWh
*Gen (Gen by MP, HMR Year in GWh)
*VOMF (VOMF by MP, HMR, Year, in $/MWh)
*FOMF (Fixed OM by Yr, HMR, MP $/kWh/Yr)
*FCoF (Fuel Cost by Yr, HMR, MP, $/MWh)
*EConsExoAnn (Yr, HMR, GWh)
