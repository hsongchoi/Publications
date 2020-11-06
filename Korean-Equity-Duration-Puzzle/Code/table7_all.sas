Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table7\all.csv' 
Out=all_data dbms=csv replace;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table7\rate.csv' 
Out=int dbms=csv replace;
run;
proc sort data=int;
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
proc rank data=all_data1 out=intrank descending group=4;
var rate;
ranks r_rate;
run;
data r1 r2 r3 r4;
set intrank;
if r_rate=0 then output r1;
if r_rate=1 then output r2;
if r_rate=2 then output r3;
if r_rate=3 then output r4;
drop _TYPE_ _FREQ_;
run;
/*dividend*/
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table7\dy.csv' 
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
data divmean;
set divmean;
if div_mean>0;
run;

proc sort data=divmean;
by descending div_mean;
run;
proc rank data=divmean out=divrank descending group=4;
var div_mean;
ranks r_div;
run;
data d1 d2 d3 d4;
set divrank;
if r_div=0 then output d1;
if r_div=1 then output d2;
if r_div=2 then output d3;
if r_div=3 then output d4;
drop _TYPE_ _FREQ_;
run;
%macro select;
%do hae=1 %to 4;
%do song=1 %to 4;

proc sql;
create table reg&hae&song as
select b.code, a.date, a.owner, a.dy, a.p_return, a.bps, a.eps, a.rate
from r&song as a, d&hae as b
where a.code = b.code;
quit;

data reg&hae&song;
set reg&hae&song;
owner1=log(owner);
bps1=log(bps);
eps1=log(eps);
bps2=bps*0.00001;
eps2=eps*0.0001;
owner2=owner*0.000001;
dyrate=dy*rate;
if owner1=. then owner1=0;

if eps1=. then eps1=0;
run;
%end;
%end;
%mend select;
%select;

proc reg data=reg14;
model owner2=dy/vif;
run;

proc panel data=reg11;
model owner1=dy rate/fixonetime;
id code date;
run;
