Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table7\all.csv' 
Out=all_data dbms=csv replace;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table7\rate.csv' 
Out=int dbms=csv replace;
run;
proc rank data=int out=int descending group=4;
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

data reg;
set all_data1;
owner1=log(owner);
if owner=0 then owner1=0;
p_owner1=log(p_owner);
if p_owner=0 then p_owner1=0;
dyrate=dy*rate;
owner1rate=owner1*rate;
dyrrate=dy*rrate;
owner1rrate=owner1*rate;
owner2=owner*0.000001;
p_owner2=p_owner*0.0000001;
owner2rate=owner2*rate;

run;

proc reg data=reg;
model return=owner1rrate dyrrate p_return p_owner1/vif;
run;
proc panel data=reg;
model return=p_return dyrate owner2rate p_owner1/fixonetime;
id code date;
run;
proc panel data=reg;
model return=owner1rrate dyrrate p_owner1 p_return dy owner1/fixonetime;
id code date;
run;
