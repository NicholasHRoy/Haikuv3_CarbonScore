*-------------------------------------------------------------------------------------------------------------
* IMMEDIATE POST-PROCESSING
*-------------------------------------------------------------------------------------------------------------
*For calibration, resolve with the calibrator variables instead of constraints, to find marginal costs in competitive states.
$ifthen.cal %UI_Cal% == Yes
*       CalGen is adjusted to make total costs equal total revenue.
*        t1118CGAdj(Yr)=(sum((HMR,Sea,TB),ERevRef(Yr,HMR,Sea,TB))-sum(HMR,TotCost_YrHMR.L(Yr,HMR))/1E3)
*                /(sum((HMR,MP,Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB))/1E3);
*        display t1118CGAdj;
*        CalGen.fx(Yr,HMR,Fuel)$(CalGenEq.M(Yr,HMR,Fuel) <> 0) =  CalGenEq.M(Yr,HMR,Fuel);
*        CalGen.fx(Yr,HMR,Fuel)$(CalGenEq2.M(Yr,HMR,Fuel) <> 0) = -CalGenEq2.M(Yr,HMR,Fuel);
*        CalGen.fx(Yr,HMR,Fuel)$(sum(PPAR,(CalGenPPAREq.M(Yr,PPAR,Fuel)*map_CalGen_YPH(Yr,PPAR,HMR))) <> 0) = -sum(PPAR,(CalGenPPAREq.M(Yr,PPAR,Fuel)*map_CalGen_YPH(Yr,PPAR,HMR)));
        CalGen.fx(Yr,HMR,Fuel) = CalGenEq.M(Yr,HMR,Fuel) -CalGenEq2.M(Yr,HMR,Fuel) - sum(PPAR,(CalGenPPAREq.M(Yr,PPAR,Fuel)*map_CalGen_YPH(Yr,PPAR,HMR)));
        CalGenTot.fx(Yr,HMR)$(CalGenTotEq.M(Yr,HMR) <> 0)= CalGenTotEq.M(Yr,HMR);
        CalGenTot.fx(Yr,HMR)$(CalGenTotEq2.M(Yr,HMR) <> 0)=- CalGenTotEq2.M(Yr,HMR);
        CalEmis.fx(Yr)=CalEmisEq.M(Yr);
        CalEmisRGGI.fx(Yr)=CalEmisRGGIEq.M(Yr);

*        CalGen.L(Yr,HMR,Fuel)$(CalGenEq.M(Yr,HMR,Fuel) <> 0)  = CalGenEq.M(Yr,HMR,Fuel);
*        CalGen.L(Yr,HMR,Fuel)$(CalGenEq2.M(Yr,HMR,Fuel) <> 0) = -CalGenEq2.M(Yr,HMR,Fuel);
*        CalGen.L(Yr,HMR,Fuel)$(sum(PPAR,(CalGenPPAREq.M(Yr,PPAR,Fuel)*map_CalGen_YPH(Yr,PPAR,HMR))) <> 0) = -sum(PPAR,(CalGenPPAREq.M(Yr,PPAR,Fuel)*map_CalGen_YPH(Yr,PPAR,HMR)));
        CalGen.l(Yr,HMR,Fuel) = CalGenEq.M(Yr,HMR,Fuel) -CalGenEq2.M(Yr,HMR,Fuel) - sum(PPAR,(CalGenPPAREq.M(Yr,PPAR,Fuel)*map_CalGen_YPH(Yr,PPAR,HMR)));
        CalGenTot.L(Yr,HMR)$(CalGenTotEq.M(Yr,HMR) <> 0)= CalGenTotEq.M(Yr,HMR);
        CalGenTot.L(Yr,HMR)$(CalGenTotEq2.M(Yr,HMR) <> 0)= -CalGenTotEq2.M(Yr,HMR);
        CalEmis.L(Yr)=CalEmisEq.M(Yr);
        CalEmisRGGI.L(Yr)=CalEmisRGGIEq.M(Yr);

        CalNPCap(Yr,HMR,MP)=NPCap.L(Yr,HMR,MP);
        CalTrans(Yr,HMRe,HMRi,Sea,TB)=Trans.L(Yr,HMRe,HMRi,Sea,TB);
        TransCap(Yr,HMRe,HMRi,Sea)=smax(TB,Trans.L(Yr,HMRe,HMRi,Sea,TB)/Hrs(Sea,TB))
                +max(1,0.2*sum(MP,NPCap.L(Yr,HMRe,MP)))$HMRei(HMRe,HMRi);
$endif.cal

