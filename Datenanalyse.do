use /*"Arbeitsdaten_BA.dta"*/, clear


********Deskriptive Analyse
tab Impfstatus_1 [aw = phrf_full]
tab Impfstatus_2 [aw = phrf_full]
tab Impfstatus_3 [aw = phrf_full]
			 

**Individuelle Ebene
*Bildung
tab casmin_einfach
tab casmin_einfach [aw = phrf_full]


tab casmin_einfach Impfstatus_2, row
tab casmin_einfach Impfstatus_2 [aw = phrf_full], row


*Reported
melogit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI ib2.Infekt c.HHinc i.casmin_einfach GISD_ROR_Score i.sampreg i.Vorerkrankung, or vce(robust) || ror:
table casmin_einfach if e(sample), statistic(mean Impfstatus_2) statistic(sd Impfstatus_2) statistic(n Impfstatus_2)
*


graph hbar Impfstatus_1 Impfstatus_2 [aw = phrf_full], over(casmin_einfach) intensity(50) blabel(bar, format(%4.2f)) asyvars

preserve
collapse (mean) mean2101 = Dat_Jan21 ///
		 (mean) mean2102 = Dat_Feb21 ///
		 (mean) mean2103 = Dat_Mar21 ///
		 (mean) mean2104 = Dat_Apr21 ///
		 (mean) mean2105 = Dat_May21 ///
		 (mean) mean2106 = Dat_Jun21 ///
		 (mean) mean2107 = Dat_Jul21 ///
		 (mean) mean2108 = Dat_Aug21 ///
		 (mean) mean2109 = Dat_Sep21 ///
		 (mean) mean2110 = Dat_Nov21 ///
		 (mean) mean2111 = Dat_Okt21 ///
		 (mean) mean2112 = Dat_Dez21 ///
		 (mean) mean2113 = Dat_Jan22 ///
		 (mean) mean2114 = Dat_Feb22 ///
		 (mean) mean2115 = Dat_Mar22 [aw = phrf_full], by(casmin_einfach)
reshape long mean, i(casmin_einfach) j(dat)
graph twoway (line mean dat if casmin_einfach == 1) ///
			 (line mean dat if casmin_einfach == 2) ///
			 (line mean dat if casmin_einfach == 3), ///
			 legend(row(1) order(1 "Niedrige Bildung" 2 "Mittlere Bildung" 3 "Hohe Bildung"))
restore


*Einkommen
sum HHinc [aw = phrf_full], det
sum HHinc [aw = phrf_full] if Impfstatus_1 == 0, det
sum HHinc [aw = phrf_full] if Impfstatus_1 == 1, det
sum HHinc [aw = phrf_full] if Impfstatus_2 == 0, det
sum HHinc [aw = phrf_full] if Impfstatus_2 == 1, det

graph hbar Impfstatus_2 [aw = phrf_full], by(GISD_10) intensity(50) blabel(bar, format(%4.2f)) asyvars


*Einkommen + Bildung
graph hbar HHinc [aw = phrf_full], over(casmin_einfach) by(Impfstatus_2) intensity(50) blabel(bar, format(%4.2f)) asyvars


*GISD
tab GISD_ROR_10 [aw = phrf_full]

graph bar Impfstatus_2 [aw = phrf_full], over(GISD_ROR_10) intensity(50) blabel(bar, format(%4.2f)) asyvars

*Reported
qui melogit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI ib2.Infekt c.HHinc i.casmin_einfach GISD_ROR_Score i.sampreg i.Vorerkrankung, or vce(robust) || ror:
table GISD_ROR_10 if e(sample), statistic(mean Impfstatus_2) statistic(sd Impfstatus_2) statistic(n Impfstatus_2)
preserve
statsby mean=r(mean) ub=r(ub) lb=r(lb) N=r(N) if e(sample), by(GISD_ROR_10) clear: ci mean Impfstatus_2
twoway bar mean GISD_ROR_10, color(gs12) barw(0.5) || rcap ub lb GISD_ROR_10 || lfit mean GISD_ROR_10, color(cranberry%50) lpatt(dash) legend(off) xlab(1(1)10) xscale(r(1 10)) ylab(0.75(0.05)1) yscale(r(0.75(0.05)1)) ytitle("Impfquote") xtitle("GISD Perzentile")
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Impfquote_GISD.png", as(png) replace
restore		 
*

