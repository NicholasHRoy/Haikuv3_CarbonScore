**-------------------------------------------------------------------------------------------------------------

*===============================Cost Equations==================================
* Electricity supply LP
Obj..
        TotCostLP =e= sum((Yr,HMR),SimYrWgt(Yr)*TotCost_YrHMR(Yr,HMR));

*Intermediate Objective Function (HMR level cost equation)
ObjInt(Yr,HMR)..
        TotCost_YrHMR(Yr,HMR) =e=
**Variable Costs
        sum((HMRMP(HMR,MP),Sea,TB), Gen(Yr,HMR,MP,Sea,TB)*
                ( VOM(Yr,HMR,MP)
                +FCo(Yr,HMR,MP,Sea)$(not sum(Fuel,MPFC(MP,Fuel)))
                +(FCiRef(Yr,HMR,'Coal')*HR(Yr,HMR,MP)*1E-3)$(MPFC(MP,'Coal') and not (MPNew(MP) and MPCofire(MP)))
                +(((1-CofirePct(HMR,MP))*FCiRef(Yr,HMR,'Coal') + CofirePct(HMR,MP)*FCiRef(Yr,HMR,'NG')) * HR(Yr,HMR,MP)*1E-3)$(MPFC(MP,'Coal') and (MPNew(MP) and MPCofire(MP)))
                +(FCiRef(Yr,HMR,'NG')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'NG')
                +(FCiRef(Yr,HMR,'Oil')*HR(Yr,HMR,MP)*1E-3)$MPFC(MP,'Oil')
                +sum(Fuel,CalGen.L(Yr,HMR,Fuel)$(MPFuel(MP,Fuel) and CalGenIncl(Yr,HMR,Fuel)))
                +CalGenTot.L(Yr,HMR)$(HMRMP(HMR,MP) and (not MPFuel(MP,'Storage')))
                +CalEmis.L(Yr)*ERo(Yr,HMR,MP,'CO2')
                +CalEmisRGGI.L(Yr)*ERo(Yr,HMR,MP,'CO2')$HMRRGGICal(HMR)
                +sum(PPAR,AlwPrc.L(Yr,PPAR)*ExchangeRate(Yr,PPAR,HMR)*EnhancedComp(Yr,PPAR,HMR)*map_EmisPol_YPHM(Yr,PPAR,HMR,MP))*ERo(Yr,HMR,MP,'CO2')
                +sum(PPAR,AlwPrcBank.L(Yr,PPAR)*ExchangeRate(Yr,PPAR,HMR)*EnhancedComp(Yr,PPAR,HMR)*map_EmisPol_YPHM(Yr,PPAR,HMR,MP))*ERo(Yr,HMR,MP,'CO2')
                -sum(PPAR,PSPrc.l(Yr,PPAR)*PSCredit(Yr,PPAR,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP))
                )
        )
*Pricing non-sector emissions
        +sum((PPAR,Sector),(AlwPrc.L(Yr,PPAR)*ExchangeRate(Yr,PPAR,HMR)*map_EmisPol_YPH(Yr,PPAR,HMR)*EmisSect(Yr,HMR,Sector)))
        +sum((PPAR,Sector),(AlwPrcBank.L(Yr,PPAR)*ExchangeRate(Yr,PPAR,HMR)*EnhancedComp(Yr,PPAR,HMR)*map_EmisPol_YPH(Yr,PPAR,HMR)*EmisSect(Yr,HMR,Sector)))
        +sum((Sector,stepAbate),EmisAbatement(Yr,HMR,Sector,stepAbate) * AbatementPrice(Yr,HMR,Sector,stepAbate))
        +sum((PPAR,step),ACAlw(Yr,PPAR,HMR,step)*ACAlwPrc(Yr,PPAR,step)*map_EmisPol_YPH(Yr,PPAR,HMR))
        +sum(PPAR,sum((HMRe,HMRi,Sea,TB),Trans(Yr,HMRe,HMRi,Sea,TB)*ExpERo(Yr,HMRe)*ExchangeRate(Yr,PPAR,HMR)*EnhancedComp(Yr,PPAR,HMR)*map_EmisPol_YPH(Yr,PPAR,HMRi)*PriceImports(PPAR)*AlwPrc.L(Yr,PPAR))*map_EmisPol_YPH(Yr,PPAR,HMR))
        +sum(PPAR,sum((HMRe,HMRi,Sea,TB),Trans(Yr,HMRe,HMRi,Sea,TB)*ExpERo(Yr,HMRe)*ExchangeRate(Yr,PPAR,HMR)*EnhancedComp(Yr,PPAR,HMR)*map_EmisPol_YPH(Yr,PPAR,HMRi)*PriceImports(PPAR)*AlwPrcBank.L(Yr,PPAR))*map_EmisPol_YPH(Yr,PPAR,HMR))
        +sum(PPAR,ACPquantity(Yr,PPAR,HMR)*ACPprice(Yr,PPAR,HMR)*map_PS_YPH(Yr,PPAR,HMR))
**O&M Costs (fixed cost)
*        +sum(HMRMP(HMR,MP),NPCap(Yr,HMR,MP)*1E3*FOM(Yr,HMR,MP)$(not (MPCofire(MP) and MPNew(MP))))
        +sum(HMRMP(HMR,MP),NPCap(Yr,HMR,MP)*1E3*FOM(Yr,HMR,MP))
**Capacity Costs (fixed cost)
        +sum(HMRMP(HMR,MP),sum(YrFull,
                                (sum(Yrdup,NPCap(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull,Yrdup))
                                  -sum(Yrdup,NPCap(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull-1,Yrdup))
                                  )
                                * CapCost(YrFull,HMR,MP)$(SimYrFull(YrFull)<=SimYr(Yr))
                               )
             )
**CCS storage costs and subsidies
        + sum((HMRi,StepCCS,TypeCCS),CCSEmis45q(Yr,HMR,HMRi,StepCCS,TypeCCS)*(CCSCost(HMR,HMRi,StepCCS,TypeCCS)-CCS45QVal(Yr,TypeCCS)))
        + sum((HMRi,StepCCS,TypeCCS),CCSEmisNo45q(Yr,HMR,HMRi,StepCCS,TypeCCS)*(CCSCost(HMR,HMRi,StepCCS,TypeCCS)))
**ITC subsidies (fixed cost)
        -sum((YrFull,MP),(
                                (sum(Yrdup,NPCap(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull,Yrdup))
                                  -sum(Yrdup,NPCap(Yrdup,HMR,MP)*1E3*SimYrWgtKnl(YrFull-1,Yrdup))
                                  )
                                * CapCost(YrFull,HMR,MP)$(SimYrFull(YrFull)<=SimYr(Yr))
                                *sum(Yrdup,SimYrWgtKnl(YrFull,Yrdup)
                                            *sum(PPAR,(ITCPct(Yrdup,PPAR)*ITCredit(Yrdup,PPAR,HMR,MP)*map_ITC_YPHM(Yrdup,PPAR,HMR,MP)*(InvPlnHrzn/(max(InvPlnHrzn,SimYrLast - SimYrFull(YrFull)))))))
                                * sum(PPAR,ITCHaircut(YrFull,PPAR)
                                            *sum(Yrdup,SimYrWgtKnl(YrFull,Yrdup)*map_ITC_YPHM(Yrdup,PPAR,HMR,MP)))
                         )
             )
