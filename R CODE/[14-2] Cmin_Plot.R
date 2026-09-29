# 필요한 패키지 로드
library(dplyr)

# 폴더 경로 지정
folder_path <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/Cmax/average_Cmax"

# 파일 리스트 가져오기
file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)

# 초기화
all_data <- data.frame()
set_value <- 1000

# 각 파일 처리
for (file in file_list) {
  # 파일 읽기
  data <- read.csv(file)
  
  # TIME 칼럼 값이 384 이상인 행들 중 'Concentration' 값이 가장 작은 행 추출
  filtered_data <- data %>% filter(TIME > 384) %>% slice(which.min(Concentration))
  
  # SET 칼럼 추가 및 값 설정
  filtered_data$SET <- set_value
  set_value <- set_value + 1
  
  # 모든 데이터 결합
  all_data <- bind_rows(all_data, filtered_data)
}

# 결과 파일 저장
write.csv(all_data, file = file.path(folder_path, "Cmin_SUM.csv"), row.names = FALSE)
