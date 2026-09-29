
#################################################################################################
#### 이 코드가 정상작동 아래코드 사용하기  





library(readr)
library(dplyr)

input_path  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/SIMDV/TEST/RESULT"
output_path <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/SIMDV/TEST/RESULT/STEP1"

if (!dir.exists(output_path)) dir.create(output_path, recursive = TRUE)

file_list <- list.files(path = input_path, pattern = "\\.csv$", full.names = TRUE, ignore.case = TRUE)
stopifnot(length(file_list) > 0)

keep_cols <- c("ID","TIME","AMT","ADDL","II","DV","MDV","CMT","AGE","WT","ALB","AST","SEX","PRED")

for (file_name in file_list) {
  data <- read_csv(file_name, show_col_types = FALSE)
  
  # DV 후보 모두 찾기
  dv_idx <- which(grepl("^DV", names(data), ignore.case = TRUE))
  if (length(dv_idx) > 1) {
    # 첫 번째 DV만 남기고 나머지는 제거
    first_dv <- dv_idx[1]
    drop_idx <- dv_idx[-1]
    data <- data[, -drop_idx, drop = FALSE]
    names(data)[first_dv] <- "DV"  # 표준화
  } else if (length(dv_idx) == 1) {
    names(data)[dv_idx] <- "DV"
  } else {
    stop(paste("DV 컬럼이 없습니다:", basename(file_name)))
  }
  
  # AMT==80000이면 PRED=0 (없으면 생성)
  if (!"PRED" %in% names(data)) data$PRED <- NA_real_
  data <- mutate(data, PRED = ifelse(AMT == 80000, 0, PRED))
  
  # 필요한 열만 선택
  data_filtered <- dplyr::select(data, dplyr::any_of(keep_cols))
  
  output_file <- file.path(output_path, basename(file_name))
  write_csv(data_filtered, file = output_file)
}

cat("DV 첫 번째만 남겨 csv로 저장 완료 →", output_path, "\n")
