* EmisCap Policy Settings

*--------------------------------------------------
* Default Settings - No Policy (Tax or Cap)
Parameters
    TmpAlwPrc(Yr,PPAR)
;

$ifthen.init not %UI_Func% == Res
    AlwPrc.L(Yr,PPAR) = 0;
$endif.init

*Save initial values in the Tmp variables, for use restoring initial values after they are reset to zero next.
TmpAlwPrc(Yr,PPAR)=AlwPrc.L(Yr,PPAR);

*We need to be careful about bringing .lo and .up values in through initial values, which might not be overwritten
*appropriately for the intended policy. Maybe setting .lo and .up instead of .fx would be better here and allow for
*the removal of the Tmp variables above. ap190311
AlwPrc.fx(Yr,PPAR)=0;
ACAlw.fx(Yr,PPAR,HMR,step)=0;
AlwPrcCofire.fx(YrFull,PPAR)=0;
EmisCap(YrFull,PPAR,step)=10E6;
EmisCapAlloc(YrFull,PPAR,HMR) = 0;
EmisCapAllocStep(YrFull,PPAR,HMR,step) = 10E6;
ExchangeRate(Yr,PPAR,HMR) = 1;
EnhancedComp(Yr,PPAR,HMR) = 1;
ACAlwPrc(Yr,PPAR,step)=0;
AlwPrcBank.fx(Yr,PPAR)=0;
EmisBankStartYr(PPAR) = DataYr;
EmisSector0(Yr,HMR,Sector) = 0;
Bank0(PPAR)=0;
EmisAbatement.fx(Yr,HMR,Sector,stepAbate) = 0;
AbatementPrice(Yr,HMR,Sector,stepAbate) = 0;
AbatementElasticity(Yr,HMR,Sector) = 0;
CrossElasticity(Yr,HMR,Sector) = 0;
ConsPerEmisAbate(Yr,HMR,Sector) = 0;
*Note that the problem with doing this is that it becomes another lever that prevents abatement
AbatementStepMax(Yr,HMR,Sector,stepAbate) = 0;
ConsPerEmisAbate(Yr,HMR,Sector) = 0;
VMT.fx(YrFull,HMR,VehClass,VehType) = 0;
CO2perMi(YrFull,VehClass,VehType,Scenario) = 0;

*--------------------------------------------------
* Declare parameters used in this subprogram of DefScen.
Parameters
    EmisRefMP(Yr,PPAR,HMR,MP)
    EmisRefMPFull(YrFull,PPAR,HMR,MP)
    EmisRefFull(YrFull,PPAR)
    EmisCapCovTot(Yr,PPAR) annual total RGGI covered emissions [M tons]
    PPAREmisCovTot(Yr,PPAR) annual total RGGI covered emissions [M tons]
    EmisAnn(Yr,HMR,MP,Pol)
    EmisYPCvr(Yr,PPAR,Pol)
    EmisCapPrcExog(Yr,PPAR)
    PPARAct(PPAR) PPAR is active
    map_EmisPrc_PHM(PPAR,HMR,MP) "mapping of HMR/MP pairs to PPARs for emissions pricing"
    EECheck(Yr,HMR)
    EECheckSeaTb(Yr,HMR,Sea,Tb)
;

*Emissions caps in years in between SimYrs are interpolated.
EmisCap(YrFull,PPAR,'s1') = sum(Yrdup,EmisCap(Yrdup,PPAR,'s1')*SimYrWgtKnl(YrFull,Yrdup));

*Identify PHM tuples that ever face an emissions price.
map_EmisPrc_PHM(PPAR,HMR,MP)=sum(Yr,map_EmisPol_YPHM(Yr,PPAR,HMR,MP));

*Default reference allowance price is $0/ton.
AlwPrcRef(Yr,PPAR)=0;

*Initialize UI_EmisPolType, which is now obsolete? That would be cool. ap190905
$setglobal UI_EmisPolType NA


*set default value for whether to include imports in carbon cap
PriceImports(PPAR) = 0;

*set average emissions rate per (exporting) state based on historical values
*ExpERo(HMR) =  EmisHist('Yr0',HMR,'CO2') * 1000 / (GenHist('Yr0',HMR));
*ExpERo(HMR) =  0.4*smax((Yr,MP),ERo(Yr,HMR,MP,'CO2')$MPFuel(MP,'NG')$MPTech(MP,'CC'));

**----------------------------------------------------------------------------------------------------------

*Setting reference emissions to a reference case scenario for a set of policies
$ifthenE.RefEmisAnn SameAs('%UI_RefEmisAnn%','Yes')

*Load emissions from the reference scenario %UI_vRS1%_%UI_RefScen1%.
put dummy;
put_utility 'gdxin' / '%UI_RootDir%\..\%UI_vRS3%\Output\%UI_RefScen3%\%UI_vRS3%_%UI_RefScen3%';
execute_load EmisYPCvr;
putclose;

EmisRefFull(YrFull,PPAR) = sum(Yr,EmisYPCvr(Yr,PPAR,'CO2')*SimYrWgtKnl(YrFull,Yr));

$endIf.RefEmisAnn
**----------------------------------------------------------------------------------------------------------


*National Carbon Tax
$ifthen.ctax not %UI_CTax%==0
**---------------------------------------------------------------------------------------------------------
*set years for the tax
set
YrC(Yr)
;
YrC(Yr)=Yes$(SimYr(Yr)>=%UI_CTaxStYr%);
*set level of tax
AlwPrc.fx(YrC,'Nat') = %UI_CTax% * (1/Inflation('2019')) * ((1+ (%UI_GrRate% *.01) )**(SimYr(YrC)-%UI_CTaxStYr%));

*turn on mapping for national PPAR
map_EmisPol_YPH(Yr,'Nat',HMR)= Yes;
map_EmisPol_YPHM(Yr,'Nat',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'Nat',HMR) and EmisPolMP(MP));
**----------------------------------------------------------------------------------------------------------
$endif.ctax

*National Cofiring Emissions Cap -- turn on constraint based on mappings created in DS4

$ifthen.cofire not %UI_PPAR_Cofire% == No
AlwPrcCofire.up(YrFull,PPAR)$(sum((Yr,HMR),map_CofirePol_YPH(Yr,PPAR,HMR)) and SimYrFull(YrFull)>%UI_FxCap%)=+INF;
AlwPrcCofire.lo(YrFull,PPAR)$(sum((Yr,HMR),map_CofirePol_YPH(Yr,PPAR,HMR)) and SimYrFull(YrFull)>%UI_FxCap%)=-INF;
$endif.cofire
**----------------------------------------------------------------------------------------------------------



*National Carbon Cap
$ifthenE.ccap SameAs('%UI_CCap%',Yes)
*--------------------------------------------------------
map_EmisPol_YPH(Yr,'Nat',HMR)=YES;
map_EmisPol_YPHM(Yr,'Nat',HMR,MP)=YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'Nat',HMR) and EmisPolMP(MP) );

*EmisCap('Yr0','Nat','s1') =  sum(HMR,EmisHist('Yr0',HMR,'CO2'));
EmisCap('Yr4','Nat','s1') =  1800;
EmisCap('Yr11','Nat','s1') =   (2282 * MtSt * 0.2);
EmisCap(YrFull,'Nat','s1')$(SimYrFull(YrFull)>2019 and SimYrFull(YrFull)<2030) = EmisCap('Yr4','Nat','s1') + ((EmisCap('Yr4','Nat','s1') - EmisCap('Yr11','Nat','s1'))*(SimYrFull(YrFull)-2023)/(2023-2030));
EmisCap(YrFull,'Nat','s1')$(SimYrFull(YrFull)>2030) = EmisCap('Yr11','Nat','s1') + ((EmisCap('Yr11','Nat','s1') - (2282 * MtSt * 0))*(SimYrFull(YrFull)-2030)/(2030-2050));

$ifthen.RefCap  %UI_RefCap% == Yes
EmisCap(YrFull,'Nat','s1') = EmisRefFull(YrFull,'Nat');
$endif.RefCap

EmisCapNom(YrFull,'Nat')= EmisCap(YrFull,'Nat','s1');

*unfix allowance price to turn on the equation
AlwPrc.up(Yr,'Nat')$(SimYr(Yr)>=2023)=+INF;
AlwPrc.lo(Yr,'Nat')$(SimYr(Yr)>=2023)=-INF;

ACAlwPrc(Yr,'Nat','s1') = 5000;
ACAlw.up(Yr,'Nat',HMR,'s1') = +Inf;
*AlwPrcBank.up(Yr,'Nat')$(SimYr(Yr)>=2022)=+INF;
*AlwPrcBank.lo(Yr,'Nat')$(SimYr(Yr)>=2022)=-INF;
*EmisBankStartYr('Nat') = smin(Yr,(SimYr(Yr)$(AlwPrcBank.up(Yr,'Nat')>AlwPrcBank.lo(Yr,'Nat')) + SimYrLast$(AlwPrcBank.up(Yr,'Nat')=AlwPrcBank.lo(Yr,'Nat'))));
*smin(Yr,(SimYr(Yr)$(AlwPrcBank.up(Yr,PPAR)>AlwPrcBank.lo(Yr,PPAR)) + SimYrLast$(AlwPrcBank.up(Yr,PPAR)=AlwPrcBank.lo(Yr,PPAR))))
*AlwPrcBank.fx('Yr3','Nat')  =        12.5348902739128;
*AlwPrcBank.fx('Yr13','Nat') =        20.4180154144214;
*AlwPrcBank.fx('Yr26','Nat') =        38.5012132541463;
*AlwPrcBank.fx(Yr,'Nat')$(SimYr(Yr)>=2022)  = 12.5348902739128* (1 + betaRt)**(SimYr(Yr)-DataYr);
*AlwPrcBank.fx(Yr,'Nat') = 10.2268 * (1 + betaRt)**(SimYr(Yr)-DataYr);
*AlwPrc.fx(Yr,'Nat') = 10.2268 * (1 + betaRt)**(SimYr(Yr)-DataYr);

*AlwPrcBank.up(Yr,'Nat')=+INF;
*AlwPrcBank.lo(Yr,'Nat')=-INF;

*----------------------------------------------------------
$endif.ccap
**----------------------------------------------------------------------------------------------------------


$ifthen.CTaxRecon %UI_CTaxNat2021% == Yes

**---------------------------------------------------------------------------------------------------------
*set years for the tax
set
YrC(Yr)
;
YrC(Yr)=Yes$(SimYr(Yr)>=2023);

*set level of tax
AlwPrc.l('Yr8','Nat')  = 15;
AlwPrc.l('Yr9','Nat')  = 16;
AlwPrc.l('Yr10','Nat')  = 18;
AlwPrc.l('Yr11','Nat')  = 21;
AlwPrc.l(YrC,'Nat')$(SimYr(YrC) = 2027 )     =  25;
AlwPrc.l(YrC,'Nat')$(SimYr(YrC) >= 2028 )    = (30 +((SimYr(YrC)-2028)*10));

*Convert 2023 $/tonne estimates to 2015 $/short ton
AlwPrc.fx(YrC,'Nat')$(SimYr(YrC)>= 2023) = AlwPrc.l(YrC,'Nat') * (1/Inflation('2023'));

*turn on mapping for national PPAR
map_EmisPol_YPH(Yr,'Nat',HMR)= Yes;
map_EmisPol_YPHM(Yr,'Nat',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'Nat',HMR) and EmisPolMP(MP));
**----------------------------------------------------------------------------------------------------------

$elseif.CTaxRecon %UI_CTaxNat2021% == CTax15

**---------------------------------------------------------------------------------------------------------
*set years for the tax
set
YrC(Yr)
;
YrC(Yr)=Yes$(SimYr(Yr)>=2022);

*set level of tax
AlwPrc.fx('Yr3','Nat')  = 15;
AlwPrc.fx(YrC,'Nat')$(SimYr(YrC)>= 2022) = 15 * ((1.05)**(SimYr(YrC)-2022));

*turn on mapping for national PPAR
map_EmisPol_YPH(Yr,'Nat',HMR)= Yes;
map_EmisPol_YPHM(Yr,'Nat',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'Nat',HMR) and EmisPolMP(MP));
**----------------------------------------------------------------------------------------------------------

$elseif.CTaxRecon %UI_CTaxNat2021% == CTax10

**---------------------------------------------------------------------------------------------------------
*set years for the tax
set
YrC(Yr)
;
YrC(Yr)=Yes$(SimYr(Yr)>=2023);

*set level of tax
AlwPrc.l('Yr8','Nat')  = 10;
AlwPrc.l(YrC,'Nat')$(SimYr(YrC)>= 2023) = 10 * ((1.05)**(SimYr(YrC)-2023));

*Convert 2023 $/tonne estimates to 2015 $/short ton
AlwPrc.fx(YrC,'Nat')$(SimYr(YrC)>= 2023) = AlwPrc.l(YrC,'Nat') * (1/Inflation('2023'));

*turn on mapping for national PPAR
map_EmisPol_YPH(Yr,'Nat',HMR)= Yes;
map_EmisPol_YPHM(Yr,'Nat',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'Nat',HMR) and EmisPolMP(MP));
**----------------------------------------------------------------------------------------------------------


