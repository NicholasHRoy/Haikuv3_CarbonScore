$setglobal UI_CAScen BAU

Sets
    YrFull 'Full years' /Yr0*Yr26/
    VehClass 'Vehicle classes' / LDV, MDV, HDV, Bus /
    VehType 'Vehicle types' /Elec, PHEV, Gas, Diesel, CNG, Hydrogen/
    Scenario /BAU, SP/;

Scalars
    DataYr /2019/
    SimYrLast;

Alias (YrFull, Yr)
Alias (VehType, VehTypedup);

Parameters
    SimYrFull(YrFull)
    SimYr(Yr)
    Veh0(YrFull, VehClass, VehType, Scenario) "Initial vehicle stock"
    VehSales0(YrFull, VehClass, VehType, Scenario) "Initial sales"
    VehRtr0(YrFull, VehClass, VehType, Scenario) "Initial retirement"
    VMT0(YrFull, VehClass, Scenario) "Initial VMT"
    MPV0(YrFull, VehClass, Scenario) "Initial amount a vehicle in vehicle class is driven from scoping plan[miles/vehicle]"
    MPV(YrFull, VehClass, VehType) "Adjusted MPV based on elasticity from elasticity [miles/vehicle]"
    MPGe(YrFull, VehClass, VehType) "Average miles per gallon equivalent of fleet"
    VMTDemand(YrFull, VehClass) "Vehicle Miles Traveled (VMT) demand by vehicle class"
    PlnVehRtr(Yr,VehClass,VehType) "Total vehicles that have retired since the previous model year [vehicles]"
    SalesPct(YrFull,VehClass,VehType) "Percent of each vehile type of vehicles sold [%]";

$GDXIN Transport_230125.gdx
$LOAD Veh0 VehRtr0 VehSales0 VMT0

SimYrFull('Yr0') = DataYr;
loop(YrFull, SimYrFull(YrFull + 1) = SimYrFull(YrFull) + 1);
SimYr(Yr) = SimYrFull(Yr);
SimYrLast = smax(Yr, SimYr(Yr));


Variable
    VehiclePurchases "All vehicles purchased";

Positive Variable
    Veh(YrFull, VehClass, VehType) "Vehicle stock"
    VehSales(YrFull, VehClass, VehType) "Vehicle sales"
    VehRtr(YrFull, VehClass, VehType) "Vehicle retirement"
    VMT(YrFull,VehClass,VehType);

Equations
    Obj
    Sales(YrFull, VehClass, VehType) "Equation for vehicle sales"
    VMTDemandEq(YrFull, VehClass) "Equation for VMT Demand"
    VehSalesCompEq(YrFull,VehClass,VehType)
    VehClassMTEq(YrFull,VehClass)
    VMTEq(YrFull,VehClass,VehType);

* Assign imported parameter values to the respective parameters
Veh.l(YrFull, VehClass, VehType)      = Veh0(YrFull, VehClass, VehType, '%UI_CAScen%');
VehRtr.fx(YrFull, VehClass, VehType)  = VehRtr0(YrFull, VehClass, VehType, '%UI_CAScen%');
VehSales.l(YrFull, VehClass, VehType) = VehSales0(YrFull, VehClass, VehType, '%UI_CAScen%');

*Calculate intitial miles per vehicle based on vehicle class
MPV0(YrFull,VehClass, Scenario)$(sum(VehType,Veh0(YrFull,VehClass,VehType,'%UI_CAScen%')) > 0) =
    VMT0(YrFull,VehClass, Scenario)/sum(VehType,Veh0(YrFull,VehClass,VehType,Scenario));


*Assign initial MPV to be the same for all vehicle types
MPV(YrFull,VehClass,VehType)$(Veh0(YrFull,VehClass,VehType,'%UI_CAScen%') > 0) = MPV0(YrFull,VehClass,'%UI_CAScen%');

* Calculate VMTDemand based on imported parameters
VMTDemand(YrFull, VehClass) = sum(VehType, MPV(YrFull, VehClass, VehType) * Veh.l(YrFull, VehClass, VehType));


SalesPct(YrFull,VehClass,VehType)$(sum(VehTypedup,( Veh.l(YrFull,VehClass,VehTypedup) - Veh.l(YrFull - 1,VehClass,VehTypedup) - VehRtr.l(YrFull,VehClass,VehTypedup) ) ) > 0 ) =
    (Veh.l(YrFull,VehClass,VehType) - Veh.l(YrFull - 1,VehClass,VehType) - VehRtr.l(YrFull,VehClass,VehType))/
    sum(VehTypedup,( Veh.l(YrFull,VehClass,VehTypedup) - Veh.l(YrFull - 1,VehClass,VehTypedup) - VehRtr.l(YrFull,VehClass,VehTypedup) ) );
                              
display VMTDemand, VehRtr0, MPV;

Obj..
    VehiclePurchases
    -sum((YrFull, VehClass, VehType), VehSales(YrFull, VehClass, VehType))
    =e= 0;
Sales(YrFull, VehClass, VehType)..
    Veh(YrFull, VehClass, VehType)
    - Veh(YrFull - 1, VehClass, VehType)
    - VehSales(YrFull, VehClass, VehType)
    - VehRtr(YrFull, VehClass, VehType)
    =e= 0;
    
*VMT by vehicle type    
VMTEq(YrFull,VehClass,VehType)..
    VMT(YrFull,VehClass,VehType)
    - MPV(YrFull,VehClass,VehType)* Veh(YrFull,VehClass,VehType)
    =e= 0; 

*Vehicle Class Travel Demand
VehClassMTEq(YrFull,VehClass)..
    VMTDemand(YrFull,VehClass)
    - sum(VehType,VMT(YrFull,VehClass,VehType))
    =e= 0;
         
VehSalesCompEq(YrFull,VehClass,VehType)..
    sum(VehTypedup,VehSales(YrFull,VehClass,VehTypedup))*SalesPct(YrFull,VehClass,VehType)
    - VehSales(YrFull,VehClass,VehType)
    =e= 0;

Model VehicleStockTurnoverModel / Obj, Sales, VMTEq, VehClassMTEq, VehSalesCompEq/;

Solve VehicleStockTurnoverModel using lp minimizing VehiclePurchases;

Parameter
testvehsales(YrFull,VehClass,VehType)
testveh(YrFull,VehClass,VehType);

testveh(YrFull,VehClass,VehType) = Veh0(YrFull,VehClass,VehType,'%UI_CAScen%') - Veh.l(YrFull,VehClass,VehType);
testvehsales(YrFull,VehClass,VehType) = VehSales0(YrFull,VehClass,VehType,'%UI_CAScen%') - VehSales.l(YrFull,VehClass,VehType);

Display testveh, testvehsales, Veh.L, VehSales.L, VMTDemand;
