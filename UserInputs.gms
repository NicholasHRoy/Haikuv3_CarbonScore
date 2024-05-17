**-------------------------------------------------------------------------------------------------------------
* SET INITIAL USER INPUT
**-------------------------------------------------------------------------------------------------------------

*-----------------------------Haiku Model Defaults------------------------------

$if not set UI_Cal        $setglobal UI_Cal        No !! [Yes,No] run in calibration mode? default is No, changed to Yes for UI_ScenKnl==Cal.
$if not set UI_devCal     $setglobal UI_devCal     No !! [Yes,No] deviate from calibration? (irrelevant for calibration)
$if not set UI_fxPrcHMR   $setglobal UI_fxPrcHMR   !! {AL,AR,AZ,CA,CO,FL,GA,IA,ID,IL,IN,KS,KY,LA,MI,MN,MO,MS,MT,}NC!!,ND,NE,NM,NV,OK,OR,SC,SD,TN,UT,VA,WA,WI,WV,WY
$if not set UI_PS_ReqMult $setglobal UI_PS_ReqMult 1
$if not set UI_SetPol     $setglobal UI_SetPol     Yes !! [Yes,No] Run EmisPol_Opts? This pertains only for calls to DictMap and SclItrp.
$if not set UI_Yrs        $setglobal UI_Yrs        31CSP !! number and version of years in initial variable values
$if not set UI_InitCal    $setglobal UI_InitCal    NA !! scenario providing calibrator values
$if not set UI_SU         $setglobal UI_SU         Yes !! [Yes,No] calcuate scale diagnostics?
$if not set UI_PrtbInit   $setglobal UI_PrtbInit   No !! [Yes,No] perturb initial values?
$if not set UI_TB         $setglobal UI_TB         NA !! [0,1,2,3,4,NA] for EV demand TBs
$if not set UI_VMT        $setglobal UI_VMT        NA !![high, low, NA]
$if not set UI_TCIonly    $setglobal UI_TCIonly    No !![Yes, No]
$if not set UI_FxNuke     $setglobal UI_FxNuke     No !! [Yes, No]
$if not set UI_FxTDLoss   $setglobal UI_FxTDLoss   No !! [No, Yes]

*---------------------------Default National Policies---------------------------
*Tax Credits
$if not set UI_PPAR_TC    $setglobal UI_PPAR_TC    Nat          !! PPAR configuration for Tax Credit
$if not set UI_TCPol      $setglobal UI_TCPol      Nat2020      !! Default Production Tax Credit Policy
$if not set UI_TCElig     $setglobal UI_TCElig     Nat2020      !! Default Production Tax Credit Policy Eligibility
$if not set UI_TCDP       $setglobal UI_TCDP       No           !! Default Direct Pay is Off for BBB
$if not set UI_TCOption   $setglobal UI_TCOption   No           !! Default Tax Credits are not optionality

*Federal Emissions Tax or Trading
$if not set UI_CTax       $setglobal UI_CTax       0  !! [0, 1, 10,...] National Carbon Tax
$if not set UI_CCap       $setglobal UI_CCap       No !![Yes, No] National Carbon Cap

*Carbon Scoring
$if not set UI_CSP        $setglobal UI_CSP        No

*-------------------------Default Subnational Policies--------------------------
*California (as a tax)
$if not set UI_CACap      $setglobal UI_CACap      Yes !![Yes,No]
$if not set UI_CAfloor    $setglobal UI_CAfloor    No !![Yes,No]
$if not set UI_CALDV      $setglobal UI_CALDV      No !![Yes,No]
$if not set UI_CAScen     $setglobal UI_CAScen     NA
$if not set UI_Diablo     $setglobal UI_Diablo     NA


*11 State RGGI region
$if not set UI_RGGI       $setglobal UI_RGGI       RGGI11 !! [RGGI11, RGGI12, RGGI13]
$if not set UI_RGGIfloor  $setglobal UI_RGGIfloor  No!! [Yes,No]

*other emissions program
$if not set UI_PPAR_EP    $setglobal UI_PPAR_EP    NA !! [NA, Nat, RGGI9, RGGI11, RGGI19, state (or pair), RGGIstate, RGGI_state] PPAR configuration for emissions pricing

*other RPS program
$if not set UI_PPAR_PS    $setglobal UI_PPAR_PS    NA !! [Nat, RGGI9, RGGI11, RGGI19, state (or pair), RGGIstate, RGGI_state, RPS, NENYPJM] PPAR configuration for portfolio standards

*Subnational and Voluntary RPS's
$if not set UI_RPS        $setglobal UI_RPS        No !![Yes, No]
$if not set UI_NatRPS     $setglobal UI_NatRPS     No !![Yes, No]
$if not set UI_PS_ERMult  $setglobal UI_PS_ERMult  1  !! For CES multiplier?

$if not set UI_FxGen      $setglobal UI_FxGen      0    !![0 (off), 2019, 2020, 2021, ...]
$if not set UI_FxCap      $setglobal UI_FxCap      0    !![0 (off), 2019, 2020, 2021, ...]
$if not set UI_FxNukeGen  $setglobal UI_FxNukeGen  3000 !![0 (off), 2019, 2020, 2021, ...]
$if not set UI_GrowCap    $setglobal UI_GrowCap    3000 !![0 (off), 2019, 2020, 2021, ...]
$if not set UI_growth     $setglobal UI_growth     Old
$if not set UI_Demand     $setglobal UI_Demand     No !![No, High, Low, NREL, AEO2023]
$if not set UI_CapCostRE  $setglobal UI_CapCostRE  No !![No, High, Low]


