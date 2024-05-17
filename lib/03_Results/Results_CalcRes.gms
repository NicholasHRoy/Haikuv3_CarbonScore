* Calculate post-processing parameters.
*-----------------------------------------------------------------------------------------------------------------------

** MP cost and performance characteristics ---------------------------------------------------
CapCostF(Yr,HMR,MP)  = CapCost(Yr,HMR,MP);
ITCCapCost(YrFull,HMR,MP) = betaRt*(CapCostOvernight(YrFull,HMR,MP)*sum(Yr,(sum(PPAR,ITCPct(Yr,PPAR)$map_ITC_YPHM(Yr,PPAR,HMR,MP)))*SimYrWgtKnl(YrFull,Yr)))/(1-(1+betaRt)**(-InvPlnHrzn));
CapCostITC(Yr,HMR,MP)= CapCost(Yr,HMR,MP) - ITCCapCost(Yr,HMR,MP);
FOMF(Yr,HMR,MP)=FOM(Yr,HMR,MP);
VOMF(Yr,HMR,MP)=( sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)*VOM(Yr,HMR,MP))
        /sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)) )$sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB));


HRF(Yr,HMR,MP)=HR(Yr,HMR,MP);
FCoF(Yr,HMR,MP)=( sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)* ( FCo(Yr,HMR,MP,Sea)$(not sum(Fuel,MPFC(MP,Fuel)))
        +(FCiRef(Yr,HMR,'NG')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'NG')
        +(FCiRef(Yr,HMR,'Coal')*HR(Yr,HMR,MP)*1E-3)$(MPFC(MP,'Coal') and not (MPNew(MP) and MPCofire(MP)))
        +(((1-CofirePct(HMR,MP))*FCiRef(Yr,HMR,'Coal') + CofirePct(HMR,MP)*FCiRef(Yr,HMR,'NG')) * HR(Yr,HMR,MP)*1E-3)$(MPFC(MP,'Coal') and (MPNew(MP) and MPCofire(MP)))
        +(FCiRef(Yr,HMR,'Oil')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'Oil') ))
                /sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)) )$sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB));
ERoF(Yr,HMR,MP)=ERo(Yr,HMR,MP,'CO2');

MVCostF(Yr,HMR,MP,Sea,TB)= VOM(Yr,HMR,MP)
                                 +FCo(Yr,HMR,MP,Sea)$(not sum(Fuel,MPFC(MP,Fuel)))
                                 +(FCiRef(Yr,HMR,'Coal')*HR(Yr,HMR,MP)*1E-3)$(MPFC(MP,'Coal') and not (MPNew(MP) and MPCofire(MP)))
                                 +(((1-CofirePct(HMR,MP))*FCiRef(Yr,HMR,'Coal') + CofirePct(HMR,MP)*FCiRef(Yr,HMR,'NG')) * HR(Yr,HMR,MP)*1E-3)$(MPFC(MP,'Coal') and (MPNew(MP) and MPCofire(MP)))
                                 +(FCiRef(Yr,HMR,'NG')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'NG')
                                 +(FCiRef(Yr,HMR,'Oil')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'Oil')
                                 +sum(Fuel,CalGen.L(Yr,HMR,Fuel)$(MPFuel(MP,Fuel) and CalGenIncl(Yr,HMR,Fuel)))
                                 +CalGenTot.L(Yr,HMR)
                                 +CalEmis.L(Yr)*ERo(Yr,HMR,MP,'CO2')
                                 +CalEmisRGGI.L(Yr)*ERo(Yr,HMR,MP,'CO2')$HMRRGGICal(HMR)
                                 +sum(PPAR,AlwPrc.L(Yr,PPAR)*map_EmisPol_YPHM(Yr,PPAR,HMR,MP))$(%UI_CTax% > 0)*ERo(Yr,HMR,MP,'CO2')
                                 +sum(PPAR,AlwPrcBank.L(Yr,PPAR)*map_EmisPol_YPHM(Yr,PPAR,HMR,MP))*ERo(Yr,HMR,MP,'CO2')
                                 -sum(PPAR,PSPrc.l(Yr,PPAR)*PSCredit(Yr,PPAR,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP));

** Capacity ---------------------------------------------------
NPCapNat(Yr,MP)=sum(HMR,NPCap.L(Yr,HMR,MP));
NPCapTot(Yr,HMR)=sum(MP,NPCap.L(Yr,HMR,MP));
NPCapNatTot(Yr)=sum(HMR,NPCapTot(Yr,HMR));
NPCapFuel(Yr,HMR,Fuel)=sum(MP,NPCap.L(Yr,HMR,MP)*MPFuel(MP,Fuel));
NPCapFuelNat(Yr,Fuel)=sum(HMR,NPCapFuel(Yr,HMR,Fuel));

NPCapYHFM(Yr,HMR,Fuel,MP)=NPCap.L(Yr,HMR,MP)*MPFuel(MP,Fuel);
NPCapYPFM(Yr,PPAR,Fuel,MP)=sum((HMR),NPCap.L(Yr,HMR,MP)$map_all_YPH(Yr,PPAR,HMR)*MPFuel(MP,Fuel));
NPCapFuelYP_EmisPol(Yr,Fuel,PPAR)=sum((HMR,MP),NPCap.L(Yr,HMR,MP)$map_EmisPol_YPH(Yr,PPAR,HMR)*MPFuel(MP,Fuel)*MPFuel(MP,Fuel));
NPCapFuelYPCvr_EmisPol(Yr,Fuel,PPAR)=sum((HMR,MP),NPCap.L(Yr,HMR,MP)$map_EmisPol_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));
NPCapFuelYP_PS(Yr,Fuel,PPAR)=sum((HMR,MP),NPCap.L(Yr,HMR,MP)$map_PS_YPH(Yr,PPAR,HMR)*MPFuel(MP,Fuel));
NPCapFuelYPCvr_PS(Yr,Fuel,PPAR)=sum((HMR,MP),NPCap.L(Yr,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));

