## =========================
## Two-model PK Parameter Bootstrap Comparison (Internal Validation)
## - loads two bootstrap CSVs
## - summarizes, builds 95% CI
## - equivalence testing (TOST) on log- or raw-scale
## - violin/forest plots + report csv
## =========================

setwd("D:/MBMA/osimertinib/NONMEM/VER2/bs_run39")

suppressPackageStartupMessages({
 #install.packages('tidyverse')
 #install.packages('readr')
 #install.packages('TOSTER')  
  library(tidyverse)
  library(readr)
  library(TOSTER)   # TOSTtwo.raw / TOSTtwo.prop 등
})

## ------------------------------------------------------------
## 0) 사용자 설정: 파일 경로/스케일/마진
## ------------------------------------------------------------
file_modelA <- "bootstrap_results.csv"  # 80% split
file_modelB <- "bootstrap_results_EX.csv"  # 20% split

## (선택) 대상 파라미터 화이트리스트: 비워두면 자동 감지
param_keep <- c()   # 예: c("CL","V","KA","CLM","VM","FM","IIV_CL","SIG_PROP_PAR")

## 로그스케일로 등가성 테스트할 파라미터(양수 파라미터 권장)
## 비워두면 CL/V/KA/… 등 고정효과는 자동 추정(이름 단서 기반) + IIV/SIGMA는 raw로 처리
logscale_params_user <- c()  

## 등가성 마진(%): 고정효과 ±20%, 분산/오차 ±30% (필요 시 조정)
fe_margin_pct <- 0.20
varerr_margin_pct <- 0.30

## 다중비교 보정 방법 (p.adjust)
p_adj_method <- "holm"

## 결과물 파일 prefix
out_prefix <- "pk_bootstrap_compare"

## ------------------------------------------------------------
## 1) 로더: wide/long 자동 인식 + 정리
## ------------------------------------------------------------
read_boot <- function(path, model_label, param_keep = character()) {
  df <- readr::read_csv(path, show_col_types = FALSE)
  
  # long형 감지 (parameter/value)
  low <- tolower(names(df))
  is_long <- all(c("parameter","value") %in% low)
  
  if (is_long) {
    pcol <- names(df)[match("parameter", low)]
    vcol <- names(df)[match("value",     low)]
    out <- df %>%
      rename(Parameter = !!pcol, Value = !!vcol) %>%
      mutate(Model = model_label) %>%
      select(Model, Parameter, Value)
  } else {
    # wide형: 수치형 열 gather
    num_cols <- df %>% select(where(is.numeric)) %>% names()
    # 부트스트랩 반복 식별자 후보 제외
    id_like <- tolower(names(df)) %in% c("rep","replicate","seed","bootstrap","iter","id",".id")
    num_cols <- setdiff(num_cols, names(df)[id_like])
    out <- df %>%
      select(all_of(num_cols)) %>%
      pivot_longer(everything(), names_to = "Parameter", values_to = "Value") %>%
      mutate(Model = model_label) %>%
      select(Model, Parameter, Value)
  }
  
  out <- out %>% filter(is.finite(Value))
  if (length(param_keep) > 0) {
    out <- out %>% filter(Parameter %in% param_keep)
  }
  out
}

A <- read_boot(file_modelA, "ModelA_80", param_keep)
B <- read_boot(file_modelB, "ModelB_20", param_keep)
boot_raw <- bind_rows(A,B)

stopifnot(nrow(boot_raw) > 0)

## ------------------------------------------------------------
## 2) 파라미터 타입/스케일 자동 분류
##    - 이름 규칙으로 IIV/SIGMA/OMEGA 등 분산·오차를 구분
##    - 나머지(고정효과)는 log-scale 후보
## ------------------------------------------------------------
is_var_or_err <- function(p) {
  grepl("^IIV|^OMEGA|^SIG|^EPS|^RUV|_CV$|VAR$", p, ignore.case = TRUE)
}

boot_raw <- boot_raw %>%
  mutate(ParamType = if_else(is_var_or_err(Parameter), "VARERR", "FIXED"))

# 사용자 지정 로그스케일이 있으면 우선 적용
logscale_set <- unique(logscale_params_user)

