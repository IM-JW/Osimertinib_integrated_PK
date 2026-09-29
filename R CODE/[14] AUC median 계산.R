# 필요한 패키지를 로드하거나 설치합니다.
if (!require("dplyr")) install.packages("dplyr")
if (!require("readr")) install.packages("readr")

library(dplyr)
library(readr)

# CSV 파일이 위치한 디렉토리 경로를 설정합니다.
directory_path <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/AUC/AUC/"

# 지정된 디렉토리에 있는 모든 CSV 파일의 목록을 가져옵니다.
file_list <- list.files(path = directory_path, pattern = "*.csv", full.names = TRUE)

# 각 파일에 대해 반복하면서 'AUC' 칼럼의 중앙값을 계산합니다.
results <- data.frame(NUMBER = integer(), AUC = numeric())

for (i in 1:length(file_list)) {
  # CSV 파일을 읽습니다.
  data <- read_csv(file_list[i])
  
  # 'AUC' 칼럼의 중앙값을 계산합니다.
  median_auc <- median(data$AUC, na.rm = TRUE)
  
  # 결과를 'results' 데이터 프레임에 추가합니다.
  results <- rbind(results, data.frame(NUMBER = i, AUC = median_auc))
}

# 결과를 새로운 CSV 파일로 저장합니다.
write_csv(results, path = paste0(directory_path, "AUC_medians_summary.csv"))

# 작업 완료 메시지를 출력합니다.
cat("AUC 중앙값 계산 및 저장이 완료되었습니다.\n결과 파일 위치: ", paste0(directory_path, "AUC_medians_summary.csv"))