*The calibration diagnostics control variables matter only for the output from SolveLP.
$setglobal UI_CalDiagHMR   ME!!,AL,AR,AZ,CA,CO,FL,GA,IA,ID,IL,IN,KS,KY,LA,MI,MN,MO,MS,MT,NC,ND,NE,NM,NV,OK,OR,SC,SD,TN,UT,VA,WA,WI,WV,WY,TX,ME,VT,NH,MA,RI,CT,NY,NJ,DE,DC,MD,PA,OH
$setglobal UI_CalDiagFuel  Coal{,NG,Oil,Nuke,Hydro,Wind,Solar,Bio,Geo,Oth}
$setglobal UI_CalDiagYr    Yr0!!,Yr11

*------------------------------Project Specific UI------------------------------

**Federal Climate Policy
*Build Back Better
$if not set UI_NGPrc      $setglobal UI_NGPrc      No !![Yes, No, High, Low, Shock]
$if not set UI_PPAR_EE    $setglobal UI_PPAR_EE    No !![No, Nat, VA,...]

*Cofiring Standard
$if not set UI_Cofire         $setglobal UI_Cofire         No !! For CES multiplier?
$if not set UI_PPAR_Cofire    $setglobal UI_PPAR_Cofire    No !! [No, Nat, RGGI9, etc]
$if not set UI_CofireRate     $setglobal UI_CofireRate     No !! [No,Yes]
$if not set UI_CofireRateAnn  $setglobal UI_CofireRateAnn  No !! [No, Yes]
$if not set UI_CofireReq      $setglobal UI_CofireReq      0  !! [0,20, 40, 60]
$if not set UI_LookBack       $setglobal UI_LookBack       0  !! [0,1,2]
$if not set UI_RefEmisAnn     $setglobal UI_RefEmisAnn     No !! [Yes, No]

**State Inputs:
*Colorado
$if not set UI_COTax      $setglobal UI_COTax      0  !![0, 1, 10,...] Colorado Specific carbon tax
$if not set UI_COCoal     $setglobal UI_COCoal     0  !![0, 2020, 2021...]
$if not set UI_PSCoCap    $setglobal UI_CoCap      No !![No,Yes]
$if not set UI_COEV       $setglobal UI_COEV       No !![No,Yes]
$if not set UI_FxCOImp    $setglobal UI_FxCOImp    No !![No,Yes]

*Virginia
$if not set UI_VARPS      $setglobal UI_VARPS      No
$if not set UI_CapTgt     $setglobal UI_CapTgt     No
$if not set UI_VACoal     $setglobal UI_VACoal     No !![Yes, No]

*PA
$if not set UI_PACoalRtr  $setglobal UI_PACoalRtr  No

*set type of Nuclear calibration and type of capacity growth constraint
$setglobal UI_NukeCal     Yes  !! [Yes,No]
$setglobal UI_growth      Old !! [New,Old]
$if not set  UI_GrowCapPct   $setglobal UI_GrowCapPct  0.07 !! [0.07, 0.10]
*----------------------------------------------Scenario Specific Inputs----------------------------------------------
$setglobal UI_SlvLoad     Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal     %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v5


$setglobal UI_RGGIfloor   Yes
$setglobal UI_CAfloor     Yes
$setglobal UI_RPSReg      Yes !![No, Yes]
$setglobal UI_CapTgt      Yes !![AEO, Yes]
*$setglobal UI_VACoal      Yes !![Yes, No]

$setglobal UI_FxTDLoss    Yes

*CA RPS
$setglobal UI_PSPol       CACES
$setglobal UI_PSElig      NonEmit
$setglobal UI_PPAR_PS     CA

*Fix Recent Historical Year Generation and Capacity to calibrator values
$setglobal UI_vRS1         %UI_vHaiku%
$setglobal UI_RefScen1     %UI_Yrs%_BL_%UI_vInputs%_v5_CSP_DemnoIRA_NGnoIRA

$setglobal UI_vRS2         %UI_vRS1%
$setglobal UI_RefScen2     %UI_RefScen1%

$setglobal UI_FxGen        2022 !![0 (no), 2019, 2020, 2021, ... ]
$setglobal UI_FxCap        2023 !![0 (no), 2019, 2020, 2021, ... ]

*Limit Capacity Growth
$setglobal UI_GrowCap      2024 !! [3000 (no), 2019, 2020, 2021, ... ]
*$setglobal UI_GrowCapPct  0.07 !! [0.07, 0.10]
*$setglobal UI_EffCap      No   !! [Yes, No to effective capacity]

*Tax Credits
$setglobal UI_TCPol       IRA
$setglobal UI_TCElig      IRA
$setglobal UI_PPAR_TC     Nat
$setglobal UI_45Q         Yes

*Nuclear stays online
$setglobal UI_FxNukeGen   2023 !![3000 (no), 2019, 2020, 2021, ... ]

*Sensitivies
$setglobal UI_NGPrc       BL2022    !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023]
$setglobal UI_CapCostRE   No        !! [No, High, Low]O
$setglobal UI_Demand      ref2023   !! [No, High, Low, NREL, AEO2023, CSP2023, ref2023, lowogs, highogs]
$setglobal UI_CSP         CSP       !! [CSP, AEO]
$setglobal UI_EPRIScen    Central   !! [Central, Low, High]

*Fossil Fuel Levers
$setglobal UI_Cofire           Yes !! [Yes, 20, 60, 100, 2060]
$setglobal UI_CCSRetrofit      Yes
$setglobal UI_LimCCSStorage    Yes  !! [No (default), Yes]
$setglobal UI_CCSEmisRate      Mid !! [Mid (default), High, Low]
$setglobal UI_GoodNeighbor    No

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%_CCS%UI_LimCCSStorage%


