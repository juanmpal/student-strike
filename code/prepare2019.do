set more off
clear all

/*=================
 	prepare2019.do
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
loc db_stud_2019 = "`data'/raw/student-2019.dta"
loc db_prin_2019 = "`data'/raw/principal-2019.dta"


/*=======================================
	1) Merge Student with Principal DBs
			(Only for 2019)
========================================*/



*Prepare director base

use `db_prin_2019', clear

sort ID1

tempfile prin_temp

save `prin_temp', replace


*Merge it with student base

use `db_stud_2019'

sort ID1

merge ID1 using `prin_temp'

drop if _merge == 2

drop _merge


destring ap* ldesemp mdesemp repitencia_dicotomica, replace
destring TEM TEL, replace dpcomma






/*=======================================
		2) Variable Creation
========================================*/
/*

2.1) Test Scores
2.2) Identifiers
2.3) Socioeconomic variables
2.4) Weights

*/

/*====================
	2.1) Test Scores
======================*/

gen mscore = TEL
gen lscore = TEM

*(Log) Test Scores

* Lengua
gen log_lscore = log(lscore)

* Matematica
gen log_mscore = log(mscore)


label define leng 1"Por debajo de nivel basico" 2"Nivel Basico" ///
	3"Nivel Satisfactorio" 4"Nivel Avanzado"
label values ldesemp leng

label define mate 1"Por debajo de nivel basico" 2"Nivel Basico" ///
	3"Nivel Satisfactorio" 4"Nivel Avanzado"
label values mdesemp mate




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

gen year = 2019

gen idschool = ID1
*encode ID1, gen(idschool)
encode claveseccion, gen(idclass)

bysort idclass: gen idstudent = _n

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
gen 	woman = 0 if ap02 == 1
replace woman = 1 if ap02 == 2


*foreign
*0=Argentina, 1=Any other country
gen 	foreign = .
replace foreign = 0 if ap03 == 1
replace foreign = 1 if ap03 > 1 & ap03 != .

label define foreign 0 "Argentine" 1 "Foreign"
label values foreign foreign


*child: if has any child
gen 	child = .
replace child = 0 if ap09 == 2
replace child = 1 if ap09 == 1


*internet: if has internet connection at home
gen 	internet = .
replace internet = 0 if ap11_08 == 2
replace internet = 1 if ap11_08 == 1


*internet_phone: if can access internet through internet_phone
gen 	  internet_phone = .
replace   internet_phone = 0 if ap13 == 2
replace   internet_phone = 1 if ap13 == 1
label var internet_phone "If can access internet via phone"


*educ_mother: mother's education level
	*1=prii 2=pric 3=seci 4=secc 5=supi/supc	
gen 		 educ_mother = .
replace 	 educ_mother = 1 if ap16 == 1 	
replace 	 educ_mother = 2 if ap16 == 2
replace 	 educ_mother = 3 if ap16 == 3
replace 	 educ_mother = 4 if ap16 == 4
replace 	 educ_mother = 5 if ap16 == 5 | ap16 == 6 | ap16 == 7
label define educ_mother  	1"Primary Incomplete" 	///
							2"Primary Complete" 	///
							3"Secondary Incomplete" ///
							4"Secondary Complete" 	///
							5"Superior (Complete or incomplete)"
label values educ_mother educ_mother



*educ_father: father's education level
	*1=prii 2=pric 3=seci 4=secc 5=supi/supc	
gen 		 educ_father = .
replace 	 educ_father = 1 if ap17 == 1 	
replace 	 educ_father = 2 if ap17 == 2
replace 	 educ_father = 3 if ap17 == 3
replace 	 educ_father = 4 if ap17 == 4
replace 	 educ_father = 5 if ap17 == 5 | ap17 == 6 | ap17 == 7
label define educ_father  	1"Primary Incomplete" 	///
							2"Primary Complete" 	///
							3"Secondary Incomplete" ///
							4"Secondary Complete" 	///
							5"Superior (Complete or incomplete)"
label values educ_father educ_father



*work: if works outside home
gen 	work = .
replace work = 0 if ap21 == 1
replace work = 1 if ap21 > 1 & ap21 != .



*kinder: if went to kindergarden
gen 	kinder = .
replace kinder = 0 if ap24 == 4
replace kinder = 1 if ap24 >= 1 & ap24 <= 3


*repeated: dummy for any level
gen 	repeated = .
replace repeated = 0 if repitencia_dicotomica == 2
replace repeated = 1 if repitencia_dicotomica == 1





/*================================
		2.4) Weights
==================================*/


gen weight = ponder
gen lweight = lpondera
gen mweight = mpondera



destring weight lweight mweight, replace dpcomma




*===============================================



order year region idschool idclass idstudent
sort  year region idschool idclass idstudent

keep year region idschool idclass idstudent public urban woman foreign ///
	 child internet internet_phone educ_mother educ_father work kinder repeated ///
	 mscore mscore_std log_mscore lscore lscore_std log_lscore weight lweight mweight



	 

save "`data'/analytical/db2019.dta", replace

