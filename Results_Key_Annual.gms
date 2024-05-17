$ifthen.ui %UI_Func% == Res

$set UI_InitVar %UI_vHaiku%_%UI_Scen%
put_utility 'gdxin' / '%UI_RootDir%\..\Shared\Solutions\%UI_InitVar%';
execute_load NPCap, Gen, Trans, EPrcRtl, ECons,
             gamma, MCGen, MCCap, lambda, MCNoDsp,
             AlwIss, AlwPrc, AlwAlc, PSPrc, PSReq, AlwPrcBank
;

put_utility 'gdxin' / '%UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen%';
execute_load
             CalRGGIHaiku, CalRGGIAEO, CalEmisRGGIHaiku, CalEmisRGGIAEO,
             Chk_Gen, Chk_Emis, Chk_Emis_RGGI,
             CapCostF, FOMF, VOMF, HRF, FCoF, ERoF,
             EPrcRtlAnn,EPrcRtlPPAR,EConsPPAR,
             NetImportsYP, TDLossAnnPPAR, Trans,
             NPCapYPFM, NPCapYHFM
             GenYPFM, GenYHFM,
             EmisYPFM, EmisFuelYPCvr_EmisPol, EmisYPCvr_EmisPol
             AlwIss, AlwIssPrc, AlwPrc, PSPrc, PSReq,
             PSReqQty, PS_RefER, GenYPFMCred_PS,
             AlwAlc,AlwIssPPAR,
             {AlwAlcPctPH,}
             map_EmisPol_YPH
;

*$if not set UI_ScenKnl $set UI_ScenKnl %UI_Scen%
*$set UI_Scen %UI_ScenKnl%
$set UI_ScenKnl %UI_ScenName%

$endif.ui

*KeyRes('%UI_Scen%','%UI_ScenKnl%',*,*,*,*,*,*,*) = 0;

** Objective Function ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenKnl%','TotCostLP','na','na','na','na','na','na') = TotCostLP.L;
KeyRes('%UI_Scen%','%UI_ScenKnl%','TotCost_YrHMR',ResYr,'na',ResHMR,'na','na','na') = TotCost_YrHMR.L(ResYr,ResHMR);

** Revenue ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenKnl%','ERevAEO',ResYr,'na',ResHMR,'na','na','na') = sum((Sea,TB),ERevRef(ResYr,ResHMR,Sea,TB))*1E3;
KeyRes('%UI_Scen%','%UI_ScenKnl%','ERevAEO',ResYr,'Nat','na','na','na','na') = sum((Sea,TB,ResHMR),ERevRef(ResYr,ResHMR,Sea,TB))*1E3;

KeyRes('%UI_Scen%','%UI_ScenKnl%','ERev',ResYr,'na',ResHMR,'na','na','na') = sum((Sea),EPrcRtl.L(ResYr,ResHMR,Sea)*sum(TB,EConsExo(ResYr,ResHMR,Sea,TB)));
KeyRes('%UI_Scen%','%UI_ScenKnl%','ERev',ResYr,'Nat','na','na','na','na') = sum((Sea,ResHMR),EPrcRtl.L(ResYr,ResHMR,Sea)*sum(TB,EConsExo(ResYr,ResHMR,Sea,TB)));

** Calibration ---------------------------------------------------
*KeyRes('%UI_Scen%','%UI_ScenKnl%','CalRGGIHaiku',ResYr,'na',ResHMR,Fuel,'na','na') = CalRGGIHaiku(ResYr,ResHMR,Fuel);
*KeyRes('%UI_Scen%','%UI_ScenKnl%','CalRGGIAEO',ResYr,'na',ResHMR,Fuel,'na','na') = CalRGGIAEO(ResYr,ResHMR,Fuel);
KeyRes('%UI_Scen%','%UI_ScenKnl%','CalEmisRGGIHaiku',ResYr,'na','na','na','na','na') = CalEmisRGGIHaiku(ResYr);
KeyRes('%UI_Scen%','%UI_ScenKnl%','CalEmisRGGIAEO',ResYr,'na','na','na','na','na') = CalEmisRGGIAEO(ResYr);
KeyRes('%UI_Scen%','%UI_ScenKnl%','Chk_Gen',ResYr,'na',ResHMR,Fuel,'na','na') = Chk_Gen(ResYr,ResHMR,Fuel);
KeyRes('%UI_Scen%','%UI_ScenKnl%','Chk_Gen',ResYr,'Nat','na',Fuel,'na','na') = sum(HMR,Chk_Gen(ResYr,HMR,Fuel));
KeyRes('%UI_Scen%','%UI_ScenKnl%','Chk_Emis',ResYr,'na','na','na','na','na') = Chk_Emis(ResYr);
KeyRes('%UI_Scen%','%UI_ScenKnl%','Chk_Emis_RGGI',ResYr,'na','na','na','na','na') = Chk_Emis_RGGI(ResYr);

