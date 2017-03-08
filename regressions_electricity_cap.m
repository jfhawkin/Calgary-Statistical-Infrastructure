% Script to perform regression analysis of Enmax electricity data
clc;
codePath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/Code';
csvPath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/CSV';
addpath(codePath, csvPath);
csv = csvread('enmax_regress_in.csv',1,0);

% Specify population and employment data
POP = csv(:,3); % persons
EMP = csv(:,131); % employees

% Specify population/employment density data
POP_EMP = POP+EMP;
POP_EMP_EC = POP+EMP.*EMP_FACTOR_ELEC;
POP_EMP_TC = POP+EMP.*EMP_FACTOR_TRANS;
POP_EMP_DC = POP+EMP.*EMP_FACTOR_DEMO;
AREA = csv(:,151)./10^6; % Area in km^2
DENS = POP_EMP./AREA;
DENS_RES = POP./AREA;
DENS_EMP = EMP./AREA; % Not factored to match population (no factor would exist for this regression)

% Regress for per capita electricity consumption by community (in kWh)
y_elec = csv(:,119)./POP_EMP_EC;
y_res = (csv(:,166)+csv(:,168))./POP; % Single and multi-unit residential totals
y_res(isinf(y_res))=0;
y_res(isnan(y_res))=0;
y_com = csv(:,167)./EMP;
y_com(isinf(y_com))=0;
y_com(isnan(y_com))=0;
y_ind = csv(:,169)./EMP;
y_ind(isinf(y_ind))=0;
y_ind(isnan(y_ind))=0;

% Regress for per capita electricity consumption by low/high density
y_elec_l = y_elec.*(DENS<3528);
y_res_l = y_res.*(DENS<3528);
y_com_l = y_com.*(DENS<3528);
y_ind_l = y_ind.*(DENS<3528);
y_elec_h = y_elec.*(DENS>=3528);
y_res_h = y_res.*(DENS>=3528);
y_com_h = y_com.*(DENS>=3528);
y_ind_h = y_ind.*(DENS>=3528);

% Specify dwelling and employment establishment data
DWELL = csv(:,4);
ESTAB = csv(:,143);

% Check ownership rate in community
OWN = csv(:,165)./0.05;

% Specify dwellings by type (occupied) and establishments by sector
SF = csv(:,75); % Single family dwelling count
DU = csv(:,40); % Duplex dwelling count
MF = csv(:,47); % Manufactured dwelling count
APT = csv(:,26); % Apartment dwelling count
TH = csv(:,68); % Townhouse dwelling count
MH = csv(:,54); % Multi-family dwelling count
CV = csv(:,33); % Conventional dwelling count
OTH = csv(:,61); % Other dwelling count
AG = csv(:,132); % Agriculture establishment count
FOR = csv(:,133); % Forestry establishment count
IND = csv(:,134); % Industry establishment count
CON = csv(:,135); % Construction establishment count
MAN = csv(:,136); % Manufacturing establishment count
WR = csv(:,137); % Wholesale/retail establishment count
COM = csv(:,138); % Commercial establishment count
INST = csv(:,139); % Institutional establishment count
ART = csv(:,140); % Arts establishment count
MI = csv(:,141); % Miscellaneous establishment count
GOV = csv(:,142); % Government establishment count

% Specify age of community data
AGE = csv(:,144);

% Specify number of dwellings constructed in each age category (first year
% coded)
% Taking the average occupancy by community as a factor on age should
% provide some measure of effect of age of building, normalized by number
% of people residing in the dwelling.
AGE_Old = csv(:,154);
AGE_1961 = csv(:,155);
AGE_1981 = csv(:,156);
AGE_1991 = csv(:,157);
AGE_2001 = csv(:,158);
AGE_2006 = csv(:,159);
OCC = POP./DWELL;
OCC(isinf(OCC))=0;
OCC(isnan(OCC))=0;

% Specify number of dwellings by number of rooms in dwelling (lower range
% coded)
% Taking the average occupancy by community as a factor on rooms should
% provide some measure of effect of rooms in building, normalized by number
% of people residing in the dwelling.
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
MED_INC = csv(:,153)./5000; % Per $5,000 change


%Pull in spatial data
shpname = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/GIS/mstr_Enmax_Oct31';
results = shape_read(shpname);
latt = results.xc;
long = results.yc;
[j,W,j] = xy2cont(long,latt);

% Run regressions for total electricity (low density)

X_dwell_est_1 = [DWELL ESTAB OWN].*repmat((DENS<3528),1,3);
b_dwell_est_ec1_l = sar(y_elec_l,X_dwell_est_1,W);

X_dwell_est_2 = [SF DU MF APT TH MH CV OTH AG FOR IND CON MAN WR COM INST ART MI GOV].*repmat((DENS<3528),1,19);
b_dwell_est_ec2_l = sar(y_elec_l,X_dwell_est_2,W);

X_pop_emp_den = [DENS].*repmat((DENS<3528),1,1);
b_pop_emp_den_ec1_l = sar(y_elec_l,X_pop_emp_den,W);

X_age_1 = [AGE].*repmat((DENS<3528),1,1);
b_age_ec1_l = sar(y_elec_l, X_age_1,W);

X_age_2 = [AGE_Old AGE_1961 AGE_1981 AGE_1991 AGE_2001 AGE_2006 OCC].*repmat((DENS<3528),1,7);
b_age_ec2_l = sar(y_elec_l, X_age_2,W);

X_room = [ROOMS_1 ROOMS_5 ROOMS_6 ROOMS_7 ROOMS_8 OCC].*repmat((DENS<3528),1,6);
b_room_ec_l = sar(y_elec_l, X_room, W);

