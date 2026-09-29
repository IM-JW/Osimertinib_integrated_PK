install.packages("rlang")
install.packages("rlang", dependencies = TRUE)
library(rlang)
library(dplyr)
.rs.restartR()
library(dplyr)
install.packages("vctrs")
library(vctrs)
library(dplyr)




install.packages("dplyr")
library(dplyr)

# 작업 디렉토리 설정
setwd("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER3/DATA")

# CSV 파일 경로
csv_path <- "DATA_VER1.csv"

# CSV 파일 불러오기
data <- read.csv(csv_path)

# "TIME" 칼럼 값이 지정된 값들인 행만 추출
desired_times <- c(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96,120, 144, 168, 192, 216, 240, 264, 288, 312, 336, 360, 362, 364, 366, 368, 370, 372, 374, 376, 378, 380, 382, 384, 386, 388, 390, 392, 394, 396, 398, 400, 402, 404, 406, 408, 410, 412, 414, 416, 418, 420, 422, 424, 426, 428, 430, 432, 434, 436, 438, 440, 442, 444, 446, 448, 450, 452, 454, 456 )

data_filtered <- data %>% filter(TIME %in% desired_times)

# 결과를 다시 CSV 파일로 저장
write.csv(data_filtered, "DATA_VER2.csv", row.names = FALSE)

# 결과 출력
print("작업이 완료되었습니다.")
