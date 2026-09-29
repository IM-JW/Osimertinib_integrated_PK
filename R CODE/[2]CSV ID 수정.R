library(data.table)

# 작업할 디렉토리로 이동
setwd("/Volumes/Untitled/MBMA/MBMA/DATA")

# CSV 파일 목록 가져오기
csv_files <- list.files(pattern = "\\.csv$")

# 반복하여 작업 수행 및 ID 열 이름 대체
for (csv_file in csv_files) {
  # 파일명에서 숫자 추출
  file_number <- gsub("output_(\\d+)\\.csv", "\\1", csv_file)
  
  # CSV 파일 불러오기
  data <- fread(csv_file)
  
  # 'ID' 열 값 대체
  data[, ID := as.integer(file_number)]
  
  # 대체된 데이터를 새로운 파일로 저장
  new_csv_file <- paste0("newcsv_", file_number, ".csv")
  write.csv(data, file = new_csv_file, row.names = FALSE)
}