$endif.CTaxRecon

*$offtext


*Colorado Carbon Tax
$ifthen.cotax not %UI_COTax%==0
**---------------------------------------------------------------------------------------------------------
*set level of tax
AlwPrc.fx(Yr,'CO')$(simYr(Yr)>=2022) = %UI_COTax% * (1/Inflation('2022'));

*turn on mapping for CO PPAR
map_EmisPol_YPH(Yr,'CO',HMR)= Yes$(HMR_CO(HMR));
map_EmisPol_YPHM(Yr,'CO',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'CO',HMR) and EmisPolMP(MP));
**----------------------------------------------------------------------------------------------------------
$endif.cotax
**----------------------------------------------------------------------------------------------------------


*VA Carbon Tax
$ifthen.VACap %UI_VACap% == Yes
**---------------------------------------------------------------------------------------------------------
*Unfix alowance price to set cap
AlwPrc.up(Yr,'VA')$(simYr(Yr)>=2022) = +Inf;
AlwPrc.lo(Yr,'VA')$(simYr(Yr)>=2022) = -Inf;

*turn on mapping for VA PPAR
map_EmisPol_YPH(Yr,'VA',HMR)= Yes$(HMR_VA(HMR));
map_EmisPol_YPHM(Yr,'VA',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'VA',HMR) and EmisPolMP(MP));

EmisCap(YrFull,'VA','s1') = sum(Fuel,EmisFuelHist('Yr0','VA',Fuel,'CO2')) - (sum(Fuel,EmisFuelHist('Yr0','VA',Fuel,'CO2')) - 0)*(SimYrFull(YrFull)-2020)/(2045-2020);
EmisCap(YrFull,'VA','s1')$(SimYrFull(YrFull)>=2045) = 0;
EmisCap(Yr,'VA','s1') = EmisCap(Yr,'VA','s1');
EmisCapNom(Yr,'VA') = EmisCap(Yr,'VA','s1');

$ifthen.res %UI_Func% == Res
AlwPrc.L(Yr,'VA')$sum(HMR,map_EmisPol_YPH(Yr,'VA',HMR))=    TmpAlwPrc(Yr,'VA');
$endif.res
**----------------------------------------------------------------------------------------------------------
$endif.VACap


$ifthen.MACap %UI_MACap% == Yes
**---------------------------------------------------------------------------------------------------------
*Unfix alowance price to set cap
AlwPrc.up(Yr,'MA')$(simYr(Yr)>=2022) = +Inf;
AlwPrc.lo(Yr,'MA')$(simYr(Yr)>=2022) = -Inf;

ACAlw.up(Yr,'MA','MA','s1')$(simYr(Yr)>=2022) = +Inf;

*turn on mapping for MA PPAR
map_EmisPol_YPH(Yr,'MA',HMR)= Yes$(HMR_MA(HMR));
map_EmisPol_YPHM(Yr,'MA',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'MA',HMR) and EmisPolMP(MP));

*the state level cap is 80% of 2018 levels by 2050
EmisCap(YrFull,'MA','s1') = 0;
EmisCap(YrFull,'MA','s2') = sum(Fuel,EmisFuelHist('Yr-1','MA',Fuel,'CO2')) - (sum(Fuel,EmisFuelHist('Yr-1','MA',Fuel,'CO2')) - (sum(Fuel,EmisFuelHist('Yr-1','MA',Fuel,'CO2'))*0.2))*(SimYrFull(YrFull)-2018)/(2050-2018);
EmisCapAllocStep(YrFull,'MA','MA','s1') = 0;
EmisCapAllocStep(YrFull,'MA','MA','s2') = sum(Fuel,EmisFuelHist('Yr-1','MA',Fuel,'CO2')) - (sum(Fuel,EmisFuelHist('Yr-1','MA',Fuel,'CO2')) - (sum(Fuel,EmisFuelHist('Yr-1','MA',Fuel,'CO2'))*0.2))*(SimYrFull(YrFull)-2018)/(2050-2018);
EmisCapNom(YrFull,'MA') = EmisCap(YrFull,'MA','s2');

$ifthen.res %UI_Func% == Res
AlwPrc.L(Yr,'MA')$sum(HMR,map_EmisPol_YPH(Yr,'MA',HMR))=    TmpAlwPrc(Yr,'MA');
$endif.res
**----------------------------------------------------------------------------------------------------------
$endif.MACap


*California Carbon Cap
**---------------------------------------------------------------------------------------------------------

$ifthen.cacap %UI_CACap%==Yes

*MultiSector Representation
$ifthen.CASector %UI_CASector% == Yes

parameter EmisSect0(YrFull,Sector,Scenario);

$call gdxxrw.exe "EmisSect0_%UI_vCARB%.xlsx" par=EmisSect0 rdim=3 rng=sheet1!A2:D621 output = "EmisSect0_%UI_vCARB%.gdx"
$gdxin "EmisSect0_%UI_vCARB%.gdx"
$load EmisSect0
$gdxin

$ifthen.CALDVEmis1 %UI_CALDV% == Yes

*Initialize Vehicle Stock for years before constraint is active
Veh.fx(Yr,'CA',VehClass,VehType)$(SimYr(Yr) <= %UI_FxGen%)       = Veh0(Yr,VehClass,VehType,'%UI_CAScen%');
Veh.l(Yr,'CA',VehClass,VehType)                                  = Veh0(Yr,VehClass,VehType,'%UI_CAScen%');

*Set MPV variable to initial MPV
MPV(Yr,'CA',VehClass,VehType) = MPV0(Yr,VehClass,VehType,'%UI_CAScen%');

*Set VMT Demand
VMTDemand(Yr,'CA',VehClass)= VMT0(Yr,VehClass,'%UI_CAScen%');

*Portion of vehicle type within a class
ClassWgt(YrFull,VehClass,VehType)$(Veh0(YrFull,VehClass,VehType,'%UI_CAScen%')>0) =
                                                 Veh0(YrFull,VehClass,VehType,'%UI_CAScen%')/
                                                 (sum(VehTypedup,Veh0(YrFull,VehClass,VehTypedup,'%UI_CAScen%')$(Veh0(YrFull,VehClass,VehTypedup,'%UI_CAScen%')>0))) ;


SalesPct(Yr,VehClass,VehType)$(sum(VehTypedup,( Veh.l(Yr,'CA',VehClass,VehTypedup) - Veh.l(Yr - 1,'CA',VehClass,VehTypedup) - PlnVehRtr(Yr,'CA',VehClass,VehTypedup) ) ) > 0 ) =
                                         (Veh.l(Yr,'CA',VehClass,VehType) - Veh.l(Yr - 1,'CA',VehClass,VehType) - PlnVehRtr(Yr,'CA',VehClass,VehType))/
                                          sum(VehTypedup,( Veh.l(Yr,'CA',VehClass,VehTypedup) - Veh.l(Yr - 1,'CA',VehClass,VehTypedup) - PlnVehRtr(Yr,'CA',VehClass,VehTypedup) ) );


*Initialize VMT, Vehicle Sales, and Vehicle
VMT.l(Yr,'CA',VehClass,VehType) = VMTDemand(Yr,'CA',VehClass)*ClassWgt(Yr,VehClass,VehType);
VehSales.l(Yr,'CA',VehClass,VehType)$(MPV(Yr,'CA',VehClass,VehType) and MPV(Yr -1,'CA',VehClass,VehType)) =
                                                                         VMT.l(Yr,'CA',VehClass,VehType)/MPV(Yr,'CA',VehClass,VehType)
                                                                              - VMT.l(Yr - 1,'CA',VehClass,VehType)/MPV(Yr - 1,'CA',VehClass,VehType)
                                                                              - PlnVehRtr(Yr,'CA',VehClass,VehType);

*Veh.fx('Yr1','CA',VehClass,VehTech,VehFuel)      = Veh.l('Yr1','CA',VehClass,VehTech,VehFuel);

*Unfix Vehicle Stock and Sales for years after constraint is activated
Veh.up(Yr,'CA',VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)           = +INF;
Veh.lo(Yr,'CA',VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)           = 0;
VehSales.up(Yr,'CA',VehClass,VehType)$(SimYr(Yr -1) > %UI_FxGen%)   = +INF;
VehSales.lo(Yr,'CA',VehClass,VehType)$(SimYr(Yr -1) > %UI_FxGen%)   = 0;

parameter testVMT(Yr,VehClass,VehType);

testVMT(Yr,VehClass,VehType) =  VMT.l(Yr,'CA',VehClass,VehType) - MPV(Yr,'CA',VehClass,VehType)* Veh.l(Yr,'CA',VehClass,VehType);

VMT.up(Yr,'CA',VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)   = +INF;
VMT.lo(Yr,'CA',VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)   = 0;
VMT.fx(Yr,'CA',VehClass,VehType)$(SimYr(Yr) <= %UI_FxGen%)  = 0;


*Calculate ICE VMT for MPGe calculation
parameter tempICEVMT(YrFull,VehClass,VehType,Scenario);
tempICEVMT(YrFull,VehClass,VehType,Scenario)$(VehFuelEmis(VehType) and not VehFuelHybrid(VehType) )   = tempVMT(YrFull,VehClass,VehType,Scenario);
tempICEVMT(YrFull,VehClass,VehType,Scenario)$(VehFuelHybrid(VehType)) = tempVMT(YrFull,VehClass,VehType,Scenario)*(ZEVRatio/(ZEVRatio+1));

*Calculate MPG for each vehicle (split for PHEVs)
MPGe(YrFull,VehClass,VehType,Scenario)$(tempICEVMT(YrFull,VehClass,VehType,Scenario) > 0 and VehFuelEmis(VehType) and not VehFuelGas(VehType)) =  tempVMT(YrFull,VehClass,VehType,Scenario) / VehEnergy0(YrFull,VehClass,VehType,Scenario) ;
MPGe(YrFull,VehClass,VehType,Scenario)$(tempICEVMT(YrFull,VehClass,VehType,Scenario) > 0 and VehFuelGas(VehType)) =
                                                 ((tempVMT(YrFull,VehClass,VehType,Scenario))/
                                                 ((VehEnergy0(YrFull,VehClass,'Gas',Scenario))*
                                                         ((tempICEVMT(YrFull,VehClass,VehType,Scenario)$(VehFuelGas(VehType)))/(sum(VehTypedup,tempICEVMT(YrFull,VehClass,VehTypedup,Scenario)$(VehFuelGas(VehTypedup)))))));

display MPGe;
$ifthen.CALDVMPGScen %UI_CAEffScen% == 20pctEff2045

parameter MPGScale(YrFull);
MPGScale(YrFull) = 1;
MPGScale(YrFull)$(SimYrFull(YrFull)> 2025) = 1 + (SimYrFull(YrFull)-2025)*(.01);
MPGe(YrFull,'LDV',VehType,Scenario)$(tempICEVMT(YrFull,'LDV',VehType,Scenario) > 0 and VehFuelGas(VehType)) = MPGScale(YrFull) * MPGe(YrFull,'LDV',VehType,Scenario);
display MPGScale;
$endif.CALDVMPGScen


CO2perMi(YrFull,VehClass,VehType,Scenario) = 0;
CO2perMi(YrFull,VehClass,VehType,Scenario)$(VehFuelGas(VehType) and MPGe(YrFull,VehClass,VehType,Scenario) > 0) = (1/907.1847)* 8.02 *(1/MPGe(YrFull,VehClass,VehType,Scenario)); !! (ton/lb) x (lb/gal) x (gal/mi)     or (ton/kg) x (kg/gal) x (gal/mi)
CO2perMi(YrFull,VehClass,'Diesel',Scenario)$(MPGe(YrFull,VehClass,'Diesel',Scenario) > 0) = (1/907.1847)*10.15*(1/MPGe(YrFull,VehClass,'Diesel',Scenario)); !! (ton/lb) x (lb/gal) x (gal/mi)     or (ton/kg) x (kg/gal) x (gal/mi)
CO2perMi(YrFull,VehClass,'CNG',Scenario)$(MPGe(YrFull,VehClass,'CNG',Scenario) > 0)  =  (1/2000)*(1/120.96)*(1000)*(1/MPGe(YrFull,VehClass,'Diesel',Scenario)); !! (ton/mi) = (ton/lb)*(lb/k ft^3) * (k ft^3/ft^3) *(ft^3/mi)

CO2perMi(YrFull,VehClass,VehType,Scenario) = CO2perMi(YrFull,VehClass,VehType,Scenario) / 1000000;
EmisSect0(Yr,'EVs','%UI_CAScen%')$(SimYr(Yr) > %UI_FxGen%) = EmisSect0(Yr,'EVs','%UI_CAScen%')
                                                             - sum((VehClass,VehType),CO2perMi(Yr,VehClass,VehType,'%UI_CAScen%')* VMT.l(Yr,'CA',VehClass,VehType));

EmisSect0(Yr,'EVs','%UI_CAScen%')$(SimYr(Yr) > %UI_FxGen% and EmisSect0(Yr,'EVs','%UI_CAScen%') < 0.1) = 0;
display CO2perMi;
display EmisSect0;


