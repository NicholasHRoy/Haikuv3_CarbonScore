*$Title Results
*$OffUpper
*$OnSymList
*$eolcom !!
*$inlinecom { }

$if not set UI_Func $set UI_Func Res

*-----------------------------------------------------------------------------------------------------------------------
* If run alone, update User Inputs
*-----------------------------------------------------------------------------------------------------------------------
$ifthen.ui %UI_Func% == Res
$include Init

$set UI_Func         Res !! [DM,SI,Slv,Res] run which function?
$set UI_SetPol       No !! [Yes,No] Run EmisPol_Opts?
$set UI_RptAllPPAR   Yes !! [Yes,No] Activate all PPARs for reporting? Yes only for running Results.gms.
$set UI_RsltCmp      8F_LPCal_noCalEqs !! scenario to compare against the results of the scenario processed here
*$if not set UI_Scen     $set UI_Scen    8FLP_Cal_AgH_1step
$if not set UI_Scen     $set UI_Scen    8FLP_Cal_AgH_2stepsNOadj
$set UI_InitVar %UI_vHaiku%_%UI_Scen%
$if %UI_Cal% == Yes     $set UI_InitCal %UI_InitVar%
$include DefScen

$ifthen.knl %UI_ScenKnl% == BL
PSPrc.fx(Yr,PPAR)=0;
PSReq.fx(Yr,PPAR)=0;
$endif.knl

$endif.ui

*-----------------------------------------------------------------------------------------------------------------------
* Run Results
*-----------------------------------------------------------------------------------------------------------------------
Parameters
    ChkECons(Yr,HMR,Sea,TB)
    ChkGen(Yr,HMR,MP,Sea,TB)
    ChkVOM(Yr,HMR,MP)
    ChkFC(Yr,HMR,MP,Sea)
    ChkCalGen(Yr,HMR,MP)
    ChkCalEmis(Yr,HMR,MP)
    ChkCalEmisRGGI(Yr,HMR,MP)
    ChkAlwPrc(Yr,HMR,MP)
    ChkPSRev(Yr,HMR,MP)
    ChkPSCost(Yr,HMR,Sea)
    ChkTrans(Yr,HMR,Sea)
    ChkCapCost(Yr,HMR,MP,Sea)
    ChkMC(Yr,HMR,Sea)
    ChkRsvMrg(Yr,HMR,Sea)
    ChkCalEPrcRtl(Yr,HMR,Sea)
    ChkEmis(Yr,HMR,MP,Sea)
;
** COS
ChkECons(Yr,HMR,Sea,TB) = EConsExo(Yr,HMR,Sea,TB);
ChkGen(Yr,HMR,MP,Sea,TB) = Gen.L(Yr,HMR,MP,Sea,TB);
ChkVOM(Yr,HMR,MP) = VOM(Yr,HMR,MP);
ChkFC(Yr,HMR,MP,Sea) = FCo(Yr,HMR,MP,Sea)$(not sum(Fuel,MPFC(MP,Fuel)))
                +(FCiRef(Yr,HMR,'NG')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'NG')
                +(FCiRef(Yr,HMR,'Coal')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'Coal')
                +(FCiRef(Yr,HMR,'Oil')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'Oil');
