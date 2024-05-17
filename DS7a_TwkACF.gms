* Tweak capacity and availibility factors to make calibration feasible. This is intended to make only small differences
* and mostly only in the years before the end of the construction lag. The variables ACFGen and ACFRsv put together CFs
* and AFs appropriately for non-dispatchables and non-retireables separately for generation and reserve.
*-----------------------------------------------------------------------------------------------------------------------

Parameters
        GenNoDspMinFuel(Yr,HMR,Fuel) minimum possible generation by non-dispatchables by fuel type [GWh]
        GenNoDspRtrMinFuel(Yr,HMR,Fuel) "minimum possible generation by non-dispatchables/retirables by fuel type [GWh]"
        GenRtrPCapMinFuel(Yr,HMR,Fuel) "minimum possible generation by retirables due to planned capacity by fuel type [GWh]"
        ACFadj1(Yr,HMR,Fuel)
        ACFadj1Full(Yr,HMR,Fuel)
        GenMaxFuel(Yr,HMR,Fuel) maximum possible generation by fuel type [GWh]
        ACFadj2(Yr,HMR,Fuel)
        GenNewNoDsp(Yr,HMR,FuelNoDspNewCap) generation required of new MPs that are grouped by Fuel with only non-dispatchables [GWh]
        GNNDPrvLrg(Yr,HMR,FuelNoDspNewCap) largest previous occurance of GenNewNoDsp that was not treated by ACFadj1 [GWh]
        ACFadj3(Yr,HMR,MP)
;

* TWEAK #1: maximum generation = 0 and AEO generation > 0
*-------------------------------------------------------
*MA is an arbitrary HMR to move ME/Coal generation to.
GenAEOSeaFuel(Yr,'MA',Sea,'Coal')=GenAEOSeaFuel(Yr,'MA',Sea,'Coal')+GenAEOSeaFuel(Yr,'ME',Sea,'Coal');
GenAEOSeaFuel(Yr,'ME',Sea,'Coal')=0;

* TWEAK #2: minimum non-dispatchable/retireable generation > AEO generation - minimum retireable planned generation
*-------------------------------------------------------
*If minimum non-dispatchable/retireable regional annual generation by fuel type exceeds GenAEOSeaFuel then CF and AF are
*reduced to make MCP_CalGen (CalGenEq in LP) feasible.
GenNoDspRtrMinFuel(Yr,HMR,Fuel)=sum((MP,Sea,TB),
        ( NPCap.lo(Yr,HMR,MP)*OpNPCapRat(HMR,MP,Sea)*CF(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB) )
                $(MPNoDspRtrInv(MP) and CF(Yr,HMR,MP,Sea,TB) and MPFuel(MP,Fuel)) );
GenRtrPCapMinFuel(Yr,HMR,Fuel)=sum((MP,Sea,TB),
        ( NPCap.lo(Yr,HMR,MP)*OpNPCapRat(HMR,MP,Sea)*CF(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB) )
                $(not MPNoDspRtrInv(MP) and CF(Yr,HMR,MP,Sea,TB) and MPFuel(MP,Fuel)) );
ACFadj1(Yr,HMR,Fuel)$GenNoDspRtrMinFuel(Yr,HMR,Fuel)=min(0,
        ( (sum(Sea,GenAEOSeaFuel(Yr,HMR,Sea,Fuel))-GenRtrPCapMinFuel(Yr,HMR,Fuel))-GenNoDspRtrMinFuel(Yr,HMR,Fuel) )
        /GenNoDspRtrMinFuel(Yr,HMR,Fuel) )$GenNoDspRtrMinFuel(Yr,HMR,Fuel);
CF(Yr,HMR,MP,Sea,TB)$MPNoDspRtrInv(MP)=CF(Yr,HMR,MP,Sea,TB)*(1+sum(Fuel,ACFadj1(Yr,HMR,Fuel)*MPFuel(MP,Fuel)));
AF(Yr,HMR,MP,Sea,TB)$MPNoDspRtrInv(MP)=AF(Yr,HMR,MP,Sea,TB)*(1+sum(Fuel,ACFadj1(Yr,HMR,Fuel)*MPFuel(MP,Fuel)));
ACFGen(Yr,HMR,MP,Sea,TB)=CF(Yr,HMR,MP,Sea,TB)$MPNoDsp(MP)+AF(Yr,HMR,MP,Sea,TB)$(not MPNoDsp(MP));

