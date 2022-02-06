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

/** Macro hbar - Start Definition **/

%macro hbar( var=, title= );

  proc sort data=A;
    by descending &var;
  run;

  proc sgplot data=A noautolegend;
    hbarparm category=cluster2017 response=&var / nooutline fillattrs=(color=&URBAN_COLOR_CYAN) datalabel;
    yaxis display=(nolabel) valueattrs=(color=black family="Lato" size=8pt);
    xaxis display=none /*display=(nolabel) valueattrs=(color=black family="Lato" size=9pt)*/;
    title2 justify=left color=black font="Lato" height=10pt "&title, 2010–2020";
  run;

%mend hbar;

/** End Macro Definition **/


/** Macro scatter - Start Definition **/

%macro scatter( x=, y=, xlabel=, ylabel=, datalabel=, where= );

  proc sgplot data=A noautolegend uniform=scale;
    %if %length( &where ) > 0 %then %do;
      where &where;
    %end;
    scatter x=&x y=&y / 
      markerattrs=(color=&URBAN_COLOR_CYAN symbol=CircleFilled)
      tip=(&datalabel)
      /*tip=(numhsgunits_chg popblacknonhispbridge_chg cluster2017) tipformat=(comma8.0 comma8.0 $clus17a.)*/
      datalabel=&datalabel datalabelattrs=(color=black family="Lato");
    reg x=&x y=&y / lineattrs=(color=&URBAN_COLOR_CYAN pattern=2);
    xaxis /*display=(nolabel)*/ valueattrs=(color=black family="Lato");
    yaxis /*display=(nolabel)*/ valueattrs=(color=black family="Lato");
    label 
      &x = "&xlabel" 
      &y = "&ylabel";
    /*title1 justify=left color=&URBAN_COLOR_CYAN font="Lato" height=9pt "FIGURE %upcase(&appendix).#BYVAL1";*/
    title2 justify=left color=black font="Lato" height=10pt "&ylabel vs. &xlabel, 2010–2020";
  run;

%mend scatter;

/** End Macro Definition **/


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


ods html file="&_dcdata_default_path\NCDB\Prog\2020\Pop_hsng_analysis_cluster2017.html" (title="Analysis by cluster2017");

ods graphics on / imagemap=on border=off height=10in width=8in;

%hbar( var=totpop_chg, title=Change in total population )
%hbar( var=totpop_pctchg, title=Pct. change in total population )

%hbar( var=popblacknonhispbridge_chg, title=Change in Black population )
%hbar( var=popblacknonhispbridge_pctchg, title=Pct. change in Black population )

%hbar( var=numhsgunits_chg, title=Change in housing units )
%hbar( var=numhsgunits_pctchg, title=Pct. change in housing units )

ods graphics on / imagemap=on height=7in width=11in;


%scatter( 
  datalabel=cluster2017,
  x=numhsgunits_chg, 
  y=popblacknonhispbridge_chg, 
  xlabel=Housing unit change, 
  ylabel=NH Black population change, 
  where=cluster2017 not in ( "27" )
)

%scatter( 
  datalabel=cluster2017,
  x=numhsgunits_pctchg, 
  y=popblacknonhispbridge_pctchg, 
  xlabel=Pct. housing unit change, 
  ylabel=Pct. NH Black population change, 
  where=cluster2017 not in ( "27" )
)

%scatter( 
  datalabel=cluster2017,
  x=totpop_chg, 
  y=popblacknonhispbridge_chg, 
  xlabel=Population change, 
  ylabel=NH Black population change, 
  where=cluster2017 not in ( "27" )
)

%scatter( 
  datalabel=cluster2017,
  x=totpop_pctchg, 
  y=popblacknonhispbridge_pctchg, 
  xlabel=Pct. population change, 
  ylabel=Pct. NH Black population change, 
  where=cluster2017 not in ( "27" )
)

ods html close;
