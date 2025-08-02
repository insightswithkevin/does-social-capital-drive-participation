**** Deskriptive Befunde

use "outputs\final_dataset.dta", clear


** Datenstruktur

cap drop cntry_id
gen cntry_id = .

replace cntry_id = 1	if cntry == "BE"
replace cntry_id = 2	if cntry == "BG"
replace cntry_id = 3	if cntry == "CZ"
replace cntry_id = 4	if cntry == "DK"
replace cntry_id = 5	if cntry == "DE"
replace cntry_id = 6	if cntry == "EE"
replace cntry_id = 7	if cntry == "IE"
replace cntry_id = 8	if cntry == "ES"
replace cntry_id = 9	if cntry == "FR"
replace cntry_id = 10	if cntry == "HR"
replace cntry_id = 11	if cntry == "IT"
replace cntry_id = 12	if cntry == "LV"
replace cntry_id = 13	if cntry == "LT"
replace cntry_id = 14	if cntry == "HU"
replace cntry_id = 15	if cntry == "NL"
replace cntry_id = 16	if cntry == "AT"
replace cntry_id = 17	if cntry == "PL"
replace cntry_id = 18	if cntry == "PT"
replace cntry_id = 19	if cntry == "SK"
replace cntry_id = 20	if cntry == "FI"
replace cntry_id = 21	if cntry == "SE"
replace cntry_id = 22	if cntry == "GB"

lab var cntry_id "Country identifier"

quietly: xtset cntry_id
xtsum index_politparti index_capital welfare_exp welfare_type if e(sample) // Untersuchung wie stark die Variablen auf Level-1-Ebene und Level-2-Ebene variieren


** Korrelation des Sozialkapitals und der politischen Partizipation auf Länderebene

preserve


collapse (mean) age index_religion index_politparti index_capital index_trust index_network index_norms religion_comp wealth welfare_exp, by(cntry) // --> Aggregation von Individualmerkmalen auf die Länder

export delimited using "outputs\aggregated_dataset.csv", replace


pwcorr index_politparti index_capital, sig star(.05) // Pearson-Korrelation
pwcorr index_capital welfare_exp, sig star(.05)

egen pos = mlabvpos(index_politparti index_capital)

replace pos = 12 if cntry == "BE"
replace pos = 12 if cntry == "IT"
replace pos = 3 if cntry == "EE"
replace pos = 12 if cntry == "CZ"
replace pos = 9 if cntry == "LV"
replace pos = 4 if cntry == "BG"
replace pos = 3 if cntry == "FI"
replace pos = 3 if cntry == "SK"
replace pos = 3 if cntry == "HR"
replace pos = 9 if cntry == "FR"
replace pos = 6 if cntry == "ES"
replace pos = 1 if cntry == "GB"

twoway lfit index_politparti index_capital || scatter index_politparti index_capital, mlabel(cntry) mlabvpos(pos) ||, ytitle(Political participation, size(medium)) xtitle(Social capital) title("Correlation between political participation and social capital at country level", size(medsmall)) ylabel(0 (1) 4) xlabel(28 (5) 43) graphregion(fcolor(white))

graph export "results\corr_scapital_participation.pdf", replace
 

restore

clear