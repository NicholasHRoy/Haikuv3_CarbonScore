* Declare portfolio standard variables and parameters, and initialize.
**----------------------------------------------------------------------------------------------------------------------
Parameters
        TmpPSPrc(Yr,PPAR)
        TmpPSPrcBank(Yr,PPAR)
        TmpPSReq(Yr,PPAR)
        EmisRefPS(Yr,PPAR)
        EmisRefFullPS(YrFull,PPAR)
        EmisCapFullPS(YrFull,PPAR)
        EmisYP_PS(Yr,PPAR,Pol)
        GenAnn(Yr,HMR,MP)
        GenAnn_PSRef(Yr,PPAR) annual generation for a portfolio standard from a reference scenario [TWh]
        GenFuelYPCvr_PS(Yr,Fuel,PPAR)
        GenFuelYPCred_PS(Yr,Fuel,PPAR)
        GenFuelYPCred_PS_Full(YrFull,Fuel,PPAR)
        EConsPPAR(Yr,PPAR)
        EConsPPARFull(YrFull,PPAR)
        PSReqQuant(YrFull,PPAR)
;

*PS Requirement in years in between SimYrs are interpolated.
*PSReqFull(YrFull,PPAR) = sum(Yrdup,PSReq(Yrdup,PPAR)*SimYrWgtKnl(YrFull,Yrdup));

* Initialize
PSPrc.lo(Yr,PPAR)=0; PSPrc.up(Yr,PPAR)=0;
PSPrcBank.lo(Yr,PPAR) = 0; PSPrcBank.up(Yr,PPAR) = 0;
PSReq.lo(Yr,PPAR)=0; PSReq.up(Yr,PPAR)=0;
PSReqFull(YrFull,PPAR)=       0;
EmisCapPS(YrFull,PPAR)=    10E6;
EmisRefPS(Yr,PPAR)=        +INF;
EmisRefFullPS(YrFull,PPAR)=+INF;
EmisCapFullPS(YrFull,PPAR)=+INF;
ACPquantity.fx(Yr,PPAR,HMR) = 0;
ACPprice(Yr,PPAR,HMR) = 0;
PTCHaircut(YrFull,'%UI_PPAR_TC%') = TCHaircut;
ITCHaircut(YrFull,'%UI_PPAR_TC%') = TCHaircut;
TmpPSPrc(Yr,PPAR)=PSPrc.L(Yr,PPAR); !! Assumes current years same as initial values years
TmpPSPrcBank(Yr,PPAR)=PSPrcBank.L(Yr,PPAR);
TmpPSReq(Yr,PPAR)=PSReq.L(Yr,PPAR);

$setglobal UI_PSPolType NA

* Policy Options (Depending on UI_PSPol Input)
**----------------------------------------------------------------------------------------------------------------------

$ifthen.ps_pol %UI_PSPol% == RPS_RGGIPrj
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2026))=+INF;
PSPrc.L(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2026))=TmpPSPrc(Yr,PPAR);

*RPS for Wind/Solar Set at 5% above 2021 levels, up to 10% by 2031
put dummy;
put_utility 'gdxin' / '%UI_RootDir%\..\%UI_vRS1%\Output\%UI_RefScen1%\%UI_vRS1%_%UI_RefScen1%';
execute_load GenAnn, EConsPPAR;
putclose;

EConsPPARFull(YrFull,PPAR)=sum(Yrdup,EConsPPAR(Yrdup,PPAR)*SimYrWgtKnl(YrFull,Yrdup));
GenFuelYPCvr_PS(Yr,Fuel,PPAR)=sum((HMR,MP),GenAnn(Yr,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));
GenFuelYPCred_PS(Yr,Fuel,PPAR)=sum((HMR,MP),(GenAnn(Yr,HMR,MP)*PSCredit(Yr,PPAR,HMR,MP))$map_PS_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));
GenFuelYPCred_PS_Full(YrFull,Fuel,PPAR)=sum(Yrdup,GenFuelYPCred_PS(Yrdup,Fuel,PPAR)*SimYrWgtKnl(YrFull,Yrdup));

*display PSMP, map_PS_YPH, map_PS_YPHM, MPFuel;
*display GenAnn;
*display GenFuelYPCvr_PS, GenFuelYPCred_PS, EConsPPAR;
*display GenFuelYPCred_PS_Full, EConsPPARFull;

PSReqFull(YrFull,'%UI_PPAR_PS%') = 0;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2026 and SimYrFull(YrFull)<=2031) = sum(Fuel,GenFuelYPCred_PS_Full(YrFull,Fuel,'%UI_PPAR_PS%')) / EConsPPARFull(YrFull,'%UI_PPAR_PS%');
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2026)
 = PSReqFull(YrFull,'%UI_PPAR_PS%') + (.05 + .01*(SimYrFull(YrFull)-2026));
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>2031) = PSReqFull('Yr16','%UI_PPAR_PS%');
PSReq.fx(Yr,PPAR)=PSReqFull(Yr,PPAR) * %UI_PS_ReqMult%;
$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_RGGIPrj
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2026))=+INF;
PSPrc.L(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2026))=TmpPSPrc(Yr,PPAR);

*RPS for Wind/Solar Set at 5% above 2021 levels, up to 10% by 2031
put dummy;
put_utility 'gdxin' / '%UI_RootDir%\..\%UI_vRS1%\Output\%UI_RefScen1%\%UI_vRS1%_%UI_RefScen1%';
execute_load GenAnn, EConsPPAR;
putclose;

EConsPPARFull(YrFull,PPAR)=sum(Yrdup,EConsPPAR(Yrdup,PPAR)*SimYrWgtKnl(YrFull,Yrdup));
GenFuelYPCvr_PS(Yr,Fuel,PPAR)=sum((HMR,MP),GenAnn(Yr,HMR,MP)$map_PS_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));
GenFuelYPCred_PS(Yr,Fuel,PPAR)=sum((HMR,MP),(GenAnn(Yr,HMR,MP)*PSCredit(Yr,PPAR,HMR,MP))$map_PS_YPHM(Yr,PPAR,HMR,MP)*MPFuel(MP,Fuel));
GenFuelYPCred_PS_Full(YrFull,Fuel,PPAR)=sum(Yrdup,GenFuelYPCred_PS(Yrdup,Fuel,PPAR)*SimYrWgtKnl(YrFull,Yrdup));

*display PSMP, map_PS_YPH, map_PS_YPHM, MPFuel;
*display GenAnn;
*display GenFuelYPCvr_PS, GenFuelYPCred_PS, EConsPPAR;
*display GenFuelYPCred_PS_Full, EConsPPARFull;

PSReqFull(YrFull,'%UI_PPAR_PS%') = 0;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2026 and SimYrFull(YrFull)<=2031) = sum(Fuel,GenFuelYPCred_PS_Full(YrFull,Fuel,'%UI_PPAR_PS%')) / EConsPPARFull(YrFull,'%UI_PPAR_PS%');
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2026)
 = PSReqFull(YrFull,'%UI_PPAR_PS%') + (.05 + .01*(SimYrFull(YrFull)-2026));
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>2031) = PSReqFull('Yr16','%UI_PPAR_PS%');
PSReq.fx(Yr,PPAR)=PSReqFull(Yr,PPAR) * %UI_PS_ReqMult%;
$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_Smith
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021))=+INF;
PSPrc.L(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021))=TmpPSPrc(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021));

*Y6 = 2021, Y24 = 2039