# 자동 로그스케일 후보: FIXED 이면서 값이 모두 >0 인 파라미터
auto_log_candidates <- boot_raw %>%
  group_by(Parameter) %>%
  summarise(all_pos = all(Value > 0, na.rm=TRUE),
            ParamType = first(ParamType),
            .groups = "drop") %>%
  filter(ParamType=="FIXED", all_pos) %>% pull(Parameter)

logscale_final <- union(logscale_set, auto_log_candidates)

boot <- boot_raw %>%
  mutate(Scale = case_when(
    Parameter %in% logscale_final ~ "LOG",
    TRUE ~ "RAW"
  ),
  Value_tr = if_else(Scale=="LOG", log(Value), Value))

## ------------------------------------------------------------
## 3) 요약통계 + 95% percentile CI
## ------------------------------------------------------------
summ <- boot %>%
  group_by(Model, Parameter, ParamType, Scale) %>%
  summarise(
    n = sum(!is.na(Value_tr)),
    mean = mean(Value_tr, na.rm=TRUE),
    median = median(Value_tr, na.rm=TRUE),
    sd = sd(Value_tr, na.rm=TRUE),
    p2.5 = quantile(Value_tr, 0.025, na.rm=TRUE),
    p97.5 = quantile(Value_tr, 0.975, na.rm=TRUE),
    .groups = "drop"
  )

## ------------------------------------------------------------
## 4) 등가성(TOST) + 비모수 보조 검정
##    - 마진은 ModelA 평균 기준의 상대(%)
##    - LOG 스케일: 차이의 등가 마진 = log(1±pct)
##    - RAW 스케일: 차이의 등가 마진 = meanA * pct
## ------------------------------------------------------------
tost_by_param <- function(df_param){
  Avals <- df_param %>% filter(Model=="ModelA_80") %>% pull(Value_tr)
  Bvals <- df_param %>% filter(Model=="ModelB_20") %>% pull(Value_tr)
  Scale <- df_param$Scale[1]
  ParamType <- df_param$ParamType[1]
  Parameter <- df_param$Parameter[1]
  
  if (length(Avals) < 5 || length(Bvals) < 5)
    return(tibble(Parameter=Parameter, Scale=Scale, ParamType=ParamType,
                  margin_lower=NA, margin_upper=NA,
                  meanA=mean(Avals), meanB=mean(Bvals),
                  tost_p=max(NA_real_, NA_real_), decision="insufficient n"))
  
  mA <- mean(Avals, na.rm=TRUE)
  pct <- ifelse(ParamType=="FIXED", fe_margin_pct, varerr_margin_pct)
  
  if (Scale=="LOG") {
    # 등가 마진: log(1±pct)
    low_eqbound  <- log(1 - pct)
    high_eqbound <- log(1 + pct)
  } else {
    # RAW: 평균 기준 상대 %
    low_eqbound  <- -abs(mA * pct)
    high_eqbound <-  abs(mA * pct)
  }
  
  tr <- try(
    TOSTER::TOSTtwo.raw(m1=mean(Avals), m2=mean(Bvals),
                        sd1=sd(Avals), sd2=sd(Bvals),
                        n1=length(Avals), n2=length(Bvals),
                        low_eqbound=low_eqbound, high_eqbound=high_eqbound,
                        alpha=0.05, var.equal=FALSE),
    silent = TRUE
  )
  
  if (inherits(tr,"try-error")) {
    tibble(Parameter=Parameter, Scale=Scale, ParamType=ParamType,
           margin_lower=low_eqbound, margin_upper=high_eqbound,
           meanA=mA, meanB=mean(Bvals), tost_p=NA_real_, decision="error")
  } else {
    decision <- ifelse(tr$TOST_outcome=="equivalent","equivalent","not equivalent")
    tibble(Parameter=Parameter, Scale=Scale, ParamType=ParamType,
           margin_lower=low_eqbound, margin_upper=high_eqbound,
           meanA=mA, meanB=mean(Bvals),
           tost_p=max(tr$TOST_p1, tr$TOST_p2),
           decision=decision)
  }
}

tost_res <- boot %>%
  group_by(Parameter, ParamType, Scale) %>%
  group_modify(~tost_by_param(.x)) %>%
  ungroup() %>%
  mutate(tost_p_adj = p.adjust(tost_p, method = p_adj_method))

