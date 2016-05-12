/**************************************************************************
 Program:  Ncdb_2010_2000_was03.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/27/12
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Create view for 2010 NCDB file for Washington region
(2003 def).

 NOTE: THIS DOESN'T WORK BECAUSE THE BLOCK TO TRACT MACRO IS ONLY FOR DC.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

** Start submitting commands to remote server **;

rsubmit;

data Ncdb_2010_2000_was03_blk;

  set 
    Ncdb.Ncdb_2010_dc_blk 
    Ncdb.Ncdb_2010_md_blk 
    Ncdb.Ncdb_2010_va_blk 
    Ncdb.Ncdb_2010_wv_blk;
  
  where put( ucounty, $ctym03f. ) ~= '';
  
  %metro03( ucounty )
  
  /*
  length MSA03 $ 5;
  
  msa03 = put( ucounty, $ctym03f. );
  
  label msa03 = 'Metropolitan statistical area (2003)';
  */
  
  format ucounty $cnty03f.;
  
  %Block10_to_tr00()

run;

proc summary data=Ncdb_2010_2000_was03_blk nway;
  class geo2000;
  id metro03 ucounty state;
  var adult: child: max: min: mr: non: occ: shr: tot: trct: vac:;
  output sum=
    out=Ncdb.Ncdb_2010_2000_was03 
          (label='NCDB, 2010 (2000 tracts), Washington region (2003)' sortedby=geo2000 drop=_freq_ _type_);
run;

%File_info( data=Ncdb.Ncdb_2010_2000_was03, freqvars=state ucounty metro03 )

run;

endrsubmit;

** End submitting commands to remote server **;

signoff;