X_eth = [AFR WE EE WA EA LA].*repmat((DENS<3528),1,6);
b_eth_ec_l = sar(y_elec_l, X_eth, W);

X_inc = [MED_INC].*repmat((DENS<3528),1,1);
b_inc_ec_l = sar(y_elec_l, X_inc, W);

% Run regressions for residential electricity

X_dwell_1 = [DWELL OWN].*repmat((DENS<3528),1,2);
b_dwell_ec1_r_l = sar(y_res_l, X_dwell_1, W);

X_dwell_2 = [SF DU MF APT TH MH CV OTH].*repmat((DENS<3528),1,8);
b_dwell_ec2_r_l = sar(y_res_l, X_dwell_2, W);

X_pop_den = [DENS_RES].*repmat((DENS<3528),1,1);
b_pop_den_ec_r_l = sar(y_res_l, X_pop_den, W);

b_age_1_ec_r_l = sar(y_res_l, X_age_1, W);

b_age_2_ec_r_l = sar(y_res_l, X_age_2, W);

b_room_ec_r_l = sar(y_res_l, X_room, W);

b_eth_ec_r_l = sar(y_res_l, X_eth, W);

b_inc_ec_r_l = sar(y_res_l, X_inc, W);

% Run regressions for commercial electricity

X_est_1 = [ESTAB].*repmat((DENS<3528),1,1);
b_est_ec1_c_l = sar(y_com_l, X_est_1, W);

X_est_2 = [AG FOR IND CON MAN WR COM INST ART MI GOV].*repmat((DENS<3528),1,11);
b_est_ec2_c_l = sar(y_com_l, X_est_2, W);

X_emp_den = [DENS_EMP].*repmat((DENS<3528),1,1);
b_emp_den_ec_c_l = sar(y_com_l, X_emp_den, W);


% Run regressions for industrial electricity

b_est_ec1_i_l = sar(y_ind_l, X_est_1, W);

b_est_ec2_i_l = sar(y_ind_l, X_est_2, W);

b_emp_den_ec_i_l = sar(y_ind_l, X_emp_den, W);

% Run regressions for total electricity (high density)

X_dwell_est_h = [DWELL ESTAB OWN].*repmat((DENS>=3528),1,3);
b_dwell_est_ec1_h = sar(y_elec_h,X_dwell_est_1,W);

X_dwell_est_2 = [SF DU MF APT TH MH CV OTH AG FOR IND CON MAN WR COM INST ART MI GOV].*repmat((DENS>=3528),1,19);
b_dwell_est_ec2_h = sar(y_elec_h,X_dwell_est_2,W);

X_pop_emp_den = [DENS].*repmat((DENS>=3528),1,1);
b_pop_emp_den_ec1_h = sar(y_elec_h,X_pop_emp_den,W);

X_age_1 = [AGE].*repmat((DENS>=3528),1,1);
b_age_ec1_h = sar(y_elec_h, X_age_1,W);

X_age_2 = [AGE_Old AGE_1961 AGE_1981 AGE_1991 AGE_2001 AGE_2006 OCC].*repmat((DENS>=3528),1,7);
b_age_ec2_h = sar(y_elec_h, X_age_2,W);

X_room = [ROOMS_1 ROOMS_5 ROOMS_6 ROOMS_7 ROOMS_8 OCC].*repmat((DENS>=3528),1,6);
b_room_ec_h = sar(y_elec_h, X_room, W);

X_eth = [AFR WE EE WA EA LA].*repmat((DENS>=3528),1,6);
b_eth_ec_h = sar(y_elec_h, X_eth, W);

X_inc = [MED_INC].*repmat((DENS>=3528),1,1);
b_inc_ec_h = sar(y_elec_h, X_inc, W);

% Run regressions for residential electricity

X_dwell_1 = [DWELL OWN].*repmat((DENS>=3528),1,2);
b_dwell_ec1_r_h = sar(y_res_h, X_dwell_1, W);

X_dwell_2 = [SF DU MF APT TH MH CV OTH].*repmat((DENS>=3528),1,8);
b_dwell_ec2_r_h = sar(y_res_h, X_dwell_2, W);

X_pop_den = [DENS_RES].*repmat((DENS>=3528),1,1);
b_pop_den_ec_r_h = sar(y_res_h, X_pop_den, W);

b_age_1_ec_r_h = sar(y_res_h, X_age_1, W);

b_age_2_ec_r_h = sar(y_res_h, X_age_2, W);

b_room_ec_r_h = sar(y_res_h, X_room, W);

b_eth_ec_r_h = sar(y_res_h, X_eth, W);

b_inc_ec_r_h = sar(y_res_h, X_inc, W);

% Run regressions for commercial electricity

X_est_1 = [ESTAB].*repmat((DENS>=3528),1,1);
b_est_ec1_c_h = sar(y_com_h, X_est_1, W);

X_est_2 = [AG FOR IND CON MAN WR COM INST ART MI GOV].*repmat((DENS>=3528),1,11);
b_est_ec2_c_h = sar(y_com_h, X_est_2, W);

X_emp_den = [DENS_EMP].*repmat((DENS>=3528),1,1);
b_emp_den_ec_c_h = sar(y_com_h, X_emp_den, W);


% Run regressions for industrial electricity

b_est_ec1_i_h = sar(y_ind_h, X_est_1, W);

b_est_ec2_i_h = sar(y_ind_h, X_est_2, W);

b_emp_den_ec_i_h = sar(y_ind_h, X_emp_den, W);