** Generation ---------------------------------------------------
GenAnn(Yr,HMR,MP)=sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB))/1E3;
GenAnnNat(Yr,MP)=sum(HMR,GenAnn(Yr,HMR,MP));
GenTot(Yr,HMR)=sum(MP,GenAnn(Yr,HMR,MP)$(not MPFuel(MP,'Storage')));
GenNat(Yr)=sum((HMR,MP),GenAnn(Yr,HMR,MP)$(not MPFuel(MP,'Storage')));
GenFuel(Yr,HMR,Fuel)=sum(MP,GenAnn(Yr,HMR,MP)*MPFuel(MP,Fuel));
GenFuelNat(Yr,Fuel)=sum(HMR,GenFuel(Yr,HMR,Fuel));

GenYHFM(Yr,HMR,Fuel,MP)=GenAnn(Yr,HMR,MP)*MPFuel(MP,Fuel);
GenYPFM(Yr,PPAR,Fuel,MP)=sum((HMR),GenAnn(Yr,HMR,MP)$map_all_YPH(Yr,PPAR,HMR)*MPFuel(MP,Fuel));
GenYHFS(Yr,HMR,Fuel,Sea) = sum((MP,TB),Gen.L(Yr,HMR,MP,Sea,TB)*MPFuel(MP,Fuel))/1E3;
CF_YHFM(Yr,HMR,Fuel,MP)$(NPCapYHFM(Yr,HMR,Fuel,MP)) = GenYHFM(Yr,HMR,Fuel,MP)*1E3 / (NPCapYHFM(Yr,HMR,Fuel,MP)*8760);
GenFuelYP_EmisPol(Yr,Fuel,PPAR)=sum((HMR,MP),GenAnn(Yr,HMR,MP)$map_EmisPol_YPH(Yr,PPAR,HMR)*MPFuel(MP,Fuel));
GenFuelYPCvr_EmisPol(Yr,Fuel,PPAR)=sum((HMR,MP),GenAnn(Yr,HMR,MP)$map_EmisPol_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));
GenFuelYP_PS(Yr,Fuel,PPAR)=sum((HMR,MP),GenAnn(Yr,HMR,MP)$map_PS_YPH(Yr,PPAR,HMR)*MPFuel(MP,Fuel));
GenFuelYPCvr_PS(Yr,Fuel,PPAR)=sum((HMR,MP),GenAnn(Yr,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));
GenFuelYPCred_PS(Yr,Fuel,PPAR)=sum((HMR,MP),(GenAnn(Yr,HMR,MP)*PSCredit(Yr,PPAR,HMR,MP))$map_PS_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));
GenYPFMCred_PS(Yr,PPAR,Fuel,MP)=sum((HMR),(GenAnn(Yr,HMR,MP)*PSCredit(Yr,PPAR,HMR,MP))$map_PS_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));

GenYP_EmisPol(Yr,PPAR)=sum(Fuel,GenFuelYP_EmisPol(Yr,Fuel,PPAR)$(not FuelStorage(Fuel)));
GenYPCvr_EmisPol(Yr,PPAR)=sum(Fuel,GenFuelYPCvr_EmisPol(Yr,Fuel,PPAR)$(not FuelStorage(Fuel)));
GenYP_PS(Yr,PPAR)=sum(Fuel,GenFuelYP_PS(Yr,Fuel,PPAR)$(not FuelStorage(Fuel)));
GenYPCvr_PS(Yr,PPAR)=sum(Fuel,GenFuelYPCvr_PS(Yr,Fuel,PPAR)$(not FuelStorage(Fuel)));
GenYPCred_PS(Yr,PPAR)=sum(Fuel,GenFuelYPCred_PS(Yr,Fuel,PPAR)$(not FuelStorage(Fuel)));

GenYHFST(Yr,HMR,Fuel,Sea,TB) = sum((MP),Gen.L(Yr,HMR,MP,Sea,TB)$MPFuel(MP,Fuel))/1E3;
GenYPFST(Yr,PPAR,Fuel,Sea,TB) = sum((HMR,MP),Gen.L(Yr,HMR,MP,Sea,TB)$map_all_YPH(Yr,PPAR,HMR)*MPFuel(MP,Fuel))/1E3;
UtilizationFactor(Yr,HMR,MP,Sea,TB)$((NPCap.L(Yr,HMR,MP) <> 0) and (ACFGen(Yr,HMR,MP,Sea,TB)<>0)) = Gen.L(Yr,HMR,MP,Sea,TB)/(NPCap.L(Yr,HMR,MP)*Hrs(Sea,TB)*ACFGen(Yr,HMR,MP,Sea,TB));

GenAEOFuelYH(Yr,HMR,Fuel)=sum(Month,GenAEO(Yr,Month,HMR,Fuel))/1E3;
GenExoYH(Yr,HMR)=sum((MP,Sea,TB),(NPCap.up(Yr,HMR,MP)*OpNPCapRat(HMR,MP,Sea)*CF(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB))
        $(CF(Yr,HMR,MP,Sea,TB) and MPNoDsp(MP) and MPNoRtrInv(MP) and (not MPFuel(MP,'Storage'))) );
GenEndoFuelYH(Yr,HMR,Fuel)=sum((MP,Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)$MPFuel(Mp,Fuel))
        -sum((MPNoDsp(MP),Sea,TB), ( NPCap.lo(Yr,HMR,MP)*OpNPCapRat(HMR,MP,Sea)*CF(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB) )
                $(CF(Yr,HMR,MP,Sea,TB) and MPFuel(MP,Fuel)) );

** Emissions ---------------------------------------------------
EmisAnn(Yr,HMR,MP,Pol)=sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB))*ERo(Yr,HMR,MP,Pol)*PolScl(Pol);
EmisAnnNat(Yr,MP,Pol)=sum(HMR,EmisAnn(Yr,HMR,MP,Pol));
EmisTot(Yr,HMR,Pol)=sum(MP,EmisAnn(Yr,HMR,MP,Pol));
EmisNat(Yr,Pol)=sum((HMR,MP),EmisAnn(Yr,HMR,MP,Pol));
EmisFuel(Yr,HMR,Fuel,Pol)=sum(MP,EmisAnn(Yr,HMR,MP,Pol)*MPFuel(MP,Fuel));
EmisFuelNat(Yr,Fuel,Pol)=sum(HMR,EmisFuel(Yr,HMR,Fuel,Pol));
EmisCO2Nat(Yr)=EmisNat(Yr,'CO2');
EmisCO2FuelNat(Yr,Fuel)=EmisFuelNat(Yr,Fuel,'CO2');

