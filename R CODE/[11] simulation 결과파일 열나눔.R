library(readr)
library(dplyr)
#install.packages("tidyr")
library(tidyr)
#install.packages("writexl")
library(writexl)


# 파일을 불러올 기본 경로와 저장할 경로 설정
base_path <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/SIMDV/TEST/TEST"
processed_path <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/SIMDV/TEST/RESULT"

# SIM1000부터 SIM1079까지의 파일명 생성 및 처리
for (i in 1000:1000) {
  file_name <- paste0("SIM", i, ".csv") # 생성된 파일 이름
  file_path <- file.path(base_path, file_name) # 완전한 파일 경로
  
  # 파일 존재 여부 확인
  if (file.exists(file_path)) {
    # CSV 파일 불러오기 (공백이 구분자인 경우, 첫 번째와 두 번째 행을 건너뛰기)
    data <- read_csv(file_path, col_names = FALSE, skip = 2)
    
    # 열 이름 설정
    colnames(data) <- c("ID", "TIME", "AMT", "ADDL", "II", "DV", "MDV", "CMT", "WT", "ALB","AST","SEX","DV", "PRED", "RES", "WRES")
    
    # 처리된 데이터를 지정된 'Processed' 폴더에 저장
    processed_file_name <- paste0("", file_name) # 처리된 파일 이름 생성
    processed_file_path <- file.path(processed_path, processed_file_name) # 처리된 파일의 완전한 경로
    write_csv(data, processed_file_path)
  } else {
    cat("File does not exist:", file_path, "\n")
  }
}