put dummy;
put_utility 'gdxout' / 'Transport.gdx';
execute_unload testVMT, VMT, Veh, Veh0, VehSales, VehSales0, VehRtr0, PlnVehRtr, MPGe, CO2perMi, EmisSect0;

*ZEV Adjustment
SalesPct(Yr,'LDV','Elec')$(SimYr(Yr) >= %UI_ZEV% and SalesPct(Yr,'LDV','Gas') > 0)  =  SalesPct(Yr,'LDV','Elec') + (SalesPct(Yr,'LDV','Gas') * (ZEVRatio/(ZEVRatio+1)));
SalesPct(Yr,'LDV','PHEV')$(SimYr(Yr) >= %UI_ZEV% and SalesPct(Yr,'LDV','Gas') > 0)  =  SalesPct(Yr,'LDV','PHEV') + (SalesPct(Yr,'LDV','Gas') * (1/(ZEVRatio+1)));
SalesPct(Yr,'LDV','Gas')$(SimYr(Yr) >= %UI_ZEV%) = 0;

*Need to think about how to decrease this over time

display SalesPct;

$endif.CALDVEmis1


$ifthen.CALDVEmisScen %UI_CAVMTScen% == VMTBAU


*Set VMT Demand and MPV to BAU levels
VMTDemand(Yr,'CA',VehClass)= VMT0(Yr,VehClass,'BAU');
MPV(Yr,'CA',VehClass,VehType) = MPV0(Yr,VehClass,VehType,'BAU');

*Initialize Vehicle Sales
VehSales.l(Yr,'CA',VehClass,VehType)$(MPV(Yr,'CA',VehClass,VehType) and MPV(Yr -1,'CA',VehClass,VehType)) =
                                                                         VMT.l(Yr,'CA',VehClass,VehType)/MPV(Yr,'CA',VehClass,VehType)
                                                                              - VMT.l(Yr - 1,'CA',VehClass,VehType)/MPV(Yr - 1,'CA',VehClass,VehType)
                                                                              - PlnVehRtr(Yr,'CA',VehClass,VehType);

Veh.up(Yr,'CA',VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)           = +INF;
Veh.lo(Yr,'CA',VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)           = 0;
VehSales.up(Yr,'CA',VehClass,VehType)$(SimYr(Yr -1) > %UI_FxGen%)   = +INF;
VehSales.lo(Yr,'CA',VehClass,VehType)$(SimYr(Yr -1) > %UI_FxGen%)   = 0;
VMT.up(Yr,'CA',VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%)   = +INF;
VMT.l(Yr,'CA',VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%) = VMTDemand(Yr,'CA',VehClass)*ClassWgt(Yr,VehClass,VehType);
VMT.lo(Yr,'CA',VehClass,VehType)$(SimYr(Yr) > %UI_FxGen%) = 0;

$endif.CALDVEmisScen


$ifthen.CAFSC %UI_CAAdj% == CAFSC

EmisSect0('Yr5','Ind','%UI_CAScen%')  =  EmisSect0('Yr5','Ind','%UI_CAScen%')  - 1.61 * MtSt;
EmisSect0('Yr6','Ind','%UI_CAScen%')  =  EmisSect0('Yr6','Ind','%UI_CAScen%')  - 1.53 * MtSt;
EmisSect0('Yr7','Ind','%UI_CAScen%')  =  EmisSect0('Yr7','Ind','%UI_CAScen%')  - 1.46 * MtSt;
EmisSect0('Yr8','Ind','%UI_CAScen%')  =  EmisSect0('Yr8','Ind','%UI_CAScen%')  - 1.38 * MtSt;
EmisSect0('Yr9','Ind','%UI_CAScen%')  =  EmisSect0('Yr9','Ind','%UI_CAScen%')  - 1.30 * MtSt;
EmisSect0('Yr10','Ind','%UI_CAScen%') =  EmisSect0('Yr10','Ind','%UI_CAScen%') - 1.23 * MtSt;
EmisSect0('Yr11','Ind','%UI_CAScen%') =  EmisSect0('Yr11','Ind','%UI_CAScen%') - 1.15 * MtSt;
EmisSect0('Yr12','Ind','%UI_CAScen%') =  EmisSect0('Yr12','Ind','%UI_CAScen%') - 1.11 * MtSt;
EmisSect0('Yr13','Ind','%UI_CAScen%') =  EmisSect0('Yr13','Ind','%UI_CAScen%') - 1.07 * MtSt;
EmisSect0('Yr14','Ind','%UI_CAScen%') =  EmisSect0('Yr14','Ind','%UI_CAScen%') - 1.03 * MtSt;
EmisSect0('Yr15','Ind','%UI_CAScen%') =  EmisSect0('Yr15','Ind','%UI_CAScen%') - 1.00 * MtSt;
EmisSect0('Yr16','Ind','%UI_CAScen%') =  EmisSect0('Yr16','Ind','%UI_CAScen%') - 0.96 * MtSt;
EmisSect0('Yr17','Ind','%UI_CAScen%') =  EmisSect0('Yr17','Ind','%UI_CAScen%') - 0.92 * MtSt;
EmisSect0('Yr18','Ind','%UI_CAScen%') =  EmisSect0('Yr18','Ind','%UI_CAScen%') - 0.88 * MtSt;
EmisSect0('Yr19','Ind','%UI_CAScen%') =  EmisSect0('Yr19','Ind','%UI_CAScen%') - 0.84 * MtSt;
EmisSect0('Yr20','Ind','%UI_CAScen%') =  EmisSect0('Yr20','Ind','%UI_CAScen%') - 0.80 * MtSt;
EmisSect0('Yr21','Ind','%UI_CAScen%') =  EmisSect0('Yr21','Ind','%UI_CAScen%') - 0.76 * MtSt;
EmisSect0('Yr22','Ind','%UI_CAScen%') =  EmisSect0('Yr22','Ind','%UI_CAScen%') - 0.73 * MtSt;
EmisSect0('Yr23','Ind','%UI_CAScen%') =  EmisSect0('Yr23','Ind','%UI_CAScen%') - 0.69 * MtSt;
EmisSect0('Yr24','Ind','%UI_CAScen%') =  EmisSect0('Yr24','Ind','%UI_CAScen%') - 0.65 * MtSt;
EmisSect0('Yr25','Ind','%UI_CAScen%') =  EmisSect0('Yr25','Ind','%UI_CAScen%') - 0.61 * MtSt;
EmisSect0('Yr26','Ind','%UI_CAScen%') =  EmisSect0('Yr26','Ind','%UI_CAScen%') - 0.57 * MtSt;


$endif.CAFSC

*Other sectors
EmisSector0(Yr,'CA',Sector) = EmisSect0(Yr, Sector, '%UI_CAScen%')*1E3;



$ifthen.ind %UI_CAInd% == Yes
*make industry elastic
AbatementElasticity(Yr,'CA','Ind') = 0.005;
CrossElasticity(Yr,'CA','Ind') = 0.001;
ConsPerEmisAbate(Yr,'CA','Ind')$(EmisSector0(Yr,'CA','Ind')<>0) = (CrossElasticity(Yr,'CA','Ind') * Cons0(Yr,'CA','Ind'))/ (AbatementElasticity(Yr,'CA','Ind') * EmisSector0(Yr,'CA','Ind'));
EmisAbatement.up(Yr,'CA','Ind',stepAbate)$(SimYr(Yr)>%UI_FxGen%) = +Inf;
AbatementStepMax(Yr,'CA','Ind',stepAbate)$(EmisSector0(Yr,'CA','Ind')<>0) = AbatementElasticity(Yr,'CA','Ind') * EmisSector0(Yr,'CA','Ind');
AbatementPrice(Yr,'CA','Ind',stepAbate)$(EmisSector0(Yr,'CA','Ind')<>0) = (10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012)) + ord(stepAbate);
$endif.ind

$ifthen.ind %UI_CABuilding% == Yes
*make buildings elastic
AbatementElasticity(Yr,'CA','Res') = 0.0027;
CrossElasticity(Yr,'CA','Res') = 0.001;
ConsPerEmisAbate(Yr,'CA','Res')$(EmisSector0(Yr,'CA','Res')<>0) = (CrossElasticity(Yr,'CA','Res') * Cons0(Yr,'CA','Res'))/ (AbatementElasticity(Yr,'CA','Res') * EmisSector0(Yr,'CA','Res'));
EmisAbatement.up(Yr,'CA','Res',stepAbate)$(SimYr(Yr)>%UI_FxGen%) = +Inf;
AbatementStepMax(Yr,'CA','Res',stepAbate)$(EmisSector0(Yr,'CA','Res')<>0) = AbatementElasticity(Yr,'CA','Res') * EmisSector0(Yr,'CA','Res');
AbatementPrice(Yr,'CA','Res',stepAbate)$(EmisSector0(Yr,'CA','Res')<>0) = (10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012)) + ord(stepAbate);
$endif.ind

$endif.CASector

EmisRefFull('Yr0','CA')  = 473.854369;   !! Real world allowances offered (free + real)
EmisRefFull('Yr1','CA')  = 388.573046;   !! Real world allowances offered (free + real)
EmisRefFull('Yr2','CA')  = 414.569018;   !! Real world allowances offered (free + real)
EmisRefFull('Yr3','CA')  = 381.574619;   !! Real world allowances offered (free + real)
EmisRefFull('Yr26','CA') = 0; !! Net Zero by 2045
*set cap reference level
$ifthen.CACapGoal %UI_CA2030Cap% == 2020_60pct

*40% below 2020 levels by 2030
EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2022) = EmisRefFull('Yr1','CA')*(1 - (0.04*(SimYrFull(YrFull)-SimYrFull('Yr1'))));
EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2045) = 0;

$elseif.CACapGoal %UI_CA2030Cap% == 1990_60pct
*40% below 1990 levels by 2030
EmisRefFull('Yr11','CA') = .6*484*MtSt;

EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2022 and SimYrFull(YrFull) < 2030)
                         =  EmisRefFull('Yr11','CA')
                            + ((SimYrFull(YrFull)-2030) *
                                 ((EmisRefFull('Yr11','CA') - EmisRefFull('Yr3','CA'))
                                   /(SimYrFull('Yr11')-SimYrFull('Yr3'))));


EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2030 and SimYrFull(YrFull) < 2045)
                         =  EmisRefFull('Yr26','CA')
                            + ((SimYrFull(YrFull)-2045) *
                                 ((EmisRefFull('Yr26','CA') - EmisRefFull('Yr11','CA'))
                                   /(SimYrFull('Yr26')-SimYrFull('Yr11'))));

EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2045) = 0;

$elseif.CACapGoal %UI_CA2030Cap% == 1990_52pct
*48% below 1990 levels by 2030
EmisRefFull('Yr11','CA') = .52*484*MtSt;

EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2022 and SimYrFull(YrFull) < 2030)
                         =  EmisRefFull('Yr11','CA')
                            + ((SimYrFull(YrFull)-2030) *
                                 ((EmisRefFull('Yr11','CA') - EmisRefFull('Yr3','CA'))
                                   /(SimYrFull('Yr11')-SimYrFull('Yr3'))));


EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2030 and SimYrFull(YrFull) < 2045)
                         =  EmisRefFull('Yr26','CA')
                            + ((SimYrFull(YrFull)-2045) *
                                 ((EmisRefFull('Yr26','CA') - EmisRefFull('Yr11','CA'))
                                   /(SimYrFull('Yr26')-SimYrFull('Yr11'))));

EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2045) = 0;

$elseif.CACapGoal %UI_CA2030Cap% == AlwBudget

EmisRefFull('Yr3','CA')  = 307.5 * MtSt;
EmisRefFull('Yr4','CA')  = 294.1 * MtSt;
EmisRefFull('Yr5','CA')  = 280.7 * MtSt;
EmisRefFull('Yr6','CA')  = 267.4 * MtSt;
EmisRefFull('Yr7','CA')  = 254.0 * MtSt;
EmisRefFull('Yr8','CA')  = 240.6 * MtSt;
EmisRefFull('Yr9','CA')  = 227.3 * MtSt;
EmisRefFull('Yr10','CA') = 213.9 * MtSt;
EmisRefFull('Yr11','CA') = 200.5 * MtSt;
EmisRefFull('Yr12','CA') = 193.8 * MtSt;
EmisRefFull('Yr26','CA') = 0;

EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2031 and SimYrFull(YrFull) < 2045)
                         =  EmisRefFull('Yr26','CA')
                            + ((SimYrFull(YrFull)-2045) *
                                 ((EmisRefFull('Yr26','CA') - EmisRefFull('Yr12','CA'))
                                   /(SimYrFull('Yr26')-SimYrFull('Yr12'))));

EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2045) = 0;

$else.CACapGoal

EmisRefFull('Yr0','CA')= EmisHist('Yr0','CA','CO2') + sum(Sector,(EmisSector0('Yr0','CA',Sector)/1E3));
EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2020)= EmisRefFull('Yr0','CA')*(1 - (0.04*(SimYrFull(YrFull)-SimYrFull('Yr1'))));

