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

% Regress for per capita demolition consumption by low/high density
y_trans_l = y_trans.*(DENS<3528);
y_trans_h = y_trans.*(DENS>=3528);
y_hov_l = y_hov.*(DENS<3528);
y_hov_h = y_hov.*(DENS>=3528);
y_sov_l = y_sov.*(DENS<3528);
y_sov_h = y_sov.*(DENS>=3528);
y_act_l = y_act.*(DENS<3528);
y_act_h = y_act.*(DENS>=3528);
y_transit_l = y_transit.*(DENS<3528);
y_transit_h = y_transit.*(DENS>=3528);

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
X_mode = [HOV SOV ACT TRANS].*repmat((DENS>=3528),1,4);

% Run regressions for transport per capita (low density)

b_dwell_est_tc1_l = sar(y_trans_l,X_dwell_est_1,W);

b_dwell_est_tc2_l = sar(y_trans_l,X_dwell_est_2,W);

b_pop_emp_den_tc1_l = sar(y_trans_l,X_pop_emp_den,W);

b_age_tc1_l = sar(y_trans_l, X_age_1,W);

b_age_tc2_l = sar(y_trans_l, X_age_2,W);

b_room_tc_l = sar(y_trans_l, X_room, W);

b_eth_tc_l = sar(y_trans_l, X_eth, W);

b_inc_tc_l = sar(y_trans_l, X_inc, W);

b_mode_tc_l = sar(y_trans_l, X_mode, W);

% Run regressions for transport per capita (high density)

b_dwell_est_tc1_h = sar(y_trans_h,X_dwell_est_1,W);

b_dwell_est_tc2_h = sar(y_trans_h,X_dwell_est_2,W);

b_pop_emp_den_tc1_h = sar(y_trans_h,X_pop_emp_den,W);

b_age_tc1_h = sar(y_trans_h, X_age_1,W);

b_age_tc2_h = sar(y_trans_h, X_age_2,W);

b_room_tc_h = sar(y_trans_h, X_room, W);

b_eth_tc_h = sar(y_trans_h, X_eth, W);

b_inc_tc_h = sar(y_trans_h, X_inc, W);

b_mode_tc_h = sar(y_trans_h, X_mode, W);

% Run regressions for hov per capita (low density)

b_dwell_est_hc1_l = sar(y_hov_l,X_dwell_est_1,W);

b_dwell_est_hc2_l = sar(y_hov_l,X_dwell_est_2,W);

b_pop_emp_den_hc1_l = sar(y_hov_l,X_pop_emp_den,W);

b_age_hc1_l = sar(y_hov_l, X_age_1,W);

b_age_hc2_l = sar(y_hov_l, X_age_2,W);

b_room_hc_l = sar(y_hov_l, X_room, W);

b_eth_hc_l = sar(y_hov_l, X_eth, W);

b_inc_hc_l = sar(y_hov_l, X_inc, W);

b_mode_hc_l = sar(y_hov_l, X_mode, W);

% Run regressions for sov per capita (high density)

b_dwell_est_hc1_h = sar(y_sov_h,X_dwell_est_1,W);

b_dwell_est_hc2_h = sar(y_sov_h,X_dwell_est_2,W);

b_pop_emp_den_hc1_h = sar(y_sov_h,X_pop_emp_den,W);

b_age_hc1_h = sar(y_sov_h, X_age_1,W);

b_age_hc2_h = sar(y_sov_h, X_age_2,W);

b_room_hc_h = sar(y_sov_h, X_room, W);

b_eth_hc_h = sar(y_sov_h, X_eth, W);

b_inc_hc_h = sar(y_sov_h, X_inc, W);

b_mode_hc_h = sar(y_sov_h, X_mode, W);

% Run regressions for sov per capita (low density)

b_dwell_est_sc1_l = sar(y_sov_l,X_dwell_est_1,W);

b_dwell_est_sc2_l = sar(y_sov_l,X_dwell_est_2,W);

b_pop_emp_den_sc1_l = sar(y_sov_l,X_pop_emp_den,W);

b_age_sc1_l = sar(y_sov_l, X_age_1,W);

