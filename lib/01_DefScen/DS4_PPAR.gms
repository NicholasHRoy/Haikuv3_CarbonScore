* Define regional mappings and partial crediting for emissions policies, OBA eligibility, and PS inclusion.
** --------------------------------------------------------------------------------------------------
*SetPPARMapping uses UI_PPAR and map_tmp_YPH so that it can accomodate both EmisPol and PS.

*Populate map_EmisPol_YPH on UI_PPAR_EP.
$set UI_PPAR %UI_PPAR_EP%
$include SetPPARMapping
map_EmisPol_YPH(Yr,PPAR,HMR)     = map_tmp_YPH(Yr,PPAR,HMR);

*Populate map for RGGI
$set UI_PPAR %UI_RGGI%
$include SetPPARMapping
map_EmisPol_YPH(Yr,PPAR,HMR)$map_tmp_YPH(Yr,PPAR,HMR)     = yes;

*Populate map for reading in reference emissions
$set UI_RptAllPPAR Yes
$include SetPPARMapping
map_RefEmisAnn_YPH(Yr,PPAR,HMR) = map_tmp_YPH(Yr,PPAR,HMR);
map_RefEmisAnn_YP(Yr,PPAR)= sum(HMR,map_RefEmisAnn_YPH(Yr,PPAR,HMR));
$set UI_RptAllPPAR No

*Populate map_PS_YPH based on UI_PPAR_PS.
$set UI_PPAR %UI_PPAR_PS%
$include SetPPARMapping
map_PS_YPH(Yr,PPAR,HMR)          = map_tmp_YPH(Yr,PPAR,HMR);

*Add regions with statutory RPSs to map
$ifthen.rps %UI_RPSReg% == Yes
$set UI_PPAR RPS2
$include SetPPARMapping
map_RPSReg0_YPH(Yr,PPAR,HMR)        = yes$map_tmp_YPH(Yr,PPAR,HMR);
map_PS_YPH(Yr,PPAR,HMR)$map_RPSReg0_YPH(Yr,PPAR,HMR) = yes;
$endif.rps

*Add states with statutory RPSs to map
$ifthen.rps %UI_RPS% == Yes
$set UI_PPAR State
$include SetPPARMapping
map_RPS0_YPH(Yr,PPAR,HMR)        = yes$(map_tmp_YPH(Yr,PPAR,HMR) and RPS0(Yr,HMR));
map_PS_YPH(Yr,PPAR,HMR)$map_RPS0_YPH(Yr,PPAR,HMR) = yes;
$endif.rps

*Add sale regions
map_PS_Sales_YPH(Yr,PPAR,HMR)    = map_PS_YPH(Yr,PPAR,HMR);


*Populate RE target maps
*RE targets
$set UI_PPAR %UI_PPAR_REtgt%
$include SetPPARMapping
map_REtgt_YPH(Yr,PPAR,HMR) = map_tmp_YPH(Yr,PPAR,HMR);

*Populate map_PTC_YPH and map_ITC_YPH based on UI_PPAR_TC
$set UI_PPAR %UI_PPAR_TC%
$include SetPPARMapping
map_PTC_YPH(Yr,PPAR,HMR)         = map_tmp_YPH(Yr,PPAR,HMR);

$set UI_PPAR %UI_PPAR_TC%
$include SetPPARMapping
map_ITC_YPH(Yr,PPAR,HMR)         = map_tmp_YPH(Yr,PPAR,HMR);

*Populate map_CofirePol_YPH based on UI_PPAR_Cofire
$set UI_PPAR %UI_PPAR_Cofire%
$include SetPPARMapping
map_CofirePol_YPH(Yr,PPAR,HMR)   = map_tmp_YPH(Yr,PPAR,HMR);

map_CalGen_YPH(Yr,PPAR,HMR)      = NO;

*populate map for fixed transmission based on UI_PPAR_FxTran
$ifthen %UI_FxTransCons% == Yes
$set UI_PPAR %UI_PPAR_FxTran%
$include SetPPARMapping
map_FxTrans_YPH(Yr,PPAR,HMR) = map_tmp_YPH(Yr,PPAR,HMR);
$else
map_FxTrans_YPH(Yr,PPAR,HMR) = NO;
TransFx(Yr,HMRe,HMRi,Sea,TB) = 0;
$endif

