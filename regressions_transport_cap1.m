% Script to perform regression analysis of Enmax electricity data
clc;
codePath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/Code';
csvPath = 'C:/Users/jason/Documents/Calgary Statistical Infrastructure/CSV';
addpath(codePath, csvPath);
csv = csvread('transport_regress_in.csv',1,0);

% Regress for per capita transportation consumption by community
y_trans = csv(:,170)./POP_EMP_TC;
y_hov = csv(:,166)./POP_EMP_TC;
y_sov = csv(:,167)./POP_EMP_TC;
y_act = csv(:,168)./POP_EMP_TC;
y_transit = csv(:,169)./POP_EMP_TC;

% Specify the mode distributions for the community
HOV = csv(:,166)./csv(:,170);
HOV(HOV==inf)=0;
HOV(isnan(HOV))=0;
SOV = csv(:,167)./csv(:,170);
SOV(isnan(SOV))=0;
ACT = csv(:,168)./csv(:,170);
ACT(isnan(ACT))=0;
TRANS = csv(:,169)./csv(:,170);
TRANS(isnan(TRANS))=0;
X_mode = [HOV SOV ACT TRANS];

% Run regressions for transport per capita
b_dwell_est_tc1 = sar(y_trans,X_dwell_est_1,W);

b_dwell_est_tc2 = sar(y_trans,X_dwell_est_2,W);

b_pop_emp_den_tc1 = sar(y_trans,X_pop_emp_den,W);

b_age_tc1 = sar(y_trans, X_age_1,W);

b_age_tc2 = sar(y_trans, X_age_2,W);

b_room_tc = sar(y_trans, X_room, W);

b_eth_tc = sar(y_trans, X_eth, W);

b_inc_tc = sar(y_trans, X_inc, W);

b_sqft_tc = sar(y_trans, X_sqm, W);

b_mode_tc = sar(y_trans, X_mode, W);

% Run regressions for hov per capita

b_dwell_est_hc1 = sar(y_hov,X_dwell_est_1,W);

b_dwell_est_hc2 = sar(y_hov,X_dwell_est_2,W);

b_pop_emp_den_hc1 = sar(y_hov,X_pop_emp_den,W);

b_age_hc1 = sar(y_hov, X_age_1,W);

b_age_hc2 = sar(y_hov, X_age_2,W);

b_room_hc = sar(y_hov, X_room, W);

b_eth_hc = sar(y_hov, X_eth, W);

b_inc_hc = sar(y_hov, X_inc, W);

b_sqft_hc = sar(y_hov, X_sqm, W);

b_mode_hc = sar(y_hov, X_mode, W);

% Run regressions for sov per capita

b_dwell_est_sc1 = sar(y_sov,X_dwell_est_1,W);

b_dwell_est_sc2 = sar(y_sov,X_dwell_est_2,W);

b_pop_emp_den_sc1 = sar(y_sov,X_pop_emp_den,W);

b_age_sc1 = sar(y_sov, X_age_1,W);

b_age_sc2 = sar(y_sov, X_age_2,W);

b_room_sc = sar(y_sov, X_room, W);

b_eth_sc = sar(y_sov, X_eth, W);

b_inc_sc = sar(y_sov, X_inc, W);

b_sqft_sc = sar(y_sov, X_sqm, W);

b_mode_sc = sar(y_sov, X_mode, W);

% Run regressions for act per capita

b_dwell_est_ac1 = sar(y_act,X_dwell_est_1,W);

b_dwell_est_ac2 = sar(y_act,X_dwell_est_2,W);

b_pop_emp_den_ac1 = sar(y_act,X_pop_emp_den,W);

b_age_ac1 = sar(y_act, X_age_1,W);

b_age_ac2 = sar(y_act, X_age_2,W);

b_room_ac = sar(y_act, X_room, W);

b_eth_ac = sar(y_act, X_eth, W);

b_inc_ac = sar(y_act, X_inc, W);

b_sqm_ac = sar(y_act, X_sqm, W);

b_mode_ac = sar(y_act, X_mode, W);

% Run regressions for transit per capita

b_dwell_est_trc1 = sar(y_transit,X_dwell_est_1,W);

b_dwell_est_trc2 = sar(y_transit,X_dwell_est_2,W);

b_pop_emp_den_trc1 = sar(y_transit,X_pop_emp_den,W);

b_age_trc1 = sar(y_transit, X_age_1,W);

b_age_trc2 = sar(y_transit, X_age_2,W);

b_room_trc = sar(y_transit, X_room, W);

b_eth_trc = sar(y_transit, X_eth, W);

b_inc_trc = sar(y_transit, X_inc, W);

b_sqm_trc = sar(y_transit, X_sqm, W);

b_mode_trc = sar(y_transit, X_mode, W);