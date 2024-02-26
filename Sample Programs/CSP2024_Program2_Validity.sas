*************************************************************************************************************************
*** CONFERENCE ON STATISTICAL PRACTICE
*** FEBRUARY 2024, NEW ORLEANS, LOUISIANA
*** PROGRAMMER: LAURA KATHERINE KAIZER
*** AFFILIATION: DEPARTMENT OF BIOSTATISTICS AND INFORMATIONS, UNIVERSITY OF COLORADO, ANSCHUTZ MEDICAL CAMPUS
*** 
*** COURSE: WORKFLOW FOR WEARABLES
***
*** PROGRAM 2. Validity
************************************************************************************************************************;

%macro validity(data= ,outdata=, person=, timepoint=, date=, time=, lying_down=, nonwear=);

****STEP 1: Flag first and last day of wear--these usually are incomplete and get removed;
	proc sql;
	create table &data._step1 as
	select *, min(&date) as first_wear format=mmddyy10., max(&date) as last_wear format=mmddyy10.
	from &data
	group by &person, &timepoint
	order by &person, &timepoint, &date, &time;
	quit;

****STEP 2: Sum up total minutes of wear time***;
	proc sql;
	create table &data._step2 as
	select *, sum(minute) as valid_minutes, sum(&nonwear./60) as non_wear_minutes
	from &data._step1
	group by &person, &timepoint, &date
	order by &person, &timepoint, &date, &time;
	quit;

****STEP 3: Flag first and last days--and days with <1360.8 or <1200 minutes of wear time***;
	data &data._step3;
	length delete $20 delete2 $20;
	set &data._step2;
	*Checking the nonwear variable;
	total_wear=valid_minutes-non_wear_minutes;

	*Create date_sleep variable to be able to calculate bedtime and waketime for each night;
	if &time>='12:00:00't and &time<'23:59:59't then date_sleep=&date;
	else date_sleep=&date-1;

	format date_sleep mmddyy10.;

	*Validity;
	if &date=first_wear or &date=last_wear then delete="First/Last";
	else if total_wear<1360.8 then delete="Less than 1360.8"; 
	else delete="Valid";

	if total_wear<1200 then delete2="Less than 1200";
	else if total_wear<1360.8 then delete2="1200<=wear<1360.8";
	else delete2="Valid";

	lt1200=(total_wear<1200);
	lt13608=(total_wear<1360.8);
	run; 

****STEP 4: Keep one record per person per day***;
proc sort data=&data._step3 out=pl_&data.(keep=&person &timepoint &date delete delete2 lt1200 lt13608) nodupkey;
by &person &date;
run;

	title "Validity Criteria &data";
	proc freq data=pl_&data.;
	tables delete delete2 delete*delete2/norow nocol nopercent;
	run;
	title;

****STEP 5: Keep one record per person per timepoint ***;
proc sql;
create table counts_&data as
select &person,&timepoint, count(&date.) as n_days, sum(lt1200) as ndays_lt1200, sum(lt13608) as ndays_lt13608, 
		count(&date)-sum(lt1200) as nvaliddays1200
from pl_&data
group by &person, &timepoint;
quit;
%mend validity;
