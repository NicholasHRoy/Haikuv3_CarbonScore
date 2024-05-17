$title Solve LP
$offUpper
$eolcom !!
$inlinecom { }
*$onSymList
*$offlisting
option limrow=5E4 !!, limcol=0{1E5}, solprint=silent, lp=cplex, sysout=on;

*-------------------------------------------------------------------------------------------------------------
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
*-------------------------------------------------------------------------------------------------------------
Sets
    ResYr(Yr) /Yr0/
    ResPPAR(PPAR) /Nat, TCI, NonTCI, RGGI12, RGGI9, CO/
    ResHMR(HMR) /CO/
*    ResHMR(HMR)   /ME, VT, NH, MA, RI, CT, NY, NJ, PA, DE, MD, DC, VA, NC, OH/
*    ResMP(MP) /'Ex CT NG Eff1','Ex NGCC Eff1'/
*    ResSea(Sea) /Sum/
*    ResTB(TB) /1/
;
*Alias (Yr, ResYr)
*Alias (PPAR, ResPPAR)
*Alias (HMR, ResHMR)
Alias(MP,ResMP);
Alias(Sea, ResSea)
Alias(TB,ResTB);

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

parameter p(HMR,step);
p(HMR,'s1') =(smax((YrFullHist),((NPCapHist(YrFullHist,HMR) - NPCapHist(YrFullHist + 1,HMR))$(SimYrFullHist(YrFullHist) <> SimYrFullHist('Yr-17')))));
p(HMR,'s2') =(NPCapHist('Yr0',HMR)/20);

*-------------------------------------------------------------------------------------------------------------
* Solve
*-------------------------------------------------------------------------------------------------------------
mCPLEXopt('%UI_LP_Tol%');
*HaikuLP.IterLim=0;
option reslim = 10000000;

$ifthen.slv %UI_SlvLoad% == Slv
$ifthen.cal %UI_Cal% == Yes
        CalGen.L(Yr,HMR,Fuel)=0; CalEmis.L(Yr)=0; CalEmisRGGI.L(Yr)=0; CalGenPPAR.L(Yr,PPAR,Fuel)=0; CalGenTot.L(Yr,HMR)=0;
* Turning on/off calibrators
        CalGen.fx(Yr,HMR,Fuel) = 0;
        CalEmis.fx(Yr) = 0;
        CalEmisRGGI.fx(Yr) = 0;
        CalGenPPAR.fx(Yr,PPAR,Fuel) = 0;
        CalGenTot.fx(Yr,HMR) = 0;

*Calibate national emissions
*        CalEmis.up(Yr)$(SimYr(Yr)>=2022) = +INF;
*        CalEmis.lo(Yr)$(SimYr(Yr)>=2022) = -INF;

*Calibrate National Emissions Eventually

*calibrate generation by fuel in state of interest (make user input)
*          CalGen.up(Yr,HMR_PA(HMR),'Coal') = +INF;
*          CalGen.lo(Yr,HMR_PA(HMR),'Coal') = -INF;
*          CalGen.up(Yr,HMR_PA(HMR),'NG') = +INF;
*          CalGen.lo(Yr,HMR_PA(HMR),'NG') = -INF;

*calbirate RGGI emissions
        CalEmisRGGI.up(Yr)  = +INF;
        CalEmisRGGI.lo(Yr)  = -INF;

*calibrate total generation in each state except DC

*$ontext
        CalGenTot.up(Yr,HMR) = +INF;
        CalGenTot.lo(Yr,HMR) = -INF;

        CalGenTot.fx(Yr,'SD')=0;
        CalGenTot.l(Yr,'SD')=0;

        CalGenTot.fx(Yr,'TX')=0;
        CalGenTot.l(Yr,'TX')=0;

*calibrate total generation by fuel
        CalGenPPAR.up(Yr,'Nat','Coal') = +INF;
        CalGenPPAR.lo(Yr,'Nat','Coal') = -INF;
        CalGenPPAR.up(Yr,'Nat','NG') = +INF;
        CalGenPPAR.lo(Yr,'Nat','NG') = -INF;
        CalGenPPAR.up(Yr,'Nat','Oil') = +INF;
        CalGenPPAR.lo(Yr,'Nat','Oil') = -INF;
