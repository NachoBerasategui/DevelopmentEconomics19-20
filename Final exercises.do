/*
*******************************************************************
*******************************************************************
** QUESTION 1
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Final data.dta" , clear

** Trim all non-positive values
rename total_income income
rename total_wealth wealth
keep if consumption >0
keep if wealth >0
keep if income >0
egen total1= rowtotal(income wealth)
keep if consumption < total1
_pctile consumption, nq(100)
drop if consumption >r(r99) 
_pctile income, nq(100)
drop if income >r(r99)
_pctile wealth, nq(100)
drop if wealth >r(r99) 

** Conversion to USD 2013 (we use an average exchange rate of c. 2500)
replace consumption = consumption/2500
replace income = income/2500
replace wealth = wealth/2500

**QUESTION 1.1
**Report average CIW per household separately for rural and urban areas
mean(consumption income wealth) [pw=wgt_X]
mean(consumption income wealth) [pw=wgt_X] if urban == 1
mean(consumption income wealth) [pw=wgt_X] if urban == 0 

/*



Mean estimation                   Number of obs   =      2,353

--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
 consumption |   1034.682   16.96266      1001.418    1067.945
      income |   1822.553   58.75524      1707.336    1937.771
      wealth |   3252.071   143.6435       2970.39    3533.752
--------------------------------------------------------------

. mean(consumption income wealth) [pw=wgt_X] if urban == 1

Mean estimation                   Number of obs   =        631

--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
 consumption |   1424.107   43.82241      1338.052    1510.163
      income |   3162.768   160.8067      2846.986     3478.55
      wealth |     5609.5     389.02      4845.567    6373.433
--------------------------------------------------------------

. mean(consumption income wealth) [pw=wgt_X] if urban == 0 

Mean estimation                   Number of obs   =      1,722

--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
 consumption |   899.4345   16.05508      867.9449     930.924
      income |   1357.098   52.17296      1254.769    1459.427
      wealth |   2433.337   133.6373      2171.229    2695.446
--------------------------------------------------------------



*/
	  
** QUESTION 1.2.
**CIW inequality: (1) Show histogram for CIW separately for rural and urban 
**areas; (2) Report the variance of logs for CIW separately for rural and urban 
**areas.

** Histograms
twoway (histogram consumption if urban==0, fcolor(none) lcolor(green))(histogram consumption if urban==1, fcolor(none) lcolor(blue)), ///
legend(order(1 "Rural" 2 "Urban")) xtitle(Consumption) graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histconsumption.png", replace 

twoway (histogram income if urban==0, fcolor(none) lcolor(green))(histogram income if urban==1, fcolor(none) lcolor(blue)), ///
legend(order(1 "Rural" 2 "Urban")) xtitle(Income) graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histincome.png", replace 

