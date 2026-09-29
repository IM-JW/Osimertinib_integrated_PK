library(dplyr)
library(readr)

# 경로 설정
input_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM/CONC"
output_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM/CONC/MIN"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# 파일 목록
files <- list.files(input_dir, pattern = "\\.csv$", full.names = TRUE)
files <- files[file.info(files)$isdir == FALSE]

# 안전한 읽기 함수
safe_read <- function(f) {
  df <- suppressWarnings(read_csv(f, show_col_types = FALSE))
  df %>%
    mutate(
      DV = as.numeric(DV),
      TIME = as.numeric(TIME),
      AGE = as.numeric(AGE),
      WT = as.numeric(WT),
      ALB = as.numeric(ALB),
      CMT = as.integer(CMT),
      ID = as.integer(ID)
    )
}

# ✅ CP.csv 생성 (TIME 370~450 사이)
cp_data <- lapply(files, function(f) {
  df <- safe_read(f)
  df %>%
    filter(CMT %in% c(1, 2), TIME >= 370, TIME <= 450) %>%
    group_by(ID) %>%
    slice_min(DV, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    select(ID, DV, TIME, CMT, AGE, WT, ALB, SEX, everything())
}) %>% bind_rows()

write_csv(cp_data, file.path(output_dir, "CP.csv"))
cat("✅ CP.csv 저장 완료\n")

# ✅ CM.csv 생성 (TIME 370~450 사이)
cm_data <- lapply(files, function(f) {
  df <- safe_read(f)
  df %>%
    filter(CMT %in% c(1, 3), TIME >= 370, TIME <= 450) %>%
    group_by(ID) %>%
    slice_min(DV, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    select(ID, DV, TIME, CMT, AGE, WT, ALB, SEX, everything())
}) %>% bind_rows()

write_csv(cm_data, file.path(output_dir, "CM.csv"))
cat("✅ CM.csv 저장 완료\n")

# ✅ CP_A.csv: 동일한 AGE, WT, ALB, SEX 그룹별 평균 DV
cp_avg <- cp_data %>%
  group_by(AGE, WT, ALB, SEX) %>%
  summarise(DV = mean(DV, na.rm = TRUE), .groups = "drop") %>%
  mutate(ID = row_number()) %>%
  select(ID, DV, AGE, WT, ALB, SEX)

write_csv(cp_avg, file.path(output_dir, "CP_A.csv"))
cat("✅ CP_A.csv 저장 완료\n")

# ✅ CM_A.csv: 동일한 AGE, WT, ALB, SEX 그룹별 평균 DV
cm_avg <- cm_data %>%
  group_by(AGE, WT, ALB, SEX) %>%
  summarise(DV = mean(DV, na.rm = TRUE), .groups = "drop") %>%
  mutate(ID = row_number()) %>%
  select(ID, DV, AGE, WT, ALB, SEX)

write_csv(cm_avg, file.path(output_dir, "CM_A.csv"))
cat("✅ CM_A.csv 저장 완료\n")
