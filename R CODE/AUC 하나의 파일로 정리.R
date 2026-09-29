library(readr)
library(dplyr)
library(stringr)

# AUC 결과 파일들이 위치한 디렉토리
input_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/VALIDATION/SIM/AUC/AUC"

# 결과 저장용 리스트
result_list <- list()

# 모든 csv 파일 불러오기
file_list <- list.files(input_dir, pattern = "^SIM[0-9]+\\.csv$", full.names = TRUE)

for (file_path in file_list) {
  # 파일 불러오기
  df <- read_csv(file_path, show_col_types = FALSE)
  
  # CP와 CM 평균 계산
  cp_mean <- mean(df$CP, na.rm = TRUE)
  cm_mean <- mean(df$CM, na.rm = TRUE)
  
  # SET 번호 추출 (예: SIM123.csv → 123)
  file_name <- basename(file_path)
  set_number <- as.numeric(str_extract(file_name, "\\d+"))
  
  # 인구통계 정보 (ID 별로 동일하다고 가정하고 첫 번째 값 사용)
  age <- df$AGE[1]
  wt  <- df$WT[1]
  alb <- df$ALB[1]
  sex <- df$SEX[1]
  
  # 하나의 row 생성
  row <- tibble(
    SET = set_number,
    CP = cp_mean,
    CM = cm_mean,
    AGE = age,
    WT = wt,
    ALB = alb,
    SEX = sex
  )
  
  # 결과 리스트에 추가
  result_list[[length(result_list) + 1]] <- row
}

# 리스트를 하나의 데이터프레임으로 병합
final_df <- bind_rows(result_list)

# 결과 저장
output_path <- file.path(input_dir, "AUC.csv")
write_csv(final_df, output_path)

cat("✅ AUC.csv 저장 완료:", output_path, "\n")
