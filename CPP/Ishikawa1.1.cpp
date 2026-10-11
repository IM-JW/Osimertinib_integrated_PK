
$PARAM
TVKA = 0.334, 
TVCL = 17.37, TVV = 1271, 
TVCLM = 44.41, TVVM = 589.0, 
TVCLMM = 46.2, TVVMM = 2288, 
TVFM = 0.25, TVFMM = 0.25


$ODE
dxdt_GUT    = -KA * GUT;
dxdt_CENT  = KA * GUT - (Kmet + Kmmet + Kel) * CENT;
dxdt_CENTM = Kmet * CENT - CLM * (CENTM / VM);
dxdt_CENTMM = Kmmet * CENT - CLMM * (CENTMM / VMM);


$CMT GUT CENT CENTM CENTMM

$MAIN
double Kmet = CL * FM / V;
double Kmmet = CL * FMM / V;
double Kel = CL * (1 - FM - FMM) / V;

double KA  = TVKA;
double CL  = TVCL * pow((ALB/ 40), 1.376) * exp(ETA(1));
double CLM = TVCLM * pow((ALB / 40), 1.935) * exp(ETA(2) + ETA(3));
double CLMM = TVCLMM * pow((WT / 55), 1.25) * exp(ETA(4) + ETA(5));

double V   = TVV;
double VM  = TVVM;
double VMM = TVVMM;

double FM = TVFM;  
double FMM = TVFMM; 

 

$OMEGA @label
ECL     : 0.094               : ηCLparent
ECLM    : 0.0 0.123           : ηCLmetabolite5
ECLMIOV : 0.0 0.0 0.034       : ηCLmetabolite5_IOV
ECLMM   : 0.0 0.0 0.0 0.0754  : ηCLmetabolite7
ECLMMIOV: 0.0 0.0 0.0 0.0 0.0223 : ηCLmetabolite7_IOV

$SIGMA @FIXED
0.0081 0 0.0081 0 0.0081 0

$TABLE
double CP  = (CENT / V) * (1 + EPS(1)) + EPS(2);     
double CM  = (CENTM / VM) * (1 + EPS(3)) + EPS(4);  
double CMM = (CENTMM / VMM) * (1 + EPS(5)) + EPS(6);

$CAPTURE CP CM CMM