*GISD + Bildung
graph bar Impfstatus_2 [aw = phrf_full], over(casmin_einfach) over(GISD_5) intensity(50) blabel(bar, format(%4.2f)) asyvars

qui melogit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI ib2.Infekt c.HHinc i.casmin_einfach GISD_ROR_Score i.sampreg i.Vorerkrankung, or vce(robust) || ror:
table GISD_ROR_10 casmin_einfach if e(sample), statistic(mean Impfstatus_2) statistic(sd Impfstatus_2) statistic(n Impfstatus_2)


preserve
collapse (mean) mean= Impfstatus_2 (sd) sd=Impfstatus_2 (count) n=Impfstatus_2 [aw = phrf_full], by(GISD_ROR_10 casmin_einfach)
gen hi = mean + invttail(n-1,0.025)*(sd / sqrt(n))
gen low = mean - invttail(n-1,0.025)*(sd / sqrt(n))

*graph bar mean, over(casmin_einfach) over(GISD) asyvars

cap drop gisdbild
gen gisdbild = casmin_einfach if GISD_ROR_10 == 1
replace gisdbild = casmin_einfach + 4 if GISD_ROR_10 == 2
replace gisdbild = casmin_einfach + 8 if GISD_ROR_10 == 3
replace gisdbild = casmin_einfach + 12 if GISD_ROR_10 == 4
replace gisdbild = casmin_einfach + 16 if GISD_ROR_10 == 5
replace gisdbild = casmin_einfach + 20 if GISD_ROR_10 == 6
replace gisdbild = casmin_einfach + 24 if GISD_ROR_10 == 7
replace gisdbild = casmin_einfach + 28 if GISD_ROR_10 == 8
replace gisdbild = casmin_einfach + 32 if GISD_ROR_10 == 9
replace gisdbild = casmin_einfach + 36 if GISD_ROR_10 == 10


sort gisdbild
list gisdbild casmin_einfach GISD_ROR_10, sepby(GISD_ROR_10)
graph twoway (bar mean gisdbild if casmin_einfach == 1) ///
			 (bar mean gisdbild if casmin_einfach == 2) ///
			 (bar mean gisdbild if casmin_einfach == 3) ///
			 (rcap hi low gisdbild), ///
			 legend(row(1) order(1 "Niedrige Bildung" 2 "Mittlere Bildung" 3 "Hohe Bildung")) ///
			 xlabel( 2 "1" 6 "2" 10 "3" 14 "4" 18 "5" 22 "6" 26 "7" 30 "8" 34 "9" 38 "10" , noticks) ///
			 xtitle("GISD") ytitle("Impfquote") ///
			 yscale(r(0.4 1)) ylabel(0.4(0.1)1, format(%4.2f)) 
restore


**GISD+Einkommen
twoway (scatter Impfstatus_2 HHinc if HHinc <= 10) ///
       (qfit Impfstatus_2 HHinc if HHinc <= 10) ///
	   (qfitci Impfstatus_2 HHinc if HHinc <= 10), by(GISD_ROR_10) xscale(r(0(1)10)) xlab(0(1)10)


********************************************************************************
********Explorative Analyse
**GLM, Singe-level logit
*Leeres Modell
logit Impfstatus_2 [pw = phrf_full]

*Modell 1, Einkommen und Bildung
logit Impfstatus_2 i.isced_einfach HHinc [pw = phrf_full], or

cap drop prob_m1
predict prob_m1, pr
twoway (line prob_m1 HHinc if isced_einfach == 1 & HHinc <= 20, sort) ///
	   (line prob_m1 HHinc if isced_einfach == 2 & HHinc <= 20, sort) ///
	   (line prob_m1 HHinc if isced_einfach == 3 & HHinc <= 20, sort), ///					
	   legend(order(1 "Niedrige Bildung" 2 "Mittlere Bildung" 3 "Hohe Bildung")) ///
	   xtitle("Haushaltsäquivalenzeinkommen in Euro") ytitle("Predicted Prob. 2. Impfung")
	   
