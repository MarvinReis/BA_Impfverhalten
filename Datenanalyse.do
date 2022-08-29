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


*Einkommen
sum HHinc, det
sum HHinc [aw = phrf_full], det

sum HHinc if Impfstatus_2 == 0, det
sum HHinc if Impfstatus_2 == 1, det
sum HHinc [aw = phrf_full] if Impfstatus_2 == 0, det
sum HHinc [aw = phrf_full] if Impfstatus_2 == 1, det


*GISD
tab GISD_ROR_10
tab GISD_ROR_10 [aw = phrf_full]

tab GISD_ROR_10 Impfstatus_2
tab GISD_ROR_10 Impfstatus_2 [aw = phrf_full], row


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
*Reported
qui melogit Impfstatus_2 i.Geschlecht i.Altersgruppe_RKI ib2.Infekt c.HHinc i.casmin_einfach GISD_ROR_Score i.sampreg i.Vorerkrankung, or vce(robust) || ror:
table GISD_ROR_10 casmin_einfach if e(sample), statistic(mean Impfstatus_2) statistic(sd Impfstatus_2) statistic(n Impfstatus_2)
*


********************************************************************************
********Explorative Analyse
*Vegleich der Schätzungsmethoden (GLM vs. LRF)
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
***Reported Models
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

	   
esttab fullmodel_* using /*"Modelle_Analyse.rtf"*/, p eform compress replace	   	  


**********Plots für Abbildungen
**GISD over sampreg
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:		  
	
margins sampreg, at(GISD_ROR_Score=(0(0.1)1)) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15)) scheme(rkihc) title("") ytitle("P(Impfung)") xtitle("GISD-Score") plot(, label("Westdeutschland" "Ostdeutschland"))
graph export /*"Marginsplot_GISD_OW.png"*/,  as(png) replace

margins, at(GISD_ROR_Score=(0(0.1)1)) dydx(sampreg) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%15)) scheme(rkihc) yline(0) title("") ytitle("Differenz P(Impfung) zu Westdeutschland") xtitle("GISD-Score")
graph export /*"MarginalEffects_GISD_OW.png"*/,  as(png) replace



**Bildung + GISD
melogit Impfstatus_2 i.Geschlecht ib4.Altersgruppe_RKI i.Vorerkrankung ib2.Infekt c.HHinc c.GISD_ROR_Score##i.casmin_einfach c.GISD_ROR_Score##i.sampreg if e(sample), or vce(robust) || ror:	

margins casmin_einfach, at(GISD_ROR_Score=(0(0.1)1)) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%5)) scheme(rkihc) title("") ytitle("P(Impfung)") xtitle("GISD-Score") plot(, label("Niedrige Bildung ""Mittlere Bildung" "Hohe Bildung"))
graph export /*"Marginsplot_GISD_Bildung.png"*/,  as(png) replace

margins, at(GISD_ROR_Score=(0(0.1)1)) dydx(casmin_einfach) atmeans
marginsplot, recast(line) recastci(rarea) ciopt(color(%10)) scheme(rkihc) yline(0) title("") ytitle("Differenz P(Impfung) zu Niedriger Bildung") xtitle("GISD-Score") plot(, label("Mittlere Bildung" "Hohe Bildung"))
graph export /*"MarginalEffects_GISD_Bildung.png"*/,  as(png) replace


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
graph export /*"ModelFit_Logit.png"*/, as(png) replace
	   

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
esttab OW_* using /*"OstWest_Analyse.rtf"*/, p eform compress replace	


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
graph export /*"Coef_OW.png"*/, as(png) replace


coefplot (OW_West_2, label(Westdeutschland)) (OW_Ost_2, label(Ostdeutschland)), eform drop(_cons) xline(1) xtitle("Odds-Ratio") 
graph export /*"Coef_OW_Interaction.png"*/, as(png) replace



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
esttab RS_* using /*"RandomSlopes_Analyse.rtf"*/, p eform compress replace	


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
graph export /*"Coef_RandomSlopes.png"*/, as(png) replace



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
esttab linprob_* using /*"LinProb_Analyse.rtf"*/, p eform compress replace


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
graph export /*"ModelFit_LinProb.png"*/, as(png) replace


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
esttab fiveC_* using /*"5C_Analyse.rtf"*/, p eform compress replace

		 
		 