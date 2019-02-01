************************************************************************************
************************************************************************************

*STEP 0. GENERATE A DATABASE WHICH ALLOWS TO ANALYZE CONSUMPTION, WEALTH AND INCOME*


*STEP 0.1. Generate consumption information
*The monthly information for consumption for year 2014 is contained in the file with name "UNPS 2013-14 Consumption Aggregate"
*The dataset will contain information of consumption expenditure after regional and seasonal adjustments, 
*location variables, household size (in equivalence terms) and cross-sectional weight of each household

 ** Introduce input
 
 use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\UNPS 2013-14 Consumption Aggregate.dta", clear
 

 ** Calculate annual consumption (in constant currency) and eliminate non required variables

 gen consumption = 12*(cpexp30)
 
 keep HHID district_code urban ea region regurb wgt_X hsize equiv consumption 
 
 ** Generate id code for households and eliminate if repeated
 
 replace HHID = subinstr(HHID, "H", "", .)
 replace HHID = subinstr(HHID, "-", "", .)
 destring HHID, gen(HH)
 drop HHID
 
 bysort HH: gen n = _n
 drop if n>1
 
** Save

 save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Consumption data.dta", replace
 
 ************************************************************************************
 ************************************************************************************
 
 *STEP 0.2. Generate wealth information by adding all the different forms of wealth
 *The dataset will contain information of the value of the assets owned by the household minus the value of
 *debts and liabilities

 *STEP 0.2.1. Generate non-agricultural wealth
 *The information for the value of the assets for year 2014 is contained in file with name "GSEC14A"
 
  **Introduce input
 
  use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC14A.dta", clear
 
  ** Calculate non-agricultural wealth (We could correct considering number of assets but there would be excesive deleting)

 bysort HHID: egen nonag_wealth = total(h14q5)
 
 keep HHID nonag_wealth

  ** Generate id code for households and eliminate if repeated
 
 replace HHID = subinstr(HHID, "H", "", .)
 replace HHID = subinstr(HHID, "-", "", .)
 destring HHID, gen(HH)
 drop HHID
 
 bysort HH: gen n = _n
 drop if n>1
 drop n
 
** Save

 save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta", replace
 
 *STEP 0.2.2. Generate agricultural wealth
 *The information for the value of land, poultry, livestock,... is contained in multiple datasets. So we repeat the process.
 *0.2.2.1. Land
/*
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC2B.dta", clear
replace a2bq9 = 0 if a2bq9 == .
replace a2bq4 = 0 if a2bq4 == .
keep if a2bq9 > 0
keep if a2bq4 > 0
gen average_rent = a2bq9/a2bq4
summ average_rent
*/
*The average rental price is 120.835, which is the price we impute to all those who don´t present rental price
*c. 124.325 chellines (c. average paid rents for those who pay rents) * 10 years * number of true acres
 use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC2B.dta", clear
 replace a2bq9 = 0 if a2bq9 == .
 replace a2bq4 = 0 if a2bq4 == .
 gen land_wealth = 10 * a2bq9
 replace land_wealth = 10 * 124325 * a2bq4 if land_wealth == 0
 collapse (sum) land_wealth, by(HHID) 
 rename HHID HH
 keep HH land_wealth 
 bysort HH: gen n = _n
 drop if n>1
 drop n
 merge 1:1 HH using "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta"
 drop _merge
 save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta", replace 
 
 *0.2.2.2. Equipment
 use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC10.dta", clear
 gen  equipment = 0 
 replace equipment = a10q2
 bysort HHID: egen equipment_wealth = total(equipment)
 rename HHID HH
 keep HH equipment_wealth 
 bysort HH: gen n = _n
 drop if n>1
 drop n
 merge 1:1 HH using "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta"
 drop _merge
 save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta", replace 
 
 *0.2.2.3. Cattle
 use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC6A.dta", clear
 gen  cattle_wealth = a6aq3a*a6aq14b
 collapse(sum) cattle_wealth, by(HHID)
 keep HHID cattle_wealth
 rename HHID HH
 bysort HH: gen n = _n
 drop if n>1
 drop n
 merge 1:1 HH using "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta"
 drop _merge
 save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta", replace 
 
  *0.2.2.4. Small animals
 use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC6B.dta", clear
 gen  sanimals_wealth = a6bq3a*a6bq14b
 collapse(sum) sanimals_wealth, by(HHID)
 keep HHID sanimals_wealth
 rename HHID HH
 bysort HH: gen n = _n
 drop if n>1
 drop n
 merge 1:1 HH using "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta"
 drop _merge
 save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta", replace 
 
   *0.2.2.5. Poultry
 use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC6C.dta", clear
 gen  poultry_wealth = a6cq3a*a6cq14b
 collapse(sum) poultry_wealth, by(HHID)
 keep HHID poultry_wealth
 rename HHID HH
 bysort HH: gen n = _n
 drop if n>1
 drop n
 merge 1:1 HH using "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta"
 drop _merge
 save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta", replace 

 *STEP 0.2.3. Add all forms of wealth
 use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta", clear
 replace nonag_wealth = 0 if nonag_wealth==.
 replace land_wealth = 0 if land_wealth==.
 replace equipment_wealth = 0 if equipment_wealth==.
 replace cattle_wealth = 0 if cattle_wealth==.
 replace sanimals_wealth = 0 if sanimals_wealth==.
 replace poultry_wealth = 0 if poultry_wealth==.
 gen total_wealth = land_wealth + nonag_wealth + equipment_wealth + cattle_wealth + sanimals_wealth + poultry_wealth
 save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta", replace 
 
 ************************************************************************************
 ************************************************************************************
 
 *STEP 0.3. Generate income information by adding all the different forms of income

 ** 1. RURAL REVENUES AND COSTS
