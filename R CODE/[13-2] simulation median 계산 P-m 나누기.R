library(readr)
library(dplyr)

input_dir  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/SIMDV/TEST/STEP2"
output_dir_P <- file.path(input_dir, "P")
output_dir_M <- file.path(input_dir, "M")

if (!dir.exists(output_dir_P)) dir.create(output_dir_P, recursive = TRUE)
if (!dir.exists(output_dir_M)) dir.create(output_dir_M, recursive = TRUE)

# STEP3 폴더 안의 CSV 파일 목록
file_list <- list.files(path = input_dir, pattern = "\\.csv$", full.names = TRUE)

for (f in file_list) {
  df <- read_csv(f, show_col_types = FALSE)
  
  # 파일 이름만 추출
  fname <- tools::file_path_sans_ext(basename(f))
  
  # CMT == 1 or 2 → P 버전
  df_P <- df %>% filter(CMT %in% c(1, 2))
  if (nrow(df_P) > 0) {
    out_file_P <- file.path(output_dir_P, paste0(fname, "_P.csv"))
    write_csv(df_P, out_file_P)
  }
  
  # CMT == 1 or 3 → M 버전
  df_M <- df %>% filter(CMT %in% c(1, 3))
  if (nrow(df_M) > 0) {
    out_file_M <- file.path(output_dir_M, paste0(fname, "_M.csv"))
    write_csv(df_M, out_file_M)
  }
}

cat("처리 완료 →\n P 폴더:", output_dir_P, "\n M 폴더:", output_dir_M, "\n")
