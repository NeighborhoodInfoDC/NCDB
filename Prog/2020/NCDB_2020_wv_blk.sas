/**************************************************************************
 Program:  NCDB_2020_wv_blk.sas
 Library:  NCDB
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  09/03/21
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  25

 Description:  Calculate NCDB variables from Census 2020 
 PL94-171 data.

 West Virginia.

 Modifications:

**************************************************************************/

%include "\\sas1\dcdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )
%DCData_lib( Census, local=n )

%let revisions = Fix variable names.;

%Ncdb_2020_blk_mac( wv )