**PTC subsidies (represented as a fixed cost)
        -sum((YrFull,MP),(
                                (sum((Yrdup,Sea,TB),(NPCap(Yrdup,HMR,MP)*ACFGen(Yrdup,HMR,MP,Sea,TB))*SimYrWgtKnl(YrFull,Yrdup)*OpNPCapRat(HMR,MP,Sea)*Hrs(Sea,TB))
                                  -sum((Yrdup,Sea,TB),(NPCap(Yrdup,HMR,MP)*ACFGen(Yrdup,HMR,MP,Sea,TB))*SimYrWgtKnl(YrFull-1,Yrdup)*OpNPCapRat(HMR,MP,Sea)*Hrs(Sea,TB))
                                  )
                                *sum((Yrdup,PPAR),SimYrWgtKnl(YrFull,Yrdup)
                                        *(PTCPrc(Yrdup,PPAR)*PTCredit(Yrdup,PPAR,HMR,MP)*map_PTC_YPHM(Yrdup,PPAR,HMR,MP)*(TCWindow/(max(InvPlnHrzn,SimYrLast - SimYrFull(YrFull)))))
                                     )$(SimYrFull(YrFull)<=SimYr(Yr))
                                * sum(PPAR,PTCHaircut(YrFull,PPAR)
                                         *sum(Yrdup,SimYrWgtKnl(YrFull,Yrdup)*map_PTC_YPHM(Yrdup,PPAR,HMR,MP)))
                         )
             )
**Transmissions Costs
        +sum((Sea,TB,HMRei(HMRe,HMR)),Trans(Yr,HMRe,HMR,Sea,TB)*TransCost(HMRe,HMR));


*Supply and Demand Equation (Wholesale Power Price)
SupDemEq(Yr,HMR,Sea,TB).. SimYrWgt(Yr)* (
        sum(HMRMP(HMR,MP),Gen(Yr,HMR,MP,Sea,TB))
        +sum(HMRei(HMRe,HMR),Trans(Yr,HMRe,HMR,Sea,TB))-sum(HMRei(HMR,HMRi),Trans(Yr,HMR,HMRi,Sea,TB))
        +NetFrgnImpCHP(Yr,HMR,Sea,TB)
*        -(((EConsEVExo(Yr,HMR,Sea,TB) + EConsOtherExo(Yr,HMR,Sea,TB)) + sum(MP,EConsStorage(Yr,HMR,MP,Sea,TB)*MPFuel(MP,'Storage')))/(1-TDLoss(Yr,Sea)))
        -((sum(Sector,ConsST(Yr,HMR,Sector,Sea,TB)) + sum(MP,EConsStorage(Yr,HMR,MP,Sea,TB)*MPFuel(MP,'Storage')))/(1-TDLoss(Yr,Sea))))
        =e= 0;

ConsEq(Yr,HMR,Sector)..
         Cons(Yr,HMR,Sector)
         - Cons0(Yr,HMR,Sector)
         - sum((VehClass,VehType),(GWhperMi(Yr,VehClass,VehType,'%UI_CAScen%') * VMT.l(Yr,HMR,VehClass,VehType))$(not Other(Sector)))
         - sum(stepAbate,EmisAbatement(Yr,HMR,Sector,stepAbate))*ConsPerEmisAbate(Yr,HMR,Sector)
         =e= 0;

ConsSTEq(Yr,HMR,Sector,Sea,TB)..
         ConsST(Yr,HMR,Sector,Sea,TB)
         - (Cons(Yr,HMR,Sector) * SeaPctAnn(Yr,HMR,Sea,Sector) * TBpctSea(Yr,HMR,Sea,TB,Sector))
         =e= 0;

*=====================Capacity and Generation Constraints=======================

*Interyear Capacity Constraint ()
NPCapEq(Yr,HMRMP(HMR,MP))$gamma.up(Yr,HMR,MP).. SimYrWgt(Yr)* (
        ( (NPCap(Yr-1,HMR,MP)+CumPlnInvRtr(Yr,HMR,MP)) - (NPCap(Yr,HMR,MP)+CumPlnInvRtr(Yr-1,HMR,MP)) )$MPEx(MP)
        +( NPCap(Yr,HMR,MP)-NPCap(Yr-1,HMR,MP) )$MPNew(MP) )
        =g= 0;

*Reserve Margin Equation Constraint ()
RsvMrgEq(Yr,RsvRg,Sea,TB).. SimYrWgt(Yr)* (
        sum((HMR,MP), OpNPCapRat(HMR,MP,Sea)*NPCap(Yr,HMR,MP)$map_RsvRg(HMR,RsvRg)*ACFRsv(Yr,HMR,MP,Sea,TB) )
*        sum((HMR,MP), OpNPCapRat(HMR,MP,Sea)*NPCap(Yr,HMR,MP)$map_RsvRg(HMR,RsvRg)*ACFRsv(Yr,HMR,MP,Sea,TB)*HMRMP(HMR,MP) )
        -sum(HMR, sum(Sector,Cons(Yr,HMR,Sector)*SeaPctAnn(Yr,HMR,Sea,Sector)*TBpctSea(Yr,HMR,Sea,TB,Sector))$map_RsvRg(HMR,RsvRg)*(1+RsvMrg(Yr,RsvRg))/Hrs(Sea,TB) )         )
        =g= MCP_RHS('MCP_MCCap',Yr){-1E-12}*SimYrWgt(Yr);

*Generation Constrained by Capacity ()
GenLeCapEq(Yr,HMRMP(HMR,MP),Sea,TB)$(not MPNoDsp(MP)).. SimYrWgt(Yr)* (
        OpNPCapRat(HMR,MP,Sea)*NPCap(Yr,HMR,MP)*ACFGen(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB)
        -Gen(Yr,HMR,MP,Sea,TB) )
        =g= 0;

*Non Dispatchable Equation
NoDspEq(Yr,HMRMP(HMR,MP),Sea,TB)$(MCNoDsp.up(Yr,HMR,MP,Sea,TB) and SimYr(Yr) > %UI_FxGen%).. SimYrWgt(Yr)* ( !! note: MCNoDsp.up=0 <=> not MPNoDsp(MP) or MPNoRtrInv(MP)
        OpNPCapRat(HMR,MP,Sea)*NPCap(Yr,HMR,MP)*ACFGen(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB)
        -Gen(Yr,HMR,MP,Sea,TB) )
        =e= 0;
*        =g= 0;

*Non Dispatchable Equation
NoDspEq2(Yr,HMRMP(HMR,MP),Sea,TB)$(HMR_TX(HMR) and (MPFuel(MP,'Solar') or MPFuel(MP,'Wind')) and SimYr(Yr) > %UI_FxGen%).. SimYrWgt(Yr)* ( !! note: MCNoDsp.up=0 <=> not MPNoDsp(MP) or MPNoRtrInv(MP)
        OpNPCapRat(HMR,MP,Sea)*NPCap(Yr,HMR,MP)*ACFGen(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB)
        -Gen(Yr,HMR,MP,Sea,TB) )
        =g= 0;


*============================Storage Equations==================================
*Storage Constraint: Storage Facilities must consume as much as they generate each season
StorageBalanceEq(Yr,HMR,MP,Sea)$MPFuel(MP,'Storage')..
        (sum(TB,EConsStorage(Yr,HMR,MP,Sea,TB))*StorageEff(HMR,MP))
        -sum(TB,Gen(Yr,HMR,MP,Sea,TB))
        =e= 0;