*Populate results reporting map with all PPARs
$set UI_RptAllPPAR Yes
$include SetPPARMapping
map_all_YPH(Yr,PPAR,HMR) = map_tmp_YPH(Yr,PPAR,HMR);
$set UI_RptAllPPAR No

* Define RGGI coverage for model plants. This is our best representation of all fossil > 25 MW.
** --------------------------------------------------------------------------------------------------

EmisPolMP(MP)=YES$( ( MPFuel(MP,'Coal') or MPFuel(MP,'NG') or MPFuel(MP,'Oil') )
                       and ( MPTech(MP,'Steam') or MPTech(MP,'CC') or MPTech(MP,'CT')
                       or MPTech(MP,'CHP') ) );
*EmisPolMP(MP)=YES$(MPFuel(MP,'solar') and MPNew(MP));
*HMRMP is just for sparsity. I think it need not be here. Maybe if it's not here then it must be in the equation?
map_EmisPol_YPHM(Yr,PPAR,HMR,MP) = YES$( HMRMP(HMR,MP) and map_EmisPol_YPH(Yr,PPAR,HMR) and EmisPolMP(MP) );

* Define PS Eligibility under different RPS and CES policies
** --------------------------------------------------------------------------------------------------
$ifthen.pselig %UI_PSElig% == NonEmit
        PSMP(MP) = YES$(MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro')
                   or MPFuel(MP,'Nuke') or MPFuel(MP,'Geo'));

$elseif.pselig %UI_PSElig% == RPS_RGGIPrj
        PSMP(MP) = YES$(MPFuel(MP,'Solar')$MPNew(MP) or MPFuel(MP,'Wind')$MPNew(MP));

$elseif.pselig %UI_PSElig% == CES_RGGIPrj
        PSMP(MP) = YES$(
                         (( MPFuel(MP,'Coal') or MPFuel(MP,'NG') or MPFuel(MP,'Oil') )
                            and ( MPTech(MP,'Steam') or MPTech(MP,'CC') or MPTech(MP,'CT') ))
                            or ( MPFuel(MP,'Nuke') )
                            or ( MPFuel(MP,'Solar')$MPNew(MP) or MPFuel(MP,'Wind')$MPNew(MP) )
                         );

$elseif.pselig %UI_PSElig% == CES_Smith
        PSMP(MP) = YES$(MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro') or MPFuel(MP,'Nuke')
                   or MPFuel(MP,'Geo') or MPFuel(MP,'Bio') or MPFuel(MP,'NG'));

$elseif.pselig %UI_PSElig% == CES_Nat
        PSMP(MP) = YES$(MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro') or MPFuel(MP,'Nuke')
                         or MPFuel(MP,'Geo') or MPFuel(MP,'Bio') or MPFuel(MP,'NG'));

$elseif.pselig %UI_PSElig% == CES_Nat_noCHP
        PSMP(MP) = YES$((MPFuel(MP,'Solar') or MPFuel(MP,'Wind') or MPFuel(MP,'Hydro') or MPFuel(MP,'Nuke')
                         or MPFuel(MP,'Geo') or MPFuel(MP,'Bio') or (MPFuel(MP,'NG') and not MPTech(MP,'CHP'))));

$else.pselig
        PSMP(MP) = NO;

$endif.pselig

map_PS_YPHM(Yr,PPAR,HMR,MP) = YES$( HMRMP(HMR,MP) and map_PS_YPH(Yr,PPAR,HMR) and PSMP(MP)); !! Updated in PolOpts_PS for MPs with PSCredit > 0

Parameters
    PS_RefER(YrFull,PPAR)
;
PS_RefER(YrFull,PPAR) = 9999;
PSCredit(YrFull,PPAR,HMR,MP) = 0;

