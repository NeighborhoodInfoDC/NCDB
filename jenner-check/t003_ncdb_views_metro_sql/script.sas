/**************************************************************************
 Jenner compatibility bundle for NCDB (NeighborhoodInfoDC)

 Source program:  Prog/Create_ncdb_views_was20.sas  (%Create_view)
 What it does:    Builds an NCDB "Washington region (2020)" view with
                  PROC SQL: it selects every column, adds a computed
                  metro-area code Metro20 = put( ucounty, $ctym20f. ),
                  and keeps only the counties that map to a 2020
                  metro/micro area (where put( ucounty, $ctym20f. ) ne "").

 The PROC SQL select/where is kept exactly as written in the repo. The
 metro lookup format $ctym20f., the input Ncdb data set, and the metadata
 registration are not part of this repo, so this bundle defines a small
 $ctym20f. from the Washington-region county codes, supplies a synthetic
 Ncdb_lf_2000 with a ucounty column, and materializes the result as a
 table (in place of a registered view) so it can be printed.
**************************************************************************/

/* Washington-region metro lookup the repo applies via put( ucounty, $ctym20f. ) */

proc format;
  value $ctym20f
    "11001" = "47900"   /* District of Columbia, DC */
    "24031" = "47900"   /* Montgomery, MD           */
    "24033" = "47900"   /* Prince George's, MD      */
    "51013" = "47900"   /* Arlington, VA            */
    "51059" = "47900"   /* Fairfax, VA              */
    "51510" = "47900"   /* Alexandria, VA           */
    "24001" = "19060"   /* Allegany, MD (Cumberland MSA) */
    other   = "";
run;

/* Synthetic NCDB long-form input (Ncdb.Ncdb_lf_2000 shape, small) */

data Ncdb_lf_2000;
  input ucounty $ statecd $ stusab $ trctpop0n;
  datalines;
11001 11 DC 3800
24031 24 MD 5100
24033 24 MD 4400
51013 51 VA 3900
51059 51 VA 5300
51510 51 VA 3600
24001 24 MD 2200
99999 99 ZZ 1000
;
run;

/* --- repo PROC SQL below, verbatim aside from view->table and dataset names --- */

proc sql;
  create table Ncdb_lf_2000_was20 (label="NCDB Long Form Data, 2000, Washington region (2020)") as
  select *, put( ucounty, $ctym20f. ) as Metro20 
    length=5 label='Metropolitan/micropolitan statistical area (2020)' 
  from Ncdb_lf_2000
  where put( ucounty, $ctym20f. ) ~= "";
quit;

run;

proc print data=Ncdb_lf_2000_was20 label;
  id ucounty;
  var statecd stusab Metro20 trctpop0n;
run;
