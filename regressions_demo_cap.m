% Script to perform regression analysis of Enmax electricity data
clc;
codePath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/Code';
csvPath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/CSV';
addpath(codePath, csvPath);
csv = csvread('demo_regress_in.csv',1,0);

% Regress for per capita demolition area by community
y_demo = csv(:,168)./POP_EMP_DC;

% Regress for per capita demolition consumption by low/high density
y_demo_l = y_demo.*(DENS<3528);
y_demo_h = y_demo.*(DENS>=3528);

% Run regressions for total demolitions by area (low density)

b_dwell_est_dc1_l = sar(y_demo_l,X_dwell_est_1,W);

b_dwell_est_dc2_l = sar(y_demo_l,X_dwell_est_2,W);

b_pop_emp_den_dc1_l = sar(y_demo_l,X_pop_emp_den,W);

b_age_dc1_l = sar(y_demo_l, X_age_1,W);

b_age_dc2_l = sar(y_demo_l, X_age_2,W);

b_room_dc_l = sar(y_demo_l, X_room, W);

b_eth_dc_l = sar(y_demo_l, X_eth, W);

b_inc_dc_l = sar(y_demo_l, X_inc, W);

% Run regressions for total electricity (high density)

b_dwell_est_dc1_h = sar(y_demo_h,X_dwell_est_1,W);

b_dwell_est_dc2_h = sar(y_demo_h,X_dwell_est_2,W);

b_pop_emp_den_dc1_h = sar(y_demo_h,X_pop_emp_den,W);

b_age_dc1_h = sar(y_demo_h, X_age_1,W);

b_age_dc2_h = sar(y_demo_h, X_age_2,W);

b_room_dc_h = sar(y_demo_h, X_room, W);

b_eth_dc_h = sar(y_demo_h, X_eth, W);

b_inc_dc_h = sar(y_demo_h, X_inc, W);