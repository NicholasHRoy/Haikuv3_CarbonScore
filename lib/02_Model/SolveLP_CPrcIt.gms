$title Solve LP
$offUpper
$eolcom !!
$inlinecom { }
*$onSymList
*$offlisting
option limrow=5E4 !!, limcol=0{1E5}, solprint=silent, lp=cplex, sysout=on;

* User inputs
*-------------------------------------------------------------------------------------------------------------
$include Init
$set UI_Func           LP !! [DM,SI,Slv,Res,LP] run which function?
$set UI_SetPol         No !! [Yes,No] Run PolOpts_*?
$set UI_SprsDspDefScen Yes !! [Yes,No] Suppress display statements in DefScen?
$set UI_SrpsDspLPLong  No !! [Yes,No] Suppress display statements in SolveLP?
$set UI_SlvLoad        Slv !![Slv,Load] Solve the LP or load the previous solution?

*$if not set UI_Scen    $set UI_Scen    8FLP_BLAEO_AgH
$if not set UI_Scen    $set UI_Scen    8FLP_Cal_AgH_1step
$if not set UI_Scen    $set UI_Scen    8FLP_Cal_AgH_2stepsNOadj
$include DefScen

*-------------------------------------------------------------------------------------------------------------
* INITIALIZE POST-PROCESSING PARAMTERS
Sets
*    ResYr(Yr) /Yr16/
    ResPPAR(PPAR) /Nat, TCI, NonTCI, RGGI12, RGGI9/
*    ResHMR(HMR)   /ME, VT, NH, MA, RI, CT, NY, NJ, PA, DE, MD, DC, VA, NC, OH/
*    ResSea(Sea) /Sum/
*    ResTB(TB) /1/
;
Alias (Yr, ResYr)
Alias (HMR, ResHMR)
Alias (Sea, ResSea)
Alias (TB, ResTB)
Alias (MP, ResMP)

Parameters
    KeyRes(*,*,*,*,*,*,*,*,*) !! Scen,Var,Yr,PPAR,Fuel,MP,Pol
;

*-------------------------------------------------------------------------------------------------------------
* Data Adjustments
*-------------------------------------------------------------------------------------------------------------
ACFGen(Yr,HMR,'New Onshore Wind',Sea,TB)$(SimYr(Yr)>=2020) = WindAF(HMR,'Onshore',Sea,TB);
ACFRsv(Yr,HMR,'New Onshore Wind',Sea,TB) = ACFGen(Yr,HMR,'New Onshore Wind',Sea,TB);
ACFGen(Yr,HMR,'New Offshore Wind',Sea,TB)$(SimYr(Yr)>=2020) = WindAF(HMR,'Offshore',Sea,TB);
ACFRsv(Yr,HMR,'New Offshore Wind',Sea,TB) = ACFGen(Yr,HMR,'New Offshore Wind',Sea,TB);

*adjust coal emissions up
display
ERo
;
*increase heat rates of coal plants by 9% for coal to match AEO (including Colorado)
*The Initial Haiku emissions/Generation we compare to come from
*"T:\Haikuv3\GAMS_161201\Scenarios\200420_HaikuColorado\Output\8F_LPCal_200307bl_v12_NGCoalCal"
*The file ScaleEmissions.xlsx has the calculations
ERo(Yr,HMR,MP,'CO2')$(MPFuel(MP,'Coal') and not HMR_CO(HMR))= ERo(Yr,HMR,MP,'CO2')*(1.09);
FCo(Yr,HMR,MP,Sea)$(MPFuel(MP,'Coal')and not HMR_CO(HMR)) = FCo(Yr,HMR,MP,Sea)*(1.09);
*increase heat rate of gas plants by 30% to match AEO
ERo(Yr,HMR,MP,'CO2')$(MPFuel(MP,'NG'))= ERo(Yr,HMR,MP,'CO2')*(1.3);
FCo(Yr,HMR,MP,Sea)$(MPFuel(MP,'NG')) = FCo(Yr,HMR,MP,Sea)*(1.3);

