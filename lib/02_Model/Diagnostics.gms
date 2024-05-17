$ifthen.cal %UI_Cal% == Yes

Sets
        CalDiagYr(Yr)      /Yr1/
        CalDiagHMR(HMR)    /ME{,AL,AR,AZ,CA,CO,FL,GA,IA,ID,IL,IN,KS,KY,LA,MI,MN,
                            MO,MS,MT,NC,ND,NE,NM,NV,OK,OR,SC,SD,TN,UT,VA,WA,WI,
                            WV,WY,TX,ME,VT,NH,MA,RI,CT,NY,NJ,DE,DC,MD,PA,OH}/
        CalDiagFuel(Fuel)  /Coal{,NG,Oil,Nuke,Hydro,Wind,Solar,Bio,Geo,Oth}/
;
Parameters
*building blocks
        GenAEOAnnFuel(Yr,HMR,Fuel) annual AEO generation [GWh]
        CalGenDiffAEO(Yr,HMR,Fuel) generation in excess of AEO [GWh]
        ExcTransCap(Yr,HMRe,HMRi) excess transmission capability [GW]
        ExcRsvCap(Yr,RsvRg,Sea,TB) excess reserve capacity [GWh]
*filtered by UI_CalDiagHMR and UI_CalDiagFuel
        CalEPrcRtlAvg(Yr,HMR)  "average EPrcRtl calibrators [$/MWh]"
        CalGenAvgFuel(Yr,Fuel) "average Gen calibrators [$/MWh]"
        CalGenAvgHMR (Yr,HMR)  "average Gen calibrators [$/MWh]"
        CalDiag_ACFadj1(Yr,HMR,Fuel) ACFadj1
        CalDiag_ACFadj1_postadj(Yr,HMR,Fuel) ACFadj1
        CalDiag_GenMaxFuel(Yr,HMR,Fuel) "maximum possible generation [GWh] before tweaks"
        CalDiag_GenMaxFuel_postadj(Yr,HMR,Fuel) "maximum possible generation [GWh] after tweaks"
        CalDiag_GenNewNoDsp(Yr,HMR,Fuel) "generation required of new MPs that are grouped by Fuel with only non-dispatchables [GWh]"
        CalDiag_GenFuelYH(Yr,HMR,Fuel) "generation [GWh]"
        CalDiag_GenAEOFuelYH(Yr,HMR,Fuel) "AEO generation [GWh]"
        CalDiag_GNDMF_postadj(Yr,HMR,Fuel) "past-adjustment minimum possible generation by non-dispatchables [GWh]"
        CalDiag_GMF_postadj(Yr,HMR,Fuel) "maximum possible generation [GWh]"
        CalDiag_ExcExpCap(Yr,HMR) "excess export capability [GW]"
        CalDiag_ExcImpCap(Yr,HMR) "excess import capability [GW]"
        CalDiag_GenAbvMin(Yr,HMR,Fuel) "generation above minimum [GWh]"
        CalDiag_GenBlwMax(Yr,HMR,Fuel) "spare generation capaciy [GWh]"
        CalDiag_ExcRsvCap(RsvRg,Yr) "excess reserve capacity [GWh]"
        CalDiag_NetExp(Yr,HMR) "net exports [GWh]"
*still working these in... ap190215
        CalEmisAvg   (Yr) "national average CO2 emissions calibrators [$/ton]"
        ExcPotGenB(Yr,HMR,Sea,TB) excess potential generation [GW]
;
GenAEOAnnFuel(Yr,HMR,Fuel)=sum(Sea,GenAEOSeaFuel(Yr,HMR,Sea,Fuel));
CalGenDiffAEO(Yr,HMR,Fuel)=sum((HMRMP(HMR,MP),Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)$MPFuel(MP,Fuel))
        - sum(Sea,GenAEOSeaFuel(Yr,HMR,Sea,Fuel));
