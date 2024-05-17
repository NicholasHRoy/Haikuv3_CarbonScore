$set UI_InitVar %UI_vHaiku%_%UI_Scen%

put_utility 'gdxin' / '%UI_RootDir%\..\Shared\Solutions\%UI_InitVar%';
execute_load NPCap, Gen, Trans, EPrcRtl, ECons,
             gamma, MCGen, MCCap, lambda, MCNoDsp,
             AlwIss, AlwPrc, AlwAlc, PSPrc, PSReq, AlwPrcBank
*, ObjInt
;

put_utility 'gdxin' / '%UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen%';
execute_load
             CapCostF, FOMF, VOMF, HRF, FCoF, ERoF, EConsStorage
             EPrcRtlAnn,EPrcRtlPPAR,EConsPPAR,
             NetImportsYP, TDLossAnnPPAR, Trans,
             NPCapYPFM, NPCapYHFM,
             GenYPFM, GenYHFST, GenYPFST, GenYHFM,
             EmisYPFM, EmisFuelYPCvr_EmisPol, EmisYPCvr_EmisPol, EmisCapNom,
             AlwIss, AlwIssPrc, AlwPrc, PSPrc, PSReq,
             PSReqQty, PS_RefER, GenYPFMCred_PS,
             AlwAlc,AlwIssPPAR,
*             AlwAlcPctPH,
             map_EmisPol_YPH,
*             PTCCosts, ITCCosts, CPriceRev, CESTotVal,
             LCOE_Ex, LCOE_New, LFOM, LCapCo, LVOM, LFCo, LPolCo, LFixCo, LVarCo,
*             FOMExpend, CapCoExpend, FCoExpend, VOMExpend,
* MPFuel, MPTech, Tech,
             EConsEVTBpctSea, EConsEVExoAnn,
             EConsYHST, EConsYPST, EConsEVYHST, EConsEVYPST, Obj, ObjInt, TotCost_YrHMR, TotCostLP,
             CalGen, CalGenTot, EmisAEO, GenAEOFuelYH

;


$if not set UI_ScenName $set UI_ScenName %UI_Scen%
$set UI_Scen %UI_ScenName%

*KeyRes('%UI_Scen%','%UI_ScenName%',*,*,*,*,*,*,*) = 0;

** MP Inputs ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','CapCostF',ResYr,'na',ResHMR,'na',MP,'na','na','na') = CapCostF(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','FOMF',ResYr,'na',ResHMR,'na',MP,'na','na','na') = FOMF(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','VOMF',ResYr,'na',ResHMR,'na',MP,'na','na','na') = VOMF(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','HRF',ResYr,'na',ResHMR,'na',MP,'na','na','na') = HRF(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','FCoF',ResYr,'na',ResHMR,'na',MP,'na','na','na') = FCoF(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','ERoF',ResYr,'na',ResHMR,'na',MP,'na','na','na') = ERoF(ResYr,ResHMR,MP);

** Electricity Consumption, Prices, & Trade ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','EPrcRtlH',ResYr,'na',ResHMR,'na','na','na','na','na') = EPrcRtlAnn(ResYr,ResHMR);
KeyRes('%UI_Scen%','%UI_ScenName%','EPrcRtl',ResYr,ResPPAR,'na','na','na','na','na','na') = EPrcRtlPPAR(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenName%','EConsPPAR',ResYr,ResPPAR,'na','na','na','na','na','na') = EConsPPAR(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenName%','NetImports',ResYr,ResPPAR,'na','na','na','na','na','na') = NetImportsYP(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenName%','TDLossAnnPPAR',ResYr,ResPPAR,'na','na','na','na','na','na') = TDLossAnnPPAR(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenName%','Trade',ResYr,HMRe,HMRi,'na','na','na','na','na') =
        sum((Sea,TB),Trans.L(ResYr,HMRe,HMRi,Sea,TB));
