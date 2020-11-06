Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table6\all_data.csv' 
Out=all_data dbms=csv replace;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table6\interest.csv' 
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
div_rate=div*rate;
if bv=0 then delete;
if mv=0 then delete;
bvmv=bv/mv;
run;
proc sort data=all_data1 out=all_data1;
by code date;
run;
data all08101512;
set all_data1;
	format date yymmdd10. ;
if 20081031<= date <=20151231;
run;

/*fund*/
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table1\DIVIDEND_FINAL.csv' 
Out=div_final dbms=csv replace;
run;
proc sort data=div_final;
by date;
run;
data div;
set div_final;
	format date yymmdd10. ;
if 20081031<= date <=20151231;
run;
proc sort data=div;
by code;
run;
proc means data=div mean;
var div;
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
/*fund_owner*/
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table6\fund_owner.csv' 
Out=fund_owner dbms=csv replace;
run;
proc sort data=fund_owner out=fund_owner;
by date;
run;
data fund_owner;
set fund_owner;
	format date yymmdd10. ;
if 20081031<=date<=20151231;
run;
proc sort data=fund_owner out=fund_owner;
by code date;
run;
proc sort data=r_1 out=r_1;
by code;
run;
proc sql;
create table ri_1 as
select r_1.code, fund_owner.date, fund_owner.owner
from r_1, fund_owner
where r_1.code = fund_owner.code;
quit;
proc sort data=all08101512;
by code date;
run;

proc sql;
create table reg0815 as
select ri_1.code, ri_1.date, ri_1.owner, all08101512.div, all08101512.size, all08101512.mom, all08101512.rate, all08101512.div_rate, all08101512.bvmv
from ri_1, all08101512
where ri_1.code = all08101512.code and ri_1.date = all08101512.date;
quit;
data reg0815final;
set reg0815;
owner1=lag1(owner);
if code ne lag1(code) then owner1=.;
size1=lag1(size);
if code ne lag1(code) then size1=.;
if size1=. then delete;
if size=0 then delete;
sizer=size1/size;
if owner=0 then delete;
ownerr=owner1/owner;
run;

proc reg data=reg0815final;
model ownerr=div rate sizer mom bvmv/ vif;
run;



proc reg data=fund_reg;
model ownerr=div rate sizer bvmv mom/vif;
run;
