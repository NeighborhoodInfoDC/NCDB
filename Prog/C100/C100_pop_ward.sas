/**************************************************************************
 Program:  C100_pop_ward.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/09/12
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Population by ward

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

  set Ncdb.C100_wd02;
  
  %ChgVar( TotPop )

  %ChgVar( PopBlackNonHispBridge, chgvar=ChgPopBlackNonHispBr )
  %ChgVar( PopWhiteNonHispBridge, chgvar=ChgPopWhiteNonHispBr )
  %ChgVar( PopHisp )
  %ChgVar( PopAsianPINonHispBridge, chgvar=ChgPopAsianPINonHispBr )

proc print data=Pop_ward;
  id ward2002;
  var totpop_1980 totpop_1990 totpop_2000 totpop_2010;

run;

proc print data=Pop_ward;
  id ward2002;
  var chgtotpop_: ;
  *var chgtotpop_1980_1990 chgtotpop_19902000 chgtotpop_2010;

run;

proc print data=Pop_ward;
  id ward2002;
  var ChgPopBlack: ;
run;

proc print data=Pop_ward;
  id ward2002;
  var ChgPopWhite: ;
run;

proc print data=Pop_ward;
  id ward2002;
  var ChgPopHisp: ;
run;

proc print data=Pop_ward;
  id ward2002;
  var ChgPopAsianPI: ;
run;

