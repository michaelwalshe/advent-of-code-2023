%macro get(ds, var, outvar);
    data _null_;
        set &ds.(obs=1);
        call symputx("&var.", "&outvar.","G");
    run;
%mend get;
