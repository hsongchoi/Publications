Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table4\equity.csv' 
Out=equity dbms=csv replace;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table4\debt.csv' 
Out=debt dbms=csv replace;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table4\volatility_equity.csv' 
Out=volatility dbms=csv replace;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table4\ri.csv' 
Out=ri dbms=csv replace;
run;
proc sort data=debt;
by code;
run;
proc sort data=equity;
by code;
run;
proc sort data=equity;
by code;
run;
proc sort data=equity;
by code;
run;
proc sort data=equity;
by code;
run;
proc sort data=volatility;
by code;
run;
proc sort data=ri;
by code;
run;
data merge_vol;
merge debt equity volatility ri;
by code;
run;
data merge_vol1;
set merge_vol;
if vol=0 then delete;
naivol=(equity*vol)/(equity+debt)+(0.05*debt+0.25*vol*debt)/(equity+debt);
lnef=log(equity+debt)/debt;
dd=(lnef+(ri-0.5*naivol*naivol))/naivol;
run;
proc rank data=merge_vol1 out=rankvol descending group=4;
var dd;
ranks r_dd;
run;
data dd_1 dd_2 dd_3 dd_4;
set rankvol;
if r_dd=0 then output dd_1;
if r_dd=1 then output dd_2;
if r_dd=2 then output dd_3;
if r_dd=3 then output dd_4;
drop _TYPE_ _FREQ_;
run;
/*dividend*/
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table4\DIVIDEND_FINAL.csv' 
Out=div_final dbms=csv replace;
run;
proc sort data=div_final;
by date;
run;
data div;
set div_final;
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
data r_1 r_2 r_3 r_4;
set divrank;
if r_div=0 then output r_1;
if r_div=1 then output r_2;
if r_div=2 then output r_3;
if r_div=3 then output r_4;
drop _TYPE_ _FREQ_;
run;
%macro select;
%do hae=1 %to 4;
%do song=1 %to 4;

proc sql;
create table divdd&hae&song as
select b.code
from r_&hae as a, dd_&song as b
where a.code = b.code;
quit;
%end;
%end;
%mend select;
%select;


Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table4\all_data.csv' Out=all_data  dbms=csv replace;
run;
Proc import datafile= 'C:\Users\haesong\Desktop\hsongchoi\Table4\kospi_0526.csv' out=kospi1 dbms=csv replace;
run;
proc sort data=kospi1;
by code;
run;
%macro haesong;
%do hae=1 %to 4;
%do song=1 %to 4;

proc sql;
create table ri&hae&song as
select kospi1.code, kospi1.date, kospi1.ri
from divdd&hae&song as a, kospi1
where a.code = kospi1.code;
quit;

proc sort data=ri&hae&song;
by date;

data reg&hae&song;
merge all_data ri&hae&song;
by date;

proc sort data=reg&hae&song;
by code;

data reg&hae&song;
set reg&hae&song;
rirf=ri-rf;
rmrf=rm-rf;

%end;
%end;
%mend haesong;
%haesong;
proc reg data=reg12;
model rirf=rmrf interest_m_/ vif;
run;
proc reg data=reg44;
model rirf=interest_m_ smb hml mom/ vif;
run;
