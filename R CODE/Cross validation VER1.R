# 필요한 패키지
library(dplyr)
library(readr)

# 경로 설정
path_dv   <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/DV/M"
path_pred <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/PRED/RESULT/STEP2/M"
path_out  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER"

# 데이터 불러오기
dv_test   <- read_csv(file.path(path_dv, "DV_TEST_M.csv"))
dv_vali   <- read_csv(file.path(path_dv, "DV_VALI_M.csv"))
pred_test <- read_csv(file.path(path_pred, "PRED_TEST_SIM_M.csv"))
pred_vali <- read_csv(file.path(path_pred, "PRED_VALI_SIM_M.csv"))

# 숫자형 변환 함수
numify <- function(x) suppressWarnings(as.numeric(x))
for (nm in c("DV","PRED","TIME","ID")) {
  if (nm %in% names(dv_test))   dv_test[[nm]]   <- numify(dv_test[[nm]])
  if (nm %in% names(dv_vali))   dv_vali[[nm]]   <- numify(dv_vali[[nm]])
  if (nm %in% names(pred_test)) pred_test[[nm]] <- numify(pred_test[[nm]])
  if (nm %in% names(pred_vali)) pred_vali[[nm]] <- numify(pred_vali[[nm]])
}

# 매칭 (ID, TIME 기준)
cp_A <- dv_vali %>% inner_join(pred_test, by=c("ID","TIME"), suffix=c("_DV","_PRED"))
cp_B <- dv_test %>% inner_join(pred_vali, by=c("ID","TIME"), suffix=c("_DV","_PRED"))

# 지표 함수
metrics <- function(df, dv_col="DV", pred_col="PRED"){
  dv   <- numify(df[[dv_col]])
  pred <- numify(df[[pred_col]])
  err  <- pred - dv
  rmse <- sqrt(mean(err^2, na.rm=TRUE))
  mae  <- mean(abs(err), na.rm=TRUE)
  bias <- mean(err, na.rm=TRUE)
  c(RMSE=rmse, MAE=mae, Bias=bias, N=sum(is.finite(err)))
}

res_A <- metrics(cp_A, dv_col="DV", pred_col="PRED")
res_B <- metrics(cp_B, dv_col="DV", pred_col="PRED")

res <- tibble::tibble(
  Comparison = c("TEST model → VALI data", "VALI model → TEST data"),
  RMSE = c(res_A["RMSE"], res_B["RMSE"]),
  MAE  = c(res_A["MAE"],  res_B["MAE"]),
  Bias = c(res_A["Bias"], res_B["Bias"]),
  N    = c(res_A["N"],    res_B["N"])
)

print(res)

# 🔽 CSV 저장
write.csv(res, file.path(path_out, "CrossPrediction_M.csv"), row.names = FALSE)
