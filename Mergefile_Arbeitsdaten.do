
********Daten anspielen
*****Fragebogen
use /*"CoMoBu Datensatz.dta"*/, clear

tempfile RKISOEP

save `RKISOEP', replace


*****Regiodaten
use /*"Regionaldaten.dta"*/

merge 1:m cid hid using `RKISOEP'

drop _merge

*Cleaning
fre frabo_gesamt
keep if frabo_gesamt == 1						//Fälle mit gültigem Fragebogen behalten
fre frabo_gesamt

save `RKISOEP', replace


*****Gewichte
use pid phrf_full using /*"Gewichte.dta"*/, clear

merge 1:m pid using `RKISOEP'

drop _merge

*Cleaning
fre frabo_gesamt
keep if frabo_gesamt == 1						//Fälle mit gültigem Fragebogen behalten
fre frabo_gesamt

save `RKISOEP', replace


*****Aus ppathl
use pid hid cid syear loc1989 migback using /*"ppathl.dta"*/, clear

keep if syear == 2020

merge 1:m pid hid using `RKISOEP'

drop _merge

*Cleaning
fre frabo_gesamt
keep if frabo_gesamt == 1						//Fälle mit gültigem Fragebogen behalten
fre frabo_gesamt

save `RKISOEP', replace


*****Aus bkpgen
use pid hid cid syear pgcasmin pgisced11 using /*"bkpgen.dta"*/, clear

keep if syear == 2020

merge 1:m pid hid using `RKISOEP'

drop _merge

*Cleaning
fre frabo_gesamt
keep if frabo_gesamt == 1						//Fälle mit gültigem Fragebogen behalten
fre frabo_gesamt

save `RKISOEP', replace


*****Aus hbrutto
use hid cid syear hhgr sampreg using /*"hbrutto.dta"*/, clear

keep if syear == 2020

merge 1:m hid using `RKISOEP'

drop _merge

*Cleaning
fre frabo_gesamt
keep if frabo_gesamt == 1						//Fälle mit gültigem Fragebogen behalten
fre frabo_gesamt

save `RKISOEP', replace


*****Aus bkpequiv
use pid hid cid syear d1110620 d1110720 h1110220 using /*"bkpequiv.dta"*/, clear

keep if syear == 2020

merge 1:m pid hid using `RKISOEP'

drop _merge

*Cleaning
fre frabo_gesamt
keep if frabo_gesamt == 1						//Fälle mit gültigem Fragebogen behalten
fre frabo_gesamt

save `RKISOEP', replace


*****Aus pl
use pid hid syear cid plh0333 using /*"pl.dta"*/, clear

keep if syear == 2018

drop syear

merge 1:m pid hid using `RKISOEP'

drop _merge

*Cleaning
fre frabo_gesamt
keep if frabo_gesamt == 1						//Fälle mit gültigem Fragebogen behalten
fre frabo_gesamt


