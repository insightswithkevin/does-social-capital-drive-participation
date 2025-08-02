version 17
clear

* Working directory
cd "C:\Users\kevin\OneDrive\Documents\Studium\HU\SoSe2022\VS Demokratie in Zeiten von Ungleichheiten\Hausarbeit\Okonkwo_617877_Hausarbeit"

* Options
set more off, perm
set varabbrev off, perm
set maxvar 32767, perm
set seed 1234

* Check for SSC-dependencies:
foreach p in grstyle fre estout {
	cap `p'
	if (_rc == 199) ssc install `p'
}

* Graphing options
set scheme s1mono
grstyle clear
grstyle init
grstyle set imesh, horizontal // inesh = R

* Writing log-files (with date in file-name)
local logdate = string( d(`c(current_date)'), "%dCY-N-D")
log using "logs\log_`logdate'.log", append

* Run-Code
do "jobs\data_import_merge.do" 				// data import and merging
do "jobs\data_variable_preparation.do"		// preparation of variables
do "jobs\analysis_descriptives.do"			// regression analysis
do "jobs\analysis_regressions.do"			// regression analysis