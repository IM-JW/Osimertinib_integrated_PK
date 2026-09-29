# 데이터 불러오기
data <- read.csv("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/TEST/TEST_V1.csv")

# AGE_C 변수 생성
data$AGE_C <- with(data, ifelse(AGE >= 18 & AGE < 60, 1,
                                ifelse(AGE >= 60, 0, NA)))

# AGE 변수 삭제
data$AGE <- NULL

# AGE_C를 AGE로 이름 변경
names(data)[names(data) == "AGE_C"] <- "AGE"

# 새 파일로 저장
write.csv(data, "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/TEST/TEST_V2.csv", row.names = FALSE)
