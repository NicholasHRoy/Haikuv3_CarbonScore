$Title MCP System
$OffUpper
$OnSymList
$eolcom !!
$inlinecom { }
*------------------------------Scenario Selection-------------------------------

*$if not set UI_MScenKnl   $setglobal UI_MScenKnl    Calibrate
*$if not set UI_MScenKnl   $setglobal UI_MScenKnl    Baselines
*$if not set UI_MScenKnl   $setglobal UI_MScenKnl    BLScenarios
*$if not set UI_MScenKnl   $setglobal UI_MScenKnl    Scenarios
$if not set UI_MScenKnl   $setglobal UI_MScenKnl    OldScenarios


$include UserInputs
$include CopyLib
$include Init

**------------------------------------------------------------------------------------------------------------
*  CALIBRATION SCENARIOS
**-------------------------------------------------------------------------------------------------------------
$ifthen.MScenKnl %UI_MScenKnl% == Calibrate

$setglobal UI_ScenKnl     LPCal
$call copy UserInputs_Default.gms UserInputs.gms

$onechoV >> UserInputs.gms

*----------------------------------------------Scenario Specific Inputs----------------------------------------------

$setglobal UI_Cal         Yes !! [Yes,No] Solve LP for NPCap trajectory and duals?
$setglobal UI_SlvLoad     Slv !![Slv,Load] Solve the LP or load the previous solution?
$set       UI_CalYrs      %UI_Yrs% !! %UI_Yrs% (note that the code may not be robust to an LPCal with UI_Yrs <> UI_CalYrs ap191115)

$setglobal UI_RGGIfloor   Yes
$setglobal UI_CAfloor     Yes
$setglobal UI_RPSReg      No  !![No, Yes]
$setglobal UI_CapTgt      AEO !![AEO, Yes]

$setglobal UI_Scen        %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5  !! name the scenario

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP     --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-------------------------------------------------------------------------------------------------------------

$setglobal UI_ScenKnl     LPBLCal
$call copy UserInputs_Default.gms UserInputs.gms

$onechoV >> UserInputs.gms

*----------------------------------------------Scenario Specific Inputs----------------------------------------------

$setglobal UI_Cal         No
$setglobal UI_SlvLoad     Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal     %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v5

$setglobal UI_RGGIfloor   Yes
$setglobal UI_CAfloor     Yes
$setglobal UI_RPSReg      No  !![No, Yes]
$setglobal UI_CapTgt      AEO !![AEO, Yes]

$setglobal UI_Scen        %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP     --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results



**------------------------------------------------------------------------------------------------------------
*  BASELINES SCENARIOS
**-------------------------------------------------------------------------------------------------------------


$elseif.MScenKnl %UI_MScenKnl% == Baselines


$setglobal UI_ScenKnl     BLAEO
$call copy UserInputs_Default.gms UserInputs.gms

$onechoV >> UserInputs.gms

*----------------------------------------------Scenario Specific Inputs----------------------------------------------

$setglobal UI_SlvLoad     Slv !![Slv,Load] Solve the LP or load the previous solution?
$setglobal UI_InitCal     %UI_vHaiku%_%UI_Yrs%_LPCal_%UI_vInputs%_v5

$setglobal UI_RGGIfloor   Yes
$setglobal UI_CAfloor     Yes
$setglobal UI_RPSReg      Yes !![No, Yes]
$setglobal UI_CapTgt      AEO !![AEO, Yes]

$setglobal UI_FxTDLoss    Yes

$setglobal UI_Scen        %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP     --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results


**-----------------------------------------------------------------------------------------------------
$setglobal UI_ScenKnl     BLNREL
$call copy UserInputs_Default.gms UserInputs.gms


$onechoV >> UserInputs.gms

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

$setglobal UI_Scen        %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

$include UserInputs
$include CopyLib
$include Init

**------------------------------------------------------------------------------------------------------------
*  BASELINES SCENARIOS
**-------------------------------------------------------------------------------------------------------------

$elseif.MScenKnl %UI_MScenKnl% == BLScenarios

**-----------------------------------------------------------------------------------------------------
$setglobal UI_ScenKnl     BL
$call copy UserInputs_Default.gms UserInputs.gms

$onechoV >> UserInputs.gms
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
*$setglobal UI_GoodNeighbor   Yes

*Sensitivies
$setglobal UI_CSP             CSP       !! [CSP, AEO]
$setglobal UI_Demand          noIRA     !! [No, High, Low, NREL, ref2023, lowogs, highogs, noIRA]
$setglobal UI_NGPrc           BL2023  !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023, noIRA]
$setglobal UI_CapCostRE       No        !! [No, High, Low]

$setglobal UI_Scen        %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-----------------------------------------------------------------------------------------------------
*BL High NG Prices
$call copy UserInputs_Default.gms UserInputs.gms

$onechoV >> UserInputs.gms
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
*$setglobal UI_GoodNeighbor   Yes