*Assign values to MCP variables that are not LP variables.
ECons.L(Yr,HMR,Sea,TB)=sum(sector,Cons.l(Yr,HMR,Sector)*SeaPctAnn(Yr,HMR,Sea,Sector)*TBpctSea(Yr,HMR,Sea,TB,Sector));
gamma.L(Yr,HMR,MP)=NPCapEq.M(Yr,HMR,MP);
MCGen.L(Yr,HMR,Sea,TB)=SupDemEq.M(Yr,HMR,Sea,TB);
MCCap.L(Yr,RsvRg,Sea,TB)=RsvMrgEq.M(Yr,RsvRg,Sea,TB);
lambda.L(Yr,HMR,MP,Sea,TB)=GenLeCapEq.M(Yr,HMR,MP,Sea,TB);
MCNoDsp.L(Yr,HMR,MPNew,Sea,TB)=NoDspEq.M(Yr,HMR,MPNew,Sea,TB);
AlwPrc.FX(Yr,PPAR)$(AlwPrc.up(Yr,PPAR)>AlwPrc.lo(Yr,PPAR)) = sum(step,EmisCapEq.M(Yr,PPAR,step));
*AlwPrcBank.FX(Yr,PPAR)$(AlwPrcBank.up(Yr,PPAR)>AlwPrcBank.lo(Yr,PPAR)) = sum(Yrdup,sum(step,EmisCapEqBankStep.M(Yrdup,PPAR,step))$(SimYr(Yrdup)>=SimYr(Yr))) * (1/Beta(Yr));
*AlwPrcBank.FX(Yr,PPAR)$(AlwPrcBank.up(Yr,PPAR)>AlwPrcBank.lo(Yr,PPAR)) = (sum(Yrdup,sum(step,EmisCapEqBankStep.M(Yrdup,PPAR,step))$(SimYr(Yrdup)>=SimYr(Yr)))- EmisCapEqBankCeiling.M(Yr,PPAR)) * (1/Beta(Yr));


parameter
tempAlwPrcBank(Yr,PPAR,step);

tempAlwPrcBank(Yr,PPAR,step) = 0;
tempAlwPrcBank(Yr,PPAR,step) = ACAlwPrc(Yr,PPAR,step)$(sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR)) <= sum(stepdup,EmisCap(Yr,PPAR,stepdup)$(s(stepdup) = s(step)+1))*1E3
                                                       and sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR)) > 0 );
display tempAlwPrcBank;

parameter
bool1test(Yr,PPAR,step)
bool2test(Yr,PPAR,step)
bool1Stest(Yr,PPAR)
bool2Stest(Yr,PPAR);

bool1test(Yr,PPAR,step) = sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR)) <= EmisCap(Yr,PPAR,step)*1E3;
bool2test(Yr,PPAR,step) = sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR)) > 0;

bool1Stest(Yr,PPAR) = smin(step$(bool1test(Yr,PPAR,step)), s(step)$(bool1test(Yr,PPAR,step)));
bool2Stest(Yr,PPAR) = smax(step$(bool1test(Yr,PPAR,step)), s(step)$(bool2test(Yr,PPAR,step)));

display bool1test bool2test bool1Stest bool2Stest;


AlwPrcBank.FX(Yr,PPAR)$((AlwPrcBank.up(Yr,PPAR)>AlwPrcBank.lo(Yr,PPAR)) and (smin(step$(bool1test(Yr,PPAR,step)),s(step)$(bool1test(Yr,PPAR,step))) = smax(step$(bool1test(Yr,PPAR,step)),s(step)$(bool2test(Yr,PPAR,step))))) =
         smax(step,ACAlwPrc(Yr,PPAR,step)$(sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR)) <= sum(stepdup,EmisCap(Yr,PPAR,stepdup)$(s(stepdup) = s(step)+1))*1E3
                                       and sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR)) > 0 ));

display AlwPrcBank.l;

$ontext
smax(step,tempAlwPrcBank(Yr,PPAR,step))

tempAlwPrcBank(Yr,PPAR,step)$()

AlwPrcBank.FX(Yr,PPAR)$((AlwPrcBank.up(Yr,PPAR)>AlwPrcBank.lo(Yr,PPAR)) and
                         (smin(step,s(step)$((sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR)) <= EmisCap(Yr,PPAR,step)*1E3)))
                         = smax(step,s(step)$((sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR)) > 0)))
                         )) =
                                 smax(step,ACAlwPrc(Yr,PPAR,step)$(sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR)) <= sum(stepdup,EmisCap(Yr,PPAR,stepdup)$(s(stepdup) = s(step)+1))*1E3
                                       and sum(HMR,ACAlw.l(Yr,PPAR,HMR,step)*map_EmisPol_YPH(Yr,PPAR,HMR)) > 0 ));
$offtext

