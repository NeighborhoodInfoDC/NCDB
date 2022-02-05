/**************************************************************************
 Program:  Pop_hsng_analysis.sas
 Library:  NCDB
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  02/05/22
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  21
 
 Description:  Analysis of population and housing change.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )

%** Urban chart colors **;

%global URBAN_COLOR_CYAN URBAN_COLOR_GOLD URBAN_COLOR_BLACK URBAN_COLOR_GRAY
        URBAN_COLOR_MAGENTA URBAN_COLOR_GREEN;

%let URBAN_COLOR_CYAN = "cx1696d2";
%let URBAN_COLOR_GOLD = "cxfdbf11";
%let URBAN_COLOR_BLACK = "cx000000";
%let URBAN_COLOR_GRAY = "cxd2d2d2";
%let URBAN_COLOR_MAGENTA = "cxec008b";
%let URBAN_COLOR_GREEN = "cx558748";

data A;

  merge 
    Ncdb.Ncdb_sum_2010_cl17
    Ncdb.Ncdb_sum_2020_cl17;
  by cluster2017;
  
  where cluster2017 not in ( "40", "41", "42", "43", "44", "45", "46" );
  
  totpop_chg = totpop_2020 - totpop_2010;
  totpop_pctchg = totpop_chg / totpop_2010;
  
  popblacknonhispbridge_chg = popblacknonhispbridge_2020 - popblacknonhispbridge_2010;
  popblacknonhispbridge_pctchg = popblacknonhispbridge_chg / popblacknonhispbridge_2010;
  
  numhsgunits_chg = numhsgunits_2020 - numhsgunits_2010;
  numhsgunits_pctchg = numhsgunits_chg / numhsgunits_2010; 
  
  format totpop_chg popblacknonhispbridge_chg numhsgunits_chg comma8.0;

  format totpop_pctchg popblacknonhispbridge_pctchg numhsgunits_pctchg percent8.1;
  
  keep cluster2017 totpop_: popblacknonhispbridge_: numhsgunits_: ;

run;

%File_info( data=A, contents=N, printobs=50 )


***********************************************************************************************
**** Create charts;

%let lastfignumber = 0;

title1;
footnote1;

options nodate nonumber nocenter nobyline;
options orientation=portrait leftmargin=0.5in rightmargin=0.5in topmargin=0.5in bottommargin=0.5in;

proc template;
 define style mystyle;
 parent=styles.Pearl;
    class graphwalls / 
          frameborder=off;
    class graphbackground / 
          color=white;
 end;
run;

ods graphics on / imagemap /*width=6in height=4in*/ border=off;

***ods pdf file="&_dcdata_default_path\NCDB\Prog\2020\Pop_hsng_analysis.pdf" style=mystyle notoc nogfootnote;
ods html file="&_dcdata_default_path\NCDB\Prog\2020\Pop_hsng_analysis.html";

ods graphics on / height=10in width=8in;

/** Macro hbar - Start Definition **/

%macro hbar( var=, title= );

  proc sort data=A;
    by descending &var;
  run;

  proc sgplot data=A noautolegend;
    hbarparm category=cluster2017 response=&var / nooutline fillattrs=(color=&URBAN_COLOR_CYAN) datalabel;
    yaxis display=(nolabel) valueattrs=(color=black family="Lato" size=8pt);
    xaxis display=none /*display=(nolabel) valueattrs=(color=black family="Lato" size=9pt)*/;
    title2 justify=left color=black font="Lato" height=10pt "&title, 2010–20";
  run;

%mend hbar;

/** End Macro Definition **/

%hbar( var=totpop_chg, title=Change in total population )
%hbar( var=totpop_pctchg, title=Pct. change in total population )

%hbar( var=popblacknonhispbridge_chg, title=Change in Black population )
%hbar( var=popblacknonhispbridge_pctchg, title=Pct. change in Black population )

%hbar( var=numhsgunits_chg, title=Change in housing units )
%hbar( var=numhsgunits_pctchg, title=Pct. change in housing units )


proc sgplot data=A noautolegend uniform=scale;
  where cluster2017 not in ( "27" );
  scatter x=numhsgunits_chg y=popblacknonhispbridge_chg / 
    markerattrs=(color=&URBAN_COLOR_CYAN symbol=CircleFilled)
    /*tip=(numhsgunits_chg popblacknonhispbridge_chg cluster2017) tipformat=(comma8.0 comma8.0 $clus17a.)*/
    /*datalabel datalabelattrs=(color=black family="Lato")*/;
  reg x=numhsgunits_chg y=popblacknonhispbridge_chg / lineattrs=(color=&URBAN_COLOR_CYAN pattern=2);
  xaxis /*display=(nolabel)*/ valueattrs=(color=black family="Lato");
  yaxis /*display=(nolabel)*/ valueattrs=(color=black family="Lato");
  format numhsgunits_chg popblacknonhispbridge_chg comma8.0;
  label 
    numhsgunits_chg = "Change in number of housing units" 
    popblacknonhispbridge_chg = "Change in NH Black population";
  /*title1 justify=left color=&URBAN_COLOR_CYAN font="Lato" height=9pt "FIGURE %upcase(&appendix).#BYVAL1";*/
  title2 justify=left color=black font="Lato" height=10pt "Black population change vs. Housing unit change, 2010–20";
run;

proc sgplot data=A noautolegend uniform=scale;
  where cluster2017 not in ( "27" );
  scatter x=numhsgunits_pctchg y=popblacknonhispbridge_pctchg / 
    markerattrs=(color=&URBAN_COLOR_CYAN symbol=CircleFilled) 
    /*datalabel datalabelattrs=(color=black family="Lato")*/;
  reg x=numhsgunits_pctchg y=popblacknonhispbridge_pctchg / lineattrs=(color=&URBAN_COLOR_CYAN pattern=2);
  xaxis /*display=(nolabel)*/ valueattrs=(color=black family="Lato");
  yaxis /*display=(nolabel)*/ valueattrs=(color=black family="Lato");
  format numhsgunits_chg popblacknonhispbridge_chg comma8.0;
  label 
    numhsgunits_pctchg = "Pct. change in number of housing units" 
    popblacknonhispbridge_pctchg = "Pct. change in NH Black population";
  /*title1 justify=left color=&URBAN_COLOR_CYAN font="Lato" height=9pt "FIGURE %upcase(&appendix).#BYVAL1";*/
  title2 justify=left color=black font="Lato" height=10pt "Pct. Black population change vs. Pct. housing unit change, 2010–20";
run;

***ods pdf close;
ods html close;
