set more off
clear all

/*=================
 	prepare2017.do
===================

*This do file
1- Merges student with principal base
2- Generates variables of interest

Remark: 2016 and 2017 dbs were already processed for a previous project and
couldn't recover the raw, original ones. So for those two cases I start from
an intermediate db and accustom them to this project

====================================*/


*Directory structure
cd "C:/Users/juanc/Google Drive/research/student-strike"
loc data = "C:/research/student-strike/data"
loc db_merge = "`data'/raw/principal-student-2017.dta"


/*=======================================
	1) Merge Student with Principal DBs
			(Only for 2019)
========================================*/

*not for this year



/*=======================================
		2) Variable Creation
========================================*/
/*

2.1) Test Scores
2.2) Identifiers
2.3) Socioeconomic variables
2.4) Weights

*/

use `db_merge', clear

/*====================
	2.1) Test Scores
======================*/

gen mscore = mpuntaje
gen lscore = lpuntaje

*(Log) Test Scores

* Lengua
gen log_lscore = log(lpuntaje)

* Matematica
gen log_mscore = log(mpuntaje)


label define leng2 1"Por debajo de nivel basico" 2"Nivel Basico" ///
	3"Nivel Satisfactorio" 4"Nivel Avanzado"
label values ldesemp leng2

label define mate2 1"Por debajo de nivel basico" 2"Nivel Basico" ///
	3"Nivel Satisfactorio" 4"Nivel Avanzado"
label values mdesemp mate2




*Standardized Test Scores

* Lengua
gen lscore_std = .
replace lscore_std = lscore / 880

* Matematica
gen mscore_std = .
replace mscore_std = mscore / 880





/*================================
		2.2) Identifiers
==================================*/


gen year = 2017

*encode cueanexo, gen(idschool)
gen idschool = cueanexo
encode claveseccion, gen(idclass)

bysort idclass: gen idstudent = _n

*rename region region_old
gen region = cod_provincia
*encode cod_provincia, gen(region)





/*================================
	2.3) Socioeconomic variables
==================================*/



*private (vs public school)
gen 	public = .
replace public = 1 if sector == 1
replace public = 0 if sector == 2

*urban (vs rural school)
gen 	urban = .
replace urban = 0 if ambito == 2
replace urban = 1 if ambito == 1


*dummy woman
gen 	woman = 0 if ap2 == 1
replace woman = 1 if ap2 == 2


*foreign
*0=Argentina, 1=Any other country
gen 	foreign = .
replace foreign = 0 if ap3a==1
replace foreign = 1 if ap3a>1 & ap3a<=8

label define foreign 0 "Argentine" 1 "Foreign"
label values foreign foreign



*child: if has any child
gen 	child = .
replace child = 0 if ap13 == 2
replace child = 1 if ap13 == 1


*internet: if has internet connection at home
*rename internet internet_old
gen 	internet = .
// replace internet = 0 if ap11_08 == 2
// replace internet = 1 if ap11_08 == 1


*internet_phone: if can access internet through internet_phone
gen 	  internet_phone = .
// replace   internet_phone = 0 if ap13 == 2
// replace   internet_phone = 1 if ap13 == 1
// label var internet_phone "If can access internet via phone"


*educ_mother: mother's education level
	*1=prii 2=pric 3=seci 4=secc 5=supi/supc	
gen 		 educ_mother = .
replace 	 educ_mother = 1 if ap10 == 1 | ap10 == 2 
replace 	 educ_mother = 2 if ap10 == 3
replace 	 educ_mother = 3 if ap10 == 4
replace 	 educ_mother = 4 if ap10 == 5
replace 	 educ_mother = 5 if ap10 == 6 | ap10 == 7
label define educ_mother  	1"Primary Incomplete" 	///
							2"Primary Complete" 	///
							3"Secondary Incomplete" ///
							4"Secondary Complete" 	///
							5"Superior (Complete or incomplete)"
label values educ_mother educ_mother



*educ_father: father's education level
	*1=prii 2=pric 3=seci 4=secc 5=supi/supc	
gen 		 educ_father = .
replace 	 educ_father = 1 if ap11 == 1 | ap11 == 2 
replace 	 educ_father = 2 if ap11 == 3
replace 	 educ_father = 3 if ap11 == 4
replace 	 educ_father = 4 if ap11 == 5
replace 	 educ_father = 5 if ap11 == 6 | ap11 == 7
label define educ_father  	1"Primary Incomplete" 	///
							2"Primary Complete" 	///
							3"Secondary Incomplete" ///
							4"Secondary Complete" 	///
							5"Superior (Complete or incomplete)"
label values educ_father educ_father



*work: if works outside home
gen 	work = .
replace work = 0 if ap17 == 2
replace work = 1 if ap17 == 1



*kinder: if went to kindergarden
gen 	kinder = .
replace kinder = 0 if ap19 == 4
replace kinder = 1 if ap19>0 & ap19<4


*repeated: dummy for any level

gen 	repeated = .
replace repeated = 0 if repitio_prim == 0 & repitio_sec == 0
replace repeated = 1 if repitio_prim == 1 | repitio_sec == 1





/*================================
		2.4) Weights
==================================*/


gen weight = ponder
gen lweight = lpondera
gen mweight = mpondera









*===============================================



order year region idschool idclass idstudent
sort  year region idschool idclass idstudent

keep year region idschool idclass idstudent public urban woman foreign ///
	 child internet internet_phone educ_mother educ_father work kinder repeated ///
	 mscore mscore_std log_mscore lscore lscore_std log_lscore weight lweight mweight





save "`data'/analytical/db2017.dta", replace