EmisYPFM(Yr,PPAR,Fuel,MP,Pol)=sum((HMR),EmisAnn(Yr,HMR,MP,Pol)$map_all_YPH(Yr,PPAR,HMR)*MPFuel(MP,Fuel));
EmisYPFMCvr_EmisPol(Yr,PPAR,Fuel,MP,Pol)=sum((HMR),EmisAnn(Yr,HMR,MP,Pol)$map_EmisPol_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));
EmisFuelYP_EmisPol(Yr,Fuel,PPAR,Pol)=sum((HMR,MP),EmisAnn(Yr,HMR,MP,Pol)$map_EmisPol_YPH(Yr,PPAR,HMR)*MPFuel(MP,Fuel));
EmisFuelYPCvr_EmisPol(Yr,Fuel,PPAR,Pol)=sum((HMR,MP),EmisAnn(Yr,HMR,MP,Pol)$map_EmisPol_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));
EmisFuelYP_PS(Yr,Fuel,PPAR,Pol)=sum((HMR,MP),EmisAnn(Yr,HMR,MP,Pol)$map_PS_YPH(Yr,PPAR,HMR)*MPFuel(MP,Fuel));
EmisFuelYPCvr_PS(Yr,Fuel,PPAR,Pol)=sum((HMR,MP),EmisAnn(Yr,HMR,MP,Pol)$map_PS_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));

EmisYP_EmisPol(Yr,PPAR,Pol)=sum(Fuel,EmisFuelYP_EmisPol(Yr,Fuel,PPAR,Pol));
EmisYPCvr_EmisPol(Yr,PPAR,Pol)=sum(Fuel,EmisFuelYPCvr_EmisPol(Yr,Fuel,PPAR,Pol));
EmisYP_PS(Yr,PPAR,Pol)=sum(Fuel,EmisFuelYP_PS(Yr,Fuel,PPAR,Pol));
EmisYPCvr_PS(Yr,PPAR,Pol)=sum(Fuel,EmisFuelYPCvr_PS(Yr,Fuel,PPAR,Pol));

EmisAEOYP(Yr,Pol)=sum((HMR,Fuel),EmisAEO(Yr,HMR,Fuel,Pol));
ERFuelPol(Yr,Fuel,Pol)=sum(HMRMP(HMR,MP),EmisAnn(Yr,HMR,MP,Pol)*MPFuel(MP,Fuel))
        /sum(HMR,1$(not GenAEOFuelYH(Yr,HMR,Fuel))+GenAEOFuelYH(Yr,HMR,Fuel))
        /PolScl(Pol)*PolSclER(Pol);

*output for hypothetical emissions programs
EmisYPCvr(Yr,PPAR,Pol)=sum((HMR,MP),EmisAnn(Yr,HMR,MP,Pol)*map_all_YPH(Yr,PPAR,HMR)*EmisPolMP(MP));

** Electricity Consumption & Price ---------------------------------------------------
EConsAnn(Yr,HMR)=sum(Sector,Cons.l(Yr,HMR,Sector))/1E3;
EConsNat(Yr)=sum(HMR,EConsAnn(Yr,HMR));
EConsPPAR(Yr,PPAR)=sum(HMR,EConsAnn(Yr,HMR)$map_all_YPH(Yr,PPAR,HMR));

EConsYHST(Yr,HMR,Sea,TB) = sum(Sector,Cons.l(Yr,HMR,Sector)*SeaPctAnn(Yr,HMR,Sea,Sector)*TBPctSea(Yr,HMR,Sea,TB,Sector))/1000;
EConsYPST(Yr,PPAR,Sea,TB) = sum(HMR,EConsYHST(Yr,HMR,Sea,TB)*map_all_YPH(Yr,PPAR,HMR));
EConsEVYHST(Yr,HMR,Sea,TB) = (Cons.l(Yr,HMR,'EVs')*SeaPctAnn(Yr,HMR,Sea,'EVs')*TBPctSea(Yr,HMR,Sea,TB,'EVs'))/1000;
EConsEVYPST(Yr,PPAR,Sea,TB) = sum(HMR,EConsEVYHST(Yr,HMR,Sea,TB)*map_all_YPH(Yr,PPAR,HMR));

EPrcRtlAnn(Yr,HMR)=sum(Sea,EPrcRtl.L(Yr,HMR,Sea)*sum((TB,Sector),Cons.l(Yr,HMR,Sector)*SeaPctAnn(Yr,HMR,Sea,Sector)*TBPctSea(Yr,HMR,Sea,TB,Sector)/1000))/(EConsAnn(Yr,HMR));
EPrcRtlNat(Yr)=sum(HMR,EPrcRtlAnn(Yr,HMR)*EConsAnn(Yr,HMR))/EConsNat(Yr);
EPrcRtlPPAR(Yr,PPAR)$(sum(HMR,EConsAnn(Yr,HMR)$map_all_YPH(Yr,PPAR,HMR))) = sum(HMR,EPrcRtlAnn(Yr,HMR)*EConsAnn(Yr,HMR)$map_all_YPH(Yr,PPAR,HMR))/sum(HMR,EConsAnn(Yr,HMR)$map_all_YPH(Yr,PPAR,HMR));
EPrcRtlRGGI11(Yr)$(sum(HMR,EConsAnn(Yr,HMR)$map_all_YPH(Yr,'RGGI11',HMR))) = sum(HMR,EPrcRtlAnn(Yr,HMR)*EConsAnn(Yr,HMR)$map_all_YPH(Yr,'RGGI11',HMR))/sum(HMR,EConsAnn(Yr,HMR)$map_all_YPH(Yr,'RGGI11',HMR));