*Storage Constraint: Storage Facilities cannot consume more energy than their power capacity allows
StorageConsEq(Yr,HMR,MP,Sea,TB)$MPFuel(MP,'Storage')..
        OpNPCapRat(HMR,MP,Sea)*NPCap(Yr,HMR,MP)*ACFGen(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB)
        -EConsStorage(Yr,HMR,MP,Sea,TB)
        =g= 0;

*Constrain seasonal generation for VA pumped Hydro
VAStorageEq(Yr,Sea)..
         VAStorageMax(Sea)
         - Sum(TB,Gen(Yr,'VA','Ex Pumped Storage',Sea,TB))
         =g= 0;

StorageCycleEq(Yr,Sea,HMR,MP)$MPFuel(MP,'Storage')..
        NPCap(Yr,HMR,MP)*StorageDuration(HMR,MP)*(sum(TB,Hrs(Sea,TB))/24)
         - Sum(TB,Gen(Yr,HMR,MP,Sea,TB))
         =g= 0;


*============================Cofiring Equations=================================

*Coal-NG cofiring equation
FossilRetrofitEq(Yr,HMR,Fuel,Tech,Eff)..
             sum(MP,NPCap0(HMR,MP)*MPReplaceable(MP)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*(not MPNew(MP))*MPEff(MP,Eff)*HMRMP(HMR,MP))
             + sum(MP,CumPlnInvRtr(Yr,HMR,MP)*MPReplaceable(MP)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*(not MPNew(MP))*MPEff(MP,Eff)*HMRMP(HMR,MP))
             - sum(MP,NPCap(Yr,HMR,MP)*(1/(1-NPCapPenalty(HMR,MP)))*MPReplaceable(MP)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*MPNew(MP)*MPEff(MP,Eff)*HMRMP(HMR,MP))
             - sum(MP,NPCap(Yr,HMR,MP)*MPReplaceable(MP)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*(not MPNew(MP))*MPEff(MP,Eff)*HMRMP(HMR,MP))
*             sum(YrFull,
*              (sum(MP,sum(Yrdup,NPCap(Yrdup,HMR,MP)*(1/(1-NPCapPenalty(HMR,MP)))*MPReplaceable(MP)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*MPNew(MP)*MPEff(MP,Eff)*HMRMP(HMR,MP)*SimYrWgtKnl(YrFull-1,Yrdup)))
*               + sum(MP,sum(Yrdup,NPCap(Yrdup,HMR,MP)*MPReplaceable(MP)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*(not MPNew(MP))*MPEff(MP,Eff)*HMRMP(HMR,MP)*SimYrWgtKnl(YrFull-1,Yrdup)))
*               + sum(MP,sum(Yrdup,CumPlnInvRtr(Yrdup,HMR,MP)*MPReplaceable(MP)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*(not MPNew(MP))*MPEff(MP,Eff)*HMRMP(HMR,MP)*SimYrWgtKnl(YrFull,Yrdup)))
*               - sum(MP,sum(Yrdup,NPCap(Yrdup,HMR,MP)*(1/(1-NPCapPenalty(HMR,MP)))*MPReplaceable(MP)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*MPNew(MP)*MPEff(MP,Eff)*HMRMP(HMR,MP)*SimYrWgtKnl(YrFull,Yrdup)))
*               - sum(MP,sum(Yrdup,NPCap(Yrdup,HMR,MP)*MPReplaceable(MP)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*(not MPNew(MP))*MPEff(MP,Eff)*HMRMP(HMR,MP)*SimYrWgtKnl(YrFull,Yrdup)))
*               - sum(MP,sum(Yrdup,CumPlnInvRtr(Yrdup,HMR,MP)*MPReplaceable(MP)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*(not MPNew(MP))*MPEff(MP,Eff)*HMRMP(HMR,MP)*SimYrWgtKnl(YrFull-1,Yrdup)))
*              )$(SimYrFull(YrFull)=SimYr(Yr)))
             =g= 0;

*require coal plants to meet the efficiency requirement on a seasonal basis
CofireRateEq(Yr,HMR,Eff,Sea,TB)$(SimYr(Yr)>%UI_FxCap%)..
         sum(MP,Gen(Yr,HMR,MP,Sea,TB)*ERo(Yr,HMR,MP,'CO2')*MPCofire(MP)*MPEff(MP,Eff))
         - (ERoCofire(Yr,HMR,Eff)
                 * sum(MP,Gen(Yr,HMR,MP,Sea,TB)*MPCofire(MP)*MPEff(MP,Eff))
            )
         =l= 0;
*require coal plants to meet the efficiency requirement on an annual basis
CofireRateAnnEq(Yr,HMR,Eff)$(SimYr(Yr)>%UI_FxCap%)..
         sum((Sea,TB),sum(MP,Gen(Yr,HMR,MP,Sea,TB)*ERo(Yr,HMR,MP,'CO2')*MPCofire(MP)*MPEff(MP,Eff)))
         - (ERoCofire(Yr,HMR,Eff)
                 * sum((Sea,TB),sum(MP,Gen(Yr,HMR,MP,Sea,TB)*MPCofire(MP)*MPEff(MP,Eff)))
           )
         =l= 0;

*Endogenous Emissions Cap Constraint for mass based cofiring rule
CofireEmisCapEq(YrFull,PPAR)$(AlwPrcCofire.up(YrFull,PPAR)>AlwPrcCofire.lo(YrFull,PPAR))..
        sum((Yr,HMR,MP,Sea,TB),Gen(Yr,HMR,MP,Sea,TB)*sum(Eff,ERoCofire(Yr,HMR,Eff)*MPEff(MP,Eff))*MPCofire(MP)*map_CofirePol_YPHM(Yr,PPAR,HMR,MP)*SimYrWgtKnl(YrFull-LookBack,Yr))
        -sum((Yr,HMR,MP,Sea,TB),Gen(Yr,HMR,MP,Sea,TB)*ERo(Yr,HMR,MP,'CO2')*MPCofire(MP)*map_CofirePol_YPHM(Yr,PPAR,HMR,MP)*SimYrWgtKnl(YrFull,Yr))
        =g= 0;

RequireRetrofitEq(Yr,HMR,MP)$(SimYr(Yr)>=RetrofitYr(MP) and HMRMP(HMR,MP) and RetrofitYr(MP)<>0)..
         NPCap(Yr,HMR,MP)
         =e= 0;

*Force coal plants to retire in line with CSAPR Good Neighbor [GW]
CSAPRRetirementEq(Yr,HMR)$(NPCapRetired(Yr,HMR)<>0 and SimYr(Yr)>%UI_FxCap%)..
        max(0,(sum(MP,NPCap0(HMR,MP)$(MPFuel(MP,"Coal") and not MPNoRtrInv(MP)))
        - NPCapRetired(Yr,HMR)))
        - sum(MP,NPCap(Yr,HMR,MP)$(MPFuel(MP,"Coal") and not (MPCCS(MP) and not MPCCSRetrofit(MP)) and not MPNoRtrInv(MP)))
        =g= 0;


*=======================CCS Constraints=========================================

