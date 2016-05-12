/**************************************************************************
 Program:  Register_NCDB_2010_dc_blk.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/28/11
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Register NCDB_2010_dc_blk file with metadata system.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( NCDB )

** Start submitting commands to remote server **;

rsubmit;

%Dc_update_meta_file(
  ds_lib=NCDB,
  ds_name=NCDB_2010_dc_blk,
  creator_process=NCDB_2010_dc_blk.sas,
  restrictions=None,
  revisions=%str(Added VoterPre2012.)
)

run;

endrsubmit;

** End submitting commands to remote server **;

run;

signoff;