*ChkCalGen(Yr,HMR,MP) = sum(Fuel,CalGenEq.M(Yr,HMR,Fuel)$(MPFuel(MP,Fuel) and CalGenIncl(Yr,HMR,Fuel)));
*ChkCalGen(Yr,HMR,MP) = sum(Fuel,CalGen.L(Yr,HMR,Fuel)$(MPFuel(MP,Fuel) and CalGenIncl(Yr,HMR,Fuel)));
ChkCalGen(Yr,HMR,MP) = sum(Fuel,CalGen.L(Yr,HMR,Fuel)$(MPFuel(MP,Fuel) and CalGenIncl(Yr,HMR,Fuel)));
ChkCalEmis(Yr,HMR,MP) = CalEmis.L(Yr)*ERo(Yr,HMR,MP,'CO2');
ChkCalEmisRGGI(Yr,HMR,MP) = CalEmisRGGI.L(Yr)*ERo(Yr,HMR,MP,'CO2')$HMRRGGICal(HMR);
*ChkAlwPrc(Yr,HMR,MP) = sum(PPAR,RGGIEmisEq.M(Yr,PPAR)*ERo(Yr,HMR,MP,'CO2')$map_EmisPol_YPHM(Yr,PPAR,HMR,MP));
*ChkAlwPrc(Yr,HMR,MP) = sum(PPAR,AlwPrc.L(Yr,PPAR)*ERo(Yr,HMR,MP,'CO2')$map_EmisPol_YPHM(Yr,PPAR,HMR,MP));
ChkAlwPrc(Yr,HMR,MP) = sum(PPAR,AlwPrc.L(Yr,PPAR)*ERo(Yr,HMR,MP,'CO2')$map_EmisPol_YPHM(Yr,PPAR,HMR,MP));
ChkPSRev(Yr,HMR,MP) = sum(PPAR,PSPrc.L(Yr,PPAR)*PSCredit(Yr,PPAR,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP));
ChkTrans(Yr,HMR,Sea) = sum((HMRei(HMRe,HMR),TB),Trans.L(Yr,HMRe,HMR,Sea,TB)*TransCost(HMRe,HMR));
ChkCapCost(Yr,HMR,MP,Sea) = sum(HMRMP(HMR,MP),NPCap.L(Yr,HMR,MP)*1E3*(FOM(Yr,HMR,MP)+CapCost(Yr,HMR,MP)))*sum(TB,Hrs(Sea,TB))/HrsAnn;
** Non-COS
ChkMC(Yr,HMR,Sea) = sum(TB,SupDemEq.M(Yr,HMR,Sea,TB)*EConsExo(Yr,HMR,Sea,TB));
*ChkMC(Yr,HMR,Sea) = sum(TB,SupDemEq.M(Yr,HMR,Sea,TB)*EConsExo(Yr,HMR,Sea,TB));
*ChkMC(Yr,HMR,Sea,TB) = SupDemEq.M(Yr,HMR,Sea,TB);
ChkRsvMrg(Yr,HMR,Sea) = sum(TB,sum(RsvRg,RsvMrgEq.M(Yr,RsvRg,Sea,TB)*(1+RsvMrg(Yr,RsvRg)))*EConsExo(Yr,HMR,Sea,TB)/Hrs(Sea,TB));
*ChkRsvMrg(Yr,HMRl,Sea,TB) = sum(TB,sum(RsvRg,RsvMrgEq.M(Yr,RsvRg,Sea,TB)*(1+RsvMrg(Yr,RsvRg)))*EConsExo(Yr,HMR,Sea,TB)/Hrs(Sea,TB)) );
** COS/Non-COS
ChkPSCost(Yr,HMR,Sea) = sum((map_PS_YPH(Yr,PPAR,HMR),TB),EConsExo(Yr,HMR,Sea,TB)*PSReq.L(Yr,PPAR)*PSPrc.L(Yr,PPAR));
ChkCalEPrcRtl(Yr,HMR,Sea) = CalEPrcRtl.L(Yr,HMR,Sea);

ChkEmis(Yr,HMR,MP,Sea) =  sum(TB,Gen.L(Yr,HMR,MP,Sea,TB)*ERo(Yr,HMR,MP,'CO2'));

$ontext
Sets
    ResYr(Yr) /Yr19/
    ResHMR(HMR) /CO/
*    ResMP(MP) /'Ex CT NG Eff1','Ex NGCC Eff1'/
    ResSea(Sea) /Sum/
*    ResTB(TB) /1/
;
Alias(ResMP,MP);
Alias(ResTB,TB);
$offtext

Parameters
    ChkObjRtl(*,*,*,*,*,*,*,*)
;

** Objective Function ---------------------------------------------------
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','TotCostLP','na','na','na','na','na') = TotCostLP.L;
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','TotCost_YrHMR',ResYr,ResHMR,'na','na','na') = TotCost_YrHMR.L(ResYr,ResHMR);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','EPrcRtl',ResYr,ResHMR,'na',ResSea,'na') = EPrcRtl.L(ResYr,ResHMR,ResSea);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','EConsExo',ResYr,ResHMR,'na',ResSea,ResTB) = ChkECons(ResYr,ResHMR,ResSea,ResTB);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkGen',ResYr,ResHMR,ResMP,ResSea,ResTB) = ChkGen(ResYr,ResHMR,ResMP,ResSea,ResTB);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkVOM',ResYr,ResHMR,ResMP,'na','na') = ChkVOM(ResYr,ResHMR,ResMP);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkCalGen',ResYr,ResHMR,ResMP,'na','na') = ChkCalGen(ResYr,ResHMR,ResMP);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkFC',ResYr,ResHMR,ResMP,ResSea,'na') = ChkFC(ResYr,ResHMR,ResMP,ResSea);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkCalEmis',ResYr,ResHMR,ResMP,'na','na') = ChkCalEmis(ResYr,ResHMR,ResMP);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkCalEmisRGGI',ResYr,ResHMR,ResMP,'na','na') = ChkCalEmisRGGI(ResYr,ResHMR,ResMP);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkAlwPrc',ResYr,ResHMR,ResMP,'na','na') = ChkAlwPrc(ResYr,ResHMR,ResMP);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkPSRev',ResYr,ResHMR,ResMP,'na','na') = ChkPSRev(ResYr,ResHMR,ResMP);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkTrans',ResYr,ResHMR,'na',ResSea,'na') = ChkTrans(ResYr,ResHMR,ResSea);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkCapCost',ResYr,ResHMR,ResMP,ResSea,'na') = ChkCapCost(ResYr,ResHMR,ResMP,ResSea);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkMC',ResYr,ResHMR,'na',ResSea,'na') = ChkMC(ResYr,ResHMR,ResSea);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkRsvMrg',ResYr,ResHMR,'na',ResSea,'na') = ChkRsvMrg(ResYr,ResHMR,ResSea);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkPSCost',ResYr,ResHMR,'na',ResSea,'na') = ChkPSCost(ResYr,ResHMR,ResSea);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ChkCalEPrcRtl',ResYr,ResHMR,'na',ResSea,'na') = ChkCalEPrcRtl(ResYr,ResHMR,ResSea);