$ifthen.ps_pol1 %UI_PSPol% == CES_Smith
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2030) = .64;
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2030 and SimYrFull(YrFull)<2035) = .54;
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2035 and SimYrFull(YrFull)<2040) = .44;
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2040)                            = .34;
        PS_RefER(YrFull,'%UI_PPAR_PS%')                                                      = PS_RefER(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2021 and SimYr(Yr)<2040)              = max((1 - (ERo(Yr,HMR,MP,'CO2') / PS_RefER(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);

$elseif.ps_pol1 %UI_PSPol% == CES_Smith_EmisTgt
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2021 and SimYrFull(YrFull)<2030)= .64;
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2030 and SimYrFull(YrFull)<2035)= .54;
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2035 and SimYrFull(YrFull)<2040)= .44;
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2040)                           = .34;
        PS_RefER(YrFull,'%UI_PPAR_PS%')                                                     = PS_RefER(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2021 and SimYr(Yr)<2040)             = max((1 - (ERo(Yr,HMR,MP,'CO2') / PS_RefER(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);
$elseif.ps_pol1 %UI_PSPol% == CES_RGGIPrj
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2026)= .5;
        PS_RefER(YrFull,'%UI_PPAR_PS%')                                                     = PS_RefER(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2026)                                = max((1 - (ERo(Yr,HMR,MP,'CO2') / PS_RefER(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);
        map_PS_YPHM(Yr,PPAR,HMR,MP)                                                         = YES$( HMRMP(HMR,MP) and map_PS_YPH(Yr,PPAR,HMR) and PSMP(MP) and (PSCredit(Yr,PPAR,HMR,MP)>0));
$elseif.ps_pol1 %UI_PSPol% == CES_CO
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2022)                           = .2;
        PS_RefER(YrFull,'%UI_PPAR_PS%')                                                     = PS_RefER(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2022)                                = max((1 - (ERo(Yr,HMR,MP,'CO2') / PS_RefER(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);
$elseif.ps_pol1 %UI_PSPol% == CES_Nat
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2022)                           = .2;
        PS_RefER(YrFull,'%UI_PPAR_PS%')                                                     = PS_RefER(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2022)                                = max((1 - (ERo(Yr,HMR,MP,'CO2') / PS_RefER(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);

$elseif.ps_pol1 %UI_PSPol% == CES_Bank
*        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2022 and SimYrFull(YrFull)<= 2030) = smax(HMR,ERo('Yr7',HMR,'New CT NG','CO2'));              !!
*        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2031 and SimYrFull(YrFull)<= 2035) = smax(HMR,ERo('Yr15',HMR,'New CT NG','CO2'));              !!
*        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2036)                              = smax(HMR,ERo('Yr19',HMR,'New CT NG','CO2'));              !!
*        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2022) = max((1 - (ERo(Yr,HMR,MP,'CO2') / PS_RefER(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2022)                                = 0;
        PS_RefER(YrFull,'%UI_PPAR_PS%')                                                          = PS_RefER(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2022)                                     = 1$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP);

$elseif.ps_pol1 %UI_PSPol% == CES_Nat2022
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2023)       = .44;
        PS_RefER(YrFull,'%UI_PPAR_PS%')                                 = PS_RefER(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)<=2022)            = 0;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2023)            = max((1 - (ERo(Yr,HMR,MP,'CO2') / PS_RefER(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);

$elseif.ps_pol1 %UI_PSPol% == CES_Nat2023
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2023)       = .44;
        PS_RefER(YrFull,'%UI_PPAR_PS%')                                 = PS_RefER(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)<=2022)            = 0;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2023)            = max((1 - (ERo(Yr,HMR,MP,'CO2') / PS_RefER(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);

$elseif.ps_pol1 %UI_PSPol% == CES_Nat2023-banking

        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2023)       = .44;
        PS_RefER(YrFull,'%UI_PPAR_PS%')                                 = PS_RefER(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)<=2022)            = 0;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2023)            = max((1 - (ERo(Yr,HMR,MP,'CO2') / PS_RefER(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);

$elseif.ps_pol1 %UI_PSPol% == CES80x30
        PS_RefER(YrFull,PPAR)$(sum((Yr,HMR),map_PS_YPH(Yr,PPAR,HMR)) and SimYrFull(YrFull)>=2023)       = 0;
        PS_RefER(YrFull,PPAR)$sum((Yr,HMR),map_PS_YPH(Yr,PPAR,HMR))                                     = PS_RefER(YrFull,PPAR) * %UI_PS_ERMult%;
        PSCredit(Yr,PPAR,HMR,MP)$(map_PS_YPH(Yr,PPAR,HMR) and SimYr(Yr)<=2022)                          = 0;
        PSCredit(Yr,PPAR,HMR,MP)$(map_PS_YPH(Yr,PPAR,HMR) and SimYr(Yr)>=2023)                          = 1$map_PS_YPHM(Yr,PPAR,HMR,MP);

$elseif.ps_pol1 %UI_PSPol% == CES80x30p
        PS_RefER(YrFull,'%UI_PPAR_PS%')$(SimYrFull(YrFull)>=2023)       = .44;
        PS_RefER(YrFull,'%UI_PPAR_PS%')                                 = PS_RefER(YrFull,'%UI_PPAR_PS%') * %UI_PS_ERMult%;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)<=2022)            = 0;
        PSCredit(Yr,'%UI_PPAR_PS%',HMR,MP)$(SimYr(Yr)>=2023)            = max((1 - (ERo(Yr,HMR,MP,'CO2') / PS_RefER(Yr,'%UI_PPAR_PS%')))$map_PS_YPHM(Yr,'%UI_PPAR_PS%',HMR,MP),0);

$elseif.ps_pol1 %UI_PSPol% == CESreg80x30
        PS_RefER(YrFull,PPAR)$(sum((Yr,HMR),map_PS_YPH(Yr,PPAR,HMR)) and SimYrFull(YrFull)>=2023)       = 0;
        PS_RefER(YrFull,PPAR)$sum((Yr,HMR),map_PS_YPH(Yr,PPAR,HMR))                                     = PS_RefER(YrFull,PPAR) * %UI_PS_ERMult%;
        PSCredit(Yr,PPAR,HMR,MP)$(map_PS_YPH(Yr,PPAR,HMR) and SimYr(Yr)<=2022)                          = 0;
        PSCredit(Yr,PPAR,HMR,MP)$(map_PS_YPH(Yr,PPAR,HMR) and SimYr(Yr)>=2023)                          = 1$map_PS_YPHM(Yr,PPAR,HMR,MP);

$else.ps_pol1
        PSCredit(Yr,PPAR,HMR,MP) = 1;

$endif.ps_pol1

$ontext
display
PSCredit
;
$offtext
*$stop

map_PS_YPHM(Yr,PPAR,HMR,MP) = YES$( HMRMP(HMR,MP) and map_PS_YPH(Yr,PPAR,HMR) and PSMP(MP) and (PSCredit(Yr,PPAR,HMR,MP)>0));

** --------------------------------------------------------------------------------------------------
* Define eligibility for PTC and ITS
** --------------------------------------------------------------------------------------------------

Parameters
    PTC_RefER(YrFull,PPAR)
    map_PTCRefER(YrFull,PPAR,HMR,MP)
    ITC_RefER(YrFull,PPAR)
;

PTC_RefER(YrFull,PPAR) = 9999;
ITC_RefER(YrFull,PPAR) = 9999;
PTCredit(YrFull,PPAR,HMR,MP) = 0;
ITCredit(YrFull,PPAR,HMR,MP) = 0;

$ifthen.ptc_elig %UI_TCElig% == Nat2020
         PTCMP(MP)$(MPFuel(MP,'Wind')and MPNew(MP))  = Yes;
         ITCMP(MP)$(MPFuel(MP,'Solar')and MPNew(MP)) = Yes;

*=========================================================== IRA Tax Credits ===========================================
$elseif.ptc_elig %UI_TCElig% == IRA
         PTCMP(MP)$(MPNew(MP)and(MPFuel(MP,'Solar')or MPFuel(MP,'Wind')
                    or MPFuel(MP,'Hydro') or MPFuel(MP,'Nuke')
                    or MPFuel(MP,'Geo') or MPFuel(MP,'Bio')))                = Yes;
         PTCMP('New Offshore Wind')                                          = No;
         ITCMP(MP)$(MPNew(MP)and(MPFuel(MP,'Solar')or MPFuel(MP,'Wind')
                    or MPFuel(MP,'Storage')))                                = Yes;

$else.ptc_elig
         PTCMP(MP) = No;
         ITCMP(MP) = No;
$endif.ptc_elig

map_PTC_YPHM(Yr,PPAR,HMR,MP) = YES$( HMRMP(HMR,MP) and map_PTC_YPH(Yr,PPAR,HMR) and PTCMP(MP)); !! Updated in PolOpts_PS for MPs with PTCredit > 0
map_ITC_YPHM(Yr,PPAR,HMR,MP) = YES$( HMRMP(HMR,MP) and map_ITC_YPH(Yr,PPAR,HMR) and ITCMP(MP)); !! Updated in DS9_PolOpts_PS for MPs with ITCredit > 0


$ifthen.ptc_pol %UI_TCPol% == Nat2020

*        2020 Tax Credits for Wind
         PTCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_PTC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP) and (SimYr(Yr) = 2019) )                     = 4/10;
         PTCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_PTC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP)
                                                 and (SimYr(Yr) >= 2020 and SimYr(Yr) <= 2021))                                  = 6/10;
         PTCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_PTC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP) and (SimYr(Yr) >= 2022))                     = 0;

