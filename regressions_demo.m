% Script to perform regression analysis of Enmax electricity data
clc;
codePath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/Code';
csvPath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/CSV';
addpath(codePath, csvPath);
csv = csvread('demo_regress_in.csv',1,0);

% Regress for total electricity consumption by community (in kWh)
y_ct = csv(:,166);
y_fee = csv(:,167);
y_area = csv(:,168);

% Specify population and employment data
POP = csv(:,3)./100; % Per 100 persons
EMP = csv(:,131)./100; % Per 100 employees

% Specify population/employment density data
POP_EMP = POP+EMP;
AREA = csv(:,151)./10000; % Area in hectares
DENS = POP_EMP./AREA;
DENS_RES = POP./AREA;
DENS_EMP = EMP./AREA;

EMP_MOD = EMP;
EMP_MOD(EMP_MOD==0)=1;
POP_DEN_R = POP./EMP_MOD;
DENS_LOW = (DENS<=prctile(DENS,33));
DENS_MID = (DENS>prctile(DENS,33)*DENS<=prctile(DENS,66)).*2;
DENS_HIGH = (DENS>prctile(DENS,66)).*3;
DENS_CAT_1 = DENS_LOW + DENS_MID;
DENS_CAT_2 = DENS_MID + DENS_HIGH;

% Specify dwelling and employment establishment data
DWELL = csv(:,4)./25; % Per 25 dwellings
ESTAB = csv(:,143)./25; % Per 25 establishments

% Check ownership rate in community
OWN = csv(:,165)./0.05;

% Specify dwellings by type (occupied) and establishments by sector
SF = csv(:,75)./10; % Single family dwelling count /10
DU = csv(:,40)./10; % Duplex dwelling count /10
MF = csv(:,47)./10; % Manufactured dwelling count /10
APT = csv(:,26)./10; % Apartment dwelling count /10
TH = csv(:,68)./10; % Townhouse dwelling count /10
MH = csv(:,54)./10; % Multi-family dwelling count /10
CV = csv(:,33)./10; % Conventional dwelling count /10
OTH = csv(:,61)./10; % Other dwelling count /10
AG = csv(:,132)./10; % Agriculture establishment count /10
FOR = csv(:,133)./10; % Forestry establishment count /10
IND = csv(:,134)./10; % Industry establishment count /10
CON = csv(:,135)./10; % Construction establishment count /10
MAN = csv(:,136)./10; % Manufacturing establishment count /10
WR = csv(:,137)./10; % Wholesale/retail establishment count /10
COM = csv(:,138)./10; % Commercial establishment count /10
INST = csv(:,139)./10; % Institutional establishment count /10
ART = csv(:,140)./10; % Arts establishment count /10
MI = csv(:,141)./10; % Miscellaneous establishment count /10
GOV = csv(:,142)./10; % Government establishment count /10

% Specify age of community data
AGE = csv(:,144);

% Specify number of dwellings constructed in each age category (first year
% coded)
AGE_Old = csv(:,154);
AGE_1961 = csv(:,155);
AGE_1981 = csv(:,156);
AGE_1991 = csv(:,157);
AGE_2001 = csv(:,158);
AGE_2006 = csv(:,159);

% Taking the average occupancy by community as a factor on age should
% provide some measure of effect of age of building, normalized by number
% of people residing in the dwelling. We do not have more details on it or
% the average sqft of dwellings by community. Roughly approximates number
% of people living in dwellings of that age (assuming average occupancy
% across entire community).
PER_DWELL = POP./DWELL.*4;
PER_DWELL(isinf(PER_DWELL))=0;
PER_DWELL(isnan(PER_DWELL))=0;
AGE_Old_2 = AGE_Old.*PER_DWELL;
AGE_1961_2 = AGE_1961.*PER_DWELL;
AGE_1981_2 = AGE_1981.*PER_DWELL;
AGE_1991_2 = AGE_1991.*PER_DWELL;
AGE_2001_2 = AGE_2001.*PER_DWELL;
AGE_2006_2 = AGE_2006.*PER_DWELL;

% Specify number of dwellings by number of rooms in dwelling (lower range
% coded)
ROOMS_1 = csv(:,160);
ROOMS_5 = csv(:,161);
ROOMS_6 = csv(:,162);
ROOMS_7 = csv(:,163);
ROOMS_8 = csv(:,164);

