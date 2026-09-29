# 필요한 패키지
library(dplyr)
library(readr)

# ===== 경로 설정 =====
path_dv   <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/DV/M"
path_pred <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/PRED/RESULT/STEP2/M"
path_out  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER"

# ===== 데이터 불러오기 ('.'를 NA로 처리 권장) =====
dv_test   <- read_csv(file.path(path_dv,   "DV_TEST_M.csv"), na = ".")
dv_vali   <- read_csv(file.path(path_dv,   "DV_VALI_M.csv"), na = ".")
pred_test <- read_csv(file.path(path_pred, "PRED_TEST_SIM_M.csv"), na = ".")
pred_vali <- read_csv(file.path(path_pred, "PRED_VALI_SIM_M.csv"), na = ".")

# 숫자 변환 헬퍼
numify <- function(x) suppressWarnings(as.numeric(x))

for (nm in c("DV","PRED","TIME","ID")) {
  if (nm %in% names(dv_test))   dv_test[[nm]]   <- numify(dv_test[[nm]])
  if (nm %in% names(dv_vali))   dv_vali[[nm]]   <- numify(dv_vali[[nm]])
  if (nm %in% names(pred_test)) pred_test[[nm]] <- numify(pred_test[[nm]])
  if (nm %in% names(pred_vali)) pred_vali[[nm]] <- numify(pred_vali[[nm]])
}

# ===== 매칭 (ID, TIME 기준) =====
# A) TEST model → VALI data  : DV=VALI, PRED=TEST
cp_A <- dv_vali %>%
  inner_join(pred_test, by = c("ID","TIME"), suffix = c("_DV","_PRED")) %>%
  rename(DV = DV, PRED = PRED)

# B) VALI model → TEST data  : DV=TEST, PRED=VALI
cp_B <- dv_test %>%
  inner_join(pred_vali, by = c("ID","TIME"), suffix = c("_DV","_PRED")) %>%
  rename(DV = DV, PRED = PRED)

# ===== 지표 함수 (절대값 + %값) =====
metrics_with_pct <- function(df, dv_col = "DV", pred_col = "PRED") {
  df <- df %>% filter(is.finite(.data[[dv_col]]), is.finite(.data[[pred_col]]))
  dv   <- df[[dv_col]]
  pred <- df[[pred_col]]
  err  <- pred - dv
  
  rmse <- sqrt(mean(err^2, na.rm = TRUE))
  mae  <- mean(abs(err), na.rm = TRUE)
  bias <- mean(err, na.rm = TRUE)
  n    <- sum(is.finite(err))
  
  dv_median <- median(dv, na.rm = TRUE)
  
  # DV 중앙값 대비 백분율 (%)
  rRMSE <- if (is.finite(dv_median) && dv_median != 0) rmse / dv_median * 100 else NA_real_
  rMAE  <- if (is.finite(dv_median) && dv_median != 0) mae  / dv_median * 100 else NA_real_
  rBias <- if (is.finite(dv_median) && dv_median != 0) bias / dv_median * 100 else NA_real_
  
  tibble::tibble(
    DV_Median = dv_median,
    RMSE = rmse, MAE = mae, Bias = bias, N = n,
    rRMSE_pct = rRMSE, rMAE_pct = rMAE, rBias_pct = rBias
  )
}

res_A <- metrics_with_pct(cp_A) %>% mutate(Comparison = "TEST model → VALI data")
res_B <- metrics_with_pct(cp_B) %>% mutate(Comparison = "VALI model → TEST data")

# 결과 합치기 (열 순서 정리)
res <- bind_rows(res_A, res_B) %>%
  select(Comparison, DV_Median, RMSE, MAE, Bias, N, rRMSE_pct, rMAE_pct, rBias_pct)

print(res)

# ===== CSV 저장 =====
write.csv(res, file.path(path_out, "CrossPrediction_%_M.csv"), row.names = FALSE)
cat("\nSaved to: ", file.path(path_out, "CrossPrediction_%_M.csv"), "\n")
