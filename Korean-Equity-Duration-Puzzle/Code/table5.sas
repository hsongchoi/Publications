Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table1\DIVIDEND_FINAL.csv' 
Out=div_final dbms=csv replace;
run;
proc sort data=div_final;
by date;
run;
data div_final;
set div_final;
if date=. then delete;
if div=0 then delete;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table5\mvbv.csv' 
Out=mvbv dbms=csv replace;
run;
data mvbv;
set mvbv;
if mv=0 or bv=0 then delete;
mvbv=mv/bv;
run;

%macro select;
%do song=1995 %to 2015;
%do hae=1 %to 12;
proc sort data=div_final out=div&song&hae;
by code;
where date=&song&hae;

proc rank data=div&song&hae out=div_r&song&hae descending group=4;
var div;
ranks r_div;

data div_r&song&hae;
set div_r&song&hae;
if r_div=1 or r_div=2 then delete;

proc sort data=div_r&song&hae out=div_r&song&hae;
by code;

proc sql;
create table join&song&hae as
select a.date, a.code, a.mvbv, b.r_div
from mvbv a, div_r&song&hae b
where a.code=b.code and a.date=b.date;
quit;

proc means data=join&song&hae;
var mvbv;
class r_div;
output out=r_mean&song&hae mean=r_mean; 

data sub&song&hae;
set  r_mean&song&hae;
drop _TYPE_ _FREQ_;

proc transpose data=sub&song&hae out=trans&song&hae;
id r_div;
var r_mean;

data trans&song&hae;
set trans&song&hae;
sub=_0-_3;
date=&song&hae;
%end;
%end;
%mend select;
%select;

data join95;
set trans19955 trans19956 trans19957 trans19958 trans19959 trans199510 trans199511 trans199512;
run;
data join96;
set join95 trans19961 trans19962 trans19963 trans19964 trans19965 trans19966 trans19967 trans19968 trans19969 trans199610 trans199611 trans199612;
run;
data join97;
set join96 trans19971 trans19972 trans19973 trans19974 trans19975 trans19976 trans19977 trans19978 trans19979 trans199710 trans199711 trans199712;
run;
data join98;
set join97 trans19981 trans19982 trans19983 trans19984 trans19985 trans19986 trans19987 trans19988 trans19989 trans199810 trans199811 trans199812;
run;
data join99;
set join98 trans19991 trans19992 trans19993 trans19994 trans19995 trans19996 trans19997 trans19998 trans19999 trans199910 trans199911 trans199912;
run;
data join00;
set join99 trans20001 trans20002 trans20003 trans20004 trans20005 trans20006 trans20007 trans20008 trans20009 trans200010 trans200011 trans200012;
run;
data join01;
set join00 trans20011 trans20012 trans20013 trans20014 trans20015 trans20016 trans20017 trans20018 trans20019 trans200110 trans200111 trans200112;
run;
data join02;
set join01 trans20021 trans20022 trans20023 trans20024 trans20025 trans20026 trans20027 trans20028 trans20029 trans200210 trans200211 trans200212;
run;
data join03;
set join02 trans20031 trans20032 trans20033 trans20034 trans20035 trans20036 trans20037 trans20038 trans20039 trans200310 trans200311 trans200312;
run;
data join04;
set join03 trans20041 trans20042 trans20043 trans20044 trans20045 trans20046 trans20047 trans20048 trans20049 trans200410 trans200411 trans200412;
run;
data join05;
set join04 trans20051 trans20052 trans20053 trans20054 trans20055 trans20056 trans20057 trans20058 trans20059 trans200510 trans200511 trans200512;
run;
data join05;
set join04 trans20051 trans20052 trans20053 trans20054 trans20055 trans20056 trans20057 trans20058 trans20059 trans200510 trans200511 trans200512;
run;
data join06;
set join05 trans20061 trans20062 trans20063 trans20064 trans20065 trans20066 trans20067 trans20068 trans20069 trans200610 trans200611 trans200612;
run;
data join07;
set join06 trans20071 trans20072 trans20073 trans20074 trans20075 trans20076 trans20077 trans20078 trans20079 trans200710 trans200711 trans200712;
run;
data join08;
set join07 trans20081 trans20082 trans20083 trans20084 trans20085 trans20086 trans20087 trans20088 trans20089 trans200810 trans200811 trans200812;
run;
data join09;
set join08 trans20091 trans20092 trans20093 trans20094 trans20095 trans20096 trans20097 trans20098 trans20099 trans200910 trans200911 trans200912;
run;
data join10;
set join09 trans20101 trans20102 trans20103 trans20104 trans20105 trans20106 trans20107 trans20108 trans20109 trans201010 trans201011 trans201012;
run;
data join11;
set join10 trans20111 trans20112 trans20113 trans20114 trans20115 trans20116 trans20117 trans20118 trans20119 trans201110 trans201111 trans201112;
run;
data join12;
set join11 trans20121 trans20122 trans20123 trans20124 trans20125 trans20126 trans20127 trans20128 trans20129 trans201210 trans201211 trans201212;
run;
data join13;
set join12 trans20131 trans20132 trans20133 trans20134 trans20135 trans20136 trans20137 trans20138 trans20139 trans201310 trans201311 trans201312;
run;
data join14;
set join13 trans20141 trans20142 trans20143 trans20144 trans20145 trans20146 trans20147 trans20148 trans20149 trans201410 trans201411 trans201412;
run;
data join15;
set join14 trans20151 trans20152 trans20153 trans20154 trans20155 trans20156 trans20157 trans20158 trans20159 trans201510 trans201511 trans201512;
run;
data join15;
set join15;
sub1=-sub;
run;
Proc import datafile='C:\Users\haesong\Desktop\hsongchoi\Table5\all_data.csv' 
Out=all_data dbms=csv replace;
run;
proc sort data=all_data out=all_data;
by date;
run;
proc sort data=join15 out=join15;
by date;
run;
data amerge;
merge all_data join15;
by date;
run;
proc reg data=amerge;
model sub1=kospi_var rate_var rate/vif;
run;
proc reg data=amerge;
model sub1=rate;
run;
%macro back;
/*data join1995;
%do j=5 %to j=12;
set  trans1995&j;
%end;
%mend;
%back;*/
