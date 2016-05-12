/**************************************************************************
 Program:  Ncdb_sum_all.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/19/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all summary files from NCDB tract summary file.

 Modifications:
  11/21/08 PAT Removed AVG variables from summary file (need to calculate).
  09/09/12 PAT Updated for new 2010/2012 geos.
               New weights for Median vars.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

rsubmit;

%Create_all_summary_from_tracts( 

  /** Change to N for testing, Y for final batch mode run **/
  register=Y,
  
  /** Update with information on latest file revision **/
  revisions=%str(Updated for new 2010/2012 geos. New weights for Median vars.),

  lib=Ncdb,
  data_pre=Ncdb_sum, 
  data_label=%str(NCDB summary, DC),
  count_vars=agg: /****SHOULD CALCULATE AVERAGES avg:****/ Children: elderly: females: grossrent: males: num: 
    people: persons: pop: poverty: tot:, 
  prop_vars=median:, 
  calc_vars=, 
  calc_vars_labels=,
  creator_process=Ncdb_sum_all.sas,
  restrictions=None
)

run;

endrsubmit;

signoff;