$onText
**Policy Revenues and Costs-----------------------------------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','PTCCosts',ResYr,ResPPAR,'na','na','na','na','na','na')= PTCCosts(ResYr,ResPPAR);
*KeyRes('%UI_Scen%','%UI_ScenName%','PTCCostsHM',ResYr,'na',ResHMR,'na',MP,'na','na','na')= PTCCosts(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','ITCCosts',ResYr,ResPPAR,'na','na','na','na','na','na')= ITCCosts(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenName%','CPriceRev',ResYr,ResPPAR,'na','na','na','na','na','na')= CPriceRev(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenName%','CESTotVal',ResYr,ResPPAR,'na','na','na','na','na','na')= CESTotVal(ResYr,ResPPAR);
$offText
**Levelized Costs---------------------------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','LCOE_Ex',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=LCOE_Ex(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','LCOE_New',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=LCOE_New(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','LFOM',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=LFOM(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','LCapCo',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=LCapCo(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','LVOM',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=LVOM(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','LFCo',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=LFCo(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','LPolCo',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=LPolCo(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','LFixCo',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=LFixCo(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','LVarCo',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=LVarCo(ResYr,ResPPAR,Fuel,MP);
*KeyRes('%UI_Scen%','%UI_ScenName%','FOMExpend',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=FOMExpend(ResYr,ResPPAR,Fuel,MP);
*KeyRes('%UI_Scen%','%UI_ScenName%','CapCoExpend',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=CapCoExpend(ResYr,ResPPAR,Fuel,MP);
*KeyRes('%UI_Scen%','%UI_ScenName%','FCoExpend',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=FCoExpend(ResYr,ResPPAR,Fuel,MP);
*KeyRes('%UI_Scen%','%UI_ScenName%','VOMExpend',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na')=VOMExpend(ResYr,ResPPAR,Fuel,MP);

$ontext
**Lifetime LCOE
KeyRes('%UI_Scen%','%UI_ScenName%','LCOE_Lifetime','na',ResPPAR,'na',Fuel,MP,'na','na','na')$((sum(Yr,SimYrWgt(Yr)*GenYPFM(Yr,ResPPAR,Fuel,MP))<>0)and(MPNew(MP))) =
         sum(Yr,
                 SimYrWgt(Yr)*sum(HMR,
                                 ((FOMF(Yr,HMR,MP)+CapCostF(Yr,HMR,MP))*
                                 HMRMP(HMR,MP)*
                                 NPCapYHFM(Yr,HMR,Fuel,MP)
                                 +
                                 ((FCoF(Yr,HMR,MP)+VOMF(Yr,HMR,MP))*
                                 HMRMP(HMR,MP)*
                                 GenYHFM(Yr,HMR,Fuel,MP)))*
                                 map_EmisPol_YPH(Yr,ResPPAR,HMR))
         )
         /
         sum(Yr,
                 SimYrWgt(Yr)*GenYPFM(Yr,ResPPAR,Fuel,MP)
         );

$offtext

**EV usage--------------------------------------------------------------------------------------
*KeyRes('%UI_Scen%','%UI_ScenName%','EConsEVTBpctSea',ResYr,ResPPAR,ResHMR,'na','na','na',Sea,TB) = EConsEVTBpctSea(ResYr,ResHMR,Sea,TB);
*KeyRes('%UI_Scen%','%UI_ScenName%','EConsYHST',ResYr,'na',ResHMR,'na','na','na',Sea,TB) = EConsYHST(ResYr,ResHMR,Sea,TB);
KeyRes('%UI_Scen%','%UI_ScenName%','EConsYH',ResYr,'na',ResHMR,'na','na','na','na','na') = sum((Sea,TB),EConsYHST(ResYr,ResHMR,Sea,TB));
KeyRes('%UI_Scen%','%UI_ScenName%','EConsYPST',ResYr,ResPPAR,'na','na','na','na',Sea,TB) = EConsYPST(ResYr,ResPPAR,Sea,TB);
KeyRes('%UI_Scen%','%UI_ScenName%','EConsYP',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((Sea,TB),EConsYPST(ResYr,ResPPAR,Sea,TB));
*KeyRes('%UI_Scen%','%UI_ScenName%','EConsEVYHST',ResYr,'na',ResHMR,'na','na','na',Sea,TB) = EConsEVYHST(ResYr,ResHMR,Sea,TB);
KeyRes('%UI_Scen%','%UI_ScenName%','EConsEVYH',ResYr,'na',ResHMR,'na','na','na','na','na') = sum((Sea,TB),EConsEVYHST(ResYr,ResHMR,Sea,TB));
KeyRes('%UI_Scen%','%UI_ScenName%','EConsEVYPST',ResYr,ResPPAR,'na','na','na','na',Sea,TB) =EConsEVYPST(ResYr,ResPPAR,Sea,TB);
KeyRes('%UI_Scen%','%UI_ScenName%','EConsEVYP',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((Sea,TB),EConsEVYPST(ResYr,ResPPAR,Sea,TB));
*KeyRes('%UI_Scen%','%UI_ScenName%','EConsStorageYH',ResYr,'na',ResHMR,'na','na','na','na','na') = sum((MP,Sea,TB),EConsStorage.l(ResYr,ResHMR,MP,Sea,TB))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','EConsStorageYPST',ResYr,ResPPAR,'na','na','na','na',Sea,TB) =sum((HMR,MP),EConsStorage.l(ResYr,HMR,MP,Sea,TB)*map_EmisPol_YPH(ResYr,ResPPAR,HMR))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','EConsStorageYP',ResYr,ResPPAR,'na','na','na','na','na','na') =sum((HMR,MP,Sea,TB),EConsStorage.l(ResYr,HMR,MP,Sea,TB)*map_EmisPol_YPH(ResYr,ResPPAR,HMR))/1000;

** Capacity ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYPFM',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na') = NPCapYPFM(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYPF',ResYr,ResPPAR,'na',Fuel,'na','na','na','na') =
*         sum(MP,NPCapYPFM(ResYr,ResPPAR,Fuel,MP)*(MPFuel(MP,Fuel)));
         sum(MP,NPCapYPFM(ResYr,ResPPAR,Fuel,MP)*MPFuel(MP,Fuel)*(not (MPCofire(MP) and MPNew(MP))));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYPF_NGOil',ResYr,ResPPAR,'na','na','na','na','na','na') =
         sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'NG') or MPFuel(MP,'Oil')));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYPF_Oth',ResYr,ResPPAR,'na','na','na','na','na','na') =
            sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$
                        (not (MPFuel(MP,'Coal') or MPFuel(MP,'NG') or MPFuel(MP,'Oil') or
                        MPFuel(MP,'Nuke') or MPFuel(MP,'Wind') or MPFuel(MP,'Solar')))
            );
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP',ResYr,ResPPAR,'na','na','na','na','na','na') =
*        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP));
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)*(not (MPCofire(MP) and MPNew(MP))));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_NewNG',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'NG')$MPNew(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_NewWS',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Wind')$MPNew(MP) or MPFuel(MP,'Solar')$MPNew(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_NewW',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Wind')$MPNew(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_NewS',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Solar')$MPNew(MP)));


** Generation ---------------------------------------------------

KeyRes('%UI_Scen%','%UI_ScenName%','GenYHF',ResYr,'na',HMR,Fuel,'na','na','na','na') = sum(MP,GenYHFM(ResYr,HMR,Fuel,MP));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYH',ResYr,'na',HMR,'na','na','na','na','na') = sum((Fuel,MP),GenYHFM(ResYr,HMR,Fuel,MP)$(not MPFuel(MP,'Storage')));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPFM',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na') = GenYPFM(ResYr,ResPPAR,Fuel,MP);

$ontext
*Sea TB
KeyRes('%UI_Scen%','%UI_ScenName%','GenYHFST',ResYr,'na',ResHMR,Fuel,'na','na',Sea,TB) = GenYHFST(ResYr,ResHMR,Fuel,Sea,TB);
KeyRes('%UI_Scen%','%UI_ScenName%','GenYHFST_NGOil',ResYr,'na',ResHMR,'na','na','na',Sea,TB) =
         GenYHFST(ResYr,ResHMR,'NG',Sea,TB) + GenYHFST(ResYr,ResHMR,'Oil',Sea,TB);
KeyRes('%UI_Scen%','%UI_ScenName%','GenYHFST_Oth',ResYr,'na',ResHMR,'na','na','na',Sea,TB) =
         sum(Fuel,GenYHFST(ResYr,ResHMR,Fuel,Sea,TB))
         - GenYHFST(ResYr,ResHMR,'Coal',Sea,TB)
         - GenYHFST(ResYr,ResHMR,'Oil',Sea,TB)
         - GenYHFST(ResYr,ResHMR,'Nuke',Sea,TB)
         - GenYHFST(ResYr,ResHMR,'Wind',Sea,TB)
         - GenYHFST(ResYr,ResHMR,'Solar',Sea,TB)
         - GenYHFST(ResYr,ResHMR,'Storage',Sea,TB);
$offtext
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPFST',ResYr,ResPPAR,'na',Fuel,'na','na',Sea,TB) = GenYPFST(ResYr,ResPPAR,Fuel,Sea,TB);
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPFST_NGOil',ResYr,ResPPAR,'na','na','na','na',Sea,TB) =
         GenYPFST(ResYr,ResPPAR,'NG',Sea,TB) + GenYPFST(ResYr,ResPPAR,'Oil',Sea,TB);
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPFST_Oth',ResYr,ResPPAR,'na','na','na','na',Sea,TB) =
         sum(Fuel,GenYPFST(ResYr,ResPPAR,Fuel,Sea,TB))
         - GenYPFST(ResYr,ResPPAR,'Coal',Sea,TB)
         - GenYPFST(ResYr,ResPPAR,'Oil',Sea,TB)
         - GenYPFST(ResYr,ResPPAR,'Nuke',Sea,TB)
         - GenYPFST(ResYr,ResPPAR,'Wind',Sea,TB)
         - GenYPFST(ResYr,ResPPAR,'Solar',Sea,TB)
         - GenYPFST(ResYr,ResPPAR,'Storage',Sea,TB);

KeyRes('%UI_Scen%','%UI_ScenName%','GenYPF',ResYr,ResPPAR,'na',Fuel,'na','na','na','na') =
        sum((MP),GenYPFM(ResYr,ResPPAR,Fuel,MP));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYP',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(not FuelStorage(Fuel)));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPFM_Coal',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$MPFuel(MP,'Coal'));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPFM_NGOil',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'NG') or MPFuel(MP,'Oil')));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPFM_Nuke',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Nuke')));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPFM_WS',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Wind') or MPFuel(MP,'Solar')));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPFM_Oth',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$
                        (not (MPFuel(MP,'Coal') or MPFuel(MP,'NG') or MPFuel(MP,'Oil') or
                        MPFuel(MP,'Nuke') or MPFuel(MP,'Wind') or MPFuel(MP,'Solar')))
            );
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPFM_Cred',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na') = GenYPFMCred_PS(ResYr,ResPPAR,Fuel,MP);

