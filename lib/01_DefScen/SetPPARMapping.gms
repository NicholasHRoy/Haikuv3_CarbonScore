map_tmp_YPH(Yr,PPAR,HMR)=NO;

$ifthen %UI_PPAR% == Nat
    map_tmp_YPH(Yr,'Nat',HMR)=YES;
$elseif %UI_PPAR% == RGGI9
    map_tmp_YPH(Yr,'RGGI9',HMR)=YES$( HMR_RGGI9(HMR) );
$elseif %UI_PPAR% == RGGI11
    map_tmp_YPH(Yr,'RGGI9',HMR)=YES$( SimYr(Yr)=2019 and HMR_RGGI9(HMR) );
    map_tmp_YPH(Yr,'RGGI10',HMR)=YES$( SimYr(Yr)=2020 and HMR_RGGI10(HMR) );
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
$elseif %UI_PPAR% == RGGI12
    map_tmp_YPH(Yr,'RGGI9',HMR)=YES$( SimYr(Yr)=2019 and HMR_RGGI9(HMR) );
    map_tmp_YPH(Yr,'RGGI10',HMR)=YES$( SimYr(Yr)=2020 and HMR_RGGI10(HMR) );
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( (SimYr(Yr)=2021 or SimYr(Yr)=2022) and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'RGGI12',HMR)=YES$( SimYr(Yr)>=2023 and HMR_RGGI12(HMR) );
$elseif %UI_PPAR% == RGGIZone
    map_tmp_YPH(Yr,'RGGI9',HMR)=YES$( SimYr(Yr)=2019 and HMR_RGGI9(HMR) );
    map_tmp_YPH(Yr,'RGGI10',HMR)=YES$( SimYr(Yr)=2020 and HMR_RGGI10(HMR) );
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( (SimYr(Yr)=2021 or SimYr(Yr)=2022) and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'RGGI12Lead',HMR)=YES$( SimYr(Yr)>=2023 and HMR_RGGI12Lead(HMR) );
    map_tmp_YPH(Yr,'RGGI12Stnd',HMR)=YES$( SimYr(Yr)>=2023 and HMR_RGGI12Stnd(HMR) );
$elseif %UI_PPAR% == RGGI13
    map_tmp_YPH(Yr,'RGGI9',HMR)=YES$( SimYr(Yr)=2019 and HMR_RGGI9(HMR) );
    map_tmp_YPH(Yr,'RGGI10',HMR)=YES$( SimYr(Yr)=2020 and HMR_RGGI10(HMR) );
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'RGGI12',HMR)=YES$( SimYr(Yr)>=2022 and SimYr(Yr) <= 2024 and HMR_RGGI12(HMR) );
    map_tmp_YPH(Yr,'RGGI13',HMR)=YES$( SimYr(Yr)>=2025 and HMR_RGGI13(HMR) );
$elseif %UI_PPAR% == RGGI19
    map_tmp_YPH(Yr,'RGGI19',HMR)=YES$( SimYr(Yr)>=2021 and ( HMR_RGGI11(HMR) or
         HMR_PA(HMR) or HMR_IL(HMR) or HMR_MN(HMR) or HMR_CO(HMR) or
         HMR_NM(HMR) or HMR_NV(HMR) or HMR_WA(HMR) or HMR_NC(HMR) ) );
*note that we activate all of these PPARs for the RGGI_TCI policy, but will keep only RGGI12 in the end
$elseif %UI_PPAR% == RGGI_TCI
    map_tmp_YPH(Yr,'RGGI12',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI12(HMR) );
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'RGGI9',HMR)=YES$( HMR_RGGI9(HMR) );
    map_tmp_YPH(Yr,'PA',HMR)=YES$( HMR_PA(HMR) );
$elseif %UI_PPAR% == NENYPJM
    map_tmp_YPH(Yr,'NERPS',HMR)=YES$( SimYr(Yr)>=2020 and HMR_NERPS(HMR) );
    map_tmp_YPH(Yr,'NYRPS',HMR)=YES$( SimYr(Yr)>=2020 and HMR_NYRPS(HMR) );
    map_tmp_YPH(Yr,'PJMRPS',HMR)=YES$( SimYr(Yr)>=2020 and HMR_PJMRPS(HMR));
