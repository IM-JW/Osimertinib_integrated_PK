#Brown

$PARAM
TVKA =0.24, TVCL = 14.2, TVV = 986, TVFM = 0.25, 
TVCLM = 31.5, TVVM = 207 

 

$PARAM @covariates
EWH = 0.56, EWHM = 0.99, EWHV = 0.65, EABV = 1.33 

$ODE
dxdt_GUT = -KA*GUT;
dxdt_CENT = KA*GUT - CL*(CENT/V);
dxdt_CENTM = CL*FM*(CENT/V)-CLM*(CENTM/VM);

$CMT GUT CENT CENTM

$MAIN 

double KA =TVKA*exp(ETA(1));
double CL =(TVCL*pow((BW/62), EWH))*exp(ETA(2)); 
double CLM =(TVCLM*pow((BW/62), EWHM))*exp(ETA(3))*exp(ETA(6));
double V = (TVV*pow((ALB/39), EABV)*pow((BW/62), EWHV))*exp(ETA(4));
double VM = TVVM*exp(ETA(5));
double FM = TVFM;


$OMEGA @label 
EKA     : 0.89 : ηka
ECL     : 0.0 0.46 : ηCLparent
ECLM    : 0.0 0.0 0.52 : ηCLmetabolite  
EV      : 0.0 0.0 0.0 0.52 : ηVparent
EVM     : 0.0 0.0 0.0 0.0 0.62 : ηVmetabolite
ECLPM   : 0.0 0.0 0.0 0.0 0.0 0.90 :ηCorrelation coefficient CL P-M

$SIGMA @FIXED 
0.01 0

$TABLE 
double CP = (CENT/V)*(1+EPS(1)) + EPS(2);
double CM = (CENTM/VM)*(1+EPS(1)) + EPS(2);


$CAPTURE CP CM 