AlwPrcBank.FX(Yr,PPAR)$(AlwPrcBank.up(Yr,PPAR)>AlwPrcBank.lo(Yr,PPAR)) = sum(Yrdup,sum(step,EmisCapEqBankStep.M(Yrdup,PPAR,step))$(SimYr(Yrdup)>=SimYr(Yr))) * (1/Beta(Yr));
display AlwPrcBank.l;

AlwPrcBank.FX(Yr,PPAR)$(AlwPrcBank.L(Yr,PPAR)>smax(step, ACAlwPrc(Yr,PPAR,step))) = smax(step, ACAlwPrc(Yr,PPAR,step));
AlwPrcBank.l(Yr,PPAR)$(AlwPrcBank.L(Yr,PPAR)>smax(step, ACAlwPrc(Yr,PPAR,step))) = smax(step, ACAlwPrc(Yr,PPAR,step));
display AlwPrcBank.l;

AlwPrcBank.FX(Yr,PPAR)$(AlwPrcBank.L(Yr,PPAR)<smin(step$(ACAlwPrc(Yr,PPAR,step) > 0 ), ACAlwPrc(Yr,PPAR,step)) and AlwPrcBank.L(Yr,PPAR) > 0 ) = smin(step$(ACAlwPrc(Yr,PPAR,step) > 0 ), ACAlwPrc(Yr,PPAR,step));
AlwPrcBank.l(Yr,PPAR)$(AlwPrcBank.L(Yr,PPAR)<smin(step$(ACAlwPrc(Yr,PPAR,step) > 0 ), ACAlwPrc(Yr,PPAR,step))  and AlwPrcBank.L(Yr,PPAR) > 0 ) = smin(step$(ACAlwPrc(Yr,PPAR,step) > 0 ), ACAlwPrc(Yr,PPAR,step));
display AlwPrcBank.l;

PSPrc.FX(Yr,PPAR) = PSPrc.l(Yr,PPAR) + PSEQ.M(Yr,PPAR);
PlnREPrc.fx(Yr,PPAR) = PlnREInv.M(Yr,PPAR);
PlnTechPrc.fx(Yr,HMR,Tech) = PlnTechInv.M(Yr,HMR,Tech);

*-------------------------------------------------------------------------------------------------------------
* RETAIL PRICE CALCULATION
*-------------------------------------------------------------------------------------------------------------

$include RtlPrc.gms

*-------------------------------------------------------------------------------------------------------------
* EXPORT SOLUTION
*-------------------------------------------------------------------------------------------------------------
*Round values near zero and save variables, equations, and objective function.
*mSU_fVarDims(mr6)
put dummy;
put_utility 'gdxout' / '..\Shared\Solutions\%UI_vHaiku%_%UI_Scen%.gdx';
execute_unload
        ListVarCore(noFunc,noEq,none,'','',',',none)
        TotCostLP, TotCost_YrHMR, Obj, ObjInt,
        NPCapEQ, SupDemEq, RsvMrgEq, GenLeCapEq, NoDspEq
*        NPCap, Gen, Trans, EPrcRtl, ECons,
*        gamma, MCGen, MCCap, lambda, MCNoDsp,
;

$ifthen.cal %UI_Cal% == Yes
*Save calibrators.
        put dummy;
        put_utility 'gdxout' / '%UI_RootDir%\..\Shared\Solutions\Calibration\%UI_vHaiku%_%UI_Scen%';
        execute_unload
                ListVarCal(noFunc,noEq,none,'','',',',none),
                ListPrm(noFunc,noEq,none,'','',',',none),
                CalGenEq, CalGenEq2, CalGenPPAREq, CalGenTotEq, CalEmisEq, CalEmisRGGIEq
;
$endif.cal
putclose;

*$ontext
$else.slv
        put dummy;
        put_utility 'gdxin' / '..\Shared\Solutions\%UI_vHaiku%_%UI_Scen%.gdx';
        execute_load NPCap, Gen, Trans, EPrcRtl, ECons,
                       TotCostLP, TotCost_YrHMR, gamma, MCGen, MCCap, lambda, MCNoDsp,
                       Obj, ObjInt, NPCapEQ, SupDemEq, RsvMrgEq, GenLeCapEq, NoDspEq;

        put_utility 'gdxin' / '..\Shared\Solutions\Calibration\%UI_vHaiku%_%UI_Scen%.gdx';
        execute_load CalEPrcRtl, CalEPrcRtl2, CalGen, CalEmis, CalEmisRGGI, TransCap,
                       CalGenEq, CalEmisEq, CalEmisRGGIEq;
        putclose;
$endif.slv
*$offtext

*-------------------------------------------------------------------------------------------------------------
* RESULTS
*-------------------------------------------------------------------------------------------------------------

$include Results