*        2020 Tax Credits for Solar
         ITCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_ITC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP) and (SimYr(Yr) = 2019) )                     = 1;
         ITCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_ITC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP)
                                                 and (SimYr(Yr) >= 2020 and SimYr(Yr) <= 2022) )                                 = 26/30;
         ITCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_ITC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP) and (SimYr(Yr) = 2023) )                     = 22/30;
         ITCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_ITC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP) and (SimYr(Yr) >= 2024))                     = 10/30;

*=========================================================== IRA Tax Credits ======================================================================================

$elseif.ptc_pol %UI_TCPol% == IRA

*Modify ITC and PTC maps for tax credit technology change

*Onshore Wind Only PTC before 2022
map_PTC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP)$(SimYr(Yr) <= 2022 and not MPTech(MP,'Onshore'))                                          = NO;
*Solar Only ITC before 2022
map_ITC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP)$(SimYr(Yr) <= 2022 and not (MPFuel(MP,'Solar')))                                          = NO;
*New Battery Storage and Offshore Wind only for the ITC after 2022
map_ITC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP)$(SimYr(Yr) >= 2022 and (MPFuel(MP,'Solar') or MPTech(MP,'Onshore')))                      = NO;


*        2020 Tax Credits for Wind
         PTCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_PTC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP) and (SimYr(Yr) = 2019))                      = 4/10;
         PTCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_PTC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP)
                                                 and ((SimYr(Yr) >= 2020) and (SimYr(Yr) <= 2021)))                              = 6/10;
         PTCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_PTC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP) and (SimYr(Yr) >= 2022))                     = 0;

