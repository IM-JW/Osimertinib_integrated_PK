library(dplyr)
library(readr)

# 1단계: 'AUC.csv' 파일 읽기
auc_path <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/AUC/AUC/AUC.csv"
auc_data <- read_csv(auc_path)

# 2단계: 대상 폴더 내 파일 목록 가져오기
folder_path <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3"
files <- list.files(path = folder_path, full.names = TRUE)

# 3단계: 각 'SET' 값에 대해 반복 실행
for(set_val in auc_data$SET) {
  # 해당 'SET' 값과 일치하는 파일 찾기
  file_path <- grep(set_val, files, value = TRUE)
  if(length(file_path) > 0) {
    # 4단계: 일치하는 파일 읽기
    file_data <- read_csv(file_path[1]) # 여러 파일이 일치할 경우 첫 번째 파일 사용
    if(nrow(file_data) >= 2) {
      # 5단계: 'WT', 'ALB', 'SEX'의 두 번째 행 값 추출 및 업데이트
      auc_data <- auc_data %>%
        mutate(WT = ifelse(SET == set_val, file_data$WT[2], WT),
               ALB = ifelse(SET == set_val, file_data$ALB[2], ALB),
               SEX = ifelse(SET == set_val, file_data$SEX[2], SEX))
    }
  }
}

# 6단계: 변경된 데이터를 'AUC_NEW.csv'로 저장
write_csv(auc_data, file.path(auc_path, "AUC_NEW.csv"))
