% Script to perform regression analysis of Enmax electricity data
clc;
codePath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/Code';
csvPath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/CSV';
outPath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/Outputs';
diaryName = 'regression_mode.txt';
addpath(codePath, csvPath, outPath);
csv = csvread('mode_regress_in.csv',1,0);

% Regress for total electricity consumption by community (in kWh)
y = csv(:,175);

% Specify population and employment data
POP = csv(:,2);
EMP = csv(:,129);

% Specify population/employment density data
POP_EMP = POP+EMP;
AREA = csv(:,160)./10000; % Area in hectares
DENS = POP_EMP./AREA;
DENS(isinf(DENS))=0;
DENS(isnan(DENS))=0;

% Specify dwelling and employment establishment data
DWELL = csv(:,3);
ESTAB = csv(:,141);

% Check ownership rate in community
OWN = csv(:,173);

% Specify dwellings by type (occupied) and establishments by sector
SF = csv(:,74); % Single family dwelling count
DU = csv(:,39); % Duplex dwelling count
MF = csv(:,46); % Manufactured dwelling count
APT = csv(:,25); % Apartment dwelling count
TH = csv(:,67); % Townhouse dwelling count
MH = csv(:,53); % Multi-family dwelling count
CV = csv(:,32); % Conventional dwelling count
OTH = csv(:,60); % Other dwelling count
AG = csv(:,130); % Agriculture establishment count
FOR = csv(:,131); % Forestry establishment count
IND = csv(:,132); % Industry establishment count
CON = csv(:,133); % Construction establishment count
MAN = csv(:,134); % Manufacturing establishment count
WR = csv(:,135); % Wholesale/retail establishment count
COM = csv(:,136); % Commercial establishment count
INST = csv(:,137); % Institutional establishment count
ART = csv(:,138); % Arts establishment count
MI = csv(:,139); % Miscelaneous establishment count
GOV = csv(:,140); % Government establishment count

% Specify age of community data
AGE = csv(:,153);
AGE_RES = AGE<9; % Remove non-residential entries, which do not give the community age
AGE_ADJ = AGE(AGE_RES);

% Specify number of dwellings constructed in each age category (first year
% coded)
AGE_Old = csv(:,163);
AGE_1961 = csv(:,164);
AGE_1981 = csv(:,165);
AGE_1991 = csv(:,166);
AGE_2001 = csv(:,167);
AGE_2006 = csv(:,168);

% Remove non-residential entries, which do not give the community age
AGE_Old_ADJ = AGE_Old(AGE_RES);
AGE_1961_ADJ = AGE_1961(AGE_RES);
AGE_1981_ADJ = AGE_1981(AGE_RES);
AGE_1991_ADJ = AGE_1991(AGE_RES);
AGE_2001_ADJ = AGE_2001(AGE_RES);
AGE_2006_ADJ = AGE_2006(AGE_RES);

% Taking the average occupancay by community as a factor on age should
% provide some measure of effect of age of building, normalized by number
% of people residing in the dwelling. We do not have more details on it or
% the average sqft of dwellings by community. Roughly approximates number
% of people living in dwellings of that age (assuming average occupancy
% across entire community).
PER_DWELL = POP./DWELL;
PER_DWELL(isinf(PER_DWELL))=0;
PER_DWELL(isnan(PER_DWELL))=0;
PER_DWELL_ADJ = PER_DWELL(AGE_RES);
AGE_Old_2 = AGE_Old_ADJ.*PER_DWELL_ADJ;
AGE_1961_2 = AGE_1961(AGE_RES);
AGE_1981_2 = AGE_1981(AGE_RES);
AGE_1991_2 = AGE_1991(AGE_RES);
AGE_2001_2 = AGE_2001(AGE_RES);
AGE_2006_2 = AGE_2006(AGE_RES);

