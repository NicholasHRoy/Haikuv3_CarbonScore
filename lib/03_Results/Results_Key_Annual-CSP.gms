$set UI_InitVar %UI_vHaiku%_%UI_Scen%

put_utility 'gdxin' / '%UI_RootDir%\..\Shared\Solutions\%UI_InitVar%';
execute_load NPCap, Gen, Trans, EPrcRtl, ECons,
             gamma, MCGen, MCCap, lambda, MCNoDsp,
             AlwPrc, PSPrc, PSReq, AlwPrcBank
*, ObjInt
;

put_utility 'gdxin' / '%UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen%';
execute_load
             CapCostF, FOMF, VOMF, HRF, FCoF, FCiRef, ERoF, EConsStorage, EConsAnn, ECons, Cons,
*             VarCOSConsumer, FixCOSConsumer, NonCOSConsumer, VarPolCostConsumer,
*             FixPolCostConsumer, PSCostsConsumer, CalCostConsumer, TransCostConsumer,
             EPrcRtlAnn,EPrcRtlPPAR,EConsPPAR,
             NetImportsYP, TDLossAnnPPAR, Trans,
             NPCapYPFM,
             GenYPFM, GenYPFST, GenYHFM,
             EmisYPFM, EmisFuelYPCvr_EmisPol, EmisYPCvr_EmisPol, EmisCapNom,EmisFuel,
             AlwPrc, PSPrc, PSReq, map_EmisPol_YPHM, map_PS_YPHM,
             PSReqQty, PS_RefER, GenYPFMCred_PS,
             RCost_FCo,
             RCost_VOM,
             RCost_CCS
             RCost_FOM,
             RCost_CapCost,
             RCost_Imp,
             RCost_Exp,  CCSEmis
*             AlwAlcPctPH,
*             PTCCosts, ITCCosts,
             CESTotVal, CESBank, NationalCE,
*             PTCExpendP_TW, PTCExpendPYf_TW, ITCExpendP_At
              map_PTC_YPHM, PTCredit, PTCPrc,
              map_ITC_YPHM, ITCredit, ITCPct,
             LCOE_Ex, LCOE_New,
              ACFGen, Expend45Q_Y, Expend45Q_YH,
*             LFOM, LCapCo, LVOM, LFCo, LPolCo, LFixCo, LVarCo,
*             FOMExpend, CapCoExpend, FCoExpend, VOMExpend,
* MPFuel, MPTech, Tech,
             ERevRef,
             EConsYHST, EConsYPST, EConsEVYHST, EConsEVYPST, Obj, ObjInt, TotCost_YrHMR, TotCostLP,
             CalGen,CalEmis,CalEmisRGGI, CalGenTot, EmisAEO, GenAEOFuelYH, SupDemEq.M, RsvMrgEq.M,CalEPrcRtl,CalEPrcRtl2,
             NPCapFuelHist, GenFuelHist, EConsExoHist, EmisFuelHist, EmisFuelYP_EmisPol
*             PTCOutlaysH, CCCOutlaysH, ITCOutlaysH

;
Alias(  PPAR,PPARdup);

$if not set UI_ScenName $set UI_ScenName %UI_Scen%
$set UI_Scen %UI_ScenName%

*KeyRes('%UI_Scen%','%UI_ScenName%',*,*,*,*,*,*,*) = 0;

*------------------------------ Electricity Demand ------------------------------
*Retail Price of Electricity
KeyRes('%UI_Scen%','%UI_ScenName%','EPrcRtl',YrFull,ResPPAR,'na','na')          = sum(Yr,EPrcRtlPPAR(Yr,ResPPAR)*(SimYrWgtKnl(YrFull,Yr)));
KeyRes('%UI_Scen%','%UI_ScenName%','EPrcRtlGen',YrFull,ResPPAR,'na','na')       =
                                                    sum((Yr,HMR,Sea),(EPrcRtl.l(Yr,HMR,Sea) - CalEPrcRtl.L(Yr,HMR,Sea) - CalEPrcRtl2.L(Yr,HMR,Sea))
                                                         *sum(TB,ECons.l(Yr,HMR,Sea,TB))*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr))
                                                    / sum((Yr,HMR,Sea),sum(TB,ECons.l(Yr,HMR,Sea,TB))*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','RevGen',YrFull,ResPPAR,'na','na')       =
                                                    sum((Yr,HMR,Sea),(EPrcRtl.l(Yr,HMR,Sea) - CalEPrcRtl.L(Yr,HMR,Sea) - CalEPrcRtl2.L(Yr,HMR,Sea))
                                                         *sum(TB,ECons.l(Yr,HMR,Sea,TB))*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr))/1E3;

KeyRes('%UI_Scen%','%UI_ScenName%','Rev',YrFull,ResPPAR,'na','na')       =
                                                    sum((Yr,HMR,Sea),EPrcRtl.l(Yr,HMR,Sea)
                                                         *sum(TB,ECons.l(Yr,HMR,Sea,TB))*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr))/1E3;