** Emissions ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYPFMCO2',ResYr,ResPPAR,'na',Fuel,MP,'na','na','na') = EmisYPFM(ResYr,ResPPAR,Fuel,MP,'CO2');
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYPFCO2',ResYr,ResPPAR,'na',Fuel,'na','na','na','na') =
        sum((MP),EmisYPFM(ResYr,ResPPAR,Fuel,MP,'CO2'));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYPCO2',ResYr,ResPPAR,'na','na','na','na','na','na') =
        sum((Fuel,MP),EmisYPFM(ResYr,ResPPAR,Fuel,MP,'CO2'));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYPFCvrCO2',ResYr,ResPPAR,'na',Fuel,'na','na','na','na') =
         EmisFuelYPCvr_EmisPol(ResYr,Fuel,ResPPAR,'CO2');
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYPCvrCO2',Yr,ResPPAR,'na','na','na','na','na','na') =
        sum(Fuel,EmisFuelYPCvr_EmisPol(Yr,Fuel,ResPPAR,'CO2'));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisCapNom',ResYr,ResPPAR,'na','na','na','na','na','na') = EmisCapNom(ResYr,ResPPAR);

** Policies ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','AlwPrc',ResYr,ResPPAR,'na','na','na','na','na','na') = AlwPrc.L(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenName%','AlwPrcYH',ResYr,'na',ResHMR,'na','na','na','na','na') =
        sum(ResPPAR, AlwPrc.L(ResYr,ResPPAR) * map_EmisPol_YPH(ResYr,ResPPAR,ResHMR));
