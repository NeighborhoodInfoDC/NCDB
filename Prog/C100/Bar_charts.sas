/**************************************************************************
 Program:  Bar_charts.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/12/12
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Bar charts for key indicators.
 C/100 presentation.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Ncdb )

/** Macro ChgVar - Start Definition **/

%macro ChgVar( var, chgvar= );

  %if &chgvar = %then %let chgvar = Chg&var;

  &chgvar._2000_2010 = &var._2010 - &var._2000;

%mend ChgVar;

/** End Macro Definition **/

/** Macro hbar - Start Definition **/

%macro hbar( geovar, vars );

  %local i v;

  %let i = 1;
  %let v = %scan( &vars, &i );

  %do %until ( &v = );

    hbar &geovar /sumvar=&v descending;

    %let i = %eval( &i + 1 );
    %let v = %scan( &vars, &i );

  %end;

%mend hbar;

/** End Macro Definition **/

/** Macro Charts_geo - Start Definition **/

%macro Charts_geo( geo, geovar );

  data C100_&geo;

    set Ncdb.C100_&geo;
    
    %if %upcase(&geo) = CLTR00 %then %do;
      ** Remove non-cluster areas **;
      where cluster_tr2000 ~= '99';
    %end;
    
    ChgAvgHHSize_2000_2010 = AvgHHSize_2010 - AvgHHSize_2000;
    
    ChgPersonsPerSqMi_2000_2010 = PersonsPerSqMi_2010 - PersonsPerSqMi_2000;
    
    ChgTotPop_2000_2010 = TotPop_2010 - TotPop_2000;
    
    label
      AvgHHSize_2010 = "Average HH size, 2010"
      ChgAvgHHSize_2000_2010 = "Change in average HH size, 2000-2010"
      PersonsPerSqMi_2010 = "Persons per sq. mile, 2010"
      ChgPersonsPerSqMi_2000_2010 = "Change in persons per sq. mile, 2010"
      ChgTotPop_2000_2010 = "Change in total population, 2000-2010"
    ;
    
    %ChgVar( PopAge_0_17 )
    %ChgVar( PopAge_18_34 )
    %ChgVar( PopAge_35_64 )
    %ChgVar( PopAge_65 )
    
    label
      ChgPopAge_0_17_2000_2010 = "Change in population 0-17 years old, 2000-2010"
      ChgPopAge_18_34_2000_2010 = "Change in population 18-34 years old, 2000-2010"
      ChgPopAge_35_64_2000_2010 = "Change in population 35-64 years old, 2000-2010"
      ChgPopAge_65_2000_2010 = "Change in population 65+ years old, 2000-2010";
    
    %ChgVar( PopBlackNonHispBridge, chgvar=ChgPopBlackNonHispBr )
    %ChgVar( PopWhiteNonHispBridge, chgvar=ChgPopWhiteNonHispBr )
    %ChgVar( PopHisp )
    %ChgVar( PopAsianPINonHispBridge, chgvar=ChgPopAsianPINonHispBr )
    
    label
      ChgPopBlackNonHispBr_2000_2010 = "Change in non-Hisp. Black population, 2000-2010"
      ChgPopWhiteNonHispBr_2000_2010 = "Change in non-Hisp. White population, 2000-2010" 
      ChgPopHisp_2000_2010 = "Change in Hispanic population, 2000-2010"
      ChgPopAsianPINonHispBr_2000_2010 = "Change in non-Hisp. Asian/PI population, 2000-2010";
    
    PctHomeowner_2000 = 100 * NumOwnerOccupiedHsgUnits_2000 / ( NumOwnerOccupiedHsgUnits_2000 + NumRenterOccupiedHsgUnits_2000 );
    PctHomeowner_2010 = 100 * NumOwnerOccupiedHsgUnits_2010 / ( NumOwnerOccupiedHsgUnits_2010 + NumRenterOccupiedHsgUnits_2010 );

    %ChgVar( PctHomeowner )
    
    label
      PctHomeowner_2000 = "Homeownership rate (%), 2000"
      PctHomeowner_2010 = "Homeonwership rate (%), 2010"
      ChgPctHomeowner_2000_2010 = "Change in homeownership rate, 2000-2010";
    
  run;

/*
  proc print data=C100_&geo;
    id &geovar;
    var AvgHHSize_2000 AvgHHSize_2010 ChgAvgHHSize_2000_2010 
        PersonsPerSqMi_2000 PersonsPerSqMi_2010 ChgPersonsPerSqMi_2000_2010;
  run;
*/

  proc chart data=C100_&geo;
    %hbar( geovar=&geovar, 
           vars=ChgTotPop_2000_2010 AvgHHSize_2010 ChgAvgHHSize_2000_2010 PersonsPerSqMi_2010 ChgPersonsPerSqMi_2000_2010 
                ChgPopAge_0_17_2000_2010 ChgPopAge_18_34_2000_2010 ChgPopAge_35_64_2000_2010 ChgPopAge_65_2000_2010
                ChgPopBlackNonHispBr_2000_2010 ChgPopWhiteNonHispBr_2000_2010 PopHisp_2000 ChgPopHisp_2000_2010 ChgPopAsianPINonHispBr_2000_2010
                PctHomeowner_2010 ChgPctHomeowner_2000_2010 
          )
  run;

%mend Charts_geo;

/** End Macro Definition **/

ods rtf file="D:\DCData\Libraries\NCDB\Prog\C100\Bar_charts.rtf" style=Rtf /*Styles.Rtf_arial_9pt*/;

%Charts_geo( wd02, ward2002 )
%Charts_geo( cltr00, cluster_tr2000 )

ods rtf close;

ENDSAS;

** Export cluster data for mapping **;

data C100_cltr00_map;

  set C100_cltr00;
  
  keep cluster_tr2000 ChgTotPop_2000_2010 AvgHHSize_2010 ChgAvgHHSize_2000_2010 PersonsPerSqMi_2010 ChgPersonsPerSqMi_2000_2010 
       ChgPopAge_0_17_2000_2010 ChgPopAge_18_34_2000_2010 ChgPopAge_35_64_2000_2010 ChgPopAge_65_2000_2010
       ChgPopBlackNonHispBr_2000_2010 ChgPopWhiteNonHispBr_2000_2010 ChgPopHisp_2000_2010 ChgPopAsianPINonHispBr_2000_2010
       PctHomeowner_2010 ChgPctHomeowner_2000_2010;
                
run;

filename fexport "D:\DCData\Libraries\NCDB\Maps\C100_cltr00_map.csv" lrecl=5000;

proc export data=C100_cltr00_map
    outfile=fexport
    dbms=csv replace;

run;

filename fexport clear;

