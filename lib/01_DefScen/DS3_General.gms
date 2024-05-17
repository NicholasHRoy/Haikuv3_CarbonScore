Sets
$ifthen.cal %UI_Cal% == Yes
        MPNoRtrInv(MP) non-retireable and non-investable MPs get exogenous capacity
                 /'Ex CHP Biomass','Ex CHP Coal','Ex CHP NG','Ex Pumped Storage',
                 'Ex Geothermal','Ex Hydro Conv','Ex Other','Ex Solar','Ex Onshore Wind',
                 'Ex Offshore Wind','New Geothermal','New Hydro Conv', 'New Biomass',
                 'New NGCC CCS','New Steam Coal CCS30','New Steam Coal CCS90',
                 'New Steam Nuclear'/
$else.cal
        MPNoRtrInv(MP) non-retireable and non-investable MPs get exogenous capacity
                 /'Ex CHP Biomass','Ex CHP Coal','Ex CHP NG','Ex Pumped Storage',
                 'Ex Geothermal','Ex Hydro Conv','Ex Other','Ex Solar','Ex Onshore Wind',
                 'Ex Offshore Wind','New Geothermal','New Hydro Conv', 'New Biomass',
                 'New Steam Coal CCS30',
                 'New Steam Nuclear'/
$endif.cal
        MPNoDsp(MP) non-dispatchable MPs generate at exogenous generation or an exogenous capacity factor !!
                /'Ex CHP Biomass','Ex CHP Coal','Ex CHP NG',
                 'Ex Geothermal','Ex Hydro Conv','Ex Other','Ex Solar','Ex Onshore Wind',
                 'Ex Offshore Wind','New Geothermal','New Hydro Conv','New Solar','New Onshore Wind','New Offshore Wind'/
        MPNoDspRtrInv(MP) "non-dispatchable MPs that are also non-retireable/investable"
        MPExoGen(Yr,HMR,MP) MPs for which generation is exogenous
        MPNoRsv(MP) MPs that contribute no capacity to reserves beyond their generation level !!
                /'Ex Geothermal','Ex Solar','Ex Onshore Wind','Ex Offshore Wind','New Geothermal','New Solar','New Onshore Wind','New Offshore Wind'/
        MPBaseLoad(MP) MPs that cannot be easilly turned on and off or ramped
                /'New Steam Nuclear','Ex Steam Nuclear'/
        MPBaseLoadCC(MP) MPs that cannot be easilly turned on and off or ramped
                /'New Steam Coal CCS30','New Steam Coal CCS90','New Steam Nuclear','Ex Steam Nuclear',
                 'Ex Steam Coal Eff1'*'Ex Steam Coal Eff18','New20 Steam Coal Eff1'*'New20 Steam Coal Eff18',
                 'New60 Steam Coal Eff1'*'New60 Steam Coal Eff18','New100 Steam Coal Eff1'*'New100 Steam Coal Eff18',
                 'NewCCS90 Steam Coal Eff1'*'NewCCS90 Steam Coal Eff18', 'NewCCS90 NGCC Eff1'*'NewCCS90 NGCC Eff18',
                 'Ex NGCC Eff1'*'Ex NGCC Eff18','New NGCC'  /
        HMRCOS(HMR) HMRs that price retail electricity by cost of service !!
                /AL, AR, AZ, CA, CO, FL, GA, IA, ID, IL, IN, KS,
                 KY, LA, MI, MN, MO, MS, MT, NC, ND, NE, NM, NV,
                 OK, OR, SC, SD, TN, UT, VA, WA, WI, WV, WY/
        SeaMonth(Sea,Month) mapping of months to seasons
                /Sum.(May,Jun,Jul,Aug,Sep), Win.(Dec,Jan,Feb), SF.(Mar,Apr,Oct,Nov)/
        HMRRGGICal(HMR) HMRs in RGGI for calibration RGGI11
                /MD,DE,NY,CT,RI,MA,VT,NH,ME,NJ,VA/
        FuelCalNoDspRtr(Fuel) fuel types that cannot dispatch or retire that are calibrated to AEO regional annual generation
                /Hydro, Wind, Solar, Geo, Oth/
        FuelNoDspNewCap(Fuel) non-dispatchable fuel types with new capacity investment potential
                /Hydro, Wind, Solar, Geo/
        FuelNuke(Fuel) /Nuke/
        MPCCS(MP) MPs with Carbon Capture and Storage
                 /'New NGCC CCS','New Steam Coal CCS30','New Steam Coal CCS90'
                 'NewCCS90 Steam Coal Eff1'*'NewCCS90 Steam Coal Eff18', 'NewCCS90 NGCC Eff1'*'NewCCS90 NGCC Eff18'/
        MPTech(MP,Tech) generation technology of each MP
                /('Ex Geothermal','Ex Steam Coal Eff1'*'Ex Steam Coal Eff18','Ex Steam NG',
                  'New20 Steam Coal Eff1'*'New20 Steam Coal Eff18','New60 Steam Coal Eff1'*'New60 Steam Coal Eff18','New100 Steam Coal Eff1'*'New100 Steam Coal Eff18',
                  'NewCCS90 Steam Coal Eff1'*'NewCCS90 Steam Coal Eff18',
                  'Ex Steam Nuclear','Ex Steam Oil','New Geothermal','New Steam Coal CCS30','New Steam Coal CCS90',
                  'New Steam Nuclear').Steam
                 ('Ex IGCC','Ex NGCC Eff1'*'Ex NGCC Eff18','New NGCC','New NGCC Adv','New NGCC CCS','NewCCS90 NGCC Eff1'*'NewCCS90 NGCC Eff18').CC
                 ('Ex CT NG Eff1'*'Ex CT NG Eff12','Ex CT Oil','New CT NG','New CT NG Adv').CT
                 ('Ex Hydro Conv','New Hydro Conv').Hydro
                 ('Ex Solar','New Solar').Solar
                 ('Ex Onshore Wind','New Onshore Wind').Onshore
                 ('Ex Offshore Wind','New Offshore Wind').Offshore
                 ('Ex CHP Hydro','Ex CHP Biomass','Ex CHP Coal','Ex CHP NG').CHP
                 ('Ex IC NG','Ex IC Oil').IC
                 ('Ex Battery Storage','New Battery Storage').Battery
                 ('Ex Pumped Storage').Pumped
                 ('Ex Biomass','Ex Other','New Biomass').Oth/
        MPFuel(MP,Fuel) fuel type of each MP
                /('Ex CHP Coal','Ex IGCC','Ex Steam Coal Eff1'*'Ex Steam Coal Eff18','New20 Steam Coal Eff1'*'New20 Steam Coal Eff18',
                  'New60 Steam Coal Eff1'*'New60 Steam Coal Eff18','New100 Steam Coal Eff1'*'New100 Steam Coal Eff18',
                  'NewCCS90 Steam Coal Eff1'*'NewCCS90 Steam Coal Eff18',
                  'New Steam Coal CCS30','New Steam Coal CCS90').Coal
                 ('Ex CHP NG','Ex CT NG Eff1'*'Ex CT NG Eff12','Ex IC NG','Ex NGCC Eff1'*'Ex NGCC Eff18','Ex Steam NG',
                  'NewCCS90 NGCC Eff1'*'NewCCS90 NGCC Eff18',
                  'New CT NG','New CT NG Adv','New NGCC','New NGCC Adv','New NGCC CCS').NG
                 ('Ex CT Oil','Ex IC Oil','Ex Steam Oil').Oil
                 ('Ex Steam Nuclear','New Steam Nuclear').Nuke
                 ('Ex Hydro Conv','New Hydro Conv', 'Ex CHP Hydro').Hydro
                 ('Ex Onshore Wind','Ex Offshore Wind','New Onshore Wind','New Offshore Wind').Wind
                 ('Ex Solar','New Solar').Solar
                 ('Ex CHP Biomass','Ex Biomass','New Biomass').Bio
                 ('Ex Geothermal','New Geothermal').Geo
                 ('Ex Battery Storage','New Battery Storage','Ex Pumped Storage').Storage
                 ('Ex Other').Oth/
        MPFC(MP,Fuel) source for fuel costs if not SNL
                /('Ex CT NG Eff1'*'Ex CT NG Eff12','Ex IC NG','Ex NGCC Eff1'*'Ex NGCC Eff18','Ex Steam NG',
                  'New CT NG','New CT NG Adv','New NGCC','New NGCC Adv','New NGCC CCS',
                  'NewCCS90 NGCC Eff1'*'NewCCS90 NGCC Eff18').NG
                 ('Ex IGCC','Ex Steam Coal Eff1'*'Ex Steam Coal Eff18','New20 Steam Coal Eff1'*'New20 Steam Coal Eff18',
                  'New60 Steam Coal Eff1'*'New60 Steam Coal Eff18','New100 Steam Coal Eff1'*'New100 Steam Coal Eff18',
                  'NewCCS90 Steam Coal Eff1'*'NewCCS90 Steam Coal Eff18',
                  'New Steam Coal CCS30','New Steam Coal CCS90').Coal
                 ('Ex CT Oil','Ex IC Oil','Ex Steam Oil').Oil/
        MPCCSRetrofit(MP) CCS retrofit plants
                 /
                 'NewCCS90 Steam Coal Eff1'*'NewCCS90 Steam Coal Eff18',
                 'NewCCS90 NGCC Eff1'*'NewCCS90 NGCC Eff18'
                 /
        MPCofire(MP) cofiring coal plants
                 /
                 'New20 Steam Coal Eff1'*'New20 Steam Coal Eff18'
                 'New60 Steam Coal Eff1'*'New60 Steam Coal Eff18'
                 'New100 Steam Coal Eff1'*'New100 Steam Coal Eff18'
                 'Ex Steam Coal Eff1'*'Ex Steam Coal Eff18'
                 /
        MPReplaceable(MP) mapping of retrofits to model plants
                /
                 'New20 Steam Coal Eff1'*'New20 Steam Coal Eff18'
                 'New60 Steam Coal Eff1'*'New60 Steam Coal Eff18'
                 'New100 Steam Coal Eff1'*'New100 Steam Coal Eff18'
                 'NewCCS90 Steam Coal Eff1'*'NewCCS90 Steam Coal Eff18'
                 'Ex Steam Coal Eff1'*'Ex Steam Coal Eff18'
                 'NewCCS90 NGCC Eff1'*'NewCCS90 NGCC Eff18'
                 'Ex NGCC Eff1'*'Ex NGCC Eff18'
               /
        Retrofit type of retorift for coal plants seeking to cofire
                /New20, New60, New100/
        MPRetrofit(MP,Retrofit) mapping of retrofits to model plants
               /'New20 Steam Coal Eff1'*'New20 Steam Coal Eff18'.New20
                'New60 Steam Coal Eff1'*'New60 Steam Coal Eff18'.New60
                'New100 Steam Coal Eff1'*'New100 Steam Coal Eff18'.New100
               /
        VehFuelEmis(VehType) mapping of vehicle fuels that emit CO2
               /Gas, CNG, Diesel, PHEV/
        VehFuelEV(VehType) mapping of vehicles that consume electricity
               /Elec, PHEV/
        VehFuelGas(VehType) mapping of vehicles that consume gasoline
                 /Gas, PHEV/
        VehFuelHybrid(VehType) mapping of vehicles that consume electricity
               /PHEV/
        MPFuelTechVin(FuelTechVin,MP) mapping of model plants to fuel technology and vintage
            /'Ex Coal'.('Ex IGCC','Ex CHP Coal',('Ex Steam Coal Eff1'*'Ex Steam Coal Eff18'))
            'Retrofit Coal CCS'.('NewCCS90 Steam Coal Eff1'*'NewCCS90 Steam Coal Eff18'),
            'Coal CCS'.('New Steam Coal CCS30','New Steam Coal CCS90'),
            'Coal Cofire 20'.('New20 Steam Coal Eff1' * 'New20 Steam Coal Eff18'),
            'Coal Cofire 60'.('New60 Steam Coal Eff1' * 'New60 Steam Coal Eff18'),
            'Coal Cofire 100'.('New100 Steam Coal Eff1' * 'New100 Steam Coal Eff18'),
            'Ex NG CT'.('Ex CT NG Eff1' * 'Ex CT NG Eff12'),
            'Ex NG CC'.('Ex NGCC Eff1' * 'Ex NGCC Eff18', 'Ex Steam NG'),
            'Ex NG CHP'.'Ex CHP NG',
            'Ex NG IC'.'Ex IC NG',
            'Rerofit NG CCS'.('NewCCS90 NGCC Eff1' * 'NewCCS90 NGCC Eff18'),
            'New NG CCS'.'New NGCC CCS',
            'New NG CC'.('New NGCC','New NGCC Adv'),
            'New NG CT'.('New CT NG', 'New CT NG Adv'),
            Oil.('Ex CT Oil','Ex IC Oil','Ex Steam Oil'),
            Nuke.('Ex Steam Nuclear','New Steam Nuclear'),
            Hydro.('Ex CHP Hydro','Ex Hydro Conv','New Hydro Conv'),
            'Pumped Hydro'.'Ex Pumped Storage',
            Bio. ('Ex Biomass','New Biomass','Ex CHP Biomass'),
            Solar.('Ex Solar', 'New Solar'),
            'Onshore Wind'.('Ex Onshore Wind',  'New Onshore Wind'),
            'Offshore Wind'.('Ex Offshore Wind', 'New Offshore Wind'),
            Geo.('Ex Geothermal','New Geothermal'),
            Storage.('Ex Battery Storage','New Battery Storage'),
            Other.'Ex Other'
            /