logit Impfstatus_2 i.isced_einfach HHinc [pw = phrf_full], or coeflegend
	   
twoway (function y=invlogit(_b[HHinc]*x+_b[_cons]), range(-20 20)) ///
	   (function y=invlogit(_b[HHinc]*x+_b[2.isced_einfach]+_b[3.isced_einfach]+_b[_cons]), range(-20 20)), ///
	   legend(order(1 "Mittlere Bildung" 2 "Hohe Bildung")) ///
	   xtitle("Haushaltsäquivalenzeinkommen in Euro") ytitle("Predicted Prob. 2. Impfung") ///
	   xline(0)

	   
	   
**LRF, sinle-Level probit
probit Impfstatus_2 [pw = phrf_full]

*Modell 1, Einkommen und Bildung
qui melogit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI ib2.Infekt c.HHinc i.casmin_einfach GISD_ROR_Score i.sampreg i.Vorerkrankung, or vce(robust) || ror:
melogit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI ib2.Infekt c.HHinc i.casmin_einfach GISD_ROR_Score i.Vorerkrankung, vce(robust) || ror:
meprobit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI ib2.Infekt c.HHinc i.casmin_einfach GISD_ROR_Score i.Vorerkrankung if e(sample), vce(robust) || ror:


twoway (function y=invlogit(1.7882-.6224*x), range(-10 10)) ///
	   (function y=normal(1.1185-.3115*x), range(-10 10) lpatt(dash)), ///
	   legend(order(1 "Logit link" 2 "Probit Link")) ///
	   xtitle("GISD-Score") ytitle("P(Impfung)") ///
	   xline(0)
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Logit_vs_Probit.png", as(png) replace

	   
****Mixed-Effects random-intecept
**2. Impfung, einfache Modelle -> Haupttheorie
estimates clear
qui melogit Impfstatus_2 c.HHinc GISD_ROR_Score i.casmin_einfach, or || ror:

melogit Impfstatus_2 if e(sample), or vce(robust) || ror:
estat icc	   //Über 0.05 Threshold für substantial evidence of clustering Heck et . (2014)


melogit Impfstatus_2 HHinc i.casmin_einfach if e(sample), or vce(robust) || ror:
estat icc	  //kleiner, aber immer noch über Treshold
disp _b[_cons]/(1+_b[_cons]) //Person mit Niedriger Bildung und mean HHinc hat eine Wahrscheinlichkeit von 62.2% geimpft zu sein
estimates store me_impf2_1


melogit Impfstatus_2 GISD_ROR_Score if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_2


melogit Impfstatus_2 HHinc i.casmin_einfach GISD_ROR_Score if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_3


melogit Impfstatus_2 HHinc c.GISD_ROR_Score##i.casmin_einfach if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_4


melogit Impfstatus_2 c.GISD_ROR_Score##i.casmin_einfach if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_5


melogit Impfstatus_2 c.HHinc##c.GISD_ROR_Score i.casmin_einfach if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_6


esttab me_impf2_*, p 
esttab me_impf2_*, p eform
estimates stats me_impf2_*

esttab me_impf2_* using "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Grundmodelle_randomintercept.rtf", p eform compress replace


**Plots
melogit Impfstatus_2 HHinc c.GISD_ROR_Score##i.casmin_einfach if e(sample), or vce(robust) || ror:
coefplot, drop(_cons) xlabel(, grid) baselevels xline(0) ciopts(recast(rcap)) citop msymbol(D)


****weitere Modelle: Geschlecht, Altersgruppen
estimates clear
qui melogit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI HHinc i.casmin_einfach GISD_ROR_Score, or vce(robust) || ror:

estimates clear
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_1


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI HHinc i.casmin_einfach GISD_ROR_Score if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_2


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI c.HHinc c.GISD_ROR_Score##i.casmin_einfach if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_3


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI c.GISD_ROR_Score##i.casmin_einfach if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_4


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI c.GISD_ROR_Score##c.HHinc i.casmin_einfach if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_5