twoway (histogram wealth if urban==0, fcolor(none) lcolor(green))(histogram wealth if urban==1, fcolor(none) lcolor(blue)), ///
legend(order(1 "Rural" 2 "Urban")) xtitle(Wealth) graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histwealth.png", replace 
 
 ** Variances
 foreach var in consumption income wealth {
	 gen l_`var'=log(`var')
	 egen sd_l_`var'_u = sd(l_`var'), by(urban)
	 gen var_l_`var'_u = (sd_l_`var'_u)^2
	 egen sd_l_`var' = sd(l_`var')
	 gen var_l_`var' = (sd_l_`var')^2
 }

  foreach var in consumption income wealth {
 	 mean var_l_`var'
	 mean var_l_`var'_u if urban==0
	 mean var_l_`var'_u if urban==1
 }

/*

Mean estimation                   Number of obs   =      2,353

-------------------------------------------------------------------
                  |       Mean   Std. Err.     [95% Conf. Interval]
------------------+------------------------------------------------
var_l_consumption |   .4598104          0             .           .
-------------------------------------------------------------------

Mean estimation                   Number of obs   =      1,722

---------------------------------------------------------------------
                    |       Mean   Std. Err.     [95% Conf. Interval]
--------------------+------------------------------------------------
var_l_consumption_u |   .3917213          0             .           .
---------------------------------------------------------------------

Mean estimation                   Number of obs   =        631

---------------------------------------------------------------------
                    |       Mean   Std. Err.     [95% Conf. Interval]
--------------------+------------------------------------------------
var_l_consumption_u |   .4754116          0             .           .
---------------------------------------------------------------------

Mean estimation                   Number of obs   =      2,353

--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
var_l_income |   1.732512          0             .           .
--------------------------------------------------------------

Mean estimation                   Number of obs   =      1,722

----------------------------------------------------------------
               |       Mean   Std. Err.     [95% Conf. Interval]
---------------+------------------------------------------------
var_l_income_u |   1.473934          0             .           .
----------------------------------------------------------------

Mean estimation                   Number of obs   =        631

----------------------------------------------------------------
               |       Mean   Std. Err.     [95% Conf. Interval]
---------------+------------------------------------------------
var_l_income_u |   1.850317          0             .           .
----------------------------------------------------------------

Mean estimation                   Number of obs   =      2,353

--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
var_l_wealth |   2.430725          0             .           .
--------------------------------------------------------------

Mean estimation                   Number of obs   =      1,722

----------------------------------------------------------------
               |       Mean   Std. Err.     [95% Conf. Interval]
---------------+------------------------------------------------
var_l_wealth_u |   2.032961          0             .           .
----------------------------------------------------------------

Mean estimation                   Number of obs   =        631

----------------------------------------------------------------
               |       Mean   Std. Err.     [95% Conf. Interval]
---------------+------------------------------------------------
var_l_wealth_u |   3.289507          0             .           .
----------------------------------------------------------------

*/
** QUESTION 1.3.
** the joint cross-sectional behavior of CIW
correlate (consumption income wealth)
correlate (consumption income wealth) if urban == 0
correlate (consumption income wealth) if urban == 1


/*

             | consum~n   income   wealth
-------------+---------------------------
 consumption |   1.0000
      income |   0.5542   1.0000
      wealth |   0.5750   0.3080   1.0000


. correlate (consumption income wealth) if urban == 0
(obs=1,722)

             | consum~n   income   wealth
-------------+---------------------------
 consumption |   1.0000
      income |   0.4324   1.0000
      wealth |   0.5002   0.2244   1.0000


. correlate (consumption income wealth) if urban == 1
(obs=631)

             | consum~n   income   wealth
-------------+---------------------------
 consumption |   1.0000
      income |   0.5574   1.0000
      wealth |   0.5791   0.2781   1.0000


*/



** QUESTION 1.4.
/* CIW level, inequality, and covariances over the lifecycle */
** Averages
egen a_consumption = mean(consumption), by(age)
egen aa_consumption = mean(consumption), by(urban age)
egen a_income = mean(income), by(age)
egen aa_income = mean(income), by(urban age)
egen a_wealth = mean(wealth), by(age)
egen aa_wealth = mean(wealth), by(urban age)
	
preserve
drop if age < 20
drop if age > 60
** Rural 
twoway (connected aa_consumption aa_income aa_wealth age if urban == 0, sort),xtitle("Age") title("Average CIW by age in rural areas") legend(order(1 "Mean consumption" 2 "Mean income" 3 "Mean wealth")) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_Rural_lifec.png", replace
** Urban 
twoway (connected aa_consumption aa_income aa_wealth age if urban == 1, sort),xtitle("Age") title("Average CIW by age in urban areas") legend(order(1 "Mean consumption" 2 "Mean income" 3 "Mean wealth")) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_Urban_lifec.png", replace
** Total
twoway (connected a_consumption a_income a_wealth age, sort), xtitle("Age") title("Average CIW by age in all country") legend(order(1 "Mean consumption" 2 "Mean income" 3 "Mean wealth")) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_All_lifec.png", replace
restore

** Variances
 foreach var in consumption income wealth {
	 egen sd_l_`var'_a = sd(l_`var'), by(age)
	 gen var_l_`var'_a = (sd_l_`var'_a)^2
	 egen sd_l_`var'_a_u = sd(l_`var'), by(age urban)
	 gen var_l_`var'_a_u = (sd_l_`var'_a_u)^2
 }

preserve
drop if age < 20
drop if age > 60
** Rural
twoway (connected var_l_consumption_a_u var_l_income_a_u var_l_wealth_a_u age if urban == 0, sort), xtitle("Age") title(" Var(log(CIW)) by age in rural areas") legend(order(1 "Var(log(con))" 2 "Var(log(inc))" 3 "Var(log(weal))")) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\V_Rural_lifec.png", replace
** Urban
twoway (connected var_l_consumption_a_u var_l_income_a_u var_l_wealth_a_u age if urban == 1, sort), xtitle("Age") title(" Var(log(CIW)) by age in urban areas") legend(order(1 "Var(log(con))" 2 "Var(log(inc))" 3 "Var(log(weal))")) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\V_Urban_lifec.png", replace
** Total
twoway (connected var_l_consumption_a var_l_income_a var_l_wealth_a age, sort), xtitle("Age") title(" Var(log(CIW)) by age in all country") legend(order(1 "Var(log(con))" 2 "Var(log(inc))" 3 "Var(log(weal))")) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\V_All_lifec.png", replace
restore

**QUESTION 1.5.
/*  Rank your households by income, and dicuss the behavior of the top and 
bottom of the consumption and wealth distributions conditional on income */
** Analysis top 1% 
preserve
_pctile income, nq(100)
drop if income <r(r99) 
mean(consumption income wealth)
restore

** Analysis bottom 1% 
preserve
_pctile income, nq(100)
drop if income>r(r1) 
mean(consumption income wealth)
restore

** Analysis top 10% 
preserve
_pctile income, nq(100)
drop if income <r(r90) 
mean(consumption income wealth)
restore

** Analysis bottom 10% 
preserve
_pctile income, nq(100)
drop if income>r(r10) 
mean(consumption income wealth)
restore
	
/*
Top 10%
Mean estimation                   Number of obs   =        236

--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
 consumption |   2045.294   75.47743      1896.595    2193.993
      income |   8444.129   271.6838      7908.882    8979.376
      wealth |   8411.723   713.4091      7006.229    9817.218
--------------------------------------------------------------


Bottom 10%
Mean estimation                   Number of obs   =        236

--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
 consumption |   548.2621     25.558        497.91    598.6141
      income |   92.61779   2.965193      86.77603    98.45954
      wealth |   1939.306   271.5811      1404.261     2474.35
--------------------------------------------------------------


*/