*KeyRes('%UI_Scen%','%UI_ScenName%','AlwIssPrc',ResYr,ResPPAR,'na','na','na',Trc) = AlwIssPrc(ResYr,ResPPAR,Trc);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisCapBaseYP',Yr,ResPPAR,'na','na','na','na','na','na') =
        AlwIss.up(Yr,ResPPAR,'Floor') + AlwIss.up(Yr,ResPPAR,'ECR');
*KeyRes('%UI_Scen%','%UI_ScenName%','EmisCapBaseYH',Yr,'na',ResHMR,'na','na','na') =
*        sum(ResPPAR, (AlwIss.up(Yr,ResPPAR,'Floor') + AlwIss.up(Yr,ResPPAR,'ECR'))
*                *AlwAlcPctPH(Yr,ResPPAR,ResHMR)$AlwPrc.L(Yr,ResPPAR) );
*KeyRes('%UI_Scen%','%UI_ScenName%','AlwIssYPT',ResYr,ResPPAR,'na','na','na',Trc,'na','na') = AlwIss.L(ResYr,ResPPAR,Trc);
*KeyRes('%UI_Scen%','%UI_ScenName%','AlwIssYP',ResYr,ResPPAR,'na','na','na','na','na','na') =
*        sum(Trc,AlwIss.L(ResYr,ResPPAR,Trc));
*KeyRes('%UI_Scen%','%UI_ScenName%','AlwIssYH',Yr,'na',ResHMR,'na','na','na') =
*        sum(ResPPAR, EmisYPCvr_EmisPol(Yr,ResPPAR,'CO2')
*                *AlwAlcPctPH(Yr,ResPPAR,ResHMR)$AlwPrc.L(Yr,ResPPAR) );

