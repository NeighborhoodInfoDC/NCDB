/**************************************************************************
 Program:  Ncdb_2010_was15.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/09/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Create 2010 NCDB data set for Washington region (2015 def).

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Ncdb )

data Ncdb_2010_was15_blk;

  set 
    Ncdb.Ncdb_2010_dc_blk 
    Ncdb.Ncdb_2010_md_blk 
    Ncdb.Ncdb_2010_va_blk 
    Ncdb.Ncdb_2010_wv_blk;
  
  where put( ucounty, $ctym15f. ) ~= '';
  
  %metro15( ucounty )
  
  format state $fstname. ucounty $cnty15f.;
  
run;

proc summary data=Ncdb_2010_was15_blk nway;
  class geo2010;
  id metro15 ucounty state;
  var adult: child: old: max: min: mr: non: occ: shr: tot: trct: vac:;
  output sum=
    out=Ncdb_2010_was15 (drop=_freq_ _type_);
run;

%Finalize_data_set( 
  /** Finalize data set parameters **/
  data=Ncdb_2010_was15,
  out=Ncdb_2010_was15,
  outlib=Ncdb,
  label='NCDB, 2010, Washington region (2015)',
  sortby=geo2010,
  /** Metadata parameters **/
  restrictions=None,
  revisions=%str(Added 65+ variables),
  /** File info parameters **/
  contents=Y,
  printobs=0,
  freqvars=state ucounty metro15
)

