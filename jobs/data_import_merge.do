**** Import/Mergen der Datensätze


* Reduzierung des ESS-9-Datensatzes um spezifische Länder

use "inputs\ESS9e03_1.dta", clear

drop if cntry == "CH" | cntry == "CY" | cntry == "IS" | cntry == "ME" | cntry == "NO" | cntry == "RS" |  cntry == "SI" // Ausschluss dieser Länder aus der Analyse

save "outputs\ESS9_reduced.dta", replace

clear


* Vorbereitung des Datensatzes zu Sozialausgaben der Länder

import delimited "inputs\spr_exp_sum_page_linear.csv", clear

keep geo obs_value

replace geo = "GB" if geo == "UK"

rename geo cntry

rename obs_value welfare_exp

collapse (mean) welfare_exp, by(cntry)

format welfare_exp %3.2f 

save "outputs\aggregated_spr_exp.dta", replace

clear


* Vorbereitung des Datensatzes zu Wohlstand der Länder

import delimited "inputs\gdp_capita_pps.csv", clear

keep geo obs_value

replace geo = "GB" if geo == "UK"

rename geo cntry

rename obs_value wealth

collapse (mean) wealth, by(cntry)

replace wealth = round(wealth)

save "outputs\aggregated_gdp.dta", replace

clear


* Mergen beider Datensätze 

use "outputs\ESS9_reduced.dta", clear

merge m:1 cntry using "outputs\aggregated_spr_exp.dta"

cap drop _merge

merge m:1 cntry using "outputs\aggregated_gdp.dta"

save "outputs\ESS9_merged.dta", replace

clear



