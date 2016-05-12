/**************************************************************************
 Program:  Ncdb_sum_vp12.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   S. Zhang
 Created:  12/18/12
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all 2012 Voting Precinct summary files from NCDB tract summary file.

 Modifications:
  12/18/2012 SXZ Create summary files for 2012 Voting Precincts 
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

rsubmit;

%Create_summary_from_tracts( 
  geo=voterpre2012,  

  /** Change to N for testing, Y for final batch mode run **/
  register=Y,
  
  /** Update with information on latest file revision **/
  revisions=%str(New file.),

  lib=Ncdb,
  data_pre=Ncdb_sum, 
  data_label=%str(NCDB summary, DC),
  count_vars=agg: /****SHOULD CALCULATE AVERAGES avg:****/ Children: elderly: females: grossrent: males: num: 
    people: persons: pop: poverty: tot:, 
  prop_vars=median:, 
  calc_vars=, 
  calc_vars_labels=,
  creator_process=Ncdb_sum_vp12.sas,
  restrictions=None,
  TRACT_YR=2000
)

run;

endrsubmit;

signoff;
