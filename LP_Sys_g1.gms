$Title MCP System
$OffUpper
$OnSymList
$eolcom !!
$inlinecom { }

$include CopyLib
$include Init

**-------------------------------------------------------------------------------------------------------------
* SET INITIAL USER INPUT
**-------------------------------------------------------------------------------------------------------------
$onecho > UserInputs.gms

*------------------------------Scenario Selection-------------------------------

*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    LPCal
*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    LPBLCal
*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    BLAEO
*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    BLNREL
*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    BL
*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    BLCSAPR
*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    BLIRA
$if not set UI_ScenKnl    $setglobal UI_ScenKnl    CSP
*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    BLCARB
*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    CARB
*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    RGGI
*$if not set UI_ScenKnl    $setglobal UI_ScenKnl    TaxCredits

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

$offecho
$include UserInputs


**------------------------------------------------------------------------------------------------------------
* SCENARIOS
**-------------------------------------------------------------------------------------------------------------
$ifthen.SimType %UI_ScenKnl% == LPCal
$onechoV >> UserInputs.gms
$setglobal UI_Cal       Yes !! [Yes,No] Solve LP for NPCap trajectory and duals?
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?
$set       UI_CalYrs    %UI_Yrs% !! %UI_Yrs% (note that the code may not be robust to an LPCal with UI_Yrs <> UI_CalYrs ap191115)

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v4  !! name the scenario


$setglobal UI_RGGIfloor   Yes
$setglobal UI_CAfloor     Yes
$setglobal UI_RPSReg      No  !![No, Yes]
$setglobal UI_CapTgt      AEO !![AEO, Yes]

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP     --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-------------------------------------------------------------------------------------------------------------

$elseif.SimType %UI_ScenKnl% == LPBLCal

$onechoV >> UserInputs.gms
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal   %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v4
$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v4

$setglobal UI_RGGIfloor   Yes
$setglobal UI_CAfloor     Yes
$setglobal UI_RPSReg      No  !![No, Yes]
$setglobal UI_CapTgt      AEO !![AEO, Yes]

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP     --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-------------------------------------------------------------------------------------------------------------
$elseif.SimType %UI_ScenKnl% == BLAEO


$onechoV >> UserInputs.gms
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal   %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v4
$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v4

$setglobal UI_RGGIfloor   Yes
$setglobal UI_CAfloor     Yes
$setglobal UI_RPSReg      Yes !![No, Yes]
$setglobal UI_CapTgt      AEO !![AEO, Yes]

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP     --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-----------------------------------------------------------------------------------------------------
$elseif.SimType %UI_ScenKnl% == BLNREL

$onechoV >> UserInputs.gms
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal   %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v4
$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v4

$setglobal UI_RGGIfloor   Yes
$setglobal UI_CAfloor     Yes
$setglobal UI_RPSReg      Yes !![No, Yes]
$setglobal UI_CapTgt      Yes !![AEO, Yes]
*$setglobal UI_VACoal      Yes !![Yes, No]

*CA RPS
$setglobal UI_PSPol       CACES
$setglobal UI_PSElig      NonEmit
$setglobal UI_PPAR_PS     CA

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-----------------------------------------------------------------------------------------------------
$elseif.SimType %UI_ScenKnl% == BL

$onechoV >> UserInputs.gms
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal   %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v5
$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5

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
$setglobal UI_vRS1        %UI_vHaiku%
$setglobal UI_RefScen1    %UI_Yrs%_BLNREL_%UI_vInputs%_v5
$setglobal UI_vRS2        %UI_vRS1%
$setglobal UI_RefScen2    %UI_RefScen1%

$setglobal UI_FxGen       2022 !![0 (no), 2019, 2020, 2021, ... ]
$setglobal UI_FxCap       2023 !![0 (no), 2019, 2020, 2021, ... ]

*Limit Capacity Growth
$setglobal UI_GrowCap     2024 !! [3000 (no), 2019, 2020, 2021, ... ]
$setglobal UI_GrowCapPct  0.07 !! [0.07, 0.10]
$setglobal UI_EffCap      Yes   !! [Yes, No to effective capacity]

