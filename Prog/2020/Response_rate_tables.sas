/**************************************************************************
 Program:  Response_rate_tables.sas
 Library:  NCDB
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  11/21/21
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  28
 
 Description:  Summary tables and data for 2010 & 2020 census response rates. 

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )
%DCData_lib( Census )

data Tracts;

  set 
    Census.response_rates_2020_dc_tr20
    Census.response_rates_2020_md_tr20
    Census.response_rates_2020_va_tr20
    Census.response_rates_2020_wv_tr20;
  by geo2020;
  
  keep county geo2020 crrall crrint; 

run;

proc summary data=Tracts;
  by county; 
  var crrall crrint;
  output out=Tract_min_max min= max= /autoname;
run;

proc print data=Tract_min_max;
run;

data Tables;

  merge
    Census.response_rates_2020_was20_regcnt (drop=geo_id metro20 resp_date in=in1)
    Tract_min_max (keep=county crr:);
  by county;
  
  if in1;
  
run;

proc print;
run;
