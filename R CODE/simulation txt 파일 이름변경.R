# 기본 코드를 문자열로 저장
base_code <- "
$PROBLEM PK model revised for one-compartment model
;; 1. Based on run37
;; 2. Description SIMULATION_pure 80mg
;; x1. Author JIWOO

$ABBR DERIV2=NO ; 
;----------------------------------
$INPUT ID TIME AMT ADDL II DV MDV CMT WT ALB SEX 
;----------------------------------
$DATA FILENAME.csv IGNORE=@
;----------------------------------
$SUBROUTINES ADVAN2 TRANS2
;----------------------------------

$PK
  TVKA = THETA(1)
  TVCL = THETA(2)*((WT/66.15)**THETA(7))
  TVV = THETA(3)*((WT/66.15)**THETA(6))*((ALB/39.59)**THETA(8))*EXP(THETA(9)*SEX)

  KA = TVKA ;
  CL = TVCL*EXP(ETA(1)) ; Typical value of clearance with IIV
  V = TVV*EXP(ETA(2)) ; Typical value of volume with IIV
 
  S2 = V ; AMT (g) DV(단위 변환 nM에서 ngmL로)

$ERROR
  IPRED = F
  IRES = DV-IPRED
  W = IPRED*THETA(5)+THETA(4)
  IF (W.EQ.0) W = 1
  IWRES = IRES/W
  Y= IPRED+W*ERR(1)
  CWRES = IRES/SQRT(IPRED**2)

ITER=IREP

$THETA
(0.269) FIX ;1 KA
(14.1) FIX ;2 CL
(1080) FIX;3 V
(9.89E-06) FIX ;4 ADD
(0.0557) FIX ;5 PRO
(0.555) FIX;6 V_WT
(0.0489) FIX ;7 CL_WT
(1.15) FIX ;8 V_ALB
(-0.0312) FIX;9 V_SEX

$OMEGA  ; Assuming some degree of IIV for CL and V
 0 FIX  ; IIV-Ka 
 0.00327 FIX ; IIV-CL
 0 FIX  ; IIV-V

$SIGMA 
 1 FIX 

$SIM (12345) (54321) ONLYSIMULATION
$TABLE  ID TIME AMT ADDL II DV MDV CMT WT ALB SEX ONEHEADER NOPRINT FILE=SIMFILENAME.csv
"

# 파일을 저장할 경로
save_path <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3"

# 1000부터 1107까지의 숫자로 변경하여 파일 저장
for (i in 1000:1107) {
  # 현재 숫자로 파일명과 파일 경로 설정
  csv_name <- paste0(i, ".csv")
  sim_name <- paste0("SIM", i)
  file_name <- paste0(save_path, "/", i, ".txt")
  
  # 기본 코드에서 파일명과 SIM 이름 변경
  modified_code <- gsub("FILENAME", i, base_code)
  modified_code <- gsub("SIMFILENAME", sim_name, modified_code)
  
  # 텍스트 파일로 저장
  writeLines(modified_code, file_name)
}
