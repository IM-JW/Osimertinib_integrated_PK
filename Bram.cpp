#Bram

$PARAM
TVKA =0.332, TVCL = 14.50, TVV = 1150
 

$ODE
dxdt_GUT = -KA*GUT;
dxdt_CENT = KA*GUT-CL*CENT/V;

$CMT GUT CENT 

$MAIN 
double CL = TVCL*exp(ETA(1)); 
double V = TVV*exp(ETA(2));
double KA = TVKA;


$OMEGA @label 

ECL     : 0.268 : ηCLparent


$SIGMA @FIXED 
0.00225

$TABLE 
double CP = (CENT/V)*(1+EPS(1));



$CAPTURE CP 
