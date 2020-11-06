Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table8\ex_all1.csv' 
Out=all_data dbms=csv replace;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table8\rate.csv' 
Out=int dbms=csv replace;
run;
proc rank data=int output=int descending group=4;
var rate;
ranks r_rate;
run;
data int;
set int;
if r_rate=3 then rrate=1;
if r_rate=0 then rrate=0;
if r_rate=1 then rrate=0;
if r_rate=2 then rrate=0;
run;

proc sort data=int out=int;
by date;
run;
proc sort data=all_data out=all_data;
by date;
run;
data all_data1;
merge all_data int;
by date;
run;
data all_data1;
set all_data1;
if date=. then delete;
run;


Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table6\dy.csv' 
Out=dy dbms=csv replace;
run;
proc sort data=dy;
by code;
run;
proc means data=dy mean;
var dy;
class code;
output out=divmean mean=div_mean; /* mean   */
run; 
proc sort data=divmean;
by descending div_mean;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table6\kospi200.csv' 
Out=kospi200 dbms=csv replace;
run;
data divmean;
set divmean;
if div_mean>0;
run;
proc sort data=kospi200;
by code;
run;
proc sort data=divmean;
by code;
run;
data divmean;
merge divmean kospi200;
by code;
run;
proc sort data=divmean;
by descending div_mean;
run;
/*rank  */
proc rank data=divmean out=divrank descending group=4;
var div_mean;
ranks r_div;
run;
data r_1 r_2 r_3 r_4;
set divrank;
if r_div=0 then output r_1;
if r_div=1 then output r_2;
if r_div=2 then output r_3;
if r_div=3 then output r_4;
drop _TYPE_ _FREQ_;
run;
proc sort data=all_data1;
by code date;
run;
proc sort data=r_1 out=r_1;
by code;
run;


proc sql;
create table reg as
select r_1.code, all_data1.date, all_data1.owner, all_data1.dy, all_data1.rate, all_data1.p_return, all_data1.p_owner, all_data1.return, all_data1.rrate
from r_1, all_data1
where r_1.code = all_data1.code;
quit;
data reg;
set reg;
owner1=log(owner);
if owner=0 then owner1=0;
p_owner1=log(p_owner);
if p_owner=0 then p_owner1=0;
dyrate=dy*rate;
owner1rate=owner1*rate;
dyrrate=dy*rrate;
owner1rrate=owner1*rate;
run;

proc reg data=reg;
model return=owner1 dy p_return dyrrate owner1rrate/vif;
run;
/*----------------------r_2*/
proc sort data=r_4 out=r_4;
by code;
run;


proc sql;
create table reg4 as
select r_4.code, all_data1.date, all_data1.owner, all_data1.dy, all_data1.rate, all_data1.p_return, all_data1.p_owner, all_data1.return
from r_4, all_data1
where r_4.code = all_data1.code;
quit;
data reg4;
set reg4;
owner1=log(owner);
if owner=0 then owner1=0;
p_owner1=log(p_owner);
if p_owner=0 then p_owner1=0;
dyrate=dy*rate;
owner1rate=owner1*rate;

run;

proc reg data=reg4;
model return=rate owner1 p_return dy/vif;
run;

proc panel data=reg;
model return=rate owner1 p_return dy /fixonetime;
id code date;
run;
