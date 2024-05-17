*Calculate retail electricity prices.
$ifthen.calnot %UI_Cal% == Yes
CalEPrcRtl2.L(Yr,HMR,Sea) = 0;
$endif.calnot

EPrcRtl.L(Yr,HMR,Sea)=
*Variable Costs for COS regions
        ( ( ( sum( (HMRMP(HMR,MP),TB),Gen.L(Yr,HMR,MP,Sea,TB)*
                         ( VOM(Yr,HMR,MP)
                         +FCo(Yr,HMR,MP,Sea)$(not sum(Fuel,MPFC(MP,Fuel)))
                         +(FCiRef(Yr,HMR,'Coal')*HR(Yr,HMR,MP)*1E-3)$(MPFC(MP,'Coal') and not (MPNew(MP) and MPCofire(MP)))
                         +(((1-CofirePct(HMR,MP))*FCiRef(Yr,HMR,'Coal') + CofirePct(HMR,MP)*FCiRef(Yr,HMR,'NG')) * HR(Yr,HMR,MP)*1E-3)$(MPFC(MP,'Coal') and (MPNew(MP) and MPCofire(MP)))
                         +(FCiRef(Yr,HMR,'NG')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'NG')
                         +(FCiRef(Yr,HMR,'Oil')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'Oil')
                         +sum(Fuel,CalGen.L(Yr,HMR,Fuel)$(MPFuel(MP,Fuel) and CalGenIncl(Yr,HMR,Fuel)))
                         +CalGenTot.L(Yr,HMR)
                         +CalEmis.L(Yr)*ERo(Yr,HMR,MP,'CO2')
                         +CalEmisRGGI.L(Yr)*ERo(Yr,HMR,MP,'CO2')$HMRRGGICal(HMR)
                         +sum(PPAR,AlwPrc.L(Yr,PPAR)*ERo(Yr,HMR,MP,'CO2')*ExchangeRate(Yr,PPAR,HMR)*EnhancedComp(Yr,PPAR,HMR)$map_EmisPol_YPHM(Yr,PPAR,HMR,MP))
                         +sum(PPAR,AlwPrcBank.L(Yr,PPAR)*ERo(Yr,HMR,MP,'CO2')*ExchangeRate(Yr,PPAR,HMR)*EnhancedComp(Yr,PPAR,HMR)$map_EmisPol_YPHM(Yr,PPAR,HMR,MP))
                         -(sum(PPAR,PSPrc.L(Yr,PPAR)$((not PSPRc.L(Yr,'NatWPS')) and not (PSPRc.l(Yr,'NatSPS')))*PSCredit(Yr,PPAR,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP)))
                         )
                 )
*Transmission Costs for COS regions
             +sum((HMRei(HMRe,HMR),TB),Trans.L(Yr,HMRe,HMR,Sea,TB)*TransCost(HMRe,HMR))
*Fixed O&M Costs for COS regions
             +sum(HMRMP(HMR,MP),NPCap.l(Yr,HMR,MP)*1E3*FOM(Yr,HMR,MP)$(not (MPCofire(MP) and MPNew(MP))))*sum(TB,Hrs(Sea,TB))/HrsAnn
*Capital Costs for COS regions
             +sum(HMRMP(HMR,MP),sum(YrFull,
                                (sum(Yrdup,NPCap.l(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull,Yrdup))
                                  -sum(Yrdup,NPCap.l(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull-1,Yrdup))
                                  )
                                * CapCost(YrFull,HMR,MP)$((not (MPCofire(MP) and MPNew(MP))) and SimYrFull(YrFull)<=SimYr(Yr))
                               )*sum(TB,Hrs(Sea,TB))/HrsAnn
                  )
*Subsidy implicit in capacity constraints
         -sum(HMRMP(HMR,MP),NPCap.l(Yr,HMR,MP)*sum(PPAR,PlnREPrc.l(Yr,PPAR)*map_REtgt_YPHM(Yr,PPAR,HMR,MP)))*sum(TB,Hrs(Sea,TB))/HrsAnn
         -sum(HMRMP(HMR,MP),NPCap.l(Yr,HMR,MP)*sum(Tech,PlnTechPrc.l(Yr,HMR,Tech)*MPTech(MP,Tech)*MPNew(MP)*(HMRMP(HMR,MP)$(TechTgt(Yr,HMR,Tech)<>0))))*sum(TB,Hrs(Sea,TB))/HrsAnn
*CCS storage costs and subsidies
        + sum((HMRi,StepCCS,TypeCCS),CCSEmis.l(Yr,HMR,HMRi,StepCCS,TypeCCS)*(CCSCost(HMR,HMRi,StepCCS,TypeCCS)-CCS45QVal(Yr,TypeCCS)))*sum(TB,Hrs(Sea,TB))/HrsAnn
*Savings from ITC for COS regions
             -sum(HMRMP(HMR,MP),sum(YrFull,
                                (sum(Yrdup,NPCap.l(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull,Yrdup))
                                  -sum(Yrdup,NPCap.l(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull-1,Yrdup))
                                  )
                                * ((betaRt*(CapCostOvernight(YrFull,HMR,MP)*sum(Yrdup,(sum(PPAR,ITCPct(Yrdup,PPAR)*ITCredit(Yrdup,PPAR,HMR,MP)*map_ITC_YPHM(Yrdup,PPAR,HMR,MP)))*SimYrWgtKnl(YrFull,Yrdup)))/(1-(1+betaRt)**(-InvPlnHrzn)))
                                                 $(SimYrFull(YrFull)<=SimYr(Yr) and SimYrFull(YrFull) > SimYr(Yr)-InvPlnHrzn and (sum(Yrdup,sum(PPAR,map_ITC_YPHM(Yrdup,PPAR,HMR,MP)*SimYrWgtKnl(YrFull,Yrdup))))))
                                 )
                 )*sum(TB,Hrs(Sea,TB))/HrsAnn
*Savings from PTC for COS regions
             -sum((YrFull,MP),
                        (sum((Yrdup,Seadup,TB),(NPCap.l(Yrdup,HMR,MP)*ACFGen(Yrdup,HMR,MP,Seadup,TB))*SimYrWgtKnl(YrFull,Yrdup)*OpNPCapRat(HMR,MP,Seadup)*Hrs(Seadup,TB))
                          -sum((Yrdup,Seadup,TB),(NPCap.l(Yrdup,HMR,MP)*ACFGen(Yrdup,HMR,MP,Seadup,TB))*SimYrWgtKnl(YrFull-1,Yrdup)*OpNPCapRat(HMR,MP,Seadup)*Hrs(Seadup,TB))
                          )
                        *sum((Yrdup,PPAR),SimYrWgtKnl(YrFull,Yrdup)
                                *(PTCPrc(Yrdup,PPAR)*PTCredit(Yrdup,PPAR,HMR,MP)$map_PTC_YPHM(Yrdup,PPAR,HMR,MP))
                                 )$(SimYrFull(YrFull)<=SimYr(Yr) and SimYrFull(YrFull) > SimYr(Yr)-TCWindow)
                  )*sum(TB,Hrs(Sea,TB))/HrsAnn
             )
             $HMRCOS(HMR)
*Wholesale Power Prices for non-COS regions
          +( sum(TB,SupDemEq.M(Yr,HMR,Sea,TB)*ECons.l(Yr,HMR,Sea,TB))

*Capacity Market Costs for non-COS regions
*          +sum(TB,sum(map_RsvRg(HMR,RsvRg),RsvMrgEq.M(Yr,RsvRg,Sea,TB)*(1+RsvMrg(Yr,RsvRg)))*ECons.l(Yr,HMR,Sea,TB)/Hrs(Sea,TB))  )
          +(sum((Seadup,TB),sum(map_RsvRg(HMR,RsvRg),RsvMrgEq.M(Yr,RsvRg,Seadup,TB)*(1+RsvMrg(Yr,RsvRg)))*ECons.l(Yr,HMR,Seadup,TB)/Hrs(Seadup,TB)))*(sum(TB,Hrs(Sea,TB))/HrsAnn)  )
          $(not HMRCOS(HMR))
*Import Costs/Export Revenues
         +sum((HMRe,TB),Trans.l(Yr,HMRe,HMR,Sea,TB)*((SupDemEq.M(Yr,HMRe,Sea,TB)+SupDemEq.M(Yr,HMR,Sea,TB))/2))$HMRCOS(HMR)
         -sum((HMRi,TB),Trans.l(Yr,HMR,HMRi,Sea,TB)*((SupDemEq.M(Yr,HMR,Sea,TB)+SupDemEq.M(Yr,HMRi,Sea,TB))/2))$HMRCOS(HMR)
*REC Costs
          +sum((map_PS_YPH(Yr,PPAR,HMR),TB),ECons.l(Yr,HMR,Sea,TB)*PSReq.L(Yr,PPAR)*PSPrc.L(Yr,PPAR))
*Subsidy implicit in capacity constraints
          +sum(HMRMP(HMR,MP),NPCap.l(Yr,HMR,MP)*sum(PPAR,PlnREPrc.l(Yr,PPAR)*map_REtgt_YPHM(Yr,PPAR,HMR,MP)))*sum(TB,Hrs(Sea,TB))/HrsAnn
          +sum(HMRMP(HMR,MP),NPCap.l(Yr,HMR,MP)*sum(Tech,PlnTechPrc.l(Yr,HMR,Tech)*MPTech(MP,Tech)*MPNew(MP)*(HMRMP(HMR,MP)$(TechTgt(Yr,HMR,Tech)<>0))))*sum(TB,Hrs(Sea,TB))/HrsAnn
          )
        /sum(TB,ECons.l(Yr,HMR,Sea,TB)))