** 1.1. COSTS
** 1.1.1. Agricultural costs first s (fertilizer, pesticide and labour)
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC3A.dta", clear
replace a3aq8 = 0 if a3aq8 == .
replace a3aq18 = 0 if a3aq18 == .
replace a3aq27 = 0 if a3aq27 == .
replace a3aq36 = 0 if a3aq36 == .
gen costs_agricultural_1 = a3aq8 + a3aq18 + a3aq27 + a3aq36
collapse(sum) costs_agricultural_1, by(HHID)
keep HHID costs_agricultural_1
tempfile filet1
save `filet1'

** 1.2. Agricultural costs second s (fertilizer, pesticide and labour)
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC3B.dta", clear
replace a3bq8 = 0 if a3bq8 == .
replace a3bq18 = 0 if a3bq18 == .
replace a3bq27 = 0 if a3bq27 == .
replace a3bq36 = 0 if a3bq36 == .
gen costs_agricultural_2 = a3bq8 + a3bq18 + a3bq27 + a3bq36
collapse(sum) costs_agricultural_2, by(HHID)
keep HHID costs_agricultural_2
tempfile filet2
save `filet2'

** 1.3. Agricultural costs first s (seeds)
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC4A.dta", clear
replace a4aq15 = 0 if a4aq15 == .
rename a4aq15 costs_seed_1
collapse(sum) costs_seed_1, by(HHID)
keep HHID costs_seed_1
tempfile filet3
save `filet3'

** 1.4. Agricultural costs second s (seeds)
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC4B.dta", clear
replace a4bq15 = 0 if a4bq15 == .
rename a4bq15 costs_seed_2
collapse(sum) costs_seed_2, by(HHID)
keep HHID costs_seed_2
tempfile filet4
save `filet4'

** 1.5. Livestock costs (feed, water, vaccines...)
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC7.dta", clear
replace a7bq2e = 0 if a7bq2e == .
replace a7bq3f = 0 if a7bq3f == .
replace a7bq5d = 0 if a7bq5d == .
replace a7bq6c = 0 if a7bq6c == .
replace a7bq7c = 0 if a7bq7c == .
replace a7bq8c = 0 if a7bq8c == .
gen costs_livestock = a7bq2e + a7bq3f + a7bq5d + a7bq6c + a7bq7c + a7bq8c
collapse(sum) costs_livestock, by(HHID)
keep HHID costs_livestock
tempfile filet5
save `filet5'

** 1.6. Farm equipment costs
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC10.dta", clear
replace a10q8 = 0 if a10q8 == .
rename a10q8 costs_equipment
collapse(sum) costs_equipment, by(HHID)
keep HHID costs_equipment
tempfile filet6
save `filet6'