** Trade
*TDLoss(Yr,Sea)
TDLossAnn(Yr,HMR)=sum((MP,Sea,TB),TDLoss(Yr,Sea)*(Gen.L(Yr,HMR,MP,Sea,TB)))/1E3;
TDLossAnnPPAR(Yr,PPAR)=sum(HMR,TDLossAnn(Yr,HMR)$map_all_YPH(Yr,PPAR,HMR));
*Can be calculated in multiple ways that should be equivalent
** Consumption + Storage Consumption + TDLoss - Gen - Gen Storage
** Consumption + Battery Loss        + TDLoss - Gen
** Imports - Exports + NetFrgnImpCHP
NetImportsYP(Yr,PPAR) = EConsPPAR(Yr,PPAR) + sum(HMR,sum((Sea,TB),sum(MP,EConsStorage.l(Yr,HMR,MP,Sea,TB)*map_all_YPH(Yr,PPAR,HMR))))+ TDLossAnnPPAR(Yr,PPAR) - sum(HMR,GenTot(Yr,HMR)*map_all_YPH(Yr,PPAR,HMR));
NetImportsYPS(Yr,HMR,Sea) = sum(TB,ECons.L(Yr,HMR,Sea,TB) + ECons.L(Yr,HMR,Sea,TB)*TDLoss(Yr,Sea) - sum(MP,Gen.L(Yr,HMR,MP,Sea,TB)$(not MPFuel(MP,'Storage'))))/1E3 ;

EffTransCapacity(Yr,HMRe,HMRi,Sea,TB) = Trans.l(Yr,HMRe,HMRi,Sea,TB) / Hrs(Sea,TB);
TransCapacityUtil(Yr,HMRe,HMRi) = sum((Sea,TB),Trans.l(Yr,HMRe,HMRi,Sea,TB)) / sum((Sea,TB),TransCapMax0(HMRe,HMRi)*Hrs(Sea,TB));

** Policy ---------------------------------------------------
PSReqQty(Yr,PPAR) = EConsPPAR(Yr,PPAR)*PSReq.l(Yr,PPAR);
PSPrcRef(Yr,PPAR)=PSPrc.L(Yr,PPAR);
AlwPrcRef(Yr,PPAR)=AlwPrc.L(Yr,PPAR);
Allowances(Yr,PPAR,step) = sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR));

** Policy Revenues and Costs---------------------------------
$ontext
PTCExpendYfP(YrFull,PPAR) = sum((YrFulldup,HMR,MP),
                                 (sum((Yrdup,Sea,TB),(NPCap.l(Yrdup,HMR,MP)*ACFGen(Yrdup,HMR,MP,Sea,TB))*SimYrWgtKnl(YrFulldup,Yrdup)*OpNPCapRat(HMR,MP,Sea)*Hrs(Sea,TB))
                                  -sum((Yrdup,Sea,TB),(NPCap.l(Yrdup,HMR,MP)*ACFGen(Yrdup,HMR,MP,Sea,TB))*SimYrWgtKnl(YrFulldup-1,Yrdup)*OpNPCapRat(HMR,MP,Sea)*Hrs(Sea,TB))
                                 )
                                 *sum((Yrdup),SimYrWgtKnl(YrFulldup,Yrdup)
                                         *PTCPrc(Yrdup,PPAR)*PTCredit(Yrdup,PPAR,HMR,MP)$map_PTC_YPHM(Yrdup,PPAR,HMR,MP) )$(SimYrFull(YrFulldup)<=SimYrFull(YrFull) and SimYrFull(YrFulldup) > SimYrFull(YrFull)-TCWindow)
                             )
                             /1000;

ITCExpendYfP(YrFull,PPAR) = sum((HMR,MP),
                                 (sum(Yrdup,NPCap.l(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull,Yrdup))
                                 -sum(Yrdup,NPCap.l(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull-1,Yrdup))
                                  )
                                 *CapCost0(HMR,MP)*sum(Yr,SimYrWgtKnl(YrFull,Yr)*ITCPct(Yr,PPAR)$map_ITC_YPHM(Yr,PPAR,HMR,MP))
                             )
                             /1000;

CPriceRev(Yr,PPAR)   = AlwPrc.l(Yr,PPAR)*EmisYPCvr_EmisPol(Yr,PPAR,'CO2');

$offtext




*CESTotVal(Yr,PPAR)   = PSPrc.l(Yr,PPAR)*sum((HMR,MP),GenAnn(Yr,HMR,MP)*PSCredit(Yr,PPAR,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP));
*CESBankTot(PPAR)     = sum(YrFull,(sum(Yr,sum((map_PS_YPHM(Yr,PPAR,HMR,MP),Sea,TB),Gen.l(Yr,HMR,MP,Sea,TB)*PSCredit(Yr,PPAR,HMR,MP))*SimYrWgtKnl(YrFull,Yr))));
*CESConsReqTot(PPAR)  = sum(YrFull,sum(Yr,sum(HMR,sum(sector,Cons.l(Yr,HMR,Sector))*map_PS_Sales_YPH(Yr,PPAR,HMR))*SimYrWgtKnl(YrFull,Yr))*PSReqFull(YrFull,PPAR));
*CESBank(Yr,PPAR)     = 1000*sum((HMR,MP),GenAnn(Yr,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP)*PSCredit(Yr,PPAR,HMR,MP))
*                       -sum((HMR),sum(sector,Cons.l(Yr,HMR,Sector))+ sum(MP,EConsStorage.l(Yr,HMR,MP,Sea,TB)*(1-StorageEff)))$map_PS_Sales_YPH(Yr,PPAR,HMR))*PSReq.l(Yr,PPAR);
NationalCE(Yr)       = 1000
                          *sum((HMR,MP),GenAnn(Yr,HMR,MP)$((MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro') or MPFuel(MP,'Nuke')
                                                                 or MPFuel(MP,'Geo') or MPFuel(MP,'Bio') or MPFuel(MP,'NG')))
                                                *(1-(ERo(Yr,HMR,MP,'CO2') / .44)))
                          /
                          ((sum(HMR,(sum(sector,Cons.l(Yr,HMR,Sector))
                                                +sum((MP,Sea,TB),EConsStorage.l(Yr,HMR,MP,Sea,TB)*(1-StorageEff(HMR,MP)))))));