$elseif %UI_PPAR%== RPS
    map_tmp_YPH(Yr,'PJMRPS',HMR)=YES$HMR_PJMRPS(HMR);
    map_tmp_YPH(Yr,'NERPS',HMR)=YES$HMR_NERPS(HMR);
    map_tmp_YPH(Yr,'NYRPS',HMR)=YES$HMR_NYRPS(HMR);
    map_tmp_YPH(Yr,'NWRPS',HMR)=YES$HMR_NWRPS(HMR);
    map_tmp_YPH(Yr,'CARPS',HMR)=YES$HMR_CARPS(HMR);
    map_tmp_YPH(Yr,'RMRPS',HMR)=YES$HMR_RMRPS(HMR);
    map_tmp_YPH(Yr,'AZNMRPS',HMR)=YES$HMR_AZNMRPS(HMR);
    map_tmp_YPH(Yr,'TXRPS',HMR)=YES$HMR_TXRPS(HMR);
    map_tmp_YPH(Yr,'MWRPS',HMR)=YES$HMR_MWRPS(HMR);
    map_tmp_YPH(Yr,'SERPS',HMR)=YES$HMR_SERPS(HMR);
$elseif %UI_PPAR%== RPS2
    map_tmp_YPH(Yr,'PJMRPS',HMR)=YES$HMR_PJMRPS(HMR);
    map_tmp_YPH(Yr,'NENYRPS',HMR)=YES$HMR_NENYRPS(HMR);
    map_tmp_YPH(Yr,'NWCARPS',HMR)=YES$HMR_NWCARPS(HMR);
    map_tmp_YPH(Yr,'RMRPS',HMR)=YES$HMR_RMRPS(HMR);
    map_tmp_YPH(Yr,'AZNMRPS',HMR)=YES$HMR_AZNMRPS(HMR);
    map_tmp_YPH(Yr,'TXRPS',HMR)=YES$HMR_TXRPS(HMR);
    map_tmp_YPH(Yr,'MWRPS',HMR)=YES$HMR_MWRPS(HMR);
    map_tmp_YPH(Yr,'SERPS',HMR)=YES$HMR_SERPS(HMR);
$elseif %UI_PPAR%== RPS3
    map_tmp_YPH(Yr,'PJMRGGIRPS',HMR)=YES$HMR_PJMRGGIRPS(HMR);
    map_tmp_YPH(Yr,'PJMnotRGGIRPS',HMR)=YES$HMR_PJMnotRGGIRPS(HMR);
    map_tmp_YPH(Yr,'NERPS',HMR)=YES$HMR_NERPS(HMR);
    map_tmp_YPH(Yr,'NYRPS',HMR)=YES$HMR_NYRPS(HMR);
    map_tmp_YPH(Yr,'NWRPS',HMR)=YES$HMR_NWRPS(HMR);
    map_tmp_YPH(Yr,'CARPS',HMR)=YES$HMR_CARPS(HMR);
    map_tmp_YPH(Yr,'RMRPS',HMR)=YES$HMR_RMRPS(HMR);
    map_tmp_YPH(Yr,'AZNMRPS',HMR)=YES$HMR_AZNMRPS(HMR);
    map_tmp_YPH(Yr,'TXRPS',HMR)=YES$HMR_TXRPS(HMR);
    map_tmp_YPH(Yr,'MWRPS',HMR)=YES$HMR_MWRPS(HMR);
    map_tmp_YPH(Yr,'SERPS',HMR)=YES$HMR_SERPS(HMR);
$elseif %UI_PPAR%==NatSPS
    map_tmp_YPH(Yr,'NatSPS',HMR)=YES$(SimYr(Yr)>=2020);
$ifthen.co %UI_ExemptCoRPS%==Yes
    map_tmp_YPH(Yr,'NatSPS',HMR)$HMR_CO(HMR)=NO;
$endif.co
$elseif %UI_PPAR%==NatWPS
    map_tmp_YPH(Yr,'NatWPS',HMR)=YES$(SimYr(Yr)>=2020);
$ifthen.co %UI_ExemptCoRPS%==Yes
    map_tmp_YPH(Yr,'NatWPS',HMR)$HMR_CO(HMR)=NO;
