/**************************************************************************
 Program:  Pop_2000_cltr00.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/28/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Calculate population totals for 2000 from NCDB data.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )
%DCData_lib( General )

rsubmit;

/*
data Pop_2000_tr;

  set Ncdb.Ncdb_lf_2000_dc (keep=geo2000 trctpop0);

run;
*/

%Transform_geo_data(
    dat_ds_name=Ncdb.Ncdb_lf_2000_dc,
    dat_org_geo=geo2000,
    dat_count_vars=trctpop0,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_tr00_cltr00,
    wgt_org_geo=geo2000,
    wgt_new_geo=cluster_tr2000,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=Pop_2000_cltr00,
    out_ds_label=Population for neighborhood clusters (2000),
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=Y,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )

run;

proc download status=no
  data=Pop_2000_cltr00 
  out=Ncdb.Pop_2000_cltr00;

run;

endrsubmit;

signoff;