$endif.CACapGoal


display EmisRefFull;

$ifthen.CAAdj %UI_CAAdj% == Prog
EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull) >= 2025 and SimYrFull(YrFull) <= 2031) = EmisRefFull(YrFull,'CA') - 4*MtSt*(SimYrFull(YrFull)-2025);
EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2031 and SimYrFull(YrFull) < 2045)
                         =  EmisRefFull('Yr26','CA')
                            + ((SimYrFull(YrFull)-2045) *
                                 ((EmisRefFull('Yr26','CA') - EmisRefFull('Yr12','CA'))
                                   /(SimYrFull('Yr26')-SimYrFull('Yr12'))));

$elseif.CAAdj %UI_CAAdj% == CAFSC
EmisRefFull('Yr5','CA')  = EmisRefFull('Yr5','CA')  - 2.01*MtSt;
EmisRefFull('Yr6','CA')  = EmisRefFull('Yr6','CA')  - 1.91*MtSt;
EmisRefFull('Yr7','CA')  = EmisRefFull('Yr7','CA')  - 1.82*MtSt;
EmisRefFull('Yr8','CA')  = EmisRefFull('Yr8','CA')  - 1.72*MtSt;
EmisRefFull('Yr9','CA')  = EmisRefFull('Yr9','CA')  - 1.63*MtSt;
EmisRefFull('Yr10','CA') = EmisRefFull('Yr10','CA') - 1.53*MtSt;
EmisRefFull('Yr11','CA') = EmisRefFull('Yr11','CA') - 1.44*MtSt;
EmisRefFull('Yr12','CA') = EmisRefFull('Yr12','CA') - 1.39*MtSt;
EmisRefFull('Yr13','CA') = EmisRefFull('Yr13','CA') - 1.34*MtSt;
EmisRefFull('Yr14','CA') = EmisRefFull('Yr14','CA') - 1.29*MtSt;
EmisRefFull('Yr15','CA') = EmisRefFull('Yr15','CA') - 1.24*MtSt;
EmisRefFull('Yr16','CA') = EmisRefFull('Yr16','CA') - 1.20*MtSt;
EmisRefFull('Yr17','CA') = EmisRefFull('Yr17','CA') - 1.15*MtSt;
EmisRefFull('Yr18','CA') = EmisRefFull('Yr18','CA') - 1.10*MtSt;
EmisRefFull('Yr19','CA') = EmisRefFull('Yr19','CA') - 1.05*MtSt;
EmisRefFull('Yr20','CA') = EmisRefFull('Yr20','CA') - 1.00*MtSt;
EmisRefFull('Yr21','CA') = EmisRefFull('Yr21','CA') - 0.96*MtSt;
EmisRefFull('Yr22','CA') = EmisRefFull('Yr22','CA') - 0.91*MtSt;
EmisRefFull('Yr23','CA') = EmisRefFull('Yr23','CA') - 0.86*MtSt;
EmisRefFull('Yr24','CA') = EmisRefFull('Yr24','CA') - 0.81*MtSt;
EmisRefFull('Yr25','CA') = EmisRefFull('Yr25','CA') - 0.76*MtSt;
EmisRefFull('Yr26','CA') = EmisRefFull('Yr26','CA') - 0.72*MtSt;


$endif.CAAdj

*EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2020 and SimYrFull(YrFull)<=2030)= EmisRefFull('Yr0','CA')*(1 - (0.04*(SimYrFull(YrFull)-SimYrFull('Yr1'))));
*EmisRefFull(YrFull,'CA')$(SimYrFull(YrFull)>=2030) = EmisRefFull('Yr11','CA');
EmisRefFull(YrFull,'CA')$(EmisRefFull(YrFull,'CA')<0)= 0;


display EmisRefFull;

*turn on mapping for CA PPAR
map_EmisPol_YPH(Yr,'CA',HMR)= Yes$(HMR_CA(HMR));
map_EmisPol_YPHM(Yr,'CA',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'CA',HMR) and EmisPolMP(MP));

$ifthen.ecr %UI_CAStep% == ECR

*        floor
         EmisCap(YrFull,'CA','s1')= 0;
         ACAlw.up(Yr,'CA',HMR,'s1')$map_EmisPol_YPH(Yr,'CA',HMR) = +inf;
         ACAlwPrc(Yr,'CA','s1')     = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);

*        ecr
         EmisCap(YrFull,'CA','s2')= EmisRefFull(YrFull,'CA')*0.95;
         ACAlw.up(Yr,'CA',HMR,'s2')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s2')$(SimYr(Yr) >= 2021)
                                    = ((10*(1/Inflation('2012'))) + ((65*(1/Inflation('2021')))-(10*(1/Inflation('2012'))))*0.25) * MtSt * (1/0.95)**(SimYr(Yr)-2021);

*        ceiling
         EmisCap(YrFull,'CA','s3')= EmisRefFull(YrFull,'CA');
         ACAlw.up(Yr,'CA',HMR,'s3')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s3')$(SimYr(Yr) >= 2021)
                                    = 65 * MtSt * (1/Inflation('2021')) * (1/0.95)**(SimYr(Yr)-2021);

*        set nominal cap
         EmisCapNom(YrFull,'CA')= EmisCap(YrFull,'CA','s3');

$elseif.ecr %UI_CAStep% == ECRCCR

*        floor
         EmisCap(YrFull,'CA','s1')= 0;
         ACAlw.up(Yr,'CA',HMR,'s1')$map_EmisPol_YPH(Yr,'CA',HMR) = +inf;
         ACAlwPrc(Yr,'CA','s1')     = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);

*        ecr
         EmisCap(YrFull,'CA','s2')= EmisRefFull(YrFull,'CA')*0.95;
         ACAlw.up(Yr,'CA',HMR,'s2')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s2')$(SimYr(Yr) >= 2021)
                                    = ((10*(1/Inflation('2012'))) + ((65*(1/Inflation('2021')))-(10*(1/Inflation('2012'))))*0.25) * MtSt * (1/0.95)**(SimYr(Yr)-2021);
*        CCR1
         EmisCap(YrFull,'CA','s3')= EmisRefFull(YrFull,'CA');
         ACAlw.up(Yr,'CA',HMR,'s3')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s3')$(SimYr(Yr) >= 2021)
                                    = ((10*(1/Inflation('2012'))) + ((65*(1/Inflation('2021')))-(10*(1/Inflation('2012'))))*0.5) * MtSt * (1/0.95)**(SimYr(Yr)-2021);

*        CCR2
         EmisCap(YrFull,'CA','s4')= EmisRefFull(YrFull,'CA')*1.05;
         ACAlw.up(Yr,'CA',HMR,'s4')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s4')$(SimYr(Yr) >= 2021)
                                    = ((10*(1/Inflation('2012'))) + ((65*(1/Inflation('2021')))-(10*(1/Inflation('2012'))))*0.75) * MtSt * (1/0.95)**(SimYr(Yr)-2021);

*        ceiling
         EmisCap(YrFull,'CA','s5')= EmisRefFull(YrFull,'CA')*1.1;
         ACAlw.up(Yr,'CA',HMR,'s5')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s5')$(SimYr(Yr) >= 2021)
                                    = 65 * MtSt * (1/Inflation('2021')) * (1/0.95)**(SimYr(Yr)-2021);

*        set nominal cap
         EmisCapNom(YrFull,'CA')= EmisCap(YrFull,'CA','s3');

$elseif.ecr %UI_CAStep% == CCR

*        floor
         EmisCap(YrFull,'CA','s1')= 0;
         ACAlw.up(Yr,'CA',HMR,'s1')$map_EmisPol_YPH(Yr,'CA',HMR) = +inf;
         ACAlwPrc(Yr,'CA','s1')     = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);

*        CCR1
         EmisCap(YrFull,'CA','s2')= EmisRefFull(YrFull,'CA');
         ACAlw.up(Yr,'CA',HMR,'s2')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s2')$(SimYr(Yr) >= 2021)
                                    = ((10*(1/Inflation('2012'))) + ((65*(1/Inflation('2021')))-(10*(1/Inflation('2012'))))*0.5) * MtSt * (1/0.95)**(SimYr(Yr)-2021);

*        CCR2
         EmisCap(YrFull,'CA','s3')= EmisRefFull(YrFull,'CA')*1.05;
         ACAlw.up(Yr,'CA',HMR,'s3')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s3')$(SimYr(Yr) >= 2021)
                                    = ((10*(1/Inflation('2012'))) + ((65*(1/Inflation('2021')))-(10*(1/Inflation('2012'))))*0.75) * MtSt * (1/0.95)**(SimYr(Yr)-2021);

*        Ceiling
         EmisCap(YrFull,'CA','s4')= EmisRefFull(YrFull,'CA')*1.1;
         ACAlw.up(Yr,'CA',HMR,'s4')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s4')$(SimYr(Yr) >= 2021)
                                    = 65 * MtSt * (1/Inflation('2021')) * (1/0.95)**(SimYr(Yr)-2021);

*        set nominal cap
         EmisCapNom(YrFull,'CA')= EmisCap(YrFull,'CA','s2');

$elseif.ecr %UI_CAStep% == StandardLim

*        floor
         EmisCap(YrFull,'CA','s1')= 0;
         ACAlw.up(Yr,'CA',HMR,'s1')$map_EmisPol_YPH(Yr,'CA',HMR) = +inf;
         ACAlwPrc(Yr,'CA','s1')     = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);

*        ceiling
         EmisCap(YrFull,'CA','s2')= EmisRefFull(YrFull,'CA');
         ACAlw.up(Yr,'CA',HMR,'s2')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s2')$(SimYr(Yr) >= 2021)
                                    = 65 * MtSt * (1/Inflation('2021')) * (1/0.95)**(SimYr(Yr)-2021);
*        ceiling limit
         EmisCap(YrFull,'CA','s3')= sum((Yr,Sector),EmisSector0(Yr,'CA',Sector)*SimYrWgtKnl(YrFull,Yr)/1000) + 50 ;

*        set nominal cap
         EmisCapNom(YrFull,'CA')= EmisCap(YrFull,'CA','s2');

$else.ecr

*        floor
         EmisCap(YrFull,'CA','s1')= 0;
         ACAlw.up(Yr,'CA',HMR,'s1')$map_EmisPol_YPH(Yr,'CA',HMR) = +inf;
         ACAlwPrc(Yr,'CA','s1')     = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);

*        ceiling
         EmisCap(YrFull,'CA','s2')= EmisRefFull(YrFull,'CA');
         ACAlw.up(Yr,'CA',HMR,'s2')$(map_EmisPol_YPH(Yr,'CA',HMR) and (SimYr(Yr) >= 2021)) = +inf;
         ACAlwPrc(Yr,'CA','s2')$(SimYr(Yr) >= 2021)
                                    = 65 * MtSt * (1/Inflation('2021')) * (1/0.95)**(SimYr(Yr)-2021);

*        set nominal cap
         EmisCapNom(YrFull,'CA')= EmisCap(YrFull,'CA','s2');

$endif.ecr

*set initial value for AlwPrc
AlwPrc.fx(Yr,'CA') = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);

*turn on cap equation
AlwPrc.up(Yr,'CA')$(SimYr(Yr)>%UI_FxGen%) = +Inf;
AlwPrc.l(Yr,'CA')$(SimYr(Yr)>%UI_FxGen%) = 0;
AlwPrc.lo(Yr,'CA')$(SimYr(Yr)>%UI_FxGen%) = -Inf;

*decide whether to run CA as a tax
$ifthen.catax %UI_CAfloor%==Yes
AlwPrc.fx(Yr,'CA') = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);
$endif.catax

*decide whether to include imported electricity emissions under the cap
$ifthen.caimp %UI_CAImp%==Yes
PriceImports('CA') = 1;
$endif.caimp

$ifthen.caBank %UI_CABank%==Yes
AlwPrc.fx(Yr,'CA')$(SimYr(Yr)<=%UI_FxGen%) = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);
AlwPrc.fx(Yr,'CA')$(SimYr(Yr)>%UI_FxGen%) = 0;
AlwPrcBank.up(Yr,'CA')$(SimYr(Yr)>%UI_FxGen%)=+INF;
AlwPrcBank.lo(Yr,'CA')$(SimYr(Yr)>%UI_FxGen%)=-INF;
EmisBankStartYr('CA') = smin(Yr,(SimYr(Yr)$(AlwPrcBank.up(Yr,'CA')>AlwPrcBank.lo(Yr,'CA')) + SimYrLast$(AlwPrcBank.up(Yr,'CA')=AlwPrcBank.lo(Yr,'CA'))));

$elseif.caBank %UI_CABank%==DualTax

AlwPrc.fx('Yr0','CA')  =  16.5591420012031;
AlwPrc.fx('Yr1','CA')  =  17.4306757907401;
AlwPrc.fx('Yr3','CA')  =  19.3137681891857;
AlwPrc.fx('Yr4','CA')  =  69.8189500352499;
AlwPrc.fx('Yr6','CA')  =  77.3617174905816;
AlwPrc.fx('Yr9','CA')  =  90.2308995370539;
AlwPrc.fx('Yr11','CA') =  99.9788360521373;
AlwPrc.fx('Yr16','CA') =  129.208192146937;
AlwPrc.fx('Yr21','CA') =  166.982909354674;
AlwPrc.fx('Yr26','CA') =  215.801270439897;