*CO2 captured by CCS plants must be equal to emissions transferred out of state or to instate storage
CCSTrans45qEq(Yr,HMR)..
         sum((MPCCS,Sea,TB),GenCCS45q(Yr,HMR,MPCCS,Sea,TB)*ERoCCS(Yr,HMR,MPCCS))
         - sum((HMRi,StepCCS,TypeCCS),CCSEmis45q(Yr,HMR,HMRi,StepCCS,TypeCCS))
         =e= 0;

CCSTransNo45qEq(Yr,HMR)..
         sum((MPCCS,Sea,TB),GenCCSno45q(Yr,HMR,MPCCS,Sea,TB)*ERoCCS(Yr,HMR,MPCCS))
         - sum((HMRi,StepCCS,TypeCCS),CCSEmisNo45q(Yr,HMR,HMRi,StepCCS,TypeCCS))
         =e= 0;

CCSEmisEq(Yr,HMR,HMRi,StepCCS,TypeCCS)..
         CCSEmis(Yr,HMR,HMRi,StepCCS,TypeCCS)
         - CCSEmis45q(Yr,HMR,HMRi,StepCCS,TypeCCS)
         - CCSEmisNo45q(Yr,HMR,HMRi,StepCCS,TypeCCS)
         =e= 0;

*CO2 storage at each price step cannot exceed annual maximum
CCSStorEq(Yr,HMR,StepCCS,TypeCCS)..
         CCSStorMaxScaled(Yr,HMR,StepCCS,TypeCCS)/1000
         -sum(HMRe,CCSEmis45q(Yr,HMRe,HMR,StepCCS,TypeCCS))
         -sum(HMRe,CCSEmisNo45q(Yr,HMRe,HMR,StepCCS,TypeCCS))
         =g= 0;

*Identify generation from CCS plants built more or less than 12 years ago
CCSGenEq(Yr,HMR,MPCCS,Sea,TB)..
       Gen(Yr,HMR,MPCCS,Sea,TB)
       - GenCCS45q(Yr,HMR,MPCCS,Sea,TB)
       - GenCCSno45q(Yr,HMR,MPCCS,Sea,TB)
       =e= 0;

CCSGen45qEq(Yr,HMR,MPCCS,Sea,TB)..
       sum(YrFull,
               (sum(Yrdup,(NPCap(Yrdup,HMR,MPCCS)*OpNPCapRat(HMR,MPCCS,Sea)*ACFGen(Yrdup,HMR,MPCCS,Sea,TB)*Hrs(Sea,TB))*SimYrWgtKnl(YrFull,Yrdup))
                - sum(Yrdup,(NPCap(Yrdup,HMR,MPCCS)*OpNPCapRat(HMR,MPCCS,Sea)*ACFGen(Yrdup,HMR,MPCCS,Sea,TB)*Hrs(Sea,TB))*SimYrWgtKnl(YrFull-TCWindow45Q,Yrdup))
                - (sum(Yrdup,(NPCap(Yrdup,HMR,MPCCS)*OpNPCapRat(HMR,MPCCS,Sea)*ACFGen(Yrdup,HMR,MPCCS,Sea,TB)*Hrs(Sea,TB))*SimYrWgtKnl(YrFull,Yrdup))
                   - sum(YrFulldup,sum(Yrdup,(NPCap(Yrdup,HMR,MPCCS)*OpNPCapRat(HMR,MPCCS,Sea)*ACFGen(Yrdup,HMR,MPCCS,Sea,TB)*Hrs(Sea,TB))*SimYrWgtKnl(YrFulldup,Yrdup))$(SimYrFull(YrFulldup) = 2032 + CnstLagCCS(MPCCS)))
                   )$(SimYrFull(YrFull) >= 2032 + CnstLagCCS(MPCCS))
                - sum(Yrdup,GenCCS45q(Yrdup,HMR,MPCCS,Sea,TB)*SimYrWgtKnl(YrFull,Yrdup))
               )$(SimYrFull(YrFull) = SimYr(Yr))
          )
       =g= 0;

CCSGenNo45qEq(Yr,HMR,MPCCS,Sea,TB)..
       sum(YrFull,
                (sum(Yrdup,(NPCap(Yrdup,HMR,MPCCS)*OpNPCapRat(HMR,MPCCS,Sea)*ACFGen(Yrdup,HMR,MPCCS,Sea,TB)*Hrs(Sea,TB))*SimYrWgtKnl(YrFull-TCWindow45Q,Yrdup))
                 +(sum(Yrdup,(NPCap(Yrdup,HMR,MPCCS)*OpNPCapRat(HMR,MPCCS,Sea)*ACFGen(Yrdup,HMR,MPCCS,Sea,TB)*Hrs(Sea,TB))*SimYrWgtKnl(YrFull,Yrdup))
                   - sum(YrFulldup,sum(Yrdup,(NPCap(Yrdup,HMR,MPCCS)*OpNPCapRat(HMR,MPCCS,Sea)*ACFGen(Yrdup,HMR,MPCCS,Sea,TB)*Hrs(Sea,TB))*SimYrWgtKnl(YrFulldup,Yrdup))$(SimYrFull(YrFulldup)= 2032 + CnstLagCCS(MPCCS)))
                   )$(SimYrFull(YrFull) >= 2032 + CnstLagCCS(MPCCS))
                 - sum(Yrdup,GenCCSno45q(Yrdup,HMR,MPCCS,Sea,TB)*SimYrWgtKnl(YrFull,Yrdup))
                )$(SimYrFull(YrFull) = SimYr(Yr))
          )
       =g= 0;

*set maximum capacity for CCS
CCSCap(Yr,MP)$(MPCCS(MP) and  CCSCapMax(Yr,MP) <>0)..
         CCSCapMax(Yr,MP)
         -sum(HMR,NPCap(Yr,HMR,MP))
         =g=0;

*=======================Timeblock Specific Constraints==========================

*Peak Constraints
PeakDayEq(Yr,HMR,MP,Sea)$(not (MPNoDsp(MP) or MPFuel(MP,'Oil') or MPTech(MP,'CT')))..
        Gen(Yr,HMR,MP,Sea,'4')/Hrs(Sea,'4') =e= Gen(Yr,HMR,MP,Sea,'3')/Hrs(Sea,'3');

PeakNightEq(Yr,HMR,MP,Sea)$(not (MPNoDsp(MP) or MPFuel(MP,'Oil') or MPTech(MP,'CT')))..
        Gen(Yr,HMR,MP,Sea,'8')/Hrs(Sea,'8') =e= Gen(Yr,HMR,MP,Sea,'7')/Hrs(Sea,'7');

PeakDayEq2(Yr,HMR,MP,Sea,DayPeak)$(MPFuel(MP,'NG') and MPTech(MP,'CC'))..
        Gen(Yr,HMR,MP,Sea,'2')/Hrs(Sea,'2')
        -Gen(Yr,HMR,MP,Sea,DayPeak)/Hrs(Sea,DayPeak)
        =e= 0;

PeakNightEq2(Yr,HMR,MP,Sea,NightPeak)$(MPFuel(MP,'NG') and MPTech(MP,'CC'))..
        Gen(Yr,HMR,MP,Sea,'6')/Hrs(Sea,'6')
        -Gen(Yr,HMR,MP,Sea,NightPeak)/Hrs(Sea,NightPeak)
        =e= 0;

*       Baseload Constraint
BaseLoadEq(Yr,HMR,MP,Sea,TB)$MPBaseLoad(MP)..
        Gen(Yr,HMR,MP,Sea,TB)/Hrs(Sea,TB)
        - Gen(Yr,HMR,MP,Sea,'1')/Hrs(Sea,'1')
        =e= 0;



