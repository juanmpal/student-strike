set more off
clear all

/*=====================
 	prepare-panel.do
========================

This do file:

1) Makes panel of 2016/2017/2019 DBs
2) Generates treatment variable

==============================*/

*Dir Structure
cd 				"C:/Users/juanc/Google Drive/research/student-strike"
loc data 	= 	"C:/research/student-strike/data"
loc db2016 	= 	"`data'/analytical/db2016.dta"
loc db2017 	= 	"`data'/analytical/db2017.dta"
loc db2019 = "`data'/analytical/db2019.dta"




/*================================
		1) Panel creation
==================================*/


append using `db2016' `db2017'  `db2019'



/*================================
		2.5) Schools on strike
==================================*/


gen strike = 0
replace strike = 1 if ///
	year == 2017 & ///
	(idschool == 20069600 | idschool == 20151200 | idschool == 20056900 |  ///
	 idschool == 20147500 | idschool == 20050000 | idschool == 29000800 |  ///
	 idschool == 20086600 | idschool == 29000500 | idschool == 20119800 |  ///					
	 idschool == 20058400 | idschool == 20019200 | idschool == 20124400 |  ///
	 idschool == 20015200 | idschool == 20035000 | idschool == 20104100 |  ///
	 idschool == 20071700 | idschool == 20076400 | idschool == 20089500 |  ///
	 idschool == 20070800 | idschool == 20083500 | idschool == 20124500 |  ///
	 idschool == 20132800 | idschool == 20135200 | idschool == 20244200 |  ///
	 idschool == 20040100 | idschool == 20016300 | idschool == 20250400 )  ///
	


save "`data'/analytical/db-panel.dta", replace


