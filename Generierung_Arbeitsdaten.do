use /*"BA_Data_raw.dta"*/, clear

*****Impfstatus
fre pcovimpf_n
tab pcovimpf_n prki2impf2
fre prki2impf2											//Grundimmunisierung als vollständige Impfung
tab prki2impf1 prki2impf2


cap drop Impfstatus_1
gen Impfstatus_1 = pcovimpf_n
recode Impfstatus_1 (1 = 1) (2 = 0)
replace Impfstatus_1 = 0 if prki2impf1 == 0
lab def Impfstatus_1 0 "Keine Impfung" 1 "1. Impfung", replace
lab val Impfstatus_1 Impfstatus_1
fre Impfstatus_1

cap drop Impfstatus_2
gen Impfstatus_2 = pcovimpf_n
recode Impfstatus_2 (1 = 1) (2 = 0)
replace Impfstatus_2 = 0 if prki2impf1 == 0
replace Impfstatus_2 = 0 if prki2impf2 == 0
lab def Impfstatus_2 0 "Nicht vollständig geimpft" 1 "Vollsändig geimpft", replace
lab val Impfstatus_2 Impfstatus_2
fre Impfstatus_2

cap drop Impfstatus_3
gen Impfstatus_3 = prki2impf3
replace Impfstatus_3 = 0 if prki2impf1 == 0
replace Impfstatus_3 = 0 if prki2impf2 == 0
lab def Impfstatus_3 0 "Nicht vollständig geimpft" 1 "Vollsändig geimpft", replace
lab val Impfstatus_3 Impfstatus_3
fre Impfstatus_3

fre Impfstatus*, mis

*****Bildung
fre pgcasmin

cap drop casmin_einfach
gen casmin_einfach = pgcasmin
recode casmin_einfach (0 1 2 4 = 1) (3 5 6 7 = 2) (8 9 = 3)
lab def casmin_einfach 1 "Niedrige Bildung" 2 "Mittlere Bildung" 3 "Hohe Bildung", replace
lab val casmin_einfach casmin_einfach
fre casmin_einfach


*****Haushaltsäquivaleneinkommen
fre hlc0005_v2
fre hhgr
tab hhgr d1110720, mis
tab hhgr h1110220, mis
tab d1110720 h1110220, mis

*Anpassungen
fre pld0169
replace hhgr = hhgr - 1 if pld0169 == 1

fre pla0012
replace d1110720 = d1110720 + 1 if pla0012 == 1

fre pld0149
replace d1110720 = d1110720 + 1 if pld0149 == 1
replace h1110220 = h1110220 + 1 if pld0149 == 1


cap drop HH_Erwachsene
gen HH_Erwachsene = hhgr - d1110720
replace HH_Erwachsene = . if HH_Erwachsene <= 0
replace HH_Erwachsene = 1.5 if HH_Erwachsene == 2
replace HH_Erwachsene = 2 if HH_Erwachsene == 3
replace HH_Erwachsene = 2.5 if HH_Erwachsene == 4
replace HH_Erwachsene = 3 if HH_Erwachsene == 5
replace HH_Erwachsene = 3.5 if HH_Erwachsene == 6
fre HH_Erwachsene

cap drop HHKinder_18_14
gen HHKinder_18_14 = h1110220 * 0.5
replace HHKinder_18_14 = . if HHKinder_18_14 < 0
fre HHKinder_18_14

cap drop HHKinder_unter14
gen HHKinder_unter14 = (d1110720 - h1110220) * 0.3
fre HHKinder_unter14
replace HHKinder_unter14 = . if HHKinder_unter14 < 0
fre HHKinder_unter14

cap drop HHGewicht
gen HHGewicht = HH_Erwachsene + HHKinder_18_14 + HHKinder_unter14
fre HHGewicht

cap drop HHinc
gen HHinc = hlc0005_v2 / HHGewicht
fre HHinc
sum HHinc, det

replace HHinc = HHinc / 1000
fre HHinc
sum HHinc, det


*****GISD
fre gisd_10
fre bula

cap drop GISD_10
gen GISD_10 = gisd_10
replace GISD_10 = 6 if bula == 11

tab bula GISD_10

cap drop GISD_5
gen GISD_5 = GISD_10
recode GISD_5 (1 2 = 1) (3 4 = 2) (5 6 = 3) (7 8 = 4) (9 10 = 5)
fre GISD_5


*****Risikogruppe
**Alter
tab geburt
tab pgebm
tab datj_n
tab datm_n

cap drop Alter
gen Alter = 2021 - geburt
replace Alter = Alter + 1 if pgebm == 1 & datm_n == 1 | pgebm == 2 &  datm_n == 2| pgebm == 3 & datm_n == 3
fre Alter
sum Alter, det

