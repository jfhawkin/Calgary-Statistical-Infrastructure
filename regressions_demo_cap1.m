% Script to perform regression analysis of Enmax electricity data
clc;
codePath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/Code';
csvPath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/CSV';
addpath(codePath, csvPath);
csv = csvread('demo_regress_in.csv',1,0);

% Regress for per capita demolition area by community
y_demo = csv(:,167)./POP_EMP_DC;
y_demo_ct = csv(:,167)./csv(:,166);
y_demo_ct(isnan(y_demo_ct))=0;

% Run regressions for total demolitions by area per person

b_dwell_est_da1 = sar(y_demo,X_dwell_est_1,W);

b_dwell_est_da2 = sar(y_demo,X_dwell_est_2,W);

b_pop_emp_den_da1 = sar(y_demo,X_pop_emp_den,W);

b_age_da1 = sar(y_demo, X_age_1,W);

b_age_da2 = sar(y_demo, X_age_2,W);

b_room_da = sar(y_demo, X_room, W);

b_eth_da = sar(y_demo, X_eth, W);

b_inc_da = sar(y_demo, X_inc, W);

b_sqm_da = sar(y_demo, X_sqm, W);

% Run regressions for total demolitions by area per site count

b_dwell_est_dc1 = sar(y_demo_ct,X_dwell_est_1,W);

b_dwell_est_dc2 = sar(y_demo_ct,X_dwell_est_2,W);

b_pop_emp_den_dc1 = sar(y_demo_ct,X_pop_emp_den,W);

b_age_dc1 = sar(y_demo_ct, X_age_1,W);

b_age_dc2 = sar(y_demo_ct, X_age_2,W);

b_room_dc = sar(y_demo_ct, X_room, W);

b_eth_dc = sar(y_demo_ct, X_eth, W);

b_inc_dc = sar(y_demo_ct, X_inc, W);

b_sqm_dc = sar(y_demo_ct, X_sqm, W);