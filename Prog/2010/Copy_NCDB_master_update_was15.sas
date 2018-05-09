/**************************************************************************
 Program:  Copy_NCDB_master_update_was15.sas
 Library:  NCDB
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  05/08/18
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Copy NCDB_master_update data set.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )

libname ncdb2010 "D:\Data\NCDB2010";


** Copy NCDB data for Washington metro area 2015 **;

data NCDB_master_update;

  set Ncdb2010.NCDB_master_update22615;
  
  where put( ucounty, $ctym15f. ) = "47900";

run;

%Finalize_data_set( 
  data=NCDB_master_update,
  out=NCDB_master_update,
  outlib=NCDB,
  label="NCDB 2010 master update",
  sortby=Geo2010,
  revisions=%str(New file.),
  printobs=0
)

