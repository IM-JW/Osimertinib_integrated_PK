# 필요한 패키지
library(dplyr)
library(readr)
library(stringr)

# 경로 설정
input_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM/CONC"
output_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM/CONC/MAX"

# AUC 계산 함수
calc_auc <- function(df) {
  df <- df %>% filter(TIME >= 384, TIME <= 408)
  df %>%
    group_by(ID) %>%
    summarise(AUC = sum((lag(DV, default = first(DV)) + DV) / 2 * (TIME - lag(TIME, default = first(TIME)))))
}

# 폴더 내 모든 CSV 파일 이름 가져오기
file_list <- list.files(input_dir, pattern = "\\.csv$", full.names = TRUE)

# 각 파일에 대해 반복
for (file_path in file_list) {
  # 파일 이름만 추출
  file_name <- basename(file_path)
  base_name <- str_remove(file_name, "\\.csv$")
  
  # 데이터 불러오기
  df <- read_csv(file_path, show_col_types = FALSE)
  
  # DV 열의 타입 확인 및 변환
  if (!is.numeric(df$DV)) {
    cat(sprintf("[Info] '%s'에서 DV 타입(%s) → numeric으로 변환 시도\n", file_name, typeof(df$DV)))
    df$DV <- as.numeric(df$DV)
    
    if (any(is.na(df$DV))) {
      cat(sprintf("[Warning] '%s'의 DV 열 변환 중 NA 생성: 문자형 포함 가능성 있음\n", file_name))
    }
  }
  
  # CP와 CM 각각 계산
  cp_data <- df %>% filter(CMT %in% c(1, 2)) %>% calc_auc() %>% rename(CP = AUC)
  cm_data <- df %>% filter(CMT %in% c(1, 3)) %>% calc_auc() %>% rename(CM = AUC)
  
  # 인구통계 정보 유지
  demo <- df %>% select(ID, AGE, WT, ALB, SEX) %>% distinct()
  
  # 최종 병합
  result_df <- demo %>%
    left_join(cp_data, by = "ID") %>%
    left_join(cm_data, by = "ID")
  
  # 저장
  output_file <- file.path(output_dir, paste0(base_name, ".csv"))
  write_csv(result_df, output_file)
}
