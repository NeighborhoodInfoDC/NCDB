/**************************************************************************
 Jenner compatibility bundle for NCDB (NeighborhoodInfoDC)

 Source program:  Prog/C100/C100_pop_ward.sas
 What it does:    Population by ward. Defines the %ChgVar macro, which
                  computes 1980->1990, 1990->2000, and 2000->2010 change
                  variables for a decennial population measure, then
                  applies it to total population and the bridged-race
                  population counts and prints the results by ward.

 The %ChgVar macro and the PROC PRINT reports below are kept exactly as
 written in the repo. The only substitution is the input: the repo reads
 Ncdb.C100_wd02, which is not part of this repo, so this bundle supplies a
 small synthetic C100_wd02 (eight DC wards) with the decennial population
 columns %ChgVar consumes.
**************************************************************************/

/* Synthetic ward-level decennial population input (illustrative values) */

data C100_wd02;
  input ward2002
        TotPop_1980 TotPop_1990 TotPop_2000 TotPop_2010
        PopBlackNonHispBridge_1980 PopBlackNonHispBridge_1990
          PopBlackNonHispBridge_2000 PopBlackNonHispBridge_2010
        PopWhiteNonHispBridge_1980 PopWhiteNonHispBridge_1990
          PopWhiteNonHispBridge_2000 PopWhiteNonHispBridge_2010
        PopHisp_1980 PopHisp_1990 PopHisp_2000 PopHisp_2010
        PopAsianPINonHispBridge_1980 PopAsianPINonHispBridge_1990
          PopAsianPINonHispBridge_2000 PopAsianPINonHispBridge_2010;
  datalines;
1 79000 78000 72000 75000 20000 18000 15000 13000 50000 52000 50000 55000 5000 4500 4000 3500 2000 2200 2000 2100
2 72000 71000 70000 78000 30000 25000 20000 16000 35000 38000 42000 52000 3000 3200 3300 3600 2500 3000 3200 4000
3 78000 79000 78000 80000 5000 4500 4200 4000 68000 69000 67000 68000 2000 2500 3000 4000 2000 2500 2800 3500
4 82000 84000 76000 78000 55000 52000 45000 40000 20000 22000 20000 22000 3000 5000 6000 9000 1500 2000 2500 3000
5 79000 78000 71000 74000 60000 58000 50000 44000 12000 12500 13000 18000 3500 4500 4500 6000 1000 1200 1500 2000
6 78000 76000 72000 76000 40000 36000 30000 24000 30000 32000 33000 42000 2500 3000 3500 4500 2000 2500 2800 3200
7 72000 71000 70000 72000 65000 63000 60000 55000 3000 3200 3500 6000 2000 2200 2500 4000 500 700 900 1200
8 74000 72000 70000 74000 68000 65000 62000 57000 2500 2700 3000 5000 1500 1800 2200 3500 500 600 800 1100
;
run;

/** Macro ChgVar - Start Definition **/

%macro ChgVar( var, chgvar= );

  %if &chgvar = %then %let chgvar = Chg&var;

  &chgvar._1980_1990 = &var._1990 - &var._1980;
  &chgvar._1990_2000 = &var._2000 - &var._1990;
  &chgvar._2000_2010 = &var._2010 - &var._2000;

%mend ChgVar;

/** End Macro Definition **/

data Pop_ward;

  set C100_wd02;
  
  %ChgVar( TotPop )

  %ChgVar( PopBlackNonHispBridge, chgvar=ChgPopBlackNonHispBr )
  %ChgVar( PopWhiteNonHispBridge, chgvar=ChgPopWhiteNonHispBr )
  %ChgVar( PopHisp )
  %ChgVar( PopAsianPINonHispBridge, chgvar=ChgPopAsianPINonHispBr )

run;

proc print data=Pop_ward;
  id ward2002;
  var totpop_1980 totpop_1990 totpop_2000 totpop_2010;

run;

proc print data=Pop_ward;
  id ward2002;
  var chgtotpop_: ;
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