$endif.caBank

$ifthen.bank0  %UI_CABank0%==Yes
Bank0('CA') = 321*MtSt;
$endif.bank0

$endif.cacap
**----------------------------------------------------------------------------------------------------------

$onText
parameter
CAEmisCap(Yr,step)
CAACAlwPrc(Yr,step)
CAACAlw(Yr,step)
;

CAEmisCap(Yr,step) = EmisCap(Yr,'CA',step);
CAACAlwPrc(Yr,step) = ACAlwPrc(Yr,'CA',step);
CAACAlw(Yr,step) = ACAlw.up(Yr,'CA','CA',step);

display
CAEmisCap
CAACAlwPrc
CAACAlw
;
$offText

*RGGI Scenarios
**------------------------------------------------------------------------------------------------

EmisCapAlloc('Yr0','RGGI9','CT') =  5.191324;
EmisCapAlloc('Yr0','RGGI9','DE') =  3.613361;
EmisCapAlloc('Yr0','RGGI9','ME') =  2.887571;
EmisCapAlloc('Yr0','RGGI9','MD') = 17.931922;
EmisCapAlloc('Yr0','RGGI9','MA') = 12.756508;
EmisCapAlloc('Yr0','RGGI9','NH') =  4.184333;
EmisCapAlloc('Yr0','RGGI9','NY') = 31.216182;
EmisCapAlloc('Yr0','RGGI9','RI') =  2.005354;
EmisCapAlloc('Yr0','RGGI9','VT') =  0.577390;

EmisCapAlloc('Yr1','RGGI10','CT') =  5.061540;
EmisCapAlloc('Yr1','RGGI10','DE') =  3.523027;
EmisCapAlloc('Yr1','RGGI10','ME') =  2.815382;
EmisCapAlloc('Yr1','RGGI10','MD') = 17.483623;
EmisCapAlloc('Yr1','RGGI10','MA') = 12.437596;
EmisCapAlloc('Yr1','RGGI10','NH') =  4.079725;
EmisCapAlloc('Yr1','RGGI10','NJ') = 18.000000;
EmisCapAlloc('Yr1','RGGI10','NY') = 30.435778;
EmisCapAlloc('Yr1','RGGI10','RI') =  1.955221;
EmisCapAlloc('Yr1','RGGI10','VT') =  0.562955;

EmisCapAlloc('Yr2','RGGI11','CT') =  4.860813;
EmisCapAlloc('Yr2','RGGI11','DE') =  3.383313;
EmisCapAlloc('Yr2','RGGI11','ME') =  2.733450;
EmisCapAlloc('Yr2','RGGI11','MD') = 16.790271;
EmisCapAlloc('Yr2','RGGI11','MA') = 11.944355;
EmisCapAlloc('Yr2','RGGI11','NH') =  3.960999;
EmisCapAlloc('Yr2','RGGI11','NJ') = 17.460000;
EmisCapAlloc('Yr2','RGGI11','NY') = 29.056270;
EmisCapAlloc('Yr2','RGGI11','RI') =  1.877683;
EmisCapAlloc('Yr2','RGGI11','VT') =  0.540630;
EmisCapAlloc('Yr2','RGGI11','VA') = 27.160000;

EmisCapAlloc('Yr4','RGGI12','CT') =  4.860813 * 0.94;
EmisCapAlloc('Yr4','RGGI12','DE') =  3.383313 * 0.94;
EmisCapAlloc('Yr4','RGGI12','ME') =  2.733450 * 0.94;
EmisCapAlloc('Yr4','RGGI12','MD') = 16.790271 * 0.94;
EmisCapAlloc('Yr4','RGGI12','MA') = 11.944355 * 0.94;
EmisCapAlloc('Yr4','RGGI12','NH') =  3.960999 * 0.94;
EmisCapAlloc('Yr4','RGGI12','NJ') = 17.460000 * 0.94;
EmisCapAlloc('Yr4','RGGI12','NY') = 29.056270 * 0.94;
EmisCapAlloc('Yr4','RGGI12','RI') =  1.877683 * 0.94;
EmisCapAlloc('Yr4','RGGI12','VT') =  0.540630 * 0.94;
EmisCapAlloc('Yr4','RGGI12','VA') = 27.160000 * 0.94;
EmisCapAlloc('Yr4','RGGI12','PA') = 75.510630;

$ifthenE.RGGI (SameAs('%UI_RGGI%','RGGI11'))
*------------------------------------------------------------------------------------------------
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-(0.03*(SimYrFull(YrFull)-2021)));
*EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2030) = EmisCapAlloc('Yr11','RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2030) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));

$ifthen.tighten     %UI_RGGItighten% == RGGI3pct4pct
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.01 * max(0,(SimYrFull(YrFull)-2023))));
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Stnd(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-(0.03*(SimYrFull(YrFull)-2021)));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
$elseif.tighten     %UI_RGGItighten% == RGGI3pt5
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.005 * max(0,(SimYrFull(YrFull)-2025))));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
$elseif.tighten     %UI_RGGItighten% == RGGI3pt5and0
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>=2026 and HMR_RGGI12Lead(HMR)) = Max(0,(((0-EmisCapAlloc('Yr7','RGGI11',HMR))/(2040-2026))*(SimYrFull(YrFull)-2040)));
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Stnd(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.005 * max(0,(SimYrFull(YrFull)-2025))));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
$elseif.tighten     %UI_RGGItighten% == RGGIzero
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>=2026) = Max(0,(((0-EmisCapAlloc('Yr7','RGGI11',HMR))/(2040-2026))*(SimYrFull(YrFull)-2040)));
$endif.tighten

*explicit RGGI11 cap that includes VA and NJ with backloaded RGGI9 and RGGI10 caps
EmisRefFull('Yr0','RGGI9')   = sum(HMR,EmisCapAlloc('Yr0','RGGI9',HMR));   !! 80.179708   !!  RGGI Adjusted Cap was 58.288301 (Adjusted cap might account for banking?)
EmisRefFull('Yr1','RGGI10')  = sum(HMR,EmisCapAlloc('Yr1','RGGI10',HMR));  !! 96.175215   !!  NJ enters RGGI (historical cap)  Adjusted Cap was 74.283807
EmisRefFull(YrFull,'RGGI11') = sum(HMR,EmisCapAlloc(YrFull,'RGGI11',HMR)); !! 119.767784  !!  VA enters RGGI

*set lowest price step cap to 0 so we can use the price foor
EmisCap(YrFull,'RGGI11','s1')=0;

EmisCapAllocStep(YrFull,'RGGI11',HMR,'s1') = 0;

*transfer everything from Ref to Cap
EmisCap('Yr0','RGGI9','s3')      = EmisRefFull('Yr0','RGGI9');
EmisCap('Yr1','RGGI10','s3')     = EmisRefFull('Yr1','RGGI10');
EmisCap(YrFull,'RGGI11','s3')    = EmisRefFull(YrFull,'RGGI11');

EmisCapAllocStep('Yr0','RGGI9',HMR,'s3') = EmisCapAlloc('Yr0','RGGI9',HMR);
EmisCapAllocStep('Yr1','RGGI10',HMR,'s3') = EmisCapAlloc('Yr1','RGGI10',HMR);
EmisCapAllocStep(YrFull,'RGGI11',HMR,'s3') = EmisCapAlloc(YrFull,'RGGI11',HMR);

*remove 10% to set the ECR
EmisCap(YrFull,'RGGI11','s2')$(SimYrFull(YrFull)>=2021)
                                 = EmisCap(YrFull,'RGGI11','s3')*0.9;

EmisCapAllocStep(YrFull,'RGGI11',HMR,'s2')$(SimYrFull(YrFull)>=2021)
                                 = EmisCapAllocStep(YrFull,'RGGI11',HMR,'s3')*0.9;

*add 10% to set the CCR
EmisCap(YrFull,'RGGI11','s4')$(SimYrFull(YrFull)>=2021)
                                 = EmisCap(YrFull,'RGGI11','s3')*1.1;

EmisCapAllocStep(YrFull,'RGGI11',HMR,'s4')$(SimYrFull(YrFull)>=2021)
                                 = EmisCapAllocStep(YrFull,'RGGI11',HMR,'s3')*1.1;

*save nominal cap
EmisCapNom('Yr0','RGGI9')      = EmisCap('Yr0','RGGI9','s3');
EmisCapNom('Yr1','RGGI10')     = EmisCap('Yr1','RGGI10','s3');
EmisCapNom(YrFull,'RGGI11')     = EmisCap(YrFull,'RGGI11','s3');


*Set price floors for regions by year
AlwPrc.fx(Yr,'RGGI9')$(SimYr(Yr)=2019)   = 2.26 * (1/Inflation('2019'));
AlwPrc.fx(Yr,'RGGI10')$(SimYr(Yr)=2020)  = 2.26 * (1/Inflation('2019'));

*unfix allowance price to turn on the equation because Bounds on allowance prices activate corresponding constraints.
AlwPrc.up(Yr,'RGGI11')$(SimYr(Yr)>=2021) = +INF;
AlwPrc.l(Yr,'RGGI11')$(SimYr(Yr)>=2021)    = 0;
AlwPrc.lo(Yr,'RGGI11')$(SimYr(Yr)>=2021) = -INF;

*unfix ACAlw and set ACAlwPrc to turn on steps
ACAlwPrc(Yr,'RGGI11','s1')$(SimYr(Yr)>=2021)    = 2.26 * (1/Inflation('2019'));
ACAlw.up(Yr,'RGGI11',HMR,'s1')$(map_EmisPol_YPH(Yr,'RGGI11',HMR) and (SimYr(Yr)>=2021))    = +Inf;
ACAlwPrc(Yr,'RGGI11','s2')$(SimYr(Yr)>=2021)    = 6 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI11',HMR,'s2')$(map_EmisPol_YPH(Yr,'RGGI11',HMR) and (SimYr(Yr)>=2021))    = +Inf;
ACAlwPrc(Yr,'RGGI11','s3')$(SimYr(Yr)>=2021)    = 13 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI11',HMR,'s3')$(map_EmisPol_YPH(Yr,'RGGI11',HMR) and (SimYr(Yr)>=2021))    = +Inf;
ACAlwPrc(Yr,'RGGI11','s4')$(SimYr(Yr)>=2021)    = 500 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI11',HMR,'s4')$(map_EmisPol_YPH(Yr,'RGGI11',HMR) and (SimYr(Yr)>=2021))    = +Inf;

*refix everything for all years if we are on the price floor in the calibrator
$ifthenE.floor SameAs('%UI_RGGIfloor%','YES')
*AlwPrc.fx(Yr,'RGGI11')$(SimYr(Yr)>=2021) = 2.26 * (1/Inflation('2019'));

*this is an alternate price path for RGGI11 representative of current RGGI11 prices
*AlwPrc.fx(Yr,'RGGI11')$(SimYr(Yr)>=2021)= 6.88 * (1/Inflation('2019')) * ((1.05)**(SimYr(Yr)-2021));
AlwPrc.fx(Yr,'RGGI11')$(SimYr(Yr)>=2021)= 13 * (1/Inflation('2019')) * ((1.05)**(SimYr(Yr)-2021));
$endif.floor

$ifthen.RGGIBank %UI_RGGIBank%==Yes
*AlwPrc.fx(Yr,'RGGI11')$(SimYr(Yr)<=%UI_FxGen%) = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);
AlwPrc.fx(Yr,'RGGI11')$(SimYr(Yr)>%UI_FxGen%) = 0;
AlwPrcBank.up(Yr,'RGGI11')$(SimYr(Yr)>%UI_FxGen%)=+INF;
AlwPrcBank.lo(Yr,'RGGI11')$(SimYr(Yr)>%UI_FxGen%)=-INF;
EmisBankStartYr('RGGI11') = smin(Yr,(SimYr(Yr)$(AlwPrcBank.up(Yr,'RGGI11')>AlwPrcBank.lo(Yr,'RGGI11')) + SimYrLast$(AlwPrcBank.up(Yr,'RGGI11')=AlwPrcBank.lo(Yr,'RGGI11'))));
$endif.RGGIBank

$ifthen.ExRate %UI_ExRate% == Yes
ExchangeRate(Yr,'RGGI11',HMR)$(HMR_RGGI12Lead(HMR) and SimYr(Yr) >=2025) = 2;
$endif.ExRate

$ifthen.EnhComp %UI_EnhComp% == Yes
EnhancedComp(Yr,'RGGI11',HMR)$(HMR_RGGI12Lead(HMR) and SimYr(Yr) >=2025) = 2;
$endif.EnhComp


$ifthen.res %UI_Func% == Res
AlwPrc.L(Yr,PPAR)$sum(HMR,map_EmisPol_YPH(Yr,PPAR,HMR))=    TmpAlwPrc(Yr,PPAR);
$endif.res
    