** MP Inputs ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenKnl%','CapCostF',ResYr,'na',ResHMR,'na',MP,'na') = CapCostF(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenKnl%','FOMF',ResYr,'na',ResHMR,'na',MP,'na') = FOMF(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenKnl%','VOMF',ResYr,'na',ResHMR,'na',MP,'na') = VOMF(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenKnl%','HRF',ResYr,'na',ResHMR,'na',MP,'na') = HRF(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenKnl%','FCoF',ResYr,'na',ResHMR,'na',MP,'na') = FCoF(ResYr,ResHMR,MP);
KeyRes('%UI_Scen%','%UI_ScenKnl%','ERoF',ResYr,'na',ResHMR,'na',MP,'na') = ERoF(ResYr,ResHMR,MP);

** Electricity Consumption, Prices, & Trade ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenKnl%','EPrcRtlH',ResYr,'na',ResHMR,'na','na','na') = EPrcRtlAnn(ResYr,ResHMR);
KeyRes('%UI_Scen%','%UI_ScenKnl%','EPrcRtl',ResYr,ResPPAR,'na','na','na','na') = EPrcRtlPPAR(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenKnl%','EConsPPAR',ResYr,ResPPAR,'na','na','na','na') = EConsPPAR(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenKnl%','NetImports',ResYr,ResPPAR,'na','na','na','na') = NetImportsYP(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenKnl%','TDLossAnnPPAR',ResYr,ResPPAR,'na','na','na','na') = TDLossAnnPPAR(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenKnl%','Trade',ResYr,HMRe,HMRi,'na','na','na') =
        sum((Sea,TB),Trans.L(ResYr,HMRe,HMRi,Sea,TB));

** Capacity ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenKnl%','NPCapYPFM',ResYr,ResPPAR,'na',Fuel,MP,'na') = NPCapYPFM(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenKnl%','NPCapYPFT',ResYr,ResPPAR,'na',Fuel,Tech,'na') =
        sum((MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)*MPTech(MP,Tech));
KeyRes('%UI_Scen%','%UI_ScenKnl%','NPCapYPF',ResYr,ResPPAR,'na',Fuel,'na','na') =
        sum((MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP));
KeyRes('%UI_Scen%','%UI_ScenKnl%','NPCapYHF',ResYr,'na',HMR,Fuel,'na','na') =
        sum((MP),NPCapYHFM(ResYr,HMR,Fuel,MP));
KeyRes('%UI_Scen%','%UI_ScenKnl%','NPCapYP',ResYr,ResPPAR,'na','na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP));
KeyRes('%UI_Scen%','%UI_ScenKnl%','NPCapYP_NewNG',ResYr,ResPPAR,'na','na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'NG')$MPNew(MP)));
KeyRes('%UI_Scen%','%UI_ScenKnl%','NPCapYP_NewWS',ResYr,ResPPAR,'na','na','na','na') =
        sum((Fuel,MP),NPCapYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Wind')$MPNew(MP) or MPFuel(MP,'Solar')$MPNew(MP)));

** Generation ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYHF_AEO',ResYr,ResHMR,'na',Fuel,'na','na') =
        sum(Sea,GenAEOSeaFuel(ResYr,ResHMR,Sea,Fuel))/1E3;
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYPF_AEO',ResYr,ResPPAR,'na',Fuel,'na','na') =
        sum((HMR,Sea),GenAEOSeaFuel(ResYr,HMR,Sea,Fuel)*map_EmisPol_YPH(ResYr,ResPPAR,HMR))/1E3;

KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYPFM',ResYr,ResPPAR,'na',Fuel,MP,'na') = GenYPFM(ResYr,ResPPAR,Fuel,MP);
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYPFT',ResYr,ResPPAR,'na',Fuel,Tech,'na') =
        sum((MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)*MPTech(MP,Tech));
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYPF',ResYr,ResPPAR,'na',Fuel,'na','na') =
        sum((MP),GenYPFM(ResYr,ResPPAR,Fuel,MP));
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYHF',ResYr,'na',HMR,Fuel,'na','na') =
        sum((MP),GenYHFM(ResYr,HMR,Fuel,MP));
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYP',ResYr,ResPPAR,'na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP));
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYPFM_Coal',ResYr,ResPPAR,'na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$MPFuel(MP,'Coal'));
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYPFM_NGOil',ResYr,ResPPAR,'na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'NG') or MPFuel(MP,'Oil')));
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYPFM_Nuke',ResYr,ResPPAR,'na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Nuke')));
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYPFM_WS',ResYr,ResPPAR,'na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$(MPFuel(MP,'Wind') or MPFuel(MP,'Solar')));
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYPFM_Oth',ResYr,ResPPAR,'na','na','na','na') =
        sum((Fuel,MP),GenYPFM(ResYr,ResPPAR,Fuel,MP)$
                        (not (MPFuel(MP,'Coal') or MPFuel(MP,'NG') or MPFuel(MP,'Oil') or
                        MPFuel(MP,'Nuke') or MPFuel(MP,'Wind') or MPFuel(MP,'Solar')))
            );
