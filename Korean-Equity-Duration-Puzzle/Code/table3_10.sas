Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table3\kospi_0526.csv' 
Out=kospi1 dbms=csv replace;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table3\all_data.csv' 
Out=all dbms=csv replace;
run;
proc sort data=kospi1;
by date;
run;
data kospi;
set kospi1;
if 20010131<=date<= 20151231 then output kospi;
run;
proc sort data=all;
by date;
run;
data riall;
merge kospi all;
by date;
run;

proc sort data=riall;
by code;
run;
data riall;
set riall;
rirf=ri-rf;
rmrf=rm-rf;
run;
proc reg data=riall;
model rirf = rmrf;
by code;
output out=reg residual=res;
run;
proc means data=reg;
var res;
class code;
output out=res_mean std=stds; 
run;
data res_mean;
set res_mean;
if _type_=0 then delete;
run;
proc rank data=res_mean out=res_rank descending group=4;
var stds;
ranks res_rank;
run;
data r_1 r_2 r_3 r_4;
set res_rank;
if res_rank=0 then output r_1;
if res_rank=1 then output r_2;
if res_rank=2 then output r_3;
if res_rank=3 then output r_4;
run;
/*dividend*/
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table3\DIVIDEND_FINAL.csv' 
Out=div1 dbms=csv replace;
run;
data div;
set div1;
if 20010131<=date<= 20151231 then output div;
run;
proc sort data=div;
by code;
run;
proc means data=div mean;
var div;
class code;
output out=divmean mean=div_mean; /*�� mean   */
run; 
proc sort data=divmean;
by descending div_mean;
run;
data divmean;
set divmean;
if div_mean>0;
run;
/*rank �� */
proc rank data=divmean out=divrank descending group=4;
var div_mean;
ranks r_div;
run;
data d_1 d_2 d_3 d_4;
set divrank;
if r_div=0 then output d_1;
if r_div=1 then output d_2;
if r_div=2 then output d_3;
if r_div=3 then output d_4;
drop _TYPE_ _FREQ_;
run;
%macro select;
%do hae=1 %to 4;
%do song=1 %to 4;

proc sql;
create table divr&hae&song as
select b.code
from r_&song as a, d_&hae as b
where a.code = b.code;
quit;

proc sql;
create table reg&hae&song as
select a.code, riall.date, riall.rirf, riall.rmrf, riall.interest_m_, riall.smb, riall.hml, riall.mom
from riall, divr&hae&song as a
where riall.code = a.code;
quit;

data reg&hae&song;
set reg&hae&song;
interest=interest_m_*100;

%end;
%end;
%mend select;
%select;

proc reg data=reg11;
model rirf=rmrf interest smb hml mom/ vif;
run;

proc reg data=reg41;
model rirf=rmrf interest smb hml mom/ vif;
run;
proc reg data=reg12;
model rirf=rmrf interest / vif;
run;

proc reg data=reg42;
model rirf=rmrf interest / vif;
run;

proc reg data=reg13;
model rirf=rmrf interest smb hml mom / vif;
run;

proc reg data=reg43;
model rirf=rmrf interest smb hml mom/ vif;
run;
proc reg data=reg14;
model rirf=rmrf interest smb hml mom / vif;
run;

proc reg data=reg44;
model rirf=rmrf interest smb hml mom/ vif;
run;
