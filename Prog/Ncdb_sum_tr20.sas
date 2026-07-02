/**************************************************************************
 Program:  Ncdb_sum_tr20.sas
 Library:  NCDB
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  07/02/26
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  54
 
 Description:  Create NCDB summary file for 2020 tracts

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )


%Transform_geo_data(
    dat_ds_name=Ncdb.Ncdb_sum_tr10,
    dat_org_geo=geo2010,
    dat_count_vars=
      agg: Children: elderly: females: grossrent: males: num: people: persons: 
      pop5: pop16: pop18: pop25: popasian: popbelow: popblack: popcivilian: 
      popemploy: popenglish: popfemale: popforeign: popgroup: pophisp: popinc: 
      popmale: popmin: popnative: popnot: popother: poppoor: popsame: popspanish: 
      poptravel: popun: popwhite: popwith: popwork: poverty: tot:,
    dat_prop_vars=median:,
    wgt_ds_name=General.Wt_tr10_tr20,
    wgt_org_geo=geo2010,
    wgt_new_geo=geo2020,
    wgt_new_geo_fmt=$geo20a.,
    wgt_id_vars=,
    wgt_count_var=popwt,
    wgt_prop_var=popwt_prop,
    out_ds_name=Ncdb_sum_tr20,
    out_ds_label=,
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N,
    mprint=Y
  )

%Finalize_data_set( 
  data=Ncdb_sum_tr20,
  out=Ncdb_sum_tr20,
  outlib=Ncdb,
  label="NCDB summary, DC, Census tract (2020)",
  sortby=geo2020,
  freqvars=geo2020,
  revisions=%str(New file.)
)


run;
