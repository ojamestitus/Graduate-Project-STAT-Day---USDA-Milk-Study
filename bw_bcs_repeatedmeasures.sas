proc import datafile="/home/u49828376/STAT 930/Selby and Travis/cow_bwbcs.csv"
	dbms=csv out=work.bwbcs replace;
	run;
	

data bwbcsn;
merge bwbcs;
if stage = "precalve" then stage = 1;
if stage = "prebreed" then stage = 2;
if stage = "breed" then stage = 3;
if stage = "wean" then stage =4;
run;

proc print data=bwbcsn;
run;


*----------------------------------------------------------------------
Body weight
----------------------------------------------------------------------;
title "Unstructured";
proc glimmix data=bwbcsn noclprint;
class  seasonyr cowID calfsex cowagen stage;
model BW= stage|calfsex stage|cdate stage|cowagen stage|milkauc/htype=1,3 s;
random _residual_/type=un subject=cowID(seasonyr);
ods output covparms=cov;
run;
*Note: this is the best covariance pattern;

title "AR(1)";
proc glimmix data=bwbcsn noclprint;
class  seasonyr cowID calfsex cowagen stage;
model BW= stage calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=AR(1) subject=cowID(seasonyr);
ods output covparms=cov;
run;

title "ANTE(1)";
proc glimmix data=bwbcsn noclprint;
class  seasonyr cowID calfsex cowagen stage;
model BW= stage calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=ANTE(1) subject=cowID(seasonyr);
ods output covparms=cov;
run;

title "Compound Symmetry";
proc glimmix data=bwbcsn noclprint;
class  seasonyr cowID calfsex cowagen stage;
model BW= stage calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=cs subject=cowID(seasonyr);
ods output covparms=cov;
run;

title "Toepolitz";
proc glimmix data=bwbcsn noclprint;
class  seasonyr cowID calfsex cowagen stage;
model BW= stage calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=toep subject=cowID(seasonyr);
ods output covparms=cov;
run;


*----------------------------------------------------------------------
Body condition
----------------------------------------------------------------------;
title "Unstructured";
proc glimmix data=bwbcsn noclprint;
class  seasonyr cowID calfsex cowagen stage;
model BCS= stage|calfsex stage|cdate stage|cowagen stage|milkauc/htype=1,3 s;
random _residual_/type=un subject=cowID(seasonyr);
ods output covparms=cov;
run;
*Note: this is the best covariance pattern;

title "AR(1)";
proc glimmix data=bwbcsn noclprint;
class  seasonyr cowID calfsex cowagen stage;
model BCS= stage calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=AR(1) subject=cowID(seasonyr);
ods output covparms=cov;
run;

title "ANTE(1)";
proc glimmix data=bwbcsn noclprint;
class  seasonyr cowID calfsex cowagen stage;
model BCS= stage calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=ANTE(1) subject=cowID(seasonyr);
ods output covparms=cov;
run;

title "Compound Symmetry";
proc glimmix data=bwbcsn noclprint;
class  seasonyr cowID calfsex cowagen stage;
model BCS= stage calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=cs subject=cowID(seasonyr);
ods output covparms=cov;
run;

title "Toepolitz";
proc glimmix data=bwbcsn noclprint;
class  seasonyr cowID calfsex cowagen stage;
model BCS= stage calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=toep subject=cowID(seasonyr);
ods output covparms=cov;
run;

proc univariate data=bwbcsn normal plots;
var BCS;
histogram;
run;