$endif.co
*Each of the 10 kernels (individual states or state pairs) join RGGI.
$elseif %UI_PPAR% == RGGINC
    map_tmp_YPH(Yr,'RGGINC',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_NC(HMR) );
$elseif %UI_PPAR% == RGGIPA
    map_tmp_YPH(Yr,'RGGIPA',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_PA(HMR) );
$elseif %UI_PPAR% == RGGIMN
    map_tmp_YPH(Yr,'RGGIMN',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_MN(HMR) );
$elseif %UI_PPAR% == RGGIWI
    map_tmp_YPH(Yr,'RGGIWI',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_WI(HMR) );
$elseif %UI_PPAR% == RGGIIL
    map_tmp_YPH(Yr,'RGGIIL',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_IL(HMR) );
$elseif %UI_PPAR% == RGGIMI
    map_tmp_YPH(Yr,'RGGIMI',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_MI(HMR) );
$elseif %UI_PPAR% == RGGICO
    map_tmp_YPH(Yr,'RGGICO',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_CO(HMR) );
$elseif %UI_PPAR% == RGGINM
    map_tmp_YPH(Yr,'RGGINM',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_NM(HMR) );
$elseif %UI_PPAR% == RGGINV
    map_tmp_YPH(Yr,'RGGINV',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_NV(HMR) );
$elseif %UI_PPAR% == RGGIWA
    map_tmp_YPH(Yr,'RGGIWA',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_WA(HMR) );

$elseif %UI_PPAR% == RGGINMCO
    map_tmp_YPH(Yr,'RGGINMCO',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_NMCO(HMR) );
$elseif %UI_PPAR% == RGGIILMN
    map_tmp_YPH(Yr,'RGGIILMN',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_ILMN(HMR) );
$elseif %UI_PPAR% == RGGIPANC
    map_tmp_YPH(Yr,'RGGIPANC',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_PANC(HMR) );

*Each of the 11 kernels (individual states or state pairs) exist in parallel with RGGI.
$elseif %UI_PPAR% == RGGI_NC
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'NC',HMR)=YES$( HMR_NC(HMR) );
$elseif %UI_PPAR% == RGGI_PA
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'PA',HMR)=YES$( HMR_PA(HMR) );
$elseif %UI_PPAR% == RGGI_MN
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'MN',HMR)=YES$(HMR_MN(HMR) );
$elseif %UI_PPAR% == RGGI_WI
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'WI',HMR)=YES$(HMR_WI(HMR) );
$elseif %UI_PPAR% == RGGI_IL
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'IL',HMR)=YES$( HMR_IL(HMR) );
$elseif %UI_PPAR% == RGGI_MI
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'MI',HMR)=YES$(HMR_MI(HMR) );
$elseif %UI_PPAR% == RGGI_CO
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'CO',HMR)=YES$( HMR_CO(HMR) );
$elseif %UI_PPAR% == RGGI_NM
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'NM',HMR)=YES$( HMR_NM(HMR) );
$elseif %UI_PPAR% == RGGI_NV
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'NV',HMR)=YES$( HMR_NV(HMR) );
$elseif %UI_PPAR% == RGGI_WA
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'WA',HMR)=YES$( HMR_WA(HMR) );
$elseif %UI_PPAR% == RGGI_NMCO
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'NMCO',HMR)=YES$( HMR_NMCO(HMR) );
$elseif %UI_PPAR% == RGGI_ILMN
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'ILMN',HMR)=YES$( HMR_ILMN(HMR) );
$elseif %UI_PPAR% == RGGI_PANC
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'PANC',HMR)=YES$( HMR_PANC(HMR) );
$elseif %UI_PPAR% == MENH
    map_tmp_YPH(Yr,'MENH',HMR)=YES$( HMR_MENH(HMR) );
$elseif %UI_PPAR% == NC
    map_tmp_YPH(Yr,'NC',HMR)=YES$( HMR_NC(HMR) );
$elseif %UI_PPAR% == PA
    map_tmp_YPH(Yr,'PA',HMR)=YES$( HMR_PA(HMR) );