$ontext
PTCNuke(Yr,HMR,MP)= 0;
PTCNuke(Yr,HMR,MP)$(SimYr(Yr) >= %UI_FxNukeGen% and not HMRCOS(HMR))  =
                                         max(0,
                                                 min(15,
                                                     15*(1/Inflation('2023')*Gen.l(Yr,HMR,'Ex Steam Nuclear',Sea,TB)
                                                     - .84*(sum((Sea,TB),(SupDemEq.M(Yr,HMR,Sea,TB) + sum(PPAR,PSPrc.l(Yr,PPAR)*map_PS_YPHM(Yr,PPAR,HMR,MP))*Gen.l(Yr,HMR,'Ex Steam Nuclear',Sea,TB)))
                                                            +sum((Sea,TB),NPCap.l(Yr,HMR,MP)*sum(RsvRg,RsvMrgEq.M(Yr,Rsv_Rg,Sea,TB)*map_RsvRg(HMR,RsvRg)))
                                                            )

15*(1/Inflation('2023'))*Gen.l(Yr,HMR,'Ex Steam Nuclear',Sea,TB))
                                   - 0.8*(sum((Sea,TB),SupDemEq.M(Yr,HMR,Sea,TB)*Gen.l(Yr,HMR,'Ex Steam Nuclear',Sea,TB))
                                                         -25*(1/Inflation('2023'))*sum((Sea,TB),Gen.l(Yr,HMR,'Ex Steam Nuclear',Sea,TB))
                                                   )

$offtext

**Levelized Costs--------------------------------------------

LCOE_Ex(Yr,PPAR,Fuel,MP)$((GenYPFM(Yr,PPAR,Fuel,MP)<>0)AND(not MPNew(MP))) =
                         sum(HMR,
                                 ((FOMF(Yr,HMR,MP)+CapCostF(Yr,HMR,MP))*
                                 HMRMP(HMR,MP)*
                                 NPCapYHFM(Yr,HMR,Fuel,MP)
                                 +
                                 ((FCoF(Yr,HMR,MP)+VOMF(Yr,HMR,MP))*
                                 HMRMP(HMR,MP)*
                                 GenYHFM(Yr,HMR,Fuel,MP)))*
                            map_all_YPH(Yr,PPAR,HMR))
                            /
                            GenYPFM(Yr,PPAR,Fuel,MP);
LCOE_New(Yr,PPAR,Fuel,MP)$((GenYPFM(Yr,PPAR,Fuel,MP)<>0)AND(MPNew(MP))) =
                           sum(HMR,
                                 ((FOMF(Yr,HMR,MP)+CapCostF(Yr,HMR,MP))*
                                 HMRMP(HMR,MP)*
                                 NPCapYHFM(Yr,HMR,Fuel,MP)
                                 +
                                 ((FCoF(Yr,HMR,MP)+VOMF(Yr,HMR,MP))*
                                 HMRMP(HMR,MP)*
                                 GenYHFM(Yr,HMR,Fuel,MP)))*
                            map_all_YPH(Yr,PPAR,HMR))
                            /
                            GenYPFM(Yr,PPAR,Fuel,MP);
LFOM(Yr,PPAR,Fuel,MP)$(GenYPFM(Yr,PPAR,Fuel,MP)<>0) =
                           sum(HMR, FOMF(Yr,HMR,MP)*NPCapYHFM(Yr,HMR,Fuel,MP)*HMRMP(HMR,MP)*map_all_YPH(Yr,PPAR,HMR)) / GenYPFM(Yr,PPAR,Fuel,MP);
LCapCo(Yr,PPAR,Fuel,MP)$(GenYPFM(Yr,PPAR,Fuel,MP)<>0) =
                           sum(HMR, CapCostF(Yr,HMR,MP)*NPCapYHFM(Yr,HMR,Fuel,MP)*HMRMP(HMR,MP)*map_all_YPH(Yr,PPAR,HMR)) / GenYPFM(Yr,PPAR,Fuel,MP);
LVOM(Yr,PPAR,Fuel,MP)$(GenYPFM(Yr,PPAR,Fuel,MP)<>0) =
                           sum(HMR, VOMF(Yr,HMR,MP)*GenYHFM(Yr,HMR,Fuel,MP)*HMRMP(HMR,MP)*map_all_YPH(Yr,PPAR,HMR)) / GenYPFM(Yr,PPAR,Fuel,MP);
LFCo(Yr,PPAR,Fuel,MP)$(GenYPFM(Yr,PPAR,Fuel,MP)<>0) =
                           sum(HMR, FCoF(Yr,HMR,MP)*GenYHFM(Yr,HMR,Fuel,MP)*HMRMP(HMR,MP)*map_all_YPH(Yr,PPAR,HMR)) / GenYPFM(Yr,PPAR,Fuel,MP);
LPolCo(YR,PPAR,Fuel,MP)$(GenYPFM(Yr,PPAR,Fuel,MP)<>0) =
                           ((AlwPrc.l(Yr,PPAR)*EmisYPFMCvr_EmisPol(Yr,PPAR,Fuel,MP,'CO2'))/GenYPFM(Yr,PPAR,Fuel,MP))
                           -(
                                 PTCPrc(Yr,PPAR)*sum(HMR,PTCredit(Yr,PPAR,HMR,MP)$map_PTC_YPHM(Yr,PPAR,HMR,MP))
                                 +PSPrc.l(Yr,PPAR)*sum(HMR,PSCredit(Yr,PPAR,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP))
                                 +
                                 sum(HMR,CapCost(Yr,HMR,MP)*NPCap.L(Yr,HMR,MP)*ITCPct(Yr,PPAR)*ITCredit(Yr,PPAR,HMR,MP)$map_ITC_YPHM(Yr,PPAR,HMR,MP))/GenYPFM(Yr,PPAR,Fuel,MP)
                           )
                           ;

LFixCo(Yr,PPAR,Fuel,MP)$(GenYPFM(Yr,PPAR,Fuel,MP)<>0) =
                          sum(HMR,(FOMF(Yr,HMR,MP)+CapCostF(Yr,HMR,MP))*NPCapYHFM(Yr,HMR,Fuel,MP)*HMRMP(HMR,MP)*map_all_YPH(Yr,PPAR,HMR))/ GenYPFM(Yr,PPAR,Fuel,MP);
LVarCo(Yr,PPAR,Fuel,MP)$(GenYPFM(Yr,PPAR,Fuel,MP)<>0) =
                          sum(HMR,(VOMF(Yr,HMR,MP)+FCoF(Yr,HMR,MP))*GenYHFM(Yr,HMR,Fuel,MP)*HMRMP(HMR,MP)*map_all_YPH(Yr,PPAR,HMR))/ GenYPFM(Yr,PPAR,Fuel,MP);

** Resource Costs -------------------------------------------------------------------------------

FCoExpend(Yr,PPAR,MP)    = sum((HMR,Sea,TB), Gen.l(Yr,HMR,MP,Sea,TB)*FCoF(Yr,HMR,MP)*map_all_YPH(Yr,PPAR,HMR))/1000;
VOMExpend(Yr,PPAR,MP)    = sum((HMR,Sea,TB), Gen.l(Yr,HMR,MP,Sea,TB)*VOMF(Yr,HMR,MP)*map_all_YPH(Yr,PPAR,HMR))/1000;
CCSExpend(Yr,PPAR,MP)    = sum(HMRe,map_all_YPH(Yr,PPAR,HMRe)
                                    * sum((HMRi,StepCCS,TypeCCS),CCSEmis.l(Yr,HMRe,HMRi,StepCCS,TypeCCS)*CCSCost(HMRe,HMRi,StepCCS,TypeCCS))
                                    * (sum((Sea,TB),Gen.l(Yr,HMRe,MP,Sea,TB)*ERoCCS(Yr,HMRe,MP))
                                         /sum((MPdup,Sea,TB),Gen.l(Yr,HMRe,MPdup,Sea,TB)*ERoCCS(Yr,HMRe,MPdup)))
                                 )/1000;
FOMExpend(Yr,PPAR,MP)    = sum(HMR, NPCap.l(Yr,HMR,MP)*1000*FOMF(Yr,HMR,MP)$map_all_YPH(Yr,PPAR,HMR))/1000;
CapCoExpend(Yr,PPAR,MP)  = sum(HMR, map_all_YPH(Yr,PPAR,HMR)*
                            sum(YrFull,
                                (sum(Yrdup,NPCap.l(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull,Yrdup))
                                  -sum(Yrdup,NPCap.l(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull-1,Yrdup))
                                  )
                                * CapCost(YrFull,HMR,MP)$(SimYrFull(YrFull)<=SimYr(Yr))
                                 )
                            )/1000;

RCost_FCo(Yr,PPAR)     = sum((HMR,MP,Sea,TB), Gen.l(Yr,HMR,MP,Sea,TB)*FCoF(Yr,HMR,MP)*map_all_YPH(Yr,PPAR,HMR))/1000;
RCost_VOM(Yr,PPAR)     = sum((HMR,MP,Sea,TB), Gen.l(Yr,HMR,MP,Sea,TB)*VOMF(Yr,HMR,MP)*map_all_YPH(Yr,PPAR,HMR))/1000;
RCost_CCS(Yr,PPAR)     = sum(HMRe, sum((HMRi,StepCCS,TypeCCS),CCSEmis.l(Yr,HMRe,HMRi,StepCCS,TypeCCS)*CCSCost(HMRe,HMRi,StepCCS,TypeCCS))*map_all_YPH(Yr,PPAR,HMRe))/1000;
RCost_FOM(Yr,PPAR)     = sum((HMR,MP), NPCap.l(Yr,HMR,MP)*1000*FOMF(Yr,HMR,MP)$map_all_YPH(Yr,PPAR,HMR))/1000;
RCost_CapCost(Yr,PPAR) = sum(HMRMP(HMR,MP), map_all_YPH(Yr,PPAR,HMR)*
                            sum(YrFull,
                                (sum(Yrdup,NPCap.l(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull,Yrdup))
                                  -sum(Yrdup,NPCap.l(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull-1,Yrdup))
                                  )
                                * CapCost(YrFull,HMR,MP)$(SimYrFull(YrFull)<=SimYr(Yr))
                                 )
                            )/1000;
RCost_Imp(Yr,PPAR) = sum((HMRe,HMRi,Sea,TB),Trans.l(Yr,HMRe,HMRi,Sea,TB)*((SupDemEq.M(Yr,HMRe,Sea,TB)+SupDemEq.M(Yr,HMRi,Sea,TB))/2)*map_all_YPH(Yr,PPAR,HMRi))/1000;
RCost_Exp(Yr,PPAR) = -sum((HMRe,HMRi,Sea,TB),Trans.l(Yr,HMRe,HMRi,Sea,TB)*((SupDemEq.M(Yr,HMRe,Sea,TB)+SupDemEq.M(Yr,HMRi,Sea,TB))/2)*map_all_YPH(Yr,PPAR,HMRe))/1000;


** Fuel consumption and expenditures ---------------------------------------------------
FuelExp(Yr,HMR,MP)=sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)* (
        FCo(Yr,HMR,MP,Sea)$(not sum(Fuel,MPFC(MP,Fuel)))
        +(FCiRef(Yr,HMR,'NG')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'NG')
        +(FCiRef(Yr,HMR,'Coal')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'Coal')
        +(FCiRef(Yr,HMR,'Oil')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'Oil') ));