KeyRes('%UI_Scen%','%UI_ScenKnl%','GenYPFM_Cred',ResYr,ResPPAR,'na',Fuel,MP,'na') = GenYPFMCred_PS(ResYr,ResPPAR,Fuel,MP);

** Emissions ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenKnl%','EmisYPFCO2_AEO',ResYr,ResHMR,'na',Fuel,'na','na') =
        EmisAEO(ResYr,ResHMR,Fuel,'CO2');
KeyRes('%UI_Scen%','%UI_ScenKnl%','EmisYPFCO2_AEO',ResYr,ResPPAR,'na',Fuel,'na','na') =
        sum(HMR,EmisAEO(ResYr,HMR,Fuel,'CO2')*map_EmisPol_YPH(ResYr,ResPPAR,HMR));
KeyRes('%UI_Scen%','%UI_ScenKnl%','EmisYPFMCO2',ResYr,ResPPAR,'na',Fuel,MP,'na') = EmisYPFM(ResYr,ResPPAR,Fuel,MP,'CO2');
KeyRes('%UI_Scen%','%UI_ScenKnl%','EmisYPFTCO2',ResYr,ResPPAR,'na',Fuel,Tech,'na') =
        sum((MP),EmisYPFM(ResYr,ResPPAR,Fuel,MP,'CO2')*MPTech(MP,Tech));
KeyRes('%UI_Scen%','%UI_ScenKnl%','EmisYPFCO2',ResYr,ResPPAR,'na',Fuel,'na','na') =
        sum((MP),EmisYPFM(ResYr,ResPPAR,Fuel,MP,'CO2'));
KeyRes('%UI_Scen%','%UI_ScenKnl%','EmisYPCO2',ResYr,ResPPAR,'na','na','na','na') =
        sum((Fuel,MP),EmisYPFM(ResYr,ResPPAR,Fuel,MP,'CO2'));
KeyRes('%UI_Scen%','%UI_ScenKnl%','EmisYPFCvrCO2',ResYr,ResPPAR,'na',Fuel,'na','na') = EmisFuelYPCvr_EmisPol(ResYr,Fuel,ResPPAR,'CO2');
KeyRes('%UI_Scen%','%UI_ScenKnl%','EmisYPCvrCO2',Yr,ResPPAR,'na','na','na','na') =
        sum(Fuel,EmisFuelYPCvr_EmisPol(Yr,Fuel,ResPPAR,'CO2'));

** Policies ---------------------------------------------------
KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwPrc',ResYr,ResPPAR,'na','na','na','na') = AlwPrc.L(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwPrcYH',ResYr,'na',ResHMR,'na','na','na') =
        sum(ResPPAR, AlwPrc.L(ResYr,ResPPAR) * map_EmisPol_YPH(ResYr,ResPPAR,ResHMR));
*KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwIssPrc',ResYr,ResPPAR,'na','na','na',Trc) = AlwIssPrc(ResYr,ResPPAR,Trc);
KeyRes('%UI_Scen%','%UI_ScenKnl%','EmisCapBaseYP',Yr,ResPPAR,'na','na','na','na') =
        AlwIss.up(Yr,ResPPAR,'Floor') + AlwIss.up(Yr,ResPPAR,'ECR');