* TWEAK #3: maximum generation < AEO generation
*-------------------------------------------------------
*If maximum regional annual generation by fuel type is less than GenAEOSeaFuel, then CF and AF are increased to make
*MCP_CalGen (CalGenEq in LP) feasible.
GenMaxFuel(Yr,HMR,Fuel)=sum((MP,Sea,TB),
        ( NPCap.up(Yr,HMR,MP)*OpNPCapRat(HMR,MP,Sea)*ACFGen(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB) )
                $(ACFGen(Yr,HMR,MP,Sea,TB) and MPFuel(MP,Fuel)) );
ACFadj2(Yr,HMR,Fuel)$GenMaxFuel(Yr,HMR,Fuel)=
        max(0, sum(Sea,GenAEOSeaFuel(Yr,HMR,Sea,Fuel))-GenMaxFuel(Yr,HMR,Fuel) )/GenMaxFuel(Yr,HMR,Fuel);

$ifthen.nuke %UI_NukeCal% == Yes
*Make the adjustment for all but Nuclear to avoid weird capacity factors for retiring Nuclear
CF(Yr,HMR,MP,Sea,TB)=CF(Yr,HMR,MP,Sea,TB)*(1+sum(Fuel,ACFadj2(Yr,HMR,Fuel)$(not FuelNuke(Fuel))*MPFuel(MP,Fuel)));
AF(Yr,HMR,MP,Sea,TB)=AF(Yr,HMR,MP,Sea,TB)*(1+sum(Fuel,ACFadj2(Yr,HMR,Fuel)$(not FuelNuke(Fuel))*MPFuel(MP,Fuel)));
$else.nuke
*apply adjustment to all including Nuclear
CF(Yr,HMR,MP,Sea,TB)=CF(Yr,HMR,MP,Sea,TB)*(1+sum(Fuel,ACFadj2(Yr,HMR,Fuel)*MPFuel(MP,Fuel)));
AF(Yr,HMR,MP,Sea,TB)=AF(Yr,HMR,MP,Sea,TB)*(1+sum(Fuel,ACFadj2(Yr,HMR,Fuel)*MPFuel(MP,Fuel)));
$endif.nuke

* TWEAK #4: non-retireable/dispatchable MPs with AEO generation falling over time
*-------------------------------------------------------
*For fuel types that are composed entirely of non-retireable/dispatchable MPs and include a new MP (Hydro, Wind, Solar,
*Geo as of 180821), calibration will be infeasible if GenAEO falls over time, which it does at least for Hydro in
*Missouri in the 180913 data. To make calibration feasible, CF and AF are reduced appropriately.
GenNewNoDsp(Yr,HMR,FuelNoDspNewCap)=max(0, sum(Sea,GenAEOSeaFuel(Yr,HMR,Sea,FuelNoDspNewCap))
        -sum((MPNoDsp(MPEx),Sea,TB),
        ( NPCap.lo(Yr,HMR,MPEx)*OpNPCapRat(HMR,MPEx,Sea)*CF(Yr,HMR,MPEx,Sea,TB)*Hrs(Sea,TB) )
        $(CF(Yr,HMR,MPEx,Sea,TB) and MPFuel(MPEx,FuelNoDspNewCap)) ) );
GNNDPrvLrg(Yr,HMR,FuelNoDspNewCap)=0;
loop(Yr, GNNDPrvLrg(Yr,HMR,FuelNoDspNewCap)=max( GNNDPrvLrg(Yr-1,HMR,FuelNoDspNewCap),
        GenNewNoDsp(Yr,HMR,FuelNoDspNewCap)$(CnstLagPast(Yr,FuelNoDspNewCap) and not ACFadj1(Yr,HMR,FuelNoDspNewCap)) ); );
ACFadj3(Yr,HMR,MPNew)=sum(FuelNoDspNewCap,
        min(1, (GenNewNoDsp(Yr,HMR,FuelNoDspNewCap)/GNNDPrvLrg(Yr,HMR,FuelNoDspNewCap))$GNNDPrvLrg(Yr,HMR,FuelNoDspNewCap) )
        *MPFuel(MPNew,FuelNoDspNewCap) );
