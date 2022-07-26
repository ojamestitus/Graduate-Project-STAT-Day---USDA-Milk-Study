proc import datafile='/home/u49828376/STAT 930/Selby and Travis/USDA milk study data 2-11-22.xlsx'
	dbms=xlsx out=work.onetime replace;
	sheet="one-time measures";
	run;

	
*create the variable for calf age within year season;
proc sort data = onetime nodupkey out=firstdate;
by year herd calvedate;
run;
data firstd (keep=year herd firstd);
set firstdate;
by year herd calvedate;
if first.herd;
firstd=calvedate;
run;
data onetimea;
merge onetime firstd;
by year herd;
cdate=calvedate-firstd+1;
seasonyr=trim(left(herd))||trim(left(year));
if cowage<7 then cowagen=cowage;
else cowagen=6;
run;	

proc export data=onetimea
    outfile="/home/u49828376/STAT 930/Selby and Travis/milk_onetime.csv"
    dbms=csv;
run;
	
*----------------------------------------------------------------------------------------------------------------------------
Exploratory data analysis:
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
Histograms
---------------------------------------------------------------------------------------------------------------------------;

proc print data = work.onetimea;
run;



proc sort data = work.measures nodupkey out=firstdate;
by year herd calvedate;
run;

data firstd (keep= year herd firsd);
set firstdate;
by year herd calvedate;
if first.herd;
firstd=calvedate;
run;

proc export data=onetimea outfile="/home/u49828376/STAT 930/Selby and Travis/milk_onetime.csv" dbms=csv;
run;

proc univariate data=onetimea normal;
var milkAUC;
histogram;
run;


proc univariate data=measures normal;
var precalveBW;
histogram;
run;

proc univariate data=measures normal;
var precalveBCS;
histogram;
run;

proc univariate data=measures normal;
var prebreedBW;
histogram;
run;

proc univariate data=measures normal;
var prebreedBCS;
histogram;
run;

proc univariate data=measures normal;
var breedBW;
histogram;
run;

proc univariate data=onetimea normal plots;
var breedBCS;
histogram;
run;

proc univariate data=measures normal;
var weanBW;
histogram;
run;

proc univariate data=measures normal;
var weanBCS;
histogram;
run;

proc univariate data=measures normal;
var prebreedBWchange;
histogram;
run;

proc univariate data=measures normal;
var breedBWchange;
histogram;
run;

proc univariate data=measures normal;
var weanBWchange;
histogram;
run;

proc univariate data=measures normal;
var calfbirth;
histogram;
run;

proc univariate data=measures normal plots;
var calf30;
histogram;
run;

proc univariate data=measures normal;
var calf60;
histogram;
run;

proc univariate data=measures normal;
var calf90;
histogram;
run;

proc univariate data=measures normal;
var calf120;
histogram;
run;

proc univariate data=measures normal;
var calfwean;
histogram;
run;

*-----------------------------------------------------------------------------------------------------------------------------
Scatter matrices
---------------------------------------------------------------------------------------------------------------------------;

proc sgscatter data=measures;
matrix milkAUC precalveBW prebreedBW breedBW weanBW /diagonal=(histogram);
run;

proc sgscatter data=measures;
matrix milkAUC precalveBCS prebreedBCS breedBCS weanBCS /diagonal=(histogram);
run;

proc sgscatter data=measures;
matrix milkAUC calfbirth calf30 calf60 calf90 calf120 calfwean/diagonal=(histogram);
run;

*-----------------------------------------------------------------------------------------------------------------------------
Models with quadratic effects:
-------------------------------------------------------------------------------------------------
Effect of body weights for cow:
-------------------------------------------------------------------------------------------------;


proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model precalvebw=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model prebreedbw=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model breedbw=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model weanbw=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

*-------------------------------------------------------------------------------------------------
Effect of change in body weight for cow:
-------------------------------------------------------------------------------------------------;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model prebreedBWchange=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model breedBWchange=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model weanBWchange=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

*-------------------------------------------------------------------------------------------------
Effect of body condition score for cow:
-------------------------------------------------------------------------------------------------;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model precalvebcs=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model prebreedbcs=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model breedbcs=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model weanbcs=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;
*-------------------------------------------------------------------------------------------------
Effect of calf weight:
-------------------------------------------------------------------------------------------------;


proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calfbirth=calfsex cdate cdate*cdate cowagen milkauc /htype=1,3 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calf30=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calf60=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calf90=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calf120=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calfwean=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

*-----------------------------------------------------------------------------------------------------------------------------
Models with insignificant quadratics dropped:
----------------------------------------------------------------------------------
Effect of body weights for cow:
-------------------------------------------------------------------------------------------------;

title "Assocation of milk AUC and precalve cow body weight";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model precalvebw=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and prebreed cow body weight";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model prebreedbw=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and breed cow body weight";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model breedbw=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and wean cow body weight";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model weanbw=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

*-------------------------------------------------------------------------------------------------
Effect of change in body weight for cow:
-------------------------------------------------------------------------------------------------;

title "Association of milk AUC and change in prebreed cow body weight";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model prebreedBWchange=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and change in breed cow body weight";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model breedBWchange=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and change in wean cow body weight";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model weanBWchange=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

*-------------------------------------------------------------------------------------------------
Effect of body condition score for cow:
-------------------------------------------------------------------------------------------------;

title "Association of milk AUC and precalve cow body condition";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model precalvebcs=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and prebreed cow body condition";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model prebreedbcs=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and breed cow body condition";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model breedbcs=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and wean cow body condition";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model weanbcs=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;
*-------------------------------------------------------------------------------------------------
Effect of calf weight:
-------------------------------------------------------------------------------------------------;

title "Association of milk AUC and calf birth weight";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calfbirth=calfsex cdate cowagen milkauc /htype=1,3 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and calf weight at 30 days";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calf30=calfsex cdate cdate*cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and calf weight at 60 days";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calf60=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and calf weight at 90 days";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calf90=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and calf weight at 120 days";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calf120=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

title "Association of milk AUC and calf weight at weaning";
proc glimmix data=onetimea noclprint;
class  seasonyr calfsex cowagen;
model calfwean=calfsex cdate cowagen milkauc /htype=1 s;* ddfm=kr2;
random seasonyr;
run;

proc freq data=onetimea;
table cowagen;
run;

proc means data=onetimea;
var cdate milkAUC;
run;

title "Association of MilkAUC and calfweight at 30 days";
PROC SGPLOT DATA = onetimea;
   SCATTER x = milkAUC y = calf30;
   REG   x = milkAUC y = calf30;
RUN;

title "Association of MilkAUC and weanBCS";
PROC SGPLOT DATA = onetimea;
   SCATTER x = milkAUC y = weanBCS;
   REG   x = milkAUC y = weanBCS;
RUN;

proc freq data=onetimea;
table weanBCS*cowagen;
table precalvebcs*cowagen;
table prebreedbcs*cowagen;
table breedbcs*cowagen;
run;

proc means data=onetimea;
var precalvebcs prebreedbcs breedbcs weanbcs;
run;