PSReqFull('Yr6','%UI_PPAR_PS%')  = .54;
PSReqFull('Yr7','%UI_PPAR_PS%')  = .56;
PSReqFull('Yr8','%UI_PPAR_PS%')  = .57;
PSReqFull('Yr9','%UI_PPAR_PS%')  = .59;
PSReqFull('Yr10','%UI_PPAR_PS%') = .61;
PSReqFull('Yr11','%UI_PPAR_PS%') = .62;
PSReqFull('Yr12','%UI_PPAR_PS%') = .64;
PSReqFull('Yr13','%UI_PPAR_PS%') = .65;
PSReqFull('Yr14','%UI_PPAR_PS%') = .67;
PSReqFull('Yr15','%UI_PPAR_PS%') = .69;
PSReqFull('Yr16','%UI_PPAR_PS%') = .70;
PSReqFull('Yr17','%UI_PPAR_PS%') = .72;
PSReqFull('Yr18','%UI_PPAR_PS%') = .74;
PSReqFull('Yr19','%UI_PPAR_PS%') = .75;
PSReqFull('Yr20','%UI_PPAR_PS%') = .77;
PSReqFull('Yr21','%UI_PPAR_PS%') = .79;
PSReqFull('Yr22','%UI_PPAR_PS%') = .81;
PSReqFull('Yr23','%UI_PPAR_PS%') = .82;
PSReqFull('Yr24','%UI_PPAR_PS%') = .84;
*PSCredit_Int(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2030)= .64;
*PSCredit_Int(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2030 and SimYrFull(YrFull)<2035)= .54;
*PSCredit_Int(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2035 and SimYrFull(YrFull)<2040)= .44;
*PSCredit_Int(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2040)= .34;
*PSCredit_Int(YrFull,'%UI_PPAR_PS%') = PSCredit_Int(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
*PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2021 and SimYr(Yr)<2040) = max((1 - (ERo(Yr,HMR,MP,'CO2') / PSCredit_Int(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);
*PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(PSCredit(Yr,'%UI_PPAR_PS%'HMR,MP)<0) = 0;
*map_PS_YPHM(Yr,PPAR,HMR,MP)=YES$( HMRMP(HMR,MP) and map_PS_YPH(Yr,PPAR,HMR) and PSMP(MP) and (PSCredit(Yr,PPAR,HMR,MP)>0));
PSReq.fx(Yr,PPAR)=PSReqFull(Yr,PPAR) * %UI_PS_ReqMult%;
$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_Smith_EmisTgt
*--------------------------------------------------
PSPrc.up(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021))=+INF;
*PSReq.up(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021))=+INF;
PSPrc.L(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021))=TmpPSPrc(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021));
*PSReq.L(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021))=TmpPSReq(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021));

*The nominal cap is a 3% decline from 2020 BL emissions.
put dummy;
put_utility 'gdxin' / '%UI_RootDir%\..\%UI_vRS1%\Output\%UI_RefScen1%\%UI_vRS1%_%UI_RefScen1%';
execute_load EmisYP_PS;
putclose;
EmisRefPS(Yr,PPAR) = EmisYP_PS(Yr,PPAR,'CO2');
*EmisCapPS(Yr,PPAR) = EmisYP_PS(Yr,PPAR,'CO2');
*EmisRefPS(Yr,PPAR)=sum((HMR,MP),EmisAnn(Yr,HMR,MP,'CO2')*map_PS_PHM(PPAR,HMR,MP));
EmisRefFullPS(YrFull,PPAR)=sum(Yrdup,EmisRefPS(Yrdup,PPAR)*SimYrWgtKnl(YrFull,Yrdup));
EmisCapPS(Yr,PPAR) = EmisRefFullPS(Yr,PPAR);

*PSCredit_Int(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2030)= .64;
*PSCredit_Int(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2030 and SimYrFull(YrFull)<2035)= .54;
*PSCredit_Int(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2035 and SimYrFull(YrFull)<2040)= .44;
*PSCredit_Int(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2040)= .34;
*PSCredit_Int(YrFull,'%UI_PPAR_PS%') = PSCredit_Int(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
*PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2021 and SimYr(Yr)<2040) = max((1 - (ERo(Yr,HMR,MP,'CO2') / PSCredit_Int(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);
*PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(PSCredit(Yr,'%UI_PPAR_PS%'HMR,MP)<0) = 0;
*map_PS_YPHM(Yr,PPAR,HMR,MP)=YES$( HMRMP(HMR,MP) and map_PS_YPH(Yr,PPAR,HMR) and PSMP(MP) and (PSCredit(Yr,PPAR,HMR,MP)>0));

PSReq.fx(Yr,'Nat')$((SimYr(Yr)>=2021))= 0.8;
PSReq.L(Yr,'Nat')$((SimYr(Yr)>=2021))= 0.8;

$setglobal UI_PSPolType Req_Cap

$elseif.ps_pol %UI_PSPol% == CES_CO
*--------------------------------------------------
PSPrc.up(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2022))=+INF;
PSPrc.l(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2022)) = TmpPSPrc(Yr,'CO');

PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)<2022) = 0;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2022) = 0.8;

PSReq.fx(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_Nat
*--------------------------------------------------
PSPrc.up(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2022))=+INF;
PSPrc.l(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2022)) = TmpPSPrc(Yr,'Nat');

PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)<2022) = 0;
PSReqFull(YrFull,'%UI_PPAR_PS%')$((SimYrFull(YrFull)>=2022)and (SimYrFull(YrFull)<=2034)) = 0.5 + .04*(SimYrFull(YrFull)-2022);

PSReq.fx(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_SFC2021
*--------------------------------------------------
PSPrc.up(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2022))=+INF;
PSPrc.l(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2022)) = TmpPSPrc(Yr,'Nat');

PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)<2022)                                 = 0;
PSReqFull(YrFull,'%UI_PPAR_PS%')$((SimYrFull(YrFull)>=2022)and (SimYrFull(YrFull)<=2034)) = 0.56 + .035*(SimYrFull(YrFull)-2022);
PSReqFull(YrFull,'%UI_PPAR_PS%')$((SimYrFull(YrFull)>=2035))                              = 1;

PSReq.fx(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_Bank
*--------------------------------------------------

*Banking
PSPrcBank.up(Yr,'%UI_PPAR_PS%')$(sum((HMR),map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and SimYr(Yr) >= 2022)= +INF;
PSPrcBank.l(Yr,'%UI_PPAR_PS%')$(sum((HMR),map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and SimYr(Yr) >= 2022) = TmpPSPrcBank(Yr,'Nat');


PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)<2022)                                 = 0;
PSReqFull(YrFull,'%UI_PPAR_PS%')$((SimYrFull(YrFull)>=2022)and (SimYrFull(YrFull)<=2034)) = 0.56 + .03*(SimYrFull(YrFull)-2022);
PSReqFull(YrFull,'%UI_PPAR_PS%')$((SimYrFull(YrFull)>=2035))                              = .95;

PSReq.fx(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_Smith2023
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023))=+INF;
PSPrc.L(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023))=TmpPSPrc(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023));

*Y6 = 2021, Y24 = 2039
PSReqFull('Yr8','%UI_PPAR_PS%')  = .57;
PSReqFull('Yr9','%UI_PPAR_PS%')  = .59;
PSReqFull('Yr10','%UI_PPAR_PS%') = .61;
PSReqFull('Yr11','%UI_PPAR_PS%') = .62;
PSReqFull('Yr12','%UI_PPAR_PS%') = .64;
PSReqFull('Yr13','%UI_PPAR_PS%') = .65;
PSReqFull('Yr14','%UI_PPAR_PS%') = .67;
PSReqFull('Yr15','%UI_PPAR_PS%') = .69;
PSReqFull('Yr16','%UI_PPAR_PS%') = .70;
PSReqFull('Yr17','%UI_PPAR_PS%') = .72;
PSReqFull('Yr18','%UI_PPAR_PS%') = .74;
PSReqFull('Yr19','%UI_PPAR_PS%') = .75;
PSReqFull('Yr20','%UI_PPAR_PS%') = .77;
PSReqFull('Yr21','%UI_PPAR_PS%') = .79;
PSReqFull('Yr22','%UI_PPAR_PS%') = .81;
PSReqFull('Yr23','%UI_PPAR_PS%') = .82;
PSReqFull('Yr24','%UI_PPAR_PS%') = .84;
PSReqFull(Yr,'%UI_PPAR_PS%')$(SimYr(Yr)<2055)     = .84 + .01*(SimYr(Yr)-2039);
PSReqFull(Yr,'%UI_PPAR_PS%')$(SimYr(Yr)>=2055)    = 1;