*KeyRes('%UI_Scen%','%UI_ScenName%','AlwAlcYPHA',ResYr,ResPPAR,ResHMR,'na','na',AA,'na','na') = AlwAlc.L(ResYr,ResPPAR,ResHMR,AA)/1E3;
*KeyRes('%UI_Scen%','%UI_ScenName%','AlwAlcYPA',ResYr,ResPPAR,'na','na','na',AA,'na','na') =
*        sum(ResHMR,AlwAlc.L(ResYr,ResPPAR,ResHMR,AA))/1E3;
*KeyRes('%UI_Scen%','%UI_ScenName%','AlwAlcYP',ResYr,ResPPAR,'na','na','na','na','na','na') =
*        sum((ResHMR,AA),AlwAlc.L(ResYr,ResPPAR,ResHMR,AA))/1E3;
*KeyRes('%UI_Scen%','%UI_ScenName%','AlwAlcYHA',ResYr,'na',ResHMR,'na','na',AA,'na','na') =
*        sum(ResPPAR,AlwAlc.L(ResYr,ResPPAR,ResHMR,AA))/1E3;
*KeyRes('%UI_Scen%','%UI_ScenName%','AlwAlcYH',ResYr,'na',ResHMR,'na','na','na','na','na') =
*        sum((ResPPAR,AA),AlwAlc.L(ResYr,ResPPAR,ResHMR,AA))/1E3;