FuelCons(Yr,HMR,MP)=GenAnn(Yr,HMR,MP)*HR(Yr,HMR,MP)*1E3;
FCiNat(Yr,Fuel)=(sum((HMR,MP),FuelExp(Yr,HMR,MP)$MPFC(MP,Fuel))/sum((HMR,MP),FuelCons(Yr,HMR,MP)$MPFC(MP,Fuel))*1E3)
        $sum((HMR,MP),FuelCons(Yr,HMR,MP)$MPFC(MP,Fuel));

** CCS specific outputs ----------------------------------------------------------
Expend45Q_YHML(Yr,HMR,MP,TypeCCS) = sum((HMRi,StepCCS),max(0,CCSEmis.l(Yr,HMR,HMRi,StepCCS,TypeCCS))*CCS45QVal(Yr,TypeCCS))/1000
                                         * (sum((Sea,TB),Gen.l(Yr,HMR,MP,Sea,TB)*ERoCCS(Yr,HMR,MP))
                                                 /sum((MPdup,Sea,TB),Gen.l(Yr,HMR,MPdup,Sea,TB)*ERoCCS(Yr,HMR,MPdup)));
Expend45Q_YHL(Yr,HMR,TypeCCS) = sum((HMRi,StepCCS),max(0,CCSEmis45q.l(Yr,HMR,HMRi,StepCCS,TypeCCS))*CCS45QVal(Yr,TypeCCS))/1000;
Expend45Q_YH(Yr,HMR) = sum((HMRi,StepCCS,TypeCCS),max(0,CCSEmis45q.l(Yr,HMR,HMRi,StepCCS,TypeCCS))*CCS45QVal(Yr,TypeCCS))/1000;
Expend45Q_YL(Yr,TypeCCS) = sum((HMRe,HMRi,StepCCS),max(0,CCSEmis45q.l(Yr,HMRe,HMRi,StepCCS,TypeCCS))*CCS45QVal(Yr,TypeCCS))/1000;
Expend45Q_Y(Yr) = sum((HMRe,HMRi,StepCCS,TypeCCS),max(0,CCSEmis45q.l(Yr,HMRe,HMRi,StepCCS,TypeCCS))*CCS45QVal(Yr,TypeCCS))/1000;
EmisCaptured_YHM(Yr,HMR,MP) = sum((Sea,TB),Gen.l(Yr,HMR,MP,Sea,TB)*ERoCCS(Yr,HMR,MP))/1000;
EmisCaptured_YH(Yr,HMR) = sum((MP,Sea,TB),Gen.l(Yr,HMR,MP,Sea,TB)*ERoCCS(Yr,HMR,MP))/1000;
EmisStored_YHL(Yr,HMR,StepCCS,TypeCCS) = sum(HMRe,max(0,CCSEmis.l(Yr,HMRe,HMR,StepCCS,TypeCCS)))/1000;
EmisStored_YH(Yr,HMR) = sum((HMRe,StepCCS,TypeCCS),max(0,CCSEmis.l(Yr,HMRe,HMR,StepCCS,TypeCCS)))/1000;
EmisTrans_YHH(Yr,HMRe,HMRi) = sum((StepCCS,TypeCCS),max(0,CCSEmis.l(Yr,HMRe,HMRi,StepCCS,TypeCCS)))/1000;