*ExchangeRate(Yr,'RGGI11','NY')$(SimYr(Yr)>=2021) = 2;

**------------------------------------------------------------------------------------------------


$elseifE.RGGI (SameAs('%UI_RGGI%','RGGI12'))
*----------------------------------------------------------------------------------------------------------------------------
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-(0.03*(SimYrFull(YrFull)-2021)));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12',HMR)$(SimYrFull(YrFull)>=2023 and (not HMR_PA(HMR))) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12','PA')$(SimYrFull(YrFull)>=2023) = EmisCapAlloc('Yr4','RGGI12','PA') - (2.489370 * (SimYrFull(YrFull)-2023));

$ifthen.tighten     %UI_RGGItighten% == RGGI3pct4pct
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.01 * max(0,(SimYrFull(YrFull)-2023))));
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Stnd(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-(0.03*(SimYrFull(YrFull)-2021)));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12',HMR)$(SimYrFull(YrFull)>=2023 and (not HMR_PA(HMR))) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12','PA')$(SimYrFull(YrFull)>=2023) = EmisCapAlloc('Yr4','RGGI12','PA') - (2.489370 * (SimYrFull(YrFull)-2023));
$elseif.tighten     %UI_RGGItighten% == RGGI3pt5
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.005 * max(0,(SimYrFull(YrFull)-2025))));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12',HMR)$(SimYrFull(YrFull)>=2023 and (not HMR_PA(HMR))) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12','PA')$(SimYrFull(YrFull)>=2023) = EmisCapAlloc('Yr4','RGGI12','PA') - (2.489370 * max(0,(SimYrFull(YrFull)-2023))) - ((2.489370/6) * max(0,(SimYrFull(YrFull)-2025)));
EmisCapAlloc(YrFull,'RGGI12',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI12',HMR));
$elseif.tighten     %UI_RGGItighten% == RGGI3pt5and0
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>=2026 and HMR_RGGI12Lead(HMR)) = Max(0,(((0-EmisCapAlloc('Yr7','RGGI12',HMR))/(2040-2026))*(SimYrFull(YrFull)-2040)));
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Stnd(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.005 * max(0,(SimYrFull(YrFull)-2025))));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12',HMR)$(SimYrFull(YrFull)>=2023 and (not HMR_PA(HMR))) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12','PA')$(SimYrFull(YrFull)>=2023) = EmisCapAlloc('Yr4','RGGI12','PA') - (2.489370 * max(0,(SimYrFull(YrFull)-2023))) - ((2.489370/6) * max(0,(SimYrFull(YrFull)-2025)));
EmisCapAlloc(YrFull,'RGGI12',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI12',HMR));
$elseif.tighten     %UI_RGGItighten% == RGGIzero
EmisCapAlloc(YrFull,'RGGI12',HMR)$(SimYrFull(YrFull)>=2026) = Max(0,(((0-EmisCapAlloc('Yr7','RGGI12',HMR))/(2040-2026))*(SimYrFull(YrFull)-2040)));
$endif.tighten

EmisRefFull('Yr0','RGGI9') = sum(HMR,EmisCapAlloc('Yr0','RGGI9',HMR));
EmisRefFull('Yr1','RGGI10') = sum(HMR,EmisCapAlloc('Yr1','RGGI10',HMR));
EmisRefFull('Yr2','RGGI11') = sum(HMR,EmisCapAlloc('Yr2','RGGI11',HMR));
EmisRefFull('Yr3','RGGI11') = sum(HMR,EmisCapAlloc('Yr3','RGGI11',HMR));
EmisRefFull(YrFull,'RGGI12') = sum(HMR,EmisCapAlloc(YrFull,'RGGI12',HMR));


*transfer everything from Ref to Cap
EmisCap('Yr0','RGGI9','s3')               = EmisRefFull('Yr0','RGGI9');
EmisCap('Yr1','RGGI10','s3')              = EmisRefFull('Yr1','RGGI10');
EmisCap('Yr2','RGGI11','s3')              = EmisRefFull('Yr2','RGGI11');
EmisCap('Yr3','RGGI11','s3')              = EmisRefFull('Yr3','RGGI11');
EmisCap(YrFull,'RGGI12','s3')$(SimYrFull(YrFull)>=2023)             = EmisRefFull(YrFull,'RGGI12');

EmisCapAllocStep('Yr0','RGGI9',HMR,'s3')   = EmisCapAlloc('Yr0','RGGI9',HMR);
EmisCapAllocStep('Yr1','RGGI10',HMR,'s3')  = EmisCapAlloc('Yr1','RGGI10',HMR);
EmisCapAllocStep('Yr2','RGGI11',HMR,'s3')  = EmisCapAlloc('Yr2','RGGI11',HMR);
EmisCapAllocStep('Yr3','RGGI11',HMR,'s3')  = EmisCapAlloc('Yr3','RGGI11',HMR);
EmisCapAllocStep(YrFull,'RGGI12',HMR,'s3')$(SimYrFull(YrFull)>=2023) = EmisCapAlloc(YrFull,'RGGI12',HMR);

*set first step cap to 0 for price floor
EmisCap(YrFull,'RGGI11','s1')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023) = 0;
EmisCap(YrFull,'RGGI12','s1')$(SimYrFull(YrFull)>=2023) = 0;

EmisCapAllocStep(YrFull,'RGGI11',HMR,'s1')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023) = 0;
EmisCapAllocStep(YrFull,'RGGI12',HMR,'s1')$(SimYrFull(YrFull)>=2023) = 0;

*and remove 10% for the ECR
EmisCap(YrFull,'RGGI11','s2')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023) = EmisCap(YrFull,'RGGI11','s3')*0.9;
EmisCap(YrFull,'RGGI12','s2')$(SimYrFull(YrFull)>=2023)
                                         = EmisCap(YrFull,'RGGI12','s3')*0.9;

EmisCapAllocStep(YrFull,'RGGI11',HMR,'s2')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023) = EmisCapAllocStep(YrFull,'RGGI11',HMR,'s3')*0.9;
EmisCapAllocStep(YrFull,'RGGI12',HMR,'s2')$(SimYrFull(YrFull)>=2023)
                                         = EmisCapAllocStep(YrFull,'RGGI12',HMR,'s3')*0.9;

*add 10% for the CCR
EmisCap(YrFull,'RGGI11','s4')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023)
                                         = EmisCap(YrFull,'RGGI11','s3')*1.1;
EmisCap(YrFull,'RGGI12','s4')$(SimYrFull(YrFull)>=2023)
                                         = EmisCap(YrFull,'RGGI12','s3')*1.1;

EmisCapAllocStep(YrFull,'RGGI11',HMR,'s4')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023)
                                         = EmisCapAllocStep(YrFull,'RGGI11',HMR,'s3')*1.1;
EmisCapAllocStep(YrFull,'RGGI12',HMR,'s4')$(SimYrFull(YrFull)>=2023)
                                         = EmisCapAllocStep(YrFull,'RGGI12',HMR,'s3')*1.1;

*save nominal cap
EmisCapNom('Yr0','RGGI9')                = EmisCap('Yr0','RGGI9','s3');
EmisCapNom('Yr1','RGGI10')               = EmisCap('Yr1','RGGI10','s3');
EmisCapNom('Yr2','RGGI11')               = EmisCap('Yr2','RGGI11','s3');
EmisCapNom('Yr3','RGGI11')               = EmisCap('Yr3','RGGI11','s3');
EmisCapNom(YrFull,'RGGI12')$(SimYrFull(YrFull)>=2023)     = EmisCap(YrFull,'RGGI12','s3');


*Allowance price in RGGI9, RGGI10, & RGGI11 states is on the floor in years prior to 2021.
AlwPrc.fx(Yr,'RGGI9')$(SimYr(Yr)=2019)   = 2.26 * (1/Inflation('2019'));
AlwPrc.fx(Yr,'RGGI10')$(SimYr(Yr)=2020)  = 2.26 * (1/Inflation('2019'));

*unfix allowance price to turn on the equation because Bounds on allowance prices activate corresponding constraints.
AlwPrc.up(Yr,'RGGI11')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023)  = +Inf;
AlwPrc.lo(Yr,'RGGI11')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023)  = -Inf;
AlwPrc.up(Yr,'RGGI12')$(SimYr(Yr)>=2023) = +INF;
AlwPrc.lo(Yr,'RGGI12')$(SimYr(Yr)>=2023) = -INF;

*unfix ACAlw and set ACAlwPrc to turn on steps
ACAlwPrc(Yr,'RGGI11','s1')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023)    = 2.26 * (1/Inflation('2019'));
ACAlw.up(Yr,'RGGI11',HMR,'s1')$(map_EmisPol_YPH(Yr,'RGGI11',HMR) and (SimYr(Yr)>=2021 and SimYr(Yr)<2023))    = +Inf;
ACAlwPrc(Yr,'RGGI11','s2')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023)    = 6 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI11',HMR,'s2')$(map_EmisPol_YPH(Yr,'RGGI11',HMR) and (SimYr(Yr)>=2021 and SimYr(Yr)<2023))    = +Inf;
ACAlwPrc(Yr,'RGGI11','s3')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023)    = 13 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI11',HMR,'s3')$(map_EmisPol_YPH(Yr,'RGGI11',HMR) and (SimYr(Yr)>=2021 and SimYr(Yr)<2023))    = +Inf;

ACAlwPrc(Yr,'RGGI12','s1')$(SimYr(Yr)>=2023)    = 2.26 * (1/Inflation('2019'));
ACAlw.up(Yr,'RGGI12',HMR,'s1')$(map_EmisPol_YPH(Yr,'RGGI12',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12','s2')$(SimYr(Yr)>=2023)    = 6 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12',HMR,'s2')$(map_EmisPol_YPH(Yr,'RGGI12',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12','s3')$(SimYr(Yr)>=2023)    = 13 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12',HMR,'s3')$(map_EmisPol_YPH(Yr,'RGGI12',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12','s4')$(SimYr(Yr)>=2023)    = 500 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12',HMR,'s4')$(map_EmisPol_YPH(Yr,'RGGI12',HMR) and (SimYr(Yr)>=2025))    = +Inf;

*refix everything for all years if we are on the price floor
$ifthenE.floor SameAs('%UI_RGGIfloor%','YES')
*AlwPrc.fx(Yr,'RGGI11')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023) = 2.26 * (1/Inflation('2019'));
*AlwPrc.fx(Yr,'RGGI12')$(SimYr(Yr)>=2023) = 2.26 * (1/Inflation('2019'));
AlwPrc.fx(Yr,'RGGI12')$(SimYr(Yr)>=2023) = 6 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
$endif.floor

$ifthen.RGGIBank %UI_RGGIBank%==Yes
*AlwPrc.fx(Yr,'RGGI11')$(SimYr(Yr)<=%UI_FxGen%) = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);
AlwPrc.fx(Yr,'RGGI12')$(SimYr(Yr)>%UI_FxGen%) = 0;
AlwPrcBank.up(Yr,'RGGI12')$(SimYr(Yr)>%UI_FxGen%)=+INF;
AlwPrcBank.lo(Yr,'RGGI12')$(SimYr(Yr)>%UI_FxGen%)=-INF;
EmisBankStartYr('RGGI12') = smin(Yr,(SimYr(Yr)$(AlwPrcBank.up(Yr,'RGGI12')>AlwPrcBank.lo(Yr,'RGGI12')) + SimYrLast$(AlwPrcBank.up(Yr,'RGGI12')=AlwPrcBank.lo(Yr,'RGGI12'))));
$endif.RGGIBank

$ifthen.ExRate %UI_ExRate% == Yes
ExchangeRate(Yr,'RGGI12',HMR)$(HMR_RGGI12Lead(HMR) and SimYr(Yr) >=2025) = 2;
$endif.ExRate

$ifthen.EnhComp %UI_EnhComp% == Yes
EnhancedComp(Yr,'RGGI12',HMR)$(HMR_RGGI12Lead(HMR) and SimYr(Yr) >=2025) = 2;
$endif.EnhComp

$ifthen.res %UI_Func% == Res
AlwPrc.L(Yr,PPAR)$sum(HMR,map_EmisPol_YPH(Yr,PPAR,HMR))
                                         = TmpAlwPrc(Yr,PPAR);
$endif.res

*-----------------------------------------------------------------------
$elseifE.RGGI (SameAs('%UI_RGGI%','RGGIZone'))
*----------------------------------------------------------------------------------------------------------------------------

EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-(0.03*(SimYrFull(YrFull)-2021)));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12Lead',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12Stnd',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Stnd(HMR) and (not HMR_PA(HMR))) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12Stnd','PA')$(SimYrFull(YrFull)>=2023) = EmisCapAlloc('Yr4','RGGI12','PA') - (2.489370 * (SimYrFull(YrFull)-2023));

