**** Mehrebenenanalyse

use "outputs\final_dataset.dta", clear


// Konstante Samplegröße über Modelle hinweg

quietly: mixed index_politparti index_capital index_religion sex age hinc edulvl marital hsize domicil religion_comp wealth welfare_exp i.welfare_type || cntry: index_capital, covariance(unstructured) variance reml


** Intraklassenkorrelationskoeffizienten

mixed index_politparti || cntry: if e(sample), variance reml
estat icc


** Random-Intercept-Modell

mixed index_politparti c_index_capital c_index_religion i.sex c_age hinc c_edulvl marital c_hsize domicil || cntry: if e(sample), variance reml

** Random-Slope-Modell

quietly: mixed index_politparti c_index_capital c_index_religion i.sex c_age hinc c_edulvl marital c_hsize domicil || cntry: if e(sample), variance reml

estimates store ri

quietly: mixed index_politparti c_index_capital c_index_religion i.sex c_age hinc c_edulvl marital c_hsize domicil || cntry: c_index_capital if e(sample), covariance(unstructured) variance reml

estimates store rs

lrtest ri rs


** Random-Slope-Plot für den Sozialkapital-Index

quietly: mixed index_politparti index_capital || cntry: index_capital if e(sample), variance reml
predict predscore, fitted
sort cntry index_capital
egen pickone = tag(cntry index_capital)
twoway connected predscore index_capital if pickone == 1, connect(ascending) ytitle("Fitted values: Politische Partizipation", size(medium)) name(rs_plot, replace) xtitle(Punkte auf dem Sozialkapital-Index) title("Random-Slope-Plot für die Variable Sozialkapital") ylabel(0 (1) 6) xlabel(0 (10) 75) ytick(#10) xtick(#20) graphregion(fcolor(white))

graph export "results\random-slope-plot.pdf", replace


** Modellaufbau

eststo clear
eststo Modell_1: mixed index_politparti c_index_capital|| cntry: c_index_capital if e(sample), covariance(unstructured) variance reml
eststo Modell_2: mixed index_politparti c_index_capital c_index_religion i.sex c_age hinc c_edulvl marital c_hsize domicil || cntry: c_index_capital if e(sample), covariance(unstructured) variance reml
eststo Modell_3: mixed index_politparti c_index_capital welfare_exp || cntry: c_index_capital if e(sample), covariance(unstructured) variance reml
eststo Modell_4: mixed index_politparti c_index_capital welfare_exp i.welfare_type || cntry: c_index_capital if e(sample), covariance(unstructured) variance reml
eststo Modell_5: mixed index_politparti c_index_capital c_index_religion i.sex c_age hinc c_edulvl marital c_hsize domicil religion_comp wealth welfare_exp i.welfare_type || cntry: c_index_capital if e(sample), covariance(unstructured) variance reml
eststo Modell_6: mixed index_politparti index_capital index_religion i.sex age hinc edulvl marital hsize domicil religion_comp wealth welfare_exp i.welfare_type capital_wtype || cntry: index_capital if e(sample), covariance(unstructured) variance reml
esttab Modell_1 Modell_2 Modell_3 Modell_4 Modell_5 Modell_6 using "results\regressiontabelle.tex", compress nogap label replace nodep nobase


** Koeffizientenplot der Regression

quietly: mixed index_politparti index_capital index_religion i.sex age hinc edulvl marital hsize domicil religion_comp wealth welfare_exp i.welfare_type || cntry: index_capital if e(sample), covariance(unstructured) variance reml


coefplot, drop (_cons) xline (0) ylabel (1 "Index für Sozialkapital" 2 "Stärke an Religiosität" 3 "Geschlecht: Weiblich" 4 "Alter" 5 "Haushaltsnettoeinkommen" 6 "Bildungsniveau" 7 "Familienstand"  8 "Haushaltsgröße" 9 "Wohnsitz" 10 "Anteil an religiöser Bevölkerung" 11 "BIP pro Kopf" 12 "Gesamt-Sozialausgaben" 13 "Regimetyp: Liberal" 14 "Regimetyp: Konservativ-Korporatistisch" 15 "Regimetyp: Postkommunistisch" 16 "Regimetyp: Südeuropäisch/Mediterran") title("Effekte der unabhängigen Variablen", size(medium)) xtitle(" Index für Politische Partizipation", size(small)) graphregion(fcolor(white))

graph export "results\coefplot.pdf", replace


** Modellierung von Cross-Level-Interaktionen

quietly: mixed index_politparti index_religion i.sex age i.hinc edulvl i.marital hsize domicil religion_comp wealth welfare_exp c.index_capital##i.welfare_type || cntry: index_capital if e(sample), covariance(unstructured) variance reml
margins, at(index_capital=(7 (10) 71) welfare_type=(1 2 3 4 5))
marginsplot, ytitle(Index für politische Partizipation) xtitle(Sozialkapital-Index) title("Cross-Level-Interaktion zwischen Sozialkapital und Regimetyp") subtitle("mit Kontrollvariablen") legend(title ("Regimetyp", size(medium))) graphregion(fcolor(white)) name(controlled_interaction, replace)

graph export "results\cross-level-interaction.pdf", replace


** Teststatistiken und Gütemaße

// Erklärte Varianz auf Mikro- und Makroebene

mixed index_politparti || cntry: if e(sample), variance reml

mixed index_politparti index_capital index_religion i.sex age hinc edulvl marital hsize domicil religion_comp wealth welfare_exp i.welfare_type || cntry: if e(sample), variance reml


clear