*====================Emissions Cap Allowance Constraints========================

** Annual Emissions Cap
EmisCapEq(Yr,PPAR,step)$(AlwPrc.up(Yr,PPAR)>AlwPrc.lo(Yr,PPAR))..    SimYrWgt(Yr)*(
        sum(HMR,EmisCapAllocStep(Yr,PPAR,HMR,step)*ExchangeRate(Yr,PPAR,HMR)*map_EmisPol_YPH(Yr,PPAR,HMR)*1E3)
        + sum(stepdup,sum(HMR,ACAlw(Yr,PPAR,HMR,stepdup)*map_EmisPol_YPH(Yr,PPAR,HMR))$(s(stepdup)>=s(step)))
        -sum((HMR,MP,Sea,TB),Gen(Yr,HMR,MP,Sea,TB)*ERo(Yr,HMR,MP,'CO2')*ExchangeRate(Yr,PPAR,HMR)*EnhancedComp(Yr,PPAR,HMR)*map_EmisPol_YPHM(Yr,PPAR,HMR,MP))
        -sum((HMRe,HMRi,Sea,TB),Trans(Yr,HMRe,HMRi,Sea,TB)*ExpERo(Yr,HMRe)*ExchangeRate(Yr,PPAR,HMRi)*EnhancedComp(Yr,PPAR,HMRi)*map_EmisPol_YPH(Yr,PPAR,HMRi)*PriceImports(PPAR))
        -sum((HMR,Sector),EmisSect(Yr,HMR,Sector)*ExchangeRate(Yr,PPAR,HMR)*EnhancedComp(Yr,PPAR,HMR)*map_EmisPol_YPH(Yr,PPAR,HMR))
        )
        =g= 0;

** Emissions Cap w/ Banking
EmisCapEqBank(Yr,PPAR)$( AlwPrcBank.up(Yr,PPAR)> AlwPrcBank.lo(Yr,PPAR) )..
         sum(YrFull,EmisCapNom(YrFull,PPAR)*1E3
                 $(EmisBankStartYr(PPAR) <= SimYrFull(YrFull) and SimYrFull(YrFull) <= SimYr(Yr)) )
         - sum(YrFull,sum(Yrdup,(sum((HMR,MP,Sea,TB),Gen(Yrdup,HMR,MP,Sea,TB)*ERo(Yrdup,HMR,MP,'CO2')*map_EmisPol_YPHM(Yrdup,PPAR,HMR,MP))
                                 +sum((HMRe,HMRi,Sea,TB),Trans(Yr,HMRe,HMRi,Sea,TB)*ExpERo(Yr,HMRe)*map_EmisPol_YPH(Yr,PPAR,HMRi)*PriceImports(PPAR))
                                 +sum((HMR,Sector),EmisSect(Yr,HMR,Sector)*map_EmisPol_YPH(Yr,PPAR,HMR))
                                 )
                         *SimYrWgtKnl(YrFull,Yrdup))
                 $(EmisBankStartYr(PPAR) <= SimYrFull(YrFull) and SimYrFull(YrFull) <= SimYr(Yr)) )
         =g= 0;

EmisCapEqBankStep(Yr,PPAR,step)$( AlwPrcBank.up(Yr,PPAR)> AlwPrcBank.lo(Yr,PPAR) )..
         EmisCap(Yr,PPAR,step)*1E3 + sum(stepdup,sum(HMR,ACAlw(Yr,PPAR,HMR,stepdup)*map_EmisPol_YPH(Yr,PPAR,HMR))$(s(stepdup)>=s(step)))
         + sum(YrFull,sum(Yrdup,sum(stepdup,sum(HMR,ACAlw(Yrdup,PPAR,HMR,stepdup)*map_EmisPol_YPH(Yrdup,PPAR,HMR)))*SimYrWgtKnl(YrFull,Yrdup))
                 $(EmisBankStartYr(PPAR) <= SimYrFull(YrFull) and SimYrFull(YrFull) < SimYr(Yr)) )
         + Bank0(PPAR)*1000
          - sum(YrFull,sum(Yrdup,(sum((HMR,MP,Sea,TB),Gen(Yrdup,HMR,MP,Sea,TB)*ERo(Yrdup,HMR,MP,'CO2')*map_EmisPol_YPHM(Yrdup,PPAR,HMR,MP))
                                     +sum((HMRe,HMRi,Sea,TB),Trans(Yrdup,HMRe,HMRi,Sea,TB)*ExpERo(Yrdup,HMRe)*map_EmisPol_YPH(Yrdup,PPAR,HMRi)*PriceImports(PPAR))
                                     +sum((HMR,Sector),EmisSect(Yrdup,HMR,Sector)*map_EmisPol_YPH(Yrdup,PPAR,HMR))
                                 )
                       *SimYrWgtKnl(YrFull,Yrdup))
                 $(EmisBankStartYr(PPAR) <= SimYrFull(YrFull) and SimYrFull(YrFull) <= SimYr(Yr)) )
         =g=0;

*EmisCapEqStep(Yr,PPAR,step)$( AlwPrcBank.up(Yr,PPAR)> AlwPrcBank.lo(Yr,PPAR) or AlwPrc.up(Yr,PPAR)> AlwPrc.lo(Yr,PPAR) )..
EmisCapEqStep(Yr,PPAR,step)$( AlwPrcBank.up(Yr,PPAR)> AlwPrcBank.lo(Yr,PPAR) )..
           max((EmisCap(Yr,PPAR,step+1)-EmisCap(Yr,PPAR,step)),0)*1E3
            - sum(HMR,ACAlw(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR))
           =g=0;


EmisCapEqBankCeiling(Yr,PPAR)$( AlwPrcBank.up(Yr,PPAR)> AlwPrcBank.lo(Yr,PPAR) )..
$onText
max(smax(step,EmisCap(Yr,PPAR,step)$(ACAlwPrc(Yr,PPAR,step)<>0)),
        (sum((HMR,MP,Sea,TB),Gen(Yr,HMR,MP,Sea,TB)*ERo(Yr,HMR,MP,'CO2')*map_EmisPol_YPHM(Yr,PPAR,HMR,MP))
          +sum((HMRe,HMRi,Sea,TB),Trans(Yr,HMRe,HMRi,Sea,TB)*ExpERo(Yr,HMRe)*map_EmisPol_YPH(Yr,PPAR,HMRi)*PriceImports(PPAR))
          +sum((HMR,Sector),EmisSect(Yr,HMR,Sector)*map_EmisPol_YPH(Yr,PPAR,HMR))
         )
    )
        - sum((HMR,step),ACAlw(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR))
        - sum(YrFull,sum(Yrdup,(sum((HMR,MP,Sea,TB),Gen(Yrdup,HMR,MP,Sea,TB)*ERo(Yrdup,HMR,MP,'CO2')*map_EmisPol_YPHM(Yrdup,PPAR,HMR,MP))
                                 +sum((HMRe,HMRi,Sea,TB),Trans(Yrdup,HMRe,HMRi,Sea,TB)*ExpERo(Yrdup,HMRe)*map_EmisPol_YPH(Yrdup,PPAR,HMRi)*PriceImports(PPAR))
                                 +sum((HMR,Sector),EmisSect(Yrdup,HMR,Sector)*map_EmisPol_YPH(Yrdup,PPAR,HMR))
                                 )
                         *SimYrWgtKnl(YrFull,Yrdup))
                 $(EmisBankStartYr(PPAR) <= SimYrFull(YrFull) and SimYrFull(YrFull) < SimYr(Yr)) )
        + sum(YrFull,sum((Yrdup,HMR,step),ACAlw(Yrdup,PPAR,HMR,step)*map_EmisPol_YPH(Yrdup,PPAR,HMR)*SimYrWgtKnl(YrFull,Yrdup))
                 $(EmisBankStartYr(PPAR) <= SimYrFull(YrFull) and SimYrFull(YrFull) < SimYr(Yr)) )
