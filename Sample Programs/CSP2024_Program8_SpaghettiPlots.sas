*************************************************************************************************************************
*** CONFERENCE ON STATISTICAL PRACTICE
*** FEBRUARY 2024, NEW ORLEANS, LOUISIANA
*** PROGRAMMER: LAURA KATHERINE KAIZER
*** AFFILIATION: DEPARTMENT OF BIOSTATISTICS AND INFORMATIONS, UNIVERSITY OF COLORADO, ANSCHUTZ MEDICAL CAMPUS
*** 
*** COURSE: WORKFLOW FOR WEARABLES
***
*** PROGRAM 8. Spaghetti Plots
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
CREATE MACROS
**************************************************************************;
%macro pasta(data= ,person=,  outcome=, timepoint=);

	proc sort data=&data;
	by &person &timepoint;
	run;

	PROC SGPLOT DATA=&data;
	SERIES x=&timepoint y=&outcome/group=&person;
	LOESS  x=&timepoint y=&outcome/ nomarkers lineattrs=(color=black thickness=3);
	RUN;

%mend pasta;

**************************************************************************
CALL MACROS
**************************************************************************;
%pasta(data=raw.analysis_data ,person=clean_id,  outcome=avg_steps, timepoint=week);



**************************************************************************
ADDITIONAL, STUDY-DEPENDENT MODIFICATIONS

Consideration 1: Timepoints 
**************************************************************************;

%macro pasta(data= ,person=,  outcome=, timepoint=);

	proc sort data=&data;
	by &person &timepoint;
	run;

	PROC SGPLOT DATA=&data;
	SERIES x=&timepoint y=&outcome/group=&person;
	LOESS  x=&timepoint y=&outcome/ nomarkers lineattrs=(color=black thickness=3);
	XAXIS values=(0,13,26,52);
	RUN;

%mend pasta;

%pasta(data=raw.analysis_data ,person=clean_id,  outcome=avg_steps, timepoint=week);

**************************************************************************
ADDITIONAL, STUDY-DEPENDENT MODIFICATIONS

Consideration 2: Labeled axes
**************************************************************************;

%macro pasta(data= ,person=,  outcome=, timepoint=, xlabel=, ylabel=);

	proc sort data=&data;
	by &person &timepoint;
	run;

	PROC SGPLOT DATA=&data;
	SERIES x=&timepoint y=&outcome/group=&person;
	LOESS  x=&timepoint y=&outcome/ nomarkers lineattrs=(color=black thickness=3);
	XAXIS values=(0,13,26,52) label="&xlabel";
	YAXIS label="&ylabel";
	RUN;

%mend pasta;

%pasta(data=raw.analysis_data ,person=clean_id,  outcome=avg_steps, timepoint=week, xlabel=Study Week, ylabel=Average Step Count);


**************************************************************************
ADDITIONAL, STUDY-DEPENDENT MODIFICATIONS

Consideration 3: Randomized groups
**************************************************************************;

%macro pasta(data= ,person=,  outcome=, timepoint=, xlabel=, ylabel=, rand=, imagename=);

	proc sort data=&data;
	by &person &timepoint;
	run;
	ods graphics on / imagename="&imagename.";
	PROC SGPLOT DATA=&data;
	SERIES x=&timepoint y=&outcome/group=&person transparency=.7;
	LOESS  x=&timepoint y=&outcome/ nomarkers lineattrs=(thickness=3) group=&rand;
	XAXIS values=(0,13,26,52) label="&xlabel";
	YAXIS label="&ylabel";
	RUN;

%mend pasta;


ods listing gpath="&images" image_dpi=300;

%pasta(data=raw.analysis_data ,person=clean_id, imagename=Spaghetti_steps, outcome=avg_steps, timepoint=week, xlabel=Study Week, ylabel=Average Step Count, rand=randomized_group);











ods graphics off;