*Fossil Fuel Levers
$setglobal UI_Cofire          Yes !! [Yes, 20, 60, 100, 2060]
$setglobal UI_CCSRetrofit     Yes
$setglobal UI_LimCCSStorage   Yes  !! [No (default), Yes]
$setglobal UI_CCSEmisRate     Mid !! [Mid (default), High, Low]
*$setglobal UI_GoodNeighbor    Yes

*Sensitivies
$setglobal UI_CSP         CSP       !! [CSP, AEO]
$setglobal UI_Demand      noIRA     !! [No, High, Low, NREL, ref2023, lowogs, highogs, noIRA]
$setglobal UI_NGPrc       High2023  !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023, noIRA]
$setglobal UI_CapCostRE   No        !! [No, High, Low]

$setglobal UI_Scen        %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-----------------------------------------------------------------------------------------------------
$elseif.SimType %UI_ScenKnl% == BLCSAPR

$onechoV >> UserInputs.gms
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal   %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v4
$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v4

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

*Sensitivies
$setglobal UI_CSP         AEO       !![CSP, AEO]
$setglobal UI_Demand      noIRA     !![No, High, Low, NREL, ref2023, lowogs, highogs, noIRA]
$setglobal UI_NGPrc       noIRA    !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023, noIRA]
$setglobal UI_CapCostRE   No        !! [No, High, Low]
$setglobal UI_EPRIScen    Central   !! [Central, Low, High]

*Fix Recent Historical Year Generation and Capacity to calibrator values
$setglobal UI_vRS1        %UI_vHaiku%
$setglobal UI_RefScen1    %UI_Yrs%_BL_%UI_vInputs%_v4_%UI_CSP%_DemnoIRA_BL2023
$setglobal UI_vRS2        %UI_vRS1%
$setglobal UI_RefScen2    %UI_RefScen1%

$setglobal UI_FxGen       2023 !![0 (no), 2019, 2020, 2021, ... ]
$setglobal UI_FxCap       2023 !![0 (no), 2019, 2020, 2021, ... ]

*Limit Capacity Growth
$setglobal UI_GrowCap     2024 !! [3000 (no), 2019, 2020, 2021, ... ]
$setglobal UI_GrowCapPct  0.07 !! [0.07, 0.10]
$setglobal UI_EffCap      Yes   !! [Yes, No to effective capacity]

*Fossil Fuel Levers
$setglobal UI_Cofire          Yes !! [Yes, 20, 60, 100, 2060]
$setglobal UI_CCSRetrofit     Yes
$setglobal UI_LimCCSStorage   Yes  !! [No (default), Yes]
$setglobal UI_CCSEmisRate     Mid !! [Mid (default), High, Low]
*$setglobal UI_GoodNeighbor    Yes

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v4_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results


**-----------------------------------------------------------------------------------------------------
$elseif.SimType %UI_ScenKnl% == BLIRA

$onechoV >> UserInputs.gms
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal   %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v4
$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v4

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
$setglobal UI_vRS1        %UI_vHaiku%
$setglobal UI_RefScen1    %UI_Yrs%_BL_%UI_vInputs%_v4_CSP_DemnoIRA_NGnoIRA

$setglobal UI_vRS2        %UI_vRS1%
$setglobal UI_RefScen2    %UI_RefScen1%

$setglobal UI_FxGen       2022 !![0 (no), 2019, 2020, 2021, ... ]
$setglobal UI_FxCap       2023 !![0 (no), 2019, 2020, 2021, ... ]

*Limit Capacity Growth
$setglobal UI_GrowCap     2024 !! [3000 (no), 2019, 2020, 2021, ... ]
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
$setglobal UI_NGPrc       BL2023    !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023]
$setglobal UI_CapCostRE   No        !! [No, High, Low]
$setglobal UI_EPRIScen    Central   !! [Central, Low, High]
$setglobal UI_Demand      ref2023   !! [No, High, Low, NREL, AEO2023, CSP2023, ref2023, lowogs, highogs]
$setglobal UI_CSP         CSP       !! [CSP, AEO]

*Fossil Fuel Levers
$setglobal UI_Cofire           Yes !! [Yes, 20, 60, 100, 2060]
$setglobal UI_CCSRetrofit      Yes
$setglobal UI_LimCCSStorage    Yes  !! [No (default), Yes]
$setglobal UI_CCSEmisRate      Mid !! [Mid (default), High, Low]

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v4_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%_%UI_EPRIScen%


