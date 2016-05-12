/**************************************************************************
 Program:  C100_pop_ward_2012.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/09/12
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Population by ward. Updated for 2012 wards.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Ncdb )

/** Macro ChgVar - Start Definition **/

%macro ChgVar( var, chgvar= );

  %if &chgvar = %then %let chgvar = Chg&var;

  &chgvar._1980_1990 = &var._1990 - &var._1980;
  &chgvar._1990_2000 = &var._2000 - &var._1990;
  &chgvar._2000_2010 = &var._2010 - &var._2000;

%mend ChgVar;

/** End Macro Definition **/

data Pop_ward;

  merge 
    Ncdb.Ncdb_sum_wd12 
      (keep=ward2012 TotPop: PopBlackNonHispBridge: PopWhiteNonHispBridge: PopHisp: PopAsianPINonHispBridge:)
    Ncdb.Ncdb_sum_2010_wd12 
      (keep=ward2012 TotPop: PopBlackNonHispBridge: PopWhiteNonHispBridge: PopHisp: PopAsianPINonHispBridge:);
  by Ward2012;
  
  %ChgVar( TotPop )

  %ChgVar( PopBlackNonHispBridge, chgvar=ChgPopBlackNonHispBr )
  %ChgVar( PopWhiteNonHispBridge, chgvar=ChgPopWhiteNonHispBr )
  %ChgVar( PopHisp )
  %ChgVar( PopAsianPINonHispBridge, chgvar=ChgPopAsianPINonHispBr )

run;

proc print data=Pop_ward;
  id ward2012;
  var totpop_1980 totpop_1990 totpop_2000 totpop_2010;

run;

proc print data=Pop_ward;
  id ward2012;
  var chgtotpop_: ;
  *var chgtotpop_1980_1990 chgtotpop_19902000 chgtotpop_2010;

run;

proc print data=Pop_ward;
  id ward2012;
  var ChgPopBlack: ;
run;

proc print data=Pop_ward;
  id ward2012;
  var ChgPopWhite: ;
run;

proc print data=Pop_ward;
  id ward2012;
  var ChgPopHisp: ;
run;

proc print data=Pop_ward;
  id ward2012;
  var ChgPopAsianPI: ;
run;