*        CalGenPPAR.up(Yr,'Nat','Nuke') = +INF;
*        CalGenPPAR.lo(Yr,'Nat','Nuke') = -INF;
        CalGenPPAR.up(Yr,'Nat','Wind')$(SimYr(Yr) >= 2022) = +INF;
        CalGenPPAR.lo(Yr,'Nat','Wind')$(SimYr(Yr) >= 2022) = -INF;
        CalGenPPAR.up(Yr,'Nat','Solar')$(SimYr(Yr) >= 2022) = +INF;
        CalGenPPAR.lo(Yr,'Nat','Solar')$(SimYr(Yr) >= 2022) = -INF;

        map_CalGen_YPH(Yr,'Nat',HMR) = YES;





$endif.cal


*Transmission From E4ST Constraints (WECC: 2030, EI: 2020, ERCOT: 2026)
Trans.up(Yr,HMRe,HMRi,Sea,TB) = TransCapMax0(HMRe,HMRi)*Hrs(Sea,TB);

$OnText
*Real World Constraint
Trans.up(Yr,'TX',HMRi,Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .83 * Hrs(Sea,TB);
Trans.up(Yr,HMRe,'TX',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .83 * Hrs(Sea,TB);

Trans.up(Yr,'TX','NM',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .40 * Hrs(Sea,TB);
Trans.up(Yr,'NM','TX',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .40 * Hrs(Sea,TB);

Trans.up(Yr,'MT','ND',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .20 * Hrs(Sea,TB);
Trans.up(Yr,'ND','MT',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .20 * Hrs(Sea,TB);

Trans.up(Yr,'MT','SD',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = 0.0 * Hrs(Sea,TB);
Trans.up(Yr,'SD','MT',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = 0.0 * Hrs(Sea,TB);

Trans.up(Yr,'SD','WY',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .20 * Hrs(Sea,TB);
Trans.up(Yr,'WY','SD',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .20 * Hrs(Sea,TB);

Trans.up(Yr,'NE','WY',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .11 * Hrs(Sea,TB);
Trans.up(Yr,'WY','NE',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .11 * Hrs(Sea,TB);

Trans.up(Yr,'NE','CO',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .20 * Hrs(Sea,TB);
Trans.up(Yr,'CO','NE',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .20 * Hrs(Sea,TB);

Trans.up(Yr,'KS','CO',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .21 * Hrs(Sea,TB);
Trans.up(Yr,'CO','KS',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = .21 * Hrs(Sea,TB);

Trans.up(Yr,'OK','CO',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = 0.0 * Hrs(Sea,TB);
Trans.up(Yr,'CO','OK',Sea,TB)$(SimYr(Yr) > %UI_FxCap%)  = 0.0 * Hrs(Sea,TB);
$offText

*Transmission Growth
Trans.up(Yr,HMRe,HMRi,Sea,TB)$(SimYr(Yr)>2020 and HMR_EI(HMRe) and HMR_EI(HMRi))  = TransCapMax0(HMRe,HMRi)*Hrs(Sea,TB)*(1.005)**Max(0,(SimYr(Yr)-2020));
Trans.up(Yr,HMRe,HMRi,Sea,TB)$(SimYr(Yr)>2030 and HMR_WECC(HMRe) and HMR_WECC(HMRi))  = TransCapMax0(HMRe,HMRi)*Hrs(Sea,TB)*(1.005)**Max(0,(SimYr(Yr)-2030));
*Transmissions between the interconnects
Trans.up(Yr,HMRe,HMRi,Sea,TB)$((HMR_ERCOT(HMRe) and HMR_EI(HMRi)) or (HMR_EI(HMRe) and HMR_ERCOT(HMRi)))  = Trans.up(Yr,HMRe,HMRi,Sea,TB)*(1.005)**Max(0,(SimYr(Yr)-2025));
Trans.up(Yr,HMRe,HMRi,Sea,TB)$((HMR_ERCOT(HMRe) and HMR_WECC(HMRi)) or (HMR_WECC(HMRe) and HMR_ERCOT(HMRi)))  = Trans.up(Yr,HMRe,HMRi,Sea,TB)*(1.005)**Max(0,(SimYr(Yr)-2025));
Trans.up(Yr,HMRe,HMRi,Sea,TB)$((HMR_EI(HMRe) and HMR_WECC(HMRi)) or (HMR_WECC(HMRe) and HMR_EI(HMRi)))  = Trans.up(Yr,HMRe,HMRi,Sea,TB)*(1.005)**Max(0,(SimYr(Yr)-2025));

$ifthen.transgrow  %UI_TransGrow%==Yes
*Transmission From E4ST Constraints (WECC: 2030, EI: 2020, ERCOT: 2026)
Trans.up(Yr,HMRe,HMRi,Sea,TB) = TransCapMax0(HMRe,HMRi)*Hrs(Sea,TB);
Trans.up(Yr,HMRe,HMRi,Sea,TB)$(SimYr(Yr)>2020 and HMR_EI(HMRe) and HMR_EI(HMRi))  = TransCapMax0(HMRe,HMRi)*Hrs(Sea,TB)*(1.02)**Max(0,(SimYr(Yr)-2020));
Trans.up(Yr,HMRe,HMRi,Sea,TB)$(SimYr(Yr)>2030 and HMR_WECC(HMRe) and HMR_WECC(HMRi))  = TransCapMax0(HMRe,HMRi)*Hrs(Sea,TB)*(1.02)**Max(0,(SimYr(Yr)-2030));
Trans.up(Yr,HMRe,HMRi,Sea,TB)$((HMR_ERCOT(HMRe) and HMR_EI(HMRi)) or (HMR_EI(HMRe) and HMR_ERCOT(HMRi)))  = Trans.up(Yr,HMRe,HMRi,Sea,TB)*(1.02)**Max(0,(SimYr(Yr)-2025));
Trans.up(Yr,HMRe,HMRi,Sea,TB)$((HMR_ERCOT(HMRe) and HMR_WECC(HMRi)) or (HMR_WECC(HMRe) and HMR_ERCOT(HMRi)))  = Trans.up(Yr,HMRe,HMRi,Sea,TB)*(1.02)**Max(0,(SimYr(Yr)-2025));
Trans.up(Yr,HMRe,HMRi,Sea,TB)$((HMR_EI(HMRe) and HMR_WECC(HMRi)) or (HMR_WECC(HMRe) and HMR_EI(HMRi)))  = Trans.up(Yr,HMRe,HMRi,Sea,TB)*(1.02)**Max(0,(SimYr(Yr)-2025));
$endif.transgrow

$ifthen.EPRITrans  %UI_EPRIScen% == Low
Trans.up(Yr,HMRe,HMRi,Sea,TB)$(SimYr(Yr)>2020 and HMR_EI(HMRe) and HMR_EI(HMRi))  = TransCapMax0(HMRe,HMRi)*Hrs(Sea,TB);
Trans.up(Yr,HMRe,HMRi,Sea,TB)$(SimYr(Yr)>2030 and HMR_WECC(HMRe) and HMR_WECC(HMRi))  = TransCapMax0(HMRe,HMRi)*Hrs(Sea,TB);
*Transmissions between the interconnects
Trans.up(Yr,HMRe,HMRi,Sea,TB)$((HMR_ERCOT(HMRe) and HMR_EI(HMRi)) or (HMR_EI(HMRe) and HMR_ERCOT(HMRi)))  = Trans.up(Yr,HMRe,HMRi,Sea,TB);
Trans.up(Yr,HMRe,HMRi,Sea,TB)$((HMR_ERCOT(HMRe) and HMR_WECC(HMRi)) or (HMR_WECC(HMRe) and HMR_ERCOT(HMRi)))  = Trans.up(Yr,HMRe,HMRi,Sea,TB);
Trans.up(Yr,HMRe,HMRi,Sea,TB)$((HMR_EI(HMRe) and HMR_WECC(HMRi)) or (HMR_WECC(HMRe) and HMR_EI(HMRi)))  = Trans.up(Yr,HMRe,HMRi,Sea,TB);

$elseif.EPRITrans %UI_EPRIScen% == High
Trans.up(Yr,HMRe,HMRi,Sea,TB)$(SimYr(Yr)>2020 and HMR_EI(HMRe) and HMR_EI(HMRi)) = +INF;
Trans.up(Yr,HMRe,HMRi,Sea,TB)$(SimYr(Yr)>2020 and HMR_WECC(HMRe) and HMR_WECC(HMRi)) = +INF;
$endif.EPRITrans

solve HaikuLP MINIMIZING TotCostLP using LP;

*-------------------------------------------------------------------------------------------------------------
* Post Processing
*-------------------------------------------------------------------------------------------------------------
$include LPPost
