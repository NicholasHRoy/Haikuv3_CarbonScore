$onempty
$include %UI_RootDir%\Output\%UI_Scen%\UI_%UI_Scen%
$show

Scalar SrpsDsp suppress display statements in DefScen? /0/;
$if %UI_SprsDspDefScen% == Yes SrpsDsp=1;
display$(not SrpsDsp) SrpsDsp;

* Define macros.
**----------------------------------------------------------------------------------------------------------------------
$include DS1_Macros

* Declare sets and parameters, then populate those that are inputs with data.
**----------------------------------------------------------------------------------------------------------------------
$include DS2_DecSetsPrm_LdData

* Define model parameters: general, PPARs, Consumption
**----------------------------------------------------------------------------------------------------------------------
$include DS3_General
$include DS4_PPAR
$include DS4a_Consumption

* Define variable, equations, and models for LP and MCP. Load initial values.
**----------------------------------------------------------------------------------------------------------------------
$include DS5_DecVarEqMdl
$include DS6_LdInitVar

* Some model constraints are imposed by bounds on variables instead of explicitly in equations.
**----------------------------------------------------------------------------------------------------------------------
$include DS7_Bnds

* Policy options for emissions constraints and portfolio standards.
**----------------------------------------------------------------------------------------------------------------------
*$ifthen.SetPol %UI_SetPol% == Yes


$include DS8_PolOpts_Emis
parameter GenAEOtottmp(Yr) ;
GenAEOtottmp(Yr) = sum((HMR,Sea,Fuel),GenAEOSeaFuel(Yr,HMR,Sea,Fuel));
display GenAEOtottmp;
$include DS9_PolOpts_PS

*$endif.SetPol

* Last bits that could still use a better home.
**----------------------------------------------------------------------------------------------------------------------

*Alternative BL
EConsShkAdd(Yr,HMR,Sea,TB)=0;
$ifthen.SetBL %UI_BLPol% == alt
        CapCost(Yr,HMR,'New Solar')={5,6:}0.92{3:0.65}{2:0.75}{1,4:0.85}*CapCost(Yr,HMR,'New Solar');
        CapCost(Yr,HMR,'New Wind')= {1,4,5,6:}0.95{2,3:0.85}*CapCost(Yr,HMR,'New Wind');
        FCiRef(Yr,HMR,'NG')=        {6:0.95}{1,4,5:}0.90{3:0.70}{2:0.80}*FCiRef(Yr,HMR,'NG');
$elseif.SetBL %UI_BLPol% == chpgas
        FCiRef(Yr,HMR,'NG')=        {6:0.95}{1,4,5:}{chp:}0.90{3:0.70}{2,chpr:0.80}*FCiRef(Yr,HMR,'NG');
$elseif.SetBL %UI_BLPol% == chprgas
        FCiRef(Yr,HMR,'NG')=        {6:0.95}{1,4,5:}{chp:0.90}{3:0.70}{2,chpr:}0.80*FCiRef(Yr,HMR,'NG');
$elseif.SetBL %UI_BLPol% == chpsol
        CapCost(Yr,HMR,'New Solar')={5,6:}0.92{3:0.65}{2:0.75}{1,4:0.85}*CapCost(Yr,HMR,'New Solar');
$elseif.SetBL %UI_BLPol% == DemNat
        EConsShkAdd(Yr,HMR,Sea,TB)=EConsRef(Yr,HMR,Sea,TB)*0.005*(SimYr(Yr)-2019);
$elseif.SetBL %UI_BLPol% == DemSE
        Set HMRSE(HMR)  /NC,SC,GA,FL,AL,MS,TN/;
        EConsShkAdd(Yr,HMR,Sea,TB)=EConsRef(Yr,HMR,Sea,TB)*0.005*(SimYr(Yr)-2019);
$endif.SetBL

