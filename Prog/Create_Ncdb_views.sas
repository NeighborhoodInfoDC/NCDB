/**************************************************************************
 Program:  Create_Ncdb_views.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/15/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create local views for NCDB files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Ncdb )

proc sql;
  create view Ncdb.Ncdb_lf_2000_dc as
  select *
  from Ncdbsrc.Ncdb_lf_2000
  where statecd = "11"
  using libname Ncdbsrc "D:\Data\NCDB2000\Data";

quit;

run;