*/

*******************************************************************
*******************************************************************
** QUESTION 2
/*
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Final data. Question 2.dta" , clear

** Trim all negative values
rename total_income income
rename total_wealth wealth
keep if consumption >0
keep if wealth >0
keep if income >0
egen total1= rowtotal(income wealth)
keep if consumption < total1
_pctile consumption, nq(100)
drop if consumption >r(r99) 
_pctile income, nq(100)
drop if income >r(r99)
_pctile wealth, nq(100)
drop if wealth >r(r99) 

** Conversion to USD 2013 (we use an average exchange rate of c. 2500)
replace income = income_labor/2500

**QUESTION 2.1
**Report intensive and extensive margin separately for rural and urban areas
mean(intensive_margin extensive_margin) [pw=wgt_X]
mean(intensive_margin extensive_margin) [pw=wgt_X] if urban == 1
mean(intensive_margin extensive_margin) [pw=wgt_X] if urban == 0 

/*

Mean estimation                   Number of obs   =      1,301

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   1781.132   50.65295      1681.762    1880.503
extensive_margin |   .4976523   .0018823      .4939596    .5013449
------------------------------------------------------------------

. mean(intensive_margin extensive_margin) [pw=wgt_X] if urban == 1

Mean estimation                   Number of obs   =        412

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   2481.894    108.116      2269.364    2694.423
extensive_margin |   .5903867   1.68e-18      .5903867    .5903867
------------------------------------------------------------------

. mean(intensive_margin extensive_margin) [pw=wgt_X] if urban == 0 

Mean estimation                   Number of obs   =        889

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   1474.803   52.15897      1372.433    1577.172
extensive_margin |   .4571145   3.10e-18      .4571145    .4571145

*/

**Intensive and extensive inequality: (1) Show histogram for CIW separately for rural and urban 
**areas; 
** Histograms.  
preserve

twoway (histogram intensive_margin if urban==0, fcolor(none) lcolor(green)) ///
(histogram intensive_margin if urban==1, fcolor(none) lcolor(blue)), ///
legend(order(1 "Rural" 2 "Urban")) xtitle(intensive_margin) graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histintensivmargin.png", replace
restore
** the joint cross-sectional behavior of CIW and the intensive margins
correlate (consumption income wealth intensive_margin)
correlate (consumption income wealth intensive_margin) if urban == 0
correlate (consumption income wealth intensive_margin) if urban == 1

/*

             | consum~n   income   wealth intens~n
-------------+------------------------------------
 consumption |   1.0000
      income |   0.2816   1.0000
      wealth |   0.5750   0.1589   1.0000
intensive_~n |   0.2599   0.5631   0.1193   1.0000


. correlate (consumption income wealth intensive_margin) if urban == 0
(obs=1,722)

             | consum~n   income   wealth intens~n
-------------+------------------------------------
 consumption |   1.0000
      income |   0.1584   1.0000
      wealth |   0.5002   0.0872   1.0000
intensive_~n |   0.1409   0.4848   0.0538   1.0000


. correlate (consumption income wealth intensive_margin) if urban == 1
(obs=631)

             | consum~n   income   wealth intens~n
-------------+------------------------------------
 consumption |   1.0000
      income |   0.2685   1.0000
      wealth |   0.5791   0.1272   1.0000
intensive_~n |   0.2406   0.5887   0.0748   1.0000


*/

** Intensive margin over the lifecycle
preserve
drop if age <20
drop if age >60
collapse (mean) intensive_margin, by(age)
graph twoway (line intensive_margin age, fcolor(none) lcolor(navy)), xtitle("Age") xlabel(15(10)70, labsize(medlarge) noticks grid angle(0)) ///
ylabel(, labsize(medlarge) nogrid) ytitle("Average intensive margin") graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_intensivemargin_lifec.png", replace	 
restore

**QUESTION 2.2. GENDER BASED ANALYSIS (MEANS, NOT INEQUALITY)
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Final data. Question 2.dta" , clear
 
 ** Trim all negative and weird values
rename total_income income
rename total_wealth wealth
keep if income >0
keep if wealth >0
drop if age <20
drop if age >60
drop if gender==.
_pctile consumption, nq(100)
drop if consumption >r(r99) 
_pctile income, nq(100)
drop if income >r(r99)
_pctile wealth, nq(100)
drop if wealth >r(r99) 

** Conversion to USD 2013 (we use an average exchange rate of c. 2500)
replace consumption = consumption/2500
replace income = income/2500
replace wealth = wealth/2500
 
** Average labor supply for rural and urban areas
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if gender==1
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 1 & gender==1
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 0 & gender==1

mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if gender==2
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 1 & gender==2
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 0 & gender==2

