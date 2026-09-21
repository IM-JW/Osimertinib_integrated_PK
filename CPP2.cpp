#ishikawa


$PARAM
TVKA =0.334, 
TVCL = 17.37, TVV = 1271, 
TVCLM = 44.41, TVVM = 589.0
TVCLMM = 46.2, TVVMM = 2288, TVFM = 0.25 

$PARAM @covariates
ECLA = 1.376, ECLMA = 1.935,  ECLMMB = 1.25



$ODE 

dxdt_GUT = -KA*GUT; 

dxdt_CENT = KA*GUT-CL*(CENT/V); 

dxdt_CENTM =(CL*FM*(CENT/V))-CLM*(CENTM/VM); 

dxdt_CENTMM =(CL*FM*(CENT/V))-CLMM*(CENTMM/VMM); 

 

$CMT GUT CENT CENTM CENTMM 


$MAIN 
double KA = TVKA;
double CL = TVCL*pow((ALB/4.0), ECLA)*exp(ETA(1)); 
double CLM = (TVCLM* pow((ALB/4.0), ECLMA))*exp(ETA(2)+ETA(3));
double CLMM = (TVCLM* pow((BW/55), ECLMMB))*exp(ETA(4)+ETA(5));
double V = TVV;
double VM = TVVM;
double VMM = TVVMM;
double FM = TVFM;


$OMEGA @label 

ECL     : 0.094 : ηCLparent
ECLM    : 0.0 0.123 : ηCLmetabolite5
ECLMIOV : 0.0 0.0 0.034 : ηCLmetabolite5_IOV    
ECLMM   : 0.0 0.0 0.0 0.0754: ηCLmetabolite7 
ECLMMIOV: 0.0 0.0 0.0 0.0 0.0223: ηCLmetabolite7_IOV   

$SIGMA @FIXED 

0.01 0 0.01 0 0.01 0 

$TABLE 
double CP = (CENT/V)*(1+EPS(1)) + EPS(2);
double CM = (CENTM/VM)*(1+EPS(3)) + EPS(4);
double CMM = (CENTM/VMM)*(1+EPS(5)) + EPS(6);


$CAPTURE CP CM CMM