*Sensitivies
$setglobal UI_CSP             CSP       !! [CSP, AEO]
$setglobal UI_Demand          noIRA     !! [No, High, Low, NREL, ref2023, lowogs, highogs, noIRA]
$setglobal UI_NGPrc           High2023  !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023, noIRA]
$setglobal UI_CapCostRE       No        !! [No, High, Low]

$setglobal UI_Scen        %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-----------------------------------------------------------------------------------------------------
*BL Low NG Prices
$call copy UserInputs_Default.gms UserInputs.gms

**-----------------------------------------------------------------------------------------------------

$onechoV >> UserInputs.gms

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
*$setglobal UI_GoodNeighbor   Yes

*Sensitivies
$setglobal UI_CSP             CSP       !! [CSP, AEO]
$setglobal UI_Demand          noIRA     !! [No, High, Low, NREL, ref2023, lowogs, highogs, noIRA]
$setglobal UI_NGPrc           Low2023  !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023, noIRA]
$setglobal UI_CapCostRE       No        !! [No, High, Low]

$setglobal UI_Scen        %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**------------------------------------------------------------------------------------------------------------
* SCENARIOS
**-------------------------------------------------------------------------------------------------------------

$elseif.MScenKnl %UI_MScenKnl% == Scenarios
*Good Neighbor
$setglobal UI_ScenKnl     BLGN
$call copy UserInputs_Default.gms UserInputs.gms

**-----------------------------------------------------------------------------------------------------

$onechoV >> UserInputs.gms

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

*Sensitivies
$setglobal UI_CSP         CSP       !![CSP, AEO]
$setglobal UI_Demand      noIRA     !![No, High, Low, NREL, ref2023, lowogs, highogs, noIRA]
$setglobal UI_NGPrc       noIRA    !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023, noIRA]
$setglobal UI_CapCostRE   No        !! [No, High, Low]

*Fix Recent Historical Year Generation and Capacity to calibrator values
$setglobal UI_vRS1        %UI_vHaiku%
$setglobal UI_RefScen1    %UI_Yrs%_BL_%UI_vInputs%_v5_%UI_CSP%_DemnoIRA_NGBL2023
$setglobal UI_vRS2        %UI_vRS1%
$setglobal UI_RefScen2    %UI_RefScen1%

$setglobal UI_FxGen       2023 !![0 (no), 2019, 2020, 2021, ... ]
$setglobal UI_FxCap       2024 !![0 (no), 2019, 2020, 2021, ... ]

*Limit Capacity Growth
$setglobal UI_GrowCap     2025 !! [3000 (no), 2019, 2020, 2021, ... ]
$setglobal UI_GrowCapPct  0.07 !! [0.07, 0.10]
$setglobal UI_EffCap      Yes   !! [Yes, No to effective capacity]

*Fossil Fuel Levers
$setglobal UI_Cofire          Yes !! [Yes, 20, 60, 100, 2060]
$setglobal UI_CCSRetrofit     Yes
$setglobal UI_LimCCSStorage   Yes  !! [No (default), Yes]
$setglobal UI_CCSEmisRate     Mid !! [Mid (default), High, Low]
$setglobal UI_GoodNeighbor    Yes

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%_CCS%UI_LimCCSStorage%

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

*IRA no CSAPR
$setglobal UI_ScenKnl     BLIRA
$call copy UserInputs_Default.gms UserInputs.gms

**-----------------------------------------------------------------------------------------------------

$onechoV >> UserInputs.gms

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
$setglobal UI_NGPrc       BL2023    !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023]
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


$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-----------------------------------------------------------------------------------------------------
*IRA + CSAPR
$setglobal UI_ScenKnl     CSP
$call copy UserInputs_Default.gms UserInputs.gms

$onechoV >> UserInputs.gms

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
$setglobal UI_NGPrc       BL2023    !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023]
$setglobal UI_CapCostRE   No        !! [No, High, Low]O
$setglobal UI_Demand      ref2023   !! [No, High, Low, NREL, AEO2023, CSP2023, ref2023, lowogs, highogs]
$setglobal UI_CSP         CSP       !! [CSP, AEO]
$setglobal UI_EPRIScen    Central   !! [Central, Low, High]

*Fossil Fuel Levers
$setglobal UI_Cofire           Yes !! [Yes, 20, 60, 100, 2060]
$setglobal UI_CCSRetrofit      Yes
$setglobal UI_LimCCSStorage    Yes  !! [No (default), Yes]
$setglobal UI_CCSEmisRate      Mid !! [Mid (default), High, Low]
$setglobal UI_GoodNeighbor    Yes

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%_CCS%UI_LimCCSStorage%


$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results


**-----------------------------------------------------------------------------------------------------
*IRA + GN (low NG Prices)
$setglobal UI_ScenKnl     CSP
$call copy UserInputs_Default.gms UserInputs.gms