% Specify ethnicities of immigrants for residential communities
AFR = csv(:,145)./0.05; % African immigrants from sub-saharan Africa
WE = csv(:,146)./0.05; % Western European immigrants
EE = csv(:,147)./0.05; % Eastern European immigrants
WA = csv(:,148)./0.05; % Western Asian immigrants
EA = csv(:,149)./0.05; % Eastern Asian immigrants
LA = csv(:,150)./0.05; % Latin American immigrants

% Specify the average and median incomes of the community
AVE_INC = csv(:,152)./5000; % Per $5,000 change
MED_INC = csv(:,153)./5000; % Per $5,000 change

%Pull in spatial data
shpname = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/GIS/mstr_Enmax_Oct31';
results = shape_read(shpname);
latt = results.xc;
long = results.yc;
[j,W,j] = xy2cont(long,latt);

% Run regressions for count demo

X_pop_emp = [POP EMP];
b_pop_emp_dc = sar(y_ct,X_pop_emp,W);

X_dwell_est_1 = [DWELL ESTAB];
b_dwell_est_1_dc = sar(y_ct,X_dwell_est_1,W);

X_dwell_est_2 = [DWELL ESTAB OWN];
b_dwell_est_2_dc = sar(y_ct,X_dwell_est_2,W);

X_dwell_est_3 = [SF DU MF APT TH MH CV OTH AG FOR IND CON MAN WR COM INST ART MI GOV];
b_dwell_est_3_dc = sar(y_ct,X_dwell_est_3,W);

X_pop_emp_den_1 = [DENS POP_DEN_R];
b_pop_emp_den_1_dc = sar(y_ct,X_pop_emp_den_1,W);

X_pop_emp_den_2 = [POP_DEN_R DENS_CAT_1 DENS_CAT_2];
b_pop_emp_den_2_dc = sar(y_ct,X_pop_emp_den_2,W);

X_age_1 = [AGE];
b_age_1_dc = sar(y_ct, X_age_1,W);

X_age_2 = [AGE_Old AGE_1961 AGE_1981 AGE_1991 AGE_2001 AGE_2006];
b_age_2_dc = sar(y_ct, X_age_2,W);

X_age_3 = [AGE_Old_2 AGE_1961_2 AGE_1981_2 AGE_1991_2 AGE_2001_2 AGE_2006_2];
b_age_3_dc = sar(y_ct, X_age_3, W);

X_room = [ROOMS_1 ROOMS_5 ROOMS_6 ROOMS_7 ROOMS_8];
b_room_dc = sar(y_ct, X_room, W);

X_eth = [AFR WE EE WA EA LA];
b_eth_dc = sar(y_ct, X_eth, W);

X_inc = [MED_INC];
b_inc_dc = sar(y_ct, X_inc, W);


% Run regressions for fee demo

b_pop_emp_df = sar(y_fee,X_pop_emp,W);

b_dwell_est_1_df = sar(y_fee,X_dwell_est_1,W);

b_dwell_est_2_df = sar(y_fee,X_dwell_est_2,W);

b_dwell_est_3_df = sar(y_fee,X_dwell_est_3,W);

b_pop_emp_den_1_df = sar(y_fee,X_pop_emp_den_1,W);

b_pop_emp_den_2_df = sar(y_fee,X_pop_emp_den_2,W);

b_age_1_df = sar(y_fee, X_age_1,W);

b_age_2_df = sar(y_fee, X_age_2,W);

b_age_3_df = sar(y_fee, X_age_3, W);

b_room_df = sar(y_fee, X_room, W);

b_eth_df = sar(y_fee, X_eth, W);

b_inc_df = sar(y_fee, X_inc, W);


% Run regressions for area demo

b_pop_emp_da = sar(y_area,X_pop_emp,W);

b_dwell_est_1_da = sar(y_area,X_dwell_est_1,W);

b_dwell_est_2_da = sar(y_area,X_dwell_est_2,W);

b_dwell_est_3_tc = sar(y_area,X_dwell_est_3,W);

b_pop_emp_den_1_da = sar(y_area,X_pop_emp_den_1,W);

b_pop_emp_den_2_da = sar(y_area,X_pop_emp_den_2,W);

b_age_1_da = sar(y_area, X_age_1,W);

b_age_2_da = sar(y_area, X_age_2,W);

b_age_3_da = sar(y_area, X_age_3, W);

b_room_da = sar(y_area, X_room, W);

b_eth_da = sar(y_area, X_eth, W);

b_inc_da = sar(y_area, X_inc, W);