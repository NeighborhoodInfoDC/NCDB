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
  03/23/17 JD  Updated to include Bridge Park Geography (also updated to 
			   SAS1 from Alpha).
  03/16/18 RP  Updated for cluster 2017
  05/22/18 RP  Updated for Stanton Commons
  05/25/22 EB  Updated for ward 22
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Ncdb )


%Create_all_summary_from_tracts( 

  /** Change to N for testing, Y for final batch mode run **/
  register=Y,
  
  /** Update with information on latest file revision **/
  revisions=%str(Added Ward2022 geography),

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
