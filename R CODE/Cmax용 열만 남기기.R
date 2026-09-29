# 필요한 패키지 불러오기
library(dplyr)
library(readr)

# CSV 파일이 있는 폴더 위치 설정
input_folder <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/Cmax"

# 결과 파일 저장할 폴더 위치 설정
output_folder <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/Cmax/NEW_Cmax"

# input_folder에서 .csv 파일 목록 읽기
file_list <- list.files(path = input_folder, pattern = "\\.csv$", full.names = TRUE)

# 파일별로 처리
for (i in seq_along(file_list)) {
  # 데이터 로드
  file_path <- file_list[i]
  data <- read_csv(file_path)
  
  # 'ID' 칼럼 추가
  data$ID <- i
  
  # 'TIME' 기준으로 'DV'의 평균 계산 (WT, ALB, SEX 칼럼은 변경 없음)
  time_dv_average <- data %>%
    group_by(TIME, ID, WT, ALB, SEX) %>%
    summarise(Concentration = mean(DV, na.rm = TRUE), .groups = 'drop') %>%
    mutate(Concentration = ifelse(TIME == 0, 0, Concentration))
  
  # 결과 파일명 생성 (원본 파일명에 "_avg" 추가)
  output_file <- paste0(output_folder, "/", basename(file_path), "_avg.csv")
  
  # 계산된 평균을 CSV 파일로 저장
  write_csv(time_dv_average, output_file)
}