save `RKISOEP', replace


*****Aus GISD-ROR
decode ror96, gen(Raumordnungsregion)

cap drop ror
gen ror = .
replace ror = 101 if Raumordnungsregion == "Schleswig-Holstein Mitte"
replace ror = 102 if Raumordnungsregion == "Schleswig-Holstein Nord"
replace ror = 103 if Raumordnungsregion == "Schleswig-Holstein Ost"
replace ror = 104 if Raumordnungsregion == "Schleswig-Holstein Sued"
replace ror = 105 if Raumordnungsregion == "Schleswig-Holstein Sued-West"
replace ror = 201 if Raumordnungsregion == "Hamburg"
replace ror = 301 if Raumordnungsregion == "Braunschweig"
replace ror = 302 if Raumordnungsregion == "Bremen-Umland"
replace ror = 303 if Raumordnungsregion == "Bremerhaven"
replace ror = 304 if Raumordnungsregion == "Emsland"
replace ror = 305 if Raumordnungsregion == "Goettingen"
replace ror = 306 if Raumordnungsregion == "Hamburg-Umland-Sued"
replace ror = 307 if Raumordnungsregion == "Hannover"
replace ror = 308 if Raumordnungsregion == "Hildesheim"
replace ror = 309 if Raumordnungsregion == "Lueneburg"
replace ror = 310 if Raumordnungsregion == "Oldenburg"
replace ror = 311 if Raumordnungsregion == "Osnabrueck"
replace ror = 312 if Raumordnungsregion == "Ost-Friesland"
replace ror = 313 if Raumordnungsregion == "Suedheide"
replace ror = 401 if Raumordnungsregion == "Bremen"
replace ror = 501 if Raumordnungsregion == "Aachen"
replace ror = 502 if Raumordnungsregion == "Arnsberg"
replace ror = 503 if Raumordnungsregion == "Bielefeld"
replace ror = 504 if Raumordnungsregion == "Bochum/Hagen"
replace ror = 505 if Raumordnungsregion == "Bonn"
replace ror = 506 if Raumordnungsregion == "Dortmund"
replace ror = 507 if Raumordnungsregion == "Duisburg/Essen"
replace ror = 508 if Raumordnungsregion == "Duesseldorf"
replace ror = 509 if Raumordnungsregion == "Emscher-Lippe"
replace ror = 510 if Raumordnungsregion == "Koeln"
replace ror = 511 if Raumordnungsregion == "Muenster"
replace ror = 512 if Raumordnungsregion == "Paderborn"
replace ror = 513 if Raumordnungsregion == "Siegen"
replace ror = 601 if Raumordnungsregion == "Mittelhessen"
replace ror = 602 if Raumordnungsregion == "Nordhessen"
replace ror = 603 if Raumordnungsregion == "Osthessen"
replace ror = 604 if Raumordnungsregion == "Rhein-Main"
replace ror = 605 if Raumordnungsregion == "Starkenburg"
replace ror = 701 if Raumordnungsregion == "Mittelrhein-Westerwald"
replace ror = 702 if Raumordnungsregion == "Rheinhessen-Nahe"
replace ror = 703 if Raumordnungsregion == "Rheinpfalz"
replace ror = 704 if Raumordnungsregion == "Trier"
replace ror = 705 if Raumordnungsregion == "Westpfalz"
replace ror = 801 if Raumordnungsregion == "Bodensee-Oberschwaben"
replace ror = 802 if Raumordnungsregion == "Donau-Iller (BW)"
replace ror = 803 if Raumordnungsregion == "Franken"
replace ror = 804 if Raumordnungsregion == "Hochrhein-Bodensee"
replace ror = 805 if Raumordnungsregion == "Mittlerer Oberrhein"
replace ror = 806 if Raumordnungsregion == "Neckar-Alb"
replace ror = 807 if Raumordnungsregion == "Nordschwarzwald"
replace ror = 808 if Raumordnungsregion == "Ostwuerttemberg"
replace ror = 809 if Raumordnungsregion == "Schwarzwald-Baar-Heuberg"
replace ror = 810 if Raumordnungsregion == "Stuttgart"
replace ror = 811 if Raumordnungsregion == "Suedlicher Oberrhein"
replace ror = 812 if Raumordnungsregion == "Unterer Neckar"
replace ror = 901 if Raumordnungsregion == "Allgaeu"
replace ror = 902 if Raumordnungsregion == "Augsburg"
replace ror = 903 if Raumordnungsregion == "Bayerischer Untermain"
replace ror = 904 if Raumordnungsregion == "Donau-Iller (BY)"
replace ror = 905 if Raumordnungsregion == "Donau-Wald"
replace ror = 906 if Raumordnungsregion == "Industrieregion Mittelfranken"
replace ror = 907 if Raumordnungsregion == "Ingolstadt"
replace ror = 908 if Raumordnungsregion == "Landshut"
replace ror = 909 if Raumordnungsregion == "Main-Rhoen"
replace ror = 910 if Raumordnungsregion == "Muenchen"
replace ror = 911 if Raumordnungsregion == "Oberfranken-Ost"
replace ror = 912 if Raumordnungsregion == "Oberfranken-West"
replace ror = 913 if Raumordnungsregion == "Oberland"
replace ror = 914 if Raumordnungsregion == "Oberpfalz-Nord"
replace ror = 915 if Raumordnungsregion == "Regensburg"
replace ror = 916 if Raumordnungsregion == "Suedostoberbayern"
replace ror = 917 if Raumordnungsregion == "Westmittelfranken"
replace ror = 918 if Raumordnungsregion == "Wuerzburg"
replace ror = 1001 if Raumordnungsregion == "Saar"
replace ror = 1101 if Raumordnungsregion == "Berlin"
replace ror = 1201 if Raumordnungsregion == "Havelland-Flaeming"
replace ror = 1202 if Raumordnungsregion == "Lausitz-Spreewald"
replace ror = 1203 if Raumordnungsregion == "Oderland-Spree"
replace ror = 1204 if Raumordnungsregion == "Prignitz-Oberhavel"
replace ror = 1205 if Raumordnungsregion == "Uckermark-Barnim"
replace ror = 1301 if Raumordnungsregion == "Mecklenburgische Seenplatte"
replace ror = 1302 if Raumordnungsregion == "Mittleres Mecklenburg/Rostock"
replace ror = 1303 if Raumordnungsregion == "Vorpommern"
replace ror = 1304 if Raumordnungsregion == "Westmecklenburg"
replace ror = 1401 if Raumordnungsregion == "Oberes Elbtal/Osterzgebirge"
replace ror = 1402 if Raumordnungsregion == "Oberlausitz-Niederschlesien"
replace ror = 1403 if Raumordnungsregion == "Suedsachsen"
replace ror = 1404 if Raumordnungsregion == "Westsachsen"
replace ror = 1501 if Raumordnungsregion == "Altmark"
replace ror = 1502 if Raumordnungsregion == "Anhalt-Bitterfeld-Wittenberg"
replace ror = 1503 if Raumordnungsregion == "Halle/S."
replace ror = 1504 if Raumordnungsregion == "Magdeburg"
replace ror = 1601 if Raumordnungsregion == "Mittelthueringen"
replace ror = 1602 if Raumordnungsregion == "Nordthueringen"
replace ror = 1603 if Raumordnungsregion == "Ostthueringen"
replace ror = 1604 if Raumordnungsregion == "Suedthueringen"
fre ror


save `RKISOEP', replace


