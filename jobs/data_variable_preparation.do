**** Vorbereitung der Variablen

use "outputs\ESS9_merged.dta", clear

** Abhängige Variable - Index für politische Partizipation

fre vote		// Voted last national election
cap drop pol_vote
recode vote (1 = 1 "Yes") (2 = 0 "No") (else = .), gen(pol_vote)
fre pol_vote
lab var pol_vote "Voted last national election"

fre contplt		// Contacted politician or government official last 12 months
cap drop pol_contact
recode contplt (1 = 1 "Yes") (2 = 0 "No"), gen(pol_contact)
fre pol_contact
lab var pol_contact "Contact with Politicians"

fre wrkprty		// Worked in political party or action group last 12 months
cap drop pol_party
recode wrkprty (1 = 1 "Yes") (2 = 0 "No"), gen(pol_party)
fre pol_party
lab var pol_party "Worked in political party or action group"

fre wrkorg		// Worked in another organisation or association last 12 months
cap drop pol_org
recode wrkorg (1 = 1 "Yes") (2 = 0 "No"), gen(pol_org)
fre pol_org
lab var pol_org "Worked in organisation or association"

fre badge		// Worn or displayed campaign badge/sticker last 12 months
cap drop pol_badge
recode badge (1 = 1 "Yes") (2 = 0 "No"), gen(pol_badge)
fre pol_badge
lab var pol_badge "Worn or displayed campaign badge/sticker"

fre sgnptit		// Signed petition last 12 months
cap drop pol_petition
recode sgnptit (1 = 1 "Yes") (2 = 0 "No"), gen(pol_petition)
fre pol_petition
lab var pol_petition "Signed petition"

fre pbldmn		// Taken part in lawful public demonstration last 12 months
cap drop pol_demo
recode pbldmn (1 = 1 "Yes") (2 = 0 "No"), gen(pol_demo)
fre pol_demo
lab var pol_demo "Attended public demonstration"

fre bctprd		// Boycotted certain products last 12 months
cap drop pol_boycott
recode bctprd (1 = 1 "Yes") (2 = 0 "No"), gen(pol_boycott)
fre pol_boycott
lab var pol_boycott "Boycotted products"

fre pstplonl	// Posted or shared anything about politics online last 12 months
cap drop pol_online
recode pstplonl (1 = 1 "Yes") (2 = 0 "No"), gen(pol_online)
fre pol_online
lab var pol_online "Posted politics-related content online"

gen index_politparti = pol_vote + 1.5*pol_contact + 2*pol_party + 1.5*pol_org + 1.5*pol_badge +pol_petition + pol_demo + pol_boycott + pol_online
fre index_politparti
lab var index_politparti "Political participation"

corr pol_*

alpha pol_*, item c std gen(alpha_index)

corr index_politparti alpha_index


** Zentrale unabhängige Variablen - Sozialkapital und Merkmale des Wohlfahrtsstaats

* Sozialkapital --> Dimensionen: Vertrauen, Netzwerke und Norme 

// soziales Vertrauen

fre ppltrst		// Most people can be trusted or you can't be too careful
fre pplfair		// Most people try to take advantage of you, or try to be fair
fre pplhlp		// Most of the time people helpful or mostly looking out for themselves

// soziale Netzwerke

fre sclmeet		// How often socially meet with friends, relatives or colleagues
fre inprdsc		// How many people with whom you can discuss intimate and personal matters
fre sclact		// Take part in social activities compared to others of same age

// soziale Normen

fre ipudrst		// Important to understand different people
fre ipfrule		// Important to do what is told and follow rules
fre iphlppl		// Important to help people and care for others well-being
fre iplylfr		// Important to be loyal to friends and devote to people close
fre imptrad		// Important to follow traditions and customs

cap drop norms_*

gen norms_understand = ipudrst
gen norms_rules = ipfrule
gen norms_care = iphlppl
gen norms_loyal = iplylfr
gen norms_traditions = imptrad

recode norms_* (1=6) (2=5) (3=4) (4=3) (5=2) (6=1) // Umpolung zu einem intuitiven Wertebereich (1=Stimme überhaupt nicht zu) (5=Stimme voll und ganz zu)

cap drop capital_*

gen capital_trust1 = ppltrst
gen capital_trust2 = pplfair
gen capital_trust3 = pplhlp
gen capital_network1 = sclmeet
gen capital_network2 = inprdsc
gen capital_network3 = sclact
gen capital_norms1 = norms_understand
gen capital_norms2 = norms_rules
gen capital_norms3 = norms_care
gen capital_norms4 = norms_loyal
gen capital_norms5 = norms_traditions

fre capital_*

quietly: pca capital_*
estat kmo // Kaiser-Meyer-Olkin-Kriterium

pca capital_*

scree, yline(1)

fac capital_*, ipf fac(3)

rename capital_norms2 norms2

pca capital_*

scree, yline(1)

fac capital_*, ipf fac(3)

quietly: fac capital_*, ipf fac(3)
rot, oblique quartimin

estat common

rot, oblique quartimin normalize blank(0.2)

rename capital_norms5 norms5

pca capital_*

scree, yline(1)

fac capital_*, ipf fac(3)

quietly: fac capital_*, ipf fac(3)
rot, oblique quartimin

estat common

rot, oblique quartimin normalize blank(0.2)

rename capital_network2 network2

pca capital_*

scree, yline(1)

fac capital_*, ipf fac(3)

quietly: fac capital_*, ipf fac(3)
rot, oblique quartimin

estat common

rot, oblique quartimin normalize blank(0.2)

dis e(evsum)/8

estat res