*Any combination of calibration components may be disabled by uncommenting...
*POTENTIAL PROBLEMS DEALING WITH MISSING VARIABLES/EQUATIONS
*CalEPrcRtl.fx(Yr,HMR,Sea)=0;
*CalEDemCoeff.fx(Yr,HMR,Sea,TB)=EConsRef(Yr,HMR,Sea,TB)*EPrcRef(Yr,HMR,Sea,TB)**(-EDemElast);
*CalGen.fx(Yr,HMR,Fuel)=CalGen.L(Yr,HMR,Fuel);
*Sets
*        CalGenHMR(HMR)   /MO/
*        CalGenFuel(Fuel) /NG/
*;
*CalGen.up(Yr,CalGenHMR(HMR),CalGenFuel(Fuel))=+INF;
*CalEmis.fx(Yr)=0;
*CalEmisRGGI.fx(Yr)=0;
*...end

* T&D losses are treated as uniform across HMRs, but independent across seasons. The levels are set to make CalVOMeq
* consistent with SupDemEq.
*--------------------------------------------------
NetFrgnImpCHP(Yr,HMR,Sea,TB)=NetImp(Yr,HMR,Sea,TB)+CHPExo(Yr,HMR,Sea,TB);
*This modest little command is the glue that makes calibration possible.
*This command only works if we are importing AEO levels of demand from stata input data
TDLoss(Yr,Sea)=1-( sum((HMR,Month,Sector),EConsRefMC(Yr,Month,HMR,Sector)*SeaMonth(Sea,Month))
          /sum(HMR,sum(Fuel,GenAEOSeaFuel(Yr,HMR,Sea,Fuel)$(not FuelStorage(Fuel)))+sum(TB,NetFrgnImpCHP(Yr,HMR,Sea,TB))) );


Parameters
GenTDComp(Yr,Sea)
EConsTDComp(Yr,Sea)
FrgnImpTDComp(Yr,Sea)
CHPExoTDComp(Yr,Sea)
;
GenAEOtottmp(Yr) = sum((HMR,Sea,Fuel),GenAEOSeaFuel(Yr,HMR,Sea,Fuel)$(not FuelStorage(Fuel)));
GenTDComp(Yr,Sea) = sum(HMR,sum(Fuel,GenAEOSeaFuel(Yr,HMR,Sea,Fuel)$(not FuelStorage(Fuel))));
EConsTDComp(Yr,Sea) = sum((HMR,Month,Sector),EConsRefMC(Yr,Month,HMR,Sector)*SeaMonth(Sea,Month));
FrgnImpTDComp(Yr,Sea) = sum(HMR,sum(TB,NetImp(Yr,HMR,Sea,TB)));
CHPExoTDComp(Yr,Sea) = sum(HMR,sum(TB,CHPExo(Yr,HMR,Sea,TB)));

display TDLoss;

$ifthen.TDLossFx %UI_FxTDLoss% == Yes
TDLoss(Yr,Sea)$(SimYr(Yr)>=2035) = TDLoss('Yr16', Sea);
$endif.TDLossFx
display TDLoss;


*-----------------------------------------------------------------------------------------------------------------------
$ontext
put dummy;
put_utility 'gdxout' / '%UI_RootDir%\TDComp';
execute_unload
GenTDComp, EConsTDComp, FrgnImpTDComp, CHPExoTDComp, TDLoss, GenAEOtottmp;

;
putclose;
$offtext

*Pin down CalVOM with a zero in Pennsylvania, which is selected arbitrarily.
*CalVOM.fx(Yr,'PA')=0;

* Check for mistakes.
**----------------------------------------------------------------------------------------------------------------------
assert=smin((HMR,MP,Sea),CumPlnInvRtr('Yr0',HMR,MP)=0);
abort$(assert=0) "Yr0 should have no planned investments or retirements.", CumPlnInvRtr;
assert=smin((HMR,MP,Sea),OpNPCapRat(HMR,MP,Sea)>=0 and OpNPCapRat(HMR,MP,Sea)<1.5);
abort$(assert=0) "OpNPCapRat should be greater equal than 0 and less than 1.5.", OpNPCapRat;
assert=smin((Yr,HMR,MP),NPCap.L(Yr,HMR,MP)>=0);
abort$(assert=0) "Nameplate capacity should initialize as a positive value.", NPCap.L;
*assert=smin((HMR,MP,Sea),0.8>OpNPCapRat(HMR,MP,Sea) and OpNPCapRat(HMR,MP,Sea)<=1.2)
*abort$(assert eq 0) "SumCap0 should be within +/- 20% of NPCap", OpNPCapRat;
