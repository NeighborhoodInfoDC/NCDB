/**************************************************************************
 Program:  Ncdb_2020_was20.sas
 Library:  Ncdb
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  9/19/21
 Version:  SAS 9.4
 Environment:  Windows
 GitHub issue:  32
 
 Description:  Create 2020 NCDB data set for Washington region (2020 def).

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Ncdb )

data Ncdb_2020_was20_blk;

  set 
    Ncdb.Ncdb_2020_dc_blk 
    Ncdb.Ncdb_2020_md_blk 
    Ncdb.Ncdb_2020_va_blk 
    Ncdb.Ncdb_2020_wv_blk;
  
  where put( ucounty, $ctym20f. ) ~= '';
  
  %metro20( ucounty )
  
  format state $fstname. ucounty $cnty20f.;
  
run;

proc summary data=Ncdb_2020_was20_blk nway;
  class geo2020;
  id metro20 ucounty state;
  var adult: child: /*old:*/ max: min: mr: non: occ: shr: tot: trct: vac:;
  output sum=
    out=Ncdb_2020_was20 (drop=_freq_ _type_);
run;

%Finalize_data_set( 
  /** Finalize data set parameters **/
  data=Ncdb_2020_was20,
  out=Ncdb_2020_was20,
  outlib=Ncdb,
  label='NCDB, 2020, Washington region (2020)',
  sortby=geo2020,
  /** Metadata parameters **/
  restrictions=None,
  revisions=%str(New file.),
  /** File info parameters **/
  contents=Y,
  printobs=0,
  freqvars=state ucounty metro20
)

