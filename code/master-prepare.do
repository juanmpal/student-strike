clear all
set more off

*master-prepare.do

*This do file:
*Makes all dbs and appends into panel

cd "C:/Users/juanc/Google Drive/research/student-strike"
loc data = "C:/research/student-strike/data"


do "code/prepare2016.do"
do "code/prepare2017.do"
do "code/prepare2019.do"
do "code/prepare-panel.do"