esttab me_impf2_*, p 
esttab me_impf2_*, p eform compress
estimates stats me_impf2_*

esttab me_impf2_* using "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Grundmodell_AgeSex_randomintercept.rtf", p eform compress replace


**Plots
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI c.HHinc c.GISD_ROR_Score##i.casmin_einfach if e(sample), or vce(robust) || ror:
coefplot, drop(_cons) xlabel(, grid) baselevels xline(0) ciopts(recast(rcap)) citop msymbol(D)



******Sampleregion als Kontrollvariable -> ausnehmen des Ost-West Effekts
estimates clear
qui melogit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI c.HHinc i.casmin_einfach GISD_ROR_Score i.sampreg, or vce(robust) || ror:


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI c.HHinc i.casmin_einfach GISD_ROR_Score i.sampreg, or vce(robust) || ror:
estat icc
estimates store me_impf2_1


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_2


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI c.HHinc i.casmin_einfach c.GISD_ROR_Score##c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_3


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_4


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI c.GISD_ROR_Score##c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_5


melogit Impfstatus_2 c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_6


esttab me_impf2_*, p 
esttab me_impf2_*, p eform compress
estimates stats me_impf2_*

esttab me_impf2_* using "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Grundmodell_SampReg_randomintercept.rtf", p eform compress replace


**Plots
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
coefplot, drop(_cons) xlabel(, grid) baselevels xline(0) ciopts(recast(rcap)) citop msymbol(D)



**********Vorerkrankung
estimates clear 
qui melogit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI i.Vorerkrankung c.HHinc i.casmin_einfach GISD_ROR_Score i.sampreg, or vce(robust) || ror:


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_1


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_2


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_3


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung c.GISD_ROR_Score##c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_4


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung c.HHinc i.casmin_einfach c.GISD_ROR_Score##c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estat icc
estimates store me_impf2_5



esttab me_impf2_*, p 
esttab me_impf2_*, p eform compress
estimates stats me_impf2_*

esttab me_impf2_* using "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Grundmodell_fullmodells_randomintercept.rtf", p eform compress replace



**Plots
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
coefplot, drop(_cons) xlabel(, grid) baselevels xline(0) ciopts(recast(rcap)) citop msymbol(D)


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
margins, at(GISD_ROR_Score=(0(0.1)1)) over(sampreg) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%20))


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
margins, at(GISD_ROR_Score=(0(0.1)1)) by(casmin_einfach) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15)) scheme(rkihc)


melogit Impfstatus_2 HHinc i.GISD_5##i.isced_einfach if e(sample), or vce(robust) || kkz_rek:
mchange GISD_5 isced_einfach, atmeans


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
margins, at(GISD_ROR_Score=(0.1(0.1)0.9)) dydx(casmin_einfach) atmeans
mplotoffset, horizontal offset(0.25) recast(scatter) xline(0, lcolor(red)) xscale(range()) yscale(reverse) plotopts(msymbol(D))


melogit Impfstatus_2 c.HHinc##i.GISD_5 i.isced_einfach if e(sample), or vce(robust) || kkz_rek:
margins, at(HHinc=(0(0.5)10)) by(GISD_5) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15))


melogit Impfstatus_2 c.HHinc##i.GISD_5 i.isced_einfach if e(sample), or vce(robust) || kkz_rek:
margins, at(GISD_5=(1(1)5)) dydx(HHinc) atmeans
mplotoffset, horizontal recast(scatter) xline(0, lcolor(red)) xscale(range()) yscale(reverse) plotopts(msymbol(D))


*melogit Impfstatus_2 c.HHinc##i.GISD_5 i.isced_einfach if e(sample), or vce(robust) || kkz_rek:
*margins, at(HHinc=(0(0.5)10)) by(GISD_5) atmeans
*marginsplot, recast(line) recastci(rarea) ciopt(color(%15))
*
*
*melogit Impfstatus_2 c.HHinc##i.GISD_5 i.isced_einfach if e(sample), or vce(robust) || kkz_rek:
*margins, at(GISD_5=(1(1)5)) dydx(HHinc) atmeans
*mplotoffset, horizontal recast(scatter) xline(0, lcolor(red)) xscale(range()) yscale(reverse) plotopts(msymbol(D))


xtmelogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg, or coeflegend|| ror:

twoway (function y=invlogit(_b[_cons]+_b[HHinc]*x), range(-20 20)) ///
	   (function y=invlogit((_b[_cons]+.31518)+_b[HHinc]*x), range(-20 20) lpatt(dash) lcolor(grey%30)) ///
	   (function y=invlogit((_b[_cons]-.31518)+_b[HHinc]*x), range(-20 20) lpatt(dash) lcolor(grey%30)), ///
	   legend(order(1 "Random-Intercept Multilevel-Logit-Fit")) ///
	   xtitle("Haushaltsäquivalenzeinkommen in Euro * 1000") ytitle("Predicted Prob. 2. Impfung") ///
	   xline(0) scheme(rkihc)

	   
****Modelle zur Analyse
estimates clear
qui melogit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI ib2.Infekt c.HHinc i.casmin_einfach GISD_ROR_Score i.sampreg i.Vorerkrankung, or vce(robust) || ror:


melogit Impfstatus_2 c.HHinc i.casmin_einfach if e(sample), or vce(robust) || ror:	   
estimates store fullmodel_1
	

melogit Impfstatus_2 GISD_ROR_Score if e(sample), or vce(robust) || ror:	   
estimates store fullmodel_2  
	   
	   
melogit Impfstatus_2 c.HHinc i.casmin_einfach GISD_ROR_Score if e(sample), or vce(robust) || ror:	   
estimates store fullmodel_3


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc i.casmin_einfach GISD_ROR_Score if e(sample), or vce(robust) || ror:	   
estimates store fullmodel_4 


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estimates store fullmodel_5


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
estimates store fullmodel_6 


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:	   
estimates store fullmodel_7


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:	   
estimates store fullmodel_8
estat icc


esttab fullmodel_*, p 
esttab fullmodel_*, p eform compress
estimates stats fullmodel_*

	   
esttab fullmodel_* using "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Modelle_Analyse.rtf", p eform compress replace	   	  


**********Plots für Abbildungen
**Einkommen
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:	
margins, at(HHinc=(0(0.5)8)) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15)) title("") ytitle("Marginaler Vorhergesagter Mittelwert") xtitle("Haushaltsäquivalenzeinkommen * 1000")
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Marginsplot_Einkommen.png",  as(png) replace


margins, at(HHinc=(0.5(0.5)8)) dydx(HHinc) atmeans
marginsplot, recast(scatter) recastci(rcap) ciopt(color(%90)) scheme(rkihc) yline(0) title("") ytitle("Effekt auf vorhergesagten Mittelwert") xtitle("Haushaltsäquivalenzeinkommen * 1000")
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\MarginalEffects_Einkommen.png",  as(png) replace




**Bildung
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:	
margins casmin_einfach, atmeans
marginsplot, recast(scatter) ciopt(color(%90)) scheme(rkihc) xscale(range(0.825 3.125)) title("") ytitle("Marginaler Vorhergesagter Mittelwert") xtitle("Bildung")
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Marginsplot_Bildung.png",  as(png) replace


margins r.casmin_einfach, atmeans
marginsplot, recast(scatter) recastci(rcap) ciopt(color(%90)) yline(0) yscale(r(0.1 -0.01)) xscale(range(1.925 3.125)) title("") ytitle("Kontrast des Marginalen Vorhergesagten Mittelwert") xtitle("")
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Contrast_Bildung.png",  as(png) replace


margins, dydx(casmin_einfach) atmeans
marginsplot, recast(scatter) recastci(rcap) ciopt(color(%90)) scheme(rkihc) xscale(r(0.825 2.125)) yline(0) yscale(r(0.1 -0.01)) title("") ytitle("Effekt auf vorhergesagten Mittelwert") xtitle("Bildung") xlab(1 "Mittlere Bildung" 2 "Hohe Bildung")
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\MarginalEffects_Bildung.png",  as(png) replace