*KeyRes('%UI_Scen%','%UI_ScenKnl%','EmisCapBaseYH',Yr,'na',ResHMR,'na','na','na') =
*        sum(ResPPAR, (AlwIss.up(Yr,ResPPAR,'Floor') + AlwIss.up(Yr,ResPPAR,'ECR'))
*                *AlwAlcPctPH(Yr,ResPPAR,ResHMR)$AlwPrc.L(Yr,ResPPAR) );
KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwIssYPT',ResYr,ResPPAR,'na','na','na',Trc) = AlwIss.L(ResYr,ResPPAR,Trc);
KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwIssYP',ResYr,ResPPAR,'na','na','na','na') =
        sum(Trc,AlwIss.L(ResYr,ResPPAR,Trc));
*KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwIssYH',Yr,'na',ResHMR,'na','na','na') =
*        sum(ResPPAR, EmisYPCvr_EmisPol(Yr,ResPPAR,'CO2')
*                *AlwAlcPctPH(Yr,ResPPAR,ResHMR)$AlwPrc.L(Yr,ResPPAR) );

KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwAlcYPHA',ResYr,ResPPAR,ResHMR,'na','na',AA) = AlwAlc.L(ResYr,ResPPAR,ResHMR,AA)/1E3;
KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwAlcYPA',ResYr,ResPPAR,'na','na','na',AA) =
        sum(ResHMR,AlwAlc.L(ResYr,ResPPAR,ResHMR,AA))/1E3;
KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwAlcYP',ResYr,ResPPAR,'na','na','na','na') =
        sum((ResHMR,AA),AlwAlc.L(ResYr,ResPPAR,ResHMR,AA))/1E3;
KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwAlcYHA',ResYr,'na',ResHMR,'na','na',AA) =
        sum(ResPPAR,AlwAlc.L(ResYr,ResPPAR,ResHMR,AA))/1E3;
KeyRes('%UI_Scen%','%UI_ScenKnl%','AlwAlcYH',ResYr,'na',ResHMR,'na','na','na') =
        sum((ResPPAR,AA),AlwAlc.L(ResYr,ResPPAR,ResHMR,AA))/1E3;

KeyRes('%UI_Scen%','%UI_ScenKnl%','PSPrc',ResYr,ResPPAR,'na','na','na','na') = PSPrc.L(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenKnl%','PSPrcYH',ResYr,'na',ResHMR,'na','na','na') =
        sum(ResPPAR, PSPrc.l(ResYr,ResPPAR) * map_PS_YPH(ResYr,ResPPAR,ResHMR));
KeyRes('%UI_Scen%','%UI_ScenKnl%','PSReq',ResYr,ResPPAR,'na','na','na','na') = PSReq.L(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenKnl%','PSReqQty',ResYr,ResPPAR,'na','na','na','na') = PSReqQty(ResYr,ResPPAR);
KeyRes('%UI_Scen%','%UI_ScenKnl%','PS_RefER',ResYr,ResPPAR,'na','na','na','na') = PS_RefER(ResYr,ResPPAR);

*display KeyRes;

$ifthen.ui not %UI_Func% == Res

*Create gdx, convert to xlsx. For some unknown reason, the freezeheader and sorttoc settings are not working.
*-----------------------------------------------------------------------------------------------------------------------
put dummy;
put_utility 'gdxout' / '%UI_RootDir%/Output/%UI_Scen%/KeyRes_%UI_vHaiku%_%UI_Scen%';
execute_unload
    KeyRes
;
putclose;

$onecho > gdx2xls.ini
[settings]
sorttoc=false
freezeheader=1
valueformat=#,###.###
$offecho
execute 'gdx2xls %UI_RootDir%/Output/%UI_Scen%/KeyRes_%UI_vHaiku%_%UI_Scen% @gdx2xls.ini';


$endif.ui

*Create gdx, convert to xlsx. For some unknown reason, the freezeheader and sorttoc settings are not working.
*-----------------------------------------------------------------------------------------------------------------------
$ifthen.ui2 %UI_ChkObjRtl% == Yes

*put_utility 'gdxin' / '%UI_RootDir%\Output\%UI_Scen%\ChkObj_%UI_vHaiku%_%UI_Scen%';
*execute_load
*    ChkObjRtl
*;

$onecho > gdx2xls.ini
[settings]
sorttoc=false
freezeheader=1
valueformat=#,###.###
$offecho
execute 'gdx2xls %UI_RootDir%/KeyResults/KeyRes_%UI_Res%/ChkObjRtl_%UI_vHaiku%_%UI_Scen% @gdx2xls.ini';

$endif.ui2
