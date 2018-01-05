/**************************************************************************
 Program:  Ncdb_2010_sum_all_test_comp.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/21/12
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Compare new and old Ncdb summary files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Ncdb )

libname Save 'D:\DCData\Libraries\Ncdb\Data\Save';


/** Macro Compare - Start Definition **/

%macro Compare( ds, id );

  proc compare base=Save.&ds compare=Ncdb.&ds novalues /*maxprint=(50,32000)*/
      method=percent criterion=1.0;
    id &id;
  run;

%mend Compare;

/** End Macro Definition **/

%Compare( Ncdb_sum_2010_anc02, Anc2002 )
%Compare( Ncdb_sum_2010_city, City )
%Compare( Ncdb_sum_2010_cltr00, Cluster_tr2000 )
%Compare( Ncdb_sum_2010_eor, Eor )
%Compare( Ncdb_sum_2010_psa04, Psa2004 )
%Compare( Ncdb_sum_2010_tr00, Geo2000 )
%Compare( Ncdb_sum_2010_wd02, Ward2002 )
%Compare( Ncdb_sum_2010_zip, Zip )