;

MPNoDspRtrInv(MP)=YES$(MPNoDsp(Mp) and MPNoRtrInv(MP));
*Check for mistakes
s1(MP)=sum(Fuel,MPFuel(MP,Fuel));
assert=smin(MP,s1(MP)=1);
abort$(assert=0) "Every MP should map to exactly one Fuel in MPFuel.", MPFuel;
s1(MP)=sum(Tech,MPTech(MP,Tech));
assert=smin(MP,s1(MP)=1);
abort$(assert=0) "Every MP should map to exactly one Tech in MPTech.", MPTech;

*Create real years in SimYr and SimYrFull. SimYrFull is used in SimYrWgt and interpolations.
SimYrFull('Yr0')=DataYr;
loop(YrFull, SimYrFull(YrFull+1)=SimYrFull(YrFull)+1 );
map_Yr_YrFull(Yr,YrFull) = YES$(SimYrFull(YrFull) = SimYrFull(Yr));
SimYr(Yr)=SimYrFull(Yr);
SimYrLast=smax(Yr,SimYr(Yr));

SimYrFullHist('Yr0')=DataYr;
loop(YrFullHist, SimYrFullHist(YrFullHist+1) = SimYrFullHist(YrFullHist)-1);

SimYear('1960') = 1960;
loop(Year, SimYear(Year+1)=SimYear(Year)+1 );

*Reserve margin is 15% universally.
RsvMrg(Yr,RsvRg)=0.15;

*Planned investment and retirement from SNL is supplemented for BL and subsequent scenarios.
EEExpExo(YrFull,HMR)=0;

$ifthen.CapTgt %UI_CapTgt% == AEO
        TechTgt(Yr,HMR,Tech)                                 = NPCapTargetAEO(Yr,HMR,Tech);
        RETgt(Yr,PPAR)                                       = 0;
$elseif.CapTgt %UI_CapTgt% == Yes
        TechTgt(Yr,HMR,Tech)                                  = max(NPCapTarget(Yr,HMR,Tech),NPCapTargetAEO(Yr,HMR,Tech));
*Set target years to be Yr + 1 of procurement targets in VA
$setglobal UI_PPAR_REtgt  VA
        RETgt(Yr,'VA')$(SimYr(Yr) =  2024)                    =  .2   ;
        RETgt(Yr,'VA')$(SimYr(Yr) >= 2025)                    = 3.2   ;
        RETgt(Yr,'VA')$(SimYr(Yr) >= 2028)                    = 6.4   ;
        RETgt(Yr,'VA')$(SimYr(Yr) >= 2031)                    = 10.6  ;
        RETgt(Yr,'VA')$(SimYr(Yr) >= 2036)                    = 16.7  ;
$else.CapTgt
*Initialize parameters for proper tech
        TechTgt(Yr,HMR,Tech)                                 = 0     ;
        RETgt(Yr,PPAR)                                       = 0     ;
$endif.CapTgt

Parameter
PlnInvRtrVA(YrFull,MP)
;

PlnInvRtrVA(YrFull,MP)$MPFuel(MP,'Coal') = PlnInvRtr(YrFull,'VA',MP);
*display PlnInvRtrVA;

*VA coal minimum utilization
parameter
VACoalCap(YrFull,MP) Minimum coal capacity in VA [MW]
VACoalGen(YrFull,MP) Minimum annual coal generation in VA [GWh]
VACoalUti(YrFull,MP) Minimum annual coal utilization in VA [fraction]
;
$ifthen.vacoal %UI_VACoal%==Yes
*VCHEC  and clover unit 1
VACoalCap(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull)>=2021) = 610 + 400;
VACoalCap(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull)> 2024) = 610;
VACoalCap(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull)> 2045) = 0;
*clover unit 2
VACoalCap(YrFull,'Ex Steam Coal Eff2')$(SimYrFull(YrFull)>=2021)= 400;
VACoalCap(YrFull,'Ex Steam Coal Eff2')$(SimYrFull(YrFull)> 2024)= 0;