$elseif %UI_PPAR% == MN
    map_tmp_YPH(Yr,'MN',HMR)=YES$( HMR_MN(HMR) );
$elseif %UI_PPAR% == WI
    map_tmp_YPH(Yr,'WI',HMR)=YES$( HMR_WI(HMR) );
$elseif %UI_PPAR% == IL
    map_tmp_YPH(Yr,'IL',HMR)=YES$( HMR_IL(HMR) );
$elseif %UI_PPAR% == MI
    map_tmp_YPH(Yr,'MI',HMR)=YES$( HMR_MI(HMR) );
$elseif %UI_PPAR% == CO
    map_tmp_YPH(Yr,'CO',HMR)=YES$( HMR_CO(HMR) );
$elseif %UI_PPAR% == CA
    map_tmp_YPH(Yr,'CA',HMR)=YES$( HMR_CA(HMR) );
$elseif %UI_PPAR% == NJ
    map_tmp_YPH(Yr,'NJ',HMR)=YES$( HMR_NJ(HMR) );
$elseif %UI_PPAR% == VA
    map_tmp_YPH(Yr,'VA',HMR)=YES$( HMR_VA(HMR) );
$elseif %UI_PPAR% == State
    map_tmp_YPH(Yr,'AL',HMR)=YES$HMR_AL(HMR);
    map_tmp_YPH(Yr,'AZ',HMR)=YES$HMR_AZ(HMR);
    map_tmp_YPH(Yr,'AR',HMR)=YES$HMR_AR(HMR);
    map_tmp_YPH(Yr,'CA',HMR)=YES$HMR_CA(HMR);
    map_tmp_YPH(Yr,'CO',HMR)=YES$HMR_CO(HMR);
    map_tmp_YPH(Yr,'CT',HMR)=YES$HMR_CT(HMR);
    map_tmp_YPH(Yr,'DE',HMR)=YES$HMR_DE(HMR);
    map_tmp_YPH(Yr,'FL',HMR)=YES$HMR_FL(HMR);
    map_tmp_YPH(Yr,'GA',HMR)=YES$HMR_GA(HMR);
    map_tmp_YPH(Yr,'ID',HMR)=YES$HMR_ID(HMR);
    map_tmp_YPH(Yr,'IL',HMR)=YES$HMR_IL(HMR);
    map_tmp_YPH(Yr,'IN',HMR)=YES$HMR_IN(HMR);
    map_tmp_YPH(Yr,'IA',HMR)=YES$HMR_IA(HMR);
    map_tmp_YPH(Yr,'KS',HMR)=YES$HMR_KS(HMR);
    map_tmp_YPH(Yr,'KY',HMR)=YES$HMR_KY(HMR);
    map_tmp_YPH(Yr,'LA',HMR)=YES$HMR_LA(HMR);
    map_tmp_YPH(Yr,'ME',HMR)=YES$HMR_ME(HMR);
    map_tmp_YPH(Yr,'MD',HMR)=YES$HMR_MD(HMR);
    map_tmp_YPH(Yr,'MA',HMR)=YES$HMR_MA(HMR);
    map_tmp_YPH(Yr,'MI',HMR)=YES$HMR_MI(HMR);
    map_tmp_YPH(Yr,'MN',HMR)=YES$HMR_MN(HMR);
    map_tmp_YPH(Yr,'MS',HMR)=YES$HMR_MS(HMR);
    map_tmp_YPH(Yr,'MO',HMR)=YES$HMR_MO(HMR);
    map_tmp_YPH(Yr,'MT',HMR)=YES$HMR_MT(HMR);
    map_tmp_YPH(Yr,'NE',HMR)=YES$HMR_NE(HMR);
    map_tmp_YPH(Yr,'NV',HMR)=YES$HMR_NV(HMR);
    map_tmp_YPH(Yr,'NH',HMR)=YES$HMR_NH(HMR);
    map_tmp_YPH(Yr,'NJ',HMR)=YES$HMR_NJ(HMR);
    map_tmp_YPH(Yr,'NM',HMR)=YES$HMR_NM(HMR);
    map_tmp_YPH(Yr,'NY',HMR)=YES$HMR_NY(HMR);
    map_tmp_YPH(Yr,'NC',HMR)=YES$HMR_NC(HMR);
    map_tmp_YPH(Yr,'ND',HMR)=YES$HMR_ND(HMR);
    map_tmp_YPH(Yr,'OH',HMR)=YES$HMR_OH(HMR);
    map_tmp_YPH(Yr,'OK',HMR)=YES$HMR_OK(HMR);
    map_tmp_YPH(Yr,'OR',HMR)=YES$HMR_OR(HMR);
    map_tmp_YPH(Yr,'PA',HMR)=YES$HMR_PA(HMR);
    map_tmp_YPH(Yr,'RI',HMR)=YES$HMR_RI(HMR);
    map_tmp_YPH(Yr,'SC',HMR)=YES$HMR_SC(HMR);
    map_tmp_YPH(Yr,'SD',HMR)=YES$HMR_SD(HMR);
    map_tmp_YPH(Yr,'TN',HMR)=YES$HMR_TN(HMR);
    map_tmp_YPH(Yr,'TX',HMR)=YES$HMR_TX(HMR);
    map_tmp_YPH(Yr,'UT',HMR)=YES$HMR_UT(HMR);
    map_tmp_YPH(Yr,'VT',HMR)=YES$HMR_VT(HMR);
    map_tmp_YPH(Yr,'VA',HMR)=YES$HMR_VA(HMR);
    map_tmp_YPH(Yr,'WA',HMR)=YES$HMR_WA(HMR);
    map_tmp_YPH(Yr,'WV',HMR)=YES$HMR_WV(HMR);
    map_tmp_YPH(Yr,'WI',HMR)=YES$HMR_WI(HMR);
    map_tmp_YPH(Yr,'WY',HMR)=YES$HMR_WY(HMR);
    map_tmp_YPH(Yr,'DC',HMR)=YES$HMR_DC(HMR);