** Other ---------------------------------------------------
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','OpNPCapRat','na',ResHMR,ResMP,ResSea,'na') = OpNPCapRat(ResHMR,ResMP,ResSea){ResYr(Yr)};
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ACFGen',ResYr,ResHMR,ResMP,ResSea,ResTB) = ACFGen(ResYr,ResHMR,ResMP,ResSea,ResTB);
*ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ACFGen',ResYr,ResHMR,'na',ResSea,'na') = sum(TB,ACFGen(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB)))/sum(TB,Hrs(Sea,TB));
*ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','ACFGen',ResYr,ResHMR,'na','na','na') = sum((Sea,TB),ACFGen(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB)))/sum((Sea,TB),Hrs(Sea,TB));
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','SupDemEqM',ResYr,ResHMR,'na',ResSea,ResTB) = SupDemEq.M(ResYr,ResHMR,ResSea,ResTB);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','SupDemEqL',ResYr,ResHMR,'na',ResSea,ResTB) = SupDemEq.L(ResYr,ResHMR,ResSea,ResTB);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','RsvMrgEqM',ResYr,RsvRg,'na',ResSea,ResTB) = RsvMrgEq.M(ResYr,RsvRg,ResSea,ResTB);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','RsvMrgEqL',ResYr,RsvRg,'na',ResSea,ResTB) = RsvMrgEq.L(ResYr,RsvRg,ResSea,ResTB);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','NPCapEqM',ResYr,ResHMR,ResMP,'na','na') = NPCapEq.M(ResYr,ResHMR,ResMP);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','NPCapEqL',ResYr,ResHMR,ResMP,'na','na') = NPCapEq.L(ResYr,ResHMR,ResMP);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','gammaL',ResYr,ResHMR,ResMP,'na','na') = gamma.L(ResYr,ResHMR,ResMP);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','gammaU',ResYr,ResHMR,ResMP,'na','na') = gamma.Up(ResYr,ResHMR,ResMP);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','GenLeCapEqM',ResYr,ResHMR,ResMP,ResSea,ResTB) = GenLeCapEq.M(ResYr,ResHMR,ResMP,ResSea,ResTB);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','GenLeCapEqL',ResYr,ResHMR,ResMP,ResSea,ResTB) = GenLeCapEq.L(ResYr,ResHMR,ResMP,ResSea,ResTB);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','NoDspEqM',ResYr,ResHMR,ResMP,ResSea,ResTB) = NoDspEq.M(ResYr,ResHMR,ResMP,ResSea,ResTB);
ChkObjRtl('%UI_Scen%','%UI_ScenKnl%','NoDspEqL',ResYr,ResHMR,ResMP,ResSea,ResTB) = NoDspEq.L(ResYr,ResHMR,ResMP,ResSea,ResTB);

*Create gdx, convert to xlsx. For some unknown reason, the freezeheader and sorttoc settings are not working.
*-----------------------------------------------------------------------------------------------------------------------
put dummy;
put_utility 'gdxout' / '%UI_RootDir%/Output/%UI_Scen%/ChkObjRtl_%UI_vHaiku%_%UI_Scen%';
execute_unload
  ChkObjRtl
$ontext
    EPrcRtl,
    ChkECons,
    ChkGen,
    ChkVOM,
    ChkFC,
    ChkCalGen,
    ChkCalEmis,
    ChkCalEmisRGGI,
    ChkAlwPrc,
    ChkPSRev,
    ChkTrans,
    ChkCapCost,
    ChkMC,
    ChkRsvMrg,
    ChkCalEPrcRtl,
    ChkEmis
$offtext
;
putclose;

*$exit

$onecho > gdx2xls.ini
[settings]
sorttoc=false
freezeheader=1
valueformat=#,###.###
$offecho
execute 'gdx2xls %UI_RootDir%/Output/%UI_Scen%/ChkObjRtl_%UI_vHaiku%_%UI_Scen% @gdx2xls.ini';