** 1.7. Rent paid to the landowner and rent received from sharecropping
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC2B.dta", clear
replace a2bq9 = 0 if a2bq9 == .
replace a2bq13 = 0 if a2bq13 == .
gen costs_land = a2bq9 - a2bq13
collapse(sum) costs_land, by(HHID)
keep HHID costs_land
tempfile filet7
save `filet7'

** 1.2. REVENUES
** 1.2.1. Rents from sharecropping
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC2A.dta", clear
replace a2aq14 = 0 if a2aq14 == .
rename a2aq14 revenues_sharecrop
collapse(sum) revenues_sharecrop, by(HHID)
keep HHID revenues_sharecrop
tempfile filet8
save `filet8'

** 1.2.2. Harvest value - transport costs. First season
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC5A.dta", clear
replace a5aq8 = 0 if a5aq8 == .
replace a5aq10 = 0 if a5aq10 == .
gen revenues_harvest_1 = a5aq8 - a5aq10
collapse(sum) revenues_harvest_1, by(HHID)
keep HHID revenues_harvest_1
tempfile filet9
save `filet9'


** 1.2.3. Harvest value - transport costs. Second season
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC5B.dta", clear
replace a5bq8 = 0 if a5bq8 == .
replace a5bq10 = 0 if a5bq10 == .
gen revenues_harvest_2 = a5bq8 - a5bq10
collapse(sum) revenues_harvest_2, by(HHID)
keep HHID revenues_harvest_2
tempfile filet10
save `filet10'

** 1.2.4. Value of the cattle and slaugthered minus the purchases of animals and the human cost of kepping
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC6A.dta", clear
replace a6aq14a = 0 if a6aq14a == .
replace a6aq15 = 0 if a6aq15 == .
replace a6aq14b = 0 if a6aq14b == .
replace a6aq13a = 0 if a6aq13a == .
replace a6aq13b = 0 if a6aq13b == .
replace a6aq5c = 0 if a6aq5c == .
gen revenues_cattle = (a6aq14a+a6aq15)*a6aq14b - a6aq13a*a6aq13b - a6aq5c
collapse(sum) revenues_cattle, by(HHID) 
keep HHID revenues_cattle
tempfile filet11
save `filet11'

** 1.2.5. Value of the small animals and slaugthered minus the purchases of animals and the human cost of kepping
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC6B.dta", clear
replace a6bq14a = 0 if a6bq14a == .
replace a6bq15 = 0 if a6bq15 == .
replace a6bq14b = 0 if a6bq14b == .
replace a6bq13a = 0 if a6bq13a == .
replace a6bq13b = 0 if a6bq13b == .
replace a6bq5c = 0 if a6bq5c == .
gen revenues_sanimals = (a6bq14a+a6bq15)*a6bq14b - a6bq13a*a6bq13b - a6bq5c
collapse(sum) revenues_sanimals, by(HHID)
keep HHID revenues_sanimals
tempfile filet12
save `filet12'

** 1.2.6. Value of the poultry animals and slaugthered minus the purchases of animals and the human cost of kepping
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC6C.dta", clear
replace a6cq14a = 0 if a6cq14a == .
replace a6cq15 = 0 if a6cq15 == .
replace a6cq14b = 0 if a6cq14b == .
replace a6cq13a = 0 if a6cq13a == .
replace a6cq13b = 0 if a6cq13b == .
replace a6cq5c = 0 if a6cq5c == .
gen revenues_poultry = (a6cq14a+a6cq15)*a6cq14b*4 - a6cq13a*a6cq13b - a6cq5c
collapse(sum) revenues_poultry, by(HHID) 
keep HHID revenues_poultry
tempfile filet13
save `filet13'

** 1.2.7. Value of meat that has been sold
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC8A.dta", clear
replace a8aq5 = 0 if a8aq5 == .
rename a8aq5 revenues_meat
collapse(sum) revenues_meat, by(HHID)
keep HHID revenues_meat
tempfile filet14
save `filet14'

** 1.2.8. Value of milk that has been sold
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC8B.dta", clear
replace a8bq9 = 0 if a8bq9 == .
rename a8bq9 revenues_milk
collapse(sum) revenues_milk, by(HHID)
keep HHID revenues_milk
tempfile filet15
save `filet15'

** 1.2.9. Value of eggs that has been sold
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC8C.dta", clear
replace a8cq5 = 0 if a8cq5 == .
rename a8cq5 revenues_eggs
collapse(sum) revenues_eggs, by(HHID)
keep HHID revenues_eggs
tempfile filet16
save `filet16'

