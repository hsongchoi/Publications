Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table6\ex_all1.csv' 
Out=all_data dbms=csv replace;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table6\rate.csv' 
Out=int dbms=csv replace;
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
select r_1.code, all_data1.date, all_data1.owner, all_data1.dy, all_data1.rate, all_data1.p_return, all_data1.bps, r_1.kospi200, all_data1.eps
from r_1, all_data1
where r_1.code = all_data1.code;
quit;
data reg;
set reg;
owner1=log(owner);
bps1=log(bps);
eps1=log(eps);
dyrate=dy*rate;
if owner1=. then owner1=0;
if kospi200=. then kospi200=0;
if eps1=. then eps1=0;
run;

proc reg data=reg;
model owner1=dy rate bps1 eps1 p_return kospi200/vif;
run;
/*----------------------r_2*/
proc sort data=r_2 out=r_2;
by code;
run;


proc sql;
create table reg2 as
select r_2.code, all_data1.date, all_data1.owner, all_data1.dy, all_data1.rate, all_data1.p_return, all_data1.bps, r_2.kospi200, all_data1.eps
from r_2, all_data1
where r_2.code = all_data1.code;
quit;
data reg2;
set reg2;
owner1=log(owner);
bps1=log(bps);
eps1=log(eps);
dyrate=dy*rate;
if owner1=. then owner1=0;
if kospi200=. then kospi200=0;
if eps1=. then eps1=0;
run;

proc reg data=reg2;
model owner1= rate bps1 eps1 p_return kospi200/vif;
run;
/*----------------------r_3*/
proc sort data=r_3 out=r_3;
by code;
run;


proc sql;
create table reg3 as
select r_3.code, all_data1.date, all_data1.owner, all_data1.dy, all_data1.rate, all_data1.p_return, all_data1.bps, r_3.kospi200, all_data1.eps
from r_3, all_data1
where r_3.code = all_data1.code;
quit;
data reg3;
set reg3;
owner1=log(owner);
bps1=log(bps);
eps1=log(eps);
dyrate=dy*rate;
if owner1=. then owner1=0;
if kospi200=. then kospi200=0;
if eps1=. then eps1=0;
run;

proc reg data=reg3;
model owner1= rate bps1 eps1 p_return kospi200/vif;
run;