$offText
          sum((HMR,Sector),EmisSector0(Yr,HMR,Sector)*map_EmisPol_YPH(Yr,PPAR,HMR)) + 50000
         - sum((HMR,step),ACAlw(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR))
         =g= 0;


*====================Transportation Constraints=================================

$ifthen.VMTEq  %UI_CALDV% == Yes
*Vehicle Stock Equation
VehStockEq(Yr,VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)..
         Veh(Yr,'CA',VehClass,VehType)
           - Veh(Yr - 1,'CA',VehClass,VehType)
           - VehSales(Yr,'CA',VehClass,VehType)
           - PlnVehRtr(Yr,'CA',VehClass,VehType)
         =e= 0;

VehStockCompEq(Yr,VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)..
         sum(VehTypedup,Veh(Yr,'CA',VehClass,VehTypedup))*ClassWgt(Yr,VehClass,VehType)
           - Veh(Yr,'CA',VehClass,VehType)
         =e= 0;

VehSalesCompEq(Yr,VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)..
         sum(VehTypedup,VehSales(Yr,'CA',VehClass,VehTypedup))*SalesPct(Yr,VehClass,VehType)
           - VehSales(Yr,'CA',VehClass,VehType)
         =e= 0;
*Vehicle Class Travel Demand
VehClassMTEq(Yr,VehClass)$(SimYr(Yr) > %UI_FxGen%)..
         VMTDemand(Yr,'CA',VehClass)
           - sum(VehType,VMT(Yr,'CA',VehClass,VehType))
         =e= 0;

*VMT by vehicle type
VMTEq(Yr,VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)..
         VMT(Yr,'CA',VehClass,VehType)
          - MPV(Yr,'CA',VehClass,VehType)* Veh(Yr,'CA',VehClass,VehType)
         =e= 0;
$endif.VMTEq

*Transportation
*TransEmisEq(Yr,HMR,'EVs')..
*         EmisSect(Yr,HMR,'EVs') =e= sum((VehClass,VehTech,VehFuel),VMT(Yr,VehClass,VehTech,VehFuel)*ERVeh(VehClass,VehTech,VehFuel)/MPGVeh(Yr,VehClass,VehTech,VehFuel))/1000;


EmisSectEq(Yr,HMR,Sector)..
         EmisSect(Yr,HMR,Sector)
*         - EmisSector0(Yr,HMR,Sector)
         - (EmisSector0(Yr,HMR,Sector) - sum(stepAbate,EmisAbatement(Yr,HMR,Sector,stepAbate)))
         - sum((VehClass,VehType),(1000*CO2perMi(Yr,VehClass,VehType,'%UI_CAScen%')*VMT(Yr,HMR,VehClass,VehType))$(not Other(Sector)))
         =e= 0;

EmisAbatementEq(Yr,HMR,Sector,stepAbate)..
         AbatementStepMax(Yr,HMR,Sector,stepAbate)
         -EmisAbatement(Yr,HMR,Sector,stepAbate)
         =g= 0;

*=========================Portfolio Standard Constraints========================

* Portfolio Standard constraints
** Annual Portfolio Standard Constraint
PSEQ(Yr,PPAR)$(PSPrc.up(Yr,PPAR)>PSPrc.lo(Yr,PPAR))..
        SimYrWgt(Yr)*(
        sum((map_PS_YPHM(Yr,PPAR,HMR,MP),Sea,TB),Gen(Yr,HMR,MP,Sea,TB)*PSCredit(Yr,PPAR,HMR,MP))
        + sum(HMR,ACPquantity(Yr,PPAR,HMR)*map_PS_YPH(Yr,PPAR,HMR))
        -sum(map_PS_Sales_YPH(Yr,PPAR,HMR),PSReq.l(Yr,PPAR)*
                 (sum(Sector,Cons(Yr,HMR,Sector)) + sum((Sea,TB,MP),EConsStorage(Yr,HMR,MP,Sea,TB)*(1-StorageEff(HMR,MP)))))
        )
        =g= 0;

** Portfolio Standard constraint w/ banking
PSEQBank(Yr,PPAR)$(PSPrcBank.up(Yr,PPAR) > PSPrcBank.lo(Yr,PPAR))..
         sum(YrFulldup,
                 (sum(Yrdup,(sum((map_PS_YPHM(Yrdup,PPAR,HMR,MP),Sea,TB),Gen(Yr,HMR,MP,Sea,TB)*PSCredit(Yrdup,PPAR,HMR,MP))
                 + sum(HMR,ACPquantity(Yrdup,PPAR,HMR)*map_PS_YPH(Yrdup,PPAR,HMR)))*(SimYrWgtKnl(YrFulldup,Yrdup))$(SimYrFull(YrFulldup) <= SimYr(Yr)))))
         - sum(YrFulldup,
                 (sum(Yrdup,((sum(map_PS_Sales_YPH(Yrdup,PPAR,HMR),PSReq.l(Yrdup,PPAR)*
                 (sum(Sector,Cons(Yr,HMR,Sector)) + sum((MP,Sea,TB),EConsStorage(Yrdup,HMR,MP,Sea,TB)*(1-StorageEff(HMR,MP))))))*(SimYrWgtKnl(YrFulldup,Yrdup))$(SimYrFull(YrFulldup) <= SimYr(Yr)))))           )
         =g= 0;

PlnTechInv(Yr,HMR,Tech)$( TechTgt(Yr,HMR,Tech)>0 and SimYr(Yr) > %UI_FxCap% and SimYr(Yr) >= 2023)..
         sum(MP,(NPCap(Yr,HMR,MP)*MPTech(MP,Tech)*MPNew(MP)))
         -TechTgt(Yr,HMR,Tech)
         =g= 0;


PlnREInv(Yr,PPAR)$( RETgt(Yr,PPAR)>0  and SimYr(Yr) > %UI_FxCap% and SimYr(Yr) >= 2023)..
         sum((HMR,MP),NPCap(Yr,HMR,MP)$(REtgtMP(MP))
         *map_REtgt_YPHM(Yr,PPAR,HMR,MP))
         - RETgt(Yr,PPAR)
         =g= 0;

VAMinCoal(Yr,MP)$(sum(YrFull,VACoalGen(YrFull,MP))<>0 and SimYr(Yr) >= 2021)..
         sum((Sea,TB),Gen(Yr,'VA',MP,Sea,TB)) - VACoalGen(Yr,MP)
         =e=0;

VAMinCoalCap(Yr,MP)$(sum(YrFull,VACoalCap(YrFull,MP))<>0 and SimYr(Yr) >= 2021)..
         NPCap(Yr,'VA',MP) - VACoalCap(Yr,MP)/1000
         =g= 0;


