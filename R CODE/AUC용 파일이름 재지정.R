# 파일 처리를 위한 폴더 경로 설정
folder_path <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/Processed/"

# 폴더 내의 모든 파일 목록을 가져옴
files <- list.files(path = folder_path, pattern = "^processed_SIM[0-9]+", full.names = TRUE)

# 파일 이름 변경을 위한 반복문 실행
for (file in files) {
  # 기존 파일 경로에서 파일 이름만 추출 (확장자 포함)
  file_name <- basename(file)
  
  # 파일 이름에서 숫자 부분만 추출
  id <- gsub("processed_SIM", "", file_name)
  
  # 새 파일 이름 생성 (확장자를 유지하기 위해 기존 확장자 추가 필요)
  new_file_name <- paste0(folder_path, id)
  
  # 파일 이름 변경
  file.rename(from = file, to = new_file_name)
}

# 작업 완료 메시지
cat("파일 이름 변경이 완료되었습니다.\n")
