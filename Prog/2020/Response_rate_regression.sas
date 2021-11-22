/**************************************************************************
 Program:  Response_rate_regression.sas
 Library:  NCDB
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  11/21/21
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  28
 
 Description: Regression on 2020 census response rates. 

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )
%DCData_lib( Census )


** Get list of County Codes **;

proc sql noprint;
  select county format=$5. into :county_list separated by ' ' from Census.response_rates_2020_was20_regcnt
  order by county;
quit;

%put county_list=&county_list;

/** Macro Make_county_vars - Start Definition **/

%macro Make_county_vars( county_list= );

  %local i v;

  %let i = 1;
  %let v = %scan( &county_list, &i, %str( ) );

  %do %until ( &v = );

    if ucounty = "&v" then Cnty_&v = 1; else Cnty_&v = 0;
    label Cnty_&v = "%sysfunc( putc( &v, $cnty20f. ) )";

    %let i = %eval( &i + 1 );
    %let v = %scan( &county_list, &i, %str( ) );

  %end;

%mend Make_county_vars;

/** End Macro Definition **/



** 2020 census tract data **;

data Resp_rate_Tracts_2020;

  set 
    Census.response_rates_2020_dc_tr20
    Census.response_rates_2020_md_tr20
    Census.response_rates_2020_va_tr20
    Census.response_rates_2020_wv_tr20;
  by geo2020;
  
  keep geo2020 crrall crrint; 

run;


** Merge with 2020 census data to create regression data set **;

data Reg;

  merge
    Ncdb.Ncdb_2020_was20 
      (keep=geo2020 ucounty state tothsun2 trctpop2 adult2n child2n shrnh: shrhsp2n shr2d
       in=in1)
    Resp_rate_tracts_2020;
  by geo2020;
  
  if in1;
  
  Adult2 = adult2n / trctpop2;
  Child2 = child2n / trctpop2;
  
  Shrnhw2 = shrnhw2n / shr2d;
  Shrnhb2 = shrnhb2n / shr2d;
  Shrnhi2 = shrnhi2n / shr2d;
  Shrnha2 = shrnha2n / shr2d;
  Shrnho2 = shrnho2n / shr2d;
  Shrhsp2 = shrhsp2n / shr2d;
  
  label
    adult2 = 'Proportion adults'
    child2 = 'Proportion children'
    shrnhw2 = 'Proportion NH White'
    shrnhb2 = 'Proportion NH Black'
    shrnhi2='Proportion NH Am. Indian'
    shrnha2='Proportion NH Asian/PI'
    shrnho2='Proportion NH Other races'
    shrhsp2='Proportion Hispanic/Latinx'
  ;
  
  shr_check = sum( shrnhw2, shrnhb2, shrnhi2, shrnha2, shrnho2, shrhsp2 );
  
  %Make_county_vars( county_list=&county_list )
  
  Crrall_prop = crrall / 100;
  Crrint_prop = crrint / 100;
  
  label 
    crrall_prop = "Overall self-response rate (proportion)"
    crrint_prop = "Internet-only self-response rate (proportion)"
    ;
  
  drop shrnhr2 shrnhh2;
  
run;

%File_info( data=reg, printobs=0 )


** Run regressions **;

options nodate;
options orientation=portrait;

%fdate()

ods listing close;
ods rtf file="&_dcdata_default_path\NCDB\Prog\2020\Response_rate_regression.rtf" style=Styles.Rtf_arial_9pt bodytitle;

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";

title2 ' ';

title3 "Tract-level census self-response rates, Washington, DC MSA - 2020";
footnote2 height=9pt "Note: Omitted variables are proportion adult, proportion NH White, and Charles County, MD.";

proc reg data=Reg;
  model crrall_prop crrint_prop = tothsun2 child2 shrhsp2 shrnhi2 shrnha2 shrnhb2 shrnho2;
  model crrall_prop crrint_prop = tothsun2 child2 shrhsp2 shrnhi2 shrnha2 shrnhb2 shrnho2 Cnty_11001--Cnty_24009 Cnty_24021--Cnty_54037;
run;

ods rtf close;
ods listing;

title2;
footnote1;