** 1.2.10 Value of livestock dung + others
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC11.dta", clear
replace a11q1c = 0 if a11q1c == .
replace a11q5 = 0 if a11q5 == .
gen revenues_livestock_others = a11q1c + a11q5
collapse(sum) revenues_livestock_others, by(HHID)
keep HHID revenues_livestock_others
tempfile filet17
save `filet17'

** 2. JOB REVENUES
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC8_1.dta", clear
**Clean 0s
 foreach var of varlist h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g h8q30a h8q30b h8q31a h8q31b h8q31c h8q43 h8q44 h8q44b h8q45a h8q45b h8q45c {
	replace `var' = 0 if `var'==.
 }
 
 
** First job
** First, we compute the amount of hours worked in a week and in a month. We need to consider that, on average,
** close to 8 hours are worked in a day and almost close to 40 hours are worked in a week
** h(we assume each week the amount of hours worked is the same)
egen week_h_1 = rowtotal(h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g)
gen year_h_1 = h8q30a*h8q30b*week_h_1
** W/h. First job
gen wageperh =  .
replace wageperh = (h8q31a+h8q31b)/160 if h8q31c==4
replace wageperh = (h8q31a+h8q31b)/40 if h8q31c==3	
replace wageperh = (h8q31a+h8q31b)/8 if h8q31c==2
replace wageperh = (h8q31a+h8q31b) if h8q31c==1
** w*h. First job
gen w_h_1 = wageperh * year_h_1
replace w_h_1 = 0 if w_h_1==.
** Hours worked
gen week_h_2 = h8q43
gen year_h_2 = week_h_2 * h8q44 * h8q44b
** W/h. Second job
gen wageperh_2 =0
replace wageperh_2 = (h8q45a+h8q45b)/160 if h8q45c==4
replace wageperh_2 = (h8q45a+h8q45b)/40 if h8q45c==3  	
replace wageperh_2 = (h8q45a+h8q45b)/8 if h8q45c==2  
replace wageperh_2 = (h8q45a+h8q45b) if h8q45c==1	
** w*h. Second job(h8q45a+h8q45b) if h8q45c==1	
gen w_h_2 = wageperh_2 * year_h_2
replace w_h_2 = 0 if w_h_2==.
** Generate data on income and labor supply
gen revenues_labor = w_h_2 + w_h_1
replace revenues_labor = 0 if revenues_labor==.
collapse (sum) revenues_labor w_h_2 w_h_1 year_h_2 year_h_1 week_h_2 week_h_1, by(HHID)
keep HHID revenues_labor
tempfile filet18
save `filet18'

** 3. OTHER SOURCES OF INCOME
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC11A.dta", clear
replace h11q5 = 0 if h11q5 == .
replace h11q5 = 0 if h11q5 == .
gen revenues_other = h11q5 + h11q6
collapse(sum) revenues_other, by(HHID)
keep HHID revenues_other
tempfile filet19
save `filet19'
** 3. OTHER SOURCES OF INCOME
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC11A.dta", clear
replace h11q5 = 0 if h11q5 == .
replace h11q5 = 0 if h11q5 == .
gen revenues_other = h11q5 + h11q6
collapse(sum) revenues_other, by(HHID)
keep HHID revenues_other
tempfile filet19
save `filet19'

** 4. ENTERPRISE PROFITS
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC12.dta", clear
replace h12q12 = 0 if h12q12 == .
replace h12q13 = 0 if h12q13 == .
replace h12q15 = 0 if h12q15 == .
replace h12q16 = 0 if h12q16 == .
replace h12q17 = 0 if h12q17 == .
rename hhid HHID
gen profit_enterprise = (h12q13 - h12q15 - h12q16 - h12q17)*h12q12
collapse(sum) profit_enterprise, by(HHID)
keep HHID profit_enterprise
tempfile filet20
save `filet20'