b_age_sc2_l = sar(y_sov_l, X_age_2,W);

b_room_sc_l = sar(y_sov_l, X_room, W);

b_eth_sc_l = sar(y_sov_l, X_eth, W);

b_inc_sc_l = sar(y_sov_l, X_inc, W);

b_mode_sc_l = sar(y_sov_l, X_mode, W);

% Run regressions for sov per capita (high density)

b_dwell_est_sc1_h = sar(y_sov_h,X_dwell_est_1,W);

b_dwell_est_sc2_h = sar(y_sov_h,X_dwell_est_2,W);

b_pop_emp_den_sc1_h = sar(y_sov_h,X_pop_emp_den,W);

b_age_sc1_h = sar(y_sov_h, X_age_1,W);

b_age_sc2_h = sar(y_sov_h, X_age_2,W);

b_room_sc_h = sar(y_sov_h, X_room, W);

b_eth_sc_h = sar(y_sov_h, X_eth, W);

b_inc_sc_h = sar(y_sov_h, X_inc, W);

b_mode_sc_h = sar(y_sov_h, X_mode, W);

% Run regressions for act per capita (low density)

b_dwell_est_ac1_l = sar(y_act_l,X_dwell_est_1,W);

b_dwell_est_ac2_l = sar(y_act_l,X_dwell_est_2,W);

b_pop_emp_den_ac1_l = sar(y_act_l,X_pop_emp_den,W);

b_age_ac1_l = sar(y_act_l, X_age_1,W);

b_age_ac2_l = sar(y_act_l, X_age_2,W);

b_room_ac_l = sar(y_act_l, X_room, W);

b_eth_ac_l = sar(y_act_l, X_eth, W);

b_inc_ac_l = sar(y_act_l, X_inc, W);

b_mode_ac_l = sar(y_act_l, X_mode, W);

% Run regressions for act per capita (high density)

b_dwell_est_ac1_h = sar(y_act_h,X_dwell_est_1,W);

b_dwell_est_ac2_h = sar(y_act_h,X_dwell_est_2,W);

b_pop_emp_den_ac1_h = sar(y_act_h,X_pop_emp_den,W);

b_age_ac1_h = sar(y_act_h, X_age_1,W);

b_age_ac2_h = sar(y_act_h, X_age_2,W);

b_room_ac_h = sar(y_act_h, X_room, W);

b_eth_ac_h = sar(y_act_h, X_eth, W);

b_inc_ac_h = sar(y_act_h, X_inc, W);

b_mode_ac_h = sar(y_act_h, X_mode, W);

% Run regressions for transit per capita (low density)

b_dwell_est_trc1_l = sar(y_transit_l,X_dwell_est_1,W);

b_dwell_est_trc2_l = sar(y_transit_l,X_dwell_est_2,W);

b_pop_emp_den_trc1_l = sar(y_transit_l,X_pop_emp_den,W);

b_age_trc1_l = sar(y_transit_l, X_age_1,W);

b_age_trc2_l = sar(y_transit_l, X_age_2,W);

b_room_trc_l = sar(y_transit_l, X_room, W);

b_eth_trc_l = sar(y_transit_l, X_eth, W);

b_inc_trc_l = sar(y_transit_l, X_inc, W);

b_mode_trc_l = sar(y_transit_l, X_mode, W);

% Run regressions for transit per capita (high density)

b_dwell_est_trc1_h = sar(y_transit_h,X_dwell_est_1,W);

b_dwell_est_trc2_h = sar(y_transit_h,X_dwell_est_2,W);

b_pop_emp_den_trc1_h = sar(y_transit_h,X_pop_emp_den,W);

b_age_trc1_h = sar(y_transit_h, X_age_1,W);

b_age_trc2_h = sar(y_transit_h, X_age_2,W);

b_room_trc_h = sar(y_transit_h, X_room, W);

b_eth_trc_h = sar(y_transit_h, X_eth, W);

b_inc_trc_h = sar(y_transit_h, X_inc, W);

b_mode_trc_h = sar(y_transit_h, X_mode, W);