PSReq.fx(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_Smith2023-banking
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
*Banking
PSPrcBank.up(Yr,'%UI_PPAR_PS%')$(sum((Yr,HMR),map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)))= +INF;
PSPrcBank.l(Yr,'%UI_PPAR_PS%')$(sum((Yr,HMR),map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR))) = TmpPSPrcBank(Yr,'%UI_PPAR_PS%');

*Y6 = 2021, Y24 = 2039
PSReqFull('Yr8','%UI_PPAR_PS%')  = .57;
PSReqFull('Yr9','%UI_PPAR_PS%')  = .59;
PSReqFull('Yr10','%UI_PPAR_PS%') = .61;
PSReqFull('Yr11','%UI_PPAR_PS%') = .62;
PSReqFull('Yr12','%UI_PPAR_PS%') = .64;
PSReqFull('Yr13','%UI_PPAR_PS%') = .65;
PSReqFull('Yr14','%UI_PPAR_PS%') = .67;
PSReqFull('Yr15','%UI_PPAR_PS%') = .69;
PSReqFull('Yr16','%UI_PPAR_PS%') = .70;
PSReqFull('Yr17','%UI_PPAR_PS%') = .72;
PSReqFull('Yr18','%UI_PPAR_PS%') = .74;
PSReqFull('Yr19','%UI_PPAR_PS%') = .75;
PSReqFull('Yr20','%UI_PPAR_PS%') = .77;
PSReqFull('Yr21','%UI_PPAR_PS%') = .79;
PSReqFull('Yr22','%UI_PPAR_PS%') = .81;
PSReqFull('Yr23','%UI_PPAR_PS%') = .82;
PSReqFull('Yr24','%UI_PPAR_PS%') = .84;

PSReq.fx(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')=PSReqFull(Yr,'%UI_PPAR_PS%');

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_Nat2022
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023))=+INF;
PSPrc.L(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023))=TmpPSPrc(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023));

*Y6 = 2021, Y24 = 2039
PSReqFull('Yr3','%UI_PPAR_PS%') = 0.44;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2022 and SimYrFull(YrFull)<=2032)
                                = 0.44 + ((SimYrFull(YrFull)-2022)*(.36/10));
PSReqFull('Yr11','%UI_PPAR_PS%')= 0.80;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2033 and SimYrFull(YrFull)<=2050)
                                = 0.80 + ((SimYrFull(YrFull)-2032)*(.20/18));
PSReqFull('Yr31','%UI_PPAR_PS%')= 1.00;

PSReq.fx(Yr,'%UI_PPAR_PS%')     = PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')      = PSReqFull(Yr,'%UI_PPAR_PS%');

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_Nat2022-banking
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
*Banking
PSPrcBank.up(Yr,'%UI_PPAR_PS%')$(sum((Yr,HMR),map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)))= +INF;
PSPrcBank.l(Yr,'%UI_PPAR_PS%')$(sum((Yr,HMR),map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR))) = TmpPSPrcBank(Yr,'%UI_PPAR_PS%');

*Y6 = 2021, Y24 = 2039
*Y6 = 2021, Y24 = 2039

*PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2025) = 1.00;

*$ontext
PSReqFull('Yr3','%UI_PPAR_PS%') = 0.44;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2022 and SimYrFull(YrFull)<=2032)
                                = 0.44 + ((SimYrFull(YrFull)-2022)*(.36/10));
PSReqFull('Yr16','%UI_PPAR_PS%')= 0.80;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2033 and SimYrFull(YrFull)<=2050)
                                = 0.80 + ((SimYrFull(YrFull)-2032)*(.20/18));
PSReqFull('Yr31','%UI_PPAR_PS%')= 1.00;

PSReq.fx(Yr,'%UI_PPAR_PS%')     = PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')      = PSReqFull(Yr,'%UI_PPAR_PS%');
*$offtext


$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_Nat2023
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023))=+INF;
PSPrc.L(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023))=TmpPSPrc(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023));

*Y8 = 2023, Y35 = 2050
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2023 and SimYrFull(YrFull)<=%UI_Tgt1Yr%)
                                 = %UI_TgtStrt%*.01 + ((SimYrFull(YrFull)-2023)*
                                         ((%UI_Tgt1% - %UI_TgtStrt%) / (%UI_Tgt1Yr% - 2023)) * .01  );
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)= %UI_Tgt1Yr%)
                                 = %UI_Tgt1%*.01;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=%UI_Tgt1Yr% and SimYrFull(YrFull)<=%UI_Tgt2Yr%)
                                 = %UI_Tgt1%*.01 + ((SimYrFull(YrFull)-%UI_Tgt1Yr%)*
                                         ((%UI_Tgt2% - %UI_Tgt1%) / (%UI_Tgt2Yr% - %UI_Tgt1Yr%)) * .01  );
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)= %UI_Tgt2Yr%)
                                 = %UI_Tgt2%*.01;

PSReq.fx(Yr,'%UI_PPAR_PS%')     = PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')      = PSReqFull(Yr,'%UI_PPAR_PS%');

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES_Nat2023-banking
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
*Banking
PSPrcBank.up(Yr,'%UI_PPAR_PS%')$(sum((Yr,HMR),map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)))= +INF;
PSPrcBank.l(Yr,'%UI_PPAR_PS%')$(sum((Yr,HMR),map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR))) = TmpPSPrcBank(Yr,'%UI_PPAR_PS%');

*Y8 = 2023, Y35 = 2050
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2023 and SimYrFull(YrFull)<=%UI_Tgt1Yr%)
                                 = %UI_TgtStrt%*.01 + ((SimYrFull(YrFull)-2023)*
                                         ((%UI_Tgt1% - %UI_TgtStrt%) / (%UI_Tgt1Yr% - 2023)) * .01  );
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)= %UI_Tgt1Yr%)
                                 = %UI_Tgt1%*.01;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=%UI_Tgt1Yr% and SimYrFull(YrFull)<=%UI_Tgt2Yr%)
                                 = %UI_Tgt1%*.01 + ((SimYrFull(YrFull)-%UI_Tgt1Yr%)*
                                         ((%UI_Tgt2% - %UI_Tgt1%) / (%UI_Tgt2Yr% - %UI_Tgt1Yr%)) * .01  );
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)= %UI_Tgt2Yr%)
                                 = %UI_Tgt2%*.01;

PSReq.fx(Yr,'%UI_PPAR_PS%')     = PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')      = PSReqFull(Yr,'%UI_PPAR_PS%');

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES80x30
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2023))=+INF;
PSPrc.L(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2023))=TmpPSPrc(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2023));

parameter
test_map(YrFull,PPAR,HMR)
;
test_map(YrFull,PPAR,HMR)=sum(Yr,map_PS_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr));

PSReqFull(YrFull,PPAR)$(sum((Yr,HMR),map_PS_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)) and SimYrFull(YrFull)=2022)
                                = 0.44;
PSReqFull(YrFull,PPAR)$(sum((Yr,HMR),map_PS_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)) and SimYrFull(YrFull)>=2022 and SimYrFull(YrFull)<=2030)
                                = 0.44 + ((SimYrFull(YrFull)-2022)*(0.36/8));
PSReqFull(YrFull,PPAR)$(sum((Yr,HMR),map_PS_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)) and SimYrFull(YrFull)=2030)
                                = 0.80;
PSReqFull(YrFull,PPAR)$(sum((Yr,HMR),map_PS_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)) and SimYrFull(YrFull)>2030 and SimYrFull(YrFull)<=2050)
                                = 0.80 + ((SimYrFull(YrFull)-2032)*(.20/20));
PSReqFull(YrFull,PPAR)$(sum((Yr,HMR),map_PS_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)) and SimYrFull(YrFull)>=2050)
                                = 1.00;