ExcRsvCap(Yr,RsvRg,Sea,TB)=(RsvMrgEq.L(Yr,RsvRg,Sea,TB)-RsvMrgEq.lo(Yr,RsvRg,Sea,TB))/SimYrWgt(Yr)*Hrs(Sea,TB);
ExcTransCap(Yr,HMRe,HMRi)=smin((Sea,TB), (Trans.up(Yr,HMRe,HMRi,Sea,TB)-Trans.L(Yr,HMRe,HMRi,Sea,TB))/Hrs(Sea,TB) );
        s2(Yr,HMR) =sum(Sea,  CalEPrcRtl.L(Yr,HMR,Sea)*sum(TB,ECons.L(Yr,HMR,Sea,TB)) );
CalEPrcRtlAvg(Yr,HMR) = s2(Yr,HMR) /sum((Sea,TB),ECons.L(Yr,HMR,Sea,TB));
        s2(Yr,Fuel)=sum(HMR,  CalGen.L(Yr,HMR,Fuel)*sum((MP,Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)$MPFuel(MP,Fuel)) );
        s2b(Yr,Fuel)=sum((HMR,MP,Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)$MPFuel(MP,Fuel));
CalGenAvgFuel(Yr,Fuel)$s2b(Yr,Fuel)= s2(Yr,Fuel)/(s2b(Yr,Fuel)$s2b(Yr,Fuel));
        s2(Yr,HMR) =sum(Fuel, CalGen.L(Yr,HMR,Fuel)*sum((MP,Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)$MPFuel(MP,Fuel)) );
CalGenAvgHMR (Yr,HMR) =(s2(Yr,HMR) /sum((MP,Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)))$sum((MP,Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB));
ExcPotGenB(Yr,HMR,Sea,TB)=sum((MP),
        (GenLeCapEq.L(Yr,HMR,MP,Sea,TB)-GenLeCapEq.lo(Yr,HMR,MP,Sea,TB)) /SimYrWgt(Yr)/Hrs(Sea,TB) );


CalDiag_ACFadj1(Yr,HMR,Fuel)                    $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =ACFadj1(Yr,HMR,Fuel);
CalDiag_ACFadj1_postadj(Yr,HMR,Fuel)            $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =ACFadj1_postadj(Yr,HMR,Fuel);
CalDiag_GenMaxFuel(Yr,HMR,Fuel)                 $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =GenMaxFuel(Yr,HMR,Fuel);
CalDiag_GenMaxFuel_postadj(Yr,HMR,Fuel)         $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =GenMaxFuel_postadj(Yr,HMR,Fuel);
CalDiag_GenNewNoDsp(Yr,HMR,Fuel)                $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =0; !!GenNewNoDsp(Yr,HMR,Fuel);
CalDiag_GenFuelYH(Yr,HMR,Fuel)                  $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =sum((MP,Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)*MPFuel(MP,Fuel));
CalDiag_GenAEOFuelYH(Yr,HMR,Fuel)               $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =sum(Month,GenAEO(Yr,Month,HMR,Fuel));
CalDiag_GNDMF_postadj(Yr,HMR,Fuel)              $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =GenNoDspMinFuel_postadj(Yr,HMR,Fuel);
CalDiag_GMF_postadj(Yr,HMR,Fuel)                $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =GenMaxFuel_postadj(Yr,HMR,Fuel);
CalDiag_ExcExpCap(Yr,HMR)                       $(CalDiagYr(Yr) and CalDiagHMR(HMR)                      )
        =smin(HMRi,ExcTransCap(Yr,HMR,HMRi)+1E12$(not ExcTransCap(Yr,HMR,HMRi)));
CalDiag_ExcImpCap(Yr,HMR)                       $(CalDiagYr(Yr) and CalDiagHMR(HMR)                      )
        =smin(HMRe,ExcTransCap(Yr,HMRe,HMR)+1E12$(not ExcTransCap(Yr,HMRe,HMR)));
CalDiag_GenAbvMin(Yr,HMR,Fuel)                  $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =CalDiag_GenFuelYH(Yr,HMR,Fuel)-CalDiag_GNDMF_postadj(Yr,HMR,Fuel);
CalDiag_GenBlwMax(Yr,HMR,Fuel)                  $(CalDiagYr(Yr) and CalDiagHMR(HMR) and CalDiagFuel(Fuel))
        =CalDiag_GMF_postadj(Yr,HMR,Fuel)-CalDiag_GenFuelYH(Yr,HMR,Fuel);
