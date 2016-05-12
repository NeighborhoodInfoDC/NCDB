/**************************************************************************
 Program:  Register_ncdb_sum.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/20/08
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  TEMPORARY PROGRAM.
   Register all Ncdb_sum_* files to Alpha.
   (Will be unnecessary after Ncdb_sum_tr00.sas and Ncdb_sum_all.sas
   are finished.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

** Start submitting commands to remote server **;

rsubmit;

/** Macro Register - Start Definition **/

%macro Register( data, creator=Ncdb_sum_all.sas, restrictions=None, revisions=%str(Added PopGroupQuarters_: vars.) );

  %Dc_update_meta_file(
    ds_lib=Ncdb,
    ds_name=&data,
    creator_process=&creator,
    restrictions=&restrictions,
    revisions=&revisions
  )

%mend Register;

/** End Macro Definition **/


%Register( NCDB_SUM_TR00, creator=Ncdb_sum_tr00.sas, restrictions=Confidential )
%Register( NCDB_SUM_ANC02 )
%Register( NCDB_SUM_CITY )
%Register( NCDB_SUM_CLTR00 )
%Register( NCDB_SUM_CNB03 )
%Register( NCDB_SUM_CTA03 )
%Register( NCDB_SUM_EOR )
%Register( NCDB_SUM_PSA04 )
%Register( NCDB_SUM_WD02 )
%Register( NCDB_SUM_ZIP )

run;

endrsubmit;

** End submitting commands to remote server **;

run;

signoff;
