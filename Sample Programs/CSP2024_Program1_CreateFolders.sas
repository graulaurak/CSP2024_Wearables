*************************************************************************************************************************
*** CONFERENCE ON STATISTICAL PRACTICE
*** FEBRUARY 2024, NEW ORLEANS, LOUISIANA
*** PROGRAMMER: LAURA KATHERINE KAIZER
*** AFFILIATION: DEPARTMENT OF BIOSTATISTICS AND INFORMATIONS, UNIVERSITY OF COLORADO, ANSCHUTZ MEDICAL CAMPUS
*** 
*** COURSE: WORKFLOW FOR WEARABLES
***
*** PROGRAM 1. Create Project Folders
************************************************************************************************************************;


*HELLO--PLEASE PASTE THE PATHWAY (WITHOUT QUOTATION MARKS) TO THE MAIN PROJECT FOLDER BELOW;
%let root= ;


*SET SAS SESSION OPTIONS;
OPTIONS DLCREATEDIR;

*CREATE FOLDERS;
libname create "&root/Code";
libname create "&root/Background";
libname create "&root/DataRaw";
libname create "&root/DataProcessed";
libname create "&root/DataProcessed/Results";
libname create "&root/Dissemination";
libname create "&root/Reports";


*RESET SAS SESSION OPTIONS;
LIBNAME Create CLEAR;

OPTIONS NODLCREATEDIR;