$onechoV >> UserInputs.gms

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
$setglobal UI_RefScen1     %UI_Yrs%_BL_%UI_vInputs%_v5_CSP_DemnoIRA_NGLow2023

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
$setglobal UI_NGPrc       Low2023    !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023]
$setglobal UI_CapCostRE   No        !! [No, High, Low]O
$setglobal UI_Demand      ref2023   !! [No, High, Low, NREL, AEO2023, CSP2023, ref2023, lowogs, highogs]
$setglobal UI_CSP         CSP       !! [CSP, AEO]
$setglobal UI_EPRIScen    Central   !! [Central, Low, High]

*Fossil Fuel Levers
$setglobal UI_Cofire           Yes !! [Yes, 20, 60, 100, 2060]
$setglobal UI_CCSRetrofit      Yes
$setglobal UI_LimCCSStorage    Yes  !! [No (default), Yes]
$setglobal UI_CCSEmisRate      Mid !! [Mid (default), High, Low]
$setglobal UI_GoodNeighbor    Yes

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%_CCS%UI_LimCCSStorage%


$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

*IRA + GN (high NG Prices)
**-----------------------------------------------------------------------------------------------------
$setglobal UI_ScenKnl     CSP
$call copy UserInputs_Default.gms UserInputs.gms

$onechoV >> UserInputs.gms

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
$setglobal UI_RefScen1     %UI_Yrs%_BL_%UI_vInputs%_v5_CSP_DemnoIRA_NGHigh2023

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
$setglobal UI_NGPrc       High2023    !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023]
$setglobal UI_CapCostRE   No        !! [No, High, Low]O
$setglobal UI_Demand      ref2023   !! [No, High, Low, NREL, AEO2023, CSP2023, ref2023, lowogs, highogs]
$setglobal UI_CSP         CSP       !! [CSP, AEO]
$setglobal UI_EPRIScen    Central   !! [Central, Low, High]

*Fossil Fuel Levers
$setglobal UI_Cofire           Yes !! [Yes, 20, 60, 100, 2060]
$setglobal UI_CCSRetrofit      Yes
$setglobal UI_LimCCSStorage    Yes  !! [No (default), Yes]
$setglobal UI_CCSEmisRate      Mid !! [Mid (default), High, Low]
$setglobal UI_GoodNeighbor    Yes

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%_CCS%UI_LimCCSStorage%

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results


**-----------------------------------------------------------------------------------------------------
*IRA + GN (No Limit CCS)
$setglobal UI_ScenKnl     CSP
$call copy UserInputs_Default.gms UserInputs.gms

$onechoV >> UserInputs.gms

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
$setglobal UI_NGPrc       BL2023    !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023]
$setglobal UI_CapCostRE   No        !! [No, High, Low]O
$setglobal UI_Demand      ref2023   !! [No, High, Low, NREL, AEO2023, CSP2023, ref2023, lowogs, highogs]
$setglobal UI_CSP         CSP       !! [CSP, AEO]
$setglobal UI_EPRIScen    Central   !! [Central, Low, High]

*Fossil Fuel Levers
$setglobal UI_Cofire           Yes !! [Yes, 20, 60, 100, 2060]
$setglobal UI_CCSRetrofit      Yes
$setglobal UI_LimCCSStorage    No  !! [No (default), Yes]
$setglobal UI_CCSEmisRate      Mid !! [Mid (default), High, Low]
$setglobal UI_GoodNeighbor    Yes

$setglobal UI_Scen      %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%_CCS%UI_LimCCSStorage%


$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

$elseif.MScenKnl %UI_MScenKnl% == OldScenarios

**-----------------------------------------------------------------------------------------------------
$setglobal UI_ScenKnl     BL
$call copy UserInputs_Default.gms UserInputs.gms

$onechoV >> UserInputs.gms
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
*$setglobal UI_GoodNeighbor   Yes

*Sensitivies
$setglobal UI_CSP             CSP       !! [CSP, AEO]
$setglobal UI_Demand          noIRA     !! [No, High, Low, NREL, ref2023, lowogs, highogs, noIRA]
$setglobal UI_NGPrc           BL2022  !! [Low2022, BL2022, High2022, Low2023, BL2023, High2023, noIRA]
$setglobal UI_CapCostRE       No        !! [No, High, Low]

$setglobal UI_Scen        %UI_Yrs%_%UI_ScenKnl%_%UI_vInputs%_v5_%UI_CSP%_Dem%UI_Demand%_NG%UI_NGPrc%

$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-----------------------------------------------------------------------------------------------------
*IRA no CSAPR
$setglobal UI_ScenKnl     BLIRA
$call copy UserInputs_Default.gms UserInputs.gms

**-----------------------------------------------------------------------------------------------------

$onechoV >> UserInputs.gms

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


$offecho
$include UserInputs

$call mkdir Output\%UI_Scen%
$call copy UserInputs.gms Output\%UI_Scen%\UI_%UI_Scen%.gms
$call gams SolveLP      --UI_Scen=%UI_Scen% o=output\%UI_Scen%\Slv_%UI_Scen%.lst lo=2 lf=Output\%UI_Scen%\Slv_%UI_Scen%.log ps=0
$if not errorfree $abort error(s) in call to Results

**-----------------------------------------------------------------------------------------------------
$endif.MScenKnl