*Retail Price Calibrator, intended to represent missing T&D costs + missing capital costs
        + CalEPrcRtl.L(Yr,HMR,Sea)
        + CalEPrcRtl2.L(Yr,HMR,Sea);

*For calibration, calcluate the electricity price calibrator and reset prices to reference levels.
$ifthen.cal %UI_Cal% == Yes
        CalEPrcRtl.L(Yr,HMR,Sea)=sum(TB,ERevRef(Yr,HMR,Sea,TB))*1E3/sum(TB,ECons.l(Yr,HMR,Sea,TB))-EPrcRtl.L(Yr,HMR,Sea);
        EPrcRtl.L(Yr,HMR,Sea)=sum(TB,ERevRef(Yr,HMR,Sea,TB))*1E3/sum(TB,ECons.l(Yr,HMR,Sea,TB));
        CalEPrcRtl2.L(Yr,HMR,Sea) = (AEOEPrcNat(Yr)
                                         - (sum((HMRdup,Seadup),EPrcRtl.L(Yr,HMRdup,Seadup)*sum(TB,ECons.l(Yr,HMRdup,Seadup,TB)) )/ sum((HMRdup,Seadup,TB),ECons.l(Yr,HMRdup,Seadup,TB)))
                                    )*
                                    (EPrcRtl.L(Yr,HMR,Sea)/(sum((HMRdup,Seadup),EPrcRtl.L(Yr,HMRdup,Seadup)*sum(TB,ECons.l(Yr,HMRdup,Seadup,TB)) )/ sum((HMRdup,Seadup,TB),ECons.l(Yr,HMRdup,Seadup,TB))))
$endif.cal