PSReq.fx(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)))     = PSReqFull(Yr,PPAR);
PSReq.l(Yr,PPAR)$(sum(HMR,map_PS_YPH(Yr,PPAR,HMR)))      = PSReqFull(Yr,PPAR);

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CES80x30p
*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023))=+INF;
PSPrc.L(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023))=TmpPSPrc(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2023));

PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)=2022) = 0.44;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2022 and SimYrFull(YrFull)<=2030)
                                = 0.44 + ((SimYrFull(YrFull)-2022)*(.36/8));
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)=2030)= 0.80;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>2030 and SimYrFull(YrFull)<=2050)
                                = 0.80 + ((SimYrFull(YrFull)-2032)*(.20/20));
PSReqFull('Yr35','%UI_PPAR_PS%')= 1.00;

PSReq.fx(Yr,'%UI_PPAR_PS%')     = PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')      = PSReqFull(Yr,'%UI_PPAR_PS%');
*$offtext

$setglobal UI_PSPolType Req

$elseif.ps_pol %UI_PSPol% == CACES

*--------------------------------------------------
*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2030))=+INF;
PSPrc.L(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2030))=TmpPSPrc(Yr,'%UI_PPAR_PS%')$(sum(HMR,map_PS_YPH(Yr,'%UI_PPAR_PS%',HMR)) and (SimYr(Yr)>=2030));

PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)=2030)= 0.60;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)> SimYrFull('Yr11') and SimYrFull(YrFull)<= SimYrFull('Yr16'))
                                = 0.60 + (SimYrFull(YrFull)-SimYrFull('Yr11'))*((0.90-0.60)/(SimYrFull('Yr16')-SimYrFull('Yr11')));
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)=2035)= 0.90;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)> SimYrFull('Yr16') and SimYrFull(YrFull)<= SimYrFull('Yr21'))
                                = 0.90 + (SimYrFull(YrFull)-SimYrFull('Yr16'))*((0.95-0.90)/(SimYrFull('Yr21')-SimYrFull('Yr16')));
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)=2040)= 0.95;
PSReqFull(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2045)= 1.00;

PSReq.fx(Yr,'%UI_PPAR_PS%')     = PSReqFull(Yr,'%UI_PPAR_PS%');
PSReq.l(Yr,'%UI_PPAR_PS%')      = PSReqFull(Yr,'%UI_PPAR_PS%');


$setglobal UI_PSPolType Req

$endif.ps_pol


*Colorado CES
*-------------------------------------------------------------------------------------------
$ifthen.ces %UI_CES% == Yes

*Bounds on portfolio standard prices activate corresponding constraints.
map_PS_YPH(Yr,'CO',HMR) = YES$( HMR_CO(HMR) );
map_PS_YPHM(Yr,'CO',HMR,MP) = YES$( HMRMP(HMR,MP) and map_PS_YPH(Yr,'CO',HMR) and
                                         (MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Nuke')
                                           or MPFuel(MP,'Geo') or MPFuel(MP,'Hydro') ) );
map_PS_Sales_YPH(Yr,'CO',HMR) = YES$( HMR_CO(HMR) );

PSPrc.up(Yr,'CO')$(sum(HMR,map_PS_YPH(Yr,'CO',HMR)) and (SimYr(Yr)>=2020))=+INF;
PSPrc.l(Yr,'CO')$(sum(HMR,map_PS_YPH(Yr,'CO',HMR)) and (SimYr(Yr)>=2020)) = TmpPSPrc(Yr,'CO');
PSCredit(Yr,'CO',HMR,MP)$map_PS_YPHM(Yr,'CO',HMR,MP) = 1;

parameter
PSCo_frac
;

PSCo_frac =  0.51814401;


PSReqFull(YrFull,'CO')$(SimYrFull(YrFull)<2019) = 0;
PSReqFull('Yr4','CO')  = 0.025*PSCo_frac;
PSReqFull('Yr5','CO')  = 0.05*PSCo_frac;
PSReqFull('Yr6','CO')  = 0.075*PSCo_frac;
PSReqFull('Yr7','CO')  = 0.1*PSCo_frac;
PSReqFull('Yr8','CO')  = 0.125*PSCo_frac;
PSReqFull('Yr9','CO')  = 0.15*PSCo_frac;
PSReqFull('Yr10','CO') = 0.175*PSCo_frac;
PSReqFull('Yr11','CO') = 0.2*PSCo_frac;
PSReqFull('Yr12','CO') = 0.225*PSCo_frac;
PSReqFull('Yr13','CO') = 0.25*PSCo_frac;
PSReqFull('Yr14','CO') = 0.275*PSCo_frac;
PSReqFull('Yr15','CO') = 0.3*PSCo_frac;
PSReqFull('Yr16','CO') = 0.325*PSCo_frac;
PSReqFull('Yr17','CO') = 0.35*PSCo_frac;
PSReqFull('Yr18','CO') = 0.375*PSCo_frac;
PSReqFull('Yr19','CO') = 0.4*PSCo_frac;
PSReqFull('Yr20','CO') = 0.425*PSCo_frac;
PSReqFull('Yr21','CO') = 0.45*PSCo_frac;
PSReqFull('Yr22','CO') = 0.475*PSCo_frac;
PSReqFull('Yr23','CO') = 0.5*PSCo_frac;
$onText
PSReqFull('Yr24','CO') = 0.525*PSCo_frac;
PSReqFull('Yr25','CO') = 0.55*PSCo_frac;
PSReqFull('Yr26','CO') = 0.575*PSCo_frac;
PSReqFull('Yr27','CO') = 0.6*PSCo_frac;
PSReqFull('Yr28','CO') = 0.625*PSCo_frac;
PSReqFull('Yr29','CO') = 0.65*PSCo_frac;
PSReqFull('Yr30','CO') = 0.675*PSCo_frac;
PSReqFull('Yr31','CO') = 0.7*PSCo_frac;
PSReqFull('Yr32','CO') = 0.725*PSCo_frac;
PSReqFull('Yr33','CO') = 0.75*PSCo_frac;
PSReqFull('Yr34','CO') = 0.775*PSCo_frac;
PSReqFull('Yr35','CO') = 0.8*PSCo_frac;
$offText
PSReq.fx(Yr,'CO')=PSReqFull(Yr,'CO');
$endif.ces


*Renewable Portfolio Standards
**------------------------------------------------------------------------------------------
$ifthen.rps %UI_RPSReg% == Yes

map_PS_YPHM(Yr,PPAR,HMR,MP)$map_RPSReg0_YPH(Yr,PPAR,HMR) = Yes$( HMRMP(HMR,MP) and (MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro') or MPFuel(MP,'Geo')) );

PSPrc.up(Yr,PPAR)$(sum(HMR,map_RPSReg0_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2023))=+INF;
PSPrc.l(Yr,PPAR)$(sum(HMR,map_RPSReg0_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2023)) = TmpPSPrc(Yr,PPAR);


*modify VA RPS to take nuclear into account
RPS0(YrFull,"VA")$(sum((Yr,Sector),Cons0(Yr,'VA',Sector)*SimYrWgtKnl(YrFull,Yr))<>0)
                  =  (RPS0(YrFull,"VA")*(sum((Yr,Sector),Cons0(Yr,'VA',Sector)*SimYrWgtKnl(YrFull,Yr)) - sum((Sea,TB),sum(Yr,NPCap0('VA','Ex Steam Nuclear')*OpNPCapRat('VA','Ex Steam Nuclear',Sea)*ACFGen(Yr,'VA','Ex Steam Nuclear',Sea,TB)*Hrs(Sea,TB)*SimYrWgtKnl(YrFull,Yr)))))
                         /sum((Yr,Sector),Cons0(Yr,'VA',Sector)*SimYrWgtKnl(YrFull,Yr));

*assign RPS0 values to each region
PSReqFull(YrFull,PPAR)$(sum((HMR,Sea,TB),sum((Yr,Sector),Cons0(Yr,HMR,Sector)*map_RPSReg0_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)))<>0)
                 = sum((Yr,HMR),RPS0(YrFull,HMR)*sum(Sector,Cons0(Yr,HMR,Sector))*map_RPSReg0_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr))
                         / sum(HMR,sum((Yr,Sector),Cons0(Yr,HMR,Sector)*map_RPSReg0_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)));