*Electricity Consumption
KeyRes('%UI_Scen%','%UI_ScenName%','EConsExoHist',YrFullHist,ResPPAR,'na','na')    = sum(HMR,EConsExoHist(YrFullHist,HMR)*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','ECons',YrFull,ResPPAR,'na','na')               = sum(Yr,sum(HMR,(sum(Sector,Cons.l(Yr,HMR,Sector))/1E3)$map_all_YPH(Yr,ResPPAR,HMR))*(SimYrWgtKnl(YrFull,Yr)));
KeyRes('%UI_Scen%','%UI_ScenName%','EConsSector',YrFull,ResPPAR,Sector,'na')       = sum(Yr,sum(HMR,(Cons.l(Yr,HMR,Sector)/1E3)$map_all_YPH(Yr,ResPPAR,HMR))*(SimYrWgtKnl(YrFull,Yr)));

KeyRes('%UI_Scen%','%UI_ScenName%','CleanPctCons',YrFull,ResPPAR,'na','na')        = sum(Yr,(sum((Fuel,MP),GenYPFM(Yr,ResPPAR,Fuel,MP)*(MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro') or MPFuel(MP,'Nuke') or MPFuel(MP,'Geo')))
                                                                                         /sum((Sea,TB),EConsYPST(Yr,ResPPAR,Sea,TB)))*(SimYrWgtKnl(YrFull,Yr)))$(sum((Yr,Sea,TB),EConsYPST(Yr,ResPPAR,Sea,TB)*(SimYrWgtKnl(YrFull,Yr)))> 0);

*------------------------------ Electricity Supply ------------------------------
*Electricity Resource Costs
KeyRes('%UI_Scen%','%UI_ScenName%','RCost_FCo',YrFull,ResPPAR,'na','na')           = Inflation('%UI_USD%') * sum(Yr,RCost_FCo(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr));
KeyRes('%UI_Scen%','%UI_ScenName%','RCost_VOM',YrFull,ResPPAR,'na','na')           = Inflation('%UI_USD%') * sum(Yr,RCost_VOM(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr));
KeyRes('%UI_Scen%','%UI_ScenName%','RCost_CCS',YrFull,ResPPAR,'na','na')           = Inflation('%UI_USD%') * sum(Yr,RCost_CCS(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr));
KeyRes('%UI_Scen%','%UI_ScenName%','RCost_FOM',YrFull,ResPPAR,'na','na')           = Inflation('%UI_USD%') * sum(Yr,RCost_FOM(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr));
KeyRes('%UI_Scen%','%UI_ScenName%','RCost_CapEx',YrFull,ResPPAR,'na','na')         = Inflation('%UI_USD%') * sum(Yr,RCost_CapCost(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr));
KeyRes('%UI_Scen%','%UI_ScenName%','RCost_Imp',YrFull,ResPPAR,'na','na')           = Inflation('%UI_USD%') * sum(Yr,RCost_Imp(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr));
KeyRes('%UI_Scen%','%UI_ScenName%','RCost_Exp',YrFull,ResPPAR,'na','na')           = Inflation('%UI_USD%') * sum(Yr,RCost_Exp(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr));


KeyRes('%UI_Scen%','%UI_ScenName%','RCost',YrFull,ResPPAR,'na','na')               = KeyRes('%UI_Scen%','%UI_ScenName%','RCost_FCo',YrFull,ResPPAR,'na','na')
                                                                                        + KeyRes('%UI_Scen%','%UI_ScenName%','RCost_VOM',YrFull,ResPPAR,'na','na')
                                                                                        + KeyRes('%UI_Scen%','%UI_ScenName%','RCost_CCS',YrFull,ResPPAR,'na','na')
                                                                                        + KeyRes('%UI_Scen%','%UI_ScenName%','RCost_FOM',YrFull,ResPPAR,'na','na')
                                                                                        + KeyRes('%UI_Scen%','%UI_ScenName%','RCost_CapEx',YrFull,ResPPAR,'na','na')
                                                                                        + KeyRes('%UI_Scen%','%UI_ScenName%','RCost_Imp',YrFull,ResPPAR,'na','na')
                                                                                        + KeyRes('%UI_Scen%','%UI_ScenName%','RCost_Exp',YrFull,ResPPAR,'na','na');

*Capacity
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapTot_Hist',YrFullHist,ResPPAR,'na','na')   = sum(Fuel,sum(HMR,NPCapFuelHist(YrFullHist,HMR,Fuel)*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)))$(not FuelStorage(Fuel)));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapTot',YrFull,ResPPAR,'na','na')            = sum((Fuel,MP),sum(Yr,NPCapYPFM(Yr,ResPPAR,Fuel,MP)*(SimYrWgtKnl(YrFull,Yr))));

KeyRes('%UI_Scen%','%UI_ScenName%','NPCapF_Hist',YrFullHist,ResPPAR,Fuel,'na')     = sum(HMR,NPCapFuelHist(YrFullHist,HMR,Fuel)*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapF',YrFull,ResPPAR,Fuel,'na')              = sum(MP,sum(Yr,NPCapYPFM(Yr,ResPPAR,Fuel,MP)$(not (MPCofire(MP) and MPNew(MP)))*(MPFuel(MP,Fuel))*(SimYrWgtKnl(YrFull,Yr))));

KeyRes('%UI_Scen%','%UI_ScenName%','NPCapTech',YrFull,ResPPAR,FuelTechVin,'na')    = sum((MP,Fuel),sum(Yr,NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin(FuelTechVin,MP)*(SimYrWgtKnl(YrFull,Yr))));


*Generation
KeyRes('%UI_Scen%','%UI_ScenName%','GenTot_Hist',YrFullHist,ResPPAR,'na','na')     = sum(Fuel,sum(HMR,GenFuelHist(YrFullHist,HMR,Fuel)*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)))$(not FuelStorage(Fuel)))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','GenTot',YrFull,ResPPAR,'na','na')              = sum((Fuel,MP),sum(Yr,GenYPFM(Yr,ResPPAR,Fuel,MP)$(not FuelStorage(Fuel))*(SimYrWgtKnl(YrFull,Yr))));
KeyRes('%UI_Scen%','%UI_ScenName%','GenTot_AEO',YrFull,'na','na','na')             = sum(Yr,sum((HMR,Fuel),GenAEOFuelYH(Yr,HMR,Fuel))*(SimYrWgtKnl(YrFull,Yr)));

KeyRes('%UI_Scen%','%UI_ScenName%','GenF_Hist',YrFullHist,ResPPAR,Fuel,'na')       = sum(HMR,GenFuelHist(YrFullHist,HMR,Fuel)*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','GenF',YrFull,ResPPAR,Fuel,'na')                = sum((MP),sum(Yr,GenYPFM(Yr,ResPPAR,Fuel,MP)*(SimYrWgtKnl(YrFull,Yr))));
KeyRes('%UI_Scen%','%UI_ScenName%','GenF_AEO',YrFull,ResPPAR,Fuel,'na')            = sum(Yr,sum(HMR, GenAEOFuelYH(Yr,HMR,Fuel)*map_all_YPH(Yr,ResPPAR,HMR))*(SimYrWgtKnl(YrFull,Yr)));

KeyRes('%UI_Scen%','%UI_ScenName%','GenTech',YrFull,ResPPAR,FuelTechVin,'na')      = sum((MP,Fuel),sum(Yr,GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin(FuelTechVin,MP)*(SimYrWgtKnl(YrFull,Yr))));

KeyRes('%UI_Scen%','%UI_ScenName%','Imports',YrFull,ResPPAR,'na','na')             = sum(Yr,sum(HMR, sum((Sea,TB),(sum(HMRei(HMRe,HMR),Trans.l(Yr,HMRe,HMR,Sea,TB))-sum(HMRei(HMR,HMRi),Trans.l(Yr,HMR,HMRi,Sea,TB)) +NetFrgnImpCHP(Yr,HMR,Sea,TB)))*map_all_YPH(Yr,ResPPAR,HMR))*SimYrWgtKnl(YrFull,Yr));


KeyRes('%UI_Scen%','%UI_ScenName%','NPCap_RE',YrFull,ResPPAR,'na','na')            = sum(Yr,sum(Fuel,
                                                                                                sum(MP,NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Offshore Wind',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Onshore Wind',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Solar',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Hydro',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Geo',MP))
                                                                                            )*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','NPCap_ZC',YrFull,ResPPAR,'na','na')            = KeyRes('%UI_Scen%','%UI_ScenName%','NPCap_RE',YrFull,ResPPAR,'na','na')
                                                                                     + sum(Yr,sum(Fuel,sum(MP,NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Nuke',MP)))*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','NPCap_LC',YrFull,ResPPAR,'na','na')            = KeyRes('%UI_Scen%','%UI_ScenName%','NPCap_ZC',YrFull,ResPPAR,'na','na')
                                                                                     + sum(Yr,sum(Fuel,
                                                                                                sum(MP,NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Retrofit Coal CCS',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Coal CCS',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Rerofit NG CCS',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('New NG CCS',MP))
                                                                                                )*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','NPCap_LCS',YrFull,ResPPAR,'na','na')           = KeyRes('%UI_Scen%','%UI_ScenName%','NPCap_LC',YrFull,ResPPAR,'na','na')
                                                                                     + sum(Yr,sum(Fuel,sum(MP,NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Storage',MP)))*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','NPCapNew_RE',YrFull,ResPPAR,'na','na')         = sum(Yr,sum(Fuel,
                                                                                                sum(MP,(NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Offshore Wind',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Onshore Wind',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Solar',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Hydro',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Geo',MP))$(MPNew(MP)))
                                                                                                )*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','NPCapNew_ZC',YrFull,ResPPAR,'na','na')         =  KeyRes('%UI_Scen%','%UI_ScenName%','NPCapNew_RE',YrFull,ResPPAR,'na','na')
                                                                                     + sum(Yr,sum(Fuel,sum(MP,NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Nuke',MP)$(MPNew(MP))))*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','NPCapNew_LC',YrFull,ResPPAR,'na','na')         = KeyRes('%UI_Scen%','%UI_ScenName%','NPCapNew_ZC',YrFull,ResPPAR,'na','na')
                                                                                     + sum(Yr,sum(Fuel,
                                                                                                sum(MP,(NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Retrofit Coal CCS',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Coal CCS',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Rerofit NG CCS',MP)
                                                                                                        +NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('New NG CCS',MP)))
                                                                                                )*SimYrWgtKnl(YrFull,Yr));
KeyRes('%UI_Scen%','%UI_ScenName%','NPCapNew_LCS',YrFull,ResPPAR,'na','na')        = KeyRes('%UI_Scen%','%UI_ScenName%','NPCapNew_LC',YrFull,ResPPAR,'na','na')
                                                                                     + sum(Yr,sum(Fuel,sum(MP,NPCapYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Storage',MP)$(MPNew(MP))))*SimYrWgtKnl(YrFull,Yr));


KeyRes('%UI_Scen%','%UI_ScenName%','PctGen_RE',YrFull,ResPPAR,'na','na')           = sum(Yr,sum(Fuel,
                                                                                                sum(MP,GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Offshore Wind',MP)
                                                                                                        +GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Onshore Wind',MP)
                                                                                                        +GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Solar',MP)
                                                                                                        +GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Hydro',MP)
                                                                                                        +GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Geo',MP))
                                                                                                )*SimYrWgtKnl(YrFull,Yr))
                                                                                     / sum(Yr,sum(Fuel,sum(MP,GenYPFM(Yr,ResPPAR,Fuel,MP)$(not MPFuel(MP,'Storage'))))*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','PctGen_ZC',YrFull,ResPPAR,'na','na')           = KeyRes('%UI_Scen%','%UI_ScenName%','PctGen_RE',YrFull,ResPPAR,'na','na')
                                                                                     + sum(Yr,sum(Fuel,sum(MP,GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Nuke',MP)))*SimYrWgtKnl(YrFull,Yr))
                                                                                     / sum(Yr,sum(Fuel,sum(MP,GenYPFM(Yr,ResPPAR,Fuel,MP)$(not MPFuel(MP,'Storage'))))*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','PctGen_LC',YrFull,ResPPAR,'na','na')           = KeyRes('%UI_Scen%','%UI_ScenName%','PctGen_ZC',YrFull,ResPPAR,'na','na')
                                                                                     + sum(Yr,
                                                                                                sum(Fuel,
                                                                                                sum(MP,(GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Retrofit Coal CCS',MP)
                                                                                                        +GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Coal CCS',MP)
                                                                                                        +GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('Rerofit NG CCS',MP)
                                                                                                        +GenYPFM(Yr,ResPPAR,Fuel,MP)*MPFuelTechVin('New NG CCS',MP)))
                                                                                                )*SimYrWgtKnl(YrFull,Yr))
                                                                                     /sum(Yr,sum(Fuel,sum(MP,GenYPFM(Yr,ResPPAR,Fuel,MP)$(not MPFuel(MP,'Storage'))))*SimYrWgtKnl(YrFull,Yr));


*------------------------------------ Electricity Emissions -------------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','EmisCO2_Hist',YrFullHist,ResPPAR,'na','na')     = sum(Fuel,sum(HMR,EmisFuelHist(YrFullHist,HMR,Fuel,'CO2')*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)))$(not FuelStorage(Fuel)))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisCO2',YrFull,ResPPAR,'na','na')              = sum((Yr,Fuel,MP),EmisYPFM(Yr,ResPPAR,Fuel,MP,'CO2')*SimYrWgtKnl(YrFull,Yr))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisCO2_AEO',YrFull,ResPPAR,'na','na')          = sum(Yr,sum(Fuel,sum(HMR,EmisAEO(Yr,HMR,Fuel,'CO2')*map_all_YPH(Yr,ResPPAR,HMR))$(not FuelStorage(Fuel)))*(1/MtSt)*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','EmisFCO2_Hist',YrFullHist,ResPPAR,Fuel,'na')    = sum(HMR,EmisFuelHist(YrFullHist,HMR,Fuel,'CO2')*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisFCO2',YrFull,ResPPAR,Fuel,'na')             = sum(HMR,sum(Yr,EmisFuel(Yr,HMR,Fuel,'CO2')*map_all_YPH(Yr,ResPPAR,HMR)*(SimYrWgtKnl(YrFull,Yr))))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisFCO2_AEO',YrFull,ResPPAR,Fuel,'na')         = sum(Yr,sum(HMR,EmisAEO(Yr,HMR,Fuel,'CO2')*map_EmisPol_YPH(Yr,ResPPAR,HMR))*(1/MtSt)*(SimYrWgtKnl(YrFull,Yr)));

KeyRes('%UI_Scen%','%UI_ScenName%','EmisSO2_Hist',YrFullHist,ResPPAR,'na','na')     = sum(Fuel,sum(HMR,EmisFuelHist(YrFullHist,HMR,Fuel,'SO2')*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)))$(not FuelStorage(Fuel)))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisSO2',YrFull,ResPPAR,'na','na')              = sum((Yr,Fuel,MP),EmisYPFM(Yr,ResPPAR,Fuel,MP,'SO2')*SimYrWgtKnl(YrFull,Yr))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisSO2_AEO',YrFull,ResPPAR,'na','na')          = sum(Yr,sum(Fuel,sum(HMR,EmisAEO(Yr,HMR,Fuel,'SO2')*map_all_YPH(Yr,ResPPAR,HMR))$(not FuelStorage(Fuel)))*(1/MtSt)*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','EmisFSO2_Hist',YrFullHist,ResPPAR,Fuel,'na')    = sum(HMR,EmisFuelHist(YrFullHist,HMR,Fuel,'SO2')*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisFSO2',YrFull,ResPPAR,Fuel,'na')             = sum(HMR,sum(Yr,EmisFuel(Yr,HMR,Fuel,'SO2')*map_all_YPH(Yr,ResPPAR,HMR)*(SimYrWgtKnl(YrFull,Yr))))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisFSO2_AEO',YrFull,ResPPAR,Fuel,'na')         = sum(Yr,sum(HMR,EmisAEO(Yr,HMR,Fuel,'SO2')*map_EmisPol_YPH(Yr,ResPPAR,HMR))*(1/MtSt)*(SimYrWgtKnl(YrFull,Yr)));

KeyRes('%UI_Scen%','%UI_ScenName%','EmisNOx_Hist',YrFullHist,ResPPAR,'na','na')     = sum(Fuel,sum(HMR,EmisFuelHist(YrFullHist,HMR,Fuel,'NOx')*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)))$(not FuelStorage(Fuel)))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisNOx',YrFull,ResPPAR,'na','na')              = sum((Yr,Fuel,MP),EmisYPFM(Yr,ResPPAR,Fuel,MP,'NOx')*SimYrWgtKnl(YrFull,Yr))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisNOx_AEO',YrFull,ResPPAR,'na','na')          = sum(Yr,sum(Fuel,sum(HMR,EmisAEO(Yr,HMR,Fuel,'NOx')*map_all_YPH(Yr,ResPPAR,HMR))$(not FuelStorage(Fuel)))*(1/MtSt)*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','EmisFNOx_Hist',YrFullHist,ResPPAR,Fuel,'na')    = sum(HMR,EmisFuelHist(YrFullHist,HMR,Fuel,'NOx')*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisFNOx',YrFull,ResPPAR,Fuel,'na')             = sum(HMR,sum(Yr,EmisFuel(Yr,HMR,Fuel,'NOx')*map_all_YPH(Yr,ResPPAR,HMR)*(SimYrWgtKnl(YrFull,Yr))))*(1/MtSt);
KeyRes('%UI_Scen%','%UI_ScenName%','EmisFNOx_AEO',YrFull,ResPPAR,Fuel,'na')         = sum(Yr,sum(HMR,EmisAEO(Yr,HMR,Fuel,'NOx')*map_EmisPol_YPH(Yr,ResPPAR,HMR))*(1/MtSt)*(SimYrWgtKnl(YrFull,Yr)));

*------------------------------------ Sectoral Emissions -------------------------------------
$ifthen.CSP %UI_CSP% ==AEO
KeyRes('%UI_Scen%','%UI_ScenName%','EmisSectCO2',YrFull,ResPPAR,Sector,'na')        =    sum(HMR,Emis0AEO(YrFull,HMR,Sector, '%UI_Demand%')*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)));
$elseif.CSP %UI_CSP% ==CSP
KeyRes('%UI_Scen%','%UI_ScenName%','EmisSectCO2',YrFull,ResPPAR,Sector,'na')        =    sum(HMR,Emis0CSP(YrFull,HMR,Sector, '%UI_Demand%')*sum(Yr,map_all_YPH(Yr,ResPPAR,HMR)));
$endif.CSP


*-------------------------------------- Electricity Policy --------------------------------------
*Carbon Markets
KeyRes('%UI_Scen%','%UI_ScenName%','CPrc',YrFull,ResPPAR,'na','na')                 = sum(Yr,AlwPrc.L(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr))* Inflation('%UI_USD%');
KeyRes('%UI_Scen%','%UI_ScenName%','CPriceRev',YrFull,ResPPAR,'na','na')            = sum((Yr,MP,HMR),sum(PPAR,AlwPrc.l(Yr,PPAR)*map_EmisPol_YPHM(Yr,PPAR,HMR,MP))*sum((Sea,TB),Gen.l(Yr,HMR,MP,Sea,TB))*ERoF(Yr,HMR,MP)*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr)/(1E3))* Inflation('%UI_USD%');

*Renewable Portfolio Standard
KeyRes('%UI_Scen%','%UI_ScenName%','PSPrc',YrFull,ResPPAR,'na','na')                = sum(Yr,PSPrc.L(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr)) * Inflation('%UI_USD%');
KeyRes('%UI_Scen%','%UI_ScenName%','PSReq',YrFull,ResPPAR,'na','na')                = sum(Yr,PSReq.L(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr));
KeyRes('%UI_Scen%','%UI_ScenName%','PSPriceRev',YrFull,ResPPAR,'na','na')           = (sum((Yr,PPAR,HMR,MP,Sea,TB),PSPrc.l(Yr,PPAR)*PSCredit(Yr,PPAR,HMR,MP)*map_PS_YPHM(Yr,PPAR,HMR,MP)*Gen.l(Yr,HMR,MP,Sea,TB)*SimYrWgtKnl(YrFull,Yr))/1E3)* Inflation('%UI_USD%');

*Tax Credits
KeyRes('%UI_Scen%','%UI_ScenName%','PTCCosts',YrFull,ResPPAR,'na','na')             = Inflation('%UI_USD%') *
                         sum((YrFulldup,HMR,MP),
                                 (sum((Yr,Sea,TB),(NPCap.l(Yr,HMR,MP)*ACFGen(Yr,HMR,MP,Sea,TB))*SimYrWgtKnl(YrFulldup,Yr)*OpNPCapRat(HMR,MP,Sea)*Hrs(Sea,TB))
                                  -sum((Yr,Sea,TB),(NPCap.l(Yr,HMR,MP)*ACFGen(Yr,HMR,MP,Sea,TB))*SimYrWgtKnl(YrFulldup-1,Yr)*OpNPCapRat(HMR,MP,Sea)*Hrs(Sea,TB))
                                 )
                                 *sum((Yr),SimYrWgtKnl(YrFulldup,Yr)
                                         *PTCPrc(Yr,ResPPAR)*PTCredit(Yr,ResPPAR,HMR,MP)$map_PTC_YPHM(Yr,ResPPAR,HMR,MP) )$(SimYrFull(YrFulldup)<=SimYrFull(YrFull) and SimYrFull(YrFulldup) > SimYrFull(YrFull)-TCWindow)
                             )
                         /1000;

KeyRes('%UI_Scen%','%UI_ScenName%','ITCCosts',YrFull,ResPPAR,'na','na')             = Inflation('%UI_USD%') *
                         sum((HMR,MP),
                                 (sum(Yr,NPCap.l(Yr,HMR,MP)*1E3*SimYrWgtKnl(YrFull,Yr))
                                 -sum(Yr,NPCap.l(Yr,HMR,MP)*1E3*SimYrWgtKnl(YrFull-1,Yr))
                                  )
                                 *CapCostOvernight(YrFull,HMR,MP)*sum(Yr,SimYrWgtKnl(YrFull,Yr)*ITCredit(Yr,ResPPAR,HMR,MP)*ITCPct(Yr,ResPPAR)$map_ITC_YPHM(Yr,ResPPAR,HMR,MP))
                             )
                         /1000;

KeyRes('%UI_Scen%','%UI_ScenName%','ITCCosts_levelized',YrFull,ResPPAR,'na','na')   = Inflation('%UI_USD%') *
                         sum((YrFulldup,HMR,MP),
                                 (sum(Yr,NPCap.l(Yr,HMR,MP)*1E3*SimYrWgtKnl(YrFulldup,Yr))
                                 -sum(Yr,NPCap.l(Yr,HMR,MP)*1E3*SimYrWgtKnl(YrFulldup-1,Yr))
                                  )
                                * (sum(Yr,CapCostF(Yr,HMR,MP)*(ITCPct(Yr,ResPPAR)*ITCredit(Yr,ResPPAR,HMR,MP)*map_ITC_YPHM(Yr,ResPPAR,HMR,MP))*SimYrWgtKnl(YrFulldup,Yr)))
                                                 $(SimYrFull(YrFulldup)<=SimYrFull(YrFull) and SimYrFull(YrFulldup) > SimYrFull(YrFull)-InvPlnHrzn)
                             )
                         /1000;

KeyRes('%UI_Scen%','%UI_ScenName%','CCCCosts',YrFull,ResPPAR,'na','na')              =  Inflation('%UI_USD%') * sum((Yr,HMR),Expend45Q_YH(Yr,HMR)*SimYrWgtKnl(YrFull,Yr)*map_all_YPH(Yr,ResPPAR,HMR));

KeyRes('%UI_Scen%','%UI_ScenName%','CumPTCCosts',YrFull,ResPPAR,'na','na')           =
         sum(YrFulldup,KeyRes('%UI_Scen%','%UI_ScenName%','PTCCosts',YrFulldup,ResPPAR,'na','na')$( SimYrFull(YrFulldup)<= SimYrFull(YrFull) ));

KeyRes('%UI_Scen%','%UI_ScenName%','CumITCCosts',YrFull,ResPPAR,'na','na')           =
         sum(YrFulldup,KeyRes('%UI_Scen%','%UI_ScenName%','ITCCosts_levelized',YrFulldup,ResPPAR,'na','na')$( SimYrFull(YrFulldup)<= SimYrFull(YrFull) ));

KeyRes('%UI_Scen%','%UI_ScenName%','CumCCCCosts',YrFull,ResPPAR,'na','na')           =
         sum(YrFulldup,KeyRes('%UI_Scen%','%UI_ScenName%','CCCCosts',YrFulldup,ResPPAR,'na','na')$( SimYrFull(YrFulldup)<= SimYrFull(YrFull) ));


KeyRes('%UI_Scen%','%UI_ScenName%','NetGovRev',YrFull,ResPPAR,'na','na')             = KeyRes('%UI_Scen%','%UI_ScenName%','CPriceRev',YrFull,ResPPAR,'na','na')
                                                                                        - KeyRes('%UI_Scen%','%UI_ScenName%','PTCCosts',YrFull,ResPPAR,'na','na')
                                                                                        - KeyRes('%UI_Scen%','%UI_ScenName%','ITCCosts',YrFull,ResPPAR,'na','na')
                                                                                        - KeyRes('%UI_Scen%','%UI_ScenName%','CCCCosts',YrFull,ResPPAR,'na','na');

KeyRes('%UI_Scen%','%UI_ScenName%','NetGovRev_levelized',YrFull,ResPPAR,'na','na')     = KeyRes('%UI_Scen%','%UI_ScenName%','CPriceRev',YrFull,ResPPAR,'na','na')
                                                                                        - KeyRes('%UI_Scen%','%UI_ScenName%','PTCCosts',YrFull,ResPPAR,'na','na')
                                                                                        - KeyRes('%UI_Scen%','%UI_ScenName%','ITCCosts_levelized',YrFull,ResPPAR,'na','na')
                                                                                        - KeyRes('%UI_Scen%','%UI_ScenName%','CCCCosts',YrFull,ResPPAR,'na','na');

KeyRes('%UI_Scen%','%UI_ScenName%','CCSEmis',ResYr,'Nat','na','na')                    = sum((HMRe,HMRi,StepCCS,TypeCCS),CCSEmis.l(ResYr,HMRe,HMRi,StepCCS,TypeCCS))*(1/MtSt)/1000;


*----------------------------------Detailed Costs-----------------------------------
*SupDemEq.M is in $/MWh and Gen.l is in GWh.  We want to be in million $, so divide by 1000
KeyRes('%UI_Scen%','%UI_ScenName%','FCoNat_NG',Yr,'na','na','na')                      = sum((HMR,MP,Sea,TB),FCiRef(Yr,HMR,'NG')*HR(Yr,HMR,MP)*Gen.l(Yr,HMR,MP,Sea,TB)$MPFC(MP,'NG'))*Inflation('%UI_USD%') / sum((HMR,MP,Sea,TB),HR(Yr,HMR,MP)*Gen.l(Yr,HMR,MP,Sea,TB)$MPFC(MP,'NG'));
*Note that all HMRs have the same CapCost0, so TX is an arbitrary choice
KeyRes('%UI_Scen%','%UI_ScenName%','CapCostAEO_NewNGCC',ResYr,'na','na','na')          = CapCost0('TX','New NGCC')*CapCostAnnScl(ResYr,'New NGCC')*Inflation('%UI_USD%');

KeyRes('%UI_Scen%','%UI_ScenName%','WholesaleRev_YPM',ResYr,ResPPAR,'na',MP)         = sum(HMR,sum((Sea,TB),SupDemEq.M(ResYr,HMR,Sea,TB)*Gen.l(ResYr,HMR,MP,Sea,TB))*map_EmisPol_YPH(ResYr,ResPPAR,HMR))/1000;
KeyRes('%UI_Scen%','%UI_ScenName%','WholesaleRev_YPF',ResYr,ResPPAR,Fuel,'na')       = sum((HMR,MP),sum((Sea,TB),SupDemEq.M(ResYr,HMR,Sea,TB)*Gen.l(ResYr,HMR,MP,Sea,TB))*map_EmisPol_YPH(ResYr,ResPPAR,HMR)*MPFuel(MP,Fuel))/1000;

KeyRes('%UI_Scen%','%UI_ScenName%','GenProfitsf',YrFull,'Nat','na','na')        = KeyRes('%UI_Scen%','%UI_ScenName%','RevGen',YrFull,'Nat','na','na')
                                                                                  - KeyRes('%UI_Scen%','%UI_ScenName%','RCost',YrFull,'Nat','na','na')
                                                                                  + KeyRes('%UI_Scen%','%UI_ScenName%','PTCCosts',YrFull,'Nat','na','na')
                                                                                  + KeyRes('%UI_Scen%','%UI_ScenName%','ITCCosts_levelized',YrFull,'Nat','na','na')
                                                                                  + KeyRes('%UI_Scen%','%UI_ScenName%','CCCCosts',YrFull,'Nat','na','na')
                                                                                  - KeyRes('%UI_Scen%','%UI_ScenName%','CPriceRev',YrFull,'Nat','na','na')
                                                                                  + KeyRes('%UI_Scen%','%UI_ScenName%','PSPriceRev',YrFull,'Nat','na','na');

KeyRes('%UI_Scen%','%UI_ScenName%','GenProfitsf_cal',YrFull,'Nat','na','na')     = KeyRes('%UI_Scen%','%UI_ScenName%','Rev',YrFull,'Nat','na','na')
                                                                                  - KeyRes('%UI_Scen%','%UI_ScenName%','RCost',YrFull,'Nat','na','na')
                                                                                  + KeyRes('%UI_Scen%','%UI_ScenName%','PTCCosts',YrFull,'Nat','na','na')
                                                                                  + KeyRes('%UI_Scen%','%UI_ScenName%','ITCCosts_levelized',YrFull,'Nat','na','na')
                                                                                  + KeyRes('%UI_Scen%','%UI_ScenName%','CCCCosts',YrFull,'Nat','na','na')
                                                                                  - KeyRes('%UI_Scen%','%UI_ScenName%','CPriceRev',YrFull,'Nat','na','na')
                                                                                  + KeyRes('%UI_Scen%','%UI_ScenName%','PSPriceRev',YrFull,'Nat','na','na');

*---------------------------------- Diagnostics ----------------------------------
KeyRes('%UI_Scen%','%UI_ScenName%','Obj','na','na','na','na')                          = sum((Yr,HMR),ObjInt.l(Yr,HMR)) * Inflation('%UI_USD%');
KeyRes('%UI_Scen%','%UI_ScenName%','TotCostLP','na','na','na','na')                    = TotCostLP.l;

*---------------------------------Wholesale Prices--------------------------------

KeyRes('%UI_Scen%','%UI_ScenName%','WholesalePrc',YrFull,ResPPAR,'na','na') = Inflation('%UI_USD%') * sum((Yr,HMR,Sea,TB),SupDemEq.M(Yr,HMR,Sea,TB)*ECons.l(Yr,HMR,Sea,TB)*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr))
                                                                                 /sum((Yr,HMR,Sea,TB),ECons.l(Yr,HMR,Sea,TB)*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','CalibrationAdders',YrFull,ResPPAR,'na','na') = Inflation('%UI_USD%') * sum((Yr,HMR,Sea),(CalEPrcRtl.L(Yr,HMR,Sea) + CalEPrcRtl2.L(Yr,HMR,Sea))*sum(TB,ECons.l(Yr,HMR,Sea,TB))*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr))
                                                                                     / sum((Yr,HMR,Sea,TB),ECons.l(Yr,HMR,Sea,TB)*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr));


KeyRes('%UI_Scen%','%UI_ScenName%','CapCost_perMWh',YrFull,ResPPAR,'na','na') = sum(Yr,RCost_CapCost(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr)*1E3)
                                                                                         / sum((Yr,HMR,Sea,TB),ECons.l(Yr,HMR,Sea,TB)*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr));

KeyRes('%UI_Scen%','%UI_ScenName%','CapCostSub_perMWh',YrFull,ResPPAR,'na','na') = Inflation('%UI_USD%') * (sum(Yr,RCost_CapCost(Yr,ResPPAR)*SimYrWgtKnl(YrFull,Yr)*1E3)
                                                                                                             -sum((YrFulldup,HMR,MP),
                                                                                                                 (sum(Yr,NPCap.l(Yr,HMR,MP)*1E3*SimYrWgtKnl(YrFulldup,Yr))
                                                                                                                 -sum(Yr,NPCap.l(Yr,HMR,MP)*1E3*SimYrWgtKnl(YrFulldup-1,Yr)))
                                                                                                                * (sum(Yr,CapCostF(Yr,HMR,MP)*(ITCPct(Yr,ResPPAR)*ITCredit(Yr,ResPPAR,HMR,MP)*map_ITC_YPHM(Yr,ResPPAR,HMR,MP))*SimYrWgtKnl(YrFulldup,Yr)))
                                                                                                                              $(SimYrFull(YrFulldup)<=SimYrFull(YrFull) and SimYrFull(YrFulldup) > SimYrFull(YrFull)-InvPlnHrzn)))
                                                                                         / sum((Yr,HMR,Sea,TB),ECons.l(Yr,HMR,Sea,TB)*map_all_YPH(Yr,ResPPAR,HMR)*SimYrWgtKnl(YrFull,Yr));


KeyRes('%UI_Scen%','%UI_ScenName%','ProdSurp',YrFull,ResPPAR,'na','na')         =  KeyRes('%UI_Scen%','%UI_ScenName%','Rev',YrFull,ResPPAR,'na','na')
                                                                                   -KeyRes('%UI_Scen%','%UI_ScenName%','RCost',YrFull,ResPPAR,'na','na');

KeyRes('%UI_Scen%','%UI_ScenName%','ProdSurpGen',YrFull,ResPPAR,'na','na')      =  KeyRes('%UI_Scen%','%UI_ScenName%','RevGen',YrFull,ResPPAR,'na','na')
                                                                                   -KeyRes('%UI_Scen%','%UI_ScenName%','RCost',YrFull,ResPPAR,'na','na');