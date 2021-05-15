clear all
set more off


*===============*
*	stats.do    *
*===============*

/*

*This dofile:
1) Descriptive Statistics
	1.1) Plot scores
	1.2) Plot gap scores
2) Runs regressions
3) Placebo Tests


=====================================*/


*Dir structure

cd "C:/Users/juanc/Google Drive/research/student-strike"
loc data = "C:/research/student-strike/data"
loc db = "`data'/analytical/db-panel.dta"



*======================================


use `db', clear


*======================================





/*=======================================
		1) Descriptive Statistics
========================================*/




*1.1) Grafico con brecha de scores

*MATH
preserve

	table public year [aw=mweight], c(mean log_mscore) replace
	twoway  (connected table1 year if public == 0)  ///
	 		(connected table1 year if public == 1), ///
	 		xlabel(2016(1)2019) 					///
	 		legend(label(1 "Private") 				///
				   label( 2 "Public"))				///
			ytitle("Mean log Math Score")
	graph export "output/figures/scores_math.pdf", replace		

restore

*LANG
preserve

	table public year [aw=lweight], c(mean log_lscore) replace
	twoway  (connected table1 year if public == 0)  ///
			(connected table1 year if public == 1), ///
			xlabel(2016(1)2019) 					///
			legend(label(1 "Private") 				///
				   label( 2 "Public"))				///
			ytitle("Mean log Lang Score")
	graph export "output/figures/scores_lang.pdf", replace		
restore




*=============================================================



*1.2) graficos de la diferencia de scores publico y privado

*uso auxs para generar el score publico y privado en las dos obs de cada año
*y luego dropeo una obs por año


*MATH

preserve

	table public year [aw=mweight], c(mean log_mscore) replace
	
	
	bysort year: egen aux 		= total(table1) if public == 0
	bysort year: egen privscore = total(aux)
	
	bysort year: egen aux2 		= total(table1) if public == 1
	bysort year: egen pubscore  = total(aux2)
	
	drop aux aux2 table1
	
	gen diffscore = privscore - pubscore
	
	drop if public == 0
	drop public
	
	twoway  (connected diffscore year),  				///
	 		xlabel(2016(1)2019) 						///
	 		legend(label(1 "Score (Priv-Pub)")) 		///
			ytitle("Mean log Math Score gap")	///
			ylabel(0.05(0.05)0.25)
	
	graph export "output/figures/gap_math.pdf", replace

restore




*MATH by region


preserve


	collapse (mean) log_mscore [aw=mweight], by(region year public)
	
	
	bysort region year: egen aux 		= total(log_mscore) if public == 0
	bysort region year: egen privscore = total(aux)
	
	bysort region year: egen aux2 		= total(log_mscore) if public == 1
	bysort region year: egen pubscore  = total(aux2)
	
	drop aux aux2 log_mscore
	
	gen diffscore = privscore - pubscore
	
	drop if public == 0
	drop public
	
	twoway  (connected diffscore year if region == 2)  	/// CABA
			(connected diffscore year if region == 6) 	/// PBA
			(connected diffscore year if region == 22) 	/// CHACO
			(connected diffscore year if region == 54) 	/// MISIONES
			(connected diffscore year if region == 10)  /// CATAMARCA
			(connected diffscore year if region == 14)  /// CORDOBA
			(connected diffscore year if region == 50)  /// MENDOZA
			(connected diffscore year if region == 74), /// SAN LUIS
	 		xlabel(2016(1)2019) 						///
	 		legend(label(1 "CABA")						///
	 			   label(2 "PBA")	 					///
	 			   label(3 "Chaco") 					///
	 			   label(4 "Misiones") 					///
	 			   label(5 "Catamarca") 				///
	 			   label(6 "Cordoba") 					///
	 			   label(7 "Mendoza")					///
	 			   label(8 "San Luis"))					///
			ytitle("Mean log Math Score gap")			///
			ylabel(0.05(0.025)0.175)
	
	graph export "output/figures/gap_math_region.pdf", replace

restore





*LANG


preserve

	table public year [aw=lweight], c(mean log_lscore) replace
	
	
	bysort year: egen aux 		= total(table1) if public == 0
	bysort year: egen privscore = total(aux)
	
	bysort year: egen aux2 		= total(table1) if public == 1
	bysort year: egen pubscore  = total(aux2)
	
	drop aux aux2 table1
	
	gen diffscore = privscore - pubscore
	
	drop if public == 0
	drop public
	
	twoway  (connected diffscore year),  				///
	 		xlabel(2016(1)2019) 						///
	 		legend(label(1 "Score (Priv-Pub)")) 		///
			ytitle("Mean log Lang Score gap")	///
			ylabel(0.05(0.05)0.25)
	
	graph export "output/figures/gap_lang.pdf", replace

restore



*LANG by region


preserve


	collapse (mean) log_lscore [aw=lweight], by(region year public)
	
	
	bysort region year: egen aux 		= total(log_lscore) if public == 0
	bysort region year: egen privscore = total(aux)
	
	bysort region year: egen aux2 		= total(log_lscore) if public == 1
	bysort region year: egen pubscore  = total(aux2)
	
	drop aux aux2 log_lscore
	
	gen diffscore = privscore - pubscore
	
	drop if public == 0
	drop public
	
	twoway  (connected diffscore year if region == 2)  	/// CABA
			(connected diffscore year if region == 6) 	/// PBA
			(connected diffscore year if region == 22) 	/// CHACO
			(connected diffscore year if region == 54) 	/// MISIONES
			(connected diffscore year if region == 10)  /// CATAMARCA
			(connected diffscore year if region == 14)  /// CORDOBA
			(connected diffscore year if region == 50)  /// MENDOZA
			(connected diffscore year if region == 74), /// SAN LUIS
	 		xlabel(2016(1)2019) 						///
	 		legend(label(1 "CABA")						///
	 			   label(2 "PBA")	 					///
	 			   label(3 "Chaco") 					///
	 			   label(4 "Misiones") 					///
	 			   label(5 "Catamarca") 				///
	 			   label(6 "Cordoba") 					///
	 			   label(7 "Mendoza")					///
	 			   label(8 "San Luis"))					///
			ytitle("Mean log Lang Score gap")			///
			ylabel(0.05(0.025)0.175)
	
	graph export "output/figures/gap_lang_region.pdf", replace

restore









/*=======================================
	2) Run Regressions
========================================*/


*Sample selection

use `db', clear

keep if region == 2 /// CABA


*Remark: Stata dropea PUBLIC porque no puede separar el school fixed effect 
*			del public effect (ya que ambos son time-invariant). Implícitamente,
*			el efecto de public esta adentro del school FE. Creo que no es un 
*			problema, ya que a mi me importa el efecto de la interaccion y no 
*			el efecto de Public en si.

areg log_lscore strike public woman foreign child educ_mother  		///
 				work kinder repeated i.year [w=lweight], 			///
 				abs(idschool) vce(cluster idclass) 


areg log_mscore strike public woman foreign child educ_mother  		///
 				work kinder repeated i.year [w=mweight], 			///
 				abs(idschool) vce(cluster idclass) 