/*

Mean estimation                   Number of obs   =        920

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   1692.315   57.56482      1579.341    1805.289
extensive_margin |   .4954313   .0022095      .4910951    .4997676
     consumption |   1094.798   27.26014      1041.299    1148.298
          income |   2210.352   100.5296      2013.058    2407.646
          wealth |   2694.663   189.0373      2323.668    3065.658
------------------------------------------------------------------

. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 1 & gender
> ==1

Mean estimation                   Number of obs   =        275

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   2353.078   123.2178      2110.505    2595.652
extensive_margin |   .5903867          0             .           .
     consumption |   1416.821   60.25481        1298.2    1535.442
          income |   3508.781    242.481      3031.418    3986.144
          wealth |   4085.248   471.7789      3156.476     5014.02
------------------------------------------------------------------

. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 0 & gender
> ==1

Mean estimation                   Number of obs   =        645

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   1425.681   60.78118      1306.328    1545.034
extensive_margin |   .4571145          0             .           .
     consumption |   964.8544   28.21911      909.4418    1020.267
          income |   1686.404   94.45507      1500.927    1871.882
          wealth |   2133.528   180.4729      1779.141    2487.914
------------------------------------------------------------------

. 
. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if gender==2

Mean estimation                   Number of obs   =        353

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   1686.266   101.4714        1486.7    1885.833
extensive_margin |   .5028332   .0038319      .4952969    .5103695
     consumption |   1028.707   37.89345      954.1805    1103.233
          income |   2084.685   169.4168      1751.488    2417.881
          wealth |   2852.261   281.7796      2298.078    3406.445
------------------------------------------------------------------

. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 1 & gender
> ==2

Mean estimation                   Number of obs   =        118

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   2290.634    215.781      1863.291    2717.977
extensive_margin |   .5903867   5.49e-18      .5903867    .5903867
     consumption |   1372.594   84.62021      1205.008    1540.179
          income |   3188.331   368.5919      2458.354    3918.308
          wealth |   4461.255   623.0773      3227.283    5695.227
------------------------------------------------------------------

. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 0 & gender
> ==2

Mean estimation                   Number of obs   =        235

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   1370.678   102.0572      1169.609    1571.746
extensive_margin |   .4571145          0             .           .
     consumption |   849.1356   33.70907      782.7235    915.5476
          income |   1508.383   164.6724      1183.953    1832.813
          wealth |   2012.077   268.0799      1483.918    2540.236
------------------------------------------------------------------

*/
  
** Histogram for labor supply for rural and urban areas 
preserve 
twoway (histogram intensive_margin if urban==1 & gender==1, fcolor(none) lcolor(green)) ///
(histogram intensive_margin if urban==1 & gender==2, fcolor(none) lcolor(blue)), ///
legend(order(1 "Male" 2 "Female")) xtitle("Intensive margin in urban areas") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histintensivemarginurbangender.png", replace 
twoway (histogram intensive_margin if urban==0 & gender==1, fcolor(none) lcolor(green)) ///
(histogram intensive_margin if urban==0 & gender==2, fcolor(none) lcolor(blue)), ///
legend(order(1 "Male" 2 "Female")) xtitle("Intensive margin in rural areas") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histintensivemarginruralgender.png", replace 
restore

preserve
twoway (histogram consumption if urban==1 & gender==1, fcolor(none) lcolor(green)) ///
(histogram consumption if urban==1 & gender==2, fcolor(none) lcolor(blue)), ///
legend(order(1 "Male" 2 "Female")) xtitle("Consumption in urban areas") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histconsumptionurbangender.png", replace 
twoway (histogram consumption if urban==0 & gender==1, fcolor(none) lcolor(green)) ///
(histogram consumption if urban==0 & gender==2, fcolor(none) lcolor(blue)), ///
legend(order(1 "Male" 2 "Female")) xtitle("Consumption in rural areas") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histconsumptionruralgender.png", replace 
restore

preserve
twoway (histogram income if urban==1 & gender==1, fcolor(none) lcolor(green)) ///
(histogram income if urban==1 & gender==2, fcolor(none) lcolor(blue)), ///
legend(order(1 "Male" 2 "Female")) xtitle("Income in urban areas") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histincomeurbangender.png", replace 
twoway (histogram income if urban==0 & gender==1, fcolor(none) lcolor(green)) ///
(histogram income if urban==0 & gender==2, fcolor(none) lcolor(blue)), ///
legend(order(1 "Male" 2 "Female")) xtitle("Income in rural areas") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histincomeruralgender.png", replace 
restore

preserve
twoway (histogram wealth if urban==1 & gender==1, fcolor(none) lcolor(green)) ///
(histogram wealth if urban==1 & gender==2, fcolor(none) lcolor(blue)), ///
legend(order(1 "Male" 2 "Female")) xtitle("Wealth in urban areas") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histwealthurbangender.png", replace 
twoway (histogram wealth if urban==0 & gender==1, fcolor(none) lcolor(green)) ///
(histogram wealth if urban==0 & gender==2, fcolor(none) lcolor(blue)), ///
legend(order(1 "Male" 2 "Female")) xtitle("Wealth in rural areas") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histwealthruralgender.png", replace  
restore

** Evolution by genre
preserve
collapse (mean) intensive_margin, by(age gender) 
graph twoway (line intensive_margin age if gender==1, fcolor(none) lcolor(navy))(line intensive_margin age if gender==2, fcolor(red) lcolor(blue)), ///
xtitle("Age") xlabel(15(10)70, labsize(medlarge) noticks grid angle(0))ylabel(, labsize(medlarge) nogrid) ytitle("Intensive margin. By gender", size(medlarge)) ///
legend(order(1 "Male" 2 "Female")) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_intensivemargin_lifec_gender.png", replace
restore