*VCHEC  and clover unit 1
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2021)= 363.36480 + 531.90720;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2022)= 395.42640 + 381.58560;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2023)= 395.42640 + 308.35200;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2024)= 428.65920 + 332.38656;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2025)= 577.10880;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2026)= 422.14440;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2027)= 358.02120;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2028)= 380.43504;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2029)= 416.80080;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2030)= 502.29840;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2031)= 443.51880;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2032)= 359.00208;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2033)= 331.30320;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) = 2034)= 224.43120;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) >= 2035)=170.99520;
VACoalGen(YrFull,'Ex Steam Coal Eff1')$(SimYrFull(YrFull) > 2045)=0;

*clover unit 2
VACoalGen(YrFull,'Ex Steam Coal Eff2')$(SimYrFull(YrFull)=2021)= 517.97880;
VACoalGen(YrFull,'Ex Steam Coal Eff2')$(SimYrFull(YrFull)=2022)= 341.48232;
VACoalGen(YrFull,'Ex Steam Coal Eff2')$(SimYrFull(YrFull)=2023)= 303.11352;
VACoalGen(YrFull,'Ex Steam Coal Eff2')$(SimYrFull(YrFull)=2024)= 315.48614;

display
VACoalGen
VACoalCap
;
$endif.vacoal

*$stop

*Used to be deviation from Calibrator but the EIA should know these
*NC adds many MPs inv/rtr, demand reduction, and reserve margin reduction.
        PlnInvRtr(YrFull,'NC',MP)=PlnInvRtr(YrFull,'NC',MP)+PlnInvRtrNC(YrFull,MP);
*CO adds coal retirement
        PlnInvRtr('Yr15','CO','Ex Steam Coal Eff3') = PlnInvRtr('Yr15','CO','Ex Steam Coal Eff3') - 396.0/1E3; !! Comanche Unit 2 that is still in SNL
parameter
PlnInvRtrPA(MP,Yr)
;

*PlnInvRtrPA(MP,Yr)$MPFuel(MP,'Coal') = NPCap0('PA',MP) + PlnInvRtr(Yr,'PA',MP);

$ifthen.PACoalRtr %UI_PACoalRtr% == Yes
*Conemagh UnitKey 4997
PlnInvRtr('Yr9','PA','Ex Steam Coal Eff1') = PlnInvRtr('Yr9','PA','Ex Steam Coal Eff1') - 975.5/1E3;
*Conemagh UnitKey 4996
PlnInvRtr('Yr9','PA','Ex Steam Coal Eff2') = PlnInvRtr('Yr9','PA','Ex Steam Coal Eff2') - 975.5/1E3;
*Keystone UnitKey 5019
PlnInvRtr('Yr9','PA','Ex Steam Coal Eff3') = PlnInvRtr('Yr9','PA','Ex Steam Coal Eff3') - 936/1E3;
*Keystone UnitKey 5020
PlnInvRtr('Yr9','PA','Ex Steam Coal Eff4') = PlnInvRtr('Yr9','PA','Ex Steam Coal Eff4') - 936/1E3;
*Homer City UnitKey 9128
PlnInvRtr('Yr9','PA','Ex Steam Coal Eff6') = PlnInvRtr('Yr9','PA','Ex Steam Coal Eff6') - 692/1E3;
*Homer City UnitKey 9127
PlnInvRtr('Yr9','PA','Ex Steam Coal Eff7') = PlnInvRtr('Yr9','PA','Ex Steam Coal Eff7') - 660/1E3;
*Homer City UnitKey 9126
PlnInvRtr('Yr9','PA','Ex Steam Coal Eff8') = PlnInvRtr('Yr9','PA','Ex Steam Coal Eff8') - 660/1E3;
*Montour UnitKey 5991 repowered as gas
PlnInvRtr('Yr6','PA','Ex Steam Coal Eff9') = PlnInvRtr('Yr6','PA','Ex Steam Coal Eff9') - 893/1E3;
*PlnInvRtr('Yr6','PA','New NGCC') = PlnInvRtr('Yr6','PA','New NGCC') + 893/1E3;
*Montour UnitKey 5989 repowered as gas
PlnInvRtr('Yr6','PA','Ex Steam Coal Eff11') = PlnInvRtr('Yr6','PA','Ex Steam Coal Eff11') - 864.9/1E3;
*PlnInvRtr('Yr6','PA','New NGCC') = PlnInvRtr('Yr6','PA','New NGCC') + 864.9/1E3;
$endif.PACoalRtr

*PlnInvRtrPA(MP,Yr)$MPFuel(MP,'Coal') = NPCap0('PA',MP) + PlnInvRtr(Yr,'PA',MP);


$ifthen.DiabloCanyon %UI_Diablo% == Extended

PlnInvRtr('Yr5','CA', 'Ex Steam Nuclear')  = 0;
PlnInvRtr('Yr6','CA', 'Ex Steam Nuclear')  = 0;
PlnInvRtr('Yr11','CA', 'Ex Steam Nuclear') = -1.159 - 1.164;


$endif.DiabloCanyon


*Cumulative planned investment and retirement is used downstream and is constructed to avoid forcing capacity below 1
*MW for any MP (this facilitates calibration feasibility).
s3(YrFull,HMR,MP)=0;
loop(YrFull,
        s3(YrFull,HMR,MP)=max( s3(YrFull-1,HMR,MP)+PlnInvRtr(YrFull,HMR,MP),
                               -(NPCap0(HMR,MP)-min(1E-3,NPCap0(HMR,MP)))    );
);
CumPlnInvRtr(Yr,HMR,MP)=s3(Yr,HMR,MP);

