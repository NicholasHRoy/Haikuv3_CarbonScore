* Interpolation
*-------------------------------------------------------------------------------------------------------------
Scalars
        x0 Base year to calculate slope
        x1 Reference year
        y0 value in base year
        y1 value in reference year;
* Standard interpolation function
$macro linear_interpolation(year_labels,y0,y1,x1,x0) y0 + (year_labels - x0) * (y1 - y0) / (x1 - x0)
* Function to restrict year ranges (x0,x1]
$macro year_range(year_labels,x0,x1) x0 < year_labels and year_labels <= x1

* Options files
*-------------------------------------------------------------------------------------------------------------
file PATHopt /'path.opt'/;
PATHopt.nr=2; !!numbers appear in scientific notation
PATHopt.nd=1; !!number of decimals
PATHopt.nj=2; !!numbers are left justified
PATHopt.nz=1E-7; !!zero threshold
$macro mPATHopt(time,tol,cm) \
        put PATHopt; \
        put 'time_limit ' time ';' /; \
        put 'convergence_tolerance ' tol ';' /; \
*        put 'crash_nbchange_limit 20;' /; \
*        put 'lemke_start first;' /; \
        put 'crash_searchtype line;' /; \
        put 'crash_iteration_limit 1E3;' /; \
*        put 'output 0;' /; \
        put 'output_maximum_zero_listing 0;' /; \
*        put 'crash_perturb 0;' /; \
        put 'output_factorization_singularities 0'  ';' /; \
*        put 'output_warnings 1;' /; \
*        put 'crash_method pnewton;' /; \
        put 'crash_method ' cm ';' /; \
        put 'proximal_perturbation 0;' /; \
*        put 'major_iteration_limit 10;' /; \
        put 'output_minor_iterations_frequency 500' /; \
*        put 'minor_iteration_limit 6E3' /; \
        putclose;

file CPLEXopt /'cplex.opt'/;
$macro mCPLEXopt(tol) \
        put CPLEXopt; \
        put 'epopt ' tol /; \
*        put 'PreInd 0' /; \
*        put 'LPMethod 1' /; \
*        put 'FeasOpt 1' /; \
        put 'NPCapEq.FeasPref             0' /; \
        put 'SupDemEq.FeasPref            0' /; \
        put 'RsvMrgEq.FeasPref            0' /; \
        put 'GenLeCapEq.FeasPref          0' /; \
        put 'NoDspEq.FeasPref             0' /; \
        put 'CalVOMEq.FeasPref            0' /; \
        put 'CalGenNatFuel.FeasPref       0' /; \
        put 'CalGenNat1Fuel.FeasPref      0' /; \
        put 'iis=1'                          /; \
        put 'conflictalg = 1'                /; \
        put 'conflictdisplay = 2'            /; \ 
        putclose;

file CONVERTDopt /'ConvertD.opt'/; !! for calls to PATH with option ConvertD
file dummy; !! for put_utility commands
