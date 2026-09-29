# 필요한 패키지 로드
library(readr)
library(dplyr)

# 대상 디렉토리 설정
path <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/TEST/cate3/"

# 디렉토리 내 모든 CSV 파일 목록 가져오기
file_list <- list.files(path, pattern = "\\.csv$", full.names = TRUE)

# 파일 하나씩 처리
for (file in file_list) {
  # 파일 읽기 (모든 열을 character로 읽음 → 일반 서식 유지 목적)
  df <- read_csv(file, col_types = cols(.default = col_character()))
  
  # 다시 저장 (덮어쓰기)
  write_csv(df, file)
}
