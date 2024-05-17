$set UI_InitVar %UI_vHaiku%_%UI_Scen%

*put_utility 'gdxin' / '%UI_RootDir%\..\Shared\Solutions\%UI_InitVar%';
*execute_load NPCap, Gen, EPrcRtl, ECons,
*             gamma, MCGen, MCCap, lambda, MCNoDsp,
*             AlwPrc, PSPrc, PSReq, AlwPrcBank
*, ObjInt
*;

put_utility 'gdxin' / '%UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen%';
execute_load
             Trans,NPCapYPFM,GenYPFM,EConsAnn,Gen,EmisNat,EmisTot

;

Alias(  PPAR,PPARdup);

$if not set UI_ScenName $set UI_ScenName %UI_Scen%
$set UI_Scen %UI_ScenName%

KeyRes('%UI_Scen%','%UI_ScenName%','GenYP_NewNG',ResYr,ResPPAR,'na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(MPNew(MP) and MPFuel(MP,'NG')));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYP_NewWS',ResYr,ResPPAR,'na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(MPNew(MP) and (MPFuel(MP,'Wind') or MPFuel(MP,'Solar'))));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYP_NewW',ResYr,ResPPAR,'na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(MPNew(MP) and MPFuel(MP,'Wind')));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYP_NewS',ResYr,ResPPAR,'na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(MPNew(MP) and MPFuel(MP,'Solar')));

KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_NewNG',ResYr,ResPPAR,'na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'NG') and MPNew(MP) and (not MPCCS(MP))));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_NewWS',ResYr,ResPPAR,'na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Wind')$MPNew(MP) or MPFuel(MP,'Solar')$MPNew(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_NewW',ResYr,ResPPAR,'na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Wind')$MPNew(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_NewS',ResYr,ResPPAR,'na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Solar')$MPNew(MP)));

KeyRes('%UI_Scen%','%UI_ScenName%','EmisNat',ResYr,'na','na','na','na') = EmisNat(ResYr,'CO2');
KeyRes('%UI_Scen%','%UI_ScenName%','EmisNat',ResYr,HMR,'na','na','na') = EmisTot(ResYr,HMR,'CO2');

KeyRes('%UI_Scen%','%UI_ScenName%','TransShadowPrice',ResYr,ResHMR,HMR,Sea,'na')     = Trans.M(ResYr,HMR,ResHMR,Sea,'1') + Trans.M(ResYr,ResHMR,HMR,Sea,'1');
*KeyRes('%UI_Scen%','%UI_ScenName%','TransUpperBound_GW',ResYr,ResHMR,HMR,Sea,'na')   = Trans.UP(ResYr,ResHMR,HMR,Sea,'1')/Hrs(Sea,'1');
KeyRes('%UI_Scen%','%UI_ScenName%','TransUpperBound_GW',ResYr,ResHMR,HMR,'na','na')   = sum((Sea,TB),Trans.UP(ResYr,ResHMR,HMR,Sea,TB))/sum((Sea,TB),Hrs(Sea,TB));
*KeyRes('%UI_Scen%','%UI_ScenName%','TransMaxFlow_GW',ResYr,ResHMR,HMR,Sea,TB)        = Trans.l(ResYr,ResHMR,HMR,Sea,TB)/Hrs(Sea,TB);
KeyRes('%UI_Scen%','%UI_ScenName%','TransTotAnnual_GWh',ResYr,ResHMR,HMR,'na','na')  = sum((Sea,TB),Trans.l(ResYr,ResHMR,HMR,Sea,TB));

KeyRes('%UI_Scen%','%UI_ScenName%','TransUpperBoundHMR_GW',ResYr,HMR,'na','na','na')  = sum(HMRe,sum((Sea,TB),Trans.UP(ResYr,HMR,HMRe,Sea,TB))/sum((Sea,TB),Hrs(Sea,TB)));
KeyRes('%UI_Scen%','%UI_ScenName%','TransUpperBoundMaxHMR_GW',ResYr,HMR,'na','na','na')  = sum(HMRe,smax(Sea,Trans.UP(ResYr,HMR,HMRe,Sea,'1')/Hrs(Sea,'1')));
*KeyRes('%UI_Scen%','%UI_ScenName%','TransUpperBoundHMR_GW',ResYr,HMR,'na',Sea,'na')  = sum(HMRe,Trans.UP(ResYr,HMR,HMRe,Sea,'1')/Hrs(Sea,'1'));
KeyRes('%UI_Scen%','%UI_ScenName%','TransUpperBoundNat_GW',ResYr,'na','na','na','na')  = sum(HMR,sum(HMRe,sum((Sea,TB),Trans.UP(ResYr,HMR,HMRe,Sea,TB))/sum((Sea,TB),Hrs(Sea,TB))))/2;
KeyRes('%UI_Scen%','%UI_ScenName%','TransUpperBoundMaxNat_GW',ResYr,'na','na','na','na')  = smax(Sea,sum(HMR,sum(HMRe,Trans.UP(ResYr,HMR,HMRe,Sea,'1')/Hrs(Sea,'1'))))/2;
KeyRes('%UI_Scen%','%UI_ScenName%','TransUpperBoundMaxMaxNat_GW',ResYr,'na','na','na','na')  = sum(HMR,sum(HMRe,smax(Sea,Trans.UP(ResYr,HMR,HMRe,Sea,'1')/Hrs(Sea,'1'))))/2;
*KeyRes('%UI_Scen%','%UI_ScenName%','TransUpperBoundNat_GW',ResYr,'na','na',Sea,'na')  = sum(HMR,sum(HMRe,Trans.UP(ResYr,HMR,HMRe,Sea,'1')/Hrs(Sea,'1')))/2;

KeyRes('%UI_Scen%','%UI_ScenName%','EDemand',ResYr,ResHMR,'na','na','na')       = EConsAnn(ResYr,ResHMR);
