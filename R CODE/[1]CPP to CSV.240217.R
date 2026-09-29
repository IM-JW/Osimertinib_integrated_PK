library(mrgsolve)

# 작업할 디렉토리로 이동
setwd("/Volumes/Untitled/MBMA/MBMA/REF5/CPP/CPP2")

# cpp 파일 목록 가져오기
cpp_files <- list.files(pattern = "\\.cpp$")

# 반복하여 작업 수행 및 CSV 파일로 저장
for (cpp_file in cpp_files) {
  # 1. cpp 파일 불러오기
  mod <- mread(cpp_file, recover = TRUE)
  
  # 2. 데이터 설정
  data <- expand.ev(ID = 1:1, amt = c(80000), ii = 24, addl = 18)
  
  # 3. 모델 입력
  mod %>%
    data_set(data) %>%
    Req(CP) %>%
    mrgsim(start = 0, end = 456, delta = 2, output = "df") -> result
  
  # 4. CSV 파일로 저장
  csv_file <- paste0(sub("\\.cpp$", "", cpp_file), ".csv")
  write.csv(result, csv_file)
}