**GISD over sampreg
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:		  
	
margins sampreg, at(GISD_ROR_Score=(0(0.1)1)) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15)) scheme(rkihc) title("") ytitle("P(Impfung)") xtitle("GISD-Score") plot(, label("Westdeutschland" "Ostdeutschland"))
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Marginsplot_GISD_OW.png",  as(png) replace


margins r.sampreg, at(GISD_ROR_Score=(0(0.1)1)) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15)) yline(0) title("") ytitle("Kontrast des Marginalen Vorhergesagten Mittelwert") xtitle("GISD-Score")
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Contrast_GISD_OW.png",  as(png) replace


margins, at(GISD_ROR_Score=(0(0.1)1)) dydx(sampreg) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15)) scheme(rkihc) yline(0) title("") ytitle("Differenz P(Impfung) zu Westdeutschland") xtitle("GISD-Score")
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\MarginalEffects_GISD_OW.png",  as(png) replace



**Bildung + GISD
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:	

margins casmin_einfach, at(GISD_ROR_Score=(0(0.1)1)) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%5)) scheme(rkihc) title("") ytitle("P(Impfung)") xtitle("GISD-Score") plot(, label("Niedrige Bildung ""Mittlere Bildung" "Hohe Bildung"))
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Marginsplot_GISD_Bildung.png",  as(png) replace


margins r.casmin_einfach, at(GISD_ROR_Score=(0(0.1)1)) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15)) scheme(rkihc) yline(0) title("") ytitle("Kontrast des Marginalen Vorhergesagten Mittelwert") xtitle("GISD-Score")  plot(, label("Niedrige Bildung vs. Mittlere Bildung" "Niedrige Bildung vs. Hohe Bildung")) 
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Contrast_GISD_Bildung.png",  as(png) replace


margins, at(GISD_ROR_Score=(0(0.1)1)) dydx(casmin_einfach) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%10)) scheme(rkihc) yline(0) title("") ytitle("Differenz P(Impfung) zu Niedriger Bildung") xtitle("GISD-Score") plot(, label("Mittlere Bildung" "Hohe Bildung"))
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\MarginalEffects_GISD_Bildung.png",  as(png) replace


**********Predictions
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg, or vce(robust) || ror:	 

cap drop p_log
predict p_log

cap drop pred_log
gen pred_log = .
replace pred_log = 0 if p_log <= 0.5
replace pred_log = 1 if p_log > 0.5

tab pred_log Impfstatus_2

twoway (function y=x, color(cranberry)) ///
	   (scatter Impfstatus_2 p_log) ///
	   (lowess Impfstatus_2 p_log), ///
	   ytitle("Tatsächliche Impfwahrscheinlichkeit") xtitle("Vorhergesagte Impfwahrscheinlichkeit") ///
	   legend(row(1) order(3 "Logit Model")) scheme(rkihc)
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\ModelFit_Logit.png", as(png) replace
	   
	   
	   
**********Model-Fit
xtmelogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg, or coeflegend || ror:

twoway (function y=invlogit(_b[_cons]+_b[GISD_ROR_Score]*x), range(-5 5)) ///
	   (function y=invlogit((_b[_cons]+.2571)+_b[GISD_ROR_Score]*x), range(-5 5) lpatt(dash) lcolor(black%30)) ///
	   (function y=invlogit((_b[_cons]-.2571)+_b[GISD_ROR_Score]*x), range(-5 5) lpatt(dash) lcolor(black%30)) ///
	   (function y=invlogit(_b[_cons]+_b[2.sampreg#c.GISD_ROR_Score]*x), range(-5 5)) ///
	   (function y=invlogit((_b[_cons]+.2571)+_b[2.sampreg#c.GISD_ROR_Score]*x), range(-5 5) lpatt(dash) lcolor(black%30)) ///
	   (function y=invlogit((_b[_cons]-.2571)+_b[2.sampreg#c.GISD_ROR_Score]*x), range(-5 5) lpatt(dash) lcolor(black%30)), ///
	   legend(order(1 "Westdeutschland" 4 "Ostdeutschland")) ///
	   xtitle("GISD-Score") ytitle("Predicted Prob. 2. Impfung") ///
	   xline(0) scheme(rkihc) xscale(r(-5 5))
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\ModelFit.png",  as(png) replace


**********Ost vs. West Modelle
estimates clear
qui melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score if sampreg == 1, or vce(robust) || ror:
estimates store OW_West_1

qui melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach if sampreg == 1 & e(sample), or vce(robust) || ror:
estimates store OW_West_2


qui melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score if sampreg == 2, or vce(robust) || ror:
estimates store OW_Ost_1

qui melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach if sampreg == 2 & e(sample), or vce(robust) || ror:
estimates store OW_Ost_2


esttab OW_*, p eform compress
esttab OW_*, ci eform compress
esttab OW_* using "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\OstWest_Analyse.rtf", p eform compress replace	


coefplot (OW_West_1, label(West)) (OW_Ost_1, label(Ost)), eform drop(_cons) xline(1) xtitle("Odds-Ratio") ylabel(1 "Weiblich (vs. Männlich)" ///
				2 "18-29 Jahre (vs. 65+ Jahre)" ///
				3 "30 - 44 Jahre" ///
				4 "45 - 64 Jahre" ///
				5 "Vorerkrankung (vs. keine Vorerkrankung)" ///
				6 "Coronainfektion (vs. keine Infektion)" ///
				7 "Äquivalenzeinkommen" ///
				8 "Mittlere Bildung (vs. Niedrige Bildung)" ///
				9 "Hohe Bildung" ///
				10 "GISD-Score")
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Coef_OW.png", as(png) replace


coefplot (OW_West_2, label(Westdeutschland)) (OW_Ost_2, label(Ostdeutschland)), eform drop(_cons) xline(1) xtitle("Odds-Ratio") 
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Coef_OW_Interaction.png", as(png) replace



**********Random Slopes als extra, da nicht über me nur in Anhang reporten
estimates clear
qui melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg, or vce(robust) || ror:
est store RS_1

qui meqrlogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg, or|| ror:
est store RS_2

qui melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg, or vce(robust) || ror:
est store RS_ohne

qui meqrlogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg, or|| ror: R.casmin_einfach, difficult
est store RS_mit


esttab RS_*, p eform compress
esttab RS_* using "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\RandomSlopes_Analyse.rtf", p eform compress replace	


coefplot (RS_ohne, label(Kein RS)) (RS_mit, label(RS)), drop(_cons) xline(0) xtitle("Logg-Odds") ///
		 ylabel(1 "Weiblich (vs. Männlich)" ///
				2 "18-29 Jahre (vs. 65+ Jahre)" ///
				3 "30 - 44 Jahre" ///
				4 "45 - 64 Jahre" ///
				5 "Vorerkrankung (vs. keine Vorerkrankung)" ///
				6 "Coronainfektion (vs. keine Infektion)" ///
				7 "Äquivalenzeinkommen" ///
				8 "GISD-Score" ///
				9 "Mittlere Bildung (vs. Niedrige Bildung)" ///
				10 "Hohe Bildung" ///
				11 "Mittlere Bildung X GISD" ///
				12 "Hohe Bildung X GISD" ///
				13 "Ostdeutschland (vs. Westdeutschland)" ///
				14 "GISD X Ostdeutschland")
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\Coef_RandomSlopes.png", as(png) replace



***********Linear Prediction Model
**Lowess
graph twoway (scatter Impfstatus_2 HHinc) ///
			 (lowess Impfstatus_2 HHinc) 

graph twoway (scatter Impfstatus_2 casmin_einfach) ///
			 (lowess Impfstatus_2 casmin_einfach)

graph twoway (scatter Impfstatus_2 GISD_ROR_Score) ///
			 (lowess Impfstatus_2 GISD_ROR_Score), by(sampreg)			 
			 

***Modell
graph twoway (scatter Impfstatus_2 HHinc, jitter(40) msize(tiny)) ///
			 (lfit Impfstatus_2 HHinc, color(cranberry))
			 
graph twoway (scatter Impfstatus_2 casmin_einfach, jitter(40) msize(tiny)) ///
			 (lfit Impfstatus_2 casmin_einfach, color(cranberry)) 

graph twoway (scatter Impfstatus_2 GISD_ROR_Score, jitter(40) msize(tiny)) ///
			 (lfit Impfstatus_2 GISD_ROR_Score, color(cranberry)), by(sampreg) 

estimates clear
qui melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg, or vce(robust) || ror:
est store RS_ohne
	 
mixed Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), vce(robust)|| ror:
est store linprob_1

margins, at(GISD_ROR_Score=(0(0.1)1)) over(sampreg) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%20)) yline(0)


mixed Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), vce(robust)|| ror:
est store linprob_2

margins casmin_einfach, at(GISD_ROR_Score=(0(0.1)1)) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15)) yline(0) scheme(rkihc)

margins, at(GISD_ROR_Score=(0(0.1)1)) dydx(casmin_einfach) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15)) yline(0) scheme(rkihc)


esttab linprob_*, p compress
esttab linprob_* using "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\LinProb_Analyse.rtf", p eform compress replace


********Vegleich des Datenfits
mixed Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), vce(robust)|| ror:

