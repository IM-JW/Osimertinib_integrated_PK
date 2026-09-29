library(dplyr)
library(readr)

# 경로 설정
input_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM/CONC"
output_dir <-"C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM/CONC/MAX"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# 파일 목록
files <- list.files(input_dir, pattern = "\\.csv$", full.names = TRUE)
files <- files[file.info(files)$isdir == FALSE]

# 안전하게 불러오기 함수
safe_read <- function(f) {
  df <- suppressWarnings(read_csv(f, show_col_types = FALSE))
  df %>%
    mutate(
      ID = as.integer(ID),
      CMT = as.integer(CMT),
      TIME = as.numeric(TIME),
      DV = as.numeric(DV),
      AGE = as.numeric(AGE),
      WT = as.numeric(WT),
      ALB = as.numeric(ALB),
      SEX = as.character(SEX)
    )
}

# ✅ CP.csv: CMT 1 or 2, TIME 380~450, 각 ID별 DV 최대
cp_data <- lapply(files, function(f) {
  safe_read(f) %>%
    filter(CMT %in% c(1, 2), TIME >= 380, TIME <= 450) %>%
    group_by(ID) %>%
    slice_max(DV, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    select(ID, DV, TIME, CMT, AGE, WT, ALB, SEX, everything())
}) %>% bind_rows()

cp_path <- file.path(output_dir, "CP.csv")
write_csv(cp_data, cp_path)
cat("✅ CP.csv 저장 완료\n")

# ✅ CM.csv: CMT 1 or 3, TIME 380~450, 각 ID별 DV 최대
cm_data <- lapply(files, function(f) {
  safe_read(f) %>%
    filter(CMT %in% c(1, 3), TIME >= 380, TIME <= 450) %>%
    group_by(ID) %>%
    slice_max(DV, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    select(ID, DV, TIME, CMT, AGE, WT, ALB, SEX, everything())
}) %>% bind_rows()

cm_path <- file.path(output_dir, "CM.csv")
write_csv(cm_data, cm_path)
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
