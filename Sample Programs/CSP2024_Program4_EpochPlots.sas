*************************************************************************************************************************
*** CONFERENCE ON STATISTICAL PRACTICE
*** FEBRUARY 2024, NEW ORLEANS, LOUISIANA
*** PROGRAMMER: LAURA KATHERINE KAIZER
*** AFFILIATION: DEPARTMENT OF BIOSTATISTICS AND INFORMATIONS, UNIVERSITY OF COLORADO, ANSCHUTZ MEDICAL CAMPUS
*** 
*** COURSE: WORKFLOW FOR WEARABLES
***
*** PROGRAM 4: Epoch Plots
************************************************************************************************************************;

%let root=C:\Users\graul\OneDrive - The University of Colorado Denver\Projects\CIDA Projects\CSP 2024 Abstract\Data for Course;
%let images=C:\Users\graul\OneDrive - The University of Colorado Denver\Projects\CIDA Projects\CSP 2024 Abstract;
**************************************************************************
LIBRARIES
**************************************************************************;

libname raw "&root";

**************************************************************************
READ IN THE RAW DATA
**************************************************************************;
data test;
set raw.sample_min_by_min;
METm=mets/60;
date=datepart(dtdate);
time=timepart(dtdate);
format date mmddyy10. time time9.;
if date<"13JUL19"d;
run;

**************************************************************************
OPTION 1: SEPARATE GRAPH PER DATE
**************************************************************************;
proc sgplot data=test;
by date;
series x=time y=stepcount;
run;


**************************************************************************
OPTION 2: PANELED GRAPH
**************************************************************************;

ods listing gpath="&images" image_dpi=300;


%macro minfig(data=, imagename=, datevar=, timevar=, outcomevar=);

ods graphics on / imagename="&imagename.";
proc sgpanel data=&data. noautolegend;
panelby &datevar./columns=1 rows=7;
loess x=&timevar. y=&outcomevar./lineattrs=(thickness=2 color=black) nomarkers ;
run;

%mend;

%minfig(data=test, imagename=StepCount-MinbyMin, datevar=date, timevar=time , outcomevar=stepcount);
%minfig(data=test, imagename=METm-MinbyMin, datevar=date, timevar=time , outcomevar=METm);

