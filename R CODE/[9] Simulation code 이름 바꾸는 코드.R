# 초기 파일 경로 설정
base_path <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER2"
initial_file_name <- "1000.txt" # 초기 파일 이름 (예시에 따라 수정 가능)

# 첫 번째 파일 불러오기
initial_file_path <- file.path(base_path, initial_file_name)
template <- readLines(initial_file_path)

# 문자열로 변환 (후처리를 위해)
template_text <- paste(template, collapse="\n")

# 1001부터 1079까지 반복
for(i in 1001:1079) {
  # 데이터 파일 이름과 시뮬레이션 파일 이름 치환
  modified_text <- gsub("1000.csv", sprintf("%d.csv", i), template_text)
  modified_text <- gsub("SIM1000", sprintf("SIM%d", i), modified_text)
  
  # 저장할 파일 이름 설정
  output_file_name <- sprintf("%d.txt", i)
  output_file_path <- file.path(base_path, output_file_name)
  
  # 수정된 텍스트를 파일로 저장
  writeLines(modified_text, output_file_path)
}