preserve
collapse (mean) consumption, by(age gender) 
graph twoway (line consumption age if gender==1, fcolor(none) lcolor(navy))(line consumption age if gender==2, fcolor(red) lcolor(blue)), ///
xtitle("Age") xlabel(15(10)70, labsize(medlarge) noticks grid angle(0))ylabel(, labsize(medlarge) nogrid) ytitle("Consumption. By gender", size(medlarge)) ///
legend(order(1 "Male" 2 "Female")) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_consumption_lifec_gender.png", replace
restore

preserve
collapse (mean) income, by(age gender) 
graph twoway (line income age if gender==1, fcolor(none) lcolor(navy))(line income age if gender==2, fcolor(red) lcolor(blue)), ///
xtitle("Age") xlabel(15(10)70, labsize(medlarge) noticks grid angle(0))ylabel(, labsize(medlarge) nogrid) ytitle("Income. By genre", size(medlarge)) ///
legend(order(1 "Male" 2 "Female")) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_income_lifec_gender.png", replace
restore

preserve
collapse (mean) wealth, by(age gender) 
graph twoway (line wealth age if gender==1, fcolor(none) lcolor(navy))(line wealth age if gender==2, fcolor(red) lcolor(blue)), ///
xtitle("Age") xlabel(15(10)70, labsize(medlarge) noticks grid angle(0))ylabel(, labsize(medlarge) nogrid) ytitle("Wealth. By genre", size(medlarge)) ///
legend(order(1 "Male" 2 "Female")) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_wealth_lifec_gender.png", replace
restore
 
 ****(...)same analysis as before

**QUESTION 1.2. EDUCATION BASED ANALYSIS (MEANS, NOT INEQUALITY)
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Final data. Question 2.dta" , clear
 
** Trim all negative values
rename total_income income
rename total_wealth wealth
keep if income >0
keep if wealth >0
drop if age <25
drop if age >60
drop if education==.
drop if education==99
_pctile consumption, nq(100)
drop if consumption >r(r99) 
_pctile income, nq(100)
drop if income >r(r99)
_pctile wealth, nq(100)
drop if wealth >r(r99) 

** Conversion to USD 2013 (we use an average exchange rate of c. 2500)
replace consumption = consumption/2500
replace income = income/2500
replace wealth = wealth/2500

** Generate education
gen educ = 1
replace educ = 2 if education >=17 & educ < 34
replace educ = 3 if education >=34

** Average intensive margin, and CIW for rural and urban areas by education
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if educ==1
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 1 & educ==1
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 0 & educ==1

mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if educ==2
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 1 & educ==2
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 0 & educ==2

mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if educ==3
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 1 & educ==3
mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 0 & educ==3
/*
Mean estimation                   Number of obs   =        411

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   1433.893   77.87247      1280.814    1586.972
extensive_margin |   .4816343   .0027449      .4762384    .4870302
     consumption |    927.033   31.83898      864.4449     989.621
          income |   1593.177   136.0648      1325.705    1860.649
          wealth |   1766.487   201.1926      1370.989    2161.984
------------------------------------------------------------------

. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 1 & educ==
> 1

Mean estimation                   Number of obs   =         80

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   2200.185   227.0717       1748.21     2652.16
extensive_margin |   .5903867   4.36e-18      .5903867    .5903867
     consumption |   1149.262   82.59393      984.8627    1313.661
          income |   2549.795   409.9198       1733.87     3365.72
          wealth |   2949.221   834.1137      1288.959    4609.483
------------------------------------------------------------------

. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 0 & educ==
> 1

Mean estimation                   Number of obs   =        331

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   1261.122   78.66728      1106.369    1415.874
extensive_margin |   .4571145   2.00e-18      .4571145    .4571145
     consumption |   876.9282   34.03203      809.9811    943.8753
          income |   1377.494   136.7852      1108.413    1646.575
          wealth |   1499.822   157.2399      1190.503    1809.141
------------------------------------------------------------------

. 
. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if educ==2

Mean estimation                   Number of obs   =        325

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   1729.982   104.8943      1523.622    1936.342
extensive_margin |   .4985018   .0038084      .4910095    .5059942
     consumption |   1140.567   43.67297      1054.649    1226.485
          income |   2424.391   185.8287      2058.808    2789.974
          wealth |   3080.329   301.3047      2487.568    3673.089
------------------------------------------------------------------

. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 1 & educ==
> 2

Mean estimation                   Number of obs   =         98

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   2417.131   209.3683      2001.593    2832.669
extensive_margin |   .5903867          0             .           .
     consumption |   1367.957   92.33838      1184.691    1551.223
          income |   3303.622   369.1452      2570.971    4036.273
          wealth |   4432.854   687.2385      3068.875    5796.832
------------------------------------------------------------------

. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 0 & educ==
> 2

Mean estimation                   Number of obs   =        227

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   1420.472   114.8675      1194.124     1646.82
extensive_margin |   .4571145          0             .           .
     consumption |   1038.145   46.93615      945.6561    1130.633
          income |   2028.362   207.4773      1619.525      2437.2
          wealth |   2471.116   300.5589       1878.86    3063.373
------------------------------------------------------------------

. 
. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if educ==3

Mean estimation                   Number of obs   =        316

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   2193.769   110.5143      1976.329    2411.208
extensive_margin |   .5241339   .0042367       .515798    .5324697
     consumption |   1450.872   55.42175      1341.828    1559.915
          income |   3358.569   210.2974      2944.804    3772.334
          wealth |   4807.102   455.0281      3911.823     5702.38
------------------------------------------------------------------

. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 1 & educ==
> 3

Mean estimation                   Number of obs   =        157

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |   2550.846   179.7175      2195.853     2905.84
extensive_margin |   .5903867   7.47e-18      .5903867    .5903867
     consumption |   1726.371   91.51411      1545.605    1907.138
          income |   4330.513   362.6058      3614.263    5046.764
          wealth |   5694.112    697.805      4315.747    7072.478
------------------------------------------------------------------

. mean(intensive_margin extensive_margin consumption income wealth) [pw=wgt_X] if urban == 0 & educ==
> 3

Mean estimation                   Number of obs   =        159

------------------------------------------------------------------
                 |       Mean   Std. Err.     [95% Conf. Interval]
-----------------+------------------------------------------------
intensive_margin |    1832.56   120.8515      1593.867    2071.253
extensive_margin |   .4571145          0             .           .
     consumption |   1172.184   57.94942      1057.729     1286.64
          income |   2375.378   191.4815      1997.185    2753.572
          wealth |   3909.829   584.0821      2756.213    5063.445
*/
/* ** Histogram for margins and CIW for rural and urban areas  
twoway (histogram intensive_margin if urban==1 & educ==1, fcolor(none) lcolor(green)) ///
(histogram intensive_margin if urban==1 & educ==2, fcolor(none) lcolor(blue)), ///
(histogram intensive_margin if urban==1 & educ==3, fcolor(none) lcolor(purple)), ///
legend(order(1 "Less than primary school" 2 "Less than high school" 3 "High school or more") xtitle("Intensive margin in urban areas. By education") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histintensivemarginurbaneduc.png", replace 
twoway (histogram intensive_margin if urban==0 & educ==1, fcolor(none) lcolor(green)) ///
(histogram intensive_margin if urban==0 & educ==2, fcolor(none) lcolor(blue)), ///
(histogram intensive_margin if urban==0 & educ==3, fcolor(none) lcolor(purple)), ///
legend(order(1 "Less than primary school" 2 "Less than high school" 3 "High school or more") xtitle("Intensive margin in rural areas. By education") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histintensivemarginruraleduc.png", replace 

twoway (histogram consumption if urban==1 & educ==1, fcolor(none) lcolor(green)) ///
(histogram consumption if urban==1 & educ==2, fcolor(none) lcolor(blue)), ///
(histogram consumption if urban==1 & educ==3, fcolor(none) lcolor(purple)), ///
legend(order(1 "Less than primary school" 2 "Less than high school" 3 "High school or more") xtitle("Consumption in urban areas. By education") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histconsumptionurbaneduc.png", replace 
twoway (histogram consumption if urban==0 & educ==1, fcolor(none) lcolor(green)) ///
(histogram consumption if urban==0 & educ==2, fcolor(none) lcolor(blue)), ///
(histogram consumption if urban==0 & educ==3, fcolor(none) lcolor(purple)), ///
legend(order(1 "Less than primary school" 2 "Less than high school" 3 "High school or more") xtitle("Consumption in rural areas. By education") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histconsumptionruraleduc.png", replace 

twoway (histogram income if urban==1 & educ==1, fcolor(none) lcolor(green)) ///
(histogram income if urban==1 & educ==2, fcolor(none) lcolor(blue)), ///
(histogram income if urban==1 & educ==3, fcolor(none) lcolor(purple)), ///
legend(order(1 "Less than primary school" 2 "Less than high school" 3 "High school or more") xtitle("Income in urban areas. By education") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histincomeurbaneduc.png", replace 
twoway (histogram income if urban==0 & educ==1, fcolor(none) lcolor(green)) ///
(histogram income if urban==0 & educ==2, fcolor(none) lcolor(blue)), ///
(histogram income if urban==0 & educ==3, fcolor(none) lcolor(purple)), ///
legend(order(1 "Less than primary school" 2 "Less than high school" 3 "High school or more") xtitle("Income in rural areas. By education") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histincomeruraleduc.png", replace 

twoway (histogram wealth if urban==1 & educ==1, fcolor(none) lcolor(green)) ///
(histogram wealth if urban==1 & educ==2, fcolor(none) lcolor(blue)), ///
(histogram wealth if urban==1 & educ==3, fcolor(none) lcolor(purple)), ///
legend(order(1 "Less than primary school" 2 "Less than high school" 3 "High school or more") xtitle("Wealth in urban areas. By education") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histwealthurbaneduc.png", replace 
twoway (histogram wealth if urban==0 & educ==1, fcolor(none) lcolor(green)) ///
(histogram wealth if urban==0 & educ==2, fcolor(none) lcolor(blue)), ///
(histogram wealth if urban==0 & educ==3, fcolor(none) lcolor(purple)), ///
legend(order(1 "Less than primary school" 2 "Less than high school" 3 "High school or more") xtitle("Wealth in rural areas. By education") graphregion(color(white)) 
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\histwealthruraleduc.png", replace 
*/
 ** Variables over the lifecycle
