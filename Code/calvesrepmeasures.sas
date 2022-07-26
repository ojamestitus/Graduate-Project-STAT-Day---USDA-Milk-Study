proc import datafile="/home/u49828376/STAT 930/Selby and Travis/calfweights.csv"
	dbms=csv out=work.calves replace;
	run;
	
proc print data=calves;
run;

data calves;
set calves;
dayn=day+0;
run;

*Old code
*/proc glimmix data=calves noclprint;
*class  seasonyr cowID calfsex cowagen day;
*model calfweight= day calfsex cdate cowagen milkauc milkauc*day /htype=1 s;
*random seasonyr;
*random _residual_/type=un subject=cowID;
*/run;

*From Kathy
------------------------------------------------------------------------------------------------
;
proc sort data=calves;
by seasonyr cowid dayn;
run;
proc freq data=calves;
table dayn;
run;
proc freq data=calves;
table cowagen*seasonyr;
run;
proc glimmix data=calves noclprint; 
class  seasonyr cowID calfsex cowagen dayn; 
model calfweight= dayn|calfsex  dayn|cowagen dayn|cdate dayn|milkauc/htype=1,3 s; 
random _residual_/type=un subject=cowID(seasonyr); 
lsmeans dayn*calfsex  dayn*cowagen/slicediff=(dayn);
run;
data graph;
do milkauc=400 to 1600 by 100;
do dayn=0,30,60,90,120,200;
wt=155.30+0.08432*milkauc+((dayn=0)*(-.08645)+
(dayn=30)*(-.07691)+(dayn=60)*(-.06681)+
(dayn=90)*(-.05511)+
(dayn=120)*(-.04496))*milkauc;output;
end;
end;
run;
proc sort data=calves;
by dayn;

proc sgplot data=graph;
title "Assocation of Milk AUC and Calf Weight for each day";
  series y=wt x=milkauc/group=dayn; 
  xaxis label = "Milk AUC";
  yaxis label = "Calf Weight";
run;
proc means data=calves;
by dayn;
var milkauc calfweight;
run;
proc glimmix data=calves noclprint; 
where dayn=0;
class  seasonyr cowID calfsex cowagen; 
model calfweight= calfsex cdate cowagen milkauc /htype=1,3 s; 
random calfsex cowagen/subject=cowid(seasonyr); 
run; 



*--------------------------------------------------------------------------------------------;

title "Unstructured";
proc glimmix data=calves noclprint;
class  seasonyr cowID calfsex cowagen dayn;
model calfweight= dayn calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=un subject=cowID(seasonyr);

ods output covparms=cov;
run;
**This is the best model based on fit statistics, but I did try CS and ANTE(1). Quadratic for cdate was insignificant;

title "Compound Symmetry";
proc glimmix data=calves noclprint;
class  seasonyr cowID calfsex cowagen dayn;
model calfweight= dayn calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=cs subject=cowID(seasonyr);
run;
title "ANTE(1)";
proc glimmix data=calves noclprint;
class  seasonyr cowID calfsex cowagen dayn;
model calfweight= dayn calfsex cdate cowagen milkauc/htype=1,3 s;
random _residual_/type=ante(1) subject=cowID(seasonyr);
run;

proc print data=cov;
run;
data times;
do time1=1 to 6;
 do time2=1 to time1;
  dist=time1-time2;
  output;
  end;
  end;
  run;
proc print;
run;
data covplot;
  merge times cov;
  proc print;
run;
data covp2;
set cov;
time1=substr(covparm,4,1);
time2=substr(covparm,6,1);
run;
proc print;
run;
axis1 value=(font=swiss2 h=2) label=(angle=90 f=swiss h=2 'Covariance of between Subj effects');
axis2 value=(font=swiss h=2) label=(f=swiss h=2 'Distance');
legend1 value=(font=swiss h=2) label=(f=swiss h=2 'From Time');
symbol1 color=black interpol=join line=1 value=square;
symbol2 color=black interpol=join line=2 value=circle;
symbol3 color=black interpol=join line=20 value=triangle;
symbol4 color=black interpol=join line=4 value=star;
title 'Unstructured covariance pattern';
run;
proc gplot data=covplot;
plot estimate*dist=time2/vaxis=axis1 haxis=axis2 legend=legend1;
run;
