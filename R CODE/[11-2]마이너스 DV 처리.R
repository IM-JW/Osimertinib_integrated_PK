# 필요한 패키지 로드
library(dplyr)

# --- 경로 설정 ---

# 1. 파일을 불러올 폴더 경로 (입력 경로)
input_folder <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/SIMDV/VALI/RESULT/STEP2"

# 2. 수정된 파일을 저장할 폴더 경로 (출력 경로)
# 예시: 원본 폴더 이름 뒤에 "_modified"를 붙였습니다.
output_folder <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/SIMDV/VALI/RESULT/STEP3"


# --- 파일 처리 ---

# 출력 폴더가 존재하지 않으면 자동으로 생성합니다.
if (!dir.exists(output_folder)) {
  dir.create(output_folder, recursive = TRUE)
  print(paste("생성된 출력 폴더:", output_folder))
}

# 입력 폴더 내 모든 CSV 파일 목록을 가져옵니다.
csv_files <- list.files(path = input_folder, pattern = "\\.csv$", full.names = TRUE)

# 각 파일을 순서대로 처리합니다.
for (file in csv_files) {
  # CSV 파일을 읽어옵니다.
  df <- read.csv(file, stringsAsFactors = FALSE)
  
  # 요청하신 조건에 따라 DV와 MDV 값을 변경합니다.
  # 1. AMT가 80000이면 DV를 "."으로 변경
  # 2. (AMT가 80000이 아니고) TIME이 0이면 DV를 "0"으로 변경
  # 3. DV가 "."이 되면 MDV를 "1"로 변경
  df <- df %>%
    mutate(
      DV = case_when(
        AMT == 80000 ~ ".",
        TIME == 0 ~ "0",
        TRUE ~ as.character(DV) # 위의 두 조건에 해당하지 않으면 원래 DV 값 유지
      ),
      MDV = ifelse(DV == ".", "1", MDV)
    )
  
  # 저장할 파일의 전체 경로를 생성합니다.
  # basename(file) 함수는 전체 경로에서 파일 이름만 추출합니다. (예: "data.csv")
  output_file_path <- file.path(output_folder, basename(file))
  
  # 수정된 데이터를 새로운 경로에 저장합니다.
  write.csv(df, file = output_file_path, row.names = FALSE, quote = FALSE)
}

# 작업 완료 메시지를 출력합니다.
print("모든 파일 처리가 완료되었습니다.")
print(paste("수정된 파일은 다음 경로에 저장되었습니다:", output_folder))