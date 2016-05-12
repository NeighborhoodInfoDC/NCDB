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
  03/25/15 PAT Updated for SAS1 server.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB, local=n )

** Start submitting commands to remote server **;

%Dc_update_meta_file(
  ds_lib=NCDB,
  ds_name=NCDB_2010_dc_blk,
  creator_process=NCDB_2010_dc_blk.sas,
  restrictions=None,
  revisions=%str(Added OLD1N and OLD1.)
)

run;