KeyRes('%UI_Scen%','%UI_ScenName%','PSPrc',ResYr,ResPPAR,'na','na','na','na','na','na') = PSPrc.L(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenName%','PSPrcYH',ResYr,'na',ResHMR,'na','na','na','na','na') =
        sum(ResPPAR, PSPrc.l(ResYr,ResPPAR) * map_PS_YPH(ResYr,ResPPAR,ResHMR));
KeyRes('%UI_Scen%','%UI_ScenName%','PSReq',ResYr,ResPPAR,'na','na','na','na','na','na') = PSReq.L(ResYr,ResPPAR);
*KeyRes('%UI_Scen%','%UI_ScenName%','PSReqQty',ResYr,ResPPAR,'na','na','na','na','na','na') = PSReqQty(ResYr,ResPPAR);
*KeyRes('%UI_Scen%','%UI_ScenName%','PS_RefER',ResYr,ResPPAR,'na','na','na','na','na','na') = PS_RefER(ResYr,ResPPAR);

KeyRes('%UI_Scen%','%UI_ScenName%','ObjInt',Yr,'na',HMR,'na','na','na','na','na') = ObjInt.l(Yr,HMR);
KeyRes('%UI_Scen%','%UI_ScenName%','Obj','na','na','na','na','na','na','na','na') = sum((Yr,HMR),ObjInt.l(Yr,HMR));
KeyRes('%UI_Scen%','%UI_ScenName%','TotCost_YrHMR',Yr,'na',HMR,'na','na','na','na','na') = TotCost_YrHMR.l(Yr,HMR);
KeyRes('%UI_Scen%','%UI_ScenName%','TotCostLP','na','na','na','na','na','na','na','na') = TotCostLP.l;

display
TotCostLP.l
;

** Calibration----------------------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','CalGen',Yr,'na',HMR,Fuel,'na','na','na','na') =  CalGen.l(Yr,HMR,Fuel);
KeyRes('%UI_Scen%','%UI_ScenName%','CalGenTot',Yr,'na',HMR,'na','na','na','na','na') =  CalGenTot.l(Yr,HMR);

** AEO Comparison---------------------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','GenAEOHF',ResYr,'na',HMR,Fuel,'na','na','na','na') = GenAEOFuelYH(ResYr,HMR,Fuel);
KeyRes('%UI_Scen%','%UI_ScenName%','GenAEOH',ResYr,'na',HMR,'na','na','na','na','na') = sum(Fuel,GenAEOFuelYH(ResYr,HMR,Fuel)$(not FuelStorage(Fuel)));
KeyRes('%UI_Scen%','%UI_ScenName%','GenAEOPF',ResYr,ResPPAR,'na',Fuel,'na','na','na','na') = sum(HMR, GenAEOFuelYH(ResYr,HMR,Fuel)*map_EmisPol_YPH(ResYr,ResPPAR,HMR));
KeyRes('%UI_Scen%','%UI_ScenName%','GenAEOP',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((HMR,Fuel), GenAEOFuelYH(ResYr,HMR,Fuel)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(not FuelStorage(Fuel)));

KeyRes('%UI_Scen%','%UI_ScenName%','EmisAEOHF',ResYr,'na',HMR,Fuel,'na','na','na','na') = EmisAEO(ResYr,HMR,Fuel,'CO2');
KeyRes('%UI_Scen%','%UI_ScenName%','EmisAEOH',ResYr,'na',HMR,'na','na','na','na','na') = sum(Fuel,EmisAEO(ResYr,HMR,Fuel,'CO2'));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisAEOPF',ResYr,ResPPAR,'na',Fuel,'na','na','na','na') = sum(HMR,EmisAEO(ResYr,HMR,Fuel,'CO2')*map_EmisPol_YPH(ResYr,ResPPAR,HMR));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisAEOP',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((HMR,Fuel),EmisAEO(ResYr,HMR,Fuel,'CO2')*map_EmisPol_YPH(ResYr,ResPPAR,HMR));

** Cofiring Outputs
KeyRes('%UI_Scen%','%UI_ScenName%','GenYP_CoalNoCof',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(not MPCofire(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYP_CoalCof',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and (not MPNew(MP))));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYP_CoalCofNew',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYP_CoalCofNew20',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New20')));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYP_CoalCofNew60',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New60')));
KeyRes('%UI_Scen%','%UI_ScenName%','GenYP_CoalCofNew100',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New100')));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_CoalNoCof',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),NPCapYPFM(ResYr,ResPPAR,'Coal',MP)$(not MPCofire(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_CoalCof',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),NPCapYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and (not MPNew(MP))));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_CoalCofNew',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),NPCapYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_CoalCofNew20',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),NPCapYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New20')));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_CoalCofNew60',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),NPCapYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New60')));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapYP_CoalCofNew100',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((MP),NPCapYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New100')));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYP_CoalNoCof',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(not MPCofire(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYP_CoalCof',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(MPCofire(MP) and (not MPNew(MP))));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYP_CoalCofNew',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(MPCofire(MP) and MPNew(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYP_CoalCofNew20',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New20')));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYP_CoalCofNew60',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New60')));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisYP_CoalCofNew100',ResYr,ResPPAR,'na','na','na','na','na','na') = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New100')));

