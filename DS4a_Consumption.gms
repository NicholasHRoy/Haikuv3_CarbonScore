
*EConsExo is EConsRef (EIA consumption) transformed into Sea/TB space. It is the calibration target and used by SolveLP.
EConsRef(Yr,HMR,Sea,TB)=sum(Month,EConsRefMC(Yr,Month,HMR,'Tot')*SeaMonth(Sea,Month))*EConsTBpctSea(Yr,HMR,Sea,TB);
ERevRef(Yr,HMR,Sea,TB)=sum(Month,ERevRefMC(Yr,Month,HMR,'Tot')*SeaMonth(Sea,Month))*EConsTBpctSea(Yr,HMR,Sea,TB);
EPrcRef(Yr,HMR,Sea,TB)$(EConsRef(Yr,HMR,Sea,TB)<>0)=ERevRef(Yr,HMR,Sea,TB)*1E3/EConsRef(Yr,HMR,Sea,TB);

*Build sector specific parameters
Cons0(Yr,HMR,Sector) = sum(Month,EConsRefMC(Yr,Month,HMR,Sector));
SeaPctAnn(Yr,HMR,Sea,Sector) = sum(Month,EConsRefMC(Yr,Month,HMR,Sector)*SeaMonth(Sea,Month))/sum(Month,EConsRefMC(Yr,Month,HMR,Sector));
TBpctSea(Yr,HMR,Sea,TB,Other) = EConsOtherTBpctSea(Yr,HMR,Sea,TB);
TBpctSea(Yr,HMR,Sea,TB,'EVs') = EConsEVTBpctSea(Yr,HMR,Sea,TB);

*Option to Adjust TBs
$ifthenE.tb SameAs('%UI_TB%','1')
         TBpctSea(Yr,HMR,Sea,TB,'EVs')  =0;
         TBpctSea(Yr,HMR,Sea,'1','EVs') =1;
$elseifE.tb SameAs('%UI_TB%','2')
         TBpctSea(Yr,HMR,Sea,TB,'EVs')  =0;
         TBpctSea(Yr,HMR,Sea,'2','EVs') =1;
$elseifE.tb SameAs('%UI_TB%','3')
         TBpctSea(Yr,HMR,Sea,TB,'EVs')  =0;
         TBpctSea(Yr,HMR,Sea,'3','EVs'))=1;
$elseifE.tb SameAs('%UI_TB%','4')
         TBpctSea(Yr,HMR,Sea,TB,'EVs')  =0;
         TBpctSea(Yr,HMR,Sea,'4','EVs') =1;
$elseifE.tb SameAs('%UI_TB%','23')
         TBpctSea(Yr,HMR,Sea,TB,'EVs')  =0;
         TBpctSea(Yr,HMR,Sea,'2','EVs') =0.5;
         TBpctSea(Yr,HMR,Sea,'3','EVs') =0.5;
$endif.tb



*Option to read in VA values of consumption
$ifthen.va %UI_VACons% == Yes
set
level set for VA consumption import /high, low/
cons_type set for VA consumption import /ev, dc, oth/
;
parameter
VACons(YrFull,level,cons_type) "Annual VA demand from Bill Shobe [GWh]"
VACons0(Yr,sector)
;
*$call gdxxrw.exe "ShobeDemand_210902.xlsx" par=VACons rdim=3 rng=sheet1!A2:D249
$gdxin "ShobeDemand_210902.gdx"
$load VACons
$gdxin

VACons0(Yr,Sector) = Cons0(Yr,'VA',Sector);
Cons0(Yr,'VA','EVs')$(SimYr(Yr)>%UI_FxGen%) = VACons(Yr,'high','ev');
Cons0(Yr,'VA',Other)$(SimYr(Yr)>%UI_FxGen%) = (VACons(Yr,'high','oth') + VACons(Yr,'high','dc')) * VACons0(Yr,Other) / sum(Otherdup,VACons0(Yr,Otherdup));

$endif.va


GWhperMi(YrFull,VehClass,VehType,Scenario) = 0;
$ifthen.ca %UI_CACons% == Yes

parameter
Cons0CARB(YrFull,Sector,Scenario)
CACons0(Yr,Sector)
;

$call gdxxrw.exe "Cons0CARB_%UI_vCARB%.xlsx" par=Cons0CARB rdim=3 rng=sheet1!A2:D676 Output="Cons0CARB_%UI_vCARB%.gdx"
$gdxin "Cons0CARB_%UI_vCARB%.gdx"
$load Cons0CARB
$gdxin