CF(Yr,HMR,MPNew,Sea,TB)$ACFadj3(Yr,HMR,MPNew)=CF(Yr,HMR,MPNew,Sea,TB)*ACFadj3(Yr,HMR,MPNew);
AF(Yr,HMR,MPNew,Sea,TB)$ACFadj3(Yr,HMR,MPNew)=AF(Yr,HMR,MPNew,Sea,TB)*ACFadj3(Yr,HMR,MPNew);

* TWEAKs #2, #3, and #4 are all on capacity and availibility factors. They are consolidated here.
*-------------------------------------------------------
ACFGen(Yr,HMR,MP,Sea,TB)=CF(Yr,HMR,MP,Sea,TB)$MPNoDsp(MP)+AF(Yr,HMR,MP,Sea,TB)$(not MPNoDsp(MP));
ACFRsv(Yr,HMR,MP,Sea,TB)=CF(Yr,HMR,MP,Sea,TB)$MPNoRsv(MP)+AF(Yr,HMR,MP,Sea,TB)$(not MPNoRsv(MP));

* TWEAK #5: maximum capacity < AEO generation*(1+reserve margin)
*-------------------------------------------------------
*It is possible that AEO generation is achievable, but that maximum capacity reserves are not sufficient to satisfy the
*reserve margin. The reserve margin is reduced as necessary to make calibration feasible.
RsvMrg(Yr,RsvRg)=min(RsvMrg(Yr,RsvRg), smin((Sea,TB),
        sum((HMR,MP), OpNPCapRat(HMR,MP,Sea)*NPCap.up(Yr,HMR,MP)$map_RsvRg(HMR,RsvRg)*ACFRsv(Yr,HMR,MP,Sea,TB) )
        / ( sum(HMR, sum(Sector,Cons0(Yr,HMR,Sector)*SeaPctAnn(Yr,HMR,Sea,Sector)*TBpctSea(Yr,HMR,Sea,TB,Sector))$map_RsvRg(HMR,RsvRg) /Hrs(Sea,TB) ) )-1 ))

display$(not SrpsDsp)
        GenNoDspRtrMinFuel, ACFadj1, GenMaxFuel, ACFadj2, GenNewNoDsp, GNNDPrvLrg, ACFadj3
        Hrs, OpNPCapRat, CF, AF, ACFGen, ACFRsv, SimYrWgtKnl, SimYrWgt, RsvMrg
;

*Temporary for debugging LP calibration 190904.
Parameters
        GenNoDspMinFuel_postadj(Yr,HMR,Fuel) past-adjustment minimum possible generation by non-dispatchables by fuel type [GWh]
        GenMaxFuel_postadj(Yr,HMR,Fuel) post-adjustment maximum possible generation by fuel type [GWh]
        ACFadj1_postadj(Yr,HMR,Fuel)
;

GenNoDspMinFuel_postadj(Yr,HMR,Fuel)=sum((MPNoDsp(MP),Sea,TB),
        ( NPCap.lo(Yr,HMR,MP)*OpNPCapRat(HMR,MP,Sea)*CF(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB) )
                $(CF(Yr,HMR,MP,Sea,TB) and MPFuel(MP,Fuel)) );
ACFadj1_postadj(Yr,HMR,Fuel)$GenNoDspMinFuel_postadj(Yr,HMR,Fuel)=
        min(0, sum(Sea,GenAEOSeaFuel(Yr,HMR,Sea,Fuel))-GenNoDspMinFuel_postadj(Yr,HMR,Fuel) )/GenNoDspMinFuel_postadj(Yr,HMR,Fuel);
GenMaxFuel_postadj(Yr,HMR,Fuel)=sum((MP,Sea,TB),
        ( NPCap.up(Yr,HMR,MP)*OpNPCapRat(HMR,MP,Sea)*ACFGen(Yr,HMR,MP,Sea,TB)*Hrs(Sea,TB) )
                $(ACFGen(Yr,HMR,MP,Sea,TB) and MPFuel(MP,Fuel)) );
display$(not SrpsDsp) GenNoDspMinFuel_postadj, GenMaxFuel_postadj;