$ifthen.tighten     %UI_RGGItighten% == RGGI3pct4pct
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.01 * max(0,(SimYrFull(YrFull)-2023))));
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Stnd(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-(0.03*(SimYrFull(YrFull)-2021)));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12Lead',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12Stnd',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Stnd(HMR) and (not HMR_PA(HMR))) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12Stnd','PA')$(SimYrFull(YrFull)>=2023) = EmisCapAlloc('Yr4','RGGI12','PA') - (2.489370 * (SimYrFull(YrFull)-2023));
EmisCapAlloc(YrFull,'RGGI12Stnd',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI12Stnd',HMR));
$elseif.tighten     %UI_RGGItighten% == RGGI3pt5
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.005 * max(0,(SimYrFull(YrFull)-2025))));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12Lead',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12Stnd',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Stnd(HMR)) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12Stnd','PA')$(SimYrFull(YrFull)>=2023) = EmisCapAlloc('Yr4','RGGI12','PA') - (2.489370 * max(0,(SimYrFull(YrFull)-2023))) - ((2.489370/6) * max(0,(SimYrFull(YrFull)-2025)));
EmisCapAlloc(YrFull,'RGGI12Stnd',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI12Stnd',HMR));
$elseif.tighten     %UI_RGGItighten% == RGGI3pt5and0
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>=2026 and HMR_RGGI12Lead(HMR)) = Max(0,(((0-EmisCapAlloc('Yr7','RGGI12Lead',HMR))/(2040-2026))*(SimYrFull(YrFull)-2040)));
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Stnd(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.005 * max(0,(SimYrFull(YrFull)-2025))));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12Lead',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12Stnd',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Stnd(HMR)) = EmisCapAlloc(YrFull,'RGGI11',HMR);
EmisCapAlloc(YrFull,'RGGI12Stnd','PA')$(SimYrFull(YrFull)>=2023) = EmisCapAlloc('Yr4','RGGI12','PA') - (2.489370 * max(0,(SimYrFull(YrFull)-2023))) - ((2.489370/6) * max(0,(SimYrFull(YrFull)-2025)));
EmisCapAlloc(YrFull,'RGGI12Stnd',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI12Stnd',HMR));
$elseif.tighten     %UI_RGGItighten% == RGGIzero
EmisCapAlloc(YrFull,'RGGI12Lead',HMR)$(SimYrFull(YrFull)>=2026) = Max(0,(((0-EmisCapAlloc('Yr7','RGGI12Lead',HMR))/(2040-2026))*(SimYrFull(YrFull)-2040)));
EmisCapAlloc(YrFull,'RGGI12Lead',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI12Lead',HMR));
EmisCapAlloc(YrFull,'RGGI12Stnd',HMR)$(SimYrFull(YrFull)>=2026) = Max(0,(((0-EmisCapAlloc('Yr7','RGGI12Stnd',HMR))/(2040-2026))*(SimYrFull(YrFull)-2040)));
EmisCapAlloc(YrFull,'RGGI12Stnd',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI12Stnd',HMR));
$endif.tighten

EmisRefFull('Yr0','RGGI9') = sum(HMR,EmisCapAlloc('Yr0','RGGI9',HMR));
EmisRefFull('Yr1','RGGI10') = sum(HMR,EmisCapAlloc('Yr1','RGGI10',HMR));
EmisRefFull('Yr2','RGGI11') = sum(HMR,EmisCapAlloc('Yr2','RGGI11',HMR));
EmisRefFull('Yr3','RGGI11') = sum(HMR,EmisCapAlloc('Yr3','RGGI11',HMR));
EmisRefFull(YrFull,'RGGI12Lead') = sum(HMR,EmisCapAlloc(YrFull,'RGGI12Lead',HMR));
EmisRefFull(YrFull,'RGGI12Stnd') = sum(HMR,EmisCapAlloc(YrFull,'RGGI12Stnd',HMR));


*transfer everything from Ref to Cap
EmisCap('Yr0','RGGI9','s3')               = EmisRefFull('Yr0','RGGI9');
EmisCap('Yr1','RGGI10','s3')              = EmisRefFull('Yr1','RGGI10');
EmisCap('Yr2','RGGI11','s3')              = EmisRefFull('Yr2','RGGI11');
EmisCap('Yr3','RGGI11','s3')              = EmisRefFull('Yr3','RGGI11');
EmisCap(YrFull,'RGGI12Lead','s3')$(SimYrFull(YrFull)>=2023)             = EmisRefFull(YrFull,'RGGI12Lead');
EmisCap(YrFull,'RGGI12Stnd','s3')$(SimYrFull(YrFull)>=2023)             = EmisRefFull(YrFull,'RGGI12Stnd');

EmisCapAllocStep('Yr0','RGGI9',HMR,'s3')               = EmisCapAlloc('Yr0','RGGI9',HMR);
EmisCapAllocStep('Yr1','RGGI10',HMR,'s3')              = EmisCapAlloc('Yr1','RGGI10',HMR);
EmisCapAllocStep('Yr2','RGGI11',HMR,'s3')              = EmisCapAlloc('Yr2','RGGI11',HMR);
EmisCapAllocStep('Yr3','RGGI11',HMR,'s3')              = EmisCapAlloc('Yr3','RGGI11',HMR);
EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s3')$(SimYrFull(YrFull)>=2023)             = EmisCapAlloc(YrFull,'RGGI12Lead',HMR);
EmisCapAllocStep(YrFull,'RGGI12Stnd',HMR,'s3')$(SimYrFull(YrFull)>=2023)             = EmisCapAlloc(YrFull,'RGGI12Stnd',HMR);

*set first step cap to 0 for price floor
EmisCap(YrFull,'RGGI11','s1')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023) = 0;
EmisCap(YrFull,'RGGI12Lead','s1')$(SimYrFull(YrFull)>=2023) = 0;
EmisCap(YrFull,'RGGI12Stnd','s1')$(SimYrFull(YrFull)>=2023) = 0;

EmisCapAllocStep(YrFull,'RGGI11',HMR,'s1')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023) = 0;
EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s1')$(SimYrFull(YrFull)>=2023) = 0;
EmisCapAllocStep(YrFull,'RGGI12Stnd',HMR,'s1')$(SimYrFull(YrFull)>=2023) = 0;

*and remove 10% for the ECR
EmisCap(YrFull,'RGGI11','s2')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023) = EmisCap(YrFull,'RGGI11','s3')*0.9;
EmisCap(YrFull,'RGGI12Lead','s2')$(SimYrFull(YrFull)>=2023) = EmisCap(YrFull,'RGGI12Lead','s3')*0.9;
EmisCap(YrFull,'RGGI12Stnd','s2')$(SimYrFull(YrFull)>=2023) = EmisCap(YrFull,'RGGI12Stnd','s3')*0.9;

EmisCapAllocStep(YrFull,'RGGI11',HMR,'s2')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023) = EmisCapAllocStep(YrFull,'RGGI11',HMR,'s3')*0.9;
EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s2')$(SimYrFull(YrFull)>=2023) = EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s3')*0.9;
EmisCapAllocStep(YrFull,'RGGI12Stnd',HMR,'s2')$(SimYrFull(YrFull)>=2023) = EmisCapAllocStep(YrFull,'RGGI12Stnd',HMR,'s3')*0.9;

*add 10% for the CCR
EmisCap(YrFull,'RGGI11','s4')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023) = EmisCap(YrFull,'RGGI11','s3')*1.1;
EmisCap(YrFull,'RGGI12Lead','s4')$(SimYrFull(YrFull)>=2023) = EmisCap(YrFull,'RGGI12Lead','s3')*1.1;
EmisCap(YrFull,'RGGI12Stnd','s4')$(SimYrFull(YrFull)>=2023) = EmisCap(YrFull,'RGGI12Stnd','s3')*1.1;

EmisCapAllocStep(YrFull,'RGGI11',HMR,'s4')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2023) = EmisCapAllocStep(YrFull,'RGGI11',HMR,'s3')*1.1;
EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s4')$(SimYrFull(YrFull)>=2023) = EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s3')*1.1;
EmisCapAllocStep(YrFull,'RGGI12Stnd',HMR,'s4')$(SimYrFull(YrFull)>=2023) = EmisCapAllocStep(YrFull,'RGGI12Stnd',HMR,'s3')*1.1;

*save nominal cap
EmisCapNom('Yr0','RGGI9')                = EmisCap('Yr0','RGGI9','s3');
EmisCapNom('Yr1','RGGI10')               = EmisCap('Yr1','RGGI10','s3');
EmisCapNom('Yr2','RGGI11')               = EmisCap('Yr2','RGGI11','s3');
EmisCapNom('Yr3','RGGI11')               = EmisCap('Yr3','RGGI11','s3');
EmisCapNom(YrFull,'RGGI12Lead')$(SimYrFull(YrFull)>=2023)     = EmisCap(YrFull,'RGGI12Lead','s3');
EmisCapNom(YrFull,'RGGI12Stnd')$(SimYrFull(YrFull)>=2023)     = EmisCap(YrFull,'RGGI12Stnd','s3');


*Allowance price in RGGI9, RGGI10, & RGGI11 states is on the floor in years prior to 2021.
AlwPrc.fx(Yr,'RGGI9')$(SimYr(Yr)=2019)   = 2.26 * (1/Inflation('2019'));
AlwPrc.fx(Yr,'RGGI10')$(SimYr(Yr)=2020)  = 2.26 * (1/Inflation('2019'));

*unfix allowance price to turn on the equation because Bounds on allowance prices activate corresponding constraints.
AlwPrc.up(Yr,'RGGI11')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023)  = +Inf;
AlwPrc.lo(Yr,'RGGI11')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023)  = -Inf;
AlwPrc.up(Yr,'RGGI12Lead')$(SimYr(Yr)>=2023) = +INF;
AlwPrc.lo(Yr,'RGGI12Lead')$(SimYr(Yr)>=2023) = -INF;
AlwPrc.up(Yr,'RGGI12Stnd')$(SimYr(Yr)>=2023) = +INF;
AlwPrc.lo(Yr,'RGGI12Stnd')$(SimYr(Yr)>=2023) = -INF;

*unfix ACAlw and set ACAlwPrc to turn on steps
ACAlwPrc(Yr,'RGGI11','s1')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023)    = 2.26 * (1/Inflation('2019'));
ACAlw.up(Yr,'RGGI11',HMR,'s1')$(map_EmisPol_YPH(Yr,'RGGI11',HMR) and (SimYr(Yr)>=2021 and SimYr(Yr)<2023))    = +Inf;
ACAlwPrc(Yr,'RGGI11','s2')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023)    = 6 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI11',HMR,'s2')$(map_EmisPol_YPH(Yr,'RGGI11',HMR) and (SimYr(Yr)>=2021 and SimYr(Yr)<2023))    = +Inf;
ACAlwPrc(Yr,'RGGI11','s3')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023)    = 13 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI11',HMR,'s3')$(map_EmisPol_YPH(Yr,'RGGI11',HMR) and (SimYr(Yr)>=2021 and SimYr(Yr)<2023))    = +Inf;

