# 필요한 패키지
library(dplyr)

# 입력/출력 경로
input_path  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/TEST/RESULT/STEP3/P"
output_path <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/TEST/MAX"

# 출력 폴더 생성
if (!dir.exists(output_path)) dir.create(output_path, recursive = TRUE)

# 파일 리스트
file_list <- list.files(path = input_path, pattern = "\\.csv$", full.names = TRUE)

# 초기화
all_data  <- data.frame()
set_value <- 1000

# 처리
for (file in file_list) {
  dat <- read.csv(file, check.names = FALSE)
  names(dat) <- tolower(names(dat))  # 컬럼명 소문자 통일
  
  if (!all(c("time", "pred") %in% names(dat))) {
    stop(paste("필수 칼럼 누락:", file))
  }
  
  filtered <- dat %>% 
    filter(time >= 384, !is.na(pred))
  
  if (nrow(filtered) == 0) next
  
  top_row <- filtered %>% 
    slice_max(order_by = pred, n = 1, with_ties = FALSE)  # pred 기준 최대 1행
  
  top_row$SET <- set_value
  set_value <- set_value + 1
  
  all_data <- bind_rows(all_data, top_row)
}

# 결과 저장 (입력 경로가 아닌 별도 경로)
write.csv(all_data, file = file.path(output_path, "CMAX_P.csv"), row.names = FALSE)

cat("저장 완료:", file.path(output_path, "CMAX_P.csv"), "\n")