*=======Capacity, Generation, and Transmission Growth/Historical Equations======


*Add Technology Specific Build Lags
FxCapEq(Yr,HMR,MP)$(SimYr(Yr) <= %UI_FxCap% and  NPCapMax(Yr,HMR,MP) < +INF)..
        NPCap(Yr,HMR,MP)
        - NPCapMax(Yr,HMR,MP)
        =e= 0;

*Freeze generaion to levels in reference scenario
FxGenEq(Yr,HMR,MP,Sea,TB)$(SimYr(Yr) <= %UI_FxGen% and GenFx(Yr,HMR,MP,Sea,TB) < +INF )..
        Gen(Yr,HMR,MP,Sea,TB)
        - GenFx(Yr,HMR,MP,Sea,TB)
        =e= 0;


CapHMRGrowthEq2(Yr,HMR)$(SimYr(Yr) >= %UI_GrowCap% )..
         ((1 + %UI_GrowCapPct% )**Max(0,(SimYr(Yr)-2025)))*(
                 max(1.0,(smax((YrFullHist),((NPCapHist(YrFullHist,HMR) - NPCapHist(YrFullHist + 1,HMR))$(SimYrFullHist(YrFullHist) <> SimYrFullHist('Yr-17'))))))
         )
$ifthen.grow %UI_EffCap%== Yes
         - sum(Fuel, smax(MP,(sum((Sea,TB), MPFuel(MP,Fuel)*ACFGen('Yr0',HMR,MP,Sea,TB)$(MPNew(MP) and ACFGen('Yr0',HMR,MP,Sea,TB) > 0 and ACFGen('Yr0',HMR,MP,Sea,TB) < 1 and not MPTech(MP,'Offshore')) * Hrs(Sea,TB))/8760))*
              sum(YrFull,
                 (  sum(MP, (sum(Yrdup,SimYrWgtKnl(YrFull     ,Yrdup)*MPFuel(MP,Fuel)*NPCap(Yrdup,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP))))$(SimYrFull(YrFull) = SimYr(Yr)))
                    -sum(MP, (sum(Yrdup,SimYrWgtKnl(YrFull - 1 ,Yrdup)*MPFuel(MP,Fuel)*NPCap(Yrdup,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP))))$(SimYrFull(YrFull) = SimYr(Yr)))
                    -sum(MP,                                           MPFuel(MP,Fuel)*PlnInvRtr(YrFull,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP)))$(SimYrFull(YrFull) = SimYr(Yr))
                   ) ) )
$else.grow
         -sum(YrFull,
                 (  sum(MP, (sum(Yrdup,SimYrWgtKnl(YrFull     ,Yrdup)*NPCap(Yrdup,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP))))$(SimYrFull(YrFull) = SimYr(Yr)))
                    -sum(MP, (sum(Yrdup,SimYrWgtKnl(YrFull - 1 ,Yrdup)*NPCap(Yrdup,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP))))$(SimYrFull(YrFull) = SimYr(Yr)))
                    -sum(MP,                                          PlnInvRtr(YrFull,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP)))$(SimYrFull(YrFull) = SimYr(Yr))
                   )
         )
$endif.grow
         +sum((MP,Tech),
                 (TechTgt(Yr,HMR,Tech)*MPTech(MP,Tech)*MPNew(MP))
                  -(TechTgt(Yr-1,HMR,Tech)*MPTech(MP,Tech)*MPNew(MP))
         )
         =g= 0;

CapHMRGrowthEq(Yr,HMR,Fuel)$(SimYr(Yr) >= %UI_GrowCap%)..
         (((1+max(0.07,((smax(YrFullHist, ((NPCapHist(YrFullHist,HMR) - NPCapHist(YrFullHist + 1,HMR))
                           / NPCapHist(YrFullHist + 1,HMR))$(NPCapHist(YrFullHist + 1,HMR) <>0 and SimYrFullHist(YrFullHist) <> SimYrFullHist('Yr-17'))
                  ))))
$ifthen.EPRIGrow %UI_EPRIScen% == Low
                 -0.07
$endif.EPRIGrow

                 )**(SimYr(Yr)-%UI_GrowCap% + 1)))*(
                 (smax((YrFullHist),((NPCapHist(YrFullHist,HMR) - NPCapHist(YrFullHist + 1,HMR))$(SimYrFullHist(YrFullHist) <> SimYrFullHist('Yr-17'))))))
         -smax(MP,(sum((Sea,TB), MPFuel(MP,Fuel)*ACFGen('Yr0',HMR,MP,Sea,TB)$(MPNew(MP) and ACFGen('Yr0',HMR,MP,Sea,TB) > 0 and ACFGen('Yr0',HMR,MP,Sea,TB) < 1 and not MPTech(MP,'Offshore')) * Hrs(Sea,TB))/8760))*
         sum(YrFull,
                 (  sum(MP, (sum(Yrdup,SimYrWgtKnl(YrFull     ,Yrdup)*MPFuel(MP,Fuel)*NPCap(Yrdup,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP))))$(SimYrFull(YrFull) = SimYr(Yr)))
                    -sum(MP, (sum(Yrdup,SimYrWgtKnl(YrFull - 1 ,Yrdup)*MPFuel(MP,Fuel)*NPCap(Yrdup,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP))))$(SimYrFull(YrFull) = SimYr(Yr)))
                    -sum(MP,                                           MPFuel(MP,Fuel)*PlnInvRtr(YrFull,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP)))$(SimYrFull(YrFull) = SimYr(Yr))
                   )
         )
         +sum((MP,Tech),
                 (TechTgt(Yr,HMR,Tech)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*MPNew(MP))
                  -(TechTgt(Yr-1,HMR,Tech)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*MPNew(MP))
         )
         =g= 0;

CapNatGrowthEq(Yr,Fuel)$(SimYr(Yr) >= %UI_GrowCap% + 1)..
         sum(YrFull,
                 2*(sum((HMR,MP), (sum(Yrdup,SimYrWgtKnl(YrFull - 1 ,Yrdup)*MPFuel(MP,Fuel)*NPCap(Yrdup,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP) and not MPFuel(MP,'NG') and not MPFuel(MP,'Coal') and not MPFuel(MP,'Storage') )))$(SimYrFull(YrFull) = SimYr(Yr)))
                    -sum((HMR,MP), (sum(Yrdup,SimYrWgtKnl(YrFull - 2 ,Yrdup)*MPFuel(MP,Fuel)*NPCap(Yrdup,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP)and not MPFuel(MP,'NG') and not MPFuel(MP,'Coal') and not MPFuel(MP,'Storage') )))$(SimYrFull(YrFull) = SimYr(Yr)))
                    +sum((HMR,MP),                                           MPFuel(MP,Fuel)*PlnInvRtr(YrFull-1,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP) and not MPFuel(MP,'NG') and not MPFuel(MP,'Coal') and not MPFuel(MP,'Storage') ))$(SimYrFull(YrFull) = SimYr(Yr))
                   )

                 -(  sum((HMR,MP), (sum(Yrdup,SimYrWgtKnl(YrFull     ,Yrdup)*MPFuel(MP,Fuel)*NPCap(Yrdup,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP) and not MPFuel(MP,'NG') and not MPFuel(MP,'Coal') and not MPFuel(MP,'Storage') )))$(SimYrFull(YrFull) = SimYr(Yr)))
                    -sum((HMR,MP), (sum(Yrdup,SimYrWgtKnl(YrFull - 1 ,Yrdup)*MPFuel(MP,Fuel)*NPCap(Yrdup,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP) and not MPFuel(MP,'NG') and not MPFuel(MP,'Coal') and not MPFuel(MP,'Storage') )))$(SimYrFull(YrFull) = SimYr(Yr)))
                    -sum((HMR,MP),                                           MPFuel(MP,Fuel)*PlnInvRtr(YrFull,HMR,MP)$(MPNew(MP)and not MPNoRtrInv(MP) and not MPFuel(MP,'NG') and not MPFuel(MP,'Coal') and not MPFuel(MP,'Storage') ))$(SimYrFull(YrFull) = SimYr(Yr))
                   )
         )
         +sum((HMR,MP,Tech),
                 (TechTgt(Yr,HMR,Tech)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*MPNew(MP))$(not MPFuel(MP,'Coal') and not MPFuel(MP,'Storage') )
                  -(TechTgt(Yr-1,HMR,Tech)*MPFuel(MP,Fuel)*MPTech(MP,Tech)*MPNew(MP))$(not MPFuel(MP,'Coal') and not MPFuel(MP,'Storage') )
         )
         =g= 0;

