*************************************************************************************************************************
*** CONFERENCE ON STATISTICAL PRACTICE
*** FEBRUARY 2024, NEW ORLEANS, LOUISIANA
*** PROGRAMMER: LAURA KATHERINE KAIZER
*** AFFILIATION: DEPARTMENT OF BIOSTATISTICS AND INFORMATIONS, UNIVERSITY OF COLORADO, ANSCHUTZ MEDICAL CAMPUS
*** 
*** COURSE: WORKFLOW FOR WEARABLES
***
*** PROGRAM 5: Distributions
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
data graphs;
set raw.analysis_data;
label avg_steps="Step Count" week="Week";
run;
**************************************************************************
CREATE MACROS
**************************************************************************;

%macro dist(data= ,  outcome=, timepoint=,  imagename=);

	ods graphics on / imagename="&imagename.";
	proc sgpanel data=&data;
	panelby &timepoint.;
	histogram &outcome./fillattrs=(color=purple);
	run;

%mend dist;

**************************************************************************
CREATE FIGURES
**************************************************************************;

ods listing gpath="&images" image_dpi=300;

%dist(data=graphs , imagename=Dist_steps, outcome=avg_steps, timepoint=week);











ods graphics off;