*        2020 Tax Credits for Solar
         ITCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_ITC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP) and (SimYr(Yr) = 2019))                      = 1;
         ITCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_ITC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP)
                                                 and ((SimYr(Yr) >= 2020) and (SimYr(Yr) <= 2021)))                              = 26/30;

*        IRA (Solar/Wind PTC and Battery Storage ITC) (no phaseout)
         PTCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_PTC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP) and (SimYr(Yr) >= 2023))                     = 1;
         ITCredit(Yr,'%UI_PPAR_TC%',HMR,MP)$(map_ITC_YPHM(Yr,'%UI_PPAR_TC%',HMR,MP) and (SimYr(Yr) >= 2022))                     = 1;


$else.ptc_pol

         PTCredit(Yr,'%UI_PPAR_TC%',HMR,MP)=1;
         ITCredit(Yr,'%UI_PPAR_TC%',HMR,MP)=1;

$endif.ptc_pol

*Define coverage for model plants for Cofiring caps, for now we assume same as RGGI with fossil > 25MW
** --------------------------------------------------------------------------------------------------
CofirePolMP(MP)=YES$(
        ( MPFuel(MP,'Coal') or MPFuel(MP,'NG') or MPFuel(MP,'Oil') )
        and ( MPTech(MP,'Steam') or MPTech(MP,'CC') or MPTech(MP,'CT') or MPTech(MP,'CHP') ) );

map_CofirePol_YPHM(Yr,PPAR,HMR,MP)=YES$( HMRMP(HMR,MP) and map_CofirePol_YPH(Yr,PPAR,HMR) and CofirePolMP(MP) );


* Define eligibility for RE targets
** --------------------------------------------------------------------------------------------------

$ifthen.REtgt_elig %UI_PPAR_REtgt% == VA
       REtgtMP(MP) = YES$(MPNew(MP) and (MPTech(MP,'Solar') or MPTech(MP,'Onshore')));
$else.REtgt_elig
       REtgtMP(MP) = NO;
$endif.REtgt_elig

* Fill maps for RE Targets
** --------------------------------------------------------------------------------------------------

$ifthen.REtgt_map %UI_PPAR_REtgt% == VA
map_REtgt_YPHM(Yr,PPAR,HMR,MP) = YES$(REtgtMP(MP) and map_REtgt_YPH(Yr,PPAR,HMR));
$else.REtgt_map
map_REtgt_YPHM(Yr,PPAR,HMR,MP) = NO;
$endif.REtgt_map