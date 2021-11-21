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

data Tracts_2010;

  set 
    Census.response_rates_2010_dc_tr20
    Census.response_rates_2010_md_tr20
    Census.response_rates_2010_va_tr20
    Census.response_rates_2010_wv_tr20;
  by geo2020;
  
  keep county geo2020 fsrr2010; 

run;

proc summary data=Tracts_2010;
  by county; 
  var fsrr2010;
  output out=Tracts_2010_min_max min= max= /autoname;
run;

proc print data=Tracts_2010_min_max;
run;


data Tracts_2020;

  set 
    Census.response_rates_2020_dc_tr20
    Census.response_rates_2020_md_tr20
    Census.response_rates_2020_va_tr20
    Census.response_rates_2020_wv_tr20;
  by geo2020;
  
  keep county geo2020 crrall crrint; 

run;

proc summary data=Tracts_2020;
  by county; 
  var crrall crrint;
  output out=Tracts_2020_min_max min= max= /autoname;
run;

proc print data=Tracts_2020_min_max;
run;

data Tables;

  merge
    Census.response_rates_2020_was20_regcnt (drop=geo_id metro20 resp_date in=in1)
    Census.response_rates_2010_was20_regcnt (drop=geo_id metro20)
    Tracts_2010_min_max (keep=county fsrr2010:)
    Tracts_2020_min_max (keep=county crrall: crrint:);
  by county;
  
  if in1;
  
run;

proc print;
run;
