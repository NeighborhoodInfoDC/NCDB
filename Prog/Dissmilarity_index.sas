/**************************************************************************
 Program:  Dissmilarity_index.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/01/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Calculate dissimilarity indices for DC in 1990, 2000, 2010.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( NCDB )

title2 "Black vs. white";
%di( data=Ncdb.Ncdb_sum_tr00, varA=popblacknonhispbridge_1990, varB=popwhitenonhispbridge_1990, out=bw1990 )
%di( data=Ncdb.Ncdb_sum_tr00, varA=popblacknonhispbridge_2000, varB=popwhitenonhispbridge_2000, out=bw2000 )
%di( data=Ncdb.Ncdb_sum_2010_tr00, varA=popblacknonhispbridge_2010, varB=popwhitenonhispbridge_2010, out=bw2010 )

title2 "Black vs. Hispanic";
%di( data=Ncdb.Ncdb_sum_tr00, varA=popblacknonhispbridge_1990, varB=pophisp_1990, out=bh1990 )
%di( data=Ncdb.Ncdb_sum_tr00, varA=popblacknonhispbridge_2000, varB=pophisp_2000, out=bh2000 )
%di( data=Ncdb.Ncdb_sum_2010_tr00, varA=popblacknonhispbridge_2010, varB=pophisp_2010, out=bh2010 )

title2 "Hispanic vs. white";
%di( data=Ncdb.Ncdb_sum_tr00, varA=pophisp_1990, varB=popwhitenonhispbridge_1990, out=hw1990 )
%di( data=Ncdb.Ncdb_sum_tr00, varA=pophisp_2000, varB=popwhitenonhispbridge_2000, out=hw2000 )
%di( data=Ncdb.Ncdb_sum_2010_tr00, varA=pophisp_2010, varB=popwhitenonhispbridge_2010, out=hw2010 )

title2 "Asian vs. white";
%di( data=Ncdb.Ncdb_sum_tr00, varA=popasianpinonhispbridge_1990, varB=popwhitenonhispbridge_1990, out=aw1990 )
%di( data=Ncdb.Ncdb_sum_tr00, varA=popasianpinonhispbridge_2000, varB=popwhitenonhispbridge_2000, out=aw2000 )
%di( data=Ncdb.Ncdb_sum_2010_tr00, varA=popasianpinonhispbridge_2010, varB=popwhitenonhispbridge_2010, out=aw2010 )

title2;

data A;

  merge bw1990 bw2000 bw2010 bh1990 bh2000 bh2010 hw1990 hw2000 hw2010 aw1990 aw2000 aw2010;
  
run;

proc print data=A noobs;

run;