*Freeze transmission in and out of a PPAR to levels in reference scenario
FxTransEq(Yr,HMRe,HMRi,Sea,TB)$(sum(PPAR,(sum(Yrdup, map_FxTrans_YPH(Yrdup,PPAR,HMRe))
                                                      or sum(Yrdup, map_FxTrans_YPH(Yrdup,PPAR,HMRi)))
                                         and (not (sum(Yrdup, map_FxTrans_YPH(Yrdup,PPAR,HMRe))
                                                              and sum(Yrdup, map_FxTrans_YPH(Yrdup,PPAR,HMRi))))))..
       (Trans(Yr,HMRe,HMRi,Sea,TB)-TransFx(Yr,HMRe,HMRi,Sea,TB))
        =e= 0;


*Use if we want to fix nuclear generation annually
FxGenNukeEq(Yr)$(SimYr(Yr)>= %UI_FxNukeGen% and sum((HMR,MP,Sea,TB),GenNukeFx(Yr,HMR,MP,Sea,TB))< +INF)..
        sum((HMR,MP,Sea,TB),Gen(Yr,HMR,MP,Sea,TB)$(MPFuel(MP,'Nuke')))
        - sum((HMR,MP,Sea,TB),GenNukeFx(Yr,HMR,MP,Sea,TB)$(MPFuel(MP,'Nuke') and GenNukeFx(Yr,HMR,MP,Sea,TB) < +INF))
        =e= 0;


*-------------------------------------------------------------------------------------------------------------
* CALIBRATION
*-------------------------------------------------------------------------------------------------------------
* (1) CalGenFuel:      Generation + Imports - Exports = Consumption/(1-Losses)
* (2) CalEmisEq:       Generation + Imports - Exports = Consumption/(1-Losses)
* (3) CalEmisRGGIEq:   Generation + Imports - Exports = Consumption/(1-Losses)

*CalGen.fx(Yr,HMR,Fuel) = 0;
*CalEmis.fx(Yr) = 0;
*CalEmisRGGI.fx(Yr) = 0;

CalGenEq(CalGenIncl(Yr,HMR,Fuel))$(CalGen.up(Yr,HMR,Fuel)>CalGen.lo(Yr,HMR,Fuel)).. SimYrWgt(Yr)* (
        sum(Sea,GenAEOSeaFuel(Yr,HMR,Sea,Fuel))
        -sum((HMRMP(HMR,MP),Sea,TB),Gen(Yr,HMR,MP,Sea,TB)$MPFuel(MP,Fuel) ) )
        =g= 0;

CalGenEq2(CalGenIncl(Yr,HMR,Fuel))$(CalGen.up(Yr,HMR,Fuel)>CalGen.lo(Yr,HMR,Fuel)).. SimYrWgt(Yr)* (
        sum((HMRMP(HMR,MP),Sea,TB),Gen(Yr,HMR,MP,Sea,TB)$MPFuel(MP,Fuel) )
        -sum(Sea,GenAEOSeaFuel(Yr,HMR,Sea,Fuel))
        )
        =g= 0;

CalGenPPAREq(Yr,PPAR,Fuel)$(CalGenPPAR.up(Yr,PPAR,Fuel)>CalGenPPAR.lo(Yr,PPAR,Fuel)).. SimYrWgt(Yr)* (
        sum(map_CalGen_YPH(Yr,PPAR,HMR),sum((HMRMP(HMR,MP),Sea,TB),Gen(Yr,HMR,MP,Sea,TB)$MPFuel(MP,Fuel)))
        -sum(map_CalGen_YPH(Yr,PPAR,HMR),sum((Sea),GenAEOSeaFuel(Yr,HMR,Sea,Fuel)))
        )
        =e= 0;

CalGenTotEq(Yr,HMR)$(CalGenTot.up(Yr,HMR)>CalGenTot.lo(Yr,HMR)).. SimYrWgt(Yr)* (
          sum((Sea,Fuel),GenAEOSeaFuel(Yr,HMR,Sea,Fuel)$(not FuelStorage(Fuel)))
          -sum((HMRMP(HMR,MP),Sea,TB,Fuel),Gen(Yr,HMR,MP,Sea,TB)$(MPFuel(MP,Fuel) and not MPFuel(MP,'Storage')))
          )
          =g= -sum((Sea,Fuel),GenAEOSeaFuel(Yr,HMR,Sea,Fuel)$(not FuelStorage(Fuel)))*.01;

CalGenTotEq2(Yr,HMR)$(CalGenTot.up(Yr,HMR)>CalGenTot.lo(Yr,HMR)).. SimYrWgt(Yr)* (
          sum((HMRMP(HMR,MP),Sea,TB,Fuel),Gen(Yr,HMR,MP,Sea,TB)$(MPFuel(MP,Fuel) and not MPFuel(MP,'Storage')))
          -sum((Sea,Fuel),GenAEOSeaFuel(Yr,HMR,Sea,Fuel)$(not FuelStorage(Fuel)))
          )
          =g= -sum((Sea,Fuel),GenAEOSeaFuel(Yr,HMR,Sea,Fuel)$(not FuelStorage(Fuel)))*.01;

CalEmisEq(Yr)$(CalEmis.up(Yr)>CalEmis.lo(Yr)).. SimYrWgt(Yr)* (
        sum((HMR,Fuel),EmisAEO(Yr,HMR,Fuel,'CO2'))*1E3
        -sum((HMRMP(HMR,MP),Sea,TB),Gen(Yr,HMR,MP,Sea,TB)*ERo(Yr,HMR,MP,'CO2')) )
         =e= 0;

CalEmisRGGIEq(Yr)$(CalEmisRGGI.up(Yr)>CalEmisRGGI.lo(Yr)).. SimYrWgt(Yr)* (
        sum((HMRRGGICal,Fuel),EmisAEO(Yr,HMRRGGICal,Fuel,'CO2'))*1E3
        -sum((HMRMP(HMRRGGICal,MP),Sea,TB),Gen(Yr,HMRRGGICal,MP,Sea,TB)*ERo(Yr,HMRRGGICal,MP,'CO2')) )
         =e= 0;

*-------------------------------------------------------------------------------------------------------------------