$elseif %UI_PPAR% == CESRegion
    map_tmp_YPH(Yr,'PJMCES',HMR) =YES$         HMR_PJMCES(HMR);
    map_tmp_YPH(Yr,'SECES',HMR)  =YES$         HMR_SECES(HMR);
    map_tmp_YPH(Yr,'MISOCES',HMR)=YES$         HMR_MISOCES(HMR);
    map_tmp_YPH(Yr,'SPPCES',HMR) =YES$         HMR_SPPCES(HMR);
    map_tmp_YPH(Yr,'WECCCES',HMR)=YES$         HMR_WECCCES(HMR);
    map_tmp_YPH(Yr,'NECES',HMR)  =YES$         HMR_NECES(HMR);
    map_tmp_YPH(Yr,'TXCES',HMR)  =YES$         HMR_TXCES(HMR);
    map_tmp_YPH(Yr,'CACES',HMR)  =YES$         HMR_CACES(HMR);
    map_tmp_YPH(Yr,'NYCES',HMR)  =YES$         HMR_NYCES(HMR);

$endif

$ifthen %UI_RptAllPPAR% == Yes
    map_tmp_YPH(Yr,'Nat',HMR)=YES;
    map_tmp_YPH(Yr,'RGGI9',HMR)=YES$( HMR_RGGI9(HMR) );
    map_tmp_YPH(Yr,'RGGI10',HMR)=YES$( HMR_RGGI10(HMR) );
    map_tmp_YPH(Yr,'RGGI11',HMR)=YES$( HMR_RGGI11(HMR) );
    map_tmp_YPH(Yr,'RGGI12',HMR)=YES$( HMR_RGGI12(HMR) );
    map_tmp_YPH(Yr,'RGGI12Lead',HMR)=YES$(HMR_RGGI12Lead(HMR) );
    map_tmp_YPH(Yr,'RGGI12Stnd',HMR)=YES$(HMR_RGGI12Stnd(HMR) );
    map_tmp_YPH(Yr,'RGGI19',HMR)=YES$( SimYr(Yr)>=2021 and ( HMR_RGGI11(HMR) or
         HMR_PA(HMR) or HMR_IL(HMR) or HMR_MN(HMR) or HMR_CO(HMR) or
         HMR_NM(HMR) or HMR_NV(HMR) or HMR_WA(HMR) or HMR_NC(HMR) ) );
    map_tmp_YPH(Yr,'AL',HMR)=YES$HMR_AL(HMR);
    map_tmp_YPH(Yr,'AZ',HMR)=YES$HMR_AZ(HMR);
    map_tmp_YPH(Yr,'AR',HMR)=YES$HMR_AR(HMR);
    map_tmp_YPH(Yr,'CA',HMR)=YES$HMR_CA(HMR);
    map_tmp_YPH(Yr,'CO',HMR)=YES$HMR_CO(HMR);
    map_tmp_YPH(Yr,'CT',HMR)=YES$HMR_CT(HMR);
    map_tmp_YPH(Yr,'DE',HMR)=YES$HMR_DE(HMR);
    map_tmp_YPH(Yr,'FL',HMR)=YES$HMR_FL(HMR);
    map_tmp_YPH(Yr,'GA',HMR)=YES$HMR_GA(HMR);
    map_tmp_YPH(Yr,'ID',HMR)=YES$HMR_ID(HMR);
    map_tmp_YPH(Yr,'IL',HMR)=YES$HMR_IL(HMR);
    map_tmp_YPH(Yr,'IN',HMR)=YES$HMR_IN(HMR);
    map_tmp_YPH(Yr,'IA',HMR)=YES$HMR_IA(HMR);
    map_tmp_YPH(Yr,'KS',HMR)=YES$HMR_KS(HMR);
    map_tmp_YPH(Yr,'KY',HMR)=YES$HMR_KY(HMR);
    map_tmp_YPH(Yr,'LA',HMR)=YES$HMR_LA(HMR);
    map_tmp_YPH(Yr,'ME',HMR)=YES$HMR_ME(HMR);
    map_tmp_YPH(Yr,'MD',HMR)=YES$HMR_MD(HMR);
    map_tmp_YPH(Yr,'MA',HMR)=YES$HMR_MA(HMR);
    map_tmp_YPH(Yr,'MI',HMR)=YES$HMR_MI(HMR);
    map_tmp_YPH(Yr,'MN',HMR)=YES$HMR_MN(HMR);
    map_tmp_YPH(Yr,'MS',HMR)=YES$HMR_MS(HMR);
    map_tmp_YPH(Yr,'MO',HMR)=YES$HMR_MO(HMR);
    map_tmp_YPH(Yr,'MT',HMR)=YES$HMR_MT(HMR);
    map_tmp_YPH(Yr,'NE',HMR)=YES$HMR_NE(HMR);
    map_tmp_YPH(Yr,'NV',HMR)=YES$HMR_NV(HMR);
    map_tmp_YPH(Yr,'NH',HMR)=YES$HMR_NH(HMR);
    map_tmp_YPH(Yr,'NJ',HMR)=YES$HMR_NJ(HMR);
    map_tmp_YPH(Yr,'NM',HMR)=YES$HMR_NM(HMR);
    map_tmp_YPH(Yr,'NY',HMR)=YES$HMR_NY(HMR);
    map_tmp_YPH(Yr,'NC',HMR)=YES$HMR_NC(HMR);
    map_tmp_YPH(Yr,'ND',HMR)=YES$HMR_ND(HMR);
    map_tmp_YPH(Yr,'OH',HMR)=YES$HMR_OH(HMR);
    map_tmp_YPH(Yr,'OK',HMR)=YES$HMR_OK(HMR);
    map_tmp_YPH(Yr,'OR',HMR)=YES$HMR_OR(HMR);
    map_tmp_YPH(Yr,'PA',HMR)=YES$HMR_PA(HMR);
    map_tmp_YPH(Yr,'RI',HMR)=YES$HMR_RI(HMR);
    map_tmp_YPH(Yr,'SC',HMR)=YES$HMR_SC(HMR);
    map_tmp_YPH(Yr,'SD',HMR)=YES$HMR_SD(HMR);
    map_tmp_YPH(Yr,'TN',HMR)=YES$HMR_TN(HMR);
    map_tmp_YPH(Yr,'TX',HMR)=YES$HMR_TX(HMR);
    map_tmp_YPH(Yr,'UT',HMR)=YES$HMR_UT(HMR);
    map_tmp_YPH(Yr,'VT',HMR)=YES$HMR_VT(HMR);
    map_tmp_YPH(Yr,'VA',HMR)=YES$HMR_VA(HMR);
    map_tmp_YPH(Yr,'WA',HMR)=YES$HMR_WA(HMR);
    map_tmp_YPH(Yr,'WV',HMR)=YES$HMR_WV(HMR);
    map_tmp_YPH(Yr,'WI',HMR)=YES$HMR_WI(HMR);
    map_tmp_YPH(Yr,'WY',HMR)=YES$HMR_WY(HMR);
    map_tmp_YPH(Yr,'DC',HMR)=YES$HMR_DC(HMR);
    map_tmp_YPH(Yr,'NMCO',HMR)=YES$( SimYr(Yr)>=2021 and HMR_NMCO(HMR) );
    map_tmp_YPH(Yr,'ILMN',HMR)=YES$( SimYr(Yr)>=2021 and HMR_ILMN(HMR) );
    map_tmp_YPH(Yr,'PANC',HMR)=YES$( SimYr(Yr)>=2021 and HMR_PANC(HMR) );
    map_tmp_YPH(Yr,'RGGINC',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_NC(HMR) );
    map_tmp_YPH(Yr,'RGGIPA',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_PA(HMR) );
    map_tmp_YPH(Yr,'RGGIMN',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_MN(HMR) );
    map_tmp_YPH(Yr,'RGGIWI',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_WI(HMR) );
    map_tmp_YPH(Yr,'RGGIIL',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_IL(HMR) );
    map_tmp_YPH(Yr,'RGGIMI',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_MI(HMR) );
    map_tmp_YPH(Yr,'RGGICO',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_CO(HMR) );
    map_tmp_YPH(Yr,'RGGINM',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_NM(HMR) );
    map_tmp_YPH(Yr,'RGGINV',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_NV(HMR) );
    map_tmp_YPH(Yr,'RGGIWA',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_WA(HMR) );
    map_tmp_YPH(Yr,'RGGINMCO',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_NMCO(HMR) );
    map_tmp_YPH(Yr,'RGGIILMN',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_ILMN(HMR) );
    map_tmp_YPH(Yr,'RGGIPANC',HMR)=YES$( SimYr(Yr)>=2021 and HMR_RGGI11(HMR) or HMR_PANC(HMR) );
    map_tmp_YPH(Yr,'TCI',HMR)=YES$(HMR_TCI(HMR));
    map_tmp_YPH(Yr,'NonTCI',HMR)=YES$(not HMR_TCI(HMR));
    map_tmp_YPH(Yr,'PJM',HMR)=YES$HMR_PJM(HMR);
    map_tmp_YPH(Yr,'PJMRPS',HMR)=YES$(SimYr(Yr)>=2020 and HMR_PJMRPS(HMR));
    map_tmp_YPH(Yr,'NERPS',HMR)=YES$(SimYr(Yr)>=2020 and HMR_NERPS(HMR));
    map_tmp_YPH(Yr,'NYRPS',HMR)=YES$(SimYr(Yr)>=2020 and HMR_NYRPS(HMR));
    map_tmp_YPH(Yr,'NWRPS',HMR)=YES$(SimYr(Yr)>=2020 and HMR_NWRPS(HMR));
    map_tmp_YPH(Yr,'RMRPS',HMR)=YES$(SimYr(Yr)>=2020 and HMR_RMRPS(HMR));
    map_tmp_YPH(Yr,'AZNMRPS',HMR)=YES$(SimYr(Yr)>=2020 and HMR_AZNMRPS(HMR));
    map_tmp_YPH(Yr,'MWRPS',HMR)=YES$(SimYr(Yr)>=2020 and HMR_MWRPS(HMR));
    map_tmp_YPH(Yr,'SERPS',HMR)=YES$(SimYr(Yr)>=2020 and HMR_SERPS(HMR));
    map_tmp_YPH(Yr,'NatSPS',HMR)=YES$(SimYr(Yr)>=2020);
    map_tmp_YPH(Yr,'NatWPS',HMR)=YES$(SimYr(Yr)>=2020);
    map_tmp_YPH(Yr,'PJMCES',HMR) =YES$         HMR_PJMCES(HMR);
    map_tmp_YPH(Yr,'SECES',HMR)  =YES$         HMR_SECES(HMR);
    map_tmp_YPH(Yr,'MISOCES',HMR)=YES$         HMR_MISOCES(HMR);
    map_tmp_YPH(Yr,'SPPCES',HMR) =YES$         HMR_SPPCES(HMR);
    map_tmp_YPH(Yr,'WECCCES',HMR)=YES$         HMR_WECCCES(HMR);
    map_tmp_YPH(Yr,'NECES',HMR)  =YES$         HMR_NECES(HMR);
    map_tmp_YPH(Yr,'TXCES',HMR)  =YES$         HMR_TXCES(HMR);
    map_tmp_YPH(Yr,'CACES',HMR)  =YES$         HMR_CACES(HMR);
    map_tmp_YPH(Yr,'NYCES',HMR)  =YES$         HMR_NYCES(HMR);

    map_tmp_YPH(Yr,'EI',HMR)        = Yes$HMR_EI(HMR);
    map_tmp_YPH(Yr,'WECC',HMR)      = Yes$HMR_WECC(HMR);
    map_tmp_YPH(Yr,'ERCOT',HMR)     = Yes$HMR_ERCOT(HMR);
    map_tmp_YPH(Yr,'WECCnoCA',HMR)  = Yes$HMR_WECCnoCA(HMR);

    map_tmp_YPH(Yr,'ESC',HMR)    =YES$           HMR_ESC(HMR);
    map_tmp_YPH(Yr,'WSC',HMR)    =YES$           HMR_WSC(HMR);
    map_tmp_YPH(Yr,'MTN',HMR)    =YES$           HMR_MTN(HMR);
    map_tmp_YPH(Yr,'PAC',HMR)    =YES$           HMR_PAC(HMR);
    map_tmp_YPH(Yr,'NEG',HMR)    =YES$           HMR_NEG(HMR);
    map_tmp_YPH(Yr,'SAL',HMR)    =YES$           HMR_SAL(HMR);
    map_tmp_YPH(Yr,'WNC',HMR)    =YES$           HMR_WNC(HMR);
    map_tmp_YPH(Yr,'ENC',HMR)    =YES$           HMR_ENC(HMR);
    map_tmp_YPH(Yr,'MAL',HMR)    =YES$           HMR_MAL(HMR);