// Index für soziales Vertrauen

cap drop index_trust
gen index_trust 	= capital_trust1 * capital_trust2 * capital_trust3
fre index_trust

// Index für soziale Netzwerke

cap drop index_network
gen index_network	= capital_network1 + capital_network3
fre index_network

// Index für soziale Normen

cap drop index_norms
gen index_norms	= capital_norms1 + capital_norms3 + capital_norms4
fre index_norms


// --> Gesamt-Index für Sozialkapital

cap drop index_capital
gen index_capital = 0.03*index_trust + 2*index_network + index_norms

fre index_capital
lab var index_capital "Social capital"


* Merkmale des Wohlfahrtsstaats

// Regimetyp

fre cntry // Country
cap drop welfare_type
gen welfare_type =.
replace welfare_type = 1 if cntry == "SE" | cntry == "FI" | cntry == "DK" 
replace welfare_type = 2 if cntry == "GB" | cntry == "IE"
replace welfare_type = 3 if cntry == "DE" | cntry == "FR" | cntry == "AT" | cntry == "BE" | cntry == "NL"
replace welfare_type = 4 if cntry == "PL" | cntry == "CZ" | cntry == "HR" | cntry == "BG" | cntry == "SK" | cntry == "HU" | cntry == "EE" | cntry == "LT" | cntry == "LV"
replace welfare_type = 5 if cntry == "ES" | cntry == "IT" | cntry == "PT" 

label def welfare_type 1 "Social Democratic" 2 "Liberal" 3 "Conservative-Corporatistic" 4 "Post-Communist" 5 "Latin-Rim"

label values welfare_type welfare_type

lab var welfare_type "Regime type"

fre welfare_type

// Wohlfahrtsausgaben

lab var welfare_exp "Social expenditure"	// Average total expenditure for social protection in Euro per inhabitant

fre welfare_exp


* Kontrollvariablen

// Wohlstand eines Landes

lab var wealth "GDP per capita"	// Average GDP per capita in PPS

fre wealth

// Anteil religiöser Bürger*innen eines Landes

fre rlgblg		// Belonging to particular religion or denomination

cap drop religion_comp
gen religion_comp = .
replace religion_comp = 46.00	if cntry == "BE"
replace religion_comp = 78.70	if cntry == "BG"
replace religion_comp = 20.66	if cntry == "CZ"
replace religion_comp = 58.07	if cntry == "DK"
replace religion_comp = 56.75	if cntry == "DE"
replace religion_comp = 27.05	if cntry == "EE"
replace religion_comp = 68.78	if cntry == "IE"
replace religion_comp = 62.55	if cntry == "ES"
replace religion_comp = 52.75	if cntry == "FR"
replace religion_comp = 69.13	if cntry == "HR"
replace religion_comp = 79.11	if cntry == "IT"
replace religion_comp = 44.70	if cntry == "LV"
replace religion_comp = 87.88	if cntry == "LT"
replace religion_comp = 51.81	if cntry == "HU"
replace religion_comp = 31.32	if cntry == "NL"
replace religion_comp = 73.65	if cntry == "AT"
replace religion_comp = 87.29	if cntry == "PL"
replace religion_comp = 71.13	if cntry == "PT"
replace religion_comp = 75.23	if cntry == "SK"
replace religion_comp = 56.00	if cntry == "FI"
replace religion_comp = 40.67	if cntry == "SE"
replace religion_comp = 45.80	if cntry == "GB"

lab var religion_comp "Percentage of religious"	// Percentage of respondents reporting to be religious

fre religion_comp

// Index für Religiösität eines Individuums

fre rlgdgr		// How religious are you
cap drop religion_degree
clonevar religion_degree	= rlgdgr
fre religion_degree

fre rlgatnd		// How often attend religious services apart from special occasions
cap drop religion_attend
clonevar religion_attend	= rlgatnd
fre religion_attend


cap drop index_religion
gen index_religion = religion_degree * religion_attend
fre index_religion

lab var index_religion "Strength in religiosity"

// Soziodemographische Variablen

fre gndr		// Gender
cap drop sex
clonevar sex = gndr
fre sex
lab var sex "Gender"

fre agea		// Age
cap drop age
clonevar age = agea
fre age
lab var age "Age"

fre hinctnta	// Household's total net income
cap drop hinc
clonevar hinc = hinctnta
fre hinc
lab var hinc "Household's total net income"

fre hhmmb		// Number of people living regularly as member of household
cap drop hsize
clonevar hsize = hhmmb
fre hsize
lab var hsize "Number of household members"

fre marsts		// Legal marital status
cap drop marital
clonevar marital = marsts
fre marital
lab var marital "Marital status"

fre domicil		// Domicile
lab var domicil "Domicile"

fre eisced		// Highest level of education, ES - ISCED
cap drop edulvl
clonevar edulvl = eisced
fre edulvl
lab var edulvl "Highest level of education"


// Zentrierung der unabhängigen Variablen

sum index_capital
gen c_index_capital = index_capital - r(mean)
lab var c_index_capital "Social capital"

sum index_religion
gen c_index_religion = index_religion - r(mean)
lab var c_index_religion "Strength in religiosity"

sum age
gen c_age = age - r(mean)
lab var c_age "Age"

sum edulvl
gen c_edulvl = edulvl - r(mean)
lab var c_edulvl "Highest level of education"

sum hsize
gen c_hsize = hsize - r(mean)
lab var c_hsize "Number of household members"


// Interaktionseffekt aus Regimetyp und Sozialausgaben

gen capital_wtype = index_capital * welfare_type


save "outputs\final_dataset.dta", replace

clear
