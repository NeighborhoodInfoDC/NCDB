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

** 2010 census tract data **;

data Tracts_2010;

  set 
    Census.response_rates_2010_dc_tr20
    Census.response_rates_2010_md_tr20
    Census.response_rates_2010_va_tr20
    Census.response_rates_2010_wv_tr20;
  by geo2020;
  
  keep state county geo2020 fsrr2010; 

run;

proc summary data=Tracts_2010;
  by county; 
  var fsrr2010;
  output out=Tracts_2010_min_max min= max= /autoname;
run;

** 2020 census tract data **;

data Tracts_2020;

  set 
    Census.response_rates_2020_dc_tr20
    Census.response_rates_2020_md_tr20
    Census.response_rates_2020_va_tr20
    Census.response_rates_2020_wv_tr20;
  by geo2020;
  
  keep state county geo2020 crrall crrint; 

run;

proc summary data=Tracts_2020;
  by county; 
  var crrall crrint;
  output out=Tracts_2020_min_max min= max= /autoname;
run;

** Combine aggregated tract and county data for county tables **;

data Tables_county;

  merge
    Census.response_rates_2020_was20_regcnt (drop=geo_id metro20 resp_date in=in1)
    Census.response_rates_2010_was20_regcnt (drop=geo_id metro20 sumlevel state fips_county)
    Tracts_2010_min_max (keep=county fsrr2010:)
    Tracts_2020_min_max (keep=county crrall: crrint:);
  by county;
  
  if in1;
  
run;

proc sort data=Tables_county;
  by descending crrall;
run;


** Make tables **;

options nodate nonumber;
options orientation=portrait;

%fdate()

ods listing close;
ods rtf file="&_dcdata_default_path\NCDB\Prog\2020\Response_rate_tables.rtf" style=Styles.Rtf_arial_9pt;

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

title2 ' ';


title3 "County-level census self-response rates, Washington, DC MSA - 2010 and 2020";

proc tabulate data=Tables_county format=comma10.1 noseps missing;
  class county /order=data;
  var crrall crrint fsrr2010 crrall_min crrall_max;
  table 
    /** Rows **/
    county=' ',
    /** Columns **/
    sum='2020 \line Self-response rates (%)' * (
      crrall='Overall' 
      crrint='Internet only' 
    )
    sum='2010 \line Self-response rates (%)' * (
      fsrr2010='Overall' 
    )
    sum='2020 \line Tract\~self-response ranges (%)' * (
      crrall_max='Highest tract' 
      crrall_min='Lowest tract' 
    )
  ;
run;

ods rtf close;
ods listing;

title2;
footnote1;


** Export data for mapping **;

data Maps;

  merge Tracts_2020 (in=in1) Tracts_2010 (drop=state county);
  by Geo2020;
  
  if in1;
  
  keep State County Geo2020 crrall crrint fsrr2010;
  
  format Geo2020 ;
  
run;

proc univariate data=Maps plots;
  var crrall;
run;

filename fexport "&_dcdata_default_path\NCDB\Maps\2020\Response_rate_2010_2020.csv" lrecl=1000;

proc export data=Maps
    outfile=fexport
    dbms=csv replace;

run;

filename fexport clear;