preserve
collapse (mean) intensive_margin, by(age educ) 
graph twoway (line intensive_margin age if educ==1, fcolor(none) lcolor(blue))(line intensive_margin age if educ==2, fcolor(none) lcolor(red)) ///
(line intensive_margin age if educ==3, fcolor(none) lcolor(green)),xtitle("Age") xlabel(15(10)70, labsize(medlarge) noticks grid angle(0)) ///
ylabel(, labsize(medlarge) nogrid) ytitle("Intensive margin. By education", size(medlarge)) ///
legend(order(1 "Less than primary studies" 2 "Primary and secondary studies" 3 "Highschool studies or more")) ///
graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_intensive_margin_lifec_educ.png", replace
restore

preserve
collapse (mean) consumption, by(age educ) 
graph twoway (line consumption age if educ==1, fcolor(none) lcolor(blue))(line consumption age if educ==2, fcolor(none) lcolor(red)) ///
(line consumption age if educ==3, fcolor(none) lcolor(green)),xtitle("Age") xlabel(15(10)70, labsize(medlarge) noticks grid angle(0)) ///
ylabel(, labsize(medlarge) nogrid) ytitle("Consumption. By education", size(medlarge)) ///
legend(order(1 "Less than primary studies" 2 "Primary and secondary studies" 3 "Highschool studies or more")) ///
graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_consumption_lifec_educ.png", replace
restore

preserve
collapse (mean) income, by(age educ) 
graph twoway (line income age if educ==1, fcolor(none) lcolor(blue))(line income age if educ==2, fcolor(none) lcolor(red)) ///
(line income age if educ==3, fcolor(none) lcolor(green)),xtitle("Age") xlabel(15(10)70, labsize(medlarge) noticks grid angle(0)) ///
ylabel(, labsize(medlarge) nogrid) ytitle("Income. By education", size(medlarge)) ///
legend(order(1 "Less than primary studies" 2 "Primary and secondary studies" 3 "Highschool studies or more")) ///
graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_income_lifec_educ.png", replace
restore

preserve
collapse (mean) wealth, by(age educ) 
graph twoway (line wealth age if educ==1, fcolor(none) lcolor(blue))(line wealth age if educ==2, fcolor(none) lcolor(red)) ///
(line wealth age if educ==3, fcolor(none) lcolor(green)),xtitle("Age") xlabel(15(10)70, labsize(medlarge) noticks grid angle(0)) ///
ylabel(, labsize(medlarge) nogrid) ytitle("Wealth. By education", size(medlarge)) ///
legend(order(1 "Less than primary studies" 2 "Primary and secondary studies" 3 "Highschool studies or more")) ///
graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\A_wealth_lifec_educ.png", replace
restore

*/

*******************************************************************
*******************************************************************
** QUESTION 3
use "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Final data. Question 2.dta" , clear

** Trim all negative values
rename total_income income
rename total_wealth wealth
keep if income >0
keep if wealth >0
drop if age <25
drop if age >60
drop if education==.
drop if education==99
_pctile consumption, nq(100)
drop if consumption >r(r99) 
_pctile income, nq(100)
drop if income >r(r99)
_pctile wealth, nq(100)
drop if wealth >r(r99)

** Conversion to USD 2013 (we use an average exchange rate of c. 2500)
replace consumption = consumption/2500
replace income = income/2500
replace wealth = wealth/2500

 ** QUESTION 3.1. Plot the level of consumption, wealth, intensive margin and extensive margin by zone against the level of household income by zone
preserve
collapse (mean) intensive_margin extensive_margin consumption income wealth, by (district_code) 
scatter intensive_margin income || lfit intensive_margin income, ytitle("Intensive margin", size(medlarge))ylabel(, labsize(medlarge) noticks nogrid) xtitle("Income", size(medlarge))graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Levels_intensivemarginvsincome.png", replace
restore
preserve
collapse (mean) intensive_margin extensive_margin consumption income wealth, by (district_code) 
scatter extensive_margin income || lfit extensive_margin income, ytitle("Extensive margin", size(medlarge))ylabel(, labsize(medlarge) noticks nogrid) xtitle("Income", size(medlarge))graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Levels_extensivemarginvsincome.png", replace
restore
preserve
collapse (mean) intensive_margin extensive_margin consumption income wealth, by (district_code) 
scatter consumption income || lfit consumption income, ytitle("Concumption", size(medlarge))ylabel(, labsize(medlarge) noticks nogrid) xtitle("Income", size(medlarge))graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Levels_consumptionvsincome.png", replace
restore
preserve
collapse (mean) intensive_margin extensive_margin consumption income wealth, by (district_code) 
scatter wealth income || lfit wealth income, ytitle("Wealth", size(medlarge))ylabel(, labsize(medlarge) noticks nogrid) xtitle("Income", size(medlarge))graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Levels_wealthvsincome.png", replace
restore

 ** QUESTION 3.2. Plot the inequality of CIW and labor supply by zone (or district) against the level of household income by zone.
 foreach var in intensive_margin consumption income wealth {
	 bysort district_code: egen sd_`var'= sd(`var')
	 gen v_`var'=(sd_`var')^2		
 }
 