CalDiag_ExcRsvCap(RsvRg,Yr)                     $(CalDiagYr(Yr)                                          )
        =smax((Sea,TB),ExcRsvCap(Yr,RsvRg,Sea,TB));
CalDiag_NetExp(Yr,HMR)                          $(CalDiagYr(Yr) and CalDiagHMR(HMR)                      )
        =sum((Sea,TB),sum(HMRi,Trans.L(Yr,HMR,HMRi,Sea,TB))-sum(HMRe,Trans.L(Yr,HMRe,HMR,Sea,TB)));

option CalDiag_ExcRsvCap:0;
SrpsDsp=0;
$if %UI_SrpsDspLPLong% == Yes SrpsDsp=1;
display$(not SrpsDsp) SrpsDsp,
        GenAEOAnnFuel, CalGenDiffAEO, ExcTransCap, ExcRsvCap,
        CalEPrcRtlAvg, CalGenAvgFuel, CalGenAvgHMR,
        CalDiag_ACFadj1, CalDiag_ACFadj1_postadj,
        CalDiag_GenMaxFuel, CalDiag_GenMaxFuel_postadj, CalDiag_GenNewNoDsp,
        CalDiag_ExcExpCap, CalDiag_ExcImpCap,
        ExcPotGenB
;
display CalGenDiffAEO, TotCostLP.L
        CalDiag_GenFuelYH, CalDiag_GenAEOFuelYH,
        CalDiag_GenAbvMin, CalDiag_GenBlwMax, CalDiag_ExcRsvCap, CalDiag_NetExp
;

put dummy;
put_utility 'gdxout' / 'Output\%UI_Scen%\CalDiag_%UI_Scen%.gdx';
execute_unload
        CalDiag_GenFuelYH, CalDiag_GenAEOFuelYH,
        CalDiag_GenAbvMin, CalDiag_GenBlwMax, CalDiag_NetExp;
putclose;

$endif.cal

Parameters
        t1028CO2Nat(Yr)
        t1028CO2TCI(Yr)
        t1028CO2RGGICal(Yr)
        t1028CO2NatAEO(Yr)
        t1028CO2RGGICalAEO(Yr)
        t1104EConsNat(Yr)
        t1104EConsTCI(Yr)
;
t1028CO2Nat(Yr)=sum((HMR,MP,Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB)*ERo(Yr,HMR,MP,'CO2')*PolScl('CO2'));
t1028CO2TCI(Yr)=sum((HMR_TCI,MP,Sea,TB),Gen.L(Yr,HMR_TCI,MP,Sea,TB)*ERo(Yr,HMR_TCI,MP,'CO2')*PolScl('CO2'));
t1028CO2RGGICal(Yr)=sum((HMRRGGICal,MP,Sea,TB),Gen.L(Yr,HMRRGGICal,MP,Sea,TB)*ERo(Yr,HMRRGGICal,MP,'CO2')*PolScl('CO2'));
t1028CO2NatAEO(Yr)=sum((HMR,Fuel),EmisAEO(Yr,HMR,Fuel,'CO2'))*1E3*PolScl('CO2');
t1028CO2RGGICalAEO(Yr)=sum((HMRRGGICal,Fuel),EmisAEO(Yr,HMRRGGICal,Fuel,'CO2'))*1E3*PolScl('CO2');
t1104EConsNat(Yr)=sum((HMR,Sea,TB),EConsExo(Yr,HMR,Sea,TB));
t1104EConsTCI(Yr)=sum((HMR_TCI,Sea,TB),EConsExo(Yr,HMR_TCI,Sea,TB));
display t1028CO2Nat, t1028CO2TCI, t1028CO2RGGICal, t1028CO2NatAEO, t1028CO2RGGICalAEO, t1104EConsNat, t1104EConsTCI;

Parameters
        t1104EConsTBpctAnn(Yr,Sea,TB)
;
s1(Yr)=sum((HMR,Sea,TB),EConsExo(Yr,HMR,Sea,TB));
t1104EConsTBpctAnn(Yr,Sea,TB)=sum(HMR,EConsExo(Yr,HMR,Sea,TB))/s1(Yr);
display t1104EConsTBpctAnn;

display ObjInt.L, CalGen.L;
