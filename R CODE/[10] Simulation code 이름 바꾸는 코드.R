# 초기 파일 경로 설정
base_path <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/SIMDV/TEST/TEST"
initial_file_name <- "1000.txt" # 초기 파일 이름 (예시에 따라 수정 가능)

# 첫 번째 파일 불러오기
initial_file_path <- file.path(base_path, initial_file_name)
template <- readLines(initial_file_path)

# 문자열로 변환 (후처리를 위해)
template_text <- paste(template, collapse="\n")

# 1001부터 1079까지 반복
for(i in 1000:1999) {
  # 데이터 파일 이름과 시뮬레이션 파일 이름 치환
  modified_text <- gsub("1000.csv", sprintf("%d.csv", i), template_text)
  modified_text <- gsub("SIM1000.csv", sprintf("SIM%d.csv", i), modified_text) # 'SIM숫자'를 'SIM숫자.csv'로 변경
  
  # 저장할 파일 이름 설정 (확장자를 .csv로 변경)
  output_file_name <- sprintf("%d.txt", i) # 파일 이름 형식 변경
  output_file_path <- file.path(base_path, output_file_name)
  
  # 수정된 텍스트를 파일로 저장
  writeLines(modified_text, output_file_path)
}