ACAlwPrc(Yr,'RGGI12Lead','s1')$(SimYr(Yr)>=2023)    = 2.26 * (1/Inflation('2019'));
ACAlw.up(Yr,'RGGI12Lead',HMR,'s1')$(map_EmisPol_YPH(Yr,'RGGI12Lead',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12Lead','s2')$(SimYr(Yr)>=2023)    = 6 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12Lead',HMR,'s2')$(map_EmisPol_YPH(Yr,'RGGI12Lead',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12Lead','s3')$(SimYr(Yr)>=2023)    = 13 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12Lead',HMR,'s3')$(map_EmisPol_YPH(Yr,'RGGI12Lead',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12Lead','s4')$(SimYr(Yr)>=2023)    = 500 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12Lead',HMR,'s4')$(map_EmisPol_YPH(Yr,'RGGI12Lead',HMR) and (SimYr(Yr)>=2025))    = +Inf;

ACAlwPrc(Yr,'RGGI12Stnd','s1')$(SimYr(Yr)>=2023)    = 2.26 * (1/Inflation('2019'));
ACAlw.up(Yr,'RGGI12Stnd',HMR,'s1')$(map_EmisPol_YPH(Yr,'RGGI12Stnd',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12Stnd','s2')$(SimYr(Yr)>=2023)    = 6 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12Stnd',HMR,'s2')$(map_EmisPol_YPH(Yr,'RGGI12Stnd',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12Stnd','s3')$(SimYr(Yr)>=2023)    = 13 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12Stnd',HMR,'s3')$(map_EmisPol_YPH(Yr,'RGGI12Stnd',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12Stnd','s4')$(SimYr(Yr)>=2023)    = 500 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12Stnd',HMR,'s4')$(map_EmisPol_YPH(Yr,'RGGI12Stnd',HMR) and (SimYr(Yr)>=2025))    = +Inf;

*refix everything for all years if we are on the price floor
$ifthenE.floor SameAs('%UI_RGGIfloor%','YES')
AlwPrc.fx(Yr,'RGGI11')$(SimYr(Yr)>=2021 and SimYr(Yr)<2023) = 2.26 * (1/Inflation('2019'));
AlwPrc.fx(Yr,'RGGI12Lead')$(SimYr(Yr)>=2023) = 2.26 * (1/Inflation('2019'));
AlwPrc.fx(Yr,'RGGI12Stnd')$(SimYr(Yr)>=2023) = 2.26 * (1/Inflation('2019'));
$endif.floor

$ifthen.RGGIBank %UI_RGGIBank%==Yes
*AlwPrc.fx(Yr,'RGGI11')$(SimYr(Yr)<=%UI_FxGen%) = 10 * MtSt * (1/Inflation('2012')) * (1/0.95)**(SimYr(Yr)-2012);
AlwPrc.fx(Yr,'RGGI12Lead')$(SimYr(Yr)>%UI_FxGen%) = 0;
AlwPrcBank.up(Yr,'RGGI12Lead')$(SimYr(Yr)>%UI_FxGen%)=+INF;
AlwPrcBank.lo(Yr,'RGGI12Lead')$(SimYr(Yr)>%UI_FxGen%)=-INF;
EmisBankStartYr('RGGI12Lead') = smin(Yr,(SimYr(Yr)$(AlwPrcBank.up(Yr,'RGGI12Lead')>AlwPrcBank.lo(Yr,'RGGI12Lead')) + SimYrLast$(AlwPrcBank.up(Yr,'RGGI12Lead')=AlwPrcBank.lo(Yr,'RGGI12Lead'))));
AlwPrc.fx(Yr,'RGGI12Stnd')$(SimYr(Yr)>%UI_FxGen%) = 0;
AlwPrcBank.up(Yr,'RGGI12Stnd')$(SimYr(Yr)>%UI_FxGen%)=+INF;
AlwPrcBank.lo(Yr,'RGGI12Stnd')$(SimYr(Yr)>%UI_FxGen%)=-INF;
EmisBankStartYr('RGGI12Stnd') = smin(Yr,(SimYr(Yr)$(AlwPrcBank.up(Yr,'RGGI12Stnd')>AlwPrcBank.lo(Yr,'RGGI12Stnd')) + SimYrLast$(AlwPrcBank.up(Yr,'RGGI12Stnd')=AlwPrcBank.lo(Yr,'RGGI12Stnd'))));

$endif.RGGIBank

$ifthen.res %UI_Func% == Res
AlwPrc.L(Yr,PPAR)$sum(HMR,map_EmisPol_YPH(Yr,PPAR,HMR))
                                         = TmpAlwPrc(Yr,PPAR);
$endif.res

*-----------------------------------------------------------------------

$elseifE.RGGI (SameAs('%UI_RGGI%','RGGI13'))
*----------------------------------------------------------------------------------------------------------------------------
*The nominal RGGI cap begins in 2022, declining by 3%/yr from 2021 on
EmisCap(YrFull,'RGGI13','s3')$(SimYrFull(YrFull)>=2025) =
        EmisRefFull('Yr5','RGGI13')*(1-0.03*(SimYrFull(YrFull)-2025));

*transfer everything from Ref to Cap
EmisCap('Yr0','RGGI9','s3')               = EmisRefFull('Yr0','RGGI9');
EmisCap('Yr1','RGGI10','s3')              = EmisRefFull('Yr1','RGGI10');
EmisCap('Yr2','RGGI11','s3')              = EmisRefFull('Yr2','RGGI11');
EmisCap(YrFull,'RGGI12','s3')$(SimYrFull(YrFull) >= 2022 and SimYrFull(YrFull) <= 2024)
                                          = EmisRefFull(YrFull,'RGGI12');
EmisCap(YrFull,'RGGI13','s3')$(SimYrFull(YrFull) >= 2025)
                                          = EmisRefFull(YrFull,'RGGI13');

*set first cap to 0 for price floor
EmisCap(YrFull,'RGGI13','s1')$(SimYrFull(YrFull)>=2025) = 0;

*and remove 10% for the ECR
EmisCap(YrFull,'RGGI13','s2')$(SimYrFull(YrFull)>=2025)
                                         = EmisCap(YrFull,'RGGI13','s3')*0.9;

*add 10% for the CCR
EmisCap(YrFull,'RGGI13','s4')$(SimYrFull(YrFull)>=2025)
                                         = EmisCap(YrFull,'RGGI13','s3')*1.1;

*Save nominal cap
EmisCapNom(YrFull,'RGGI13')                  = EmisCap(YrFull,'RGGI13','s3');

*Allowance price in RGGI9, RGGI10, & RGGI11 states is on the floor in years prior to 2021.
AlwPrc.fx(Yr,'RGGI9')$(SimYr(Yr)=2019)   = 2.26 * (1/Inflation('2019'));
AlwPrc.fx(Yr,'RGGI10')$(SimYr(Yr)=2020)  = 2.26 * (1/Inflation('2019'));
AlwPrc.fx(Yr,'RGGI11')$(SimYr(Yr)=2021)  = 2.26 * (1/Inflation('2019'));
AlwPrc.fx(Yr,'RGGI12')$(SimYr(Yr) >= 2022 and SimYr(Yr) <= 2024)
                                         = 2.26 * (1/Inflation('2019'));

*unfix allowance price to turn on the equation
AlwPrc.up(Yr,'RGGI13')$(SimYr(Yr)>=2025) = +INF;
AlwPrc.l(Yr,'RGGI13')$(SimYr(Yr)>=2025) = 0;
AlwPrc.lo(Yr,'RGGI13')$(SimYr(Yr)>=2025) = -INF;

*unfix ACAlw and set ACAlwPrc to turn on steps
ACAlwPrc(Yr,'RGGI13','s1')$(SimYr(Yr)>=2025)    = 2.26 * (1/Inflation('2019'));
ACAlw.up(Yr,'RGGI13',HMR,'s1')$(map_EmisPol_YPH(Yr,'RGGI13',HMR) and (SimYr(Yr)>=2025))    = +Inf;
ACAlwPrc(Yr,'RGGI13','s2')$(SimYr(Yr)>=2025)    = 6 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI13',HMR,'s2')$(map_EmisPol_YPH(Yr,'RGGI13',HMR) and (SimYr(Yr)>=2025))    = +Inf;
ACAlwPrc(Yr,'RGGI13','s3')$(SimYr(Yr)>=2025)    = 13 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI13',HMR,'s3')$(map_EmisPol_YPH(Yr,'RGGI13',HMR) and (SimYr(Yr)>=2025))    = +Inf;

*refix everything for all years if we are on the price floor
$ifthenE.floor SameAs('%UI_RGGIfloor%','YES')
AlwPrc.fx(Yr,'RGGI13')$(SimYr(Yr)>=2025) = 2.26 * (1/Inflation('2019'));
$endif.floor

$ifthen.res %UI_Func% == Res
AlwPrc.L(Yr,PPAR)$sum(HMR,map_EmisPol_YPH(Yr,PPAR,HMR))
                                         = TmpAlwPrc(Yr,PPAR);
$endif.res

*-----------------------------------------------------------------------
$endif.RGGI

$ifthen.RGGILead %UI_RGGIOverlay% == Yes
*----------------------------------------------------------------------------------------------------------------------------
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021))));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12Lead',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc(YrFull,'RGGI11',HMR);

$ifthen.tighten     %UI_RGGIOverlayType% == RGGI3pt5
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.005 * max(0,(SimYrFull(YrFull)-2025))));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12Lead',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc(YrFull,'RGGI11',HMR);
$elseif.tighten     %UI_RGGIOverlayType% == RGGI4pct
EmisCapAlloc(YrFull,'RGGI11',HMR)$(SimYrFull(YrFull)>2021 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc('Yr2','RGGI11',HMR)*(1-((0.03*(SimYrFull(YrFull)-2021)) + 0.001 * max(0,(SimYrFull(YrFull)-2023))));
EmisCapAlloc(YrFull,'RGGI11',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI11',HMR));
EmisCapAlloc(YrFull,'RGGI12Lead',HMR)$(SimYrFull(YrFull)>=2023 and HMR_RGGI12Lead(HMR)) = EmisCapAlloc(YrFull,'RGGI11',HMR);
$elseif.tighten     %UI_RGGIOverlayType% == RGGIzero
EmisCapAlloc(YrFull,'RGGI12Lead',HMR)$(SimYrFull(YrFull)>=2026) = Max(0,(((0-EmisCapAlloc('Yr7','RGGI12Lead',HMR))/(2040-2026))*(SimYrFull(YrFull)-2040)));
EmisCapAlloc(YrFull,'RGGI12Lead',HMR) = max(0,EmisCapAlloc(YrFull,'RGGI12Lead',HMR));
$endif.tighten

EmisRefFull(YrFull,'RGGI12Lead') = sum(HMR,EmisCapAlloc(YrFull,'RGGI12Lead',HMR));

*turn on mapping for RGGI12Lead PPAR
map_EmisPol_YPH(Yr,'RGGI12Lead',HMR)= Yes$(HMR_RGGI12Lead(HMR));
map_EmisPol_YPHM(Yr,'RGGI12Lead',HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,'RGGI12Lead',HMR) and EmisPolMP(MP));

*transfer everything from Ref to Cap
EmisCap(YrFull,'RGGI12Lead','s3')$(SimYrFull(YrFull)>=2023)             = EmisRefFull(YrFull,'RGGI12Lead');

EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s3')$(SimYrFull(YrFull)>=2023)             = EmisCapAlloc(YrFull,'RGGI12Lead',HMR);

*set first step cap to 0 for price floor
EmisCap(YrFull,'RGGI12Lead','s1')$(SimYrFull(YrFull)>=2023) = 0;

EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s1')$(SimYrFull(YrFull)>=2023) = 0;

*and remove 10% for the ECR
EmisCap(YrFull,'RGGI12Lead','s2')$(SimYrFull(YrFull)>=2023) = EmisCap(YrFull,'RGGI12Lead','s3')*0.9;

EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s2')$(SimYrFull(YrFull)>=2023) = EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s3')*0.9;

*add 10% for the CCR
EmisCap(YrFull,'RGGI12Lead','s4')$(SimYrFull(YrFull)>=2023) = EmisCap(YrFull,'RGGI12Lead','s3')*1.1;

EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s4')$(SimYrFull(YrFull)>=2023) = EmisCapAllocStep(YrFull,'RGGI12Lead',HMR,'s3')*1.1;

*save nominal cap
EmisCapNom(YrFull,'RGGI12Lead')$(SimYrFull(YrFull)>=2023)     = EmisCap(YrFull,'RGGI12Lead','s3');

*unfix allowance price to turn on the equation because Bounds on allowance prices activate corresponding constraints.
AlwPrc.up(Yr,'RGGI12Lead')$(SimYr(Yr)>=2023) = +INF;
AlwPrc.lo(Yr,'RGGI12Lead')$(SimYr(Yr)>=2023) = -INF;

*unfix ACAlw and set ACAlwPrc to turn on steps
ACAlwPrc(Yr,'RGGI12Lead','s1')$(SimYr(Yr)>=2023)    = 2.26 * (1/Inflation('2019'));
ACAlw.up(Yr,'RGGI12Lead',HMR,'s1')$(map_EmisPol_YPH(Yr,'RGGI12Lead',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12Lead','s2')$(SimYr(Yr)>=2023)    = 6 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12Lead',HMR,'s2')$(map_EmisPol_YPH(Yr,'RGGI12Lead',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12Lead','s3')$(SimYr(Yr)>=2023)    = 13 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12Lead',HMR,'s3')$(map_EmisPol_YPH(Yr,'RGGI12Lead',HMR) and (SimYr(Yr)>=2023))    = +Inf;
ACAlwPrc(Yr,'RGGI12Lead','s4')$(SimYr(Yr)>=2023)    = 500 * (1/Inflation('2021')) * (1.05)**(SimYr(Yr)-2021);
ACAlw.up(Yr,'RGGI12Lead',HMR,'s4')$(map_EmisPol_YPH(Yr,'RGGI12Lead',HMR) and (SimYr(Yr)>=2025))    = +Inf;

$ifthen.res %UI_Func% == Res
AlwPrc.L(Yr,PPAR)$sum(HMR,map_EmisPol_YPH(Yr,PPAR,HMR))
                                         = TmpAlwPrc(Yr,PPAR);
$endif.res
*-----------------------------------------------------------------------
$endif.RGGILead

parameter
AlwPrcRGGI(Yr,PPAR)
TestAlloc(YrFull,PPAR)
;
AlwPrcRGGI(Yr,'RGGI11') = AlwPrc.up(Yr,'RGGI11');
AlwPrcRGGI(Yr,'RGGI12') = AlwPrc.up(Yr,'RGGI12');


TestAlloc(YrFull,PPAR) = sum(HMR,EmisCapAlloc(YrFull,PPAR,HMR))
display
TestAlloc
EmisCapNom
*map_EmisPol_YPH
*ACAlwPrc
*AlwPrcRGGI
;

parameter
ACAlwRGGI(Yr,PPAR,HMR,step)
;
ACAlwRGGI(Yr,'RGGI11',HMR,step) = ACAlw.up(Yr,'RGGI11',HMR,step);
ACAlwRGGI(Yr,'RGGI12',HMR,step) = ACAlw.up(Yr,'RGGI12',HMR,step);