** Calibration ---------------------------------------------------
CalRGGIHaiku(Yr,HMRRGGICal,Fuel)=sum((HMRMP(HMRRGGICal,MP),Sea,TB),Gen.L(Yr,HMRRGGICal,MP,Sea,TB)$MPFuel(MP,Fuel))/1E3;
CalRGGIAEO(Yr,HMRRGGICal,Fuel)=sum(Sea,GenAEOSeaFuel(Yr,HMRRGGICal,Sea,Fuel))/1E3;
CalEmisRGGIHaiku(Yr)=sum((HMRRGGICal,MP,Sea,TB),Gen.l(Yr,HMRRGGICal,MP,Sea,TB)*ERo(Yr,HMRRGGICal,MP,'CO2')*HMRMP(HMRRGGICal,MP))/1E3;
CalEmisRGGIAEO(Yr)=sum((HMRRGGICal,Fuel),EmisAEO(Yr,HMRRGGICal,Fuel,'CO2'));

** Check Against AEO  (mostly for calibration) ---------------------------------------------------------
Chk_Gen(Yr,HMR,Fuel) = sum(Sea,GenAEOSeaFuel(Yr,HMR,Sea,Fuel)) - sum((HMRMP(HMR,MP),Sea,TB),Gen.l(Yr,HMR,MP,Sea,TB)$MPFuel(MP,Fuel))/1E3;
Chk_Emis(Yr) = sum((HMR,Fuel),EmisAEO(Yr,HMR,Fuel,'CO2'))*1E3 - sum((HMRMP(HMR,MP),Sea,TB),Gen.l(Yr,HMR,MP,Sea,TB)*ERo(Yr,HMR,MP,'CO2'))/1E3;
Chk_Emis_RGGI(Yr) = sum((HMRRGGICal,Fuel),EmisAEO(Yr,HMRRGGICal,Fuel,'CO2'))*1E3 - sum((HMRMP(HMRRGGICal,MP),Sea,TB),Gen.l(Yr,HMRRGGICal,MP,Sea,TB)*ERo(Yr,HMRRGGICal,MP,'CO2'))/1E3;


*Create gdx, convert to xlsx. For some unknown reason, the freezeheader and sorttoc settings are not working.
*-----------------------------------------------------------------------------------------------------------------------
put dummy;
put_utility 'gdxout' / '%UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen%';
execute_unload
** Mappings ---------------------------------------------------
        Yr, HMR, MP, Sea, TB, Pol, Fuel, PPAR, RsvRg, MPFuel,
** MP cost and performance characteristics ---------------------------------------------------
        CapCostF, CapCostITC, CapCostOvernight, FOMF, VOMF, HRF, FCoF, ERoF, ERo, FCiRef, ACFGen, ACFRsv, MVCostF
** Variables  ---------------------------------------------------
        NPCap, Gen, Trans, gamma, MCGen, MCCap, lambda,
*       AlwPrcBank, PSPrc, PSReq,
        EPrcRtl, ECons, MCNoDsp, TotCost_YrHMR, EConsStorage, ERevRef,
*        TotCostLP,
        CalEPrcRtl, CalEPrcRtl2, CalEDemCoeff, CalGen, CalGenTot, CalEmis, CalEmisRGGI,
** LP Variables  ---------------------------------------------------
        TotCostLP, TotCost_YrHMR, Obj, ObjInt,
        NPCapEQ, SupDemEq, RsvMrgEq, GenLeCapEq, NoDspEq,
        CalGenEq, CalGenEq2, CalGenTotEq, CalEmisEq, CalEmisRGGIEq,
        CapHMRGrowthEq, CapNatGrowthEq,
        VehStockEq, VehStockCompEq, VehSalesCompEq, VehClassMTEq, VMTEq, EmisSectEq,
** Capacity ---------------------------------------------------
        NPCapNat, NPCapTot, NPCapNatTot, NPCapFuel, NPCapFuelNat,
        NPCapYHFM, NPCapYPFM,
        NPCapFuelYP_EmisPol, NPCapFuelYPCvr_EmisPol,
        NPCapFuelYP_PS, NPCapFuelYPCvr_PS,
