Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table1\DIVIDEND_FINAL.csv' 
Out=div_final dbms=csv replace;
run;
proc sort data=div_final;
by date;
run;
data div2.div;
set div_final;
if 200101<= date <=200411;
run;
proc sort data=div2.div;
by code;
run;
proc means data=div2.div mean;
var div;
class code;
output out=div2.divmean mean=div_mean; /*¡¡ mean   */
run; 
proc sort data=div2.divmean;
by descending div_mean;
run;
data div2.divmean;
set div2.divmean;
if div_mean>0;
run;
/*rank ¡¡ */
proc rank data=div2.divmean out=div2.divrank descending group=4;
var div_mean;
ranks r_div;
run;
data div2.r_1 div2.r_2 div2.r_3 div2.r_4;
set div2.divrank;
if r_div=0 then output div2.r_1;
if r_div=1 then output div2.r_2;
if r_div=2 then output div2.r_3;
if r_div=3 then output div2.r_4;
drop _TYPE_ _FREQ_;
run;
*2. 5 ¡¡ return.;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\all_data.csv' Out=all_data  dbms=csv replace;
Proc import datafile= 'C:\Users\haesong\Desktop\hsongchoi\Table1\kospi_0526.csv' out=kospi dbms=csv replace;
run;
data kospi1;
set kospi;
if 200101<= date <=200411;
run;
data all_data;
set all_data;
if 200101<= date <=200411;
run;
proc sort data=kospi1;
by code;
run;
data r_1;
set div2.r_1;
run;
proc sql;
create table div2.ri_1 as
select kospi1.code, kospi1.date, kospi1.ri
from r_1, kospi1
where r_1.code = kospi1.code;
quit;
proc sort data=div2.ri_1;
by date;
run;
data div2.reg2_1;
merge all_data div2.ri_1;
by date;
run;
proc sort data=div2.reg2_1;
by code;
run;
data div2.reg2_1;
set div2.reg2_1;
rirf=ri-rf;
rmrf=rm-rf;
run;

proc reg data=div2.reg2_1;
model rirf=rmrf interest_m_/ vif;
run;
proc reg data=div2.reg2_1;
model rirf=interest_m_ smb hml mom/ vif;
run;
proc reg data=div2.reg2_1;
model rirf= rmrf interest_m_ smb hml mom/ vif;
run;
/*95-99 */
data r_2;
set div2.r_2;
run;
proc sql;
create table div2.ri_2 as
select kospi1.code, kospi1.date, kospi1.ri
from r_2, kospi1
where r_2.code = kospi1.code;
quit;
proc sort data=div2.ri_2;
by date;
run;
data div2.reg2_2;
merge all_data div2.ri_2;
by date;
run;
proc sort data=div2.reg2_2;
by code;
run;
data div2.reg2_2;
set div2.reg2_2;
rirf=ri-rf;
rmrf=rm-rf;
run;

proc reg data=div2.reg2_2;
model rirf=rmrf interest_m_/ vif;
run;
proc reg data=div2.reg2_2;
model rirf=rmrf interest_m_ smb hml mom/ vif;
run;
proc reg data=div2.reg2_2;
model rirf=interest_m_ smb hml mom/ vif;
run;
/*95-99 */
data r_3;
set div2.r_3;
run;
proc sql;
create table div2.ri_3 as
select kospi1.code, kospi1.date, kospi1.ri
from r_3, kospi1
where r_3.code = kospi1.code;
quit;
proc sort data=div2.ri_3;
by date;
run;
data div2.reg2_3;
merge all_data div2.ri_3;
by date;
run;
proc sort data=div2.reg2_3;
by code;
run;
data div2.reg2_3;
set div2.reg2_3;
rirf=ri-rf;
rmrf=rm-rf;
run;

proc reg data=div2.reg2_3;
model rirf=rmrf interest_m_/ vif;
run;
proc reg data=div2.reg2_3;
model rirf=rmrf interest_m_ smb hml mom/ vif;
run;
proc reg data=div2.reg2_3;
model rirf= interest_m_ smb hml mom/ vif;
run;
/*95-99 */

data r_4;
set div2.r_4;
run;
proc sql;
create table div2.ri_4 as
select kospi1.code, kospi1.date, kospi1.ri
from r_4, kospi1
where r_4.code = kospi1.code;
quit;
proc sort data=div2.ri_4;
by date;
run;
data div2.reg2_4;
merge all_data div2.ri_4;
by date;
run;
proc sort data=div2.reg2_4;
by code;
run;
data div2.reg2_4;
set div2.reg2_4;
rirf=ri-rf;
rmrf=rm-rf;
run;

proc reg data=div2.reg2_4;
model rirf=rmrf interest_m_/ vif;
run;
proc reg data=div2.reg2_4;
model rirf=rmrf interest_m_ smb hml mom/ vif;
run;
proc reg data=div2.reg2_4;
model rirf=interest_m_ smb hml mom/ vif;
run;