cap drop p_lin
predict p_lin

cap drop pred_lin
gen pred_lin = .
replace pred_lin = 0 if p_lin <= 0.5
replace pred_lin = 1 if p_lin > 0.5

tab pred_lin Impfstatus_2

twoway (function y=x, color(cranberry)) ///
	   (scatter Impfstatus_2 p_log) ///
	   (lowess Impfstatus_2 p_log) ///
	   (scatter Impfstatus_2 p_lin) ///
	   (lowess Impfstatus_2 p_lin), ///
	   ytitle("Tatsächliche Impfwahrscheinlichkeit") xtitle("Vorhergesagte Impfwahrscheinlichkeit") ///
	   legend(row(1) order(3 "Logit Model" 5 "Linear Probability Model")) xline(1)
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\ModelFit_LinProb.png", as(png) replace




************5C Analyse
estimates clear
qui melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg confidence complacency constraints calculation collectiveresp, or vce(robust) || ror:


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
est store fiveC_1


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg confidence if e(sample), or vce(robust) || ror:
est store fiveC_2


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg complacency if e(sample), or vce(robust) || ror:
est store fiveC_3


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg i.constraints if e(sample), or vce(robust) || ror:
est store fiveC_4


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg calculation if e(sample), or vce(robust) || ror:
est store fiveC_5


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg collectiveresp if e(sample), or vce(robust) || ror:
est store fiveC_6


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc i.casmin_einfach c.GISD_ROR_Score##i.sampreg confidence complacency constraints calculation collectiveresp if e(sample), or vce(robust) || ror:
est store fiveC_7


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:
est store fiveC_8


melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg confidence complacency constraints calculation collectiveresp if e(sample), or vce(robust) || ror:
est store fiveC_9


esttab fiveC_*, p eform compress
esttab fiveC_* using "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\5C_Analyse.rtf", p eform compress replace


********Vegleich des Datenfits
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung i.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg confidence complacency constraints calculation collectiveresp if e(sample), or vce(robust) || ror:

cap drop p_5C
predict p_5C

cap drop pred_5C
gen pred_5C = .
replace pred_5C = 0 if p_5C <= 0.5
replace pred_5C = 1 if p_5C > 0.5

tab pred_5C Impfstatus_2

twoway (function y=x, color(cranberry)) ///
	   (scatter Impfstatus_2 p_log) ///
	   (lowess Impfstatus_2 p_log) ///
	   (scatter Impfstatus_2 p_5C) ///
	   (lowess Impfstatus_2 p_5C), ///
	   ytitle("Tatsächliche Impfwahrscheinlichkeit") xtitle("Vorhergesagte Impfwahrscheinlichkeit") ///
	   legend(row(1) order(3 "Ohne 5C" 5 "Mit 5C"))
graph export "S:\Projekte\Abt2_Daten_ID0059\Projekte\ReisM\BA\Grafiken_Tabellen\ModelFit_5C.png", as(png) replace


		 
		 