$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-----------------------------------------------------------------------------------------------------
$elseif.SimType %UI_ScenKnl% == CSP

$onechoV >> UserInputs.gms
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal   %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v5
$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5

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

*Sensitivies
$setglobal UI_NGPrc       Low2023 !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023]
$setglobal UI_CapCostRE   No      !! [No, High, Low]
$setglobal UI_EPRIScen    Central !! [Central, Low, High]
$setglobal UI_Demand      highogs    !![No, High, Low, NREL, AEO2023, CSP2023, ref2023, lowogs, highogs]
$setglobal UI_CSP         CSP       !![CSP, AEO]

*Fix Recent Historical Year Generation and Capacity to calibrator values
$setglobal UI_vRS1        %UI_vHaiku%
$setglobal UI_RefScen1    %UI_Yrs%_BL_%UI_vInputs%_v5_%UI_CSP%_DemnoIRA_NGLow2023

$setglobal UI_vRS2        %UI_vRS1%
$setglobal UI_RefScen2    %UI_RefScen1%

$setglobal UI_FxGen       2022 !![0 (no), 2019, 2020, 2021, ... ]
$setglobal UI_FxCap       2023 !![0 (no), 2019, 2020, 2021, ... ]

*Limit Capacity Growth
$setglobal UI_GrowCap      2024 !! [3000 (no), 2019, 2020, 2021, ... ]
$setglobal UI_GrowCapPct  0.07 !! [0.07, 0.10]
$setglobal UI_EffCap      No   !! [Yes, No to effective capacity]

*Tax Credits
$setglobal UI_TCPol       IRA
$setglobal UI_TCElig      IRA
$setglobal UI_PPAR_TC     Nat
$setglobal UI_45Q         Yes

*Nuclear stays online
$setglobal UI_FxNukeGen   2023 !![3000 (no), 2019, 2020, 2021, ... ]

*Fossil Fuel Levers
$setglobal UI_Cofire           Yes !! [Yes, 20, 60, 100, 2060]
$setglobal UI_CCSRetrofit      Yes
$setglobal UI_LimCCSStorage   Yes  !! [No (default), Yes]
$setglobal UI_CCSEmisRate     Mid !! [Mid (default), High, Low]
$setglobal UI_GoodNeighbor    Yes

*$setglobal UI_RetireRetrofit  Yes
*$setglobal UI_CofireReq       20 !!  [20, 30, 40, 60, 100]
*$setglobal UI_PPAR_Cofire     Nat !! [No, Nat, State]
*$setglobal UI_CofireRate      Yes
*$setglobal UI_CofireRateAnn   Yes

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%_CCSLim%UI_LimCCSStorage%

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0

$if not errorfree $abort error(s) in call to Results


**-----------------------------------------------------------------------------------------------------

$elseif.SimType %UI_ScenKnl% == BLCARB

$onechoV >> UserInputs.gms
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal   %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v1
*$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v1

$setglobal UI_RGGIfloor   Yes
$setglobal UI_RPSReg      Yes !! [No, Yes]
$setglobal UI_CapTgt      Yes !! [AEO, Yes]
$setglobal UI_VACoal      Yes !![Yes, No]

$setglobal UI_FxTDLoss    Yes

*CA RPS
$setglobal UI_PSPol       CACES
$setglobal UI_PSElig      NonEmit
$setglobal UI_PPAR_PS     CA

*CA Cap Features
$setglobal UI_CAfloor     No !! [Yes, No]
$setglobal UI_CACap       Yes !!  Let CA price off price floor
$setglobal UI_CAStep      CCR !! [(default),ECR,CCR,ECRCCR,StandardLim]  (allow for price steps)
$setglobal UI_CAImp       Yes !! [Yes, No] (Allows carbon border adjustment for Califonia)
$setglobal UI_CABank      Yes !! [Yes, No] (Enables banking in California Cap-and-trade program)
$setglobal UI_CA2030Cap   AlwBudget  !! [Default (none), AlwBudget, 2020_60pct, 1990_60pct, 1990_52pct]

