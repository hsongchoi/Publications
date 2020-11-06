﻿Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table1\DIVIDEND_FINAL.csv' 
Out=div_final dbms=csv replace;
run;
proc sort data=div_final;
by date;
run;
data div4.div;
set div_final;
if 200810<= date <=201512;
run;
proc sort data=div4.div;
by code;
run;
proc means data=div4.div mean;
var div;
class code;
output out=div4.divmean mean=div_mean; /*�� mean   */
run; 
proc sort data=div4.divmean;
by descending div_mean;
run;
data div4.divmean;
set div4.divmean;
if div_mean>0;
run;
/*rank �� */
proc rank data=div4.divmean out=div4.divrank descending group=4;
var div_mean;
ranks r_div;
run;
data div4.r_1 div4.r_2 div4.r_3 div4.r_4;
set div4.divrank;
if r_div=0 then output div4.r_1;
if r_div=1 then output div4.r_2;
if r_div=2 then output div4.r_3;
if r_div=3 then output div4.r_4;
drop _TYPE_ _FREQ_;
run;
*2. 5 �� return.;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\all_data.csv' Out=all_data  dbms=csv replace;
Proc import datafile= 'C:\Users\haesong\Desktop\hsongchoi\Table1\kospi_0526.csv' out=kospi dbms=csv replace;
run;
data kospi1;
set kospi;
if 200810<= date <=201512;
run;
data all_data;
set all_data;
if 200810<= date <=201512;
run;
proc sort data=kospi1;
by code;
run;
data r_1;
set div4.r_1;
run;
proc sql;
create table div4.ri_1 as
select kospi1.code, kospi1.date, kospi1.ri
from r_1, kospi1
where r_1.code = kospi1.code;
quit;
proc sort data=div4.ri_1;
by date;
run;
data div4.reg4_1;
merge all_data div4.ri_1;
by date;
run;
proc sort data=div4.reg4_1;
by code;
run;
data div4.reg4_1;
set div4.reg4_1;
rirf=ri-rf;
rmrf=rm-rf;
run;

proc reg data=div4.reg4_1;
model rirf=rmrf interest_m_/ vif;
run;
proc reg data=div4.reg4_1;
model rirf=interest_m_ smb hml mom/ vif;
run;
proc reg data=div4.reg4_1;
model rirf= rmrf interest_m_ smb hml mom/ vif;
run;
/*95-99 */
data r_2;
set div4.r_2;
run;
proc sql;
create table div4.ri_2 as
select kospi1.code, kospi1.date, kospi1.ri
from r_2, kospi1
where r_2.code = kospi1.code;
quit;
proc sort data=div4.ri_2;
by date;
run;
data div4.reg4_2;
merge all_data div4.ri_2;
by date;
run;
proc sort data=div4.reg4_2;
by code;
run;
data div4.reg4_2;
set div4.reg4_2;
rirf=ri-rf;
rmrf=rm-rf;
run;

proc reg data=div4.reg4_2;
model rirf=rmrf interest_m_/ vif;
run;
proc reg data=div4.reg4_2;
model rirf=rmrf interest_m_ smb hml mom/ vif;
run;
proc reg data=div4.reg4_2;
model rirf=interest_m_ smb hml mom/ vif;
run;
/*95-99 */
data r_3;
set div4.r_3;
run;
proc sql;
create table div4.ri_3 as
select kospi1.code, kospi1.date, kospi1.ri
from r_3, kospi1
where r_3.code = kospi1.code;
quit;
proc sort data=div4.ri_3;
by date;
run;
data div4.reg4_3;
merge all_data div4.ri_3;
by date;
run;
proc sort data=div4.reg4_3;
by code;
run;
data div4.reg4_3;
set div4.reg4_3;
rirf=ri-rf;
rmrf=rm-rf;
run;

proc reg data=div4.reg4_3;
model rirf=rmrf interest_m_/ vif;
run;
proc reg data=div4.reg4_3;
model rirf=rmrf interest_m_ smb hml mom/ vif;
run;
proc reg data=div4.reg4_3;
model rirf= interest_m_ smb hml mom/ vif;
run;
/*95-99 */

data r_4;
set div4.r_4;
run;
proc sql;
create table div4.ri_4 as
select kospi1.code, kospi1.date, kospi1.ri
from r_4, kospi1
where r_4.code = kospi1.code;
quit;
proc sort data=div4.ri_4;
by date;
run;
data div4.reg4_4;
merge all_data div4.ri_4;
by date;
run;
proc sort data=div4.reg4_4;
by code;
run;
data div4.reg4_4;
set div4.reg4_4;
rirf=ri-rf;
rmrf=rm-rf;
run;

proc reg data=div4.reg4_4;
model rirf=rmrf interest_m_/ vif;
run;
proc reg data=div4.reg4_4;
model rirf=rmrf interest_m_ smb hml mom/ vif;
run;
proc reg data=div4.reg4_4;
model rirf=interest_m_ smb hml mom/ vif;
run;