# 비모수 보조 검정 (분포차) — Wilcoxon rank-sum, 스케일 동일 데이터 사용
wilx <- boot %>%
  group_by(Parameter, ParamType, Scale) %>%
  group_modify(function(df, key){
    Avals <- df %>% filter(Model=="ModelA_80") %>% pull(Value_tr)
    Bvals <- df %>% filter(Model=="ModelB_20") %>% pull(Value_tr)
    if (length(Avals) < 2 || length(Bvals) < 2) {
      tibble(w_stat=NA_real_, w_p=NA_real_)
    } else {
      wt <- wilcox.test(Avals, Bvals, exact=FALSE)
      tibble(w_stat=unname(wt$statistic), w_p=wt$p.value)
    }
  }) %>% ungroup() %>%
  mutate(w_p_adj = p.adjust(w_p, method = p_adj_method))

## ------------------------------------------------------------
## 5) 레포트 테이블 결합 (원스케일 기준 보고)
##    - 원단위의 중앙값/CI도 제공 (transformed→back-transform)
## ------------------------------------------------------------
# back-transform helper
back_tr <- function(x, scale) ifelse(scale=="LOG", exp(x), x)

summ_back <- summ %>%
  mutate(
    median_bt = back_tr(median, Scale),
    p2.5_bt   = back_tr(p2.5,   Scale),
    p97.5_bt  = back_tr(p97.5,  Scale)
  ) %>%
  select(Model, Parameter, ParamType, Scale, n, median_bt, p2.5_bt, p97.5_bt)

wide_med <- summ_back %>%
  select(Model, Parameter, Scale, median_bt, p2.5_bt, p97.5_bt) %>%
  pivot_wider(names_from = Model,
              values_from = c(median_bt, p2.5_bt, p97.5_bt),
              names_sep = "__")

report <- wide_med %>%
  left_join(tost_res, by=c("Parameter","Scale")) %>%
  left_join(wilx,     by=c("Parameter","Scale","ParamType")) %>%
  arrange(ParamType, Parameter)

readr::write_csv(report, paste0(out_prefix, "_parameter_comparison_report.csv"))

## ------------------------------------------------------------
## 6) 시각화: 포리스트(95% CI), 바이올린(분포)
##    - 그림은 back-transformed 스케일(원단위)로 표현
## ------------------------------------------------------------
plot_forest <- summ_back %>%
  mutate(Parameter = factor(Parameter, levels = unique(Parameter))) %>%
  ggplot(aes(x = Parameter, y = median_bt, ymin = p2.5_bt, ymax = p97.5_bt, color = Model)) +
  geom_pointrange(position = position_dodge(width=0.6)) +
  coord_flip() +
  labs(title = "Bootstrap median & 95% CI (back-transformed)",
       y = "Estimate (original scale)", x = NULL) +
  theme_bw()

ggsave(paste0(out_prefix, "_forest.png"), plot_forest, width = 9, height = 6, dpi = 300)

# 바이올린은 변환 전(원단위)로 그리기 위해 원단위 값 만들기
boot_plot <- boot %>%
  mutate(Value_bt = if_else(Scale=="LOG", exp(Value_tr), Value_tr))

plot_violin <- boot_plot %>%
  ggplot(aes(x = Parameter, y = Value_bt, fill = Model)) +
  geom_violin(trim = FALSE, alpha = 0.5) +
  geom_boxplot(width = 0.18, position = position_dodge(width=0.9), outlier.size = 0.5) +
  facet_wrap(~Scale, scales="free_y") +
  coord_flip() +
  labs(title = "Bootstrap distributions by model (original scale)",
       y = "Bootstrap values", x = NULL) +
  theme_bw()

ggsave(paste0(out_prefix, "_violin.png"), plot_violin, width = 10, height = 7, dpi = 300)

## ------------------------------------------------------------
## 7) 콘솔 요약 출력
## ------------------------------------------------------------
cat("\n=== Parameter Equivalence Summary (per TOST) ===\n")
report %>%
  transmute(Parameter, Scale,
            median_ModelA_80,
            median_ModelB_20,
            tost_p_adj,
            decision,
            wilcoxon_p_adj = w_p_adj) %>%
  print(n=Inf)

cat("\nSaved:\n",
    paste0(out_prefix, "_parameter_comparison_report.csv"), "\n",
    paste0(out_prefix, "_forest.png"), "\n",
    paste0(out_prefix, "_violin.png"), "\n")
