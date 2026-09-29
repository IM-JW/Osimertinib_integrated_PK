# 필요한 패키지
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
library(tidyverse)

# 범위
file_numbers <- 1000:1539

# 경로
in_dir  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/VALI/RESULT/STEP3/M"
out_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/VALI/AUC/M"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

# 개별 파일 처리: TIME 384~408 구간 AUC(ID별) 계산 + AGE/WT/ALB/SEX 포함
for (num in file_numbers) {
  in_file  <- file.path(in_dir,  sprintf("SIM%d_M.csv", num))
  out_file <- file.path(out_dir, sprintf("SIM%d_M.csv", num))
  if (!file.exists(in_file)) { message("파일 없음: ", in_file); next }
  
  dat <- read_csv(in_file, show_col_types = FALSE)
  
  # 값 컬럼 자동 선택: DV 우선, 없으면 PRED
  val_col <- if ("DV" %in% names(dat)) "DV" else if ("PRED" %in% names(dat)) "PRED" else NA_character_
  if (is.na(val_col)) stop(sprintf("DV/PRED 컬럼이 없습니다: %s", in_file))
  
  need_cols <- c("ID","TIME", val_col,"WT","ALB","AST","SEX")
  if (!all(need_cols %in% names(dat))) {
    stop(sprintf("필수 컬럼 누락(%s): %s", paste(setdiff(need_cols, names(dat)), collapse=", "), in_file))
  }
  
  auc_dat <- dat %>%
    filter(TIME >= 384, TIME <= 408) %>%
    group_by(ID) %>%
    arrange(TIME, .by_group = TRUE) %>%
    summarise(
      AUC = sum(
        (lag(.data[[val_col]], default = first(.data[[val_col]])) + .data[[val_col]]) / 2 *
          (TIME - lag(TIME, default = first(TIME)))
      ),
      WT  = first(WT),
      ALB = first(ALB),
      AST = first(AST),
      SEX = first(SEX),
      .groups = "drop"
    )
  
  write_csv(auc_dat, out_file)
}

# 병합: SIM숫자_P.csv만
file_list <- list.files(path = out_dir, pattern = "^SIM\\d+_M\\.csv$", full.names = TRUE)

combined_data <- file_list %>%
  map_dfr(function(f) {
    set_number <- stringr::str_extract(basename(f), "\\d+")
    read_csv(f, show_col_types = FALSE) %>% mutate(SET = set_number)
  })

write_csv(combined_data, file.path(out_dir, "AUC_M.csv"))

# SET별 평균 AUC (AGE/WT/ALB/SEX는 참조용으로 combined에 보존)
#summary_data <- combined_data %>%
 # group_by(SET) %>%
  # summarise(mean_AUC = mean(AUC, na.rm = TRUE), .groups = "drop")

# write_csv(summary_data, file.path(out_dir, "AUC_P_MEAN.csv"))
