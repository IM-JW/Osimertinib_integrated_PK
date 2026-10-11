#Rodier

$PARAM
TVKA =0.24, TVCL = 13.7, TVV = 974
 

$ODE
dxdt_GUT = -KA*GUT;
dxdt_CENT = KA*GUT-CL*CENT/V;

$CMT GUT CENT CENTM

$MAIN 
double CL = TVCL*exp(ETA(1)); 
double V = TVV*exp(ETA(2));
double KA = TVKA;


$OMEGA @label 

ECL     : 0.16 : ηCLparent
EV      : 0.0 0.41 : ηVparent

$SIGMA @FIXED 
0.0081

$TABLE 
double CP = (CENT/V)*(1+EPS(1));



$CAPTURE CP 
