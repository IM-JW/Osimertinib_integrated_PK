# 처리할 폴더 경로
folder_path <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/VALI/SIM/RESULT"

# 폴더 내 모든 CSV 파일 목록 가져오기
csv_files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)

# 각 CSV 파일 처리
for (file in csv_files) {
  
  # CSV 파일 읽기
  df <- read.csv(file, stringsAsFactors = FALSE)
  
  # TIME이 0인 행의 DV 값을 0으로 변경
  df$DV[df$TIME == 0] <- 0
  
  # 새로운 파일명 생성 (예: original → original_modified.csv)
  new_file <- sub("\\.csv$", ".csv", file)
  
  # 변경된 데이터 저장
  write.csv(df, new_file, row.names = FALSE)
  
  cat("변경 완료:", new_file, "\n")
}

cat("모든 CSV 파일 처리가 완료되었습니다.\n")