display
WindAF
ERo
;

*adjust FuelCosts for natural gas for sensitivity
*FCo(Yr,HMR,MP,Sea)$(MPFuel(MP,'NG') and SimYr(Yr)>=2022) = FCo(Yr,HMR,MP,Sea)*(0.8);

*$stop
* Solve
*-------------------------------------------------------------------------------------------------------------
mCPLEXopt('%UI_LP_Tol%');
*HaikuLP.IterLim=0;

Parameters
        t1104EConsNat(Yr)
        t1118CGAdj(Yr)
;
t1118CGAdj(Yr)=0;
t1104EConsNat(Yr)=sum((HMR,Sea,TB),EConsExo(Yr,HMR,Sea,TB));
display t1104EConsNat;

display Trans.up;
$ifthen.slv %UI_SlvLoad% == Slv
$ifthen.cal %UI_Cal% == Yes
        CalGen.L(Yr,HMR,Fuel)=0; CalEmis.L(Yr)=0; CalEmisRGGI.L(Yr)=0; CalGenPPAR.L(Yr,PPAR,Fuel)=0;
* Turning on/off calibrators
        CalGen.fx(Yr,HMR,Fuel) = 0;
        CalEmis.fx(Yr) = 0;
        CalEmisRGGI.fx(Yr) = 0;
        CalGenPPAR.fx(Yr,PPAR,Fuel) = 0;
        CalGenTot.fx(Yr,HMR) = 0;

$onText
        CalGen.up(Yr,HMR_TCI(HMR),Fuel) = +INF;
        CalGen.lo(Yr,HMR_TCI(HMR),Fuel) = -INF;
        CalGen.fx(Yr,HMR_TCI(HMR),'Wind') = 0;
        CalGen.fx(Yr,HMR_TCI(HMR),'Solar')= 0;


        CalGen.up(Yr,HMR_CO(HMR),Fuel) = +INF;
        CalGen.lo(Yr,HMR_CO(HMR),Fuel) = -INF;
        CalGen.fx(Yr,HMR_CO(HMR),'Wind') = 0;
        CalGen.fx(Yr,HMR_CO(HMR),'Solar')= 0;
$offText
        CalEmisRGGI.up(Yr)  = +INF;
        CalEmisRGGI.lo(Yr)  = -INF;
$onText
        CalGenPPAR.up(Yr,'NonTCI','Coal') = +INF;
        CalGenPPAR.lo(Yr,'NonTCI','Coal') = -INF;
        map_CalGen_YPH(Yr,'NonTCI',HMR) = YES$(not HMR_TCI(HMR));
$offText
        CalGenTot.up(Yr,HMR)$(SimYr(Yr)>=2020) = +INF;
        CalGenTot.lo(Yr,HMR)$(SimYr(Yr)>=2020) = -INF;
        CalGenTot.fx(Yr,'DC')=0;
        CalGenTot.l(Yr,'DC')=0;

        CalGenPPAR.up(Yr,'Nat','Coal') = +INF;
        CalGenPPAR.lo(Yr,'Nat','Coal') = -INF;
        map_CalGen_YPH(Yr,'Nat',HMR) = YES;

$endif.cal
set
it /it1*it200/
;

Parameter
AlwPrc_it(Yr,it)
Emis_it(Yr,it)
AlwPrc_prev(Yr)
Emis_prev(Yr)
AlwPrc_desired(Yr)
AlwPrc_it_desired(Yr,it)
counter
count_it(it)
boo_it(Yr,it)
boo2_it(Yr,it)
;
count_it(it) = ord(it);
counter = 1;