$ifthen.CALDVEDem %UI_CALDV% == Yes

Parameter
VMTDemand(YrFull,HMR,VehClass)
tempEVMT(YrFull,VehClass,VehType,Scenario)
tempVMT(YrFull,VehClass,VehType,Scenario);

$call gdxxrw.exe "Transport_%UI_vCARB%.xlsx" Output="Transport_%UI_vCARB%.gdx" Index=Index!A1:F11
$gdxin "Transport_%UI_vCARB%.gdx"
$load Veh0 VehSales0 VehRtr0 VMT0 VehEnergy0
$gdxin

MPV0(YrFull,VehClass,VehType,Scenario)$(Veh0(YrFull,VehClass,VehType,Scenario) > 0) = VMT0(YrFull,VehClass,Scenario)/sum(VehTypedup,Veh0(YrFull,VehClass,VehTypedup,Scenario));
PlnVehRtr(Yr,'CA',VehClass,VehType) = sum(YrFull,VehRtr0(YrFull,VehClass,VehType,'%UI_CAScen%')$(SimYrFull(YrFull) <= SimYr(Yr) and SimYrFull(YrFull) > SimYr(Yr-1) ) );

*Calculate initial VMT and EVMT for each vehicle type
tempVMT(YrFull,VehClass,VehType,Scenario)$(Veh0(YrFull,VehClass,VehType,Scenario)>0) =
                                                 VMT0(YrFull,VehClass,Scenario)*
                                                 (Veh0(YrFull,VehClass,VehType,Scenario))
                                                 /sum(VehTypedup,Veh0(YrFull,VehClass,VehTypedup,Scenario));

tempEVMT(YrFull,VehClass,'Elec',Scenario)$(Veh0(YrFull,VehClass,'Elec',Scenario)>0) = tempVMT(YrFull,VehClass,'Elec',Scenario);
tempEVMT(YrFull,VehClass,'PHEV',Scenario)$(Veh0(YrFull,VehClass,'PHEV',Scenario)>0) = tempVMT(YrFull,VehClass,'PHEV',Scenario)*(1/(ZEVRatio+1));

*Set GWhperMi for all vehicle classes
GWhperMi(YrFull,VehClass,VehType,Scenario)$(VehFuelEV(VehType) and tempEVMT(YrFull,VehClass,VehType,Scenario) > 0)=
                                            (VehEnergy0(YrFull,VehClass,'Elec',Scenario)*
                                                 (tempEVMT(YrFull,VehClass,VehType,Scenario)/sum(VehTypedup,tempEVMT(YrFull,VehClass,VehTypedup,Scenario)$(VehFuelEV(VehTypedup)))))
                                            /(tempVMT(YrFull,VehClass,VehType,Scenario));


parameter kWhperMi(YrFull,VehClass,VehType,Scenario);
kWhperMi(YrFull,VehClass,VehType,Scenario) = GWhperMi(YrFull,VehClass,VehType,Scenario) *1000000;
display GWhperMi kWhperMi tempEVMT;

*Rescale battery efficiency to equal real world values in the future
BattEffReScl(YrFull,VehClass,VehType,'BAU') = 1;
BattEffReScl(YrFull,VehClass,VehType,'SP') = 1;
BattEffReScl(YrFull,'LDV','PHEV','SP')  = 1.2;
BattEffReScl(YrFull,'LDV','PHEV','BAU')  = 1.2;
BattEffReScl(YrFull,'LDV','Elec',Scenario)$(SimYrFull(YrFull)< SimYrLast and GWhperMi(YrFull,'LDV','Elec',Scenario) > 0)  =
                                         (( (sum(VehType,GWhperMi(YrFull,'LDV',VehType,Scenario)*tempVMT(YrFull,'LDV',VehType,Scenario)))
                                                 - (BattEffReScl(YrFull,'LDV','PHEV',Scenario) *GWhperMi(YrFull,'LDV','PHEV',Scenario) *tempVMT(YrFull,'LDV','PHEV',Scenario)))
                                                         /(tempVMT(YrFull,'LDV','Elec',Scenario)) )
                                                 /GWhperMi(YrFull,'LDV','Elec',Scenario);
