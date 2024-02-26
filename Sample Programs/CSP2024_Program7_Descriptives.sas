*************************************************************************************************************************
*** CONFERENCE ON STATISTICAL PRACTICE
*** FEBRUARY 2024, NEW ORLEANS, LOUISIANA
*** PROGRAMMER: LAURA KATHERINE KAIZER
*** AFFILIATION: DEPARTMENT OF BIOSTATISTICS AND INFORMATIONS, UNIVERSITY OF COLORADO, ANSCHUTZ MEDICAL CAMPUS
*** 
*** COURSE: WORKFLOW FOR WEARABLES
***
*** PROGRAM7. Descriptives
************************************************************************************************************************;

%let root=C:\Users\graul\OneDrive - The University of Colorado Denver\Projects\CIDA Projects\CSP 2024 Abstract\Data for Course;
%let report=C:\Users\graul\OneDrive - The University of Colorado Denver\Projects\CIDA Projects\CSP 2024 Abstract;
**************************************************************************
LIBRARIES
**************************************************************************;

libname raw "&root";

**************************************************************************
FORMATS
**************************************************************************;


%macro table1_cont(data=,name=, class=,cat=, cont= , category= , order=, timevar=, timeval=, dec=1);

*Calculate mean and standard deviation by each categorical variable;
ods output table=&name._&timeval;
proc tabulate data=&data missing ;
where &timevar=&timeval.;
class &class &cat;
var &cont;
table (&cont),(all &class)*(n mean std)/nocellmerge;
run;

*Clean up the output to make it look nice;
data &name._&timeval;
length var $30 category $50;
set &name._&timeval;
clean=strip(put(&cont._mean, 8.&dec.))||" ("||strip(put(&cont._std, 8.&dec.))||")";
var="&name";
Category="&category";
Order=&order;
&timevar=&timeval;
if &class=. then &class=999;
run;

*Tranpose to finalize table;
proc transpose data= &name._&timeval out=f_&name._&timeval.;
by  var category &timevar.;
var clean;
id &class.;
run;

*Calculate change from baseline;
proc sql;
create table a_&name._&timeval as
select a.*, b.&cont. as &cont._0, a.&cont.-b.&cont as &cont._change
from &data a left join &data(where=(&timevar=0)) b
on a.clean_id=b.clean_id;
quit;

*Do same thing as above for change from baseline;
*Calculate mean and standard deviation by each categorical variable;
ods output table=c_&name._&timeval;
proc tabulate data=a_&name._&timeval missing ;
where &timevar=&timeval.;
class &class &cat;
var &cont._change;
table (&cont._change),(all &class)*(n mean std)/nocellmerge;
run;

*Clean up the output to make it look nice;
data c_&name._&timeval;
length var $30 category $50;
set c_&name._&timeval;
clean=strip(put(&cont._change_mean, 8.&dec.))||" ("||strip(put(&cont._change_std, 8.&dec.))||")";
var="&name";
Category="&category";
Order=&order;
&timevar=&timeval;
if &class=. then &class=999;
run;

*Tranpose to finalize table;
proc transpose data= c_&name._&timeval out=c_f_&name._&timeval. prefix=Change;
by  var category &timevar.;
var clean;
id &class.;
run;


*Combine into final table;
proc sql;
create table final_&name._&timeval. as
select a.category, a.var, a.&timevar., a._999, b.change999, a._0, b.change0, a._1, b.change1
from f_&name._&timeval. a left join c_f_&name._&timeval. b
on a.var=b.var and a.&timevar=b.&timevar.;
quit;

data final_&name._&timeval.;
set final_&name._&timeval.;
if &timevar.=0 then do;
	change999="";
	change0="";
	change1="";
end;
order=&order.;
run;

proc datasets library=work;
delete &name._&timeval f_&name._&timeval. a_&name._&timeval c_&name._&timeval c_f_&name._&timeval. ;
run;quit;

%mend table1_cont;

%table1_cont(data=raw.analysis_data,name=avg_steps, class=randomized_group,cat=, cont=avg_steps , category=Physical Activity , order=1, timevar=week, timeval=0, dec=1);
%table1_cont(data=raw.analysis_data,name=avg_steps, class=randomized_group,cat=, cont=avg_steps , category=Physical Activity , order=1, timevar=week, timeval=13, dec=1);
%table1_cont(data=raw.analysis_data,name=avg_steps, class=randomized_group,cat=, cont=avg_steps , category=Physical Activity , order=1, timevar=week, timeval=26, dec=1);
%table1_cont(data=raw.analysis_data,name=avg_steps, class=randomized_group,cat=, cont=avg_steps , category=Physical Activity , order=1, timevar=week, timeval=52, dec=1);

%table1_cont(data=raw.analysis_data,name=weight_kg, class=randomized_group,cat=, cont=weight_kg , category=Body Composition , order=2, timevar=week, timeval=0, dec=1);
%table1_cont(data=raw.analysis_data,name=weight_kg, class=randomized_group,cat=, cont=weight_kg , category=Body Composition , order=2, timevar=week, timeval=13, dec=1);
%table1_cont(data=raw.analysis_data,name=weight_kg, class=randomized_group,cat=, cont=weight_kg , category=Body Composition , order=2, timevar=week, timeval=26, dec=1);
%table1_cont(data=raw.analysis_data,name=weight_kg, class=randomized_group,cat=, cont=weight_kg , category=Body Composition , order=2, timevar=week, timeval=52, dec=1);

%table1_cont(data=raw.analysis_data,name=kcals, class=randomized_group,cat=, cont=kcals , category=Energy Intake , order=3, timevar=week, timeval=0, dec=1);
%table1_cont(data=raw.analysis_data,name=kcals, class=randomized_group,cat=, cont=kcals , category=Energy Intake , order=3, timevar=week, timeval=13, dec=1);
%table1_cont(data=raw.analysis_data,name=kcals, class=randomized_group,cat=, cont=kcals , category=Energy Intake , order=3, timevar=week, timeval=26, dec=1);
%table1_cont(data=raw.analysis_data,name=kcals, class=randomized_group,cat=, cont=kcals , category=Energy Intake , order=3, timevar=week, timeval=52, dec=1);



data _table1_;
set final:;
run;

proc sort data=_table1_;
by order var week;
run;

data _table1_;
set _table1_;
by var notsorted;
if not first.var then var="";
run;


proc format;
value $pretty
"avg_mvpa"="Average daily MVPA"
"weight_kg"="Weight (kg)"
"kcals"="Energy intake (kcals)"
"avg_steps"="Step Count";
run;

options orientation=landscape;
ods rtf file="&Report/Table1.rtf" style=journal;

proc print data=_table1_ (drop=order category) noobs label;
format var $pretty.;
label var="Measure" week="Week"  _999="All" change999="Change from baseline" _0="Randomized Group 0" change0= "Change from baseline" _1="Randomized Group 1" Change1="Change from baseline";
run;
ods rtf close;