*    map_tmp_YPH(Yr,'COSRegions',HMR) = YES$    HMRCOS(HMR);
*    map_tmp_YPH(Yr,'NonCOSRegions',HMR) = YES$  (not HMRCOS(HMR));
$ifthen.co %UI_ExemptCoRPS%==Yes
    map_tmp_YPH(Yr,'NatSPS',HMR)$HMR_CO(HMR)=NO;
    map_tmp_YPH(Yr,'NatWPS',HMR)$HMR_CO(HMR)=NO;
$endif.co
    map_tmp_YPH(Yr,'CORPS',HMR)$HMR_CO(HMR)=Yes;
    map_tmp_YPH(Yr,'CO_PSCo',HMR)=YES$(HMR_PSCo(HMR));

$endif

$ifthen.census     %UI_CensusPPAR% == Yes
    map_tmp_YPH(Yr,'ESC',HMR)    =YES$           HMR_ESC(HMR);
    map_tmp_YPH(Yr,'WSC',HMR)    =YES$           HMR_WSC(HMR);
    map_tmp_YPH(Yr,'MTN',HMR)    =YES$           HMR_MTN(HMR);
    map_tmp_YPH(Yr,'PAC',HMR)    =YES$           HMR_PAC(HMR);
    map_tmp_YPH(Yr,'NEG',HMR)    =YES$           HMR_NEG(HMR);
    map_tmp_YPH(Yr,'SAL',HMR)    =YES$           HMR_SAL(HMR);
    map_tmp_YPH(Yr,'WNC',HMR)    =YES$           HMR_WNC(HMR);
    map_tmp_YPH(Yr,'ENC',HMR)    =YES$           HMR_ENC(HMR);
    map_tmp_YPH(Yr,'MAL',HMR)    =YES$           HMR_MAL(HMR);
$endif.census
