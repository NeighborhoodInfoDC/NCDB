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

proc print;
run;
