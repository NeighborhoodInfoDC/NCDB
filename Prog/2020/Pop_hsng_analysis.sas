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

%macro hbar( geo=, var=, title=, datalabel=Y );

  proc sort data=&geo;
    by descending &var;
  run;

  proc sgplot data=&geo noautolegend;
    hbarparm category=&geo response=&var / nooutline fillattrs=(color=&URBAN_COLOR_CYAN) 
    %if %mparam_is_yes( &datalabel ) %then %do;    
      datalabel
    %end;  
    ;
    %if %mparam_is_yes( &datalabel ) %then %do;
      yaxis display=(nolabel) valueattrs=(color=black family="Lato" size=8pt);
      xaxis display=none;
    %end;
    %else %do;
      yaxis display=none;
      xaxis display=(nolabel) valueattrs=(color=black family="Lato" size=9pt);    
    %end;
    title2 ' ';
    title3 justify=left color=black font="Lato" height=10pt "&title, 2010–2020";
  run;
  
  title2;

%mend hbar;

/** End Macro Definition **/


/** Macro scatter - Start Definition **/

%macro scatter( geo=, x=, y=, xlabel=, ylabel=, where=, datalabel=Y );

  proc sgplot data=&geo noautolegend uniform=scale;
    %if %length( &where ) > 0 %then %do;
      where &where;
    %end;
    scatter x=&x y=&y / 
      markerattrs=(color=&URBAN_COLOR_CYAN symbol=CircleFilled)
      tip=(&geo)
      /*tip=(numhsgunits_chg popblacknonhispbridge_chg cluster2017) tipformat=(comma8.0 comma8.0 $clus17a.)*/
      %if %mparam_is_yes( &datalabel ) %then %do;
        datalabel=&geo datalabelattrs=(color=black family="Lato")
      %end;
      ;
    reg x=&x y=&y / lineattrs=(color=&URBAN_COLOR_CYAN pattern=2);
    xaxis /*display=(nolabel)*/ valueattrs=(color=black family="Lato");
    yaxis /*display=(nolabel)*/ valueattrs=(color=black family="Lato");
    label 
      &x = "&xlabel" 
      &y = "&ylabel";
    /*title1 justify=left color=&URBAN_COLOR_CYAN font="Lato" height=9pt "FIGURE %upcase(&appendix).#BYVAL1";*/
    title2 ' ';
    title3 justify=left color=black font="Lato" height=10pt "&ylabel vs. &xlabel, 2010–2020";
  run;
  
  title2;

%mend scatter;

/** End Macro Definition **/


/** Macro analysis - Start Definition **/

%macro analysis( geo=, geosuf=, geolbl=, datawhere=, datalabel=Y, hbarheight=10in, scatterwhere= );

  ***********************************************************************************************
  **** Compile data;

  data &geo;

    merge 
      Ncdb.Ncdb_sum_2010_&geosuf
      Ncdb.Ncdb_sum_2020_&geosuf;
    by &geo;
    
    %if %length( &datawhere ) > 0 %then %do;
      where &datawhere;
    %end;
    
    totpop_chg = totpop_2020 - totpop_2010;
    totpop_pctchg = totpop_chg / totpop_2010;
    
    popblacknonhispbridge_chg = popblacknonhispbridge_2020 - popblacknonhispbridge_2010;
    popblacknonhispbridge_pctchg = popblacknonhispbridge_chg / popblacknonhispbridge_2010;
    
    numhsgunits_chg = numhsgunits_2020 - numhsgunits_2010;
    numhsgunits_pctchg = numhsgunits_chg / numhsgunits_2010; 
    
    label
      totpop_chg = "Total population change"
      totpop_pctchg = "Pct. total population change"
      popblacknonhispbridge_chg = "NH Black population change"
      popblacknonhispbridge_pctchg = "Pct. NH Black population change"
      numhsgunits_chg = "Housing units change"
      numhsgunits_pctchg = "Pct. housing units change";

    %if %length( &geolbl ) > 0 %then %do;
      label &geo = "&geolbl";
    %end;

    format totpop_chg popblacknonhispbridge_chg numhsgunits_chg comma8.0;

    format totpop_pctchg popblacknonhispbridge_pctchg numhsgunits_pctchg percent8.1;
    
    keep &geo totpop_: popblacknonhispbridge_: numhsgunits_: ;

  run;

  %File_info( data=&geo, contents=N, printobs=5 )


  ***********************************************************************************************
  **** Create charts;

  %let lastfignumber = 0;

  options nodate nonumber nocenter nobyline;
  options orientation=portrait leftmargin=0.5in rightmargin=0.5in topmargin=0.5in bottommargin=0.5in;

  ods html file="&_dcdata_default_path\NCDB\Prog\2020\Pop_hsng_analysis_&geo..html" (title="Analysis by &geo");

  ods graphics on / imagemap=on border=off height=&hbarheight width=8in;

  %hbar( geo=&geo, var=totpop_chg, datalabel=&datalabel, title=Change in total population )
  %hbar( geo=&geo, var=totpop_pctchg, datalabel=&datalabel, title=Pct. change in total population )

  %hbar( geo=&geo, var=popblacknonhispbridge_chg, datalabel=&datalabel, title=Change in Black population )
  %hbar( geo=&geo, var=popblacknonhispbridge_pctchg, datalabel=&datalabel, title=Pct. change in Black population )

  %hbar( geo=&geo, var=numhsgunits_chg, datalabel=&datalabel, title=Change in housing units )
  %hbar( geo=&geo, var=numhsgunits_pctchg, datalabel=&datalabel, title=Pct. change in housing units )

  ods graphics on / imagemap=on height=7in width=11in;


  %scatter( 
    geo=&geo,
    x=numhsgunits_chg, 
    y=popblacknonhispbridge_chg, 
    xlabel=Housing unit change, 
    ylabel=NH Black population change, 
    datalabel=&datalabel,
    where=&scatterwhere
  )

  %scatter( 
    geo=&geo,
    x=numhsgunits_pctchg, 
    y=popblacknonhispbridge_pctchg, 
    xlabel=Pct. housing unit change, 
    ylabel=Pct. NH Black population change, 
    datalabel=&datalabel,
    where=&scatterwhere
  )

  %scatter( 
    geo=&geo,
    x=totpop_chg, 
    y=popblacknonhispbridge_chg, 
    xlabel=Population change, 
    ylabel=NH Black population change, 
    datalabel=&datalabel,
    where=&scatterwhere
  )

  %scatter( 
    geo=&geo,
    x=totpop_pctchg, 
    y=popblacknonhispbridge_pctchg, 
    xlabel=Pct. population change, 
    ylabel=Pct. NH Black population change, 
    datalabel=&datalabel,
    where=&scatterwhere
  )

  ods html close;

%mend analysis;

/** End Macro Definition **/


%analysis( 
  geosuf=tr10, 
  geo=geo2010, 
  geolbl=Census tract (2010),
  datawhere=(geo2010=:"11"), 
  datalabel=N,
  scatterwhere= 
)


%analysis( 
  geosuf=cl17, 
  geo=cluster2017, 
  datawhere=(cluster2017 not in ( "40", "41", "42", "43", "44", "45", "46" )), 
  scatterwhere=(cluster2017 not in ( "27" ))
)


%analysis( 
  geosuf=wd12, 
  geo=ward2012,
  hbarheight=6in
)