use /*"GISD\Bund\Raumordnungsregion\Raumordnungsregion_long.dta"*/, clear

keep if Jahr == 2019

rename GISD_10 GISD_ROR_10
rename GISD_5 GISD_ROR_5
rename GISD_Score GISD_ROR_Score
rename Raumordnungsregion_Nr ror

keep ror GISD_ROR_10 GISD_ROR_5 GISD_ROR_Score

merge 1:m ror using `RKISOEP'

drop _merge


*****Auf doppelte Fälle prüfen
sort pid hid
cap drop dup
quietly by pid hid:  gen dup = cond(_N==1,0,_n)
fre dup



*****Variablen aussuchen
keep pid cid hid sample1 teilnahme_soep	pgebm geburt vargeburt syear	///Vars zur Rückverfolgung
	 phrf_full															///Gewichte
	 bula gisd_10 kkz_rek sampreg ror Raumordnungsregion GISD_ROR_*		///Regiodaten
	 psex ple0010_v2 pla0009_v2 alter loc1989							///Standarddemograpie
	 plh0171 ple0011 ple0189 ple0012 ple0013 ple0014 ple0015 ple0016 	///
	 ple0017 ple0018 ple0019 ple0020 ple0021 ple0022 ple0187 ple0040	///
	 hlk0095 pla0012 pld0149 pld0169 hhgr d1110620 d1110720 h1110220	///Haushalt
	 pbeh3 pbeh4 pbeh5 pbeh6 v2 ple0008 prki2ges01 v2_pos_day 			///
	 v2_pos_mon v2_pos_year												///Gesundeheit/Krankheit
	 plh0204_v2 plh0182 												///Zufriedenheit/Risiko
	 plb0022_v9 plb0568 												///Arbeit
	 pcovimpf_n prki2impf* prki2iabsi prki2ungei* prki2einst* 			///
	 pcovimpfa* prki2i2tag prki2i2mon prki2i2jahr						///Impfung
	 plh0011_v2 plh0012_v6 	plh0333										///Politik
	 ppolver* 															///Vertrauen Institutionen
	 psozsta2* prki2staat* 												///staatliche Verantwortung
	 plj0175 															///Migration
	 plj0071 plj0072 plj0073 											///Deutschkompetenzen
	 pfamst_n pfs072a pfs082a pfs092a pfs122a pfs132a 					///Familie/Tod
	 hlc0005_v2 														///Einkommen
	 prki2infor* prki2iqu* prki2iueb01 									///Informationen
	 datt_n datm_n datj_n 												///Datum
	 pgcasmin pgisced11	 												///Bildung
	 migback															///Migrationshintergrund
	 
*Missing recodieren
mvdecode _all , mv(-1  = .k \ -2 = .f \ -3 = .u \ -4 = .m \ -5 = .n \ -6 = .o \ -8 = .p)	//codiert Missings (MR)
compress	 

*Speichern
save /*"BA_Data_raw.dta"*/, replace