% Specify number of dwellings by number of rooms in dwelling (lower range
% coded)
ROOMS_1 = csv(:,169);
ROOMS_5 = csv(:,170);
ROOMS_6 = csv(:,171);
ROOMS_7 = csv(:,172);
ROOMS_8 = csv(:,173);
% Remove non-residential entries, which do not give the number of rooms
ROOMS_1_ADJ = ROOMS_1(AGE_RES);
ROOMS_5_ADJ = ROOMS_5(AGE_RES);
ROOMS_6_ADJ = ROOMS_6(AGE_RES);
ROOMS_7_ADJ = ROOMS_7(AGE_RES);
ROOMS_8_ADJ = ROOMS_8(AGE_RES);


% Specify ethnicities of immigrants for residential communities
AFR = csv(:,154); % African immigrants from sub-saharan Africa
AFR_ADJ = AFR(AGE_RES); % Remove non-residential entries
WE = csv(:,155); % Western European immigrants
WE_ADJ = WE(AGE_RES); % Remove non-residential entries
EE = csv(:,156); % Eastern European immigrants
EE_ADJ = EE(AGE_RES); % Remove non-residential entries
WA = csv(:,157); % Western Asian immigrants
WA_ADJ = WA(AGE_RES); % Remove non-residential entries
EA = csv(:,158); % Eastern Asian immigrants
EA_ADJ = EA(AGE_RES); % Remove non-residential entries
LA = csv(:,159); % Latin American immigrants
LA_ADJ = LA(AGE_RES); % Remove non-residential entries

% Specify the average and median incomes of the community
AVE_INC = csv(:,161);
MED_INC = csv(:,162);

% Run regressions and save results to diary
cd(outPath);
delete(diaryName)
diary(diaryName)
diary on;

X_pop_emp = [POP EMP];
[b_pop_emp,dev_pop_emp,stats_pop_emp] = mnrfit(X_pop_emp,y);
b_pop_emp

X_dwell_est_1 = [DWELL ESTAB];
[b_dwell_est_1,dev_dwell_est_1,stats_dwell_est_1] = mnrfit(X_dwell_est_1,y);
b_dwell_est_1

X_dwell_est_2 = [DWELL ESTAB OWN];
[b_dwell_est_2,dev_dwell_est_2,stats_dwell_est_2] = mnrfit(X_dwell_est_2,y);
b_dwell_est_2

X_dwell_est_3 = [SF DU MF APT TH MH CV OTH AG FOR IND CON MAN WR COM INST ART MI GOV];
[b_dwell_est_3,dev_dwell_est_3,stats_dwell_est_3] = mnrfit(X_dwell_est_3,y);
b_dwell_est_3

X_pop_emp_den = [DENS];
[b_den,dev_den,stats_den] = mnrfit(X_pop_emp_den,y);
b_den

X_age_1 = [AGE_ADJ];
y_adj = y(AGE_RES);
[b_age_1,dev_age_1,stats_age_1] = mnrfit(X_age_1,y_adj);
b_age_1

X_age_2 = [AGE_Old_ADJ AGE_1961_ADJ AGE_1981_ADJ AGE_1991_ADJ AGE_2001_ADJ AGE_2006_ADJ];
y_adj = y(AGE_RES);
[b_age_2,dev_age_2,stats_age_2] = mnrfit(X_age_2,y_adj);
b_age_2

X_age_3 = [AGE_Old_2 AGE_1961_2 AGE_1981_2 AGE_1991_2 AGE_2001_2 AGE_2006_2];
y_adj = y(AGE_RES);
[b_age_3,dev_age_3,stats_age_3] = mnrfit(X_age_3,y_adj);
b_age_3

X_room = [ROOMS_1_ADJ ROOMS_5_ADJ ROOMS_6_ADJ ROOMS_7_ADJ ROOMS_8_ADJ];
y_adj = y(AGE_RES);
[b_room,dev_room,stats_room] = mnrfit(X_room,y_adj);
b_room

X_eth = [AFR_ADJ WE_ADJ EE_ADJ WA_ADJ EA_ADJ LA_ADJ ];
y_eth_adj = y(AGE_RES);
[b_eth,dev_eth,stats_eth] = mnrfit(X_eth,y_adj);
b_eth

X_inc = [AVE_INC MED_INC];
[b_inc,dev_inc,stats_inc] = mnrfit(X_inc,y);
b_inc

diary off
cd(codePath);