*Multi Sector Representation
$setglobal UI_CASector    Yes
$setglobal UI_CABank0     Yes !! [Yes, No] (Introduces initial bank of 300 something allowances)
$setglobal UI_CAScen      BAU    !! [BAU, Old: BAU0]
$setglobal UI_vCARB       230125  !! [221206, 230125]
$setglobal UI_CACons      Yes
$setglobal UI_CAInd       Yes
$setglobal UI_CABuilding  Yes
$setglobal UI_Diablo      Retire    !! [Retire, Extended]
$setglobal UI_CALDV       Yes
$setglobal UI_CAVMTScen   NA        !! [NA, VMTBAU]
$setglobal UI_CAEffScen   NA        !! [NA, 20pctEff2045]
$setglobal UI_ZEV         2050      !! [2035, 2040, 2050]
$setglobal UI_CAAdj       NA        !! [NA, Prog, Conv, Conc, Flat] Change to

*Sensitivies
$setglobal UI_NGPrc       BL2022 !! [Low, BL2022, High]

*Fix Recent Historical Year Generation and Capacity to calibrator values
$setglobal UI_vRS1        %UI_vHaiku%
$setglobal UI_RefScen1    %UI_Yrs%_BLIRA_%UI_vInputs%_v1_Central

$setglobal UI_vRS2        %UI_vRS1%
$setglobal UI_RefScen2    %UI_RefScen1%

$setglobal UI_FxGen       2022 !![0 (no), 2019, 2020, 2021, ... ]
$setglobal UI_FxCap       2023 !![0 (no), 2019, 2020, 2021, ... ]

*Limit Capacity Growth
$setglobal UI_GrowCap     2024 !! [3000 (no), 2019, 2020, 2021, ... ]

*Tax Credits
$setglobal UI_TCPol       IRA
$setglobal UI_TCElig      IRA
$setglobal UI_PPAR_TC     Nat
$setglobal UI_45Q         Yes

*Nuclear stays online
$setglobal UI_FxNukeGen   2023 !![3000 (no), 2019, 2020, 2021, ... ]

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v1_%UI_CAScen%_%UI_vCARB%

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results


**-----------------------------------------------------------------------------------------------------



$elseif.SimType %UI_ScenKnl% == CARB

$onechoV >> UserInputs.gms
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?

$setglobal UI_InitCal   %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v1
*$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v1

$setglobal UI_RGGIfloor   Yes
$setglobal UI_RPSReg      Yes       !! [No, Yes]
$setglobal UI_CapTgt      Yes       !! [AEO, Yes]
$setglobal UI_VACoal      Yes       !! [Yes, No]

$setglobal UI_FxTDLoss    Yes

*CA RPS
$setglobal UI_PSPol       CACES
$setglobal UI_PSElig      NonEmit
$setglobal UI_PPAR_PS     CA

*CA Cap Features
$setglobal UI_CAfloor     No        !! [Yes, No]
$setglobal UI_CACap       Yes       !!  Let CA price off price floor
$setglobal UI_CAStep      CCR       !! [(default),ECR,CCR,ECRCCR,StandardLim]  (allow for price steps)
$setglobal UI_CAImp       Yes       !! [Yes, No] (Allows carbon border adjustment for Califonia)
$setglobal UI_CABank      DualTax       !! [Yes, No, DualTax] (Enables banking in California Cap-and-trade program)
$setglobal UI_CA2030Cap   AlwBudget !! [Default (none), AlwBudget, 2020_60pct, 1990_60pct, 1990_52pct]

*Multi Sector Representation
$setglobal UI_CASector    Yes
$setglobal UI_CABank0     Yes       !! [Yes, No] (Introduces initial bank of 300 something allowances)

$setglobal UI_CAScen      SP       !! [BAU SP, Old: Alt3]

$setglobal UI_vCARB       230125   !! [221206, 230125]
$setglobal UI_CACons      Yes
$setglobal UI_CAInd       Yes
$setglobal UI_CABuilding  Yes
$setglobal UI_Diablo      Retire   !! [Retire, Extended]
$setglobal UI_CALDV       Yes

$setglobal UI_CAVMTScen   NA         !! [VMTBAU]
$setglobal UI_CAEffScen   NA         !! [NA, 20pctEff2045]
$setglobal UI_ZEV         2050       !! [2035,2040]
$setglobal UI_CAAdj       NA         !! [NA, Conv, Conc, Flat, CAFSC] Change to