KeyRes('%UI_Scen%','%UI_ScenName%','EmisRateYP_CoalCofAll',ResYr,ResPPAR,'na','na','na','na','na','na')$(sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP)))<>0)
                                                                                                  = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(MPCofire(MP)))
                                                                                                         / sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP)));
KeyRes('%UI_Scen%','%UI_ScenName%','EmisRateYP_CoalCofNew',ResYr,ResPPAR,'na','na','na','na','na','na')$( sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP)))<>0)
                                                                                                  = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(MPCofire(MP) and MPNew(MP)))
                                                                                                         / sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP)));

KeyRes('%UI_Scen%','%UI_ScenName%','EmisRateYP_CoalCofNew20',ResYr,ResPPAR,'na','na','na','na','na','na')$( sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New20')))<>0)
                                                                                                  = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New20')))
                                                                                                         / sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New20')));


KeyRes('%UI_Scen%','%UI_ScenName%','EmisRateYP_CoalCofNew60',ResYr,ResPPAR,'na','na','na','na','na','na')$( sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New60')))<>0)
                                                                                                  = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New60')))
                                                                                                         / sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New60')));


KeyRes('%UI_Scen%','%UI_ScenName%','EmisRateYP_CoalCofNew100',ResYr,ResPPAR,'na','na','na','na','na','na')$( sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New100')))<>0)
                                                                                                  = sum((HMR,MP),GenYHFM(ResYr,HMR,'Coal',MP)*ERoF(ResYr,HMR,MP)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New100')))
                                                                                                         / sum((MP),GenYPFM(ResYr,ResPPAR,'Coal',MP)$(MPCofire(MP) and MPNew(MP) and MPRetrofit(MP,'New100')));


KeyRes('%UI_Scen%','%UI_ScenName%','GenYPST_CoalNoCof',ResYr,ResPPAR,'na','na','na','na',Sea,TB) = sum((HMR,MP),Gen.l(ResYr,HMR,MP,Sea,TB)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)*MPFuel(MP,'Coal')*(not MPCofire(MP)))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPST_CoalCof',ResYr,ResPPAR,'na','na','na','na',Sea,TB) = sum((HMR,MP),Gen.l(ResYr,HMR,MP,Sea,TB)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)*MPFuel(MP,'Coal')*MPCofire(MP)*(not MPNew(MP)))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPST_CoalCofNew',ResYr,ResPPAR,'na','na','na','na',Sea,TB) = sum((HMR,MP),Gen.l(ResYr,HMR,MP,Sea,TB)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)*MPFuel(MP,'Coal')*MPCofire(MP)*MPNew(MP))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPST_CoalCofNew20',ResYr,ResPPAR,'na','na','na','na',Sea,TB) = sum((HMR,MP),Gen.l(ResYr,HMR,MP,Sea,TB)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)*MPFuel(MP,'Coal')*MPCofire(MP)*MPNew(MP)*MPRetrofit(MP,'New20'))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPST_CoalCofNew60',ResYr,ResPPAR,'na','na','na','na',Sea,TB) = sum((HMR,MP),Gen.l(ResYr,HMR,MP,Sea,TB)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)*MPFuel(MP,'Coal')*MPCofire(MP)*MPNew(MP)*MPRetrofit(MP,'New60'))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','GenYPST_CoalCofNew100',ResYr,ResPPAR,'na','na','na','na',Sea,TB) = sum((HMR,MP),Gen.l(ResYr,HMR,MP,Sea,TB)*map_EmisPol_YPH(ResYr,ResPPAR,HMR)*MPFuel(MP,'Coal')*MPCofire(MP)*MPNew(MP)*MPRetrofit(MP,'New100'))/1000;