PSReq.fx(Yr,PPAR)$sum((HMR),map_RPSReg0_YPH(Yr,PPAR,HMR))=PSReqFull(Yr,PPAR);

*----------------------------------
$endif.rps

*Renewable Portfolio Standards
**------------------------------------------------------------------------------------------
$ifthen.rps %UI_RPS% == Yes

map_PS_YPHM(Yr,PPAR,HMR,MP)$map_RPS0_YPH(Yr,PPAR,HMR) = Yes$( HMRMP(HMR,MP) and (MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro')) );

PSPrc.up(Yr,PPAR)$(sum(HMR,map_RPS0_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021))=+INF;
PSPrc.l(Yr,PPAR)$(sum(HMR,map_RPS0_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021)) = TmpPSPrc(Yr,PPAR);

*modify VA RPS to take nuclear into account
RPS0(YrFull,"VA")$(sum((Yr,Sector),Cons0(Yr,'VA',Sector)*SimYrWgtKnl(YrFull,Yr))<>0)
                  =  (RPS0(YrFull,"VA")*(sum((Yr,Sector),Cons0(Yr,'VA',Sector)*SimYrWgtKnl(YrFull,Yr))) - sum((Sea,TB),sum(Yr,NPCap0('VA','Ex Steam Nuclear')*OpNPCapRat('VA','Ex Steam Nuclear',Sea)*ACFGen(Yr,'VA','Ex Steam Nuclear',Sea,TB)*Hrs(Sea,TB)*SimYrWgtKnl(YrFull,Yr))))
                         /sum((Sea,TB),sum((Yr,Sector),Cons0(Yr,'VA',Sector)*SimYrWgtKnl(YrFull,Yr)));

*assign RPS0 values to each state
PSReqFull(YrFull,PPAR)$sum((Yr,HMR),map_RPS0_YPH(Yr,PPAR,HMR))= sum(HMR,RPS0(YrFull,HMR) * sum(Yr,map_RPS0_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)));

PSReq.fx(Yr,PPAR)$sum((HMR),map_RPS0_YPH(Yr,PPAR,HMR))=PSReqFull(Yr,PPAR);

*----------------------------------
$endif.rps

*Renewable Portfolio Standards  as Subsidy
**------------------------------------------------------------------------------------------
$ifthen.rps %UI_RPS% == Prc

$set UI_PPAR State
$include SetPPARMapping
map_RPS0_YPH(Yr,PPAR,HMR)        = yes$(map_tmp_YPH(Yr,PPAR,HMR) and RPS0(Yr,HMR));
map_PS_YPH(Yr,PPAR,HMR)$map_RPS0_YPH(Yr,PPAR,HMR) = yes;
map_PS_Sales_YPH(Yr,PPAR,HMR)    = map_PS_YPH(Yr,PPAR,HMR);

map_PS_YPHM(Yr,PPAR,HMR,MP)$map_RPS0_YPH(Yr,PPAR,HMR) = Yes$( HMRMP(HMR,MP) and (MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro')) );

*import portfolio standard prices
parameter
tmp_PSPrc_lo(Yr,PPAR)
tmp_PSPrc_l(Yr,PPAR)
tmp_PSPrc_up(Yr,PPAR)
;

tmp_PSPrc_lo(Yr,PPAR) = PSPrc.lo(Yr,PPAR);
tmp_PSPrc_l(Yr,PPAR) = PSPrc.l(Yr,PPAR);
tmp_PSPrc_up(Yr,PPAR) = PSPrc.up(Yr,PPAR);

*Read in reference capacity
put dummy;
put_utility 'gdxin' / '%UI_RootDir%\..\%UI_vRS1%\Output\%UI_RefScen1%\%UI_vRS1%_%UI_RefScen1%';
execute_load PSPrc.l;
putclose;


display
PSPrc.l
;

PSPrc.fx(Yr,PPAR)$(sum(HMR,map_RPS0_YPH(Yr,PPAR,HMR)))=PSPrc.l(Yr,PPAR);
PSPrc.lo(Yr,PPAR)$(not sum(HMR,map_RPS0_YPH(Yr,PPAR,HMR)))=tmp_PSPrc_lo(Yr,PPAR);
PSPrc.l(Yr,PPAR)$(not sum(HMR,map_RPS0_YPH(Yr,PPAR,HMR)))=tmp_PSPrc_l(Yr,PPAR);
PSPrc.up(Yr,PPAR)$(not sum(HMR,map_RPS0_YPH(Yr,PPAR,HMR)))=tmp_PSPrc_up(Yr,PPAR);
*PSPrc.l(Yr,PPAR)$(sum(HMR,map_RPS0_YPH(Yr,PPAR,HMR)) and (SimYr(Yr)>=2021)) = TmpPSPrc(Yr,PPAR);

PSReqFull(YrFull,PPAR)$sum((Yr,HMR),map_RPS0_YPH(Yr,PPAR,HMR))= sum(HMR,RPS0(YrFull,HMR) * sum(Yr,map_RPS0_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)));

PSReq.fx(Yr,PPAR)$sum((HMR),map_RPS0_YPH(Yr,PPAR,HMR))=PSReqFull(Yr,PPAR);

*----------------------------------
$endif.rps



*VA RPS -- if we want this to be consistent, should switch to PJMRPS, not PJM
**------------------------------------------------------------------------------------------
$ifthen.varps %UI_VARPS% == Yes

*replace PSReq for VA
PSReqFull(YrFull,'VA')$(SimYrFull(YrFull)<=2024) =  RPS0(YrFull,'VA')*0.00;
PSReqFull(YrFull,'VA')$(SimYrFull(YrFull)>=2025) =  RPS0(YrFull,'VA')*0.75;
PSReq.fx(Yr,'VA') = PSReqFull(Yr,'VA');

*turn on PJM maps
map_PS_YPH(Yr,'PJM',HMR)$(HMR_PJM(HMR) and SimYr(Yr)>=2021) = YES;
map_PS_YPHM(Yr,'PJM',HMR,MP)$map_PS_YPH(Yr,'PJM',HMR) = Yes$( HMRMP(HMR,MP) and (MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro')) );

PSReqFull(YrFull,'PJM')$(SimYrFull(YrFull)>=2021 and (sum((HMR,Sea,TB),sum(Yr,EConsExo(Yr,HMR,Sea,TB)*SimYrWgtKnl(YrFull,Yr))*HMR_PJM(HMR))<>0)) = Sum(HMR,Sum((Sea,TB),sum(Yr,EConsExo(Yr,HMR,Sea,TB)*SimYrWgtKnl(YrFull,Yr))*RPS0(YrFull,HMR)*HMR_PJM(HMR)))/sum((HMR,Sea,TB),sum(Yr,EConsExo(Yr,HMR,Sea,TB)*SimYrWgtKnl(YrFull,Yr))*HMR_PJM(HMR));
PSReq.fx(Yr,'PJM')$(SimYr(Yr)>=2021) = PSReqFull(Yr,'PJM');

PSPrc.up(Yr,'PJM')$(SimYr(Yr)>=2021) = +INF;
PSPrc.l(Yr,'PJM')$(SimYr(Yr)>=2021) = TmpPSPrc(Yr,'PJM');

*Enable ACP
ACPquantity.up(Yr,'VA','VA') = +Inf;
ACPprice(Yr,'VA','VA') = 45;
ACPquantity.up(Yr,'PJM','VA') = +Inf;
ACPprice(Yr,'PJM','VA') = 45;
*----------------------------------
$endif.varps

*National RPS for AEO's projection of Voluntary RECs
*-------------------------------------------------------------------------------
$ifthen.NatRPS  %UI_NatRPS% ==Yes

*Wind Portfolio Standard

*Set mappings
map_PS_YPH(Yr,'NatWPS',HMR) = YES;
map_PS_YPHM(Yr,'NatWPS',HMR,MP) = YES$( HMRMP(HMR,MP) and map_PS_YPH(Yr,'NatWPS',HMR) and MPFuel(MP,'Wind'));
map_PS_Sales_YPH(Yr,'NatWPS',HMR) = YES;

*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,'NatWPS')$(sum(HMR,map_PS_YPH(Yr,'NatWPS',HMR)) and (SimYr(Yr)>=2020))=+INF;
PSPrc.l(Yr,'NatWPS')$(sum(HMR,map_PS_YPH(Yr,'NatWPS',HMR)) and (SimYr(Yr)>=2020)) = TmpPSPrc(Yr,'NatWPS');
PSCredit(Yr,'NatWPS',HMR,MP)$map_PS_YPHM(Yr,'NatWPS',HMR,MP) = 1;

*Set requirement
PSReqQuant(YrFull,'NatWPS') = sum((Yr,HMR,Sea),GenAEOSeaFuel(Yr,HMR,Sea,'Wind')*SimYrWgtKnl(YrFull,Yr));
PSReqFull(Yr,'NatWPS') = PSReqQuant(Yr,'NatWPS') / sum((HMR,Sector),Cons0(Yr,HMR,Sector));
PSReq.fx(Yr,'NatWPS')=PSReqFull(Yr,'NatWPS');

*Solar Portfolio Standard

*Set mappings
map_PS_YPH(Yr,'NatSPS',HMR) = YES;
map_PS_YPHM(Yr,'NatSPS',HMR,MP) = YES$( HMRMP(HMR,MP) and map_PS_YPH(Yr,'NatSPS',HMR) and MPFuel(MP,'Solar'));
map_PS_Sales_YPH(Yr,'NatSPS',HMR) = YES;

*Bounds on portfolio standard prices activate corresponding constraints.
PSPrc.up(Yr,'NatSPS')$(sum(HMR,map_PS_YPH(Yr,'NatSPS',HMR)) and (SimYr(Yr)>=2020))=+INF;
PSPrc.l(Yr,'NatSPS')$(sum(HMR,map_PS_YPH(Yr,'NatSPS',HMR)) and (SimYr(Yr)>=2020)) = TmpPSPrc(Yr,'NatSPS');
PSCredit(Yr,'NatSPS',HMR,MP)$map_PS_YPHM(Yr,'NatSPS',HMR,MP) = 1;

*Set requirement
PSReqQuant(YrFull,'NatSPS') = sum((Yr,HMR,Sea),GenAEOSeaFuel(Yr,HMR,Sea,'Solar')*SimYrWgtKnl(YrFull,Yr));
PSReqFull(Yr,'NatSPS') = PSReqQuant(Yr,'NatSPS') / sum((HMR,Sector),Cons0(Yr,HMR,Sector));
PSReq.fx(Yr,'NatSPS')=PSReqFull(Yr,'NatSPS');

$endif.NatRPS


*National RPS as a price for AEO's projection of Voluntary RECs
*---------------------------------------------------------------
$ifthen.NatRPSPrc  %UI_NatRPS% == Prc

*import portfolio standard prices
parameter
tmp_PSPrc_lo(Yr,PPAR)
tmp_PSPrc_l(Yr,PPAR)
tmp_PSPrc_up(Yr,PPAR)
;

tmp_PSPrc_lo(Yr,PPAR) = PSPrc.lo(Yr,PPAR);
tmp_PSPrc_l(Yr,PPAR) = PSPrc.l(Yr,PPAR);
tmp_PSPrc_up(Yr,PPAR) = PSPrc.up(Yr,PPAR);

*Read in reference capacity
put dummy;
put_utility 'gdxin' / '%UI_RootDir%\..\%UI_vRS1%\Output\%UI_RefScen1%\%UI_vRS1%_%UI_RefScen1%';
execute_load PSPrc.l;
putclose;


display
PSPrc.l
;
*Wind Portfolio Standard  mapping
map_PS_YPH(Yr,'NatWPS',HMR) = YES;
map_PS_YPHM(Yr,'NatWPS',HMR,MP) = YES$( HMRMP(HMR,MP) and map_PS_YPH(Yr,'NatWPS',HMR) and MPFuel(MP,'Wind'));
map_PS_Sales_YPH(Yr,'NatWPS',HMR) = YES;

*Solar Portfolio Standard mapping
map_PS_YPH(Yr,'NatSPS',HMR) = YES;
map_PS_YPHM(Yr,'NatSPS',HMR,MP) = YES$( HMRMP(HMR,MP) and map_PS_YPH(Yr,'NatSPS',HMR) and MPFuel(MP,'Solar'));
map_PS_Sales_YPH(Yr,'NatSPS',HMR) = YES;

*set prices
PSPrc.fx(Yr,'NatWPS')= PSPRc.l(Yr,'NatWPS');
PSPrc.fx(Yr,'NatSPS')= PSPRc.l(Yr,'NatSPS');

*restor prices for other policies
PSPrc.lo(Yr,PPAR)$(not PPAR_NatRPS(PPAR)) = tmp_PSPrc_lo(Yr,PPAR);
PSPrc.l(Yr,PPAR)$(not PPAR_NatRPS(PPAR))  =  tmp_PSPrc_l(Yr,PPAR);
PSPrc.up(Yr,PPAR)$(not PPAR_NatRPS(PPAR)) = tmp_PSPrc_up(Yr,PPAR);

$endif.NatRPSPrc
*----------------------------------------------------------------



*National RPS as a price for AEO's projection of Voluntary RECs
*---------------------------------------------------------------
$ifthen.NatRPSPrc  %UI_CESPrc% == Yes

*import portfolio standard prices
parameter
tmp2_PSPrc_lo(Yr,PPAR)
tmp2_PSPrc_l(Yr,PPAR)
tmp2_PSPrc_up(Yr,PPAR)
;

tmp2_PSPrc_lo(Yr,PPAR) = PSPrc.lo(Yr,PPAR);
tmp2_PSPrc_l(Yr,PPAR) = PSPrc.l(Yr,PPAR);
tmp2_PSPrc_up(Yr,PPAR) = PSPrc.up(Yr,PPAR);

*Read in reference capacity
put dummy;
put_utility 'gdxin' / '%UI_RootDir%\..\%UI_vRS3%\Output\%UI_RefScen3%\%UI_vRS3%_%UI_RefScen3%';
execute_load PSPrc.l;
putclose;


display
PSPrc.l
;

*set prices
PSPrc.fx(Yr,PPAR)$%UI_PPAR_set%(PPAR)= PSPRc.l(Yr,PPAR);

*restor prices for other policies
PSPrc.lo(Yr,PPAR)$(not %UI_PPAR_set%(PPAR)) = tmp2_PSPrc_lo(Yr,PPAR);
PSPrc.l(Yr,PPAR)$(not %UI_PPAR_set%(PPAR))  =  tmp2_PSPrc_l(Yr,PPAR);
PSPrc.up(Yr,PPAR)$(not %UI_PPAR_set%(PPAR)) = tmp2_PSPrc_up(Yr,PPAR);

$endif.NatRPSPrc
*----------------------------------------------------------------

*-----------------------------------------------------

*========================================================= 2021 Tax Credits ===================================================================================================================================

$ifthen.NatTC %UI_TCPol% ==  Nat2020

         PTCPrc(Yr,'%UI_PPAR_TC%')$(sum(HMR,map_PTC_YPH(Yr,'%UI_PPAR_TC%',HMR)))              = 25 * (1/Inflation('2020'));

         PTCHaircut(YrFull,'%UI_PPAR_TC%')$(sum((Yr,HMR),map_PTC_YPH(Yr,'%UI_PPAR_TC%',HMR))) = TCHaircut;

         ITCPct(Yr,'%UI_PPAR_TC%')$(sum(HMR,map_ITC_YPH(Yr,'%UI_PPAR_TC%',HMR)))              = 0.30;

         ITCHaircut(YrFull,'%UI_PPAR_TC%')$(sum((Yr,HMR),map_ITC_YPH(Yr,'%UI_PPAR_TC%',HMR))) = TCHaircut;


*========================================================= IRA Tax Credits ===================================================================================================================================


$elseif.NatTC %UI_TCPol% == IRA

*direct pay covers about 75% of all cost reductions that full direct pay would
*ITC and PTC initial values

         PTCPrc(Yr,'%UI_PPAR_TC%')$(sum(HMR,map_PTC_YPH(Yr,'%UI_PPAR_TC%',HMR)))               = 25 * (1/Inflation('2020'));

         PTCHaircut(YrFull,'%UI_PPAR_TC%')$(sum((Yr,HMR),map_PTC_YPH(Yr,'%UI_PPAR_TC%',HMR)))  = TCHaircut + .10;

         ITCPct(Yr,'%UI_PPAR_TC%')$(sum(HMR,map_ITC_YPH(Yr,'%UI_PPAR_TC%',HMR)))               = 0.30;

         ITCHaircut(YrFull,'%UI_PPAR_TC%')$(sum((Yr,HMR),map_ITC_YPH(Yr,'%UI_PPAR_TC%',HMR)))  = TCHaircut + .10;

$ifthen.EPRIScens %UI_EPRIScen% == High

         PTCHaircut(YrFull,'%UI_PPAR_TC%')$(sum((Yr,HMR),map_PTC_YPH(Yr,'%UI_PPAR_TC%',HMR))) = 1 - ((1 - PTCHaircut(YrFull,'%UI_PPAR_TC%'))/2);
         ITCHaircut(YrFull,'%UI_PPAR_TC%')$(sum((Yr,HMR),map_ITC_YPH(Yr,'%UI_PPAR_TC%',HMR))) = 1 - ((1 - ITCHaircut(YrFull,'%UI_PPAR_TC%'))/2);

$elseif.EPRIScens %UI_EPRIScen% == Low

         PTCHaircut(YrFull,'%UI_PPAR_TC%')$(sum((Yr,HMR),map_PTC_YPH(Yr,'%UI_PPAR_TC%',HMR))) = 1 - ((1 - PTCHaircut(YrFull,'%UI_PPAR_TC%'))*2);
         ITCHaircut(YrFull,'%UI_PPAR_TC%')$(sum((Yr,HMR),map_ITC_YPH(Yr,'%UI_PPAR_TC%',HMR))) = 1 - ((1 - ITCHaircut(YrFull,'%UI_PPAR_TC%'))*2);

$endif.EPRIScens

*Bonuses
Parameter
DomesticBonus(Yr,HMR)
ECPctHMR(Yr,HMR)
ECPctArea(HMR);

$call gdxxrw.exe "ECBonus.xlsx" par=ECPctArea rdim=1 rng=ECPctArea!A2:B53
$gdxin "ECBonus.gdx"
$load ECPctArea
$gdxin

DomesticBonus(Yr,HMR)   = 0;
DomesticBonus(Yr,HMR)$(SimYr(Yr) >= 2025 and SimYr(Yr) <= 2050) =
                         ((SimYr(Yr) - 2025) / (2050-2025));
DomesticBonus(Yr,HMR)$(SimYr(Yr) >= 2050) = 1;

$ifthen.EPRIDomBonus %UI_EPRIScen% == High
DomesticBonus(Yr,HMR)$(SimYr(Yr) >= 2023) = min(DomesticBonus(Yr,HMR)+.2,1);
$elseif.EPRIDomBonus %UI_EPRIScen% == Low
DomesticBonus(Yr,HMR)$(SimYr(Yr) >= 2023) = max(DomesticBonus(Yr,HMR)-.2,0);
$endif.EPRIDomBonus


ECPctHMR(Yr,HMR)$(SimYr(Yr)>= 2023) = ECPctArea(HMR);
ECPctHMR(Yr,HMR)$(SimYr(Yr)<= 2022) = 0;

$ifthen.EPRIDomBonus %UI_EPRIScen% == High
ECPctHMR(Yr,HMR)$(SimYr(Yr) >= 2023) = min(ECPctHMR(Yr,HMR)+.2,1);
$elseif.EPRIDomBonus %UI_EPRIScen% == Low
ECPctHMR(Yr,HMR)$(SimYr(Yr) >= 2023) = max(ECPctHMR(Yr,HMR)-.2,0);
$endif.EPRIDomBonus

Parameter
Cost20Year(Yr,HMR,MP)
ITCValue(Yr,HMR,MP)
PTCValue(Yr,HMR,MP)
;


scalars
BetaPTC
BetaITC;

BetaPTC = sum(YrFull,beta(YrFull)$(SimYrFull(YrFull) <= DataYr + TCWindow )) ;
BetaITC = sum(YrFull,beta(YrFull)$(SimYrFull(YrFull) <= DataYr + InvPlnHrzn )) ;


PTCMP(MP)$(MPNew(MP)and(MPFuel(MP,'Solar')or MPFuel(MP,'Wind')
                         or MPFuel(MP,'Hydro') or MPFuel(MP,'Nuke')
                         or MPFuel(MP,'Geo') or MPFuel(MP,'Bio')))       = Yes;

ITCMP(MP)$(MPNew(MP)and(MPFuel(MP,'Solar')or MPFuel(MP,'Wind')
                         or MPFuel(MP,'Hydro') or MPFuel(MP,'Nuke')
                         or MPFuel(MP,'Geo') or MPFuel(MP,'Bio')
                         or MPFuel(MP,'Storage')))                       = Yes;


*        IRA (Solar/Wind PTC and Battery Storage ITC) (no phaseout)
PTCredit(Yr,PPAR,HMR,MP)$(sum((Yrdup,HMRdup,MPdup),map_PTC_YPHM(Yrdup,PPAR,HMRdup,MPdup)) and PTCMP(MP) and (SimYr(Yr) >= 2023)) = 1 + .1 * ( ECPctHMR(Yr,HMR) + DomesticBonus(Yr,HMR) );
ITCredit(Yr,PPAR,HMR,MP)$(sum((Yrdup,HMRdup,MPdup),map_ITC_YPHM(Yrdup,PPAR,HMRdup,MPdup)) and ITCMP(MP) and (SimYr(Yr) >= 2023)) = ( ITCPct(Yr,PPAR) + .1 * ( ECPctHMR(Yr,HMR) + DomesticBonus(Yr,HMR) ) )/ ITCPct(Yr,PPAR);

Cost20Year(Yr,HMR,MP) =  sum(YrFull,
                                sum(Yrdup,( ((1-betaRt)**(SimYrFull(YrFull)-SimYr(Yr)))* SimYrWgtKnl(YrFull,Yrdup)*
                                          (sum((Sea,TB),ACFGen(Yrdup,HMR,MP,Sea,TB)*OpNPCapRat(HMR,MP,Sea)*Hrs(Sea,TB)*
                                                  ( VOM(Yrdup,HMR,MP)
                                                  +FCo(Yr,HMR,MP,Sea)$(not sum(Fuel,MPFC(MP,Fuel)))
                                                  +(FCiRef(Yrdup,HMR,'Coal')*HR(Yrdup,HMR,MP)*1E-3)$(MPFC(MP,'Coal') and not (MPNew(MP) and MPCofire(MP)))
                                                  +(((1-CofirePct(HMR,MP))*FCiRef(Yrdup,HMR,'Coal') + CofirePct(HMR,MP)*FCiRef(Yrdup,HMR,'NG')) * HR(Yrdup,HMR,MP)*1E-3)$(MPFC(MP,'Coal') and (MPNew(MP) and MPCofire(MP)))
                                                  +(FCiRef(Yrdup,HMR,'NG')*HR(Yrdup,HMR,MP)*1E-3)$MPFC(MP,'NG')
                                                  +(FCiRef(Yrdup,HMR,'Oil')*HR(Yrdup,HMR,MP)*1E-3)$MPFC(MP,'Oil')
                                                  +sum(Fuel,CalGen.L(Yrdup,HMR,Fuel)$(MPFuel(MP,Fuel) and CalGenIncl(Yrdup,HMR,Fuel)))
                                                  +CalGenTot.L(Yrdup,HMR)$(HMRMP(HMR,MP) and (not MPFuel(MP,'Storage')))
                                                  +CalEmis.L(Yrdup)*ERo(Yr,HMR,MP,'CO2')
                                                  +CalEmisRGGI.L(Yrdup)*ERo(Yr,HMR,MP,'CO2')$HMRRGGICal(HMR)
                                                  +sum(PPAR,AlwPrc.L(Yrdup,PPAR)*map_EmisPol_YPHM(Yrdup,PPAR,HMR,MP))*ERo(Yrdup,HMR,MP,'CO2')
                                                  +sum(PPAR,AlwPrcBank.L(Yrdup,PPAR)*map_EmisPol_YPHM(Yrdup,PPAR,HMR,MP))*ERo(Yrdup,HMR,MP,'CO2')
                                                  -sum(PPAR,PSPrc.l(Yrdup,PPAR)*PSCredit(Yrdup,PPAR,HMR,MP)$map_PS_YPHM(Yrdup,PPAR,HMR,MP))
                                                  )
                                                )
                                           +FOM(Yr,HMR,MP)$(not (MPCofire(MP) and MPNew(MP)))*1E3
                                           +CapCost(YrFull,HMR,MP)* 1000
                                          ))
                                )$(SimYrFull(YrFull) <= SimYrFull(Yr + InvPlnHrzn))
                         );


PTCValue(Yr,HMR,MP) = Cost20Year(Yr,HMR,MP)
                         - BetaPTC *(sum((Sea,TB),ACFGen(Yr,HMR,MP,Sea,TB)*OpNPCapRat(HMR,MP,Sea)*Hrs(Sea,TB))*
                                         sum(PPAR,PTCPrc(Yr,PPAR)*PTCredit(Yr,PPAR,HMR,MP)*PTCHaircut(Yr,PPAR)*map_PTC_YPHM(Yr,PPAR,HMR,MP)));

ITCValue(Yr,HMR,MP) = Cost20Year(Yr,HMR,MP)
                         - BetaITC *(CapCost(Yr,HMR,MP)* 1000 * (sum(PPAR,ITCPct(Yr,PPAR) * ITCredit(Yr,PPAR,HMR,MP) * ITCHaircut(Yr,PPAR))));


map_PTC_YPHM(Yr,PPAR,HMR,MP)$(SimYr(Yr) > 2022 and (PTCValue(Yr,HMR,MP) <= ITCValue(Yr,HMR,MP) )) =
                                         YES$( HMRMP(HMR,MP) and map_PTC_YPH(Yr,PPAR,HMR) and PTCMP(MP) );
map_PTC_YPHM(Yr,PPAR,HMR,MP)$(SimYr(Yr) > 2022 and (ITCValue(Yr,HMR,MP) < PTCValue(Yr,HMR,MP) )) =
                                         NO$( HMRMP(HMR,MP) and map_PTC_YPH(Yr,PPAR,HMR) and PTCMP(MP));

map_ITC_YPHM(Yr,PPAR,HMR,MP)$(SimYr(Yr) > 2022 and (ITCValue(Yr,HMR,MP) <  PTCValue(Yr,HMR,MP) )) =
                                         YES$( HMRMP(HMR,MP) and map_ITC_YPH(Yr,PPAR,HMR) and ITCMP(MP));
map_ITC_YPHM(Yr,PPAR,HMR,MP)$(SimYr(Yr) > 2022 and (PTCValue(Yr,HMR,MP) <=  ITCValue(Yr,HMR,MP) )  ) =
                                         NO$( HMRMP(HMR,MP) and map_ITC_YPH(Yr,PPAR,HMR) and ITCMP(MP));

map_PTC_YPHM(Yr,'Nat',HMR,MP)$MPFuel(MP,'Storage') = NO;
map_ITC_YPHM(Yr,'Nat',HMR,'New Battery Storage')$(SimYr(Yr) >= 2023) = Yes;


$endif.NatTC

* Set 45Q

CCS45QVal(YrFull,TypeCCS)  = 0;
*CCS45QVal(YrFull,'saline') = 22.66 + (50-22.66)*(SimYrFull(YrFull)-2017)/(2026-2017);
*CCS45QVal(YrFull,'eor')    = 12.83 + (35-12.83)*(SimYrFull(YrFull)-2017)/(2026-2017);

*CCS45QVal(YrFull,'saline')$(SimYrFull(YrFull)>=2026) = 50;
*CCS45QVal(YrFull,'eor')$(SimYrFull(YrFull)>=2026)    = 35;

*display CCS45QVal;
*CCS45QVal(YrFull,TypeCCS)  = CCS45QVal(YrFull,TypeCCS) /sum(Year,Inflation(Year)$(SimYrFull(YrFull) = SimYear(Year)));
display CCS45QVal;

$ifthen.ccs %UI_45Q% == Yes

CCS45QVal(YrFull,'eor')$(SimYrFull(YrFull)>2021)    = 65 * (1/Inflation('2025'));
CCS45QVal(YrFull,'saline')$(SimYrFull(YrFull)>2021) = 85 * (1/Inflation('2025'));

$endif.ccs


*$stop
*display Yr, YrFull, Yrdup, SimYrWgtKnl;
*display map_PS_YPH, map_PS_YPHM;
*,map_PS_Sales_YPH;
*display PSCredit, PSReq.lo, PSReq.up, PSReq.l, PSReqFull, {EmisCapPS, }PSPrc.lo, PSPrc.up;
*display EmisRefPS, EmisRefFullPS;
*display TmpPSPrc, TmpPSReq;
*display map_PS_YPH, map_PS_Sales_YPH;

parameter
REReq(PPAR,Yr)
NonDisp(PPAR,Yr)
AutomaticGen(PPAR,Yr)
CalReq(PPAR,Yr)
Problem(PPAR,Yr)
NonDispMP(PPAR,Yr,MP)

;
REReq(PPAR,Yr) = sum((HMR,Sector),PSReq.l(Yr,PPAR)*Cons0(Yr,HMR,Sector)*map_PS_YPH(Yr,PPAR,HMR));
NonDisp(PPAR,Yr) =sum(HMR,sum((MP,Sea,TB),(NPCap.up(Yr,HMR,MP)*OpNPCapRat(HMR,MP,Sea)*CF(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB))
        $(CF(Yr,HMR,MP,Sea,TB) and MPNoDsp(MP) and MPNoRtrInv(MP) and (not (MPFuel(MP,'Storage') or MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro') or MPFuel(MP,'Geo'))) )) *map_PS_YPH(Yr,PPAR,HMR)) ;
AutomaticGen(PPAR,Yr) = REReq(PPAR,Yr) +  NonDisp(PPAR,YR);
CalReq(PPAR,Yr) = sum(HMR,sum((Fuel,Sea),GenAEOSeaFuel(Yr,HMR,Sea,Fuel)$(not FuelStorage(Fuel)))*map_PS_YPH(Yr,PPAR,HMR));

*check for conflict between total calbirated generation per region and minimum generation + RPS Req
Problem(PPAR,Yr)$(AutomaticGen(PPAR,Yr)>CalReq(PPAR,Yr)) =  AutomaticGen(PPAR,Yr) - CalReq(PPAR,Yr);

NonDispMP(PPAR,Yr,MP) =sum(HMR,sum((Sea,TB),(NPCap.up(Yr,HMR,MP)*OpNPCapRat(HMR,MP,Sea)*CF(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB))
        $(CF(Yr,HMR,MP,Sea,TB) and MPNoDsp(MP) and MPNoRtrInv(MP) and (not (MPFuel(MP,'Storage') or MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro') or MPFuel(MP,'Geo'))) )) *map_PS_YPH(Yr,PPAR,HMR)) ;
