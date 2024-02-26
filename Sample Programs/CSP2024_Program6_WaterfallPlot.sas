*************************************************************************************************************************
*** CONFERENCE ON STATISTICAL PRACTICE
*** FEBRUARY 2024, NEW ORLEANS, LOUISIANA
*** PROGRAMMER: LAURA KATHERINE KAIZER
*** AFFILIATION: DEPARTMENT OF BIOSTATISTICS AND INFORMATIONS, UNIVERSITY OF COLORADO, ANSCHUTZ MEDICAL CAMPUS
*** 
*** COURSE: WORKFLOW FOR WEARABLES
***
*** PROGRAM 6. Waterfall Plot
************************************************************************************************************************;

%let root=C:\Users\graul\OneDrive - The University of Colorado Denver\Projects\CIDA Projects\CSP 2024 Abstract\Data for Course;
%let images=C:\Users\graul\OneDrive - The University of Colorado Denver\Projects\CIDA Projects\CSP 2024 Abstract;

**************************************************************************
LIBRARIES
**************************************************************************;

libname raw "&root";

**************************************************************************
FORMATS
**************************************************************************;

**************************************************************************
READ IN THE DATA
**************************************************************************;
proc sql;
create table wide as
select a.clean_id, a.new_group as randomized_group, a.weight_kg as weight0, b.weight_kg as weight52
from raw.newdata(where=(week=0)) a left join raw.newdata(where=(week=52)) b
on a.clean_id=b.clean_id;
quit;

data wide;
set wide;
where weight0^=. and weight52^=.;
pctn=((weight52-weight0)/weight0)*100;
label pctn="Percent Weight Change (%) at 52 Weeks" randomized_group="Randomized Group";
run;

proc sort data=wide;
by descending pctn;
run;

data wide;
set wide;
position+1;
run;

**************************************************************************
CREATE MACROS
**************************************************************************;

%macro pasta(data= ,group=,  outcome=, position=, xlabel=, ylabel=, rand=, imagename=);

	ods graphics on / imagename="&imagename.";
	proc sgplot data=&data;
	vbar &position./response=&outcome. group=&group.;
	xaxis display=none;
	styleattrs datacontrastcolors=(black black) datacolors=(pink blue);
	run;

%mend pasta;

**************************************************************************
CREATE FIGURES
**************************************************************************;

ods listing gpath="&images" image_dpi=300;

%pasta(data=wide ,group=randomized_group, imagename=Waterfall_weight, outcome=pctn, position=position, xlabel=Study Week, ylabel=Average Step Count, rand=randomized_group);











ods graphics off;
