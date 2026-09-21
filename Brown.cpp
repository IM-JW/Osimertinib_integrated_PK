#Brown

$PARAM
TVKA =0.24, TVCL = 14.2, TVV = 986, TVFM = 0.25, 
TVCLM = 31.5, TVVM = 207 

 

$ODE
dxdt_GUT = -KA*GUT;
dxdt_CENT = KA*GUT - CL*(CENT/V);
dxdt_CENTM = CL*FM*(CENT/V)-CLM*(CENTM/VM);

$CMT GUT CENT CENTM

$MAIN 

double KA =TVKA*exp(ETA(1));
double CL =(TVCL*pow((WT/62),0.56))*exp(ETA(2));
double CLM =((TVCLM*pow((WT/62),0.99))*exp(ETA(3)))*exp(ETA(6));
double V = (TVV*pow((ALB/39),0.65)*pow((WT/62),1.33))*exp(ETA(4));
double VM = TVVM*exp(ETA(5));
double FM = TVFM;


$OMEGA @label 
EKA     : 0.89 : 1.ηka
ECL     : 0.0 0.46 : 2.ηCLparent
ECLM    : 0.0 0.0 0.52 : 3.ηCLmetabolite  # (0.9 * sqrt(0.46 * 0.52)) = 0.414
EV      : 0.0 0.0 0.0 0.52 : 4.ηVparent
EVM     : 0.0 0.0 0.0 0.0 0.62 : 5.ηVmetabolite

@correlation
1.0  0.0  0.0  0.0  0.0
0.0  1.0  0.9  0.0  0.0
0.0  0.9  1.0  0.0  0.0
0.0  0.0  0.0  1.0  0.0
0.0  0.0  0.0  0.0  1.0




$SIGMA @FIXED 
0.0225 0 0.0225 0

$TABLE 
double CP = (CENT/V)*(1+EPS(1)) + EPS(2);
double CM = (CENTM/VM)*(1+EPS(3)) + EPS(4);


$CAPTURE CP CM 