** Generation ---------------------------------------------------
        GenAnn, GenAnnNat, GenTot, GenNat, GenFuel, GenFuelNat,
        GenYHFM, CF_YHFM, GenYPFM, GenYPFMCred_PS, GenYHFS,
        GenFuelYP_EmisPol, GenFuelYPCvr_EmisPol, GenYP_EmisPol, GenYPCvr_EmisPol,
        GenFuelYP_PS, GenFuelYPCvr_PS, GenFuelYPCred_PS, GenYP_PS, GenYPCvr_PS, GenYPCred_PS, GenYHFST, GenYPFST
        GenAEOFuelYH, GenExoYH, GenEndoFuelYH, UtilizationFactor
** Emissions ---------------------------------------------------
        EmisAnn, EmisAnnNat, EmisTot, EmisNat, EmisFuel, EmisFuelNat, EmisCO2Nat, EmisCO2FuelNat,
        EmisYPFM, EmisYPFMCvr_EmisPol,
        EmisFuelYP_EmisPol, EmisFuelYPCvr_EmisPol, EmisYP_EmisPol, EmisYPCvr_EmisPol,
        EmisFuelYP_PS, EmisFuelYPCvr_PS, EmisYP_PS, EmisYPCvr_PS,
        EmisAEOYP, ERFuelPol, EmisYPCvr, EmisAEO, EmisCap, EmisCapNom, ExchangeRate, EnhancedComp, EmisCapAlloc, EmisCapAllocStep
** Electricity Consumption & Price ---------------------------------------------------
        EConsAnn, EConsNat, EConsPPAR,
        EConsYHST, EConsYPST, EConsEVYHST, EConsEVYPST,
        EPrcRtlAnn, EPrcRtlNat, EPrcRtlPPAR, EPrcRtlRGGI11,
        Cons, SeaPctAnn, TBPctSea,
*        VarCOSConsumer, FixCOSConsumer, NonCOSConsumer, VarPolCostConsumer,
*        FixPolCostConsumer, PSCostsConsumer, CalCostConsumer, TransCostConsumer,
** Trade ---------------------------------------------------
        TDLossAnn, TDLossAnnPPAR, NetImportsYP, NetImportsYPS, TransCost, Trans, EffTransCapacity, TransCapacityUtil,
** Policy ---------------------------------------------------
        EmisPolMP, map_EmisPol_YPH, map_EmisPol_YPHM,
        PSMP, map_PS_YPH, map_PS_YPHM, PSCredit,
        PTCMP, map_PTC_YPH, map_PTC_YPHM, PTCredit, PTCHaircut,
        ITCMP, map_ITC_YPH, map_ITC_YPHM, ITCredit, ITCHaircut,
        AlwPrc, AlwPrcRef, AlwPrcBank,
        PSPrc, PSReq, PSReqQty, PSPrcRef, PS_RefER, PTCPrc, ITCPct, PTC_RefER, ITC_RefER,
        ITCCapCost, ACAlw, Allowances, ACAlwPrc, PTCNuke, PlnREPrc, PlnTechPrc,
** Policy Revenues and Costs---------------------------------
         CESTotVal, CESBank, NationalCE
*        CESBankTot, CESConsReqTot,
*        PTCExpendYfP, ITCExpendYfP, CPriceRev,
        ACPprice, ACPquantity.l, EESavings,
**Levelized Costs--------------------------------------------
        LCOE_Ex, LCOE_New,
        LFOM, LCapCo, LVOM, LFCo, LPolCo, LFixCo, LVarCo,
** Resource Costs-------------------------------------------
        FCoExpend, VOMExpend, CCSExpend, FOMExpend, CapCoExpend,
        RCost_FCo,
        RCost_VOM,
        RCost_CCS,
        RCost_FOM,
        RCost_CapCost,
        RCost_Imp,
        RCost_Exp,
** CCS specific outputs ----------------------------------------------------------
        CCS45QVal, ERoCCS, CCSCost, CCSStorMax, CCSStorMaxScaled, CCSEmis,
        CCSEmis45q, CCSEmisNo45q, GenCCS45q, GenCCSNo45q, CCSTrans45qEq, CCSTransNo45qEq, CCSEmisEq, CCSStorEq, CCSGenEq, CCSGen45qEq, CCSGenNo45qEq
        Expend45Q_YHML, Expend45Q_YHL, Expend45Q_YH, Expend45Q_YL, Expend45Q_Y,
        EmisCaptured_YHM, EmisCaptured_YH, EmisStored_YHL, EmisStored_YH,
        EmisTrans_YHH,
** Calibration ---------------------------------------------------
        CalRGGIHaiku, CalRGGIAEO, CalEmisRGGIHaiku, CalEmisRGGIAEO, RsvMrg,
** Check Against AEO  (mostly for calibration) ---------------------------------------------------------
        Chk_Gen, Chk_Emis, Chk_Emis_RGGI,
** Iteration Results -----------------------------------------------------------------------------------
$ifthen.it %UI_ScenKnl% == RtlPrcIt
         EPrcRtl_it, EConsExo_it,
$elseif.it %UI_ScenKnl% == CPrcIt
         AlwPrc_it, Emis_it, AlwPrc_it_desired, boo_it, boo2_it,
$elseif.it %UI_ScenKnl% == CCapIt
         AlwPrc_it, Emis_it,
$endif.it
** Historical info -------------------------------------------------------------------------------------
        NPCapFuelHist, GenFuelHist, EConsExoHist, EmisFuelHist,
** California Project ----------------------------------------------------------
         EmisSect, Bank0, ExpERo, PriceImports, EmisBankStartYr, EmisCapEqBankStep, EmisCapEq, EmisSector0, EmisAbatement, EmisAbatementEq, AbatementPrice, AbatementStepMax,
         LDVEmisTest, VMT0, VMT, MPGe, CO2perMi, GWhperMi, AbatementElasticity, CrossElasticity, VehClass, VehType,
         VMT, MPV, MPV0, Veh, Veh0, VehSales, VehSales0, VehRtr0, PlnVehRtr, ClassWgt, SalesPct
;
putclose;

$exit

$ontext
$onecho > gdx2xls.ini
[settings]
sorttoc=false
freezeheader=1
valueformat=#,###.###
$offecho
execute 'gdx2xls %UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen% @gdx2xls.ini';

$onecho > gdx2access.ini
[settings]
$offecho
*execute 'gdx2access %UI_RootDir%\Output\%UI_Scen%\%UI_vHaiku%_%UI_Scen%.gdx @gdx2access.ini';
$offtext