*Sensitivies
$setglobal UI_NGPrc       BL2022    !! [Low, BL2022, High]

*Fix Recent Historical Year Generation and Capacity to calibrator values
$setglobal UI_vRS1        %UI_vHaiku%
$setglobal UI_RefScen1    %UI_Yrs%_BLCARB_%UI_vInputs%_v1_BAU_%UI_vCARB%

$setglobal UI_vRS2        %UI_vRS1%
$setglobal UI_RefScen2    %UI_RefScen1%

$setglobal UI_FxGen       2022 !![0 (no), 2019, 2020, 2021, ... ]
$setglobal UI_FxCap       2023 !![0 (no), 2019, 2020, 2021, ... ]

*Limit Capacity Growth
$setglobal UI_GrowCap     2024 !! [3000 (no), 2019, 2020, 2021, ... ]

*Tax Credits
$setglobal UI_TCPol       IRA
$setglobal UI_TCElig      IRA
$setglobal UI_PPAR_TC     Nat
$setglobal UI_45Q         Yes

*Nuclear stays online
$setglobal UI_FxNukeGen   2023 !![3000 (no), 2019, 2020, 2021, ... ]

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v1_%UI_CAScen%_%UI_vCARB%_%UI_CAStep%_VMT%UI_CAVMTScen%_Eff%UI_CAEffScen%_ZEV%UI_ZEV%_Adj%UI_CAAdj%_Diablo%UI_Diablo%


$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results


**-----------------------------------------------------------------------------------------------------

$elseif.SimType %UI_ScenKnl% == RGGI

$onechoV >> UserInputs.gms
$setglobal UI_SlvLoad   Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal   %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v1
$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v1

*$setglobal UI_RGGIfloor   Yes
$setglobal UI_CAfloor     Yes
$setglobal UI_RPSReg      Yes !! [No, Yes]
$setglobal UI_CapTgt      Yes !! [AEO, Yes]
$setglobal UI_VACoal      Yes !![Yes, No]

$setglobal UI_FxTDLoss    yes

*CA RPS
$setglobal UI_PSPol       CACES
$setglobal UI_PSElig      NonEmit
$setglobal UI_PPAR_PS     CA

$setglobal UI_RefEmisAnn Yes
*$setglobal UI_RGGIfloor   Yes   !! [Yes,No]
$setglobal UI_RGGI       RGGI12 !! [RGGI11, RGGI12, RGGIZone, RGGI13]
$setglobal UI_RGGILead   Yes
*$setglobal UI_RGGItighten     Yes  !! [Yes,No]
*$setglobal UI_ExRate     Yes  !! [Yes,No]
*$setglobal UI_RGGIBank   Yes
$setglobal UI_MACap       Yes

*Sensitivies
**$setglobal UI_CapCostRE  Low
$setglobal UI_NGPrc       BL2022    !! [Low, BL2022, High]

*Fix Recent Historical Year Generation and Capacity to calibrator values
$setglobal UI_vRS1        %UI_vHaiku%
$setglobal UI_RefScen1    %UI_Yrs%_BLIRA_%UI_vInputs%_v9

$setglobal UI_vRS2        %UI_vRS1%
$setglobal UI_RefScen2    %UI_RefScen1%

$setglobal UI_vRS3        %UI_vRS1%
$setglobal UI_RefScen3    %UI_RefScen1%

$setglobal UI_FxGen       2022 !![0 (no), 2019, 2020, 2021, ... ]
$setglobal UI_FxCap       2022 !![0 (no), 2019, 2020, 2021, ... ]

*Limit Capacity Growth
$setglobal UI_GrowCap     2023 !! [3000 (no), 2019, 2020, 2021, ... ]

*Tax Credits
$setglobal UI_TCPol       IRA
$setglobal UI_TCElig      IRA
$setglobal UI_PPAR_TC     Nat
$setglobal UI_45Q         Yes

*Nuclear stays online
$setglobal UI_FxNukeGen   2023 !![3000 (no), 2019, 2020, 2021, ... ]


$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-----------------------------------------------------------------------------------------------------
$endif.SimType
