library(readr)

# 원본 파일이 위치한 폴더 경로
input_path <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/Processed/"

# 처리된 파일을 저장할 폴더 경로
output_path <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/Cmax/"

# 입력 폴더 내의 모든 CSV 파일 목록을 가져옴
file_list <- list.files(path = input_path, pattern = "\\.csv$", full.names = TRUE)

# 각 파일에 대해 반복
for (file_name in file_list) {
  # CSV 파일 읽기
  data <- read_csv(file_name)
  
  # 'ID', 'TIME', 'DV' 열만 남기고 다른 열 삭제
  data_filtered <- data[, c("ID", "TIME", "DV", "WT", "ALB", "SEX")]
  
  # 출력 파일 이름 생성 (원본 파일 이름 사용)
  output_file_name <- basename(file_name)
  
  # 처리된 파일 저장
  write_csv(data_filtered, file = paste0(output_path, output_file_name))
}

# 작업 완료 메시지
cat("모든 파일이 처리되어 저장되었습니다.")
