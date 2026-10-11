#Brown

$PARAM
TVKA =0.24, TVCL = 14.2, TVV = 986, TVFM = 0.25, 
TVCLM = 31.5, TVVM = 207 



 
$ODE
dxdt_GUT   = -KA * GUT;
dxdt_CENT  = KA * GUT - (Kmet + Kel) * CENT;
dxdt_CENTM = Kmet * CENT - CLM * (CENTM / VM);

$CMT GUT CENT CENTM

$MAIN 
double Kmet = CL * FM / V;
double Kel = CL * (1 - FM) / V;
double KA =TVKA*exp(ETA(1));
double CL =(TVCL*pow((WT/62),0.56))*exp(ETA(2));
double CLM =((TVCLM*pow((WT/62),0.99))*exp(ETA(3)))*exp(ETA(6));
double V = (TVV*pow((ALB/39),1.33)*pow((WT/62),0.65))*exp(ETA(4));
double VM = TVVM*exp(ETA(5));
double FM = TVFM;


$OMEGA @label 
EKA     : 0.79 : 1.ηka
ECL     : 0.0 0.2 : 2.ηCLparent
ECLM    : 0.0 0.171 0.27 : 3.ηCLmetabolite  # (0.9 * sqrt(0.46 * 0.52)) = 0.414
EV      : 0.0 0.0 0.0 0.27 : 4.ηVparent
EVM     : 0.0 0.0 0.0 0.0 0.38 : 5.ηVmetabolite






$SIGMA @FIXED 
0.0081 0 0.0081 0

$TABLE 
double CP = (CENT/V)*(1+EPS(1)) + EPS(2);
double CM = (CENTM/VM)*(1+EPS(3)) + EPS(4);


$CAPTURE CP CM 