preserve
collapse (mean) v_intensive_margin v_consumption v_income v_wealth income wealth consumption, by(district_code)
scatter v_intensive_margin income || lfit v_intensive_margin income, ytitle("Mean var intensive margin", size(medlarge)) ylabel(, labsize(medlarge) noticks nogrid) xtitle("Mean income", size(medlarge)) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Inequality_intensivemarginvsincome.png", replace
restore

preserve
collapse (mean) v_intensive_margin v_consumption v_income v_wealth income wealth consumption, by(district_code)
scatter v_consumption income || lfit v_consumption income, ytitle("Mean var consumption", size(medlarge)) ylabel(, labsize(medlarge) noticks nogrid) xtitle("Mean income", size(medlarge)) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Inequality_consumptionvsincome.png", replace
restore

preserve
collapse (mean) v_intensive_margin v_consumption v_income v_wealth income wealth consumption, by(district_code)
scatter v_income income || lfit v_income income, ytitle("Mean var income", size(medlarge)) ylabel(, labsize(medlarge) noticks nogrid) xtitle("Mean income", size(medlarge)) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Inequality_incomevsincome.png", replace
restore
	
preserve
collapse (mean) v_intensive_margin v_consumption v_income v_wealth income wealth consumption, by(district_code)
scatter v_wealth income || lfit v_wealth income, ytitle("Mean var wealth", size(medlarge)) ylabel(, labsize(medlarge) noticks nogrid) xtitle("Mean income", size(medlarge)) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Inequality_wealthvsincome.png", replace
restore

** QUESTION 3.3 Plot the covariances of CIW and labor supply by zone (or district) against the level of household income by zone
bysort district_code: egen c_intensive_margin_consumption= corr(consumption intensive_margin)
bysort district_code: egen c_intensive_margin_income= corr(income intensive_margin)
bysort district_code: egen c_consumption_wealth= corr(consumption wealth)
bysort district_code: egen c_consumption_income= corr(consumption income)
 
**Just a few
preserve
collapse (mean) c_intensive_margin_consumption c_consumption_wealth c_consumption_income income, by(district_code)
scatter c_intensive_margin_consumption income || lfit c_intensive_margin_consumption income, ytitle("Correlation intensive margin and consumption", size(medlarge)) ylabel(, labsize(medlarge) noticks nogrid) xtitle("Mean income", size(medlarge)) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Correlation_intensivemargin&consumptionvsincome.png", replace
restore

preserve
collapse (mean) c_intensive_margin_income c_intensive_margin_consumption c_consumption_wealth c_consumption_income income, by(district_code)
scatter c_intensive_margin_income income || lfit c_intensive_margin_consumption income, ytitle("Correlation intensive margin and income", size(medlarge)) ylabel(, labsize(medlarge) noticks nogrid) xtitle("Mean income", size(medlarge)) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Correlation_intensivemargin&incomevsincome.png", replace
restore

preserve
collapse (mean) c_intensive_margin_consumption c_consumption_wealth c_consumption_income income, by(district_code)
scatter c_consumption_wealth income || lfit c_consumption_wealth income, ytitle("Correlation consumption and wealth", size(medlarge)) ylabel(, labsize(medlarge) noticks nogrid) xtitle("Mean income", size(medlarge)) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Correlation_wealth&consumptionvsincome.png", replace
restore

preserve
collapse (mean) c_intensive_margin_consumption c_consumption_wealth c_consumption_income income, by(district_code)
scatter c_consumption_income income || lfit c_consumption_income income, ytitle("Correlation consumption and income", size(medlarge)) ylabel(, labsize(medlarge) noticks nogrid) xtitle("Mean income", size(medlarge)) graphregion(color(white))
graph export "C:\Users\beras\OneDrive\Escritorio\UGANDA\Working. UGA 13\Correlation_income&consumptionvsincome.png", replace
restore

** QUESTION 3.4
bysort district_code: egen totalhoursperdistrict = sum(intensive_margin)
bysort district_code: egen totalincomeperdistrict = sum(income_labor)

gen loghoursworked = log(totalhoursperdistrict)
gen logwage = log(totalincomeperdistrict/totalhoursperdistrict)
gen age2 = age^2

reg loghoursworked logwage age age2, vce(cluster district_code)



/*

Linear regression                               Number of obs     =      1,824
                                                F(3, 88)          =       0.77
                                                Prob > F          =     0.5145
                                                R-squared         =     0.0211
                                                Root MSE          =     1.1381

                         (Std. Err. adjusted for 89 clusters in district_code)
------------------------------------------------------------------------------
             |               Robust
loghourswo~d |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
     logwage |   .2759586   .2686242     1.03   0.307    -.2578755    .8097927
         age |   .0210223   .0264472     0.79   0.429    -.0315359    .0735805
        age2 |  -.0002593    .000291    -0.89   0.375    -.0008376    .0003189
       _cons |   7.651095   1.794228     4.26   0.000     4.085444    11.21675
------------------------------------------------------------------------------

. 
. 
. */

*/
