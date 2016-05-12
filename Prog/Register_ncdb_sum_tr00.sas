/**************************************************************************
 Program:  Register_ncdb_sum_tr00.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/03/10
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Register Ncdb_sum_tr00 file with metadata system.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

** Start submitting commands to remote server **;

rsubmit;

%Dc_update_meta_file(
  ds_lib=Ncdb,
  ds_name=Ncdb_sum_tr00,
  creator_process=Ncdb_sum_tr00.sas,
  restrictions=Confidential,
  revisions=%str(Filled in missing variable labels. Renamed NumHsgUnitsBlt: vars (NumHsgUnitsBuilt:).)
)

run;

endrsubmit;

** End submitting commands to remote server **;

run;

signoff;