cap drop Altersgruppe_RKI
gen Altersgruppe_RKI: Altersgruppe_RKI = 1 if inrange(Alter,18,29)						
	replace Altersgruppe_RKI = 2 if inrange(Alter,30,44)
	replace Altersgruppe_RKI = 3 if inrange(Alter,45,64)
	replace Altersgruppe_RKI = 4 if inrange(Alter,65,150)
	lab def Altersgruppe_RKI 1 "18-29" 2 "30-44" 3 "45-64" 4 "65+"
fre Altersgruppe_RKI


**Einschlägige Vorerkrankungen
fre ple0014
fre ple0012
fre ple0013
fre ple0015
fre ple0016
fre ple0018

cap drop Vorerkrankung
gen Vorerkrankung = 1
replace Vorerkrankung = 2 if ple0014 == 1 | ple0012 == 1 | ple0013 == 1 | ple0015 == 1 | ple0016 == 1 | ple0018 == 1
lab def Vorerkrankung 1 "keine gefährdende Vorerkrankung" 2 "gefährdende Vorerkrankung", replace
lab val Vorerkrankung Vorerkrankung
fre Vorerkrankung


*****Geschlecht
fre psex
cap drop Geschlecht
gen Geschlecht = psex
replace Geschlecht = . if Geschlecht == 3
lab def Geschlecht 1 "Männlich" 2 "Weiblich", replace
lab val Geschlecht Geschlecht
fre Geschlecht

*****5c
lab def FiveC 1 "Nicht zutreffend" 2 "Eher nicht zutreffend" 3 "Teils / Teils" 4 "Eher zutreffend" 5 "Voll zutreffend", replace
**Confidence
fre prki2einst1

cap drop confidence
gen confidence = prki2einst1
fre confidence
recode confidence (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1)
lab val confidence FiveC
fre confidence

**Complacency
fre prki2einst3

cap drop complacency
gen complacency = prki2einst3
fre complacency
recode complacency (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1)
lab val complacency FiveC
fre complacency

**Constraints
fre prki2einst6

cap drop constraints
gen constraints = prki2einst6
fre constraints
recode constraints (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1)
lab val constraints FiveC
fre constraints

**Calculation
fre prki2einst4

cap drop calculation
gen calculation = prki2einst4
fre calculation
recode calculation (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1)
lab val calculation FiveC
fre calculation

**Collective Responsibility
fre prki2einst5

cap drop collectiveresp
gen collectiveresp = prki2einst5
fre collectiveresp
recode collectiveresp (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1)
lab val collectiveresp FiveC
fre collectiveresp


*****Sampelregion
fre sampreg


*****Coronaerkrankung
fre v2
fre v2_pos_year
fre v2_pos_mon
fre v2_pos_mon if v2_pos_year == 2022
tab v2_pos_mon datm_n if v2_pos_year == 2021 & datj_n == 2021

cap drop Genesen_2021
gen Genesen_2021 = .
replace Genesen_2021 = 1 if datm_n - v2_pos_mon < 4 & v2_pos_year == 2021 & datj_n == 2021
tab Genesen_2021 v2_pos_mon if v2_pos_year == 2021

cap drop Genesen_2022
gen Genesen_2022 = .
replace Genesen_2022 = 1 if v2_pos_mon < 4 & v2_pos_year == 2022 & datj_n == 2022
tab Genesen_2022 v2_pos_mon if v2_pos_year == 2022

cap drop Genesen
gen Genesen = .
replace Genesen = 1 if Genesen_2021 == 1 | Genesen_2022 == 1
fre Genesen

tab Genesen v2, mis

cap drop PCRpos
gen PCRpos = 1
replace PCRpos = 2 if Genesen == 1 & Impfstatus_2 == 0
lab def PCRpos 1 "Kein positiver Test" 2 "Positiver Test", replace
lab val PCRpos PCRpos
fre PCRpos

tab PCRpos v2_pos_mon if v2_pos_year == 2021
tab PCRpos v2_pos_mon if v2_pos_year == 2022

fre v2
cap drop Infekt
recode v2 (1 = 1) (2 3 = 2), gen(Infekt)
lab def Infekt 2 "Kein positiver Test" 1 "Positiver Test", replace
lab val Infekt Infekt
fre Infekt


**********************************
keep pid hid kkz_rek phrf_full Geschlecht ror Raumordnungsregion			///
	 Impfstatus* PCRpos Infekt												///
	 casmin_einfach															///
	 HHinc																	///
	 GISD_ROR*																///
	 Alter  Altersgruppe_RKI Vorerkrankung									///
	 confidence complacency constraints calculation collectiveresp			///
	 sampreg																///


drop if Alter < 18	
drop if PCRpos == 2 
	 
compress

save /*"Arbeitsdaten_BA.dta"*/, replace