*Multi-dimensional sets (HMR x MP, HMR x CC, HMRe x HMRi) shrink the constraints for sparsity.
*original code (prior to 20220117 includes all coal retrofit MPs even when the original plants don't exist
*HMRMP(HMR,MP)=YES$((NPCap0(HMR,MP) or smax(Yr,CumPlnInvRtr(Yr,HMR,MP))) or MPNew(MP));
*new code only includes coal retrofits if the old plants exist
HMRMP(HMR,MP)=YES$((NPCap0(HMR,MP) or smax(Yr,CumPlnInvRtr(Yr,HMR,MP))));
HMRMP(HMR,MPNew)$(not MPReplaceable(MPNew)) = Yes;
HMRMP(HMR,MPNew)$sum(MPEx,(NPCap0(HMR,MPEx) and MPReplaceable(MPNew) and MPExNew(MPEx,MPNew))) = Yes;

HMRei(HMRe,HMRi)=YES$TransCap0(HMRe,HMRi);


*set retirement dates for plants that must retrofit and adjust CumPlnInvRtr accordingly
RetrofitYr(MP) = 0;
$ifthen.RetireRetrofit %UI_RetireRetrofit% == "Yes"
RetrofitYr(MP)$(MPFuel(MP,"Coal") and MPCofire(MP) and MPEx(MP)) = 2030;
$endif.RetireRetrofit
CumPlnInvRtr(Yr,HMR,MP)$(SimYr(Yr)>=RetrofitYr(MP) and HMRMP(HMR,MP) and RetrofitYr(MP)<>0) = sum(Yrdup,CumPlnInvRtr(Yrdup,HMR,MP)$(SimYr(Yrdup)=RetrofitYr(MP)));

*Excluding MCP_CalGen for 1 HMR/Fuel pair for each Yr is necessary to make generation calibration feasible. GenAEO for
*MN/Bio is large enough. An alternative exclusion condion that is useful for diagnosing calibration feasibility is a
*specification for MCP_CalGen inclusion. If this is not to be invoked then the CalGenExcl defition should be commented.
Sets    CalGenExcl(Yr,HMR,Fuel) exclude MCP_CalGen
                /#Yr.DC.(Coal,NG,Oil,Nuke,Hydro,Wind,Solar,Bio,Geo,Oth)
                 #Yr.#HMR.Storage/
        CalGenYrIncl(Yr) include MCP_CalGen for Yr /Yr0/
*        CalGenHMRIncl(HMR) include MCP_CalGen for HMR /DC/
*        CalGenFuelIncl(Fuel) include MCP_CalGen for Fuel /Oil/!!Coal, NG{, Oil}, Nuke, Hydro, Wind, Solar, Geo, Bio, Oth/
        CalGenIncl(Yr,HMR,Fuel) include MCP_CalGen;
*CalGenExcl(Yr,HMR,Fuel)=YES$( not (CalGenYrIncl(Yr) and CalGenHMRIncl(HMR) and CalGenFuelIncl(Fuel)) );
CnstLagPast(Yr,Fuel)=sum((HMR,MPNew),(SimYr(Yr)>=DataYr+LeadTime(HMR,MPNew))*MPFuel(MPNew,Fuel))>0;
CalGenIncl(Yr,HMR,Fuel)=YES$(not CalGenExcl(Yr,HMR,Fuel) and (CnstLagPast(Yr,Fuel) or not FuelCalNoDspRtr(Fuel)));
display$(not SrpsDsp) CalGenExcl, CalGenIncl;

*Create values for hours and calculate the fraction of annual hours in each season.
*Sum={May,June,July,Aug,Sept}, Win={Dec,Jan,Feb}, SpFl={Mar,Apr,Oct,Nov}. TB 1=70%, 2=25%, 3=4%, 4=1%.
**HrsM(Month)=/744, 672, 744, 720, 744, 720, 744, 744, 720, 744, 720, 744/;
*Hrs('Sum','1')=2570; Hrs('Sum','2')=918; Hrs('Sum','3')=147; Hrs('Sum','4')=37;
*Hrs('Win','1')=1512; Hrs('Win','2')=540; Hrs('Win','3')=86; Hrs('Win','4')=22;
*Hrs('SF','1')=2050; Hrs('SF','2')=732; Hrs('SF','3')=117; Hrs('SF','4')=29;
*HrsAnn=sum((Sea,TB),Hrs(Sea,TB));
HrsAnn = 8760;

*create order for allowance price steps
s(step) = ord(step);

*set storage efficiency: 85% for batteries, 75% for pumped hydro
StorageEff(HMR,MP)$(MPFuel(MP,'Storage') and MPTech(MP,'Battery')) = 0.85;
StorageEff(HMR,MP)$(MPFuel(MP,'Storage') and MPTech(MP,'Pumped')) = 0.75;

*Set storage duration to be 4 hours for all storage types unless it's the VA hydro plant in Bath County which has 8 hours of storage.
StorageDuration(HMR,MP)$MPFuel(MP,'Storage') = 4;
StorageDuration('VA','Ex Pumped Storage') = 8;

*Transmission cost is slightly different for each HMR pair to facilitate unique solutions. The magnitude of
*transmission constraints is set at 35 GW arbitrarily because that is sufficiently large such that none bind in
*calibration. 35 is irrelevant to any non-calibration solution.
execseed=271922;
TransCost(HMRe,HMRi)=uniform(2.9,3.1);
TransCap(Yr,HMRe,HMRi,Sea)=+INF$TransCap0(HMRe,HMRi);

*I'm not sure why these are being rounded. ap171019
NPCap0(HMR,MP)=round(NPCap0(HMR,MP),6);
CumPlnInvRtr(Yr,HMR,MP)=round(CumPlnInvRtr(Yr,HMR,MP),6);

*Transform monthly variables into seasonal variables.
NetGenSea(HMR,MP,Sea)=sum(Month,NetGen0(HMR,MP)*PNG0(HMR,MP,Month)*SeaMonth(Sea,Month));
GenAEOSea(Yr,HMR,Sea)=sum((Month,Fuel),GenAEO(Yr,Month,HMR,Fuel)*SeaMonth(Sea,Month));
GenAEOYr(Yr,HMR) = sum((Month,Fuel),GenAEO(Yr,Month,HMR,Fuel));
GenAEOSeaFuel(Yr,HMR,Sea,Fuel)=sum(Month,GenAEO(Yr,Month,HMR,Fuel)*SeaMonth(Sea,Month));

*Aggregate Historical Data
NPCapHist(YrFullHist,HMR) = sum(Fuel,NPCapFuelHist(YrFullHist,HMR,Fuel));
GenHist(YrFullHist,HMR)   = sum(Fuel,GenFuelHist(YrFullHist,HMR,Fuel)$(not FuelStorage(Fuel)));
EmisHist(YrFullHist,HMR,Pol) = sum(Fuel,EmisFuelHist(YrFullHist,HMR,Fuel,Pol));

*replace 2019 generation and emissions with historical generation and emissions
*GenAEOSeaFuel('Yr0',HMR,Sea,Fuel)$(sum(Seadup,GenAEOSeaFuel('Yr0',HMR,Seadup,Fuel))<>0) =  GenFuelHist('Yr0',HMR,Fuel) * GenAEOSeaFuel('Yr0',HMR,Sea,Fuel)/sum(Seadup,GenAEOSeaFuel('Yr0',HMR,Seadup,Fuel));
*EmisAEO('Yr0',HMR,Fuel,Pol) =  EmisFuelHist('Yr0',HMR,Fuel,Pol);

$onText
parameter
EmisHistc(HMR,Fuel)
EmisAEOc(HMR,Fuel)
;

EmisHistc(HMR,Fuel)$HMR_VA(HMR) =  EmisFuelHist('Yr0',HMR,Fuel,'CO2');
EmisAEOc(HMR,Fuel)$HMR_VA(HMR) = EmisAEO('Yr0',HMR,Fuel,'CO2');

Display
EmisHistc
EmisAEOc
;
$offText


*adjust generation in Colorado for historical years.  This historical data comes from the EIA's 2015 and 2016 state profile
*GenAEOSea('Yr0','CO',Sea) = GenAEOSea('Yr0','CO',Sea)*(52393.078/GenAEOYr('Yr0','CO'));
*GenAEOSea('Yr1','CO',Sea) = GenAEOSea('Yr1','CO',Sea)*(54418.480/GenAEOYr('Yr1','CO'));
*For consistency we should also scale each fuel by the actual historical value,
*but I'm going to scale the whole thing by the same factor for the moment.
*GenAEOSeaFuel('Yr0','CO',Sea,Fuel) = GenAEOSeaFuel('Yr0','CO',Sea,Fuel)*(52393.078/GenAEOYr('Yr0','CO'));
*GenAEOSeaFuel('Yr1','CO',Sea,Fuel) = GenAEOSeaFuel('Yr1','CO',Sea,Fuel)*(54418.480/GenAEOYr('Yr1','CO'));
*display
*GenAEOSea
*GenAEOSeaFuel
*;
*$stop
*Adjustments over time from year 0
HR(Yr,HMR,MP)=HR0(HMR,MP)*0.998**(SimYr(Yr)-SimYr('Yr0'));
VOM(YrFull,HMR,MP)=VOM0(HMR,MP)*0.998**(SimYrFull(YrFull)-SimYrFull('Yr0'));
FOM(YrFull,HMR,MP)=FOM0(HMR,MP)*0.998**(SimYrFull(YrFull)-SimYrFull('Yr0'));
beta(YrFull)=(1-betaRt)**(SimYrFull(YrFull)-SimYr('Yr0'));

*Take VOM and FOM for existing batteries from the values for New batteries
VOM(YrFull,HMR,'Ex Battery Storage')=VOM(YrFull,HMR,'New Battery Storage');
FOM(YrFull,HMR,'Ex Battery Storage')=FOM(YrFull,HMR,'New Battery Storage');

*HR Fix
HR(Yr,HMR,MP)$(MPFuel(MP,'NG')) = HR(Yr,HMR,MP) * NGHRScalar ;
HR(Yr,HMR,MP)$(MPFuel(MP,'Coal')) = HR(Yr,HMR,MP) * CoalHRScalar;

*Assign ERin values to CHPs so that they can have Emissions Rates
ERinCO20(HMR,MP)$(MPTech(MP,'CHP') and MPFuel(MP,'NG')) = smax(MPdup,ERinCO20(HMR,MPdup)*(MPFuel(MPdup,'NG') and (MPTech(MPdup,'CC') or MPTech(MPdup,'CT'))));
ERinCO20(HMR,MP)$(MPTech(MP,'CHP') and MPFuel(MP,'Coal')) = smax(MPdup,ERinCO20(HMR,MPdup)*(MPFuel(MPdup,'Coal') and MPEx(MPdup)));
ERinSO20(HMR,MP)$(MPTech(MP,'CHP') and MPFuel(MP,'NG')) = smax(MPdup,ERinSO20(HMR,MPdup)*(MPFuel(MPdup,'NG') and (MPTech(MPdup,'CC') or MPTech(MPdup,'CT'))));
ERinSO20(HMR,MP)$(MPTech(MP,'CHP') and MPFuel(MP,'Coal')) = smax(MPdup,ERinSO20(HMR,MPdup)*(MPFuel(MPdup,'Coal') and MPEx(MPdup)));
ERinNOx0(HMR,MP)$(MPTech(MP,'CHP') and MPFuel(MP,'NG')) = smax(MPdup,ERinNOx0(HMR,MPdup)*(MPFuel(MPdup,'NG') and (MPTech(MPdup,'CC') or MPTech(MPdup,'CT'))));
ERinNOx0(HMR,MP)$(MPTech(MP,'CHP') and MPFuel(MP,'Coal')) = smax(MPdup,ERinNOx0(HMR,MPdup)*(MPFuel(MPdup,'Coal') and MPEx(MPdup)));

*correct emissions rates for NOx and SO2 at CCS plants to values in NREL ATB 2022  lb/MMBTU
ERinSO20(HMR,"New Steam Coal CCS90") =  0;
ERinSO20(HMR,"New NGCC CCS") =  0;
ERinNOx0(HMR,"New Steam Coal CCS90") =  0.07618;
ERinNOx0(HMR,"New NGCC CCS") =  0.0033;

*correct rates for NOx and SO2 at Coal CCS retrofit plants to follow Table 2 in the CCS-IPI paper with Ana Varela Varela
*The paper describes coal CCS retrofit emissions in terms of % of emissions per unit heat INPUT
$ifthen.ccsEmis  %UI_CCSEmisRate% == High
ERinSO20(HMR,MP)$(MPCCSRetrofit(MP) and MPFuel(MP,"Coal"))  = ERinSO20(HMR,MP) * 0.03;
ERinNOx0(HMR,MP)$(MPCCSRetrofit(MP) and MPFuel(MP,"Coal"))  = ERinNOx0(HMR,MP) * 1.00;
$elseif.ccsEmis  %UI_CCSEmisRate% == Low
ERinSO20(HMR,MP)$(MPCCSRetrofit(MP) and MPFuel(MP,"Coal"))  = ERinSO20(HMR,MP) * 0.00;
ERinNOx0(HMR,MP)$(MPCCSRetrofit(MP) and MPFuel(MP,"Coal"))  = ERinNOx0(HMR,MP) * 0.50;
$else.ccsEmis
ERinSO20(HMR,MP)$(MPCCSRetrofit(MP) and MPFuel(MP,"Coal"))  = ERinSO20(HMR,MP) * ((0.03 + 0.00)/2);
ERinNOx0(HMR,MP)$(MPCCSRetrofit(MP) and MPFuel(MP,"Coal"))  = ERinNOx0(HMR,MP) * ((1.00 + 0.50)/2);
$endif.ccsEmis

*create version of ERin0 that exists across years so that we can incorporate good neighbor multipliers as needed
ERinCO2(YrFull,HMR,MP) = ERinCO20(HMR,MP);
ERinSO2(YrFull,HMR,MP) = ERinSO20(HMR,MP);
ERinNOx(YrFull,HMR,MP) = ERinNOx0(HMR,MP);

*make sure no states have zero values for pct changes from good neighbor -- maya, please go back and fix this in stata later if you can
HRpct(YrFull,HMR)$(HRpct(YrFull,HMR)=0) = 1;
ERinSO2pct(YrFull,HMR)$(ERinSO2pct(YrFull,HMR)=0) = 1;
ERinNOxpct(YrFull,HMR)$(ERinNOxpct(YrFull,HMR)=0) = 1;
ERinCO2pct(YrFull,HMR)$(ERinCO2pct(YrFull,HMR)=0) = 1;
VOMpct(YrFull,HMR)$(VOMpct(YrFull,HMR)=0) = 1;
FOMpct(YrFull,HMR)$(FOMpct(YrFull,HMR)=0)=1;

*change HR, ERin, VOM, and FOM for coal plants due to the Good Neighbor rule
*or turn good neighbor coal retirements to zero to avoid running the CSAPR equation
$ifthen.gn %UI_GoodNeighbor% == Yes
HR(Yr,HMR,MP)$(         MPFuel(MP,"Coal") and (not MPCCS(MP)) and MPTech(MP,"Steam")) = HRpct(Yr,HMR)          * HR(Yr,HMR,MP);
ERinSO2(YrFull,HMR,MP)$(MPFuel(MP,"Coal") and (not MPCCS(MP)) and MPTech(MP,"Steam")) = ERinSO2pct(YrFull,HMR) * ERinSO2(YrFull,HMR,MP);
ERinNOx(YrFull,HMR,MP)$(MPFuel(MP,"Coal") and (not MPCCS(MP)) and MPTech(MP,"Steam")) = ERinNOxpct(YrFull,HMR) * ERinNOx(YrFull,HMR,MP);
ERinCO2(YrFull,HMR,MP)$(MPFuel(MP,"Coal") and (not MPCCS(MP)) and MPTech(MP,"Steam")) = ERinCO2pct(YrFull,HMR) * ERinCO2(YrFull,HMR,MP);
VOM(YrFull,HMR,MP)$(    MPFuel(MP,"Coal") and (not MPCCS(MP)) and MPTech(MP,"Steam")) = VOMpct(YrFull,HMR)     * VOM(YrFull,HMR,MP);
FOM(YrFull,HMR,MP)$(    MPFuel(MP,"Coal") and (not MPCCS(MP)) and MPTech(MP,"Steam")) = FOMpct(YrFull,HMR)     * FOM(YrFull,HMR,MP);
$else.gn
NPCapRetired(YrFull,HMR) = 0;
$endif.gn

*Emissions rates are expressed per unit output and are scaled down for SO2 after 2015 beased on AEO
*emissions rates to account for the start of MATS in 2016.
*180221: Remove SO2 adjustment. MATS will be accounted for in a different way.
ERo(Yr,HMR,MP,'CO2')=ERinCO2(Yr,HMR,MP)*HR(Yr,HMR,MP)/2E6;
ERo(Yr,HMR,MP,'SO2')=ERinSO2(Yr,HMR,MP)*HR(Yr,HMR,MP)/2E6;
ERo(Yr,HMR,MP,'NOx')=ERinNOx(Yr,HMR,MP)*HR(Yr,HMR,MP)/2E6;
*s3(Yr,HMR,Fuel)=sum(Sea,GenAEOSeaFuel(Yr,HMR,Sea,Fuel));
*ERFuelPolAEO(Yr,HMR,Fuel,Pol)=EmisAEO(Yr,HMR,Fuel,Pol)/(1$(not s3(Yr,HMR,Fuel))+s3(Yr,HMR,Fuel))
*        /PolScl(Pol)*PolSclER(Pol);
*ERo(Yr,HMR,MP,'SO2')$(ord(Yr)>1 and MPFuel(MP,'Coal'))=ERo(Yr,HMR,MP,'SO2')
*        *ERFuelPolAEO('Yr1',HMR,'Coal','SO2')
*        /(1$(not ERFuelPolAEO('Yr0',HMR,'Coal','SO2'))+ERFuelPolAEO('Yr0',HMR,'Coal','SO2'));

*Emissions rates for coal/NG cofiring at required level
$ifthen.cofire %UI_CofireReq% == 20
        CofireReq  = 0.2;
$elseif.cofire %UI_CofireReq% == 30
        CofireReq  = 0.3;
$elseif.cofire %UI_CofireReq% == 40
        CofireReq  = 0.4;
$elseif.cofire %UI_CofireReq% == 60
        CofireReq  = 0.6;
$elseif.cofire %UI_CofireReq% == 100
        CofireReq  = 1;
$else.cofire
        CofireReq  = 0;
$endif.cofire
        HRNonCofire(Yr,HMR,Eff) = sum(MP,HR(Yr,HMR,MP)*MPCofire(MP)*(not MPNew(MP))*MPEff(MP,Eff));
        HRCofire(Yr,HMR,Eff) = HRNonCofire(Yr,HMR,Eff) * ((1-CofireReq) + (CofireReq * 1.05));
        ERinCO20Cofire(Yr,HMR,Eff)$(HRNonCofire(Yr,HMR,Eff)<>0) =
                                    sum(MP,ERinCO20(HMR,MP)*MPCofire(MP)*(not MPNew(MP))*MPEff(MP,Eff))
                                         *((1-CofireReq) + (CofireReq * 0.5 * HRCofire(Yr,HMR,Eff)/HRNonCofire(Yr,HMR,Eff)));
        ERoCofire(Yr,HMR,Eff) = HRCofire(Yr,HMR,Eff)*ERinCO20Cofire(Yr,HMR,Eff)/2E6;
*round up the emissions rates for feasibility
        ERoCofire(Yr,HMR,Eff) = round(ERoCofire(Yr,HMR,Eff),6) + 1E-6;

$onText
Parameter
HRCofire1(Yr,HMR,MP)
tmp_ERinCO20(HMR,MP)
tmp_ERo(Yr,HMR,MP)
;

HRCofire1(Yr,HMR,MP)  = HR(Yr,HMR,MP)$(MPCofire(MP) and MPNew(MP));
tmp_ERinCO20(HMR,MP) = ERinCO20(HMR,MP)$(MPCofire(MP) and MPNew(MP));
tmp_ERo(Yr,HMR,MP) = ERo(Yr,HMR,MP,'CO2')$(MPCofire(MP) and MPNew(MP));

display
HRCofire1
tmp_ERinCO20
tmp_ERo
HRNonCofire
HRCofire
ERinCO20Cofire
ERoCofire
CofireReq
;

$offText

*set lookback for cofire cap policies
$ifthen.lookback %UI_LookBack% == 1
LookBack = 1;
$elseif.lookback %UI_LookBack% == 2
LookBack = 2
$else.lookback
LookBack = 0
$endif.lookback

display
LookBack
;

*add emissions capture rates for CCS plants. These will not be effected by the emissions multiplier.
*If we want them to be effected by the emissions multiplier, move them to SolveLP
ERoCCS(Yr,HMR,"New NGCC CCS") = 9 * ERo(Yr,HMR,"New NGCC CCS","CO2");
ERoCCS(Yr,HMR,"New Steam Coal CCS90") = 9 * ERo(Yr,HMR,"New Steam Coal CCS90","CO2");
ERoCCS(Yr,HMR,"New Steam Coal CCS30") = 3/7 * ERo(Yr,HMR,"New Steam Coal CCS30","CO2");
ERoCCS(Yr,HMR,MP)$MPCCSRetrofit(MP) = 9 * ERo(Yr,HMR,MP,"CO2");

*add lag for CCS plant builds, only relevant for phase out of 45q
CnstLagCCS(MPCCS)$MPFuel(MPCCS,'NG') = 3;
CnstLagCCS(MPCCS)$MPFuel(MPCCS,'Coal') = 5;

*Add Seasonal Maximum generation to VA bath county pumped hydro facility [GWh] -- Historical seasonal from 2001
*taken from the spreadsheet "Bath_County_net_generation_monthly.xlsx" sent by Bill Shobe
VAStorageMax("Sum") = 700;
VAStorageMax("Win") = 250;
VAStorageMax("SF")  = 665;

*----------------------------------------
NPCapMax(Yr,HMR,MP) = +INF;
NPCapFuelMax(Yr,Fuel) = +INF;
*-----------------------------------


$ifthen.NGup %UI_MethaneFee% == Yes
$ontext
FCiRef(Yr,HMR,'NG')$(SimYr(Yr)=2023) =  FCiRef(Yr,HMR,'NG') + (.003*(1/(1.09)));
FCiRef(Yr,HMR,'NG')$(SimYr(Yr)=2024) =  FCiRef(Yr,HMR,'NG') + (.039*(1/(1.09))*(1/(1.025)));
FCiRef(Yr,HMR,'NG')$(SimYr(Yr)=2025) =  FCiRef(Yr,HMR,'NG') + (.041*(1/(1.09))*(1/(1.025))*(1/(1.025)));
FCiRef(Yr,HMR,'NG')$(SimYr(Yr)>=2025) =  FCiRef('Yr6',HMR,'NG') + (.041*(1/(1.09))*((1/(1.025))**(SimYr(Yr)-2025)));
$offtext
$endif.NGup

*START use existing MP parameters to populate parameters for new MPs.
*--------------------------------------------------
*Calculate ratio of operating to nameplate capacity (OpNPCapRat) from NPCap0, SumCap0, WinCap0. If NPCap0=0 for an
*existing MP, the national average OpNPCapRat for each MP type is assigned. New MPs get OpNPCapRat from existing MPs
*mapped by MPExNew(MPEx,MPNew).
OpNPCapRat(HMR,MP,'Sum')=( SumCap0(HMR,MP)/NPCap0(HMR,MP) )$NPCap0(HMR,MP);
OpNPCapRat(HMR,MP,'Win')=( WinCap0(HMR,MP)/NPCap0(HMR,MP) )$NPCap0(HMR,MP);
OpNPCapRat(HMR,MP,'SF')=( 0.5*(SumCap0(HMR,MP)+WinCap0(HMR,MP))/NPCap0(HMR,MP) )$NPCap0(HMR,MP);
s2(MPEx,Sea)=( sum(HMR,OpNPCapRat(HMR,MPEx,Sea)*NPCap0(HMR,MPEx))/sum(HMR,NPCap0(HMR,MPEx)) )$sum(HMR,NPCap0(HMR,MPEx));
s2b(HMR,MPEx)=uniform(0,0.01);
OpNPCapRat(HMR,MPEx,Sea)$(not NPCap0(HMR,MPEx))=s2(MPEx,Sea)+s2b(HMR,MPEx);
s2(HMR,MPNew)=uniform(0,0.01);
OpNPCapRat(HMR,MPNew,Sea)=sum(MPEx,OpNPCapRat(HMR,MPEx,Sea)*MPExNew(MPEx,MPNew))+s2(HMR,MPNew);

*Historical capacity factors (CF) are used for non-dispatchable MPs, except new solar. Historical CF are calculated from
*NetGen0, OpNPCapRat and NPCap0. They vary by season, but not by TB within a season. For existing MPs with NPCap0=0, the
*national average CF for each MP is assigned. New MPs get CF from existing MPs mapped by MPExNew(MPEx,MPNew). For solar,
*we have TB specific CFs from NREL. New solar uses these CFs directly. Existing solar uses seasonal historical CF scaled
*by the NREL data to impose TB variation within seasons.
CFSea(Yr,HMR,MP,Sea)=( NetGenSea(HMR,MP,Sea)/(OpNPCapRat(HMR,MP,Sea)*NPCap0(HMR,MP)*sum(TB,Hrs(Sea,TB))) )$NPCap0(HMR,MP);
s3(Yr,MPEx,Sea)=( sum(HMR,CFSea(Yr,HMR,MPEx,Sea)*NPCap0(HMR,MPEx))/sum(HMR,NPCap0(HMR,MPEx)) )$sum(HMR,NPCap0(HMR,MPEx));
s2(HMR,MPEx)=uniform(0,0.01);
CFSea(Yr,HMR,MPEx,Sea)$(not NPCap0(HMR,MPEx))=s3(Yr,MPEx,Sea)+s2(HMR,MPEx);
s2(HMR,MPNew)=uniform(0,0.01);
CFSea(Yr,HMR,MPNew,Sea)=sum(MPEx,CFSea(Yr,HMR,MPEx,Sea)*MPExNew(MPEx,MPNew))+s2(HMR,MPNew);
CF(Yr,HMR,MP,Sea,TB)=CFSea(Yr,HMR,MP,Sea);
*NREL data applies to solar, and zero CFs are avoided by a 1e-6 lower bound.
SolarAF(HMR,Sea,TB)=max(1E-6,SolarAF(HMR,Sea,TB));
CF(Yr,HMR,'New Solar',Sea,TB)=SolarAF(HMR,Sea,TB);
s2(HMR,Sea)=sum(TB,SolarAF(HMR,Sea,TB))/sum(TB,1);
CF(Yr,HMR,'Ex Solar',Sea,TB)=max(0,min(1, CF(Yr,HMR,'Ex Solar',Sea,TB)*SolarAF(HMR,Sea,TB)/s2(HMR,Sea) ));

*For existing MPs with NPCap0=0, the national average forced and schedulded outage rates (EFORd and WSOF) for each MP
*are assigned. New MPs get EFORd and WSOF from existing MPs mapped by MPExNew. Availibility factors (AF) are
*calculated from ERORd0 and WSOF0. AF is replaced by CF if CF>AF.
s1(MPEx)=( sum(HMR,EFORd0(HMR,MPEx)*NPCap0(HMR,MPEx))/sum(HMR,NPCap0(HMR,MPEx)) )$sum(HMR,NPCap0(HMR,MPEx));
EFORd0(HMR,MPEx)$(not NPCap0(HMR,MPEx))=s1(MPEx);
EFORd0(HMR,MPNew)=sum(MPEx,EFORd0(HMR,MPEx)*MPExNew(MPEx,MPNew));
s1(MPEx)=( sum(HMR,WSOF0(HMR,MPEx)*NPCap0(HMR,MPEx))/sum(HMR,NPCap0(HMR,MPEx)) )$sum(HMR,NPCap0(HMR,MPEx));
WSOF0(HMR,MPEx)$(not NPCap0(HMR,MPEx))=s1(MPEx);
WSOF0(HMR,MPNew)=sum(MPEx,WSOF0(HMR,MPEx)*MPExNew(MPEx,MPNew));
AF(Yr,HMR,MP,Sea,TB)=(1-WSOF0(HMR,MP)/100)*(1-EFORd0(HMR,MP)/100);
AF(Yr,HMR,MP,Sea,TB)$(MPEx(MP) or MPNoDsp(MP))=max(AF(Yr,HMR,MP,Sea,TB),CF(Yr,HMR,MP,Sea,TB));

*Extrapolate fuel costs (maybe come back here and make the following change: 1. don't work with FCo, 2. extrapolate
*within FC0). New MPs that use SNL FC get it from existing counterparts.
FCo(Yr,HMR,MP,Sea)=FC0(HMR,MP);
*HR Fix for CHPs
FCo(Yr,HMR,MP,Sea)$(MPFuel(MP,'NG') and MPTech(MP,'CHP')) = FC0(HMR,MP)* NGHRScalar;
FCo(Yr,HMR,MP,Sea)$(MPFuel(MP,'Coal') and MPTech(MP,'CHP')) = FC0(HMR,MP)* CoalHRScalar;
FCo(Yr,HMR,MPNew,Sea)=sum(MPEx, FCo(Yr,HMR,MPex,Sea)*MPExNew(MPEx,MPNew)$(not sum(Fuel,MPFC(MPNew,Fuel))) );
**adjust FuelCosts for natural gas for sensitivity
*FCo(Yr,HMR,MP,Sea)$(MPFuel(MP,'NG') and SimYr(Yr)>=2022) = FCo(Yr,HMR,MP,Sea)*(0.8);
*--------------------------------------------------
*END use existing MP parameters to pupulate parameters for new MPs.

*==============================CAPITAL COSTS===================================*
*Initialize Capital Cost Scaling Parameters
CapCostScl(YrFull,HMR,MP)     = 1;
CapCostNRELScl(YrFull,MP)     = 1;
CapCostAnnScl(YrFull,MP)      = 1;

*Adjust capital costs for Yr0

*Only have capital costs for new plants
CapCost0AEO(YrFull,HMR,MP)$(MPNew(MP))       = CapCost0AEO(YrFull,HMR,MP);
CapCost0NatAEO(YrFull,MP)$(MPNew(MP))        = CapCost0NatAEO(YrFull,MP);

*Set National CapCost for Yr0 equal to CapCost0
CapCost0NatAEO('Yr0',MP)$(MPNew(MP))         = CapCost0('CA',MP); !! Because CapCost0 is not differentiated by HMR

*Regional Capital Cost Scale using 2020
CapCostHMScl(HMR,MP)$(MPNew(MP) and CapCost0NatAEO('Yr1',MP) <> 0)
                                           = CapCost0AEO('Yr1',HMR,MP) / CapCost0NatAEO('Yr1',MP);

CapCost0AEO('Yr0',HMR,MP)$(MPNew(MP))      = CapCost0(HMR,MP) * CapCostHMScl(HMR,MP);


*Annual AEO Capital Cost Decline Scale using CA as reference (since CapCost0 is the same for all HMR's)
CapCostAnnScl(YrFull,MP)$(MPNew(MP) and CapCost0('CA',MP) <> 0)
                                           = CapCost0NatAEO(YrFull,MP) / CapCost0('CA',MP);

*NREL Capital Cost Scalar
CapCostNRELScl(YrFull,MP)$(MPNew(MP) and (MPFuel(MP,'Wind') or MPFuel(MP,'Solar') or MPTech(MP,'Battery') or MPCCS(MP)) and SimYrFull(YrFull)>=2022 and CapCostNREL(YrFull,MP,'Moderate') < (CapCostAnnScl(YrFull,MP)*CapCost0NatAEO(YrFull,MP)) and (CapCostNREL(YrFull,MP,'Moderate')<>0))
                          = CapCostNREL(YrFull,MP,'Moderate') / CapCost0NatAEO(YrFull,MP);

*Raise or lower renewable capital costs to NREL Conservative of Advanced estimates
$ifthen.capcost %UI_CapCostRE%==Low
CapCostNRELScl(YrFull,MP)$(MPNew(MP) and (MPFuel(MP,'Wind') or MPFuel(MP,'Solar') or MPTech(MP,'Battery') or MPCCS(MP)) and SimYrFull(YrFull)>=2022 and CapCostNREL(YrFull,MP,'Advanced') <(CapCostAnnScl(YrFull,MP)*CapCost0NatAEO(YrFull,MP)) and (CapCostNREL(YrFull,MP,'Moderate')<>0))
                          = CapCostNREL(YrFull,MP,'Advanced') / CapCost0NatAEO(YrFull,MP);
$elseif.capcost %UI_CapCostRE%==High
CapCostNRELScl(YrFull,MP)$(MPNew(MP) and (MPFuel(MP,'Wind') or MPFuel(MP,'Solar') or MPTech(MP,'Battery') or MPCCS(MP)) and SimYrFull(YrFull)>=2022 and CapCostNREL(YrFull,MP,'Conservative') > (CapCostAnnScl(YrFull,MP)*CapCost0NatAEO(YrFull,MP)) and (CapCostNREL(YrFull,MP,'Moderate')<>0))
                          = CapCostNREL(YrFull,MP,'Conservative') / CapCost0NatAEO(YrFull,MP);
$endif.capcost



*LPCal and LPBLCal have AEO CapCosts
$ifthen.aeo %UI_ScenKnl% == LPCal
*Regional HMR, MP Scaling   * Annual AEO Scale
CapCostScl(YrFull,HMR,MP) = CapCostHMScl(HMR,MP) * CapCostAnnScl(YrFull,MP) ;
display CapCostScl;
$elseif.aeo %UI_ScenKnl% == LPBLCal
*Regional HMR, MP Scaling   * Annual AEO Scale
CapCostScl(YrFull,HMR,MP) = CapCostHMScl(HMR,MP) * CapCostAnnScl(YrFull,MP) ;
display CapCostScl;
$elseif.aeo %UI_ScenKnl% == BLAEO
*Regional HMR, MP Scaling   * Annual AEO Scale
CapCostScl(YrFull,HMR,MP) = CapCostHMScl(HMR,MP) * CapCostAnnScl(YrFull,MP) ;
display CapCostScl;
$else.aeo
*Scale Capital Costs as NREL by default
CapCostScl(YrFull,HMR,MP)$(CapCostNRELScl(YrFull,MP) <> 1 )  = CapCostNRELScl(YrFull,MP)*CapCostHMScl(HMR,MP);
CapCostScl(YrFull,HMR,MP)$(CapCostNRELScl(YrFull,MP) = 1  )  = CapCostAnnScl(YrFull,MP)*CapCostHMScl(HMR,MP);
display CapCostScl;
$endif.aeo

*create scaled/declining overnight capital costs
CapCostOvernight(YrFull,HMR,MP)$(not MPReplaceable(MP) and MPNew(MP))= CapCost0(HMR,MP) * CapCostScl(YrFull,HMR,MP);
CapCostOvernight(YrFull,HMR,MP)$(MPReplaceable(MP) and MPNew(MP))= CapCost0(HMR,MP);

*CapCost is the annualized version of overnight capital cost (CapCost0).
CapCost(YrFull,HMR,MP)=betaRt * CapCostOvernight(YrFull,HMR,MP)/(1-(1+betaRt)**(-InvPlnHrzn));

*display CapCostScl CapCost;
*display CapCostNRELScl CapCost CapCost0AEO CapCostNREL CapCost0NatAEO CapCostOvernight;
*$stop

*CapCost at lower interest rate for capital costs.
$ifthen.utilityREloans %UI_LoanCEPP% ==  Yes
         CapCost(YrFull,HMR,'New Solar')$(SimYrFull(YrFull) >= 2022) = betaRtRE * CapCostOvernight(YrFull,HMR,'New Solar')/(1-(1+betaRtRE)**(-InvPlnHrzn));;
         CapCost(YrFull,HMR,'New Wind')$(SimYrFull(YrFull) >= 2022) = betaRtRE * CapCostOvernight(YrFull,HMR,'New Wind')/(1-(1+betaRtRE)**(-InvPlnHrzn));;
$endif.utilityREloans

*Cost coefficients that increase in Gen, NPCap, or Trans add nice convexity to the model.
VOMCoeff(Yr,HMR,MP)=VOM(Yr,HMR,MP);
VOMSlpDen=smax((HMR,MP,Sea,TB),NPCap0(HMR,MP)*AF('Yr0',HMR,MP,Sea,TB)*Hrs(Sea,Tb));
VOMSlp=%UI_slpV%/VOMSlpDen;
FOMCoeff(Yr,HMR,MP)=FOM(Yr,HMR,MP);
FOMSlpDen=smax((HMR,MP),NPCap0(HMR,MP));
FOMSlp=0{2*1E-3/FOMSlpDen};
TransCostCoeff(HMRe,HMRi)=TransCost(HMRe,HMRi);
TransCostSlpDen=smax((HMRe,HMRi,Sea,TB),TransCap0(HMRe,HMRi)*Hrs(Sea,Tb));
TransCostSlp=%UI_slpT%/TransCostSlpDen;
CapCostCoeff(Yr,HMR,MP)=CapCost(Yr,HMR,MP);
CapCostSlp(MP)=0;
CapCostSlp('New Solar')=%UI_slpCC%/30;
CapCostSlp('New Onshore Wind')=%UI_slpCC%/30;
CapCostSlp('New Offshore Wind')=%UI_slpCC%/30;

*SimYr is weighted to account for interpolation between SimYrs.
SimYrWgtKnl(YrFull,Yr)$(ord(Yr)<card(Yr) and SimYrFull(YrFull)>=SimYr(Yr) and SimYrFull(YrFull)<SimYr(Yr+1))=
        1-(SimYrFull(YrFull)-SimYr(Yr))/(SimYr(Yr+1)-SimYr(Yr));
SimYrWgtKnl(YrFull,Yr)$(ord(Yr)>1 and SimYrFull(YrFull)>SimYr(Yr-1) and SimYrFull(YrFull)<=SimYr(Yr))=
        (SimYrFull(YrFull)-SimYr(Yr-1))/(SimYr(Yr)-SimYr(Yr-1));
SimYrWgt(Yr)=sum(YrFull,SimYrWgtKnl(YrFull,Yr)*beta(YrFull));


*replace with 1
*SimYrWgtKnl(YrFull,Yr) = 1;
*SimYrWgt(Yr)=beta(Yr);

*display
*SimYrWgt
*factor
*beta
*SimYrWgtKnl
*;

*Scale down CCS storage options
Parameter CCSStorMaxScaled(Yr,HMR,StepCCS,TypeCCS), tot(Yr);
$ifthen.ccs %UI_LimCCSStorage% == Yes
CCSStorMaxScaled(Yr,HMR,StepCCS,TypeCCS) = CCSStorMax(HMR,StepCCS,TypeCCS)*(100000000*2**((SimYr(Yr)-2030)/5))/sum((HMRdup,StepCCSdup,TypeCCSdup),CCSStorMax(HMRdup,StepCCSdup,TypeCCSdup));
tot(Yr) = (100000000*2**((SimYr(Yr)-2030)/5));
$else.ccs
CCSStorMaxScaled(Yr,HMR,StepCCS,TypeCCS) = CCSStorMax(HMR,StepCCS,TypeCCS);
$endif.ccs

*CCSCapMax(Yr,"New Steam Coal CCS90") = 5;
*CCSCapMax(Yr,"New NGCC CCS") = 20;
CCSCapMax(Yr,MP) = 0;

parameter
NGPriceHH(YrFull,AEOscen)   Natural Gas Spot Price at Henry Hub [2020 dollars per million Btu]
AEONGPrcRat(YrFull,PPAR,AEOscen)   AEO2021 reference case  to AEO2023 Scenario Scalars
NGPriceRat(YrFull,HMR)      Ratio of AEO side case NG prices to reference case NG prices
;

$call gdxxrw.exe "NGPrices.xlsx" par=NGPriceHH rdim=1 cdim=1 rng=sheet1!C3:L34
$gdxin "NGPrices.gdx"
$load NGPriceHH
$gdxin

$call gdxxrw.exe "AEONGPrcRat.xlsx" par=AEONGPrcRat rdim = 3 rng=AEONGPrcRat!A2:D1117
$gdxin "AEONGPrcRat.gdx"
$load AEONGPrcRat
$gdxin

display AEONGPrcRat;


NGPriceRat(YrFull,HMR)=1;

display NGPriceRat;

*option to change natural gas prices
$ifthen.NGprc %UI_NGPrc%==Low2022

         NGPriceRat(YrFull,HMR)$(SimYrFull(YrFull) = 2022) = 2;
         NGPriceRat(YrFull,HMR)$(SimYrFull(YrFull) >= 2026) = (NGPriceHH(YrFull,'HO') +
                                                                 ( ((NGPriceHH(YrFull,'REF') + NGPriceHH(YrFull,'LO'))/2)
                                                                         -NGPriceHH(YrFull,'REF'))
                                                          )/NGPriceHH(YrFull,'REF');
         NGPriceRat(YrFull,HMR)$(SimYrFull(YrFull) >= 2022 and SimYrFull(YrFull) <= 2026) =
                 NGPriceRat('Yr3',HMR) + (NGPriceRat('Yr7',HMR) - NGPriceRat('Yr3',HMR))
                                         *(SimYrFull(YrFull)-SimYrFull('Yr3'))/(SimYrFull('Yr7')-SimYrFull('Yr3'));

$elseif.NGprc %UI_NGPrc%==High2022

         NGPriceRat(YrFull,HMR)$(SimYrFull(YrFull) = 2022) = 2;
         NGPriceRat(YrFull,HMR)$(SimYrFull(YrFull) >= 2026) = (NGPriceHH(YrFull,'LO') +
                                                                 ( ((NGPriceHH(YrFull,'REF') + NGPriceHH(YrFull,'LO'))/2)
                                                                         -NGPriceHH(YrFull,'REF'))
                                                          )/NGPriceHH(YrFull,'REF');
         NGPriceRat(YrFull,HMR)$(SimYrFull(YrFull) >= 2022 and SimYrFull(YrFull) <= 2026) =
                 NGPriceRat('Yr3',HMR) + (NGPriceRat('Yr7',HMR) - NGPriceRat('Yr3',HMR))
                                         *(SimYrFull(YrFull)-SimYrFull('Yr3'))/(SimYrFull('Yr7')-SimYrFull('Yr3'));

$elseif.NGprc %UI_NGPrc%==BL2022

         NGPriceRat(YrFull,HMR)$(SimYrFull(YrFull) = 2022) = 2;
         NGPriceRat(YrFull,HMR)$(SimYrFull(YrFull) >= 2026) = ((NGPriceHH(YrFull,'REF') + NGPriceHH(YrFull,'LO'))/2)/NGPriceHH(YrFull,'REF');
         NGPriceRat(YrFull,HMR)$(SimYrFull(YrFull) >= 2022 and SimYrFull(YrFull) <= 2026) =
                 NGPriceRat('Yr3',HMR) + (NGPriceRat('Yr7',HMR) - NGPriceRat('Yr3',HMR))
                                         *(SimYrFull(YrFull)-SimYrFull('Yr3'))/(SimYrFull('Yr7')-SimYrFull('Yr3'));
$elseif.NGprc %UI_NGPrc%==High2023
$set UI_CensusPPAR Yes
$include SetPPARMapping
map_all_YPH(Yr,PPAR,HMR) = map_tmp_YPH(Yr,PPAR,HMR);
$set UI_CensusPPAR No
NGPriceRat(YrFull,HMR) = sum(PPAR,AEONGPrcRat(YrFull,PPAR,'lowogs')*sum(Yr,map_all_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)));

$elseif.NGprc %UI_NGPrc%==Low2023
$set UI_CensusPPAR Yes
$include SetPPARMapping
map_all_YPH(Yr,PPAR,HMR) = map_tmp_YPH(Yr,PPAR,HMR);
$set UI_CensusPPAR No
NGPriceRat(YrFull,HMR) = sum(PPAR,AEONGPrcRat(YrFull,PPAR,'highogs')*sum(Yr,map_all_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)));