GWhperMi(YrFull,VehClass,VehType,Scenario)$(SimYrFull(YrFull)< SimYrLast)  = BattEffReScl(YrFull,VehClass,VehType,Scenario) * GWhperMi(YrFull,VehClass,VehType,Scenario);
kWhperMi(YrFull,VehClass,VehType,Scenario)$(SimYrFull(YrFull)< SimYrLast)  = GWhperMi(YrFull,VehClass,VehType,Scenario) *1000000;

display BattEffReScl kWhperMi Cons0 Cons0CARB;
Cons0CARB(Yr,'EVs',Scenario)$(SimYr(Yr)>%UI_FxGen%) =  Cons0CARB(Yr,'EVs',Scenario)
                                                         -sum((VehClass,VehType),GWhperMi(Yr,VehClass,VehType,Scenario)*tempVMT(Yr,VehClass,VehType,Scenario));
display kWhperMi Cons0CARB;

Cons0CARB(Yr,'EVs',Scenario)$(SimYr(Yr)>%UI_FxGen% and Cons0CARB(Yr,'EVs',Scenario) < 0.1 and Cons0CARB(Yr,'EVs',Scenario) > -0.1) = 0;

display kWhperMi Cons0CARB;



$endif.CALDVEDem

CACons0(Yr,Sector) = Cons0(Yr,'CA',Sector);
display Cons0 CACons0 Cons0CARB;
CACons0(Yr,Sector) = Cons0CARB(Yr,Sector,'%UI_CAScen%');
Cons0(Yr,'CA',Sector)$(SimYr(Yr) > %UI_FxGen%) = CACons0(Yr,Sector);

display Cons0;

$endif.ca


*Option to add in EE Adjustments
parameter
EESavings(YrFull,PPAR)
;

EESavings(YrFull,PPAR)          = 0;

$set UI_PPAR %UI_PPAR_EE%
$include SetPPARMapping
map_EE_YPH(Yr,PPAR,HMR)=map_tmp_YPH(Yr,PPAR,HMR);

$ifthen.EE %UI_PPAR_EE%==Nat

EESavings('Yr3','Nat')  = 27.48 * ((1000) * (7/25)) ;
*                          Trillion BTUs * (1000 * billions/trillions) * (7/25 * GWh/billion BTUs)
*                          Trillion BTUs to GWh
EESavings('Yr4','Nat')  = EESavings('Yr3','Nat') * (1 + (1-.11)                                                                                                        );
EESavings('Yr5','Nat')  = EESavings('Yr3','Nat') * (1 + (1-.11) + (1-.11)**2                                                                                           );
EESavings('Yr6','Nat')  = EESavings('Yr3','Nat') * (1 + (1-.11) + (1-.11)**2 + (1-.11)**3                                                                              );
EESavings('Yr7','Nat')  = EESavings('Yr3','Nat') * (1 + (1-.11) + (1-.11)**2 + (1-.11)**3 + (1-.11)**4                                                                 );
EESavings('Yr8','Nat')  = EESavings('Yr3','Nat') * (1 + (1-.11) + (1-.11)**2 + (1-.11)**3 + (1-.11)**4 + (1-.11)**5                                                    );
EESavings('Yr9','Nat')  = EESavings('Yr3','Nat') * (1 + (1-.11) + (1-.11)**2 + (1-.11)**3 + (1-.11)**4 + (1-.11)**5 + (1-.11)**6                                       );
EESavings('Yr10','Nat') = EESavings('Yr3','Nat') * (1 + (1-.11) + (1-.11)**2 + (1-.11)**3 + (1-.11)**4 + (1-.11)**5 + (1-.11)**6 + (1-.11)**7                          );
EESavings('Yr11','Nat') = EESavings('Yr3','Nat') * (1 + (1-.11) + (1-.11)**2 + (1-.11)**3 + (1-.11)**4 + (1-.11)**5 + (1-.11)**6 + (1-.11)**7 + (1-.11)**8             );
EESavings('Yr12','Nat') = EESavings('Yr3','Nat') * (1 + (1-.11) + (1-.11)**2 + (1-.11)**3 + (1-.11)**4 + (1-.11)**5 + (1-.11)**6 + (1-.11)**7 + (1-.11)**8 + (1-.11)**9);
EESavings(YrFull,'Nat')$(SimYrFull(YrFull) >= 2032) = EESavings('Yr12','Nat') *((1-.11)**(SimYrFull(YrFull)-2031));

$elseif.EE %UI_PPAR_EE%==VA