** 5. TRANSFERS
** 5.1. Transfers 1
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC15B.dta", clear
replace h15bq11 = 0 if h15bq11 == .
replace h15bq11 = h15bq11*50
rename h15bq11 transfers_1
collapse(sum) transfers_1, by(HHID)
keep HHID transfers_1
tempfile filet21
save `filet21'

** 5.2. Transfers 2
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC15C.dta", clear
replace h15cq9 = 0 if h15cq9 == .
replace h15cq9 = h15cq9*12
rename h15cq9 transfers_2
collapse(sum) transfers_2, by(HHID)
keep HHID transfers_2
tempfile filet22
save `filet22'

** 5.3. Transfers 3
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC15D.dta", clear
replace h15dq5 = 0 if h15dq5 == .
rename h15dq5 transfers_3
collapse(sum) transfers_3, by(HHID)
keep HHID transfers_3
tempfile filet23
save `filet23'


** MERGE ALL TEMPORAL FILES
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC1.dta", clear
keep HHID wgt_X
mer 1:1 HHID using `filet18'
drop _merge
mer 1:1 HHID using `filet19'
drop _merge
mer 1:1 HHID using `filet20'
drop _merge
mer 1:1 HHID using `filet21'
drop _merge
mer 1:1 HHID using `filet22'
drop _merge
mer 1:1 HHID using `filet23'
drop _merge
replace HHID = subinstr(HHID, "H", "", .)
replace HHID = subinstr(HHID, "-", "", .)
destring HHID, gen(HH)
drop HHID
rename HH HHID
tempfile filet24
save `filet24'

use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\AGSEC1.dta", clear
keep HHID wgt_X
mer 1:1 HHID using `filet1'
drop _merge
mer 1:1 HHID using `filet2'
drop _merge
mer 1:1 HHID using `filet3'
drop _merge
mer 1:1 HHID using `filet4'
drop _merge
mer 1:1 HHID using `filet5'
drop _merge
mer 1:1 HHID using `filet6'
drop _merge
mer 1:1 HHID using `filet7'
drop _merge
mer 1:1 HHID using `filet8'
drop _merge
mer 1:1 HHID using `filet9'
drop _merge
mer 1:1 HHID using `filet10'
drop _merge
mer 1:1 HHID using `filet11'
drop _merge
mer 1:1 HHID using `filet12'
drop _merge
mer 1:1 HHID using `filet13'
drop _merge
mer 1:1 HHID using `filet14'
drop _merge
mer 1:1 HHID using `filet15'
drop _merge
mer 1:1 HHID using `filet16'
drop _merge
mer 1:1 HHID using `filet17'
drop _merge
mer 1:1 HHID using `filet24'
drop _merge


egen agricultural_revenue = rowtotal(revenues_sharecrop revenues_harvest_1 revenues_harvest_2 revenues_cattle revenues_sanimals revenues_poultry revenues_meat revenues_milk revenues_eggs revenues_livestock_others)
egen agricultural_costs =  rowtotal(costs_agricultural_1 costs_agricultural_2 costs_seed_1 costs_seed_2 costs_livestock costs_equipment costs_land)
replace agricultural_revenue = 0 if agricultural_revenue == .
replace agricultural_costs = 0 if agricultural_costs == .
gen agricultural_income = agricultural_revenue - agricultural_costs
gen labour_income = revenues_labor
gen profits = profit_enterprise
gen other_income = revenues_other
egen transfers = rowtotal(transfers_1 transfers_2 transfers_3)
rename HHID HH
egen total_income = rowtotal(agricultural_income labour_income profits other_income transfers)
keep HH wgt_X agricultural_revenue agricultural_costs  agricultural_income labour_income profits other_income transfers total_income
save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Income data.dta"


************************************************************************************
************************************************************************************

*Step 0.4. Obtain gender, sex and education of HH and merge all datasets
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC2.dta", clear
keep if h2q4==1
rename h2q3 gender
rename h2q8 age 
replace HHID = subinstr(HHID, "H", "", .)
replace HHID = subinstr(HHID, "-", "", .)
destring HHID, gen(HH)
drop HHID
keep HH age gender h2q4
bysort HH: gen n = _n
drop if n>1
tempfile filet25
save `filet25'

use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC4.dta", clear
rename h4q7 education
replace HHID = subinstr(HHID, "H", "", .)
replace HHID = subinstr(HHID, "-", "", .)
destring HHID, gen(HH)
drop HHID
keep HH education
bysort HH: gen n = _n
drop if n>1
tempfile eddata
save `eddata'

