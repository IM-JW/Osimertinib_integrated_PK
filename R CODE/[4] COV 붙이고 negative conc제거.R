# 필요한 라이브러리 로드
library(dplyr)
setwd("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/VER12/")
getwd ()

# 두 개의 CSV 파일 불러오기
csv1 <- read.csv("TIME_24.csv")
csv2 <- read.csv("cov_sex.csv")

# csv1을 기준으로 csv2와 조인하여 새로운 데이터프레임 생성
merged_data <- merge(csv1, csv2, by = "ID", all.x = TRUE)

# 새로운 CSV 파일로 저장
write.csv(merged_data, "TIME_24_VER1.csv", row.names = FALSE)

# 결과 확인
print("새로운 파일이 성공적으로 저장되었습니다.")


### negative conc 제거

# 필요한 라이브러리 로드
library(dplyr)


# CSV 파일 경로 지정
csv_path <- "SUM_cov.csv"

# CSV 파일 불러오기
data <- read.csv(csv_path)

# "CM" 및 "CP" 열에서 음수 값을 가진 행 찾기
negative_rows <- data %>% filter(CM < 0 | CP < 0)

# 음수 값을 가진 행의 ID 값 추출
ids_to_remove <- negative_rows$ID

# 해당 ID를 가진 모든 행 삭제
data <- data %>% filter(!(ID %in% ids_to_remove))

# 결과를 다시 CSV 파일로 저장
write.csv(data, "SUM_cov_ver1.csv", row.names = FALSE)

# 결과 출력
print("작업이 완료되었습니다.")





###삭제행
csv_path <- "SUM_cov.csv"

# CSV 파일 불러오기
data <- read.csv(csv_path) 
negative_rows <- data %>% filter(CM < 0 | CP < 0)

# 선택된 행을 새로운 CSV 파일로 저장
write.csv(negative_rows, "SUM_cov_negative.csv", row.names = FALSE)

# 결과 출력
print("음수값을 가진 행이 저장되었습니다.")