EESavings('Yr3','VA')  = 1082.262973;
EESavings('Yr4','VA')  = 2164.525945;
EESavings('Yr5','VA')  = 3246.788918;
EESavings('Yr6','VA')  = 4329.05189;
EESavings(YrFull,'VA')$(SimYrFull(YrFull) > 2025 )
                       = EESavings('Yr6','VA');

$ifthen.VAEE %UI_VAEE% == Extended
EESavings('Yr7','VA')  = 5283.62634;
EESavings('Yr8','VA')  = 6238.20079;
EESavings('Yr9','VA')  = 7192.77524;
EESavings('Yr10','VA') = 8147.34969;
EESavings('Yr11','VA') = 9101.92414;
EESavings('Yr12','VA') = 10056.49859;
EESavings('Yr13','VA') = 11011.07304;
EESavings('Yr14','VA') = 11965.64749;
EESavings('Yr15','VA') = 12920.22194;
EESavings('Yr16','VA') = 13874.79639;
EESavings('Yr17','VA') = 14829.37084;
EESavings(YrFull,'VA')$(SimYrFull(YrFull) >= 2036 )
                       = EESavings('Yr17','VA');
$endif.VAEE

$endif.EE

Cons0(Yr,HMR,Other)$(sum(PPAR,map_EE_YPH(Yr,PPAR,HMR))) = Cons0(Yr,HMR,Other) - (sum(PPAR,EESavings(Yr,PPAR)*map_EE_YPH(Yr,PPAR,HMR))
                                                                                         *(sum(PPAR,Cons0(Yr,HMR,Other)*map_EE_YPH(Yr,PPAR,HMR))/sum((PPAR,HMRdup,Otherdup),Cons0(Yr,HMRdup,Otherdup)*map_EE_YPH(Yr,PPAR,HMRdup))));

*Option to raise or lower all demand by a fixed percent.
$ifthen.dem %UI_Demand%==Low
         Cons0(Yr,HMR,Sector)$(SimYr(Yr)>=2022 and Other(Sector))= Cons0(Yr,HMR,Sector)*(1 - 0.01*(SimYr(Yr)-2021));
$elseif.dem %UI_Demand%==High
         Cons0(Yr,HMR,Sector)$(SimYr(Yr)>=2022 and Other(Sector))= Cons0(Yr,HMR,Sector)*(1 + 0.01*(SimYr(Yr)-2021));
$elseif.dem %UI_Demand%==NREL
*Option to shift to NREL high electrification
         Cons0(Yr,HMR,Sector)$(SimYr(Yr) >= %UI_GrowCap% + 1)= Cons0(Yr,HMR,Sector) + (NRELCons("high",Yr,HMR,Sector)-NRELCons("reference",Yr,HMR,Sector));
$endif.dem


$ifthen.CSP %UI_CSP% == AEO
parameter
Cons0AEO(YrFull,HMR,Sector,AEOScen);

$call gdxxrw.exe "Cons0CSP.xlsx" par=Cons0AEO rdim=4 rng=Cons0AEO!A2:E32641 Output="Cons0AEO.gdx"
$gdxin "Cons0AEO.gdx"
$load Cons0AEO
$gdxin        
Cons0(Yr,HMR,Sector)$(SimYr(Yr)>=%UI_GrowCap% + 1) = Cons0AEO(Yr,HMR,Sector,'%UI_Demand%');

$elseif.CSP %UI_CSP% == CSP
parameter
Cons0CSP(YrFull,HMR,Sector,AEOScen);

$call gdxxrw.exe "Cons0CSP.xlsx" par=Cons0CSP rdim=4 rng=Cons0CSP!A2:E32641 Output="Cons0CSP.gdx"
$gdxin "Cons0CSP.gdx"
$load Cons0CSP
$gdxin        
Cons0(Yr,HMR,Sector)$(SimYr(Yr)>=%UI_GrowCap% + 1) = Cons0CSP(Yr,HMR,Sector,'%UI_Demand%');
 
$endif.CSP


EESvSeaTb(Yr,HMR,Sea,TB) = sum(Sector,Cons0(Yr,HMR,Sector)*SeaPctAnn(Yr,HMR,Sea,Sector)*TBpctSea(Yr,HMR,Sea,TB,Sector)) / sum(Sector,Cons0(Yr,HMR,Sector));

parameter natcons(Yr);
natcons(Yr) = sum((HMR,Sea,TB,Sector),Cons0(Yr,HMR,Sector)*SeaPctAnn(Yr,HMR,Sea,Sector)*TBpctSea(Yr,HMR,Sea,TB,Sector));
display natcons;