$elseif.NGprc %UI_NGPrc%==BLIRA2023
$set UI_CensusPPAR Yes
$include SetPPARMapping
map_all_YPH(Yr,PPAR,HMR) = map_tmp_YPH(Yr,PPAR,HMR);
$set UI_CensusPPAR No
NGPriceRat(YrFull,HMR) = sum(PPAR,AEONGPrcRat(YrFull,PPAR,'ref2023')*sum(Yr,map_all_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)));

$elseif.NGprc %UI_NGPrc%==BL2023
$set UI_CensusPPAR Yes
$include SetPPARMapping
map_all_YPH(Yr,PPAR,HMR) = map_tmp_YPH(Yr,PPAR,HMR);
$set UI_CensusPPAR No
NGPriceRat(YrFull,HMR) = sum(PPAR,AEONGPrcRat(YrFull,PPAR,'noIRA')*sum(Yr,map_all_YPH(Yr,PPAR,HMR)*SimYrWgtKnl(YrFull,Yr)));
$endif.NGprc

display FCiRef;
FCiRef(Yr,HMR,'NG') = FCiRef(Yr,HMR,'NG')*NGPriceRat(Yr,HMR);
display FCiRef NGPriceRat;

parameter CapCostPrint(Yr,MP);
CapCostPrint(Yr,MP)$(MPNew(MP) and (MPFuel(MP,'Wind') or MPFuel(MP,'Solar') or MPTech(MP,'Battery') or MPCCS(MP))) = CapCost(Yr,'NY',MP);