use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Consumption data.dta", clear
mer 1:1 HH using `filet25'
drop _merge
mer 1:1 HH using `eddata'
drop _merge
mer 1:1 HH using "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Income data.dta"
drop _merge
mer 1:1 HH using "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Wealth data.dta"
drop _merge
keep if h2q4==1
save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Final data.dta"


************************************************************************************
************************************************************************************

*Step 0.5. Obtain data for labor supply
** Generate labor dataset
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Input. UGA 13\GSEC8_1.dta" , clear
**Clean 0s
 foreach var of varlist h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g h8q30a h8q30b h8q31a h8q31b h8q31c h8q43 h8q44 h8q44b h8q45a h8q45b h8q45c {
	replace `var' = 0 if `var'==.
 }
 
 
** First job
** First, we compute the amount of hours worked in a week and in a month. We need to consider that, on average,
** close to 8 hours are worked in a day and almost close to 40 hours are worked in a week
 /*
What period |
of time did |
       this |
    payment |        Summary of hours_week
     cover? |        Mean   Std. Dev.       Freq.
------------+------------------------------------
          0 |   10.697925   16.865337      13,447
       Hour |   15.166667   11.125047           6
        Day |   39.634228    22.52848         298
       Week |   37.847291   21.760654         203
      Month |   45.084677   20.111722         744
  Other (sp |   33.830189   21.840978          53
------------+------------------------------------
      Total |   13.475425   19.468342      14,751
*/
** h(we assume each week the amount of hours worked is the same)
egen week_h_1 = rowtotal(h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g)
gen year_h_1 = h8q30a*h8q30b*week_h_1
** W/h. First job
gen wageperh =0
replace wageperh = (h8q31a+h8q31b)/(h8q30b*week_h_1) if h8q31c==4
replace wageperh = (h8q31a+h8q31b)/week_h_1 if h8q31c==3	
replace wageperh = (h8q31a+h8q31b)/8 if h8q31c==2
replace wageperh = (h8q31a+h8q31b) if h8q31c==1
** w*h. First job
gen w_h_1 = wageperh * year_h_1
replace w_h_1 = 0 if w_h_1==.
 
 ** Second jobs present much lower hours of work on a week (roughly 3)
/* 
What period |
of time did |
       this |
    payment |       Summary of hours_week2
     cover? |        Mean   Std. Dev.       Freq.
------------+------------------------------------
          0 |   1.0270692   4.8853442      13,447
       Hour |           4           8           6
        Day |   3.0167785   7.5422304         298
       Week |   3.0738916   6.7412913         203
      Month |   2.8709677   7.2133058         744
  Other (sp |    3.245283   6.5277681          53
------------+------------------------------------
      Total |   1.1976137   5.1593256      14,751
*/
** Hours worked
gen week_h_2 = h8q43
gen year_h_2 = week_h_2 * h8q44 * h8q44b
** W/h. Second job
gen wageperh_2 =0
replace wageperh_2 = (h8q45a+h8q45b)/(4*3) if h8q45c==4
replace wageperh_2 = (h8q45a+h8q45b)/3 if h8q45c==3  	
replace wageperh_2 = (h8q45a+h8q45b)/3 if h8q45c==2  
replace wageperh_2 = (h8q45a+h8q45b) if h8q45c==1	
** w*h. Second job(h8q45a+h8q45b) if h8q45c==1	
gen w_h_2 = wageperh_2 * year_h_2
replace w_h_2 = 0 if w_h_2==.

** Generate data on income and labor supply
gen income_labor = w_h_2 + w_h_1
replace income_labor = 0 if income_labor==.
collapse (sum) income_labor w_h_2 w_h_1 year_h_2 year_h_1 week_h_2 week_h_1, by(HHID)
replace HHID = subinstr(HHID, "H", "", .)
replace HHID = subinstr(HHID, "-", "", .)
destring HHID, gen(HH)
drop HHID
merge 1:1 HH using "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Final data.dta"
drop _merge
gen intensive_margin = year_h_1 + year_h_2
bysort urban: egen laborforce=sum(wgt_X) if intensive>0
bysort urban: egen total=sum(wgt_X) 
gen extensive_margin = laborforce/total 
save "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Final data. Question 2.dta", replace


 
