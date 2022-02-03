/**************************************************************************
 Program:  MSA_comp_2010_2020.sas
 Library:  NCDB
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  09/27/21
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  28
 
 Description:  Compare population changes from 2010 to 2020 for 
 10 mid-large MSAs. 

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )

%let MID_LARGE_METROS = "12060", "14460", "19100", "26420", "33100", "37980", "38060", "41860", "42660", "47900";

** Read 2010 county data for calculating MSA pop totals **;

filename inf "&_dcdata_r_path\NCDB\Raw\DECENNIALPL2010.P1_2021-09-27T172100\DECENNIALPL2010.P1_data_with_overlays_2021-09-27T172051.csv";

data Cnty2010;

  infile inf dsd firstobs=2;
  
  length geo_id $ 40 metro20 ucounty $ 5 skip $ 80 xPop2010 $ 40;
  
  input geo_id @;
  
  ucounty = substr( geo_id, 10, 5 );
  
  metro20 = put( ucounty, $ctym20f_all. );
  
  if metro20 in ( &MID_LARGE_METROS ) then do;
  
    input 
      skip
      xPop2010;
    
    ** scan() needed to filter out (r?????) appended to populations for some MA counties **;
    
    Pop2010 = input( scan( xPop2010, 1 ), 20. );
    
    output;
    
  end;
  else do;
  
    input ;
    
  end;
  
  keep ucounty Metro20 Pop2010;
  
  format Metro20 $msaname20_short.;

run;

filename inf clear;


%Dup_check(
  data=Cnty2010,
  by=ucounty,
  id=Metro20 pop2010,
  out=_dup_check,
  listdups=Y,
  count=dup_check_count,
  quiet=N,
  debug=N
)

proc sort data=Cnty2010 nodupkey;
  by metro20 ucounty; 
run;

proc print data=Cnty2010;

run;

** Summarize by metro **;

proc summary data=Cnty2010 nway;
  class Metro20;
  var Pop2010;
  output out=MSA2010 sum=;
run;


** Read 2020 MSA population totals **;

filename inf "&_dcdata_r_path\NCDB\Raw\productDownload_2021-09-25T142528\DECENNIALPL2020.P1_data_with_overlays_2021-09-25T142518.csv";

data MSA2020;

  infile inf dsd firstobs=2;
  
  length geo_id $ 40 metro20 $ 5 skip $ 80 xPop2020 $ 40;
  
  input geo_id @;
  
  metro20 = substr( geo_id, 10, 5 );

  if metro20 in ( &MID_LARGE_METROS ) then do;
  
    input 
      skip
      xPop2020;
    
    Pop2020 = input( xPop2020, 20. );
    
    output;
    
  end;
  else do;
  
    input ;
    
  end;
  
  keep Metro20 Pop2020;
  
  format Metro20 $msaname20_short.;

run;

filename inf clear;

proc sort data=MSA2020;
  by Metro20;
run;


** Combine 2010 and 2020 data **;

data MSA;

  merge MSA2010 MSA2020;
  by Metro20;
  
  Pct_chg = 100 * ( ( Pop2020 / Pop2010 ) - 1 );
  
  drop _freq_ _type_;
  
run;

proc sort data=MSA;
  by Pct_chg;
run;


** Make table **;

options nodate nonumber;
options orientation=portrait;

%fdate()

ods listing close;
ods rtf file="&_dcdata_default_path\NCDB\Prog\2020\MSA_comp_2010_2020.rtf" style=Styles.Rtf_arial_9pt;

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

proc print noobs label;
  label 
    Metro20 = "MSA"
    Pop2010 = "Population, 2010"
    Pop2020 = "Population, 2020"
    Pct_chg = "Percent change";
  format Pop2010 Pop2020 comma12.0 Pct_chg comma12.1;
  title2 ' ';
  title3 "Population for 10 Mid-Large MSAs, 2010 - 2020";
run;

ods rtf close;
ods listing;

title2;
footnote1;