repeat(
AlwPrc_it(YrC,it)$(count_it(it)=counter)=AlwPrc.l(YrC,'Nat');
AlwPrc_prev(YrC) = sum(it,AlwPrc_it(YrC,it)$(count_it(it)=counter));
solve HaikuLP MINIMIZING TotCostLP using LP;
Emis_it(Yr,it)$(count_it(it)=counter) = sum((HMR,MP),sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB))*ERo(Yr,HMR,MP,'Co2')*PolScl('CO2')*map_EmisPol_YPHM(Yr,'Nat',HMR,MP));
Emis_prev(Yr) = sum(it,Emis_it(Yr,it)$(count_it(it)=counter));
AlwPrc_desired('Yr11') = Emis_prev('Yr11')*0.0125 + 9.740;
AlwPrc_it_desired(YrC,it)$(count_it(it)=counter) = AlwPrc_desired(YrC);
AlwPrc.fx('Yr11','Nat') = (AlwPrc_prev('Yr11')*149 + AlwPrc_desired('Yr11'))/150;
AlwPrc.l('Yr11','Nat')  = (AlwPrc_prev('Yr11')*149 + AlwPrc_desired('Yr11'))/150;
*increment counter
counter = counter + 1;
boo_it(YrC,it)$(count_it(it)=counter) = AlwPrc.l(YrC,'Nat')>=AlwPrc_desired(YrC)+0.05;
boo2_it(YrC,it)$(count_it(it)=counter) = AlwPrc.l(YrC,'Nat')<=AlwPrc_desired(YrC)-0.05;
until ((AlwPrc.l('Yr11','Nat')>=AlwPrc_desired('Yr11')+0.05) = 0 and (AlwPrc.l('Yr11','Nat')<=AlwPrc_desired('Yr11')-0.05) = 0) or counter=200);

display
AlwPrc_it
AlwPrc_it_desired
Emis_it
counter
boo_it
boo2_it
;

*$stop
* Post Processing
*-------------------------------------------------------------------------------------------------------------
map_EmisPol_YPH(Yr,'Nat',HMR) = YES$( SimYr(Yr)>=2021);
map_EmisPol_YPHM(Yr,'Nat',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'Nat',HMR) and EmisPolMP(MP));
map_EmisPol_YPH(Yr,'TCI',HMR) = YES$( SimYr(Yr)>=2021 and HMR_TCI(HMR));
map_EmisPol_YPHM(Yr,'TCI',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'TCI',HMR) and EmisPolMP(MP));
map_EmisPol_YPH(Yr,'NonTCI',HMR) = YES$( SimYr(Yr)>=2021 and not HMR_TCI(HMR));
map_EmisPol_YPHM(Yr,'NonTCI',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'NonTCI',HMR) and EmisPolMP(MP));
map_EmisPol_YPH(Yr,'RGGI12',HMR) = YES$( SimYr(Yr)>=2021 and HMR_RGGI12(HMR));
map_EmisPol_YPHM(Yr,'RGGI12',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'RGGI12',HMR) and EmisPolMP(MP));
map_EmisPol_YPH(Yr,'RGGI9',HMR) = YES$( SimYr(Yr)>=2021 and HMR_RGGI9(HMR));
map_EmisPol_YPHM(Yr,'RGGI9',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'RGGI9',HMR) and EmisPolMP(MP));
map_EmisPol_YPH(Yr,'CO',HMR) = YES$(HMR_CO(HMR));
map_EmisPol_YPHM(Yr,'CO',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'CO',HMR) and EmisPolMP(MP));


$include LPPost

$onText
put dummy;
put_utility 'gdxout' / '%UI_RootDir%/Output/%UI_Scen%/KeyResIter_%UI_vHaiku%_%UI_Scen%';
execute_unload
  KeyRes,ChkObj
;
putclose;

$onecho > gdx2xls.ini
[settings]
sorttoc=false
freezeheader=1
valueformat=#,###.###
$offecho
execute 'gdx2xls %UI_RootDir%/Output/%UI_Scen%/KeyResIter_%UI_vHaiku%_%UI_Scen% @gdx2xls.